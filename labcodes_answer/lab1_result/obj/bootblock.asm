
obj/bootblock.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:

# start address should be 0:7c00, in real mode, the beginning address of the running bootloader
.globl start
start:
.code16                                             # Assemble for 16-bit mode
    cli                                             # Disable interrupts
    7c00:	fa                   	cli    
    cld                                             # String operations increment
    7c01:	fc                   	cld    

    # Set up the important data segment registers (DS, ES, SS).
    xorw %ax, %ax                                   # Segment number zero
    7c02:	31 c0                	xor    %eax,%eax
    movw %ax, %ds                                   # -> Data Segment
    7c04:	8e d8                	mov    %eax,%ds
    movw %ax, %es                                   # -> Extra Segment
    7c06:	8e c0                	mov    %eax,%es
    movw %ax, %ss                                   # -> Stack Segment
    7c08:	8e d0                	mov    %eax,%ss

00007c0a <seta20.1>:
    # Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.
seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    7c0a:	e4 64                	in     $0x64,%al
    testb $0x2, %al
    7c0c:	a8 02                	test   $0x2,%al
    jnz seta20.1
    7c0e:	75 fa                	jne    7c0a <seta20.1>

    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    7c10:	b0 d1                	mov    $0xd1,%al
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port
    7c12:	e6 64                	out    %al,$0x64

00007c14 <seta20.2>:

seta20.2:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    7c14:	e4 64                	in     $0x64,%al
    testb $0x2, %al
    7c16:	a8 02                	test   $0x2,%al
    jnz seta20.2
    7c18:	75 fa                	jne    7c14 <seta20.2>

    movb $0xdf, %al                                 # 0xdf -> port 0x60
    7c1a:	b0 df                	mov    $0xdf,%al
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1
    7c1c:	e6 60                	out    %al,$0x60

    # Switch from real to protected mode, using a bootstrap GDT
    # and segment translation that makes virtual addresses
    # identical to physical addresses, so that the
    # effective memory map does not change during the switch.
    lgdt gdtdesc
    7c1e:	0f 01 16             	lgdtl  (%esi)
    7c21:	6c                   	insb   (%dx),%es:(%edi)
    7c22:	7c 0f                	jl     7c33 <protcseg+0x1>
    movl %cr0, %eax
    7c24:	20 c0                	and    %al,%al
    orl $CR0_PE_ON, %eax
    7c26:	66 83 c8 01          	or     $0x1,%ax
    movl %eax, %cr0
    7c2a:	0f 22 c0             	mov    %eax,%cr0

    # Jump to next instruction, but in 32-bit code segment.
    # Switches processor into 32-bit mode.
    ljmp $PROT_MODE_CSEG, $protcseg
    7c2d:	ea 32 7c 08 00 66 b8 	ljmp   $0xb866,$0x87c32

00007c32 <protcseg>:

.code32                                             # Assemble for 32-bit mode
protcseg:
    # Set up the protected-mode data segment registers
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    7c32:	66 b8 10 00          	mov    $0x10,%ax
    movw %ax, %ds                                   # -> DS: Data Segment
    7c36:	8e d8                	mov    %eax,%ds
    movw %ax, %es                                   # -> ES: Extra Segment
    7c38:	8e c0                	mov    %eax,%es
    movw %ax, %fs                                   # -> FS
    7c3a:	8e e0                	mov    %eax,%fs
    movw %ax, %gs                                   # -> GS
    7c3c:	8e e8                	mov    %eax,%gs
    movw %ax, %ss                                   # -> SS: Stack Segment
    7c3e:	8e d0                	mov    %eax,%ss

    # Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
    movl $0x0, %ebp
    7c40:	bd 00 00 00 00       	mov    $0x0,%ebp
    movl $start, %esp
    7c45:	bc 00 7c 00 00       	mov    $0x7c00,%esp
    call bootmain
    7c4a:	e8 b1 00 00 00       	call   7d00 <bootmain>

00007c4f <spin>:

    # If bootmain returns (it shouldn't), loop.
spin:
    jmp spin
    7c4f:	eb fe                	jmp    7c4f <spin>
    7c51:	8d 76 00             	lea    0x0(%esi),%esi

00007c54 <gdt>:
	...
    7c5c:	ff                   	(bad)  
    7c5d:	ff 00                	incl   (%eax)
    7c5f:	00 00                	add    %al,(%eax)
    7c61:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c68:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

00007c6c <gdtdesc>:
    7c6c:	17                   	pop    %ss
    7c6d:	00 54 7c 00          	add    %dl,0x0(%esp,%edi,2)
	...

00007c72 <readseg>:
/* *
 * readseg - read @count bytes at @offset from kernel into virtual address @va,
 * might copy more than asked.
 * */
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    7c72:	55                   	push   %ebp
    7c73:	89 e5                	mov    %esp,%ebp
    7c75:	57                   	push   %edi
    7c76:	56                   	push   %esi
    7c77:	89 c6                	mov    %eax,%esi
    7c79:	53                   	push   %ebx
    uintptr_t end_va = va + count;
    7c7a:	8d 04 10             	lea    (%eax,%edx,1),%eax

    // round down to sector boundary
    va -= offset % SECTSIZE;
    7c7d:	31 d2                	xor    %edx,%edx
/* *
 * readseg - read @count bytes at @offset from kernel into virtual address @va,
 * might copy more than asked.
 * */
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    7c7f:	53                   	push   %ebx
    uintptr_t end_va = va + count;
    7c80:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // round down to sector boundary
    va -= offset % SECTSIZE;
    7c83:	89 c8                	mov    %ecx,%eax
    7c85:	f7 35 e4 7d 00 00    	divl   0x7de4
    7c8b:	29 d6                	sub    %edx,%esi

    // translate from bytes to sectors; kernel starts at sector 1
    uint32_t secno = (offset / SECTSIZE) + 1;
    7c8d:	8d 58 01             	lea    0x1(%eax),%ebx

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
    7c90:	3b 75 f0             	cmp    -0x10(%ebp),%esi
    7c93:	73 65                	jae    7cfa <readseg+0x88>
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
    7c95:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c9a:	ec                   	in     (%dx),%al
struct elfhdr * ELFHDR    =      ((struct elfhdr *)0x10000) ;     // scratch space

/* waitdisk - wait for disk ready */
static void
waitdisk(void) {
    while ((inb(0x1F7) & 0xC0) != 0x40)
    7c9b:	83 e0 c0             	and    $0xffffffc0,%eax
    7c9e:	3c 40                	cmp    $0x40,%al
    7ca0:	75 f3                	jne    7c95 <readseg+0x23>
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
    7ca2:	b2 f2                	mov    $0xf2,%dl
    7ca4:	b0 01                	mov    $0x1,%al
    7ca6:	ee                   	out    %al,(%dx)
    7ca7:	0f b6 c3             	movzbl %bl,%eax
    7caa:	b2 f3                	mov    $0xf3,%dl
    7cac:	ee                   	out    %al,(%dx)
    7cad:	0f b6 c7             	movzbl %bh,%eax
    7cb0:	b2 f4                	mov    $0xf4,%dl
    7cb2:	ee                   	out    %al,(%dx)
    waitdisk();

    outb(0x1F2, 1);                         // count = 1
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
    outb(0x1F5, (secno >> 16) & 0xFF);
    7cb3:	89 d8                	mov    %ebx,%eax
    7cb5:	b2 f5                	mov    $0xf5,%dl
    7cb7:	c1 e8 10             	shr    $0x10,%eax
    7cba:	0f b6 c0             	movzbl %al,%eax
    7cbd:	ee                   	out    %al,(%dx)
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
    7cbe:	89 d8                	mov    %ebx,%eax
    7cc0:	b2 f6                	mov    $0xf6,%dl
    7cc2:	c1 e8 18             	shr    $0x18,%eax
    7cc5:	83 e0 0f             	and    $0xf,%eax
    7cc8:	83 c8 e0             	or     $0xffffffe0,%eax
    7ccb:	ee                   	out    %al,(%dx)
    7ccc:	b0 20                	mov    $0x20,%al
    7cce:	b2 f7                	mov    $0xf7,%dl
    7cd0:	ee                   	out    %al,(%dx)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
    7cd1:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7cd6:	ec                   	in     (%dx),%al
struct elfhdr * ELFHDR    =      ((struct elfhdr *)0x10000) ;     // scratch space

/* waitdisk - wait for disk ready */
static void
waitdisk(void) {
    while ((inb(0x1F7) & 0xC0) != 0x40)
    7cd7:	83 e0 c0             	and    $0xffffffc0,%eax
    7cda:	3c 40                	cmp    $0x40,%al
    7cdc:	75 f3                	jne    7cd1 <readseg+0x5f>

    // wait for disk to be ready
    waitdisk();

    // read a sector
    insl(0x1F0, dst, SECTSIZE / 4);
    7cde:	8b 0d e4 7d 00 00    	mov    0x7de4,%ecx
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
    7ce4:	89 f7                	mov    %esi,%edi
    7ce6:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7ceb:	c1 e9 02             	shr    $0x2,%ecx
    7cee:	fc                   	cld    
    7cef:	f2 6d                	repnz insl (%dx),%es:(%edi)
    uint32_t secno = (offset / SECTSIZE) + 1;

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
    7cf1:	03 35 e4 7d 00 00    	add    0x7de4,%esi
    7cf7:	43                   	inc    %ebx
    7cf8:	eb 96                	jmp    7c90 <readseg+0x1e>
        readsect((void *)va, secno);
    }
}
    7cfa:	58                   	pop    %eax
    7cfb:	5b                   	pop    %ebx
    7cfc:	5e                   	pop    %esi
    7cfd:	5f                   	pop    %edi
    7cfe:	5d                   	pop    %ebp
    7cff:	c3                   	ret    

00007d00 <bootmain>:

/* bootmain - the entry of bootloader */
void
bootmain(void) {
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);
    7d00:	a1 e4 7d 00 00       	mov    0x7de4,%eax
    7d05:	31 c9                	xor    %ecx,%ecx
    }
}

/* bootmain - the entry of bootloader */
void
bootmain(void) {
    7d07:	55                   	push   %ebp
    7d08:	89 e5                	mov    %esp,%ebp
    7d0a:	56                   	push   %esi
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);
    7d0b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    7d12:	a1 e0 7d 00 00       	mov    0x7de0,%eax
    }
}

/* bootmain - the entry of bootloader */
void
bootmain(void) {
    7d17:	53                   	push   %ebx
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);
    7d18:	e8 55 ff ff ff       	call   7c72 <readseg>

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC) {
    7d1d:	a1 e0 7d 00 00       	mov    0x7de0,%eax
    7d22:	81 38 7f 45 4c 46    	cmpl   $0x464c457f,(%eax)
    7d28:	75 3a                	jne    7d64 <bootmain+0x64>
    }

    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    7d2a:	8b 58 1c             	mov    0x1c(%eax),%ebx
    7d2d:	01 c3                	add    %eax,%ebx
    eph = ph + ELFHDR->e_phnum;
    7d2f:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
    7d33:	c1 e0 05             	shl    $0x5,%eax
    7d36:	8d 34 03             	lea    (%ebx,%eax,1),%esi
    for (; ph < eph; ph ++) {
    7d39:	39 f3                	cmp    %esi,%ebx
    7d3b:	73 18                	jae    7d55 <bootmain+0x55>
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    7d3d:	8b 43 08             	mov    0x8(%ebx),%eax
    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph ++) {
    7d40:	83 c3 20             	add    $0x20,%ebx
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    7d43:	8b 4b e4             	mov    -0x1c(%ebx),%ecx
    7d46:	8b 53 f4             	mov    -0xc(%ebx),%edx
    7d49:	25 ff ff ff 00       	and    $0xffffff,%eax
    7d4e:	e8 1f ff ff ff       	call   7c72 <readseg>
    7d53:	eb e4                	jmp    7d39 <bootmain+0x39>
    }

    // call the entry point from the ELF header
    // note: does not return
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();
    7d55:	a1 e0 7d 00 00       	mov    0x7de0,%eax
    7d5a:	8b 40 18             	mov    0x18(%eax),%eax
    7d5d:	25 ff ff ff 00       	and    $0xffffff,%eax
    7d62:	ff d0                	call   *%eax
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
}

static inline void
outw(uint16_t port, uint16_t data) {
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port));
    7d64:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
    7d69:	89 c2                	mov    %eax,%edx
    7d6b:	66 ef                	out    %ax,(%dx)
    7d6d:	b8 00 8e ff ff       	mov    $0xffff8e00,%eax
    7d72:	66 ef                	out    %ax,(%dx)
    7d74:	eb fe                	jmp    7d74 <bootmain+0x74>
