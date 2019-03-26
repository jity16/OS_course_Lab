
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 80 11 00       	mov    $0x118000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 80 11 c0       	mov    %eax,0xc0118000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	ba 28 af 11 c0       	mov    $0xc011af28,%edx
c0100041:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 a0 11 c0 	movl   $0xc011a000,(%esp)
c010005d:	e8 4d 5c 00 00       	call   c0105caf <memset>

    cons_init();                // init the console
c0100062:	e8 82 15 00 00       	call   c01015e9 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 40 5e 10 c0 	movl   $0xc0105e40,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 5c 5e 10 c0 	movl   $0xc0105e5c,(%esp)
c010007c:	e8 c7 02 00 00       	call   c0100348 <cprintf>

    print_kerninfo();
c0100081:	e8 f6 07 00 00       	call   c010087c <print_kerninfo>

    grade_backtrace();
c0100086:	e8 86 00 00 00       	call   c0100111 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 19 43 00 00       	call   c01043a9 <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 bd 16 00 00       	call   c0101752 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 35 18 00 00       	call   c01018cf <idt_init>

    clock_init();               // init clock interrupt
c010009a:	e8 00 0d 00 00       	call   c0100d9f <clock_init>
    intr_enable();              // enable irq interrupt
c010009f:	e8 1c 16 00 00       	call   c01016c0 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a4:	eb fe                	jmp    c01000a4 <kern_init+0x6e>

c01000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a6:	55                   	push   %ebp
c01000a7:	89 e5                	mov    %esp,%ebp
c01000a9:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b3:	00 
c01000b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000bb:	00 
c01000bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c3:	e8 f8 0b 00 00       	call   c0100cc0 <mon_backtrace>
}
c01000c8:	c9                   	leave  
c01000c9:	c3                   	ret    

c01000ca <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000ca:	55                   	push   %ebp
c01000cb:	89 e5                	mov    %esp,%ebp
c01000cd:	53                   	push   %ebx
c01000ce:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d1:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000d7:	8d 55 08             	lea    0x8(%ebp),%edx
c01000da:	8b 45 08             	mov    0x8(%ebp),%eax
c01000dd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000e5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000e9:	89 04 24             	mov    %eax,(%esp)
c01000ec:	e8 b5 ff ff ff       	call   c01000a6 <grade_backtrace2>
}
c01000f1:	83 c4 14             	add    $0x14,%esp
c01000f4:	5b                   	pop    %ebx
c01000f5:	5d                   	pop    %ebp
c01000f6:	c3                   	ret    

c01000f7 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000f7:	55                   	push   %ebp
c01000f8:	89 e5                	mov    %esp,%ebp
c01000fa:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0100100:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100104:	8b 45 08             	mov    0x8(%ebp),%eax
c0100107:	89 04 24             	mov    %eax,(%esp)
c010010a:	e8 bb ff ff ff       	call   c01000ca <grade_backtrace1>
}
c010010f:	c9                   	leave  
c0100110:	c3                   	ret    

c0100111 <grade_backtrace>:

void
grade_backtrace(void) {
c0100111:	55                   	push   %ebp
c0100112:	89 e5                	mov    %esp,%ebp
c0100114:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100117:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010011c:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100123:	ff 
c0100124:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100128:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010012f:	e8 c3 ff ff ff       	call   c01000f7 <grade_backtrace0>
}
c0100134:	c9                   	leave  
c0100135:	c3                   	ret    

c0100136 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100136:	55                   	push   %ebp
c0100137:	89 e5                	mov    %esp,%ebp
c0100139:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010013c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010013f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100142:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100145:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100148:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014c:	0f b7 c0             	movzwl %ax,%eax
c010014f:	83 e0 03             	and    $0x3,%eax
c0100152:	89 c2                	mov    %eax,%edx
c0100154:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100159:	89 54 24 08          	mov    %edx,0x8(%esp)
c010015d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100161:	c7 04 24 61 5e 10 c0 	movl   $0xc0105e61,(%esp)
c0100168:	e8 db 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010016d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100171:	0f b7 d0             	movzwl %ax,%edx
c0100174:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100179:	89 54 24 08          	mov    %edx,0x8(%esp)
c010017d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100181:	c7 04 24 6f 5e 10 c0 	movl   $0xc0105e6f,(%esp)
c0100188:	e8 bb 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100191:	0f b7 d0             	movzwl %ax,%edx
c0100194:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100199:	89 54 24 08          	mov    %edx,0x8(%esp)
c010019d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a1:	c7 04 24 7d 5e 10 c0 	movl   $0xc0105e7d,(%esp)
c01001a8:	e8 9b 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001ad:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b1:	0f b7 d0             	movzwl %ax,%edx
c01001b4:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c1:	c7 04 24 8b 5e 10 c0 	movl   $0xc0105e8b,(%esp)
c01001c8:	e8 7b 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001cd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d1:	0f b7 d0             	movzwl %ax,%edx
c01001d4:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001d9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e1:	c7 04 24 99 5e 10 c0 	movl   $0xc0105e99,(%esp)
c01001e8:	e8 5b 01 00 00       	call   c0100348 <cprintf>
    round ++;
c01001ed:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001f2:	83 c0 01             	add    $0x1,%eax
c01001f5:	a3 00 a0 11 c0       	mov    %eax,0xc011a000
}
c01001fa:	c9                   	leave  
c01001fb:	c3                   	ret    

c01001fc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001fc:	55                   	push   %ebp
c01001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : 2016010308
}
c01001ff:	5d                   	pop    %ebp
c0100200:	c3                   	ret    

c0100201 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100201:	55                   	push   %ebp
c0100202:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  2016010308
}
c0100204:	5d                   	pop    %ebp
c0100205:	c3                   	ret    

c0100206 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100206:	55                   	push   %ebp
c0100207:	89 e5                	mov    %esp,%ebp
c0100209:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020c:	e8 25 ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100211:	c7 04 24 a8 5e 10 c0 	movl   $0xc0105ea8,(%esp)
c0100218:	e8 2b 01 00 00       	call   c0100348 <cprintf>
    lab1_switch_to_user();
c010021d:	e8 da ff ff ff       	call   c01001fc <lab1_switch_to_user>
    lab1_print_cur_status();
c0100222:	e8 0f ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100227:	c7 04 24 c8 5e 10 c0 	movl   $0xc0105ec8,(%esp)
c010022e:	e8 15 01 00 00       	call   c0100348 <cprintf>
    lab1_switch_to_kernel();
c0100233:	e8 c9 ff ff ff       	call   c0100201 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100238:	e8 f9 fe ff ff       	call   c0100136 <lab1_print_cur_status>
}
c010023d:	c9                   	leave  
c010023e:	c3                   	ret    

c010023f <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010023f:	55                   	push   %ebp
c0100240:	89 e5                	mov    %esp,%ebp
c0100242:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100245:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100249:	74 13                	je     c010025e <readline+0x1f>
        cprintf("%s", prompt);
c010024b:	8b 45 08             	mov    0x8(%ebp),%eax
c010024e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100252:	c7 04 24 e7 5e 10 c0 	movl   $0xc0105ee7,(%esp)
c0100259:	e8 ea 00 00 00       	call   c0100348 <cprintf>
    }
    int i = 0, c;
c010025e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100265:	e8 66 01 00 00       	call   c01003d0 <getchar>
c010026a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010026d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100271:	79 07                	jns    c010027a <readline+0x3b>
            return NULL;
c0100273:	b8 00 00 00 00       	mov    $0x0,%eax
c0100278:	eb 79                	jmp    c01002f3 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010027a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010027e:	7e 28                	jle    c01002a8 <readline+0x69>
c0100280:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100287:	7f 1f                	jg     c01002a8 <readline+0x69>
            cputchar(c);
c0100289:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010028c:	89 04 24             	mov    %eax,(%esp)
c010028f:	e8 da 00 00 00       	call   c010036e <cputchar>
            buf[i ++] = c;
c0100294:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100297:	8d 50 01             	lea    0x1(%eax),%edx
c010029a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010029d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a0:	88 90 20 a0 11 c0    	mov    %dl,-0x3fee5fe0(%eax)
c01002a6:	eb 46                	jmp    c01002ee <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002a8:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002ac:	75 17                	jne    c01002c5 <readline+0x86>
c01002ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002b2:	7e 11                	jle    c01002c5 <readline+0x86>
            cputchar(c);
c01002b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002b7:	89 04 24             	mov    %eax,(%esp)
c01002ba:	e8 af 00 00 00       	call   c010036e <cputchar>
            i --;
c01002bf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002c3:	eb 29                	jmp    c01002ee <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002c5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002c9:	74 06                	je     c01002d1 <readline+0x92>
c01002cb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002cf:	75 1d                	jne    c01002ee <readline+0xaf>
            cputchar(c);
c01002d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d4:	89 04 24             	mov    %eax,(%esp)
c01002d7:	e8 92 00 00 00       	call   c010036e <cputchar>
            buf[i] = '\0';
c01002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002df:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c01002e4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002e7:	b8 20 a0 11 c0       	mov    $0xc011a020,%eax
c01002ec:	eb 05                	jmp    c01002f3 <readline+0xb4>
        }
    }
c01002ee:	e9 72 ff ff ff       	jmp    c0100265 <readline+0x26>
}
c01002f3:	c9                   	leave  
c01002f4:	c3                   	ret    

c01002f5 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f5:	55                   	push   %ebp
c01002f6:	89 e5                	mov    %esp,%ebp
c01002f8:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01002fe:	89 04 24             	mov    %eax,(%esp)
c0100301:	e8 0f 13 00 00       	call   c0101615 <cons_putc>
    (*cnt) ++;
c0100306:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100309:	8b 00                	mov    (%eax),%eax
c010030b:	8d 50 01             	lea    0x1(%eax),%edx
c010030e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100311:	89 10                	mov    %edx,(%eax)
}
c0100313:	c9                   	leave  
c0100314:	c3                   	ret    

c0100315 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100315:	55                   	push   %ebp
c0100316:	89 e5                	mov    %esp,%ebp
c0100318:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100322:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100325:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100329:	8b 45 08             	mov    0x8(%ebp),%eax
c010032c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100330:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100333:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100337:	c7 04 24 f5 02 10 c0 	movl   $0xc01002f5,(%esp)
c010033e:	e8 85 51 00 00       	call   c01054c8 <vprintfmt>
    return cnt;
c0100343:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100346:	c9                   	leave  
c0100347:	c3                   	ret    

c0100348 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100348:	55                   	push   %ebp
c0100349:	89 e5                	mov    %esp,%ebp
c010034b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010034e:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100351:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100354:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100357:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035b:	8b 45 08             	mov    0x8(%ebp),%eax
c010035e:	89 04 24             	mov    %eax,(%esp)
c0100361:	e8 af ff ff ff       	call   c0100315 <vcprintf>
c0100366:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100369:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036c:	c9                   	leave  
c010036d:	c3                   	ret    

c010036e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010036e:	55                   	push   %ebp
c010036f:	89 e5                	mov    %esp,%ebp
c0100371:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100374:	8b 45 08             	mov    0x8(%ebp),%eax
c0100377:	89 04 24             	mov    %eax,(%esp)
c010037a:	e8 96 12 00 00       	call   c0101615 <cons_putc>
}
c010037f:	c9                   	leave  
c0100380:	c3                   	ret    

c0100381 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100381:	55                   	push   %ebp
c0100382:	89 e5                	mov    %esp,%ebp
c0100384:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100387:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010038e:	eb 13                	jmp    c01003a3 <cputs+0x22>
        cputch(c, &cnt);
c0100390:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100394:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100397:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039b:	89 04 24             	mov    %eax,(%esp)
c010039e:	e8 52 ff ff ff       	call   c01002f5 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a6:	8d 50 01             	lea    0x1(%eax),%edx
c01003a9:	89 55 08             	mov    %edx,0x8(%ebp)
c01003ac:	0f b6 00             	movzbl (%eax),%eax
c01003af:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003b2:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b6:	75 d8                	jne    c0100390 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003bf:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003c6:	e8 2a ff ff ff       	call   c01002f5 <cputch>
    return cnt;
c01003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003ce:	c9                   	leave  
c01003cf:	c3                   	ret    

c01003d0 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d0:	55                   	push   %ebp
c01003d1:	89 e5                	mov    %esp,%ebp
c01003d3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003d6:	e8 76 12 00 00       	call   c0101651 <cons_getc>
c01003db:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e2:	74 f2                	je     c01003d6 <getchar+0x6>
        /* do nothing */;
    return c;
c01003e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003e7:	c9                   	leave  
c01003e8:	c3                   	ret    

c01003e9 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003e9:	55                   	push   %ebp
c01003ea:	89 e5                	mov    %esp,%ebp
c01003ec:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f2:	8b 00                	mov    (%eax),%eax
c01003f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01003fa:	8b 00                	mov    (%eax),%eax
c01003fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100406:	e9 d2 00 00 00       	jmp    c01004dd <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010040b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010040e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100411:	01 d0                	add    %edx,%eax
c0100413:	89 c2                	mov    %eax,%edx
c0100415:	c1 ea 1f             	shr    $0x1f,%edx
c0100418:	01 d0                	add    %edx,%eax
c010041a:	d1 f8                	sar    %eax
c010041c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100422:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100425:	eb 04                	jmp    c010042b <stab_binsearch+0x42>
            m --;
c0100427:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010042e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100431:	7c 1f                	jl     c0100452 <stab_binsearch+0x69>
c0100433:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100436:	89 d0                	mov    %edx,%eax
c0100438:	01 c0                	add    %eax,%eax
c010043a:	01 d0                	add    %edx,%eax
c010043c:	c1 e0 02             	shl    $0x2,%eax
c010043f:	89 c2                	mov    %eax,%edx
c0100441:	8b 45 08             	mov    0x8(%ebp),%eax
c0100444:	01 d0                	add    %edx,%eax
c0100446:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010044a:	0f b6 c0             	movzbl %al,%eax
c010044d:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100450:	75 d5                	jne    c0100427 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100452:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100455:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100458:	7d 0b                	jge    c0100465 <stab_binsearch+0x7c>
            l = true_m + 1;
c010045a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010045d:	83 c0 01             	add    $0x1,%eax
c0100460:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100463:	eb 78                	jmp    c01004dd <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100465:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010046c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010046f:	89 d0                	mov    %edx,%eax
c0100471:	01 c0                	add    %eax,%eax
c0100473:	01 d0                	add    %edx,%eax
c0100475:	c1 e0 02             	shl    $0x2,%eax
c0100478:	89 c2                	mov    %eax,%edx
c010047a:	8b 45 08             	mov    0x8(%ebp),%eax
c010047d:	01 d0                	add    %edx,%eax
c010047f:	8b 40 08             	mov    0x8(%eax),%eax
c0100482:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100485:	73 13                	jae    c010049a <stab_binsearch+0xb1>
            *region_left = m;
c0100487:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010048d:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010048f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100492:	83 c0 01             	add    $0x1,%eax
c0100495:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100498:	eb 43                	jmp    c01004dd <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010049a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010049d:	89 d0                	mov    %edx,%eax
c010049f:	01 c0                	add    %eax,%eax
c01004a1:	01 d0                	add    %edx,%eax
c01004a3:	c1 e0 02             	shl    $0x2,%eax
c01004a6:	89 c2                	mov    %eax,%edx
c01004a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ab:	01 d0                	add    %edx,%eax
c01004ad:	8b 40 08             	mov    0x8(%eax),%eax
c01004b0:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004b3:	76 16                	jbe    c01004cb <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004be:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c3:	83 e8 01             	sub    $0x1,%eax
c01004c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004c9:	eb 12                	jmp    c01004dd <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d1:	89 10                	mov    %edx,(%eax)
            l = m;
c01004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004d9:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004e3:	0f 8e 22 ff ff ff    	jle    c010040b <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004ed:	75 0f                	jne    c01004fe <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f2:	8b 00                	mov    (%eax),%eax
c01004f4:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fa:	89 10                	mov    %edx,(%eax)
c01004fc:	eb 3f                	jmp    c010053d <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004fe:	8b 45 10             	mov    0x10(%ebp),%eax
c0100501:	8b 00                	mov    (%eax),%eax
c0100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100506:	eb 04                	jmp    c010050c <stab_binsearch+0x123>
c0100508:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010050c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010050f:	8b 00                	mov    (%eax),%eax
c0100511:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100514:	7d 1f                	jge    c0100535 <stab_binsearch+0x14c>
c0100516:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100519:	89 d0                	mov    %edx,%eax
c010051b:	01 c0                	add    %eax,%eax
c010051d:	01 d0                	add    %edx,%eax
c010051f:	c1 e0 02             	shl    $0x2,%eax
c0100522:	89 c2                	mov    %eax,%edx
c0100524:	8b 45 08             	mov    0x8(%ebp),%eax
c0100527:	01 d0                	add    %edx,%eax
c0100529:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010052d:	0f b6 c0             	movzbl %al,%eax
c0100530:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100533:	75 d3                	jne    c0100508 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100535:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100538:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053b:	89 10                	mov    %edx,(%eax)
    }
}
c010053d:	c9                   	leave  
c010053e:	c3                   	ret    

c010053f <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010053f:	55                   	push   %ebp
c0100540:	89 e5                	mov    %esp,%ebp
c0100542:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100545:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100548:	c7 00 ec 5e 10 c0    	movl   $0xc0105eec,(%eax)
    info->eip_line = 0;
c010054e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100551:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100558:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055b:	c7 40 08 ec 5e 10 c0 	movl   $0xc0105eec,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100562:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100565:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010056c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100572:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100575:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100578:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010057f:	c7 45 f4 68 71 10 c0 	movl   $0xc0107168,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100586:	c7 45 f0 30 1b 11 c0 	movl   $0xc0111b30,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010058d:	c7 45 ec 31 1b 11 c0 	movl   $0xc0111b31,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100594:	c7 45 e8 7b 45 11 c0 	movl   $0xc011457b,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010059b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a1:	76 0d                	jbe    c01005b0 <debuginfo_eip+0x71>
c01005a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a6:	83 e8 01             	sub    $0x1,%eax
c01005a9:	0f b6 00             	movzbl (%eax),%eax
c01005ac:	84 c0                	test   %al,%al
c01005ae:	74 0a                	je     c01005ba <debuginfo_eip+0x7b>
        return -1;
c01005b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b5:	e9 c0 02 00 00       	jmp    c010087a <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005c7:	29 c2                	sub    %eax,%edx
c01005c9:	89 d0                	mov    %edx,%eax
c01005cb:	c1 f8 02             	sar    $0x2,%eax
c01005ce:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005d4:	83 e8 01             	sub    $0x1,%eax
c01005d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005da:	8b 45 08             	mov    0x8(%ebp),%eax
c01005dd:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005e1:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005e8:	00 
c01005e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005ec:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005fa:	89 04 24             	mov    %eax,(%esp)
c01005fd:	e8 e7 fd ff ff       	call   c01003e9 <stab_binsearch>
    if (lfile == 0)
c0100602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100605:	85 c0                	test   %eax,%eax
c0100607:	75 0a                	jne    c0100613 <debuginfo_eip+0xd4>
        return -1;
c0100609:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010060e:	e9 67 02 00 00       	jmp    c010087a <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100616:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100619:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010061c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010061f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100622:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100626:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c010062d:	00 
c010062e:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100631:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100635:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100638:	89 44 24 04          	mov    %eax,0x4(%esp)
c010063c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010063f:	89 04 24             	mov    %eax,(%esp)
c0100642:	e8 a2 fd ff ff       	call   c01003e9 <stab_binsearch>

    if (lfun <= rfun) {
c0100647:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010064a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010064d:	39 c2                	cmp    %eax,%edx
c010064f:	7f 7c                	jg     c01006cd <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100651:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100654:	89 c2                	mov    %eax,%edx
c0100656:	89 d0                	mov    %edx,%eax
c0100658:	01 c0                	add    %eax,%eax
c010065a:	01 d0                	add    %edx,%eax
c010065c:	c1 e0 02             	shl    $0x2,%eax
c010065f:	89 c2                	mov    %eax,%edx
c0100661:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100664:	01 d0                	add    %edx,%eax
c0100666:	8b 10                	mov    (%eax),%edx
c0100668:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010066b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010066e:	29 c1                	sub    %eax,%ecx
c0100670:	89 c8                	mov    %ecx,%eax
c0100672:	39 c2                	cmp    %eax,%edx
c0100674:	73 22                	jae    c0100698 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100676:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100679:	89 c2                	mov    %eax,%edx
c010067b:	89 d0                	mov    %edx,%eax
c010067d:	01 c0                	add    %eax,%eax
c010067f:	01 d0                	add    %edx,%eax
c0100681:	c1 e0 02             	shl    $0x2,%eax
c0100684:	89 c2                	mov    %eax,%edx
c0100686:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100689:	01 d0                	add    %edx,%eax
c010068b:	8b 10                	mov    (%eax),%edx
c010068d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100690:	01 c2                	add    %eax,%edx
c0100692:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100695:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100698:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069b:	89 c2                	mov    %eax,%edx
c010069d:	89 d0                	mov    %edx,%eax
c010069f:	01 c0                	add    %eax,%eax
c01006a1:	01 d0                	add    %edx,%eax
c01006a3:	c1 e0 02             	shl    $0x2,%eax
c01006a6:	89 c2                	mov    %eax,%edx
c01006a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ab:	01 d0                	add    %edx,%eax
c01006ad:	8b 50 08             	mov    0x8(%eax),%edx
c01006b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b3:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b9:	8b 40 10             	mov    0x10(%eax),%eax
c01006bc:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006cb:	eb 15                	jmp    c01006e2 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d0:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006df:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e5:	8b 40 08             	mov    0x8(%eax),%eax
c01006e8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006ef:	00 
c01006f0:	89 04 24             	mov    %eax,(%esp)
c01006f3:	e8 2b 54 00 00       	call   c0105b23 <strfind>
c01006f8:	89 c2                	mov    %eax,%edx
c01006fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006fd:	8b 40 08             	mov    0x8(%eax),%eax
c0100700:	29 c2                	sub    %eax,%edx
c0100702:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100705:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100708:	8b 45 08             	mov    0x8(%ebp),%eax
c010070b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010070f:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100716:	00 
c0100717:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010071a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010071e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100721:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100725:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100728:	89 04 24             	mov    %eax,(%esp)
c010072b:	e8 b9 fc ff ff       	call   c01003e9 <stab_binsearch>
    if (lline <= rline) {
c0100730:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100733:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100736:	39 c2                	cmp    %eax,%edx
c0100738:	7f 24                	jg     c010075e <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010073a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010073d:	89 c2                	mov    %eax,%edx
c010073f:	89 d0                	mov    %edx,%eax
c0100741:	01 c0                	add    %eax,%eax
c0100743:	01 d0                	add    %edx,%eax
c0100745:	c1 e0 02             	shl    $0x2,%eax
c0100748:	89 c2                	mov    %eax,%edx
c010074a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010074d:	01 d0                	add    %edx,%eax
c010074f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100753:	0f b7 d0             	movzwl %ax,%edx
c0100756:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100759:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010075c:	eb 13                	jmp    c0100771 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c010075e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100763:	e9 12 01 00 00       	jmp    c010087a <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100768:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076b:	83 e8 01             	sub    $0x1,%eax
c010076e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100771:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100777:	39 c2                	cmp    %eax,%edx
c0100779:	7c 56                	jl     c01007d1 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010077b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077e:	89 c2                	mov    %eax,%edx
c0100780:	89 d0                	mov    %edx,%eax
c0100782:	01 c0                	add    %eax,%eax
c0100784:	01 d0                	add    %edx,%eax
c0100786:	c1 e0 02             	shl    $0x2,%eax
c0100789:	89 c2                	mov    %eax,%edx
c010078b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010078e:	01 d0                	add    %edx,%eax
c0100790:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100794:	3c 84                	cmp    $0x84,%al
c0100796:	74 39                	je     c01007d1 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100798:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079b:	89 c2                	mov    %eax,%edx
c010079d:	89 d0                	mov    %edx,%eax
c010079f:	01 c0                	add    %eax,%eax
c01007a1:	01 d0                	add    %edx,%eax
c01007a3:	c1 e0 02             	shl    $0x2,%eax
c01007a6:	89 c2                	mov    %eax,%edx
c01007a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ab:	01 d0                	add    %edx,%eax
c01007ad:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b1:	3c 64                	cmp    $0x64,%al
c01007b3:	75 b3                	jne    c0100768 <debuginfo_eip+0x229>
c01007b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007b8:	89 c2                	mov    %eax,%edx
c01007ba:	89 d0                	mov    %edx,%eax
c01007bc:	01 c0                	add    %eax,%eax
c01007be:	01 d0                	add    %edx,%eax
c01007c0:	c1 e0 02             	shl    $0x2,%eax
c01007c3:	89 c2                	mov    %eax,%edx
c01007c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c8:	01 d0                	add    %edx,%eax
c01007ca:	8b 40 08             	mov    0x8(%eax),%eax
c01007cd:	85 c0                	test   %eax,%eax
c01007cf:	74 97                	je     c0100768 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007d7:	39 c2                	cmp    %eax,%edx
c01007d9:	7c 46                	jl     c0100821 <debuginfo_eip+0x2e2>
c01007db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007de:	89 c2                	mov    %eax,%edx
c01007e0:	89 d0                	mov    %edx,%eax
c01007e2:	01 c0                	add    %eax,%eax
c01007e4:	01 d0                	add    %edx,%eax
c01007e6:	c1 e0 02             	shl    $0x2,%eax
c01007e9:	89 c2                	mov    %eax,%edx
c01007eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ee:	01 d0                	add    %edx,%eax
c01007f0:	8b 10                	mov    (%eax),%edx
c01007f2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007f8:	29 c1                	sub    %eax,%ecx
c01007fa:	89 c8                	mov    %ecx,%eax
c01007fc:	39 c2                	cmp    %eax,%edx
c01007fe:	73 21                	jae    c0100821 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100803:	89 c2                	mov    %eax,%edx
c0100805:	89 d0                	mov    %edx,%eax
c0100807:	01 c0                	add    %eax,%eax
c0100809:	01 d0                	add    %edx,%eax
c010080b:	c1 e0 02             	shl    $0x2,%eax
c010080e:	89 c2                	mov    %eax,%edx
c0100810:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100813:	01 d0                	add    %edx,%eax
c0100815:	8b 10                	mov    (%eax),%edx
c0100817:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010081a:	01 c2                	add    %eax,%edx
c010081c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081f:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100821:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100824:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100827:	39 c2                	cmp    %eax,%edx
c0100829:	7d 4a                	jge    c0100875 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010082b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010082e:	83 c0 01             	add    $0x1,%eax
c0100831:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100834:	eb 18                	jmp    c010084e <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100836:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100839:	8b 40 14             	mov    0x14(%eax),%eax
c010083c:	8d 50 01             	lea    0x1(%eax),%edx
c010083f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100842:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100845:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100848:	83 c0 01             	add    $0x1,%eax
c010084b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100851:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100854:	39 c2                	cmp    %eax,%edx
c0100856:	7d 1d                	jge    c0100875 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085b:	89 c2                	mov    %eax,%edx
c010085d:	89 d0                	mov    %edx,%eax
c010085f:	01 c0                	add    %eax,%eax
c0100861:	01 d0                	add    %edx,%eax
c0100863:	c1 e0 02             	shl    $0x2,%eax
c0100866:	89 c2                	mov    %eax,%edx
c0100868:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086b:	01 d0                	add    %edx,%eax
c010086d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100871:	3c a0                	cmp    $0xa0,%al
c0100873:	74 c1                	je     c0100836 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100875:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010087a:	c9                   	leave  
c010087b:	c3                   	ret    

c010087c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010087c:	55                   	push   %ebp
c010087d:	89 e5                	mov    %esp,%ebp
c010087f:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100882:	c7 04 24 f6 5e 10 c0 	movl   $0xc0105ef6,(%esp)
c0100889:	e8 ba fa ff ff       	call   c0100348 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010088e:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100895:	c0 
c0100896:	c7 04 24 0f 5f 10 c0 	movl   $0xc0105f0f,(%esp)
c010089d:	e8 a6 fa ff ff       	call   c0100348 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a2:	c7 44 24 04 38 5e 10 	movl   $0xc0105e38,0x4(%esp)
c01008a9:	c0 
c01008aa:	c7 04 24 27 5f 10 c0 	movl   $0xc0105f27,(%esp)
c01008b1:	e8 92 fa ff ff       	call   c0100348 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b6:	c7 44 24 04 00 a0 11 	movl   $0xc011a000,0x4(%esp)
c01008bd:	c0 
c01008be:	c7 04 24 3f 5f 10 c0 	movl   $0xc0105f3f,(%esp)
c01008c5:	e8 7e fa ff ff       	call   c0100348 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008ca:	c7 44 24 04 28 af 11 	movl   $0xc011af28,0x4(%esp)
c01008d1:	c0 
c01008d2:	c7 04 24 57 5f 10 c0 	movl   $0xc0105f57,(%esp)
c01008d9:	e8 6a fa ff ff       	call   c0100348 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008de:	b8 28 af 11 c0       	mov    $0xc011af28,%eax
c01008e3:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008e9:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01008ee:	29 c2                	sub    %eax,%edx
c01008f0:	89 d0                	mov    %edx,%eax
c01008f2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f8:	85 c0                	test   %eax,%eax
c01008fa:	0f 48 c2             	cmovs  %edx,%eax
c01008fd:	c1 f8 0a             	sar    $0xa,%eax
c0100900:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100904:	c7 04 24 70 5f 10 c0 	movl   $0xc0105f70,(%esp)
c010090b:	e8 38 fa ff ff       	call   c0100348 <cprintf>
}
c0100910:	c9                   	leave  
c0100911:	c3                   	ret    

c0100912 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100912:	55                   	push   %ebp
c0100913:	89 e5                	mov    %esp,%ebp
c0100915:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010091b:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010091e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100922:	8b 45 08             	mov    0x8(%ebp),%eax
c0100925:	89 04 24             	mov    %eax,(%esp)
c0100928:	e8 12 fc ff ff       	call   c010053f <debuginfo_eip>
c010092d:	85 c0                	test   %eax,%eax
c010092f:	74 15                	je     c0100946 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100931:	8b 45 08             	mov    0x8(%ebp),%eax
c0100934:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100938:	c7 04 24 9a 5f 10 c0 	movl   $0xc0105f9a,(%esp)
c010093f:	e8 04 fa ff ff       	call   c0100348 <cprintf>
c0100944:	eb 6d                	jmp    c01009b3 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100946:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010094d:	eb 1c                	jmp    c010096b <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c010094f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100952:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100955:	01 d0                	add    %edx,%eax
c0100957:	0f b6 00             	movzbl (%eax),%eax
c010095a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100960:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100963:	01 ca                	add    %ecx,%edx
c0100965:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100967:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010096e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100971:	7f dc                	jg     c010094f <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100973:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100979:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097c:	01 d0                	add    %edx,%eax
c010097e:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100981:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100984:	8b 55 08             	mov    0x8(%ebp),%edx
c0100987:	89 d1                	mov    %edx,%ecx
c0100989:	29 c1                	sub    %eax,%ecx
c010098b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010098e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100991:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100995:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010099f:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009a7:	c7 04 24 b6 5f 10 c0 	movl   $0xc0105fb6,(%esp)
c01009ae:	e8 95 f9 ff ff       	call   c0100348 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009b3:	c9                   	leave  
c01009b4:	c3                   	ret    

c01009b5 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b5:	55                   	push   %ebp
c01009b6:	89 e5                	mov    %esp,%ebp
c01009b8:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009bb:	8b 45 04             	mov    0x4(%ebp),%eax
c01009be:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c4:	c9                   	leave  
c01009c5:	c3                   	ret    

c01009c6 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c6:	55                   	push   %ebp
c01009c7:	89 e5                	mov    %esp,%ebp
c01009c9:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cc:	89 e8                	mov    %ebp,%eax
c01009ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
        uint32_t ebp = read_ebp(); //(1) call read_ebp() to get the value of ebp. the type is (uint32_t);
c01009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        uint32_t eip = read_eip(); //(2) call read_eip() to get the value of eip. the type is (uint32_t);
c01009d7:	e8 d9 ff ff ff       	call   c01009b5 <read_eip>
c01009dc:	89 45 f0             	mov    %eax,-0x10(%ebp)

        int i = 0;
c01009df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
        while(ebp != 0 && i < STACKFRAME_DEPTH) {   // (3) from 0 .. STACKFRAME_DEPTH
c01009e6:	e9 88 00 00 00       	jmp    c0100a73 <print_stackframe+0xad>
            cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);       //(3.1) printf value of ebp, eip
c01009eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009ee:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f9:	c7 04 24 c8 5f 10 c0 	movl   $0xc0105fc8,(%esp)
c0100a00:	e8 43 f9 ff ff       	call   c0100348 <cprintf>
            uint32_t *args = (uint32_t *)ebp + 2;      // (3.2) (uint32_t)calling arguments [0..4] = the contents in address (uint32_t)ebp +2 [0..4]                           
c0100a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a08:	83 c0 08             	add    $0x8,%eax
c0100a0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            int j = 0;
c0100a0e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            while(j < 4){           
c0100a15:	eb 25                	jmp    c0100a3c <print_stackframe+0x76>
                cprintf("0x%08x ", args[j]);
c0100a17:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a1a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a24:	01 d0                	add    %edx,%eax
c0100a26:	8b 00                	mov    (%eax),%eax
c0100a28:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a2c:	c7 04 24 e4 5f 10 c0 	movl   $0xc0105fe4,(%esp)
c0100a33:	e8 10 f9 ff ff       	call   c0100348 <cprintf>
                j ++;
c0100a38:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
        int i = 0;
        while(ebp != 0 && i < STACKFRAME_DEPTH) {   // (3) from 0 .. STACKFRAME_DEPTH
            cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);       //(3.1) printf value of ebp, eip
            uint32_t *args = (uint32_t *)ebp + 2;      // (3.2) (uint32_t)calling arguments [0..4] = the contents in address (uint32_t)ebp +2 [0..4]                           
            int j = 0;
            while(j < 4){           
c0100a3c:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a40:	7e d5                	jle    c0100a17 <print_stackframe+0x51>
                cprintf("0x%08x ", args[j]);
                j ++;
            }
            cprintf("\n");      //(3.3) cprintf("\n");
c0100a42:	c7 04 24 ec 5f 10 c0 	movl   $0xc0105fec,(%esp)
c0100a49:	e8 fa f8 ff ff       	call   c0100348 <cprintf>
            print_debuginfo(eip - 1);//(3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
c0100a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a51:	83 e8 01             	sub    $0x1,%eax
c0100a54:	89 04 24             	mov    %eax,(%esp)
c0100a57:	e8 b6 fe ff ff       	call   c0100912 <print_debuginfo>
            eip = ((uint32_t *)ebp)[1]; //(3.5) popup a calling stackframe
c0100a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5f:	83 c0 04             	add    $0x4,%eax
c0100a62:	8b 00                	mov    (%eax),%eax
c0100a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
            ebp = ((uint32_t *)ebp)[0]; 
c0100a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6a:	8b 00                	mov    (%eax),%eax
c0100a6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            i++;
c0100a6f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
      */
        uint32_t ebp = read_ebp(); //(1) call read_ebp() to get the value of ebp. the type is (uint32_t);
        uint32_t eip = read_eip(); //(2) call read_eip() to get the value of eip. the type is (uint32_t);

        int i = 0;
        while(ebp != 0 && i < STACKFRAME_DEPTH) {   // (3) from 0 .. STACKFRAME_DEPTH
c0100a73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a77:	74 0a                	je     c0100a83 <print_stackframe+0xbd>
c0100a79:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a7d:	0f 8e 68 ff ff ff    	jle    c01009eb <print_stackframe+0x25>
            print_debuginfo(eip - 1);//(3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
            eip = ((uint32_t *)ebp)[1]; //(3.5) popup a calling stackframe
            ebp = ((uint32_t *)ebp)[0]; 
            i++;
        }
}
c0100a83:	c9                   	leave  
c0100a84:	c3                   	ret    

c0100a85 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a85:	55                   	push   %ebp
c0100a86:	89 e5                	mov    %esp,%ebp
c0100a88:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a92:	eb 0c                	jmp    c0100aa0 <parse+0x1b>
            *buf ++ = '\0';
c0100a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a97:	8d 50 01             	lea    0x1(%eax),%edx
c0100a9a:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a9d:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aa0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa3:	0f b6 00             	movzbl (%eax),%eax
c0100aa6:	84 c0                	test   %al,%al
c0100aa8:	74 1d                	je     c0100ac7 <parse+0x42>
c0100aaa:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aad:	0f b6 00             	movzbl (%eax),%eax
c0100ab0:	0f be c0             	movsbl %al,%eax
c0100ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab7:	c7 04 24 70 60 10 c0 	movl   $0xc0106070,(%esp)
c0100abe:	e8 2d 50 00 00       	call   c0105af0 <strchr>
c0100ac3:	85 c0                	test   %eax,%eax
c0100ac5:	75 cd                	jne    c0100a94 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ac7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aca:	0f b6 00             	movzbl (%eax),%eax
c0100acd:	84 c0                	test   %al,%al
c0100acf:	75 02                	jne    c0100ad3 <parse+0x4e>
            break;
c0100ad1:	eb 67                	jmp    c0100b3a <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ad3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ad7:	75 14                	jne    c0100aed <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ad9:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ae0:	00 
c0100ae1:	c7 04 24 75 60 10 c0 	movl   $0xc0106075,(%esp)
c0100ae8:	e8 5b f8 ff ff       	call   c0100348 <cprintf>
        }
        argv[argc ++] = buf;
c0100aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af0:	8d 50 01             	lea    0x1(%eax),%edx
c0100af3:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100afd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b00:	01 c2                	add    %eax,%edx
c0100b02:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b05:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b07:	eb 04                	jmp    c0100b0d <parse+0x88>
            buf ++;
c0100b09:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b10:	0f b6 00             	movzbl (%eax),%eax
c0100b13:	84 c0                	test   %al,%al
c0100b15:	74 1d                	je     c0100b34 <parse+0xaf>
c0100b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1a:	0f b6 00             	movzbl (%eax),%eax
c0100b1d:	0f be c0             	movsbl %al,%eax
c0100b20:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b24:	c7 04 24 70 60 10 c0 	movl   $0xc0106070,(%esp)
c0100b2b:	e8 c0 4f 00 00       	call   c0105af0 <strchr>
c0100b30:	85 c0                	test   %eax,%eax
c0100b32:	74 d5                	je     c0100b09 <parse+0x84>
            buf ++;
        }
    }
c0100b34:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b35:	e9 66 ff ff ff       	jmp    c0100aa0 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b3d:	c9                   	leave  
c0100b3e:	c3                   	ret    

c0100b3f <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b3f:	55                   	push   %ebp
c0100b40:	89 e5                	mov    %esp,%ebp
c0100b42:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b45:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b4f:	89 04 24             	mov    %eax,(%esp)
c0100b52:	e8 2e ff ff ff       	call   c0100a85 <parse>
c0100b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b5e:	75 0a                	jne    c0100b6a <runcmd+0x2b>
        return 0;
c0100b60:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b65:	e9 85 00 00 00       	jmp    c0100bef <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b71:	eb 5c                	jmp    c0100bcf <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b73:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b76:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b79:	89 d0                	mov    %edx,%eax
c0100b7b:	01 c0                	add    %eax,%eax
c0100b7d:	01 d0                	add    %edx,%eax
c0100b7f:	c1 e0 02             	shl    $0x2,%eax
c0100b82:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100b87:	8b 00                	mov    (%eax),%eax
c0100b89:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b8d:	89 04 24             	mov    %eax,(%esp)
c0100b90:	e8 bc 4e 00 00       	call   c0105a51 <strcmp>
c0100b95:	85 c0                	test   %eax,%eax
c0100b97:	75 32                	jne    c0100bcb <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b99:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b9c:	89 d0                	mov    %edx,%eax
c0100b9e:	01 c0                	add    %eax,%eax
c0100ba0:	01 d0                	add    %edx,%eax
c0100ba2:	c1 e0 02             	shl    $0x2,%eax
c0100ba5:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100baa:	8b 40 08             	mov    0x8(%eax),%eax
c0100bad:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bb0:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bb6:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bba:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bbd:	83 c2 04             	add    $0x4,%edx
c0100bc0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bc4:	89 0c 24             	mov    %ecx,(%esp)
c0100bc7:	ff d0                	call   *%eax
c0100bc9:	eb 24                	jmp    c0100bef <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bcb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bd2:	83 f8 02             	cmp    $0x2,%eax
c0100bd5:	76 9c                	jbe    c0100b73 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bd7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bda:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bde:	c7 04 24 93 60 10 c0 	movl   $0xc0106093,(%esp)
c0100be5:	e8 5e f7 ff ff       	call   c0100348 <cprintf>
    return 0;
c0100bea:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bef:	c9                   	leave  
c0100bf0:	c3                   	ret    

c0100bf1 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bf1:	55                   	push   %ebp
c0100bf2:	89 e5                	mov    %esp,%ebp
c0100bf4:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bf7:	c7 04 24 ac 60 10 c0 	movl   $0xc01060ac,(%esp)
c0100bfe:	e8 45 f7 ff ff       	call   c0100348 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c03:	c7 04 24 d4 60 10 c0 	movl   $0xc01060d4,(%esp)
c0100c0a:	e8 39 f7 ff ff       	call   c0100348 <cprintf>

    if (tf != NULL) {
c0100c0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c13:	74 0b                	je     c0100c20 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c15:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c18:	89 04 24             	mov    %eax,(%esp)
c0100c1b:	e8 67 0e 00 00       	call   c0101a87 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c20:	c7 04 24 f9 60 10 c0 	movl   $0xc01060f9,(%esp)
c0100c27:	e8 13 f6 ff ff       	call   c010023f <readline>
c0100c2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c33:	74 18                	je     c0100c4d <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c35:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c38:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c3f:	89 04 24             	mov    %eax,(%esp)
c0100c42:	e8 f8 fe ff ff       	call   c0100b3f <runcmd>
c0100c47:	85 c0                	test   %eax,%eax
c0100c49:	79 02                	jns    c0100c4d <kmonitor+0x5c>
                break;
c0100c4b:	eb 02                	jmp    c0100c4f <kmonitor+0x5e>
            }
        }
    }
c0100c4d:	eb d1                	jmp    c0100c20 <kmonitor+0x2f>
}
c0100c4f:	c9                   	leave  
c0100c50:	c3                   	ret    

c0100c51 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c51:	55                   	push   %ebp
c0100c52:	89 e5                	mov    %esp,%ebp
c0100c54:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c5e:	eb 3f                	jmp    c0100c9f <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c60:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c63:	89 d0                	mov    %edx,%eax
c0100c65:	01 c0                	add    %eax,%eax
c0100c67:	01 d0                	add    %edx,%eax
c0100c69:	c1 e0 02             	shl    $0x2,%eax
c0100c6c:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100c71:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c74:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c77:	89 d0                	mov    %edx,%eax
c0100c79:	01 c0                	add    %eax,%eax
c0100c7b:	01 d0                	add    %edx,%eax
c0100c7d:	c1 e0 02             	shl    $0x2,%eax
c0100c80:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100c85:	8b 00                	mov    (%eax),%eax
c0100c87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c8b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c8f:	c7 04 24 fd 60 10 c0 	movl   $0xc01060fd,(%esp)
c0100c96:	e8 ad f6 ff ff       	call   c0100348 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c9b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ca2:	83 f8 02             	cmp    $0x2,%eax
c0100ca5:	76 b9                	jbe    c0100c60 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100ca7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cac:	c9                   	leave  
c0100cad:	c3                   	ret    

c0100cae <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cae:	55                   	push   %ebp
c0100caf:	89 e5                	mov    %esp,%ebp
c0100cb1:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cb4:	e8 c3 fb ff ff       	call   c010087c <print_kerninfo>
    return 0;
c0100cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cbe:	c9                   	leave  
c0100cbf:	c3                   	ret    

c0100cc0 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cc0:	55                   	push   %ebp
c0100cc1:	89 e5                	mov    %esp,%ebp
c0100cc3:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cc6:	e8 fb fc ff ff       	call   c01009c6 <print_stackframe>
    return 0;
c0100ccb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd0:	c9                   	leave  
c0100cd1:	c3                   	ret    

c0100cd2 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cd2:	55                   	push   %ebp
c0100cd3:	89 e5                	mov    %esp,%ebp
c0100cd5:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cd8:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
c0100cdd:	85 c0                	test   %eax,%eax
c0100cdf:	74 02                	je     c0100ce3 <__panic+0x11>
        goto panic_dead;
c0100ce1:	eb 59                	jmp    c0100d3c <__panic+0x6a>
    }
    is_panic = 1;
c0100ce3:	c7 05 20 a4 11 c0 01 	movl   $0x1,0xc011a420
c0100cea:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ced:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cf6:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cfd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d01:	c7 04 24 06 61 10 c0 	movl   $0xc0106106,(%esp)
c0100d08:	e8 3b f6 ff ff       	call   c0100348 <cprintf>
    vcprintf(fmt, ap);
c0100d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d10:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d14:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d17:	89 04 24             	mov    %eax,(%esp)
c0100d1a:	e8 f6 f5 ff ff       	call   c0100315 <vcprintf>
    cprintf("\n");
c0100d1f:	c7 04 24 22 61 10 c0 	movl   $0xc0106122,(%esp)
c0100d26:	e8 1d f6 ff ff       	call   c0100348 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d2b:	c7 04 24 24 61 10 c0 	movl   $0xc0106124,(%esp)
c0100d32:	e8 11 f6 ff ff       	call   c0100348 <cprintf>
    print_stackframe();
c0100d37:	e8 8a fc ff ff       	call   c01009c6 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100d3c:	e8 85 09 00 00       	call   c01016c6 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d48:	e8 a4 fe ff ff       	call   c0100bf1 <kmonitor>
    }
c0100d4d:	eb f2                	jmp    c0100d41 <__panic+0x6f>

c0100d4f <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d4f:	55                   	push   %ebp
c0100d50:	89 e5                	mov    %esp,%ebp
c0100d52:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d55:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d5e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d62:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d65:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d69:	c7 04 24 36 61 10 c0 	movl   $0xc0106136,(%esp)
c0100d70:	e8 d3 f5 ff ff       	call   c0100348 <cprintf>
    vcprintf(fmt, ap);
c0100d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d78:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d7c:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d7f:	89 04 24             	mov    %eax,(%esp)
c0100d82:	e8 8e f5 ff ff       	call   c0100315 <vcprintf>
    cprintf("\n");
c0100d87:	c7 04 24 22 61 10 c0 	movl   $0xc0106122,(%esp)
c0100d8e:	e8 b5 f5 ff ff       	call   c0100348 <cprintf>
    va_end(ap);
}
c0100d93:	c9                   	leave  
c0100d94:	c3                   	ret    

c0100d95 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d95:	55                   	push   %ebp
c0100d96:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d98:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
}
c0100d9d:	5d                   	pop    %ebp
c0100d9e:	c3                   	ret    

c0100d9f <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d9f:	55                   	push   %ebp
c0100da0:	89 e5                	mov    %esp,%ebp
c0100da2:	83 ec 28             	sub    $0x28,%esp
c0100da5:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100dab:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100daf:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100db3:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100db7:	ee                   	out    %al,(%dx)
c0100db8:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100dbe:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dc2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dc6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dca:	ee                   	out    %al,(%dx)
c0100dcb:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dd1:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dd5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dd9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100ddd:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dde:	c7 05 0c af 11 c0 00 	movl   $0x0,0xc011af0c
c0100de5:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100de8:	c7 04 24 54 61 10 c0 	movl   $0xc0106154,(%esp)
c0100def:	e8 54 f5 ff ff       	call   c0100348 <cprintf>
    pic_enable(IRQ_TIMER);
c0100df4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100dfb:	e8 24 09 00 00       	call   c0101724 <pic_enable>
}
c0100e00:	c9                   	leave  
c0100e01:	c3                   	ret    

c0100e02 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e02:	55                   	push   %ebp
c0100e03:	89 e5                	mov    %esp,%ebp
c0100e05:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e08:	9c                   	pushf  
c0100e09:	58                   	pop    %eax
c0100e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e10:	25 00 02 00 00       	and    $0x200,%eax
c0100e15:	85 c0                	test   %eax,%eax
c0100e17:	74 0c                	je     c0100e25 <__intr_save+0x23>
        intr_disable();
c0100e19:	e8 a8 08 00 00       	call   c01016c6 <intr_disable>
        return 1;
c0100e1e:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e23:	eb 05                	jmp    c0100e2a <__intr_save+0x28>
    }
    return 0;
c0100e25:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e2a:	c9                   	leave  
c0100e2b:	c3                   	ret    

c0100e2c <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e2c:	55                   	push   %ebp
c0100e2d:	89 e5                	mov    %esp,%ebp
c0100e2f:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e36:	74 05                	je     c0100e3d <__intr_restore+0x11>
        intr_enable();
c0100e38:	e8 83 08 00 00       	call   c01016c0 <intr_enable>
    }
}
c0100e3d:	c9                   	leave  
c0100e3e:	c3                   	ret    

c0100e3f <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e3f:	55                   	push   %ebp
c0100e40:	89 e5                	mov    %esp,%ebp
c0100e42:	83 ec 10             	sub    $0x10,%esp
c0100e45:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e4b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e4f:	89 c2                	mov    %eax,%edx
c0100e51:	ec                   	in     (%dx),%al
c0100e52:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e55:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e5b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e5f:	89 c2                	mov    %eax,%edx
c0100e61:	ec                   	in     (%dx),%al
c0100e62:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e65:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e6b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e6f:	89 c2                	mov    %eax,%edx
c0100e71:	ec                   	in     (%dx),%al
c0100e72:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e75:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e7b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e7f:	89 c2                	mov    %eax,%edx
c0100e81:	ec                   	in     (%dx),%al
c0100e82:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e85:	c9                   	leave  
c0100e86:	c3                   	ret    

c0100e87 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e87:	55                   	push   %ebp
c0100e88:	89 e5                	mov    %esp,%ebp
c0100e8a:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e8d:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e97:	0f b7 00             	movzwl (%eax),%eax
c0100e9a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea1:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea9:	0f b7 00             	movzwl (%eax),%eax
c0100eac:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100eb0:	74 12                	je     c0100ec4 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100eb2:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eb9:	66 c7 05 46 a4 11 c0 	movw   $0x3b4,0xc011a446
c0100ec0:	b4 03 
c0100ec2:	eb 13                	jmp    c0100ed7 <cga_init+0x50>
    } else {
        *cp = was;
c0100ec4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec7:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ecb:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ece:	66 c7 05 46 a4 11 c0 	movw   $0x3d4,0xc011a446
c0100ed5:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ed7:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100ede:	0f b7 c0             	movzwl %ax,%eax
c0100ee1:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ee5:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ee9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100eed:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ef1:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ef2:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100ef9:	83 c0 01             	add    $0x1,%eax
c0100efc:	0f b7 c0             	movzwl %ax,%eax
c0100eff:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f03:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f07:	89 c2                	mov    %eax,%edx
c0100f09:	ec                   	in     (%dx),%al
c0100f0a:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f0d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f11:	0f b6 c0             	movzbl %al,%eax
c0100f14:	c1 e0 08             	shl    $0x8,%eax
c0100f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f1a:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f21:	0f b7 c0             	movzwl %ax,%eax
c0100f24:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f28:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f2c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f30:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f34:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f35:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f3c:	83 c0 01             	add    $0x1,%eax
c0100f3f:	0f b7 c0             	movzwl %ax,%eax
c0100f42:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f46:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f4a:	89 c2                	mov    %eax,%edx
c0100f4c:	ec                   	in     (%dx),%al
c0100f4d:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f50:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f54:	0f b6 c0             	movzbl %al,%eax
c0100f57:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f5d:	a3 40 a4 11 c0       	mov    %eax,0xc011a440
    crt_pos = pos;
c0100f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f65:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
}
c0100f6b:	c9                   	leave  
c0100f6c:	c3                   	ret    

c0100f6d <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f6d:	55                   	push   %ebp
c0100f6e:	89 e5                	mov    %esp,%ebp
c0100f70:	83 ec 48             	sub    $0x48,%esp
c0100f73:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f79:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f7d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f81:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f85:	ee                   	out    %al,(%dx)
c0100f86:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f8c:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f90:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f94:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f98:	ee                   	out    %al,(%dx)
c0100f99:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f9f:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100fa3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fa7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fab:	ee                   	out    %al,(%dx)
c0100fac:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fb2:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fb6:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fba:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fbe:	ee                   	out    %al,(%dx)
c0100fbf:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fc5:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fc9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fcd:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fd1:	ee                   	out    %al,(%dx)
c0100fd2:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fd8:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fdc:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fe0:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fe4:	ee                   	out    %al,(%dx)
c0100fe5:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100feb:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fef:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100ff3:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100ff7:	ee                   	out    %al,(%dx)
c0100ff8:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ffe:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0101002:	89 c2                	mov    %eax,%edx
c0101004:	ec                   	in     (%dx),%al
c0101005:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0101008:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c010100c:	3c ff                	cmp    $0xff,%al
c010100e:	0f 95 c0             	setne  %al
c0101011:	0f b6 c0             	movzbl %al,%eax
c0101014:	a3 48 a4 11 c0       	mov    %eax,0xc011a448
c0101019:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010101f:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101023:	89 c2                	mov    %eax,%edx
c0101025:	ec                   	in     (%dx),%al
c0101026:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101029:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c010102f:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101033:	89 c2                	mov    %eax,%edx
c0101035:	ec                   	in     (%dx),%al
c0101036:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101039:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c010103e:	85 c0                	test   %eax,%eax
c0101040:	74 0c                	je     c010104e <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101042:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101049:	e8 d6 06 00 00       	call   c0101724 <pic_enable>
    }
}
c010104e:	c9                   	leave  
c010104f:	c3                   	ret    

c0101050 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101050:	55                   	push   %ebp
c0101051:	89 e5                	mov    %esp,%ebp
c0101053:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101056:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010105d:	eb 09                	jmp    c0101068 <lpt_putc_sub+0x18>
        delay();
c010105f:	e8 db fd ff ff       	call   c0100e3f <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101064:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101068:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010106e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101072:	89 c2                	mov    %eax,%edx
c0101074:	ec                   	in     (%dx),%al
c0101075:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101078:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010107c:	84 c0                	test   %al,%al
c010107e:	78 09                	js     c0101089 <lpt_putc_sub+0x39>
c0101080:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101087:	7e d6                	jle    c010105f <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101089:	8b 45 08             	mov    0x8(%ebp),%eax
c010108c:	0f b6 c0             	movzbl %al,%eax
c010108f:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101095:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101098:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010109c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010a0:	ee                   	out    %al,(%dx)
c01010a1:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010a7:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010ab:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010af:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010b3:	ee                   	out    %al,(%dx)
c01010b4:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010ba:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010be:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010c2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010c6:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010c7:	c9                   	leave  
c01010c8:	c3                   	ret    

c01010c9 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010c9:	55                   	push   %ebp
c01010ca:	89 e5                	mov    %esp,%ebp
c01010cc:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010cf:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010d3:	74 0d                	je     c01010e2 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d8:	89 04 24             	mov    %eax,(%esp)
c01010db:	e8 70 ff ff ff       	call   c0101050 <lpt_putc_sub>
c01010e0:	eb 24                	jmp    c0101106 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010e2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e9:	e8 62 ff ff ff       	call   c0101050 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010ee:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010f5:	e8 56 ff ff ff       	call   c0101050 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010fa:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101101:	e8 4a ff ff ff       	call   c0101050 <lpt_putc_sub>
    }
}
c0101106:	c9                   	leave  
c0101107:	c3                   	ret    

c0101108 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101108:	55                   	push   %ebp
c0101109:	89 e5                	mov    %esp,%ebp
c010110b:	53                   	push   %ebx
c010110c:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010110f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101112:	b0 00                	mov    $0x0,%al
c0101114:	85 c0                	test   %eax,%eax
c0101116:	75 07                	jne    c010111f <cga_putc+0x17>
        c |= 0x0700;
c0101118:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010111f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101122:	0f b6 c0             	movzbl %al,%eax
c0101125:	83 f8 0a             	cmp    $0xa,%eax
c0101128:	74 4c                	je     c0101176 <cga_putc+0x6e>
c010112a:	83 f8 0d             	cmp    $0xd,%eax
c010112d:	74 57                	je     c0101186 <cga_putc+0x7e>
c010112f:	83 f8 08             	cmp    $0x8,%eax
c0101132:	0f 85 88 00 00 00    	jne    c01011c0 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101138:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010113f:	66 85 c0             	test   %ax,%ax
c0101142:	74 30                	je     c0101174 <cga_putc+0x6c>
            crt_pos --;
c0101144:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010114b:	83 e8 01             	sub    $0x1,%eax
c010114e:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101154:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101159:	0f b7 15 44 a4 11 c0 	movzwl 0xc011a444,%edx
c0101160:	0f b7 d2             	movzwl %dx,%edx
c0101163:	01 d2                	add    %edx,%edx
c0101165:	01 c2                	add    %eax,%edx
c0101167:	8b 45 08             	mov    0x8(%ebp),%eax
c010116a:	b0 00                	mov    $0x0,%al
c010116c:	83 c8 20             	or     $0x20,%eax
c010116f:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101172:	eb 72                	jmp    c01011e6 <cga_putc+0xde>
c0101174:	eb 70                	jmp    c01011e6 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101176:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010117d:	83 c0 50             	add    $0x50,%eax
c0101180:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101186:	0f b7 1d 44 a4 11 c0 	movzwl 0xc011a444,%ebx
c010118d:	0f b7 0d 44 a4 11 c0 	movzwl 0xc011a444,%ecx
c0101194:	0f b7 c1             	movzwl %cx,%eax
c0101197:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010119d:	c1 e8 10             	shr    $0x10,%eax
c01011a0:	89 c2                	mov    %eax,%edx
c01011a2:	66 c1 ea 06          	shr    $0x6,%dx
c01011a6:	89 d0                	mov    %edx,%eax
c01011a8:	c1 e0 02             	shl    $0x2,%eax
c01011ab:	01 d0                	add    %edx,%eax
c01011ad:	c1 e0 04             	shl    $0x4,%eax
c01011b0:	29 c1                	sub    %eax,%ecx
c01011b2:	89 ca                	mov    %ecx,%edx
c01011b4:	89 d8                	mov    %ebx,%eax
c01011b6:	29 d0                	sub    %edx,%eax
c01011b8:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
        break;
c01011be:	eb 26                	jmp    c01011e6 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011c0:	8b 0d 40 a4 11 c0    	mov    0xc011a440,%ecx
c01011c6:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011cd:	8d 50 01             	lea    0x1(%eax),%edx
c01011d0:	66 89 15 44 a4 11 c0 	mov    %dx,0xc011a444
c01011d7:	0f b7 c0             	movzwl %ax,%eax
c01011da:	01 c0                	add    %eax,%eax
c01011dc:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011df:	8b 45 08             	mov    0x8(%ebp),%eax
c01011e2:	66 89 02             	mov    %ax,(%edx)
        break;
c01011e5:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011e6:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011ed:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011f1:	76 5b                	jbe    c010124e <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011f3:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c01011f8:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011fe:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101203:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c010120a:	00 
c010120b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010120f:	89 04 24             	mov    %eax,(%esp)
c0101212:	e8 d7 4a 00 00       	call   c0105cee <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101217:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010121e:	eb 15                	jmp    c0101235 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101220:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101225:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101228:	01 d2                	add    %edx,%edx
c010122a:	01 d0                	add    %edx,%eax
c010122c:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101231:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101235:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010123c:	7e e2                	jle    c0101220 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010123e:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101245:	83 e8 50             	sub    $0x50,%eax
c0101248:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010124e:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0101255:	0f b7 c0             	movzwl %ax,%eax
c0101258:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010125c:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101260:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101264:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101268:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101269:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101270:	66 c1 e8 08          	shr    $0x8,%ax
c0101274:	0f b6 c0             	movzbl %al,%eax
c0101277:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c010127e:	83 c2 01             	add    $0x1,%edx
c0101281:	0f b7 d2             	movzwl %dx,%edx
c0101284:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101288:	88 45 ed             	mov    %al,-0x13(%ebp)
c010128b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010128f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101293:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101294:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c010129b:	0f b7 c0             	movzwl %ax,%eax
c010129e:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01012a2:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012a6:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012aa:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012ae:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012af:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01012b6:	0f b6 c0             	movzbl %al,%eax
c01012b9:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c01012c0:	83 c2 01             	add    $0x1,%edx
c01012c3:	0f b7 d2             	movzwl %dx,%edx
c01012c6:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012ca:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012cd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012d1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012d5:	ee                   	out    %al,(%dx)
}
c01012d6:	83 c4 34             	add    $0x34,%esp
c01012d9:	5b                   	pop    %ebx
c01012da:	5d                   	pop    %ebp
c01012db:	c3                   	ret    

c01012dc <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012dc:	55                   	push   %ebp
c01012dd:	89 e5                	mov    %esp,%ebp
c01012df:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012e9:	eb 09                	jmp    c01012f4 <serial_putc_sub+0x18>
        delay();
c01012eb:	e8 4f fb ff ff       	call   c0100e3f <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012f0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012f4:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012fa:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012fe:	89 c2                	mov    %eax,%edx
c0101300:	ec                   	in     (%dx),%al
c0101301:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101304:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101308:	0f b6 c0             	movzbl %al,%eax
c010130b:	83 e0 20             	and    $0x20,%eax
c010130e:	85 c0                	test   %eax,%eax
c0101310:	75 09                	jne    c010131b <serial_putc_sub+0x3f>
c0101312:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101319:	7e d0                	jle    c01012eb <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c010131b:	8b 45 08             	mov    0x8(%ebp),%eax
c010131e:	0f b6 c0             	movzbl %al,%eax
c0101321:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101327:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010132a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010132e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101332:	ee                   	out    %al,(%dx)
}
c0101333:	c9                   	leave  
c0101334:	c3                   	ret    

c0101335 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101335:	55                   	push   %ebp
c0101336:	89 e5                	mov    %esp,%ebp
c0101338:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010133b:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010133f:	74 0d                	je     c010134e <serial_putc+0x19>
        serial_putc_sub(c);
c0101341:	8b 45 08             	mov    0x8(%ebp),%eax
c0101344:	89 04 24             	mov    %eax,(%esp)
c0101347:	e8 90 ff ff ff       	call   c01012dc <serial_putc_sub>
c010134c:	eb 24                	jmp    c0101372 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010134e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101355:	e8 82 ff ff ff       	call   c01012dc <serial_putc_sub>
        serial_putc_sub(' ');
c010135a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101361:	e8 76 ff ff ff       	call   c01012dc <serial_putc_sub>
        serial_putc_sub('\b');
c0101366:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010136d:	e8 6a ff ff ff       	call   c01012dc <serial_putc_sub>
    }
}
c0101372:	c9                   	leave  
c0101373:	c3                   	ret    

c0101374 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101374:	55                   	push   %ebp
c0101375:	89 e5                	mov    %esp,%ebp
c0101377:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010137a:	eb 33                	jmp    c01013af <cons_intr+0x3b>
        if (c != 0) {
c010137c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101380:	74 2d                	je     c01013af <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101382:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c0101387:	8d 50 01             	lea    0x1(%eax),%edx
c010138a:	89 15 64 a6 11 c0    	mov    %edx,0xc011a664
c0101390:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101393:	88 90 60 a4 11 c0    	mov    %dl,-0x3fee5ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101399:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c010139e:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013a3:	75 0a                	jne    c01013af <cons_intr+0x3b>
                cons.wpos = 0;
c01013a5:	c7 05 64 a6 11 c0 00 	movl   $0x0,0xc011a664
c01013ac:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013af:	8b 45 08             	mov    0x8(%ebp),%eax
c01013b2:	ff d0                	call   *%eax
c01013b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013b7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013bb:	75 bf                	jne    c010137c <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013bd:	c9                   	leave  
c01013be:	c3                   	ret    

c01013bf <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013bf:	55                   	push   %ebp
c01013c0:	89 e5                	mov    %esp,%ebp
c01013c2:	83 ec 10             	sub    $0x10,%esp
c01013c5:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013cb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013cf:	89 c2                	mov    %eax,%edx
c01013d1:	ec                   	in     (%dx),%al
c01013d2:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013d5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013d9:	0f b6 c0             	movzbl %al,%eax
c01013dc:	83 e0 01             	and    $0x1,%eax
c01013df:	85 c0                	test   %eax,%eax
c01013e1:	75 07                	jne    c01013ea <serial_proc_data+0x2b>
        return -1;
c01013e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013e8:	eb 2a                	jmp    c0101414 <serial_proc_data+0x55>
c01013ea:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013f0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013f4:	89 c2                	mov    %eax,%edx
c01013f6:	ec                   	in     (%dx),%al
c01013f7:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013fa:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013fe:	0f b6 c0             	movzbl %al,%eax
c0101401:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101404:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101408:	75 07                	jne    c0101411 <serial_proc_data+0x52>
        c = '\b';
c010140a:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101411:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101414:	c9                   	leave  
c0101415:	c3                   	ret    

c0101416 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101416:	55                   	push   %ebp
c0101417:	89 e5                	mov    %esp,%ebp
c0101419:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010141c:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0101421:	85 c0                	test   %eax,%eax
c0101423:	74 0c                	je     c0101431 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101425:	c7 04 24 bf 13 10 c0 	movl   $0xc01013bf,(%esp)
c010142c:	e8 43 ff ff ff       	call   c0101374 <cons_intr>
    }
}
c0101431:	c9                   	leave  
c0101432:	c3                   	ret    

c0101433 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101433:	55                   	push   %ebp
c0101434:	89 e5                	mov    %esp,%ebp
c0101436:	83 ec 38             	sub    $0x38,%esp
c0101439:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010143f:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101443:	89 c2                	mov    %eax,%edx
c0101445:	ec                   	in     (%dx),%al
c0101446:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101449:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010144d:	0f b6 c0             	movzbl %al,%eax
c0101450:	83 e0 01             	and    $0x1,%eax
c0101453:	85 c0                	test   %eax,%eax
c0101455:	75 0a                	jne    c0101461 <kbd_proc_data+0x2e>
        return -1;
c0101457:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010145c:	e9 59 01 00 00       	jmp    c01015ba <kbd_proc_data+0x187>
c0101461:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101467:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010146b:	89 c2                	mov    %eax,%edx
c010146d:	ec                   	in     (%dx),%al
c010146e:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101471:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101475:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101478:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010147c:	75 17                	jne    c0101495 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010147e:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101483:	83 c8 40             	or     $0x40,%eax
c0101486:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c010148b:	b8 00 00 00 00       	mov    $0x0,%eax
c0101490:	e9 25 01 00 00       	jmp    c01015ba <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101499:	84 c0                	test   %al,%al
c010149b:	79 47                	jns    c01014e4 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010149d:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014a2:	83 e0 40             	and    $0x40,%eax
c01014a5:	85 c0                	test   %eax,%eax
c01014a7:	75 09                	jne    c01014b2 <kbd_proc_data+0x7f>
c01014a9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ad:	83 e0 7f             	and    $0x7f,%eax
c01014b0:	eb 04                	jmp    c01014b6 <kbd_proc_data+0x83>
c01014b2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b6:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014b9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014bd:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c01014c4:	83 c8 40             	or     $0x40,%eax
c01014c7:	0f b6 c0             	movzbl %al,%eax
c01014ca:	f7 d0                	not    %eax
c01014cc:	89 c2                	mov    %eax,%edx
c01014ce:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014d3:	21 d0                	and    %edx,%eax
c01014d5:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c01014da:	b8 00 00 00 00       	mov    $0x0,%eax
c01014df:	e9 d6 00 00 00       	jmp    c01015ba <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014e4:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014e9:	83 e0 40             	and    $0x40,%eax
c01014ec:	85 c0                	test   %eax,%eax
c01014ee:	74 11                	je     c0101501 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014f0:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014f4:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014f9:	83 e0 bf             	and    $0xffffffbf,%eax
c01014fc:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    }

    shift |= shiftcode[data];
c0101501:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101505:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c010150c:	0f b6 d0             	movzbl %al,%edx
c010150f:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101514:	09 d0                	or     %edx,%eax
c0101516:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    shift ^= togglecode[data];
c010151b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010151f:	0f b6 80 40 71 11 c0 	movzbl -0x3fee8ec0(%eax),%eax
c0101526:	0f b6 d0             	movzbl %al,%edx
c0101529:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010152e:	31 d0                	xor    %edx,%eax
c0101530:	a3 68 a6 11 c0       	mov    %eax,0xc011a668

    c = charcode[shift & (CTL | SHIFT)][data];
c0101535:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010153a:	83 e0 03             	and    $0x3,%eax
c010153d:	8b 14 85 40 75 11 c0 	mov    -0x3fee8ac0(,%eax,4),%edx
c0101544:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101548:	01 d0                	add    %edx,%eax
c010154a:	0f b6 00             	movzbl (%eax),%eax
c010154d:	0f b6 c0             	movzbl %al,%eax
c0101550:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101553:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101558:	83 e0 08             	and    $0x8,%eax
c010155b:	85 c0                	test   %eax,%eax
c010155d:	74 22                	je     c0101581 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010155f:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101563:	7e 0c                	jle    c0101571 <kbd_proc_data+0x13e>
c0101565:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101569:	7f 06                	jg     c0101571 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010156b:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010156f:	eb 10                	jmp    c0101581 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101571:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101575:	7e 0a                	jle    c0101581 <kbd_proc_data+0x14e>
c0101577:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010157b:	7f 04                	jg     c0101581 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010157d:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101581:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101586:	f7 d0                	not    %eax
c0101588:	83 e0 06             	and    $0x6,%eax
c010158b:	85 c0                	test   %eax,%eax
c010158d:	75 28                	jne    c01015b7 <kbd_proc_data+0x184>
c010158f:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101596:	75 1f                	jne    c01015b7 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101598:	c7 04 24 6f 61 10 c0 	movl   $0xc010616f,(%esp)
c010159f:	e8 a4 ed ff ff       	call   c0100348 <cprintf>
c01015a4:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015aa:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015ae:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015b2:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015b6:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015ba:	c9                   	leave  
c01015bb:	c3                   	ret    

c01015bc <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015bc:	55                   	push   %ebp
c01015bd:	89 e5                	mov    %esp,%ebp
c01015bf:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015c2:	c7 04 24 33 14 10 c0 	movl   $0xc0101433,(%esp)
c01015c9:	e8 a6 fd ff ff       	call   c0101374 <cons_intr>
}
c01015ce:	c9                   	leave  
c01015cf:	c3                   	ret    

c01015d0 <kbd_init>:

static void
kbd_init(void) {
c01015d0:	55                   	push   %ebp
c01015d1:	89 e5                	mov    %esp,%ebp
c01015d3:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015d6:	e8 e1 ff ff ff       	call   c01015bc <kbd_intr>
    pic_enable(IRQ_KBD);
c01015db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015e2:	e8 3d 01 00 00       	call   c0101724 <pic_enable>
}
c01015e7:	c9                   	leave  
c01015e8:	c3                   	ret    

c01015e9 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015e9:	55                   	push   %ebp
c01015ea:	89 e5                	mov    %esp,%ebp
c01015ec:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015ef:	e8 93 f8 ff ff       	call   c0100e87 <cga_init>
    serial_init();
c01015f4:	e8 74 f9 ff ff       	call   c0100f6d <serial_init>
    kbd_init();
c01015f9:	e8 d2 ff ff ff       	call   c01015d0 <kbd_init>
    if (!serial_exists) {
c01015fe:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0101603:	85 c0                	test   %eax,%eax
c0101605:	75 0c                	jne    c0101613 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101607:	c7 04 24 7b 61 10 c0 	movl   $0xc010617b,(%esp)
c010160e:	e8 35 ed ff ff       	call   c0100348 <cprintf>
    }
}
c0101613:	c9                   	leave  
c0101614:	c3                   	ret    

c0101615 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101615:	55                   	push   %ebp
c0101616:	89 e5                	mov    %esp,%ebp
c0101618:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010161b:	e8 e2 f7 ff ff       	call   c0100e02 <__intr_save>
c0101620:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101623:	8b 45 08             	mov    0x8(%ebp),%eax
c0101626:	89 04 24             	mov    %eax,(%esp)
c0101629:	e8 9b fa ff ff       	call   c01010c9 <lpt_putc>
        cga_putc(c);
c010162e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101631:	89 04 24             	mov    %eax,(%esp)
c0101634:	e8 cf fa ff ff       	call   c0101108 <cga_putc>
        serial_putc(c);
c0101639:	8b 45 08             	mov    0x8(%ebp),%eax
c010163c:	89 04 24             	mov    %eax,(%esp)
c010163f:	e8 f1 fc ff ff       	call   c0101335 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101644:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101647:	89 04 24             	mov    %eax,(%esp)
c010164a:	e8 dd f7 ff ff       	call   c0100e2c <__intr_restore>
}
c010164f:	c9                   	leave  
c0101650:	c3                   	ret    

c0101651 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101651:	55                   	push   %ebp
c0101652:	89 e5                	mov    %esp,%ebp
c0101654:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101657:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010165e:	e8 9f f7 ff ff       	call   c0100e02 <__intr_save>
c0101663:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101666:	e8 ab fd ff ff       	call   c0101416 <serial_intr>
        kbd_intr();
c010166b:	e8 4c ff ff ff       	call   c01015bc <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101670:	8b 15 60 a6 11 c0    	mov    0xc011a660,%edx
c0101676:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c010167b:	39 c2                	cmp    %eax,%edx
c010167d:	74 31                	je     c01016b0 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010167f:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c0101684:	8d 50 01             	lea    0x1(%eax),%edx
c0101687:	89 15 60 a6 11 c0    	mov    %edx,0xc011a660
c010168d:	0f b6 80 60 a4 11 c0 	movzbl -0x3fee5ba0(%eax),%eax
c0101694:	0f b6 c0             	movzbl %al,%eax
c0101697:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010169a:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c010169f:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016a4:	75 0a                	jne    c01016b0 <cons_getc+0x5f>
                cons.rpos = 0;
c01016a6:	c7 05 60 a6 11 c0 00 	movl   $0x0,0xc011a660
c01016ad:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016b3:	89 04 24             	mov    %eax,(%esp)
c01016b6:	e8 71 f7 ff ff       	call   c0100e2c <__intr_restore>
    return c;
c01016bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016be:	c9                   	leave  
c01016bf:	c3                   	ret    

c01016c0 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016c0:	55                   	push   %ebp
c01016c1:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016c3:	fb                   	sti    
    sti();
}
c01016c4:	5d                   	pop    %ebp
c01016c5:	c3                   	ret    

c01016c6 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016c6:	55                   	push   %ebp
c01016c7:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016c9:	fa                   	cli    
    cli();
}
c01016ca:	5d                   	pop    %ebp
c01016cb:	c3                   	ret    

c01016cc <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016cc:	55                   	push   %ebp
c01016cd:	89 e5                	mov    %esp,%ebp
c01016cf:	83 ec 14             	sub    $0x14,%esp
c01016d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01016d5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016d9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016dd:	66 a3 50 75 11 c0    	mov    %ax,0xc0117550
    if (did_init) {
c01016e3:	a1 6c a6 11 c0       	mov    0xc011a66c,%eax
c01016e8:	85 c0                	test   %eax,%eax
c01016ea:	74 36                	je     c0101722 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016ec:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016f0:	0f b6 c0             	movzbl %al,%eax
c01016f3:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016f9:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016fc:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101700:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101704:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101705:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101709:	66 c1 e8 08          	shr    $0x8,%ax
c010170d:	0f b6 c0             	movzbl %al,%eax
c0101710:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101716:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101719:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010171d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101721:	ee                   	out    %al,(%dx)
    }
}
c0101722:	c9                   	leave  
c0101723:	c3                   	ret    

c0101724 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101724:	55                   	push   %ebp
c0101725:	89 e5                	mov    %esp,%ebp
c0101727:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010172a:	8b 45 08             	mov    0x8(%ebp),%eax
c010172d:	ba 01 00 00 00       	mov    $0x1,%edx
c0101732:	89 c1                	mov    %eax,%ecx
c0101734:	d3 e2                	shl    %cl,%edx
c0101736:	89 d0                	mov    %edx,%eax
c0101738:	f7 d0                	not    %eax
c010173a:	89 c2                	mov    %eax,%edx
c010173c:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101743:	21 d0                	and    %edx,%eax
c0101745:	0f b7 c0             	movzwl %ax,%eax
c0101748:	89 04 24             	mov    %eax,(%esp)
c010174b:	e8 7c ff ff ff       	call   c01016cc <pic_setmask>
}
c0101750:	c9                   	leave  
c0101751:	c3                   	ret    

c0101752 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101752:	55                   	push   %ebp
c0101753:	89 e5                	mov    %esp,%ebp
c0101755:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101758:	c7 05 6c a6 11 c0 01 	movl   $0x1,0xc011a66c
c010175f:	00 00 00 
c0101762:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101768:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c010176c:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101770:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101774:	ee                   	out    %al,(%dx)
c0101775:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010177b:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c010177f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101783:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101787:	ee                   	out    %al,(%dx)
c0101788:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010178e:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101792:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101796:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010179a:	ee                   	out    %al,(%dx)
c010179b:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c01017a1:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c01017a5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01017a9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017ad:	ee                   	out    %al,(%dx)
c01017ae:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01017b4:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017b8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017bc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017c0:	ee                   	out    %al,(%dx)
c01017c1:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017c7:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017cb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017cf:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017d3:	ee                   	out    %al,(%dx)
c01017d4:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017da:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017de:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017e2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017e6:	ee                   	out    %al,(%dx)
c01017e7:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017ed:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017f1:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017f5:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017f9:	ee                   	out    %al,(%dx)
c01017fa:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0101800:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0101804:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101808:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010180c:	ee                   	out    %al,(%dx)
c010180d:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0101813:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101817:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010181b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010181f:	ee                   	out    %al,(%dx)
c0101820:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101826:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c010182a:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010182e:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101832:	ee                   	out    %al,(%dx)
c0101833:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101839:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c010183d:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101841:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101845:	ee                   	out    %al,(%dx)
c0101846:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c010184c:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101850:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101854:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101858:	ee                   	out    %al,(%dx)
c0101859:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c010185f:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101863:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101867:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010186b:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010186c:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101873:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101877:	74 12                	je     c010188b <pic_init+0x139>
        pic_setmask(irq_mask);
c0101879:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101880:	0f b7 c0             	movzwl %ax,%eax
c0101883:	89 04 24             	mov    %eax,(%esp)
c0101886:	e8 41 fe ff ff       	call   c01016cc <pic_setmask>
    }
}
c010188b:	c9                   	leave  
c010188c:	c3                   	ret    

c010188d <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010188d:	55                   	push   %ebp
c010188e:	89 e5                	mov    %esp,%ebp
c0101890:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101893:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010189a:	00 
c010189b:	c7 04 24 a0 61 10 c0 	movl   $0xc01061a0,(%esp)
c01018a2:	e8 a1 ea ff ff       	call   c0100348 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01018a7:	c7 04 24 aa 61 10 c0 	movl   $0xc01061aa,(%esp)
c01018ae:	e8 95 ea ff ff       	call   c0100348 <cprintf>
    panic("EOT: kernel seems ok.");
c01018b3:	c7 44 24 08 b8 61 10 	movl   $0xc01061b8,0x8(%esp)
c01018ba:	c0 
c01018bb:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01018c2:	00 
c01018c3:	c7 04 24 ce 61 10 c0 	movl   $0xc01061ce,(%esp)
c01018ca:	e8 03 f4 ff ff       	call   c0100cd2 <__panic>

c01018cf <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018cf:	55                   	push   %ebp
c01018d0:	89 e5                	mov    %esp,%ebp
c01018d2:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];   //define ISR's entry addrs _vectors[]
    int i = 0;
c01018d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    //arguments：0 means interrupt，GD_KTEXT means kernel text
    //use SETGATE macro to setup each item of IDT
    while(i < sizeof(idt) / sizeof(struct gatedesc)) {
c01018dc:	e9 c3 00 00 00       	jmp    c01019a4 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e4:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c01018eb:	89 c2                	mov    %eax,%edx
c01018ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f0:	66 89 14 c5 80 a6 11 	mov    %dx,-0x3fee5980(,%eax,8)
c01018f7:	c0 
c01018f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018fb:	66 c7 04 c5 82 a6 11 	movw   $0x8,-0x3fee597e(,%eax,8)
c0101902:	c0 08 00 
c0101905:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101908:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c010190f:	c0 
c0101910:	83 e2 e0             	and    $0xffffffe0,%edx
c0101913:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c010191a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010191d:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c0101924:	c0 
c0101925:	83 e2 1f             	and    $0x1f,%edx
c0101928:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c010192f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101932:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101939:	c0 
c010193a:	83 e2 f0             	and    $0xfffffff0,%edx
c010193d:	83 ca 0e             	or     $0xe,%edx
c0101940:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101947:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010194a:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101951:	c0 
c0101952:	83 e2 ef             	and    $0xffffffef,%edx
c0101955:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c010195c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195f:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101966:	c0 
c0101967:	83 e2 9f             	and    $0xffffff9f,%edx
c010196a:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101971:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101974:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c010197b:	c0 
c010197c:	83 ca 80             	or     $0xffffff80,%edx
c010197f:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101986:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101989:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c0101990:	c1 e8 10             	shr    $0x10,%eax
c0101993:	89 c2                	mov    %eax,%edx
c0101995:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101998:	66 89 14 c5 86 a6 11 	mov    %dx,-0x3fee597a(,%eax,8)
c010199f:	c0 
        i ++;
c01019a0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
      */
    extern uintptr_t __vectors[];   //define ISR's entry addrs _vectors[]
    int i = 0;
    //arguments：0 means interrupt，GD_KTEXT means kernel text
    //use SETGATE macro to setup each item of IDT
    while(i < sizeof(idt) / sizeof(struct gatedesc)) {
c01019a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a7:	3d ff 00 00 00       	cmp    $0xff,%eax
c01019ac:	0f 86 2f ff ff ff    	jbe    c01018e1 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
        i ++;
    }
    // switch from user state to kernel state
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c01019b2:	a1 c4 77 11 c0       	mov    0xc01177c4,%eax
c01019b7:	66 a3 48 aa 11 c0    	mov    %ax,0xc011aa48
c01019bd:	66 c7 05 4a aa 11 c0 	movw   $0x8,0xc011aa4a
c01019c4:	08 00 
c01019c6:	0f b6 05 4c aa 11 c0 	movzbl 0xc011aa4c,%eax
c01019cd:	83 e0 e0             	and    $0xffffffe0,%eax
c01019d0:	a2 4c aa 11 c0       	mov    %al,0xc011aa4c
c01019d5:	0f b6 05 4c aa 11 c0 	movzbl 0xc011aa4c,%eax
c01019dc:	83 e0 1f             	and    $0x1f,%eax
c01019df:	a2 4c aa 11 c0       	mov    %al,0xc011aa4c
c01019e4:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c01019eb:	83 e0 f0             	and    $0xfffffff0,%eax
c01019ee:	83 c8 0e             	or     $0xe,%eax
c01019f1:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c01019f6:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c01019fd:	83 e0 ef             	and    $0xffffffef,%eax
c0101a00:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101a05:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c0101a0c:	83 c8 60             	or     $0x60,%eax
c0101a0f:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101a14:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c0101a1b:	83 c8 80             	or     $0xffffff80,%eax
c0101a1e:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101a23:	a1 c4 77 11 c0       	mov    0xc01177c4,%eax
c0101a28:	c1 e8 10             	shr    $0x10,%eax
c0101a2b:	66 a3 4e aa 11 c0    	mov    %ax,0xc011aa4e
c0101a31:	c7 45 f8 60 75 11 c0 	movl   $0xc0117560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a38:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a3b:	0f 01 18             	lidtl  (%eax)
    //let CPU know where is IDT by using 'lidt' instruction
    lidt(&idt_pd);
}
c0101a3e:	c9                   	leave  
c0101a3f:	c3                   	ret    

c0101a40 <trapname>:

static const char *
trapname(int trapno) {
c0101a40:	55                   	push   %ebp
c0101a41:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a43:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a46:	83 f8 13             	cmp    $0x13,%eax
c0101a49:	77 0c                	ja     c0101a57 <trapname+0x17>
        return excnames[trapno];
c0101a4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a4e:	8b 04 85 20 65 10 c0 	mov    -0x3fef9ae0(,%eax,4),%eax
c0101a55:	eb 18                	jmp    c0101a6f <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a57:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a5b:	7e 0d                	jle    c0101a6a <trapname+0x2a>
c0101a5d:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a61:	7f 07                	jg     c0101a6a <trapname+0x2a>
        return "Hardware Interrupt";
c0101a63:	b8 df 61 10 c0       	mov    $0xc01061df,%eax
c0101a68:	eb 05                	jmp    c0101a6f <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a6a:	b8 f2 61 10 c0       	mov    $0xc01061f2,%eax
}
c0101a6f:	5d                   	pop    %ebp
c0101a70:	c3                   	ret    

c0101a71 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a71:	55                   	push   %ebp
c0101a72:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a74:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a77:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a7b:	66 83 f8 08          	cmp    $0x8,%ax
c0101a7f:	0f 94 c0             	sete   %al
c0101a82:	0f b6 c0             	movzbl %al,%eax
}
c0101a85:	5d                   	pop    %ebp
c0101a86:	c3                   	ret    

c0101a87 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a87:	55                   	push   %ebp
c0101a88:	89 e5                	mov    %esp,%ebp
c0101a8a:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a90:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a94:	c7 04 24 33 62 10 c0 	movl   $0xc0106233,(%esp)
c0101a9b:	e8 a8 e8 ff ff       	call   c0100348 <cprintf>
    print_regs(&tf->tf_regs);
c0101aa0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa3:	89 04 24             	mov    %eax,(%esp)
c0101aa6:	e8 a1 01 00 00       	call   c0101c4c <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101aab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aae:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101ab2:	0f b7 c0             	movzwl %ax,%eax
c0101ab5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ab9:	c7 04 24 44 62 10 c0 	movl   $0xc0106244,(%esp)
c0101ac0:	e8 83 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101ac5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac8:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101acc:	0f b7 c0             	movzwl %ax,%eax
c0101acf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ad3:	c7 04 24 57 62 10 c0 	movl   $0xc0106257,(%esp)
c0101ada:	e8 69 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101adf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae2:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101ae6:	0f b7 c0             	movzwl %ax,%eax
c0101ae9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aed:	c7 04 24 6a 62 10 c0 	movl   $0xc010626a,(%esp)
c0101af4:	e8 4f e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101af9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101afc:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b00:	0f b7 c0             	movzwl %ax,%eax
c0101b03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b07:	c7 04 24 7d 62 10 c0 	movl   $0xc010627d,(%esp)
c0101b0e:	e8 35 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b13:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b16:	8b 40 30             	mov    0x30(%eax),%eax
c0101b19:	89 04 24             	mov    %eax,(%esp)
c0101b1c:	e8 1f ff ff ff       	call   c0101a40 <trapname>
c0101b21:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b24:	8b 52 30             	mov    0x30(%edx),%edx
c0101b27:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101b2b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101b2f:	c7 04 24 90 62 10 c0 	movl   $0xc0106290,(%esp)
c0101b36:	e8 0d e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3e:	8b 40 34             	mov    0x34(%eax),%eax
c0101b41:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b45:	c7 04 24 a2 62 10 c0 	movl   $0xc01062a2,(%esp)
c0101b4c:	e8 f7 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b54:	8b 40 38             	mov    0x38(%eax),%eax
c0101b57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5b:	c7 04 24 b1 62 10 c0 	movl   $0xc01062b1,(%esp)
c0101b62:	e8 e1 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b67:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b6e:	0f b7 c0             	movzwl %ax,%eax
c0101b71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b75:	c7 04 24 c0 62 10 c0 	movl   $0xc01062c0,(%esp)
c0101b7c:	e8 c7 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b81:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b84:	8b 40 40             	mov    0x40(%eax),%eax
c0101b87:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b8b:	c7 04 24 d3 62 10 c0 	movl   $0xc01062d3,(%esp)
c0101b92:	e8 b1 e7 ff ff       	call   c0100348 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b9e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101ba5:	eb 3e                	jmp    c0101be5 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101ba7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101baa:	8b 50 40             	mov    0x40(%eax),%edx
c0101bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101bb0:	21 d0                	and    %edx,%eax
c0101bb2:	85 c0                	test   %eax,%eax
c0101bb4:	74 28                	je     c0101bde <print_trapframe+0x157>
c0101bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bb9:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101bc0:	85 c0                	test   %eax,%eax
c0101bc2:	74 1a                	je     c0101bde <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bc7:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101bce:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bd2:	c7 04 24 e2 62 10 c0 	movl   $0xc01062e2,(%esp)
c0101bd9:	e8 6a e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bde:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101be2:	d1 65 f0             	shll   -0x10(%ebp)
c0101be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101be8:	83 f8 17             	cmp    $0x17,%eax
c0101beb:	76 ba                	jbe    c0101ba7 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bed:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf0:	8b 40 40             	mov    0x40(%eax),%eax
c0101bf3:	25 00 30 00 00       	and    $0x3000,%eax
c0101bf8:	c1 e8 0c             	shr    $0xc,%eax
c0101bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bff:	c7 04 24 e6 62 10 c0 	movl   $0xc01062e6,(%esp)
c0101c06:	e8 3d e7 ff ff       	call   c0100348 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101c0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c0e:	89 04 24             	mov    %eax,(%esp)
c0101c11:	e8 5b fe ff ff       	call   c0101a71 <trap_in_kernel>
c0101c16:	85 c0                	test   %eax,%eax
c0101c18:	75 30                	jne    c0101c4a <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1d:	8b 40 44             	mov    0x44(%eax),%eax
c0101c20:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c24:	c7 04 24 ef 62 10 c0 	movl   $0xc01062ef,(%esp)
c0101c2b:	e8 18 e7 ff ff       	call   c0100348 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c33:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c37:	0f b7 c0             	movzwl %ax,%eax
c0101c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c3e:	c7 04 24 fe 62 10 c0 	movl   $0xc01062fe,(%esp)
c0101c45:	e8 fe e6 ff ff       	call   c0100348 <cprintf>
    }
}
c0101c4a:	c9                   	leave  
c0101c4b:	c3                   	ret    

c0101c4c <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c4c:	55                   	push   %ebp
c0101c4d:	89 e5                	mov    %esp,%ebp
c0101c4f:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c52:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c55:	8b 00                	mov    (%eax),%eax
c0101c57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c5b:	c7 04 24 11 63 10 c0 	movl   $0xc0106311,(%esp)
c0101c62:	e8 e1 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c67:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c6a:	8b 40 04             	mov    0x4(%eax),%eax
c0101c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c71:	c7 04 24 20 63 10 c0 	movl   $0xc0106320,(%esp)
c0101c78:	e8 cb e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c80:	8b 40 08             	mov    0x8(%eax),%eax
c0101c83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c87:	c7 04 24 2f 63 10 c0 	movl   $0xc010632f,(%esp)
c0101c8e:	e8 b5 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c93:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c96:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c99:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c9d:	c7 04 24 3e 63 10 c0 	movl   $0xc010633e,(%esp)
c0101ca4:	e8 9f e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cac:	8b 40 10             	mov    0x10(%eax),%eax
c0101caf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb3:	c7 04 24 4d 63 10 c0 	movl   $0xc010634d,(%esp)
c0101cba:	e8 89 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101cbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc2:	8b 40 14             	mov    0x14(%eax),%eax
c0101cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc9:	c7 04 24 5c 63 10 c0 	movl   $0xc010635c,(%esp)
c0101cd0:	e8 73 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd8:	8b 40 18             	mov    0x18(%eax),%eax
c0101cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cdf:	c7 04 24 6b 63 10 c0 	movl   $0xc010636b,(%esp)
c0101ce6:	e8 5d e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101ceb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cee:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cf5:	c7 04 24 7a 63 10 c0 	movl   $0xc010637a,(%esp)
c0101cfc:	e8 47 e6 ff ff       	call   c0100348 <cprintf>
}
c0101d01:	c9                   	leave  
c0101d02:	c3                   	ret    

c0101d03 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d03:	55                   	push   %ebp
c0101d04:	89 e5                	mov    %esp,%ebp
c0101d06:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d09:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d0c:	8b 40 30             	mov    0x30(%eax),%eax
c0101d0f:	83 f8 2f             	cmp    $0x2f,%eax
c0101d12:	77 21                	ja     c0101d35 <trap_dispatch+0x32>
c0101d14:	83 f8 2e             	cmp    $0x2e,%eax
c0101d17:	0f 83 04 01 00 00    	jae    c0101e21 <trap_dispatch+0x11e>
c0101d1d:	83 f8 21             	cmp    $0x21,%eax
c0101d20:	0f 84 81 00 00 00    	je     c0101da7 <trap_dispatch+0xa4>
c0101d26:	83 f8 24             	cmp    $0x24,%eax
c0101d29:	74 56                	je     c0101d81 <trap_dispatch+0x7e>
c0101d2b:	83 f8 20             	cmp    $0x20,%eax
c0101d2e:	74 16                	je     c0101d46 <trap_dispatch+0x43>
c0101d30:	e9 b4 00 00 00       	jmp    c0101de9 <trap_dispatch+0xe6>
c0101d35:	83 e8 78             	sub    $0x78,%eax
c0101d38:	83 f8 01             	cmp    $0x1,%eax
c0101d3b:	0f 87 a8 00 00 00    	ja     c0101de9 <trap_dispatch+0xe6>
c0101d41:	e9 87 00 00 00       	jmp    c0101dcd <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
c0101d46:	a1 0c af 11 c0       	mov    0xc011af0c,%eax
c0101d4b:	83 c0 01             	add    $0x1,%eax
c0101d4e:	a3 0c af 11 c0       	mov    %eax,0xc011af0c
        if (ticks % TICK_NUM == 0) {
c0101d53:	8b 0d 0c af 11 c0    	mov    0xc011af0c,%ecx
c0101d59:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d5e:	89 c8                	mov    %ecx,%eax
c0101d60:	f7 e2                	mul    %edx
c0101d62:	89 d0                	mov    %edx,%eax
c0101d64:	c1 e8 05             	shr    $0x5,%eax
c0101d67:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d6a:	29 c1                	sub    %eax,%ecx
c0101d6c:	89 c8                	mov    %ecx,%eax
c0101d6e:	85 c0                	test   %eax,%eax
c0101d70:	75 0a                	jne    c0101d7c <trap_dispatch+0x79>
            print_ticks();
c0101d72:	e8 16 fb ff ff       	call   c010188d <print_ticks>
        }
        break;
c0101d77:	e9 a6 00 00 00       	jmp    c0101e22 <trap_dispatch+0x11f>
c0101d7c:	e9 a1 00 00 00       	jmp    c0101e22 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d81:	e8 cb f8 ff ff       	call   c0101651 <cons_getc>
c0101d86:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d89:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d8d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d91:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d95:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d99:	c7 04 24 89 63 10 c0 	movl   $0xc0106389,(%esp)
c0101da0:	e8 a3 e5 ff ff       	call   c0100348 <cprintf>
        break;
c0101da5:	eb 7b                	jmp    c0101e22 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101da7:	e8 a5 f8 ff ff       	call   c0101651 <cons_getc>
c0101dac:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101daf:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101db3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101db7:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101dbb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dbf:	c7 04 24 9b 63 10 c0 	movl   $0xc010639b,(%esp)
c0101dc6:	e8 7d e5 ff ff       	call   c0100348 <cprintf>
        break;
c0101dcb:	eb 55                	jmp    c0101e22 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101dcd:	c7 44 24 08 aa 63 10 	movl   $0xc01063aa,0x8(%esp)
c0101dd4:	c0 
c0101dd5:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0101ddc:	00 
c0101ddd:	c7 04 24 ce 61 10 c0 	movl   $0xc01061ce,(%esp)
c0101de4:	e8 e9 ee ff ff       	call   c0100cd2 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101de9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dec:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101df0:	0f b7 c0             	movzwl %ax,%eax
c0101df3:	83 e0 03             	and    $0x3,%eax
c0101df6:	85 c0                	test   %eax,%eax
c0101df8:	75 28                	jne    c0101e22 <trap_dispatch+0x11f>
            print_trapframe(tf);
c0101dfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dfd:	89 04 24             	mov    %eax,(%esp)
c0101e00:	e8 82 fc ff ff       	call   c0101a87 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101e05:	c7 44 24 08 ba 63 10 	movl   $0xc01063ba,0x8(%esp)
c0101e0c:	c0 
c0101e0d:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101e14:	00 
c0101e15:	c7 04 24 ce 61 10 c0 	movl   $0xc01061ce,(%esp)
c0101e1c:	e8 b1 ee ff ff       	call   c0100cd2 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101e21:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101e22:	c9                   	leave  
c0101e23:	c3                   	ret    

c0101e24 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101e24:	55                   	push   %ebp
c0101e25:	89 e5                	mov    %esp,%ebp
c0101e27:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101e2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e2d:	89 04 24             	mov    %eax,(%esp)
c0101e30:	e8 ce fe ff ff       	call   c0101d03 <trap_dispatch>
}
c0101e35:	c9                   	leave  
c0101e36:	c3                   	ret    

c0101e37 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101e37:	1e                   	push   %ds
    pushl %es
c0101e38:	06                   	push   %es
    pushl %fs
c0101e39:	0f a0                	push   %fs
    pushl %gs
c0101e3b:	0f a8                	push   %gs
    pushal
c0101e3d:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101e3e:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e43:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e45:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101e47:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101e48:	e8 d7 ff ff ff       	call   c0101e24 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101e4d:	5c                   	pop    %esp

c0101e4e <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101e4e:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101e4f:	0f a9                	pop    %gs
    popl %fs
c0101e51:	0f a1                	pop    %fs
    popl %es
c0101e53:	07                   	pop    %es
    popl %ds
c0101e54:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e55:	83 c4 08             	add    $0x8,%esp
    iret
c0101e58:	cf                   	iret   

c0101e59 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e59:	6a 00                	push   $0x0
  pushl $0
c0101e5b:	6a 00                	push   $0x0
  jmp __alltraps
c0101e5d:	e9 d5 ff ff ff       	jmp    c0101e37 <__alltraps>

c0101e62 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e62:	6a 00                	push   $0x0
  pushl $1
c0101e64:	6a 01                	push   $0x1
  jmp __alltraps
c0101e66:	e9 cc ff ff ff       	jmp    c0101e37 <__alltraps>

c0101e6b <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e6b:	6a 00                	push   $0x0
  pushl $2
c0101e6d:	6a 02                	push   $0x2
  jmp __alltraps
c0101e6f:	e9 c3 ff ff ff       	jmp    c0101e37 <__alltraps>

c0101e74 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e74:	6a 00                	push   $0x0
  pushl $3
c0101e76:	6a 03                	push   $0x3
  jmp __alltraps
c0101e78:	e9 ba ff ff ff       	jmp    c0101e37 <__alltraps>

c0101e7d <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e7d:	6a 00                	push   $0x0
  pushl $4
c0101e7f:	6a 04                	push   $0x4
  jmp __alltraps
c0101e81:	e9 b1 ff ff ff       	jmp    c0101e37 <__alltraps>

c0101e86 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e86:	6a 00                	push   $0x0
  pushl $5
c0101e88:	6a 05                	push   $0x5
  jmp __alltraps
c0101e8a:	e9 a8 ff ff ff       	jmp    c0101e37 <__alltraps>

c0101e8f <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e8f:	6a 00                	push   $0x0
  pushl $6
c0101e91:	6a 06                	push   $0x6
  jmp __alltraps
c0101e93:	e9 9f ff ff ff       	jmp    c0101e37 <__alltraps>

c0101e98 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e98:	6a 00                	push   $0x0
  pushl $7
c0101e9a:	6a 07                	push   $0x7
  jmp __alltraps
c0101e9c:	e9 96 ff ff ff       	jmp    c0101e37 <__alltraps>

c0101ea1 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101ea1:	6a 08                	push   $0x8
  jmp __alltraps
c0101ea3:	e9 8f ff ff ff       	jmp    c0101e37 <__alltraps>

c0101ea8 <vector9>:
.globl vector9
vector9:
  pushl $0
c0101ea8:	6a 00                	push   $0x0
  pushl $9
c0101eaa:	6a 09                	push   $0x9
  jmp __alltraps
c0101eac:	e9 86 ff ff ff       	jmp    c0101e37 <__alltraps>

c0101eb1 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101eb1:	6a 0a                	push   $0xa
  jmp __alltraps
c0101eb3:	e9 7f ff ff ff       	jmp    c0101e37 <__alltraps>

c0101eb8 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101eb8:	6a 0b                	push   $0xb
  jmp __alltraps
c0101eba:	e9 78 ff ff ff       	jmp    c0101e37 <__alltraps>

c0101ebf <vector12>:
.globl vector12
vector12:
  pushl $12
c0101ebf:	6a 0c                	push   $0xc
  jmp __alltraps
c0101ec1:	e9 71 ff ff ff       	jmp    c0101e37 <__alltraps>

c0101ec6 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101ec6:	6a 0d                	push   $0xd
  jmp __alltraps
c0101ec8:	e9 6a ff ff ff       	jmp    c0101e37 <__alltraps>

c0101ecd <vector14>:
.globl vector14
vector14:
  pushl $14
c0101ecd:	6a 0e                	push   $0xe
  jmp __alltraps
c0101ecf:	e9 63 ff ff ff       	jmp    c0101e37 <__alltraps>

c0101ed4 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101ed4:	6a 00                	push   $0x0
  pushl $15
c0101ed6:	6a 0f                	push   $0xf
  jmp __alltraps
c0101ed8:	e9 5a ff ff ff       	jmp    c0101e37 <__alltraps>

c0101edd <vector16>:
.globl vector16
vector16:
  pushl $0
c0101edd:	6a 00                	push   $0x0
  pushl $16
c0101edf:	6a 10                	push   $0x10
  jmp __alltraps
c0101ee1:	e9 51 ff ff ff       	jmp    c0101e37 <__alltraps>

c0101ee6 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101ee6:	6a 11                	push   $0x11
  jmp __alltraps
c0101ee8:	e9 4a ff ff ff       	jmp    c0101e37 <__alltraps>

c0101eed <vector18>:
.globl vector18
vector18:
  pushl $0
c0101eed:	6a 00                	push   $0x0
  pushl $18
c0101eef:	6a 12                	push   $0x12
  jmp __alltraps
c0101ef1:	e9 41 ff ff ff       	jmp    c0101e37 <__alltraps>

c0101ef6 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101ef6:	6a 00                	push   $0x0
  pushl $19
c0101ef8:	6a 13                	push   $0x13
  jmp __alltraps
c0101efa:	e9 38 ff ff ff       	jmp    c0101e37 <__alltraps>

c0101eff <vector20>:
.globl vector20
vector20:
  pushl $0
c0101eff:	6a 00                	push   $0x0
  pushl $20
c0101f01:	6a 14                	push   $0x14
  jmp __alltraps
c0101f03:	e9 2f ff ff ff       	jmp    c0101e37 <__alltraps>

c0101f08 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f08:	6a 00                	push   $0x0
  pushl $21
c0101f0a:	6a 15                	push   $0x15
  jmp __alltraps
c0101f0c:	e9 26 ff ff ff       	jmp    c0101e37 <__alltraps>

c0101f11 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101f11:	6a 00                	push   $0x0
  pushl $22
c0101f13:	6a 16                	push   $0x16
  jmp __alltraps
c0101f15:	e9 1d ff ff ff       	jmp    c0101e37 <__alltraps>

c0101f1a <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f1a:	6a 00                	push   $0x0
  pushl $23
c0101f1c:	6a 17                	push   $0x17
  jmp __alltraps
c0101f1e:	e9 14 ff ff ff       	jmp    c0101e37 <__alltraps>

c0101f23 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101f23:	6a 00                	push   $0x0
  pushl $24
c0101f25:	6a 18                	push   $0x18
  jmp __alltraps
c0101f27:	e9 0b ff ff ff       	jmp    c0101e37 <__alltraps>

c0101f2c <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f2c:	6a 00                	push   $0x0
  pushl $25
c0101f2e:	6a 19                	push   $0x19
  jmp __alltraps
c0101f30:	e9 02 ff ff ff       	jmp    c0101e37 <__alltraps>

c0101f35 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f35:	6a 00                	push   $0x0
  pushl $26
c0101f37:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f39:	e9 f9 fe ff ff       	jmp    c0101e37 <__alltraps>

c0101f3e <vector27>:
.globl vector27
vector27:
  pushl $0
c0101f3e:	6a 00                	push   $0x0
  pushl $27
c0101f40:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f42:	e9 f0 fe ff ff       	jmp    c0101e37 <__alltraps>

c0101f47 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f47:	6a 00                	push   $0x0
  pushl $28
c0101f49:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f4b:	e9 e7 fe ff ff       	jmp    c0101e37 <__alltraps>

c0101f50 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f50:	6a 00                	push   $0x0
  pushl $29
c0101f52:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f54:	e9 de fe ff ff       	jmp    c0101e37 <__alltraps>

c0101f59 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f59:	6a 00                	push   $0x0
  pushl $30
c0101f5b:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f5d:	e9 d5 fe ff ff       	jmp    c0101e37 <__alltraps>

c0101f62 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f62:	6a 00                	push   $0x0
  pushl $31
c0101f64:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f66:	e9 cc fe ff ff       	jmp    c0101e37 <__alltraps>

c0101f6b <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f6b:	6a 00                	push   $0x0
  pushl $32
c0101f6d:	6a 20                	push   $0x20
  jmp __alltraps
c0101f6f:	e9 c3 fe ff ff       	jmp    c0101e37 <__alltraps>

c0101f74 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f74:	6a 00                	push   $0x0
  pushl $33
c0101f76:	6a 21                	push   $0x21
  jmp __alltraps
c0101f78:	e9 ba fe ff ff       	jmp    c0101e37 <__alltraps>

c0101f7d <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f7d:	6a 00                	push   $0x0
  pushl $34
c0101f7f:	6a 22                	push   $0x22
  jmp __alltraps
c0101f81:	e9 b1 fe ff ff       	jmp    c0101e37 <__alltraps>

c0101f86 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f86:	6a 00                	push   $0x0
  pushl $35
c0101f88:	6a 23                	push   $0x23
  jmp __alltraps
c0101f8a:	e9 a8 fe ff ff       	jmp    c0101e37 <__alltraps>

c0101f8f <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f8f:	6a 00                	push   $0x0
  pushl $36
c0101f91:	6a 24                	push   $0x24
  jmp __alltraps
c0101f93:	e9 9f fe ff ff       	jmp    c0101e37 <__alltraps>

c0101f98 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f98:	6a 00                	push   $0x0
  pushl $37
c0101f9a:	6a 25                	push   $0x25
  jmp __alltraps
c0101f9c:	e9 96 fe ff ff       	jmp    c0101e37 <__alltraps>

c0101fa1 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101fa1:	6a 00                	push   $0x0
  pushl $38
c0101fa3:	6a 26                	push   $0x26
  jmp __alltraps
c0101fa5:	e9 8d fe ff ff       	jmp    c0101e37 <__alltraps>

c0101faa <vector39>:
.globl vector39
vector39:
  pushl $0
c0101faa:	6a 00                	push   $0x0
  pushl $39
c0101fac:	6a 27                	push   $0x27
  jmp __alltraps
c0101fae:	e9 84 fe ff ff       	jmp    c0101e37 <__alltraps>

c0101fb3 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101fb3:	6a 00                	push   $0x0
  pushl $40
c0101fb5:	6a 28                	push   $0x28
  jmp __alltraps
c0101fb7:	e9 7b fe ff ff       	jmp    c0101e37 <__alltraps>

c0101fbc <vector41>:
.globl vector41
vector41:
  pushl $0
c0101fbc:	6a 00                	push   $0x0
  pushl $41
c0101fbe:	6a 29                	push   $0x29
  jmp __alltraps
c0101fc0:	e9 72 fe ff ff       	jmp    c0101e37 <__alltraps>

c0101fc5 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101fc5:	6a 00                	push   $0x0
  pushl $42
c0101fc7:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101fc9:	e9 69 fe ff ff       	jmp    c0101e37 <__alltraps>

c0101fce <vector43>:
.globl vector43
vector43:
  pushl $0
c0101fce:	6a 00                	push   $0x0
  pushl $43
c0101fd0:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101fd2:	e9 60 fe ff ff       	jmp    c0101e37 <__alltraps>

c0101fd7 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101fd7:	6a 00                	push   $0x0
  pushl $44
c0101fd9:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101fdb:	e9 57 fe ff ff       	jmp    c0101e37 <__alltraps>

c0101fe0 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101fe0:	6a 00                	push   $0x0
  pushl $45
c0101fe2:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101fe4:	e9 4e fe ff ff       	jmp    c0101e37 <__alltraps>

c0101fe9 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101fe9:	6a 00                	push   $0x0
  pushl $46
c0101feb:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101fed:	e9 45 fe ff ff       	jmp    c0101e37 <__alltraps>

c0101ff2 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101ff2:	6a 00                	push   $0x0
  pushl $47
c0101ff4:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101ff6:	e9 3c fe ff ff       	jmp    c0101e37 <__alltraps>

c0101ffb <vector48>:
.globl vector48
vector48:
  pushl $0
c0101ffb:	6a 00                	push   $0x0
  pushl $48
c0101ffd:	6a 30                	push   $0x30
  jmp __alltraps
c0101fff:	e9 33 fe ff ff       	jmp    c0101e37 <__alltraps>

c0102004 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102004:	6a 00                	push   $0x0
  pushl $49
c0102006:	6a 31                	push   $0x31
  jmp __alltraps
c0102008:	e9 2a fe ff ff       	jmp    c0101e37 <__alltraps>

c010200d <vector50>:
.globl vector50
vector50:
  pushl $0
c010200d:	6a 00                	push   $0x0
  pushl $50
c010200f:	6a 32                	push   $0x32
  jmp __alltraps
c0102011:	e9 21 fe ff ff       	jmp    c0101e37 <__alltraps>

c0102016 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102016:	6a 00                	push   $0x0
  pushl $51
c0102018:	6a 33                	push   $0x33
  jmp __alltraps
c010201a:	e9 18 fe ff ff       	jmp    c0101e37 <__alltraps>

c010201f <vector52>:
.globl vector52
vector52:
  pushl $0
c010201f:	6a 00                	push   $0x0
  pushl $52
c0102021:	6a 34                	push   $0x34
  jmp __alltraps
c0102023:	e9 0f fe ff ff       	jmp    c0101e37 <__alltraps>

c0102028 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102028:	6a 00                	push   $0x0
  pushl $53
c010202a:	6a 35                	push   $0x35
  jmp __alltraps
c010202c:	e9 06 fe ff ff       	jmp    c0101e37 <__alltraps>

c0102031 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102031:	6a 00                	push   $0x0
  pushl $54
c0102033:	6a 36                	push   $0x36
  jmp __alltraps
c0102035:	e9 fd fd ff ff       	jmp    c0101e37 <__alltraps>

c010203a <vector55>:
.globl vector55
vector55:
  pushl $0
c010203a:	6a 00                	push   $0x0
  pushl $55
c010203c:	6a 37                	push   $0x37
  jmp __alltraps
c010203e:	e9 f4 fd ff ff       	jmp    c0101e37 <__alltraps>

c0102043 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102043:	6a 00                	push   $0x0
  pushl $56
c0102045:	6a 38                	push   $0x38
  jmp __alltraps
c0102047:	e9 eb fd ff ff       	jmp    c0101e37 <__alltraps>

c010204c <vector57>:
.globl vector57
vector57:
  pushl $0
c010204c:	6a 00                	push   $0x0
  pushl $57
c010204e:	6a 39                	push   $0x39
  jmp __alltraps
c0102050:	e9 e2 fd ff ff       	jmp    c0101e37 <__alltraps>

c0102055 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102055:	6a 00                	push   $0x0
  pushl $58
c0102057:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102059:	e9 d9 fd ff ff       	jmp    c0101e37 <__alltraps>

c010205e <vector59>:
.globl vector59
vector59:
  pushl $0
c010205e:	6a 00                	push   $0x0
  pushl $59
c0102060:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102062:	e9 d0 fd ff ff       	jmp    c0101e37 <__alltraps>

c0102067 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102067:	6a 00                	push   $0x0
  pushl $60
c0102069:	6a 3c                	push   $0x3c
  jmp __alltraps
c010206b:	e9 c7 fd ff ff       	jmp    c0101e37 <__alltraps>

c0102070 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102070:	6a 00                	push   $0x0
  pushl $61
c0102072:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102074:	e9 be fd ff ff       	jmp    c0101e37 <__alltraps>

c0102079 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102079:	6a 00                	push   $0x0
  pushl $62
c010207b:	6a 3e                	push   $0x3e
  jmp __alltraps
c010207d:	e9 b5 fd ff ff       	jmp    c0101e37 <__alltraps>

c0102082 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102082:	6a 00                	push   $0x0
  pushl $63
c0102084:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102086:	e9 ac fd ff ff       	jmp    c0101e37 <__alltraps>

c010208b <vector64>:
.globl vector64
vector64:
  pushl $0
c010208b:	6a 00                	push   $0x0
  pushl $64
c010208d:	6a 40                	push   $0x40
  jmp __alltraps
c010208f:	e9 a3 fd ff ff       	jmp    c0101e37 <__alltraps>

c0102094 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102094:	6a 00                	push   $0x0
  pushl $65
c0102096:	6a 41                	push   $0x41
  jmp __alltraps
c0102098:	e9 9a fd ff ff       	jmp    c0101e37 <__alltraps>

c010209d <vector66>:
.globl vector66
vector66:
  pushl $0
c010209d:	6a 00                	push   $0x0
  pushl $66
c010209f:	6a 42                	push   $0x42
  jmp __alltraps
c01020a1:	e9 91 fd ff ff       	jmp    c0101e37 <__alltraps>

c01020a6 <vector67>:
.globl vector67
vector67:
  pushl $0
c01020a6:	6a 00                	push   $0x0
  pushl $67
c01020a8:	6a 43                	push   $0x43
  jmp __alltraps
c01020aa:	e9 88 fd ff ff       	jmp    c0101e37 <__alltraps>

c01020af <vector68>:
.globl vector68
vector68:
  pushl $0
c01020af:	6a 00                	push   $0x0
  pushl $68
c01020b1:	6a 44                	push   $0x44
  jmp __alltraps
c01020b3:	e9 7f fd ff ff       	jmp    c0101e37 <__alltraps>

c01020b8 <vector69>:
.globl vector69
vector69:
  pushl $0
c01020b8:	6a 00                	push   $0x0
  pushl $69
c01020ba:	6a 45                	push   $0x45
  jmp __alltraps
c01020bc:	e9 76 fd ff ff       	jmp    c0101e37 <__alltraps>

c01020c1 <vector70>:
.globl vector70
vector70:
  pushl $0
c01020c1:	6a 00                	push   $0x0
  pushl $70
c01020c3:	6a 46                	push   $0x46
  jmp __alltraps
c01020c5:	e9 6d fd ff ff       	jmp    c0101e37 <__alltraps>

c01020ca <vector71>:
.globl vector71
vector71:
  pushl $0
c01020ca:	6a 00                	push   $0x0
  pushl $71
c01020cc:	6a 47                	push   $0x47
  jmp __alltraps
c01020ce:	e9 64 fd ff ff       	jmp    c0101e37 <__alltraps>

c01020d3 <vector72>:
.globl vector72
vector72:
  pushl $0
c01020d3:	6a 00                	push   $0x0
  pushl $72
c01020d5:	6a 48                	push   $0x48
  jmp __alltraps
c01020d7:	e9 5b fd ff ff       	jmp    c0101e37 <__alltraps>

c01020dc <vector73>:
.globl vector73
vector73:
  pushl $0
c01020dc:	6a 00                	push   $0x0
  pushl $73
c01020de:	6a 49                	push   $0x49
  jmp __alltraps
c01020e0:	e9 52 fd ff ff       	jmp    c0101e37 <__alltraps>

c01020e5 <vector74>:
.globl vector74
vector74:
  pushl $0
c01020e5:	6a 00                	push   $0x0
  pushl $74
c01020e7:	6a 4a                	push   $0x4a
  jmp __alltraps
c01020e9:	e9 49 fd ff ff       	jmp    c0101e37 <__alltraps>

c01020ee <vector75>:
.globl vector75
vector75:
  pushl $0
c01020ee:	6a 00                	push   $0x0
  pushl $75
c01020f0:	6a 4b                	push   $0x4b
  jmp __alltraps
c01020f2:	e9 40 fd ff ff       	jmp    c0101e37 <__alltraps>

c01020f7 <vector76>:
.globl vector76
vector76:
  pushl $0
c01020f7:	6a 00                	push   $0x0
  pushl $76
c01020f9:	6a 4c                	push   $0x4c
  jmp __alltraps
c01020fb:	e9 37 fd ff ff       	jmp    c0101e37 <__alltraps>

c0102100 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102100:	6a 00                	push   $0x0
  pushl $77
c0102102:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102104:	e9 2e fd ff ff       	jmp    c0101e37 <__alltraps>

c0102109 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102109:	6a 00                	push   $0x0
  pushl $78
c010210b:	6a 4e                	push   $0x4e
  jmp __alltraps
c010210d:	e9 25 fd ff ff       	jmp    c0101e37 <__alltraps>

c0102112 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102112:	6a 00                	push   $0x0
  pushl $79
c0102114:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102116:	e9 1c fd ff ff       	jmp    c0101e37 <__alltraps>

c010211b <vector80>:
.globl vector80
vector80:
  pushl $0
c010211b:	6a 00                	push   $0x0
  pushl $80
c010211d:	6a 50                	push   $0x50
  jmp __alltraps
c010211f:	e9 13 fd ff ff       	jmp    c0101e37 <__alltraps>

c0102124 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102124:	6a 00                	push   $0x0
  pushl $81
c0102126:	6a 51                	push   $0x51
  jmp __alltraps
c0102128:	e9 0a fd ff ff       	jmp    c0101e37 <__alltraps>

c010212d <vector82>:
.globl vector82
vector82:
  pushl $0
c010212d:	6a 00                	push   $0x0
  pushl $82
c010212f:	6a 52                	push   $0x52
  jmp __alltraps
c0102131:	e9 01 fd ff ff       	jmp    c0101e37 <__alltraps>

c0102136 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102136:	6a 00                	push   $0x0
  pushl $83
c0102138:	6a 53                	push   $0x53
  jmp __alltraps
c010213a:	e9 f8 fc ff ff       	jmp    c0101e37 <__alltraps>

c010213f <vector84>:
.globl vector84
vector84:
  pushl $0
c010213f:	6a 00                	push   $0x0
  pushl $84
c0102141:	6a 54                	push   $0x54
  jmp __alltraps
c0102143:	e9 ef fc ff ff       	jmp    c0101e37 <__alltraps>

c0102148 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102148:	6a 00                	push   $0x0
  pushl $85
c010214a:	6a 55                	push   $0x55
  jmp __alltraps
c010214c:	e9 e6 fc ff ff       	jmp    c0101e37 <__alltraps>

c0102151 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102151:	6a 00                	push   $0x0
  pushl $86
c0102153:	6a 56                	push   $0x56
  jmp __alltraps
c0102155:	e9 dd fc ff ff       	jmp    c0101e37 <__alltraps>

c010215a <vector87>:
.globl vector87
vector87:
  pushl $0
c010215a:	6a 00                	push   $0x0
  pushl $87
c010215c:	6a 57                	push   $0x57
  jmp __alltraps
c010215e:	e9 d4 fc ff ff       	jmp    c0101e37 <__alltraps>

c0102163 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102163:	6a 00                	push   $0x0
  pushl $88
c0102165:	6a 58                	push   $0x58
  jmp __alltraps
c0102167:	e9 cb fc ff ff       	jmp    c0101e37 <__alltraps>

c010216c <vector89>:
.globl vector89
vector89:
  pushl $0
c010216c:	6a 00                	push   $0x0
  pushl $89
c010216e:	6a 59                	push   $0x59
  jmp __alltraps
c0102170:	e9 c2 fc ff ff       	jmp    c0101e37 <__alltraps>

c0102175 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102175:	6a 00                	push   $0x0
  pushl $90
c0102177:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102179:	e9 b9 fc ff ff       	jmp    c0101e37 <__alltraps>

c010217e <vector91>:
.globl vector91
vector91:
  pushl $0
c010217e:	6a 00                	push   $0x0
  pushl $91
c0102180:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102182:	e9 b0 fc ff ff       	jmp    c0101e37 <__alltraps>

c0102187 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102187:	6a 00                	push   $0x0
  pushl $92
c0102189:	6a 5c                	push   $0x5c
  jmp __alltraps
c010218b:	e9 a7 fc ff ff       	jmp    c0101e37 <__alltraps>

c0102190 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102190:	6a 00                	push   $0x0
  pushl $93
c0102192:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102194:	e9 9e fc ff ff       	jmp    c0101e37 <__alltraps>

c0102199 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102199:	6a 00                	push   $0x0
  pushl $94
c010219b:	6a 5e                	push   $0x5e
  jmp __alltraps
c010219d:	e9 95 fc ff ff       	jmp    c0101e37 <__alltraps>

c01021a2 <vector95>:
.globl vector95
vector95:
  pushl $0
c01021a2:	6a 00                	push   $0x0
  pushl $95
c01021a4:	6a 5f                	push   $0x5f
  jmp __alltraps
c01021a6:	e9 8c fc ff ff       	jmp    c0101e37 <__alltraps>

c01021ab <vector96>:
.globl vector96
vector96:
  pushl $0
c01021ab:	6a 00                	push   $0x0
  pushl $96
c01021ad:	6a 60                	push   $0x60
  jmp __alltraps
c01021af:	e9 83 fc ff ff       	jmp    c0101e37 <__alltraps>

c01021b4 <vector97>:
.globl vector97
vector97:
  pushl $0
c01021b4:	6a 00                	push   $0x0
  pushl $97
c01021b6:	6a 61                	push   $0x61
  jmp __alltraps
c01021b8:	e9 7a fc ff ff       	jmp    c0101e37 <__alltraps>

c01021bd <vector98>:
.globl vector98
vector98:
  pushl $0
c01021bd:	6a 00                	push   $0x0
  pushl $98
c01021bf:	6a 62                	push   $0x62
  jmp __alltraps
c01021c1:	e9 71 fc ff ff       	jmp    c0101e37 <__alltraps>

c01021c6 <vector99>:
.globl vector99
vector99:
  pushl $0
c01021c6:	6a 00                	push   $0x0
  pushl $99
c01021c8:	6a 63                	push   $0x63
  jmp __alltraps
c01021ca:	e9 68 fc ff ff       	jmp    c0101e37 <__alltraps>

c01021cf <vector100>:
.globl vector100
vector100:
  pushl $0
c01021cf:	6a 00                	push   $0x0
  pushl $100
c01021d1:	6a 64                	push   $0x64
  jmp __alltraps
c01021d3:	e9 5f fc ff ff       	jmp    c0101e37 <__alltraps>

c01021d8 <vector101>:
.globl vector101
vector101:
  pushl $0
c01021d8:	6a 00                	push   $0x0
  pushl $101
c01021da:	6a 65                	push   $0x65
  jmp __alltraps
c01021dc:	e9 56 fc ff ff       	jmp    c0101e37 <__alltraps>

c01021e1 <vector102>:
.globl vector102
vector102:
  pushl $0
c01021e1:	6a 00                	push   $0x0
  pushl $102
c01021e3:	6a 66                	push   $0x66
  jmp __alltraps
c01021e5:	e9 4d fc ff ff       	jmp    c0101e37 <__alltraps>

c01021ea <vector103>:
.globl vector103
vector103:
  pushl $0
c01021ea:	6a 00                	push   $0x0
  pushl $103
c01021ec:	6a 67                	push   $0x67
  jmp __alltraps
c01021ee:	e9 44 fc ff ff       	jmp    c0101e37 <__alltraps>

c01021f3 <vector104>:
.globl vector104
vector104:
  pushl $0
c01021f3:	6a 00                	push   $0x0
  pushl $104
c01021f5:	6a 68                	push   $0x68
  jmp __alltraps
c01021f7:	e9 3b fc ff ff       	jmp    c0101e37 <__alltraps>

c01021fc <vector105>:
.globl vector105
vector105:
  pushl $0
c01021fc:	6a 00                	push   $0x0
  pushl $105
c01021fe:	6a 69                	push   $0x69
  jmp __alltraps
c0102200:	e9 32 fc ff ff       	jmp    c0101e37 <__alltraps>

c0102205 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102205:	6a 00                	push   $0x0
  pushl $106
c0102207:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102209:	e9 29 fc ff ff       	jmp    c0101e37 <__alltraps>

c010220e <vector107>:
.globl vector107
vector107:
  pushl $0
c010220e:	6a 00                	push   $0x0
  pushl $107
c0102210:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102212:	e9 20 fc ff ff       	jmp    c0101e37 <__alltraps>

c0102217 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102217:	6a 00                	push   $0x0
  pushl $108
c0102219:	6a 6c                	push   $0x6c
  jmp __alltraps
c010221b:	e9 17 fc ff ff       	jmp    c0101e37 <__alltraps>

c0102220 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102220:	6a 00                	push   $0x0
  pushl $109
c0102222:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102224:	e9 0e fc ff ff       	jmp    c0101e37 <__alltraps>

c0102229 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102229:	6a 00                	push   $0x0
  pushl $110
c010222b:	6a 6e                	push   $0x6e
  jmp __alltraps
c010222d:	e9 05 fc ff ff       	jmp    c0101e37 <__alltraps>

c0102232 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102232:	6a 00                	push   $0x0
  pushl $111
c0102234:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102236:	e9 fc fb ff ff       	jmp    c0101e37 <__alltraps>

c010223b <vector112>:
.globl vector112
vector112:
  pushl $0
c010223b:	6a 00                	push   $0x0
  pushl $112
c010223d:	6a 70                	push   $0x70
  jmp __alltraps
c010223f:	e9 f3 fb ff ff       	jmp    c0101e37 <__alltraps>

c0102244 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102244:	6a 00                	push   $0x0
  pushl $113
c0102246:	6a 71                	push   $0x71
  jmp __alltraps
c0102248:	e9 ea fb ff ff       	jmp    c0101e37 <__alltraps>

c010224d <vector114>:
.globl vector114
vector114:
  pushl $0
c010224d:	6a 00                	push   $0x0
  pushl $114
c010224f:	6a 72                	push   $0x72
  jmp __alltraps
c0102251:	e9 e1 fb ff ff       	jmp    c0101e37 <__alltraps>

c0102256 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102256:	6a 00                	push   $0x0
  pushl $115
c0102258:	6a 73                	push   $0x73
  jmp __alltraps
c010225a:	e9 d8 fb ff ff       	jmp    c0101e37 <__alltraps>

c010225f <vector116>:
.globl vector116
vector116:
  pushl $0
c010225f:	6a 00                	push   $0x0
  pushl $116
c0102261:	6a 74                	push   $0x74
  jmp __alltraps
c0102263:	e9 cf fb ff ff       	jmp    c0101e37 <__alltraps>

c0102268 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102268:	6a 00                	push   $0x0
  pushl $117
c010226a:	6a 75                	push   $0x75
  jmp __alltraps
c010226c:	e9 c6 fb ff ff       	jmp    c0101e37 <__alltraps>

c0102271 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102271:	6a 00                	push   $0x0
  pushl $118
c0102273:	6a 76                	push   $0x76
  jmp __alltraps
c0102275:	e9 bd fb ff ff       	jmp    c0101e37 <__alltraps>

c010227a <vector119>:
.globl vector119
vector119:
  pushl $0
c010227a:	6a 00                	push   $0x0
  pushl $119
c010227c:	6a 77                	push   $0x77
  jmp __alltraps
c010227e:	e9 b4 fb ff ff       	jmp    c0101e37 <__alltraps>

c0102283 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102283:	6a 00                	push   $0x0
  pushl $120
c0102285:	6a 78                	push   $0x78
  jmp __alltraps
c0102287:	e9 ab fb ff ff       	jmp    c0101e37 <__alltraps>

c010228c <vector121>:
.globl vector121
vector121:
  pushl $0
c010228c:	6a 00                	push   $0x0
  pushl $121
c010228e:	6a 79                	push   $0x79
  jmp __alltraps
c0102290:	e9 a2 fb ff ff       	jmp    c0101e37 <__alltraps>

c0102295 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102295:	6a 00                	push   $0x0
  pushl $122
c0102297:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102299:	e9 99 fb ff ff       	jmp    c0101e37 <__alltraps>

c010229e <vector123>:
.globl vector123
vector123:
  pushl $0
c010229e:	6a 00                	push   $0x0
  pushl $123
c01022a0:	6a 7b                	push   $0x7b
  jmp __alltraps
c01022a2:	e9 90 fb ff ff       	jmp    c0101e37 <__alltraps>

c01022a7 <vector124>:
.globl vector124
vector124:
  pushl $0
c01022a7:	6a 00                	push   $0x0
  pushl $124
c01022a9:	6a 7c                	push   $0x7c
  jmp __alltraps
c01022ab:	e9 87 fb ff ff       	jmp    c0101e37 <__alltraps>

c01022b0 <vector125>:
.globl vector125
vector125:
  pushl $0
c01022b0:	6a 00                	push   $0x0
  pushl $125
c01022b2:	6a 7d                	push   $0x7d
  jmp __alltraps
c01022b4:	e9 7e fb ff ff       	jmp    c0101e37 <__alltraps>

c01022b9 <vector126>:
.globl vector126
vector126:
  pushl $0
c01022b9:	6a 00                	push   $0x0
  pushl $126
c01022bb:	6a 7e                	push   $0x7e
  jmp __alltraps
c01022bd:	e9 75 fb ff ff       	jmp    c0101e37 <__alltraps>

c01022c2 <vector127>:
.globl vector127
vector127:
  pushl $0
c01022c2:	6a 00                	push   $0x0
  pushl $127
c01022c4:	6a 7f                	push   $0x7f
  jmp __alltraps
c01022c6:	e9 6c fb ff ff       	jmp    c0101e37 <__alltraps>

c01022cb <vector128>:
.globl vector128
vector128:
  pushl $0
c01022cb:	6a 00                	push   $0x0
  pushl $128
c01022cd:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01022d2:	e9 60 fb ff ff       	jmp    c0101e37 <__alltraps>

c01022d7 <vector129>:
.globl vector129
vector129:
  pushl $0
c01022d7:	6a 00                	push   $0x0
  pushl $129
c01022d9:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01022de:	e9 54 fb ff ff       	jmp    c0101e37 <__alltraps>

c01022e3 <vector130>:
.globl vector130
vector130:
  pushl $0
c01022e3:	6a 00                	push   $0x0
  pushl $130
c01022e5:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01022ea:	e9 48 fb ff ff       	jmp    c0101e37 <__alltraps>

c01022ef <vector131>:
.globl vector131
vector131:
  pushl $0
c01022ef:	6a 00                	push   $0x0
  pushl $131
c01022f1:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01022f6:	e9 3c fb ff ff       	jmp    c0101e37 <__alltraps>

c01022fb <vector132>:
.globl vector132
vector132:
  pushl $0
c01022fb:	6a 00                	push   $0x0
  pushl $132
c01022fd:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102302:	e9 30 fb ff ff       	jmp    c0101e37 <__alltraps>

c0102307 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102307:	6a 00                	push   $0x0
  pushl $133
c0102309:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c010230e:	e9 24 fb ff ff       	jmp    c0101e37 <__alltraps>

c0102313 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102313:	6a 00                	push   $0x0
  pushl $134
c0102315:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010231a:	e9 18 fb ff ff       	jmp    c0101e37 <__alltraps>

c010231f <vector135>:
.globl vector135
vector135:
  pushl $0
c010231f:	6a 00                	push   $0x0
  pushl $135
c0102321:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102326:	e9 0c fb ff ff       	jmp    c0101e37 <__alltraps>

c010232b <vector136>:
.globl vector136
vector136:
  pushl $0
c010232b:	6a 00                	push   $0x0
  pushl $136
c010232d:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102332:	e9 00 fb ff ff       	jmp    c0101e37 <__alltraps>

c0102337 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102337:	6a 00                	push   $0x0
  pushl $137
c0102339:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c010233e:	e9 f4 fa ff ff       	jmp    c0101e37 <__alltraps>

c0102343 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102343:	6a 00                	push   $0x0
  pushl $138
c0102345:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010234a:	e9 e8 fa ff ff       	jmp    c0101e37 <__alltraps>

c010234f <vector139>:
.globl vector139
vector139:
  pushl $0
c010234f:	6a 00                	push   $0x0
  pushl $139
c0102351:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102356:	e9 dc fa ff ff       	jmp    c0101e37 <__alltraps>

c010235b <vector140>:
.globl vector140
vector140:
  pushl $0
c010235b:	6a 00                	push   $0x0
  pushl $140
c010235d:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102362:	e9 d0 fa ff ff       	jmp    c0101e37 <__alltraps>

c0102367 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102367:	6a 00                	push   $0x0
  pushl $141
c0102369:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010236e:	e9 c4 fa ff ff       	jmp    c0101e37 <__alltraps>

c0102373 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102373:	6a 00                	push   $0x0
  pushl $142
c0102375:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010237a:	e9 b8 fa ff ff       	jmp    c0101e37 <__alltraps>

c010237f <vector143>:
.globl vector143
vector143:
  pushl $0
c010237f:	6a 00                	push   $0x0
  pushl $143
c0102381:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102386:	e9 ac fa ff ff       	jmp    c0101e37 <__alltraps>

c010238b <vector144>:
.globl vector144
vector144:
  pushl $0
c010238b:	6a 00                	push   $0x0
  pushl $144
c010238d:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102392:	e9 a0 fa ff ff       	jmp    c0101e37 <__alltraps>

c0102397 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102397:	6a 00                	push   $0x0
  pushl $145
c0102399:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c010239e:	e9 94 fa ff ff       	jmp    c0101e37 <__alltraps>

c01023a3 <vector146>:
.globl vector146
vector146:
  pushl $0
c01023a3:	6a 00                	push   $0x0
  pushl $146
c01023a5:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01023aa:	e9 88 fa ff ff       	jmp    c0101e37 <__alltraps>

c01023af <vector147>:
.globl vector147
vector147:
  pushl $0
c01023af:	6a 00                	push   $0x0
  pushl $147
c01023b1:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01023b6:	e9 7c fa ff ff       	jmp    c0101e37 <__alltraps>

c01023bb <vector148>:
.globl vector148
vector148:
  pushl $0
c01023bb:	6a 00                	push   $0x0
  pushl $148
c01023bd:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01023c2:	e9 70 fa ff ff       	jmp    c0101e37 <__alltraps>

c01023c7 <vector149>:
.globl vector149
vector149:
  pushl $0
c01023c7:	6a 00                	push   $0x0
  pushl $149
c01023c9:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01023ce:	e9 64 fa ff ff       	jmp    c0101e37 <__alltraps>

c01023d3 <vector150>:
.globl vector150
vector150:
  pushl $0
c01023d3:	6a 00                	push   $0x0
  pushl $150
c01023d5:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01023da:	e9 58 fa ff ff       	jmp    c0101e37 <__alltraps>

c01023df <vector151>:
.globl vector151
vector151:
  pushl $0
c01023df:	6a 00                	push   $0x0
  pushl $151
c01023e1:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01023e6:	e9 4c fa ff ff       	jmp    c0101e37 <__alltraps>

c01023eb <vector152>:
.globl vector152
vector152:
  pushl $0
c01023eb:	6a 00                	push   $0x0
  pushl $152
c01023ed:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01023f2:	e9 40 fa ff ff       	jmp    c0101e37 <__alltraps>

c01023f7 <vector153>:
.globl vector153
vector153:
  pushl $0
c01023f7:	6a 00                	push   $0x0
  pushl $153
c01023f9:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01023fe:	e9 34 fa ff ff       	jmp    c0101e37 <__alltraps>

c0102403 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102403:	6a 00                	push   $0x0
  pushl $154
c0102405:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010240a:	e9 28 fa ff ff       	jmp    c0101e37 <__alltraps>

c010240f <vector155>:
.globl vector155
vector155:
  pushl $0
c010240f:	6a 00                	push   $0x0
  pushl $155
c0102411:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102416:	e9 1c fa ff ff       	jmp    c0101e37 <__alltraps>

c010241b <vector156>:
.globl vector156
vector156:
  pushl $0
c010241b:	6a 00                	push   $0x0
  pushl $156
c010241d:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102422:	e9 10 fa ff ff       	jmp    c0101e37 <__alltraps>

c0102427 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102427:	6a 00                	push   $0x0
  pushl $157
c0102429:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c010242e:	e9 04 fa ff ff       	jmp    c0101e37 <__alltraps>

c0102433 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102433:	6a 00                	push   $0x0
  pushl $158
c0102435:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010243a:	e9 f8 f9 ff ff       	jmp    c0101e37 <__alltraps>

c010243f <vector159>:
.globl vector159
vector159:
  pushl $0
c010243f:	6a 00                	push   $0x0
  pushl $159
c0102441:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102446:	e9 ec f9 ff ff       	jmp    c0101e37 <__alltraps>

c010244b <vector160>:
.globl vector160
vector160:
  pushl $0
c010244b:	6a 00                	push   $0x0
  pushl $160
c010244d:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102452:	e9 e0 f9 ff ff       	jmp    c0101e37 <__alltraps>

c0102457 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102457:	6a 00                	push   $0x0
  pushl $161
c0102459:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010245e:	e9 d4 f9 ff ff       	jmp    c0101e37 <__alltraps>

c0102463 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102463:	6a 00                	push   $0x0
  pushl $162
c0102465:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010246a:	e9 c8 f9 ff ff       	jmp    c0101e37 <__alltraps>

c010246f <vector163>:
.globl vector163
vector163:
  pushl $0
c010246f:	6a 00                	push   $0x0
  pushl $163
c0102471:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102476:	e9 bc f9 ff ff       	jmp    c0101e37 <__alltraps>

c010247b <vector164>:
.globl vector164
vector164:
  pushl $0
c010247b:	6a 00                	push   $0x0
  pushl $164
c010247d:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102482:	e9 b0 f9 ff ff       	jmp    c0101e37 <__alltraps>

c0102487 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102487:	6a 00                	push   $0x0
  pushl $165
c0102489:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010248e:	e9 a4 f9 ff ff       	jmp    c0101e37 <__alltraps>

c0102493 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102493:	6a 00                	push   $0x0
  pushl $166
c0102495:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010249a:	e9 98 f9 ff ff       	jmp    c0101e37 <__alltraps>

c010249f <vector167>:
.globl vector167
vector167:
  pushl $0
c010249f:	6a 00                	push   $0x0
  pushl $167
c01024a1:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01024a6:	e9 8c f9 ff ff       	jmp    c0101e37 <__alltraps>

c01024ab <vector168>:
.globl vector168
vector168:
  pushl $0
c01024ab:	6a 00                	push   $0x0
  pushl $168
c01024ad:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01024b2:	e9 80 f9 ff ff       	jmp    c0101e37 <__alltraps>

c01024b7 <vector169>:
.globl vector169
vector169:
  pushl $0
c01024b7:	6a 00                	push   $0x0
  pushl $169
c01024b9:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01024be:	e9 74 f9 ff ff       	jmp    c0101e37 <__alltraps>

c01024c3 <vector170>:
.globl vector170
vector170:
  pushl $0
c01024c3:	6a 00                	push   $0x0
  pushl $170
c01024c5:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01024ca:	e9 68 f9 ff ff       	jmp    c0101e37 <__alltraps>

c01024cf <vector171>:
.globl vector171
vector171:
  pushl $0
c01024cf:	6a 00                	push   $0x0
  pushl $171
c01024d1:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01024d6:	e9 5c f9 ff ff       	jmp    c0101e37 <__alltraps>

c01024db <vector172>:
.globl vector172
vector172:
  pushl $0
c01024db:	6a 00                	push   $0x0
  pushl $172
c01024dd:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01024e2:	e9 50 f9 ff ff       	jmp    c0101e37 <__alltraps>

c01024e7 <vector173>:
.globl vector173
vector173:
  pushl $0
c01024e7:	6a 00                	push   $0x0
  pushl $173
c01024e9:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01024ee:	e9 44 f9 ff ff       	jmp    c0101e37 <__alltraps>

c01024f3 <vector174>:
.globl vector174
vector174:
  pushl $0
c01024f3:	6a 00                	push   $0x0
  pushl $174
c01024f5:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01024fa:	e9 38 f9 ff ff       	jmp    c0101e37 <__alltraps>

c01024ff <vector175>:
.globl vector175
vector175:
  pushl $0
c01024ff:	6a 00                	push   $0x0
  pushl $175
c0102501:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102506:	e9 2c f9 ff ff       	jmp    c0101e37 <__alltraps>

c010250b <vector176>:
.globl vector176
vector176:
  pushl $0
c010250b:	6a 00                	push   $0x0
  pushl $176
c010250d:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102512:	e9 20 f9 ff ff       	jmp    c0101e37 <__alltraps>

c0102517 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102517:	6a 00                	push   $0x0
  pushl $177
c0102519:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010251e:	e9 14 f9 ff ff       	jmp    c0101e37 <__alltraps>

c0102523 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102523:	6a 00                	push   $0x0
  pushl $178
c0102525:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010252a:	e9 08 f9 ff ff       	jmp    c0101e37 <__alltraps>

c010252f <vector179>:
.globl vector179
vector179:
  pushl $0
c010252f:	6a 00                	push   $0x0
  pushl $179
c0102531:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102536:	e9 fc f8 ff ff       	jmp    c0101e37 <__alltraps>

c010253b <vector180>:
.globl vector180
vector180:
  pushl $0
c010253b:	6a 00                	push   $0x0
  pushl $180
c010253d:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102542:	e9 f0 f8 ff ff       	jmp    c0101e37 <__alltraps>

c0102547 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102547:	6a 00                	push   $0x0
  pushl $181
c0102549:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010254e:	e9 e4 f8 ff ff       	jmp    c0101e37 <__alltraps>

c0102553 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102553:	6a 00                	push   $0x0
  pushl $182
c0102555:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010255a:	e9 d8 f8 ff ff       	jmp    c0101e37 <__alltraps>

c010255f <vector183>:
.globl vector183
vector183:
  pushl $0
c010255f:	6a 00                	push   $0x0
  pushl $183
c0102561:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102566:	e9 cc f8 ff ff       	jmp    c0101e37 <__alltraps>

c010256b <vector184>:
.globl vector184
vector184:
  pushl $0
c010256b:	6a 00                	push   $0x0
  pushl $184
c010256d:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102572:	e9 c0 f8 ff ff       	jmp    c0101e37 <__alltraps>

c0102577 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102577:	6a 00                	push   $0x0
  pushl $185
c0102579:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010257e:	e9 b4 f8 ff ff       	jmp    c0101e37 <__alltraps>

c0102583 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102583:	6a 00                	push   $0x0
  pushl $186
c0102585:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010258a:	e9 a8 f8 ff ff       	jmp    c0101e37 <__alltraps>

c010258f <vector187>:
.globl vector187
vector187:
  pushl $0
c010258f:	6a 00                	push   $0x0
  pushl $187
c0102591:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102596:	e9 9c f8 ff ff       	jmp    c0101e37 <__alltraps>

c010259b <vector188>:
.globl vector188
vector188:
  pushl $0
c010259b:	6a 00                	push   $0x0
  pushl $188
c010259d:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01025a2:	e9 90 f8 ff ff       	jmp    c0101e37 <__alltraps>

c01025a7 <vector189>:
.globl vector189
vector189:
  pushl $0
c01025a7:	6a 00                	push   $0x0
  pushl $189
c01025a9:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01025ae:	e9 84 f8 ff ff       	jmp    c0101e37 <__alltraps>

c01025b3 <vector190>:
.globl vector190
vector190:
  pushl $0
c01025b3:	6a 00                	push   $0x0
  pushl $190
c01025b5:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01025ba:	e9 78 f8 ff ff       	jmp    c0101e37 <__alltraps>

c01025bf <vector191>:
.globl vector191
vector191:
  pushl $0
c01025bf:	6a 00                	push   $0x0
  pushl $191
c01025c1:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01025c6:	e9 6c f8 ff ff       	jmp    c0101e37 <__alltraps>

c01025cb <vector192>:
.globl vector192
vector192:
  pushl $0
c01025cb:	6a 00                	push   $0x0
  pushl $192
c01025cd:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01025d2:	e9 60 f8 ff ff       	jmp    c0101e37 <__alltraps>

c01025d7 <vector193>:
.globl vector193
vector193:
  pushl $0
c01025d7:	6a 00                	push   $0x0
  pushl $193
c01025d9:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01025de:	e9 54 f8 ff ff       	jmp    c0101e37 <__alltraps>

c01025e3 <vector194>:
.globl vector194
vector194:
  pushl $0
c01025e3:	6a 00                	push   $0x0
  pushl $194
c01025e5:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01025ea:	e9 48 f8 ff ff       	jmp    c0101e37 <__alltraps>

c01025ef <vector195>:
.globl vector195
vector195:
  pushl $0
c01025ef:	6a 00                	push   $0x0
  pushl $195
c01025f1:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01025f6:	e9 3c f8 ff ff       	jmp    c0101e37 <__alltraps>

c01025fb <vector196>:
.globl vector196
vector196:
  pushl $0
c01025fb:	6a 00                	push   $0x0
  pushl $196
c01025fd:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102602:	e9 30 f8 ff ff       	jmp    c0101e37 <__alltraps>

c0102607 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102607:	6a 00                	push   $0x0
  pushl $197
c0102609:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c010260e:	e9 24 f8 ff ff       	jmp    c0101e37 <__alltraps>

c0102613 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102613:	6a 00                	push   $0x0
  pushl $198
c0102615:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010261a:	e9 18 f8 ff ff       	jmp    c0101e37 <__alltraps>

c010261f <vector199>:
.globl vector199
vector199:
  pushl $0
c010261f:	6a 00                	push   $0x0
  pushl $199
c0102621:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102626:	e9 0c f8 ff ff       	jmp    c0101e37 <__alltraps>

c010262b <vector200>:
.globl vector200
vector200:
  pushl $0
c010262b:	6a 00                	push   $0x0
  pushl $200
c010262d:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102632:	e9 00 f8 ff ff       	jmp    c0101e37 <__alltraps>

c0102637 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102637:	6a 00                	push   $0x0
  pushl $201
c0102639:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c010263e:	e9 f4 f7 ff ff       	jmp    c0101e37 <__alltraps>

c0102643 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102643:	6a 00                	push   $0x0
  pushl $202
c0102645:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010264a:	e9 e8 f7 ff ff       	jmp    c0101e37 <__alltraps>

c010264f <vector203>:
.globl vector203
vector203:
  pushl $0
c010264f:	6a 00                	push   $0x0
  pushl $203
c0102651:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102656:	e9 dc f7 ff ff       	jmp    c0101e37 <__alltraps>

c010265b <vector204>:
.globl vector204
vector204:
  pushl $0
c010265b:	6a 00                	push   $0x0
  pushl $204
c010265d:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102662:	e9 d0 f7 ff ff       	jmp    c0101e37 <__alltraps>

c0102667 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102667:	6a 00                	push   $0x0
  pushl $205
c0102669:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010266e:	e9 c4 f7 ff ff       	jmp    c0101e37 <__alltraps>

c0102673 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102673:	6a 00                	push   $0x0
  pushl $206
c0102675:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010267a:	e9 b8 f7 ff ff       	jmp    c0101e37 <__alltraps>

c010267f <vector207>:
.globl vector207
vector207:
  pushl $0
c010267f:	6a 00                	push   $0x0
  pushl $207
c0102681:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102686:	e9 ac f7 ff ff       	jmp    c0101e37 <__alltraps>

c010268b <vector208>:
.globl vector208
vector208:
  pushl $0
c010268b:	6a 00                	push   $0x0
  pushl $208
c010268d:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102692:	e9 a0 f7 ff ff       	jmp    c0101e37 <__alltraps>

c0102697 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102697:	6a 00                	push   $0x0
  pushl $209
c0102699:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010269e:	e9 94 f7 ff ff       	jmp    c0101e37 <__alltraps>

c01026a3 <vector210>:
.globl vector210
vector210:
  pushl $0
c01026a3:	6a 00                	push   $0x0
  pushl $210
c01026a5:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01026aa:	e9 88 f7 ff ff       	jmp    c0101e37 <__alltraps>

c01026af <vector211>:
.globl vector211
vector211:
  pushl $0
c01026af:	6a 00                	push   $0x0
  pushl $211
c01026b1:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01026b6:	e9 7c f7 ff ff       	jmp    c0101e37 <__alltraps>

c01026bb <vector212>:
.globl vector212
vector212:
  pushl $0
c01026bb:	6a 00                	push   $0x0
  pushl $212
c01026bd:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01026c2:	e9 70 f7 ff ff       	jmp    c0101e37 <__alltraps>

c01026c7 <vector213>:
.globl vector213
vector213:
  pushl $0
c01026c7:	6a 00                	push   $0x0
  pushl $213
c01026c9:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01026ce:	e9 64 f7 ff ff       	jmp    c0101e37 <__alltraps>

c01026d3 <vector214>:
.globl vector214
vector214:
  pushl $0
c01026d3:	6a 00                	push   $0x0
  pushl $214
c01026d5:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01026da:	e9 58 f7 ff ff       	jmp    c0101e37 <__alltraps>

c01026df <vector215>:
.globl vector215
vector215:
  pushl $0
c01026df:	6a 00                	push   $0x0
  pushl $215
c01026e1:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01026e6:	e9 4c f7 ff ff       	jmp    c0101e37 <__alltraps>

c01026eb <vector216>:
.globl vector216
vector216:
  pushl $0
c01026eb:	6a 00                	push   $0x0
  pushl $216
c01026ed:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01026f2:	e9 40 f7 ff ff       	jmp    c0101e37 <__alltraps>

c01026f7 <vector217>:
.globl vector217
vector217:
  pushl $0
c01026f7:	6a 00                	push   $0x0
  pushl $217
c01026f9:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01026fe:	e9 34 f7 ff ff       	jmp    c0101e37 <__alltraps>

c0102703 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102703:	6a 00                	push   $0x0
  pushl $218
c0102705:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010270a:	e9 28 f7 ff ff       	jmp    c0101e37 <__alltraps>

c010270f <vector219>:
.globl vector219
vector219:
  pushl $0
c010270f:	6a 00                	push   $0x0
  pushl $219
c0102711:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102716:	e9 1c f7 ff ff       	jmp    c0101e37 <__alltraps>

c010271b <vector220>:
.globl vector220
vector220:
  pushl $0
c010271b:	6a 00                	push   $0x0
  pushl $220
c010271d:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102722:	e9 10 f7 ff ff       	jmp    c0101e37 <__alltraps>

c0102727 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102727:	6a 00                	push   $0x0
  pushl $221
c0102729:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010272e:	e9 04 f7 ff ff       	jmp    c0101e37 <__alltraps>

c0102733 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102733:	6a 00                	push   $0x0
  pushl $222
c0102735:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010273a:	e9 f8 f6 ff ff       	jmp    c0101e37 <__alltraps>

c010273f <vector223>:
.globl vector223
vector223:
  pushl $0
c010273f:	6a 00                	push   $0x0
  pushl $223
c0102741:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102746:	e9 ec f6 ff ff       	jmp    c0101e37 <__alltraps>

c010274b <vector224>:
.globl vector224
vector224:
  pushl $0
c010274b:	6a 00                	push   $0x0
  pushl $224
c010274d:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102752:	e9 e0 f6 ff ff       	jmp    c0101e37 <__alltraps>

c0102757 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102757:	6a 00                	push   $0x0
  pushl $225
c0102759:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010275e:	e9 d4 f6 ff ff       	jmp    c0101e37 <__alltraps>

c0102763 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102763:	6a 00                	push   $0x0
  pushl $226
c0102765:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010276a:	e9 c8 f6 ff ff       	jmp    c0101e37 <__alltraps>

c010276f <vector227>:
.globl vector227
vector227:
  pushl $0
c010276f:	6a 00                	push   $0x0
  pushl $227
c0102771:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102776:	e9 bc f6 ff ff       	jmp    c0101e37 <__alltraps>

c010277b <vector228>:
.globl vector228
vector228:
  pushl $0
c010277b:	6a 00                	push   $0x0
  pushl $228
c010277d:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102782:	e9 b0 f6 ff ff       	jmp    c0101e37 <__alltraps>

c0102787 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102787:	6a 00                	push   $0x0
  pushl $229
c0102789:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010278e:	e9 a4 f6 ff ff       	jmp    c0101e37 <__alltraps>

c0102793 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102793:	6a 00                	push   $0x0
  pushl $230
c0102795:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010279a:	e9 98 f6 ff ff       	jmp    c0101e37 <__alltraps>

c010279f <vector231>:
.globl vector231
vector231:
  pushl $0
c010279f:	6a 00                	push   $0x0
  pushl $231
c01027a1:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01027a6:	e9 8c f6 ff ff       	jmp    c0101e37 <__alltraps>

c01027ab <vector232>:
.globl vector232
vector232:
  pushl $0
c01027ab:	6a 00                	push   $0x0
  pushl $232
c01027ad:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01027b2:	e9 80 f6 ff ff       	jmp    c0101e37 <__alltraps>

c01027b7 <vector233>:
.globl vector233
vector233:
  pushl $0
c01027b7:	6a 00                	push   $0x0
  pushl $233
c01027b9:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01027be:	e9 74 f6 ff ff       	jmp    c0101e37 <__alltraps>

c01027c3 <vector234>:
.globl vector234
vector234:
  pushl $0
c01027c3:	6a 00                	push   $0x0
  pushl $234
c01027c5:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01027ca:	e9 68 f6 ff ff       	jmp    c0101e37 <__alltraps>

c01027cf <vector235>:
.globl vector235
vector235:
  pushl $0
c01027cf:	6a 00                	push   $0x0
  pushl $235
c01027d1:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01027d6:	e9 5c f6 ff ff       	jmp    c0101e37 <__alltraps>

c01027db <vector236>:
.globl vector236
vector236:
  pushl $0
c01027db:	6a 00                	push   $0x0
  pushl $236
c01027dd:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01027e2:	e9 50 f6 ff ff       	jmp    c0101e37 <__alltraps>

c01027e7 <vector237>:
.globl vector237
vector237:
  pushl $0
c01027e7:	6a 00                	push   $0x0
  pushl $237
c01027e9:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01027ee:	e9 44 f6 ff ff       	jmp    c0101e37 <__alltraps>

c01027f3 <vector238>:
.globl vector238
vector238:
  pushl $0
c01027f3:	6a 00                	push   $0x0
  pushl $238
c01027f5:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01027fa:	e9 38 f6 ff ff       	jmp    c0101e37 <__alltraps>

c01027ff <vector239>:
.globl vector239
vector239:
  pushl $0
c01027ff:	6a 00                	push   $0x0
  pushl $239
c0102801:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102806:	e9 2c f6 ff ff       	jmp    c0101e37 <__alltraps>

c010280b <vector240>:
.globl vector240
vector240:
  pushl $0
c010280b:	6a 00                	push   $0x0
  pushl $240
c010280d:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102812:	e9 20 f6 ff ff       	jmp    c0101e37 <__alltraps>

c0102817 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102817:	6a 00                	push   $0x0
  pushl $241
c0102819:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010281e:	e9 14 f6 ff ff       	jmp    c0101e37 <__alltraps>

c0102823 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102823:	6a 00                	push   $0x0
  pushl $242
c0102825:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010282a:	e9 08 f6 ff ff       	jmp    c0101e37 <__alltraps>

c010282f <vector243>:
.globl vector243
vector243:
  pushl $0
c010282f:	6a 00                	push   $0x0
  pushl $243
c0102831:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102836:	e9 fc f5 ff ff       	jmp    c0101e37 <__alltraps>

c010283b <vector244>:
.globl vector244
vector244:
  pushl $0
c010283b:	6a 00                	push   $0x0
  pushl $244
c010283d:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102842:	e9 f0 f5 ff ff       	jmp    c0101e37 <__alltraps>

c0102847 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102847:	6a 00                	push   $0x0
  pushl $245
c0102849:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010284e:	e9 e4 f5 ff ff       	jmp    c0101e37 <__alltraps>

c0102853 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102853:	6a 00                	push   $0x0
  pushl $246
c0102855:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010285a:	e9 d8 f5 ff ff       	jmp    c0101e37 <__alltraps>

c010285f <vector247>:
.globl vector247
vector247:
  pushl $0
c010285f:	6a 00                	push   $0x0
  pushl $247
c0102861:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102866:	e9 cc f5 ff ff       	jmp    c0101e37 <__alltraps>

c010286b <vector248>:
.globl vector248
vector248:
  pushl $0
c010286b:	6a 00                	push   $0x0
  pushl $248
c010286d:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102872:	e9 c0 f5 ff ff       	jmp    c0101e37 <__alltraps>

c0102877 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102877:	6a 00                	push   $0x0
  pushl $249
c0102879:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010287e:	e9 b4 f5 ff ff       	jmp    c0101e37 <__alltraps>

c0102883 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102883:	6a 00                	push   $0x0
  pushl $250
c0102885:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010288a:	e9 a8 f5 ff ff       	jmp    c0101e37 <__alltraps>

c010288f <vector251>:
.globl vector251
vector251:
  pushl $0
c010288f:	6a 00                	push   $0x0
  pushl $251
c0102891:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102896:	e9 9c f5 ff ff       	jmp    c0101e37 <__alltraps>

c010289b <vector252>:
.globl vector252
vector252:
  pushl $0
c010289b:	6a 00                	push   $0x0
  pushl $252
c010289d:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01028a2:	e9 90 f5 ff ff       	jmp    c0101e37 <__alltraps>

c01028a7 <vector253>:
.globl vector253
vector253:
  pushl $0
c01028a7:	6a 00                	push   $0x0
  pushl $253
c01028a9:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01028ae:	e9 84 f5 ff ff       	jmp    c0101e37 <__alltraps>

c01028b3 <vector254>:
.globl vector254
vector254:
  pushl $0
c01028b3:	6a 00                	push   $0x0
  pushl $254
c01028b5:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01028ba:	e9 78 f5 ff ff       	jmp    c0101e37 <__alltraps>

c01028bf <vector255>:
.globl vector255
vector255:
  pushl $0
c01028bf:	6a 00                	push   $0x0
  pushl $255
c01028c1:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01028c6:	e9 6c f5 ff ff       	jmp    c0101e37 <__alltraps>

c01028cb <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01028cb:	55                   	push   %ebp
c01028cc:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01028ce:	8b 55 08             	mov    0x8(%ebp),%edx
c01028d1:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c01028d6:	29 c2                	sub    %eax,%edx
c01028d8:	89 d0                	mov    %edx,%eax
c01028da:	c1 f8 02             	sar    $0x2,%eax
c01028dd:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028e3:	5d                   	pop    %ebp
c01028e4:	c3                   	ret    

c01028e5 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01028e5:	55                   	push   %ebp
c01028e6:	89 e5                	mov    %esp,%ebp
c01028e8:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01028eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01028ee:	89 04 24             	mov    %eax,(%esp)
c01028f1:	e8 d5 ff ff ff       	call   c01028cb <page2ppn>
c01028f6:	c1 e0 0c             	shl    $0xc,%eax
}
c01028f9:	c9                   	leave  
c01028fa:	c3                   	ret    

c01028fb <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01028fb:	55                   	push   %ebp
c01028fc:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01028fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102901:	8b 00                	mov    (%eax),%eax
}
c0102903:	5d                   	pop    %ebp
c0102904:	c3                   	ret    

c0102905 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102905:	55                   	push   %ebp
c0102906:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102908:	8b 45 08             	mov    0x8(%ebp),%eax
c010290b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010290e:	89 10                	mov    %edx,(%eax)
}
c0102910:	5d                   	pop    %ebp
c0102911:	c3                   	ret    

c0102912 <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

//initialize the `free_list` and set `nr_free` to 0.
static void
default_init(void) {
c0102912:	55                   	push   %ebp
c0102913:	89 e5                	mov    %esp,%ebp
c0102915:	83 ec 10             	sub    $0x10,%esp
c0102918:	c7 45 fc 10 af 11 c0 	movl   $0xc011af10,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010291f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102922:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102925:	89 50 04             	mov    %edx,0x4(%eax)
c0102928:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010292b:	8b 50 04             	mov    0x4(%eax),%edx
c010292e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102931:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0102933:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c010293a:	00 00 00 
}
c010293d:	c9                   	leave  
c010293e:	c3                   	ret    

c010293f <default_init_memmap>:

//initialize a free block
static void
default_init_memmap(struct Page *base, size_t n) {
c010293f:	55                   	push   %ebp
c0102940:	89 e5                	mov    %esp,%ebp
c0102942:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0102945:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102949:	75 24                	jne    c010296f <default_init_memmap+0x30>
c010294b:	c7 44 24 0c 70 65 10 	movl   $0xc0106570,0xc(%esp)
c0102952:	c0 
c0102953:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c010295a:	c0 
c010295b:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
c0102962:	00 
c0102963:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c010296a:	e8 63 e3 ff ff       	call   c0100cd2 <__panic>
    struct Page *p = base;
c010296f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102972:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102975:	eb 7d                	jmp    c01029f4 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0102977:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010297a:	83 c0 04             	add    $0x4,%eax
c010297d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102984:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102987:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010298a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010298d:	0f a3 10             	bt     %edx,(%eax)
c0102990:	19 c0                	sbb    %eax,%eax
c0102992:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102995:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102999:	0f 95 c0             	setne  %al
c010299c:	0f b6 c0             	movzbl %al,%eax
c010299f:	85 c0                	test   %eax,%eax
c01029a1:	75 24                	jne    c01029c7 <default_init_memmap+0x88>
c01029a3:	c7 44 24 0c a1 65 10 	movl   $0xc01065a1,0xc(%esp)
c01029aa:	c0 
c01029ab:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c01029b2:	c0 
c01029b3:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
c01029ba:	00 
c01029bb:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c01029c2:	e8 0b e3 ff ff       	call   c0100cd2 <__panic>
        p->flags = p->property = 0;
c01029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029ca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029d4:	8b 50 08             	mov    0x8(%eax),%edx
c01029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029da:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01029dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01029e4:	00 
c01029e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029e8:	89 04 24             	mov    %eax,(%esp)
c01029eb:	e8 15 ff ff ff       	call   c0102905 <set_page_ref>
//initialize a free block
static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01029f0:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01029f4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029f7:	89 d0                	mov    %edx,%eax
c01029f9:	c1 e0 02             	shl    $0x2,%eax
c01029fc:	01 d0                	add    %edx,%eax
c01029fe:	c1 e0 02             	shl    $0x2,%eax
c0102a01:	89 c2                	mov    %eax,%edx
c0102a03:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a06:	01 d0                	add    %edx,%eax
c0102a08:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102a0b:	0f 85 66 ff ff ff    	jne    c0102977 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102a11:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a14:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a17:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102a1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a1d:	83 c0 04             	add    $0x4,%eax
c0102a20:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102a27:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102a2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a2d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102a30:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0102a33:	8b 15 18 af 11 c0    	mov    0xc011af18,%edx
c0102a39:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a3c:	01 d0                	add    %edx,%eax
c0102a3e:	a3 18 af 11 c0       	mov    %eax,0xc011af18
    list_add(&free_list, &(base->page_link));
c0102a43:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a46:	83 c0 0c             	add    $0xc,%eax
c0102a49:	c7 45 dc 10 af 11 c0 	movl   $0xc011af10,-0x24(%ebp)
c0102a50:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102a53:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a56:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0102a59:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102a5c:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102a5f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a62:	8b 40 04             	mov    0x4(%eax),%eax
c0102a65:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102a68:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102a6b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a6e:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102a71:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102a74:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102a77:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102a7a:	89 10                	mov    %edx,(%eax)
c0102a7c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102a7f:	8b 10                	mov    (%eax),%edx
c0102a81:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102a84:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102a87:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a8a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102a8d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a90:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a93:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102a96:	89 10                	mov    %edx,(%eax)
}
c0102a98:	c9                   	leave  
c0102a99:	c3                   	ret    

c0102a9a <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102a9a:	55                   	push   %ebp
c0102a9b:	89 e5                	mov    %esp,%ebp
c0102a9d:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102aa0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102aa4:	75 24                	jne    c0102aca <default_alloc_pages+0x30>
c0102aa6:	c7 44 24 0c 70 65 10 	movl   $0xc0106570,0xc(%esp)
c0102aad:	c0 
c0102aae:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0102ab5:	c0 
c0102ab6:	c7 44 24 04 7e 00 00 	movl   $0x7e,0x4(%esp)
c0102abd:	00 
c0102abe:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0102ac5:	e8 08 e2 ff ff       	call   c0100cd2 <__panic>
    if (n > nr_free) {
c0102aca:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0102acf:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ad2:	73 0a                	jae    c0102ade <default_alloc_pages+0x44>
        return NULL;
c0102ad4:	b8 00 00 00 00       	mov    $0x0,%eax
c0102ad9:	e9 2a 01 00 00       	jmp    c0102c08 <default_alloc_pages+0x16e>
    }
    struct Page *page = NULL;
c0102ade:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102ae5:	c7 45 f0 10 af 11 c0 	movl   $0xc011af10,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102aec:	eb 1c                	jmp    c0102b0a <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102af1:	83 e8 0c             	sub    $0xc,%eax
c0102af4:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0102af7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102afa:	8b 40 08             	mov    0x8(%eax),%eax
c0102afd:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b00:	72 08                	jb     c0102b0a <default_alloc_pages+0x70>
            page = p;
c0102b02:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b05:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102b08:	eb 18                	jmp    c0102b22 <default_alloc_pages+0x88>
c0102b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102b10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b13:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102b19:	81 7d f0 10 af 11 c0 	cmpl   $0xc011af10,-0x10(%ebp)
c0102b20:	75 cc                	jne    c0102aee <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0102b22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102b26:	0f 84 d9 00 00 00    	je     c0102c05 <default_alloc_pages+0x16b>
        list_del(&(page->page_link));
c0102b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b2f:	83 c0 0c             	add    $0xc,%eax
c0102b32:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102b35:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102b38:	8b 40 04             	mov    0x4(%eax),%eax
c0102b3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102b3e:	8b 12                	mov    (%edx),%edx
c0102b40:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0102b43:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b46:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102b49:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102b4c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b52:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b55:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c0102b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b5a:	8b 40 08             	mov    0x8(%eax),%eax
c0102b5d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b60:	76 7d                	jbe    c0102bdf <default_alloc_pages+0x145>
            struct Page *p = page + n;
c0102b62:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b65:	89 d0                	mov    %edx,%eax
c0102b67:	c1 e0 02             	shl    $0x2,%eax
c0102b6a:	01 d0                	add    %edx,%eax
c0102b6c:	c1 e0 02             	shl    $0x2,%eax
c0102b6f:	89 c2                	mov    %eax,%edx
c0102b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b74:	01 d0                	add    %edx,%eax
c0102b76:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0102b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b7c:	8b 40 08             	mov    0x8(%eax),%eax
c0102b7f:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b82:	89 c2                	mov    %eax,%edx
c0102b84:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b87:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
c0102b8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b8d:	83 c0 0c             	add    $0xc,%eax
c0102b90:	c7 45 d4 10 af 11 c0 	movl   $0xc011af10,-0x2c(%ebp)
c0102b97:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102b9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102b9d:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0102ba0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102ba3:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102ba6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102ba9:	8b 40 04             	mov    0x4(%eax),%eax
c0102bac:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102baf:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102bb2:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102bb5:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102bb8:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102bbb:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102bbe:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102bc1:	89 10                	mov    %edx,(%eax)
c0102bc3:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102bc6:	8b 10                	mov    (%eax),%edx
c0102bc8:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102bcb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102bce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102bd1:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102bd4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102bd7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102bda:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102bdd:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
c0102bdf:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0102be4:	2b 45 08             	sub    0x8(%ebp),%eax
c0102be7:	a3 18 af 11 c0       	mov    %eax,0xc011af18
        ClearPageProperty(page);
c0102bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bef:	83 c0 04             	add    $0x4,%eax
c0102bf2:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102bf9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102bfc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102bff:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102c02:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0102c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102c08:	c9                   	leave  
c0102c09:	c3                   	ret    

c0102c0a <default_free_pages>:
//  *  change some pages' `p->property` correctly.

//'default_free_pages':re-link the pages into the free list, 
// and may merge small free blocks into the big ones.
static void
default_free_pages(struct Page *base, size_t n) {
c0102c0a:	55                   	push   %ebp
c0102c0b:	89 e5                	mov    %esp,%ebp
c0102c0d:	81 ec a8 00 00 00    	sub    $0xa8,%esp
    assert(n > 0);
c0102c13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102c17:	75 24                	jne    c0102c3d <default_free_pages+0x33>
c0102c19:	c7 44 24 0c 70 65 10 	movl   $0xc0106570,0xc(%esp)
c0102c20:	c0 
c0102c21:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0102c28:	c0 
c0102c29:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c0102c30:	00 
c0102c31:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0102c38:	e8 95 e0 ff ff       	call   c0100cd2 <__panic>
    struct Page *p = base;
c0102c3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102c43:	e9 9d 00 00 00       	jmp    c0102ce5 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0102c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c4b:	83 c0 04             	add    $0x4,%eax
c0102c4e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0102c55:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c58:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102c5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102c5e:	0f a3 10             	bt     %edx,(%eax)
c0102c61:	19 c0                	sbb    %eax,%eax
c0102c63:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
c0102c66:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0102c6a:	0f 95 c0             	setne  %al
c0102c6d:	0f b6 c0             	movzbl %al,%eax
c0102c70:	85 c0                	test   %eax,%eax
c0102c72:	75 2c                	jne    c0102ca0 <default_free_pages+0x96>
c0102c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c77:	83 c0 04             	add    $0x4,%eax
c0102c7a:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c0102c81:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c84:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102c87:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102c8a:	0f a3 10             	bt     %edx,(%eax)
c0102c8d:	19 c0                	sbb    %eax,%eax
c0102c8f:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
c0102c92:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0102c96:	0f 95 c0             	setne  %al
c0102c99:	0f b6 c0             	movzbl %al,%eax
c0102c9c:	85 c0                	test   %eax,%eax
c0102c9e:	74 24                	je     c0102cc4 <default_free_pages+0xba>
c0102ca0:	c7 44 24 0c b4 65 10 	movl   $0xc01065b4,0xc(%esp)
c0102ca7:	c0 
c0102ca8:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0102caf:	c0 
c0102cb0:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
c0102cb7:	00 
c0102cb8:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0102cbf:	e8 0e e0 ff ff       	call   c0100cd2 <__panic>
        p->flags = 0;
c0102cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cc7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102cce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102cd5:	00 
c0102cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cd9:	89 04 24             	mov    %eax,(%esp)
c0102cdc:	e8 24 fc ff ff       	call   c0102905 <set_page_ref>
// and may merge small free blocks into the big ones.
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102ce1:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102ce5:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102ce8:	89 d0                	mov    %edx,%eax
c0102cea:	c1 e0 02             	shl    $0x2,%eax
c0102ced:	01 d0                	add    %edx,%eax
c0102cef:	c1 e0 02             	shl    $0x2,%eax
c0102cf2:	89 c2                	mov    %eax,%edx
c0102cf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cf7:	01 d0                	add    %edx,%eax
c0102cf9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102cfc:	0f 85 46 ff ff ff    	jne    c0102c48 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102d02:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d05:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d08:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102d0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d0e:	83 c0 04             	add    $0x4,%eax
c0102d11:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0102d18:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d1b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102d1e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102d21:	0f ab 10             	bts    %edx,(%eax)
c0102d24:	c7 45 c4 10 af 11 c0 	movl   $0xc011af10,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102d2b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d2e:	8b 40 04             	mov    0x4(%eax),%eax
    //search the free list for its correct position 
    list_entry_t *next_entry = list_next(&free_list);
c0102d31:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (next_entry != &free_list && le2page(next_entry, page_link) < base)
c0102d34:	eb 0f                	jmp    c0102d45 <default_free_pages+0x13b>
c0102d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d39:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0102d3c:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d3f:	8b 40 04             	mov    0x4(%eax),%eax
        next_entry = list_next(next_entry);
c0102d42:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    base->property = n;
    SetPageProperty(base);
    //search the free list for its correct position 
    list_entry_t *next_entry = list_next(&free_list);
    while (next_entry != &free_list && le2page(next_entry, page_link) < base)
c0102d45:	81 7d f0 10 af 11 c0 	cmpl   $0xc011af10,-0x10(%ebp)
c0102d4c:	74 0b                	je     c0102d59 <default_free_pages+0x14f>
c0102d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d51:	83 e8 0c             	sub    $0xc,%eax
c0102d54:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102d57:	72 dd                	jb     c0102d36 <default_free_pages+0x12c>
c0102d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d5c:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102d5f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d62:	8b 00                	mov    (%eax),%eax
        next_entry = list_next(next_entry);
    //merge blocks at lower or higher addresses
    list_entry_t *prev_entry = list_prev(next_entry);
c0102d64:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *insert_entry = prev_entry;
c0102d67:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102d6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (prev_entry != &free_list) {
c0102d6d:	81 7d ec 10 af 11 c0 	cmpl   $0xc011af10,-0x14(%ebp)
c0102d74:	0f 84 8e 00 00 00    	je     c0102e08 <default_free_pages+0x1fe>
        p = le2page(prev_entry, page_link);
c0102d7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102d7d:	83 e8 0c             	sub    $0xc,%eax
c0102d80:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (p + p->property == base) {
c0102d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d86:	8b 50 08             	mov    0x8(%eax),%edx
c0102d89:	89 d0                	mov    %edx,%eax
c0102d8b:	c1 e0 02             	shl    $0x2,%eax
c0102d8e:	01 d0                	add    %edx,%eax
c0102d90:	c1 e0 02             	shl    $0x2,%eax
c0102d93:	89 c2                	mov    %eax,%edx
c0102d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d98:	01 d0                	add    %edx,%eax
c0102d9a:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102d9d:	75 69                	jne    c0102e08 <default_free_pages+0x1fe>
            p->property += base->property;
c0102d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102da2:	8b 50 08             	mov    0x8(%eax),%edx
c0102da5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102da8:	8b 40 08             	mov    0x8(%eax),%eax
c0102dab:	01 c2                	add    %eax,%edx
c0102dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102db0:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102db3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102db6:	83 c0 04             	add    $0x4,%eax
c0102db9:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102dc0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102dc3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102dc6:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102dc9:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0102dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dcf:	89 45 08             	mov    %eax,0x8(%ebp)
c0102dd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102dd5:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0102dd8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102ddb:	8b 00                	mov    (%eax),%eax
            insert_entry = list_prev(prev_entry);
c0102ddd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0102de0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102de3:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102de6:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102de9:	8b 40 04             	mov    0x4(%eax),%eax
c0102dec:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102def:	8b 12                	mov    (%edx),%edx
c0102df1:	89 55 a8             	mov    %edx,-0x58(%ebp)
c0102df4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102df7:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102dfa:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102dfd:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e00:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102e03:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102e06:	89 10                	mov    %edx,(%eax)
            list_del(prev_entry);
        }
    }
    if (next_entry != &free_list) {
c0102e08:	81 7d f0 10 af 11 c0 	cmpl   $0xc011af10,-0x10(%ebp)
c0102e0f:	74 7a                	je     c0102e8b <default_free_pages+0x281>
        p = le2page(next_entry, page_link);
c0102e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e14:	83 e8 0c             	sub    $0xc,%eax
c0102e17:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property == p) {
c0102e1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e1d:	8b 50 08             	mov    0x8(%eax),%edx
c0102e20:	89 d0                	mov    %edx,%eax
c0102e22:	c1 e0 02             	shl    $0x2,%eax
c0102e25:	01 d0                	add    %edx,%eax
c0102e27:	c1 e0 02             	shl    $0x2,%eax
c0102e2a:	89 c2                	mov    %eax,%edx
c0102e2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e2f:	01 d0                	add    %edx,%eax
c0102e31:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102e34:	75 55                	jne    c0102e8b <default_free_pages+0x281>
            base->property += p->property;
c0102e36:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e39:	8b 50 08             	mov    0x8(%eax),%edx
c0102e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e3f:	8b 40 08             	mov    0x8(%eax),%eax
c0102e42:	01 c2                	add    %eax,%edx
c0102e44:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e47:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e4d:	83 c0 04             	add    $0x4,%eax
c0102e50:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0102e57:	89 45 9c             	mov    %eax,-0x64(%ebp)
c0102e5a:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102e5d:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102e60:	0f b3 10             	btr    %edx,(%eax)
c0102e63:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e66:	89 45 98             	mov    %eax,-0x68(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102e69:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e6c:	8b 40 04             	mov    0x4(%eax),%eax
c0102e6f:	8b 55 98             	mov    -0x68(%ebp),%edx
c0102e72:	8b 12                	mov    (%edx),%edx
c0102e74:	89 55 94             	mov    %edx,-0x6c(%ebp)
c0102e77:	89 45 90             	mov    %eax,-0x70(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102e7a:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102e7d:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102e80:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e83:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102e86:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102e89:	89 10                	mov    %edx,(%eax)
    //         base = p;
    //         list_del(&(p->page_link));
    //     }
    // }
    //insert into free list
    nr_free += n;
c0102e8b:	8b 15 18 af 11 c0    	mov    0xc011af18,%edx
c0102e91:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e94:	01 d0                	add    %edx,%eax
c0102e96:	a3 18 af 11 c0       	mov    %eax,0xc011af18
    list_add(&free_list, &(base->page_link));
c0102e9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e9e:	83 c0 0c             	add    $0xc,%eax
c0102ea1:	c7 45 8c 10 af 11 c0 	movl   $0xc011af10,-0x74(%ebp)
c0102ea8:	89 45 88             	mov    %eax,-0x78(%ebp)
c0102eab:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102eae:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102eb1:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102eb4:	89 45 80             	mov    %eax,-0x80(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102eb7:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102eba:	8b 40 04             	mov    0x4(%eax),%eax
c0102ebd:	8b 55 80             	mov    -0x80(%ebp),%edx
c0102ec0:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0102ec6:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102ec9:	89 95 78 ff ff ff    	mov    %edx,-0x88(%ebp)
c0102ecf:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102ed5:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
c0102edb:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0102ee1:	89 10                	mov    %edx,(%eax)
c0102ee3:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
c0102ee9:	8b 10                	mov    (%eax),%edx
c0102eeb:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0102ef1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102ef4:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0102efa:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
c0102f00:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102f03:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0102f09:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
c0102f0f:	89 10                	mov    %edx,(%eax)
}
c0102f11:	c9                   	leave  
c0102f12:	c3                   	ret    

c0102f13 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102f13:	55                   	push   %ebp
c0102f14:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102f16:	a1 18 af 11 c0       	mov    0xc011af18,%eax
}
c0102f1b:	5d                   	pop    %ebp
c0102f1c:	c3                   	ret    

c0102f1d <basic_check>:

static void
basic_check(void) {
c0102f1d:	55                   	push   %ebp
c0102f1e:	89 e5                	mov    %esp,%ebp
c0102f20:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102f23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f33:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102f36:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f3d:	e8 90 0e 00 00       	call   c0103dd2 <alloc_pages>
c0102f42:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102f45:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102f49:	75 24                	jne    c0102f6f <basic_check+0x52>
c0102f4b:	c7 44 24 0c d9 65 10 	movl   $0xc01065d9,0xc(%esp)
c0102f52:	c0 
c0102f53:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0102f5a:	c0 
c0102f5b:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0102f62:	00 
c0102f63:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0102f6a:	e8 63 dd ff ff       	call   c0100cd2 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102f6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f76:	e8 57 0e 00 00       	call   c0103dd2 <alloc_pages>
c0102f7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102f82:	75 24                	jne    c0102fa8 <basic_check+0x8b>
c0102f84:	c7 44 24 0c f5 65 10 	movl   $0xc01065f5,0xc(%esp)
c0102f8b:	c0 
c0102f8c:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0102f93:	c0 
c0102f94:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0102f9b:	00 
c0102f9c:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0102fa3:	e8 2a dd ff ff       	call   c0100cd2 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102fa8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102faf:	e8 1e 0e 00 00       	call   c0103dd2 <alloc_pages>
c0102fb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102fb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102fbb:	75 24                	jne    c0102fe1 <basic_check+0xc4>
c0102fbd:	c7 44 24 0c 11 66 10 	movl   $0xc0106611,0xc(%esp)
c0102fc4:	c0 
c0102fc5:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0102fcc:	c0 
c0102fcd:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0102fd4:	00 
c0102fd5:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0102fdc:	e8 f1 dc ff ff       	call   c0100cd2 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102fe1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fe4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102fe7:	74 10                	je     c0102ff9 <basic_check+0xdc>
c0102fe9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102fef:	74 08                	je     c0102ff9 <basic_check+0xdc>
c0102ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ff4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ff7:	75 24                	jne    c010301d <basic_check+0x100>
c0102ff9:	c7 44 24 0c 30 66 10 	movl   $0xc0106630,0xc(%esp)
c0103000:	c0 
c0103001:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0103008:	c0 
c0103009:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0103010:	00 
c0103011:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0103018:	e8 b5 dc ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c010301d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103020:	89 04 24             	mov    %eax,(%esp)
c0103023:	e8 d3 f8 ff ff       	call   c01028fb <page_ref>
c0103028:	85 c0                	test   %eax,%eax
c010302a:	75 1e                	jne    c010304a <basic_check+0x12d>
c010302c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010302f:	89 04 24             	mov    %eax,(%esp)
c0103032:	e8 c4 f8 ff ff       	call   c01028fb <page_ref>
c0103037:	85 c0                	test   %eax,%eax
c0103039:	75 0f                	jne    c010304a <basic_check+0x12d>
c010303b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010303e:	89 04 24             	mov    %eax,(%esp)
c0103041:	e8 b5 f8 ff ff       	call   c01028fb <page_ref>
c0103046:	85 c0                	test   %eax,%eax
c0103048:	74 24                	je     c010306e <basic_check+0x151>
c010304a:	c7 44 24 0c 54 66 10 	movl   $0xc0106654,0xc(%esp)
c0103051:	c0 
c0103052:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0103059:	c0 
c010305a:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103061:	00 
c0103062:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0103069:	e8 64 dc ff ff       	call   c0100cd2 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c010306e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103071:	89 04 24             	mov    %eax,(%esp)
c0103074:	e8 6c f8 ff ff       	call   c01028e5 <page2pa>
c0103079:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c010307f:	c1 e2 0c             	shl    $0xc,%edx
c0103082:	39 d0                	cmp    %edx,%eax
c0103084:	72 24                	jb     c01030aa <basic_check+0x18d>
c0103086:	c7 44 24 0c 90 66 10 	movl   $0xc0106690,0xc(%esp)
c010308d:	c0 
c010308e:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0103095:	c0 
c0103096:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c010309d:	00 
c010309e:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c01030a5:	e8 28 dc ff ff       	call   c0100cd2 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01030aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030ad:	89 04 24             	mov    %eax,(%esp)
c01030b0:	e8 30 f8 ff ff       	call   c01028e5 <page2pa>
c01030b5:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c01030bb:	c1 e2 0c             	shl    $0xc,%edx
c01030be:	39 d0                	cmp    %edx,%eax
c01030c0:	72 24                	jb     c01030e6 <basic_check+0x1c9>
c01030c2:	c7 44 24 0c ad 66 10 	movl   $0xc01066ad,0xc(%esp)
c01030c9:	c0 
c01030ca:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c01030d1:	c0 
c01030d2:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c01030d9:	00 
c01030da:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c01030e1:	e8 ec db ff ff       	call   c0100cd2 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01030e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030e9:	89 04 24             	mov    %eax,(%esp)
c01030ec:	e8 f4 f7 ff ff       	call   c01028e5 <page2pa>
c01030f1:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c01030f7:	c1 e2 0c             	shl    $0xc,%edx
c01030fa:	39 d0                	cmp    %edx,%eax
c01030fc:	72 24                	jb     c0103122 <basic_check+0x205>
c01030fe:	c7 44 24 0c ca 66 10 	movl   $0xc01066ca,0xc(%esp)
c0103105:	c0 
c0103106:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c010310d:	c0 
c010310e:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0103115:	00 
c0103116:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c010311d:	e8 b0 db ff ff       	call   c0100cd2 <__panic>

    list_entry_t free_list_store = free_list;
c0103122:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c0103127:	8b 15 14 af 11 c0    	mov    0xc011af14,%edx
c010312d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103130:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103133:	c7 45 e0 10 af 11 c0 	movl   $0xc011af10,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010313a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010313d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103140:	89 50 04             	mov    %edx,0x4(%eax)
c0103143:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103146:	8b 50 04             	mov    0x4(%eax),%edx
c0103149:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010314c:	89 10                	mov    %edx,(%eax)
c010314e:	c7 45 dc 10 af 11 c0 	movl   $0xc011af10,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103155:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103158:	8b 40 04             	mov    0x4(%eax),%eax
c010315b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010315e:	0f 94 c0             	sete   %al
c0103161:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103164:	85 c0                	test   %eax,%eax
c0103166:	75 24                	jne    c010318c <basic_check+0x26f>
c0103168:	c7 44 24 0c e7 66 10 	movl   $0xc01066e7,0xc(%esp)
c010316f:	c0 
c0103170:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0103177:	c0 
c0103178:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c010317f:	00 
c0103180:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0103187:	e8 46 db ff ff       	call   c0100cd2 <__panic>

    unsigned int nr_free_store = nr_free;
c010318c:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0103191:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103194:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c010319b:	00 00 00 

    assert(alloc_page() == NULL);
c010319e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031a5:	e8 28 0c 00 00       	call   c0103dd2 <alloc_pages>
c01031aa:	85 c0                	test   %eax,%eax
c01031ac:	74 24                	je     c01031d2 <basic_check+0x2b5>
c01031ae:	c7 44 24 0c fe 66 10 	movl   $0xc01066fe,0xc(%esp)
c01031b5:	c0 
c01031b6:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c01031bd:	c0 
c01031be:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01031c5:	00 
c01031c6:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c01031cd:	e8 00 db ff ff       	call   c0100cd2 <__panic>

    free_page(p0);
c01031d2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01031d9:	00 
c01031da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031dd:	89 04 24             	mov    %eax,(%esp)
c01031e0:	e8 25 0c 00 00       	call   c0103e0a <free_pages>
    free_page(p1);
c01031e5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01031ec:	00 
c01031ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031f0:	89 04 24             	mov    %eax,(%esp)
c01031f3:	e8 12 0c 00 00       	call   c0103e0a <free_pages>
    free_page(p2);
c01031f8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01031ff:	00 
c0103200:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103203:	89 04 24             	mov    %eax,(%esp)
c0103206:	e8 ff 0b 00 00       	call   c0103e0a <free_pages>
    assert(nr_free == 3);
c010320b:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0103210:	83 f8 03             	cmp    $0x3,%eax
c0103213:	74 24                	je     c0103239 <basic_check+0x31c>
c0103215:	c7 44 24 0c 13 67 10 	movl   $0xc0106713,0xc(%esp)
c010321c:	c0 
c010321d:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0103224:	c0 
c0103225:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c010322c:	00 
c010322d:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0103234:	e8 99 da ff ff       	call   c0100cd2 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103239:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103240:	e8 8d 0b 00 00       	call   c0103dd2 <alloc_pages>
c0103245:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103248:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010324c:	75 24                	jne    c0103272 <basic_check+0x355>
c010324e:	c7 44 24 0c d9 65 10 	movl   $0xc01065d9,0xc(%esp)
c0103255:	c0 
c0103256:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c010325d:	c0 
c010325e:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0103265:	00 
c0103266:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c010326d:	e8 60 da ff ff       	call   c0100cd2 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103272:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103279:	e8 54 0b 00 00       	call   c0103dd2 <alloc_pages>
c010327e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103281:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103285:	75 24                	jne    c01032ab <basic_check+0x38e>
c0103287:	c7 44 24 0c f5 65 10 	movl   $0xc01065f5,0xc(%esp)
c010328e:	c0 
c010328f:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0103296:	c0 
c0103297:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c010329e:	00 
c010329f:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c01032a6:	e8 27 da ff ff       	call   c0100cd2 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01032ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032b2:	e8 1b 0b 00 00       	call   c0103dd2 <alloc_pages>
c01032b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01032ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01032be:	75 24                	jne    c01032e4 <basic_check+0x3c7>
c01032c0:	c7 44 24 0c 11 66 10 	movl   $0xc0106611,0xc(%esp)
c01032c7:	c0 
c01032c8:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c01032cf:	c0 
c01032d0:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01032d7:	00 
c01032d8:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c01032df:	e8 ee d9 ff ff       	call   c0100cd2 <__panic>

    assert(alloc_page() == NULL);
c01032e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032eb:	e8 e2 0a 00 00       	call   c0103dd2 <alloc_pages>
c01032f0:	85 c0                	test   %eax,%eax
c01032f2:	74 24                	je     c0103318 <basic_check+0x3fb>
c01032f4:	c7 44 24 0c fe 66 10 	movl   $0xc01066fe,0xc(%esp)
c01032fb:	c0 
c01032fc:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0103303:	c0 
c0103304:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c010330b:	00 
c010330c:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0103313:	e8 ba d9 ff ff       	call   c0100cd2 <__panic>

    free_page(p0);
c0103318:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010331f:	00 
c0103320:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103323:	89 04 24             	mov    %eax,(%esp)
c0103326:	e8 df 0a 00 00       	call   c0103e0a <free_pages>
c010332b:	c7 45 d8 10 af 11 c0 	movl   $0xc011af10,-0x28(%ebp)
c0103332:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103335:	8b 40 04             	mov    0x4(%eax),%eax
c0103338:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010333b:	0f 94 c0             	sete   %al
c010333e:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103341:	85 c0                	test   %eax,%eax
c0103343:	74 24                	je     c0103369 <basic_check+0x44c>
c0103345:	c7 44 24 0c 20 67 10 	movl   $0xc0106720,0xc(%esp)
c010334c:	c0 
c010334d:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0103354:	c0 
c0103355:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c010335c:	00 
c010335d:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0103364:	e8 69 d9 ff ff       	call   c0100cd2 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103369:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103370:	e8 5d 0a 00 00       	call   c0103dd2 <alloc_pages>
c0103375:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103378:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010337b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010337e:	74 24                	je     c01033a4 <basic_check+0x487>
c0103380:	c7 44 24 0c 38 67 10 	movl   $0xc0106738,0xc(%esp)
c0103387:	c0 
c0103388:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c010338f:	c0 
c0103390:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0103397:	00 
c0103398:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c010339f:	e8 2e d9 ff ff       	call   c0100cd2 <__panic>
    assert(alloc_page() == NULL);
c01033a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033ab:	e8 22 0a 00 00       	call   c0103dd2 <alloc_pages>
c01033b0:	85 c0                	test   %eax,%eax
c01033b2:	74 24                	je     c01033d8 <basic_check+0x4bb>
c01033b4:	c7 44 24 0c fe 66 10 	movl   $0xc01066fe,0xc(%esp)
c01033bb:	c0 
c01033bc:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c01033c3:	c0 
c01033c4:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c01033cb:	00 
c01033cc:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c01033d3:	e8 fa d8 ff ff       	call   c0100cd2 <__panic>

    assert(nr_free == 0);
c01033d8:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c01033dd:	85 c0                	test   %eax,%eax
c01033df:	74 24                	je     c0103405 <basic_check+0x4e8>
c01033e1:	c7 44 24 0c 51 67 10 	movl   $0xc0106751,0xc(%esp)
c01033e8:	c0 
c01033e9:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c01033f0:	c0 
c01033f1:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c01033f8:	00 
c01033f9:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0103400:	e8 cd d8 ff ff       	call   c0100cd2 <__panic>
    free_list = free_list_store;
c0103405:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103408:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010340b:	a3 10 af 11 c0       	mov    %eax,0xc011af10
c0103410:	89 15 14 af 11 c0    	mov    %edx,0xc011af14
    nr_free = nr_free_store;
c0103416:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103419:	a3 18 af 11 c0       	mov    %eax,0xc011af18

    free_page(p);
c010341e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103425:	00 
c0103426:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103429:	89 04 24             	mov    %eax,(%esp)
c010342c:	e8 d9 09 00 00       	call   c0103e0a <free_pages>
    free_page(p1);
c0103431:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103438:	00 
c0103439:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010343c:	89 04 24             	mov    %eax,(%esp)
c010343f:	e8 c6 09 00 00       	call   c0103e0a <free_pages>
    free_page(p2);
c0103444:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010344b:	00 
c010344c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010344f:	89 04 24             	mov    %eax,(%esp)
c0103452:	e8 b3 09 00 00       	call   c0103e0a <free_pages>
}
c0103457:	c9                   	leave  
c0103458:	c3                   	ret    

c0103459 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103459:	55                   	push   %ebp
c010345a:	89 e5                	mov    %esp,%ebp
c010345c:	53                   	push   %ebx
c010345d:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103463:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010346a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103471:	c7 45 ec 10 af 11 c0 	movl   $0xc011af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103478:	eb 6b                	jmp    c01034e5 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c010347a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010347d:	83 e8 0c             	sub    $0xc,%eax
c0103480:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103483:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103486:	83 c0 04             	add    $0x4,%eax
c0103489:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103490:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103493:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103496:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103499:	0f a3 10             	bt     %edx,(%eax)
c010349c:	19 c0                	sbb    %eax,%eax
c010349e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01034a1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01034a5:	0f 95 c0             	setne  %al
c01034a8:	0f b6 c0             	movzbl %al,%eax
c01034ab:	85 c0                	test   %eax,%eax
c01034ad:	75 24                	jne    c01034d3 <default_check+0x7a>
c01034af:	c7 44 24 0c 5e 67 10 	movl   $0xc010675e,0xc(%esp)
c01034b6:	c0 
c01034b7:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c01034be:	c0 
c01034bf:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c01034c6:	00 
c01034c7:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c01034ce:	e8 ff d7 ff ff       	call   c0100cd2 <__panic>
        count ++, total += p->property;
c01034d3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01034d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034da:	8b 50 08             	mov    0x8(%eax),%edx
c01034dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034e0:	01 d0                	add    %edx,%eax
c01034e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01034e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034e8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01034eb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01034ee:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01034f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01034f4:	81 7d ec 10 af 11 c0 	cmpl   $0xc011af10,-0x14(%ebp)
c01034fb:	0f 85 79 ff ff ff    	jne    c010347a <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103501:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103504:	e8 33 09 00 00       	call   c0103e3c <nr_free_pages>
c0103509:	39 c3                	cmp    %eax,%ebx
c010350b:	74 24                	je     c0103531 <default_check+0xd8>
c010350d:	c7 44 24 0c 6e 67 10 	movl   $0xc010676e,0xc(%esp)
c0103514:	c0 
c0103515:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c010351c:	c0 
c010351d:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0103524:	00 
c0103525:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c010352c:	e8 a1 d7 ff ff       	call   c0100cd2 <__panic>

    basic_check();
c0103531:	e8 e7 f9 ff ff       	call   c0102f1d <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103536:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010353d:	e8 90 08 00 00       	call   c0103dd2 <alloc_pages>
c0103542:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103545:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103549:	75 24                	jne    c010356f <default_check+0x116>
c010354b:	c7 44 24 0c 87 67 10 	movl   $0xc0106787,0xc(%esp)
c0103552:	c0 
c0103553:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c010355a:	c0 
c010355b:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c0103562:	00 
c0103563:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c010356a:	e8 63 d7 ff ff       	call   c0100cd2 <__panic>
    assert(!PageProperty(p0));
c010356f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103572:	83 c0 04             	add    $0x4,%eax
c0103575:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010357c:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010357f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103582:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103585:	0f a3 10             	bt     %edx,(%eax)
c0103588:	19 c0                	sbb    %eax,%eax
c010358a:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010358d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103591:	0f 95 c0             	setne  %al
c0103594:	0f b6 c0             	movzbl %al,%eax
c0103597:	85 c0                	test   %eax,%eax
c0103599:	74 24                	je     c01035bf <default_check+0x166>
c010359b:	c7 44 24 0c 92 67 10 	movl   $0xc0106792,0xc(%esp)
c01035a2:	c0 
c01035a3:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c01035aa:	c0 
c01035ab:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c01035b2:	00 
c01035b3:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c01035ba:	e8 13 d7 ff ff       	call   c0100cd2 <__panic>

    list_entry_t free_list_store = free_list;
c01035bf:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c01035c4:	8b 15 14 af 11 c0    	mov    0xc011af14,%edx
c01035ca:	89 45 80             	mov    %eax,-0x80(%ebp)
c01035cd:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01035d0:	c7 45 b4 10 af 11 c0 	movl   $0xc011af10,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01035d7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01035da:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01035dd:	89 50 04             	mov    %edx,0x4(%eax)
c01035e0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01035e3:	8b 50 04             	mov    0x4(%eax),%edx
c01035e6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01035e9:	89 10                	mov    %edx,(%eax)
c01035eb:	c7 45 b0 10 af 11 c0 	movl   $0xc011af10,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01035f2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01035f5:	8b 40 04             	mov    0x4(%eax),%eax
c01035f8:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c01035fb:	0f 94 c0             	sete   %al
c01035fe:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103601:	85 c0                	test   %eax,%eax
c0103603:	75 24                	jne    c0103629 <default_check+0x1d0>
c0103605:	c7 44 24 0c e7 66 10 	movl   $0xc01066e7,0xc(%esp)
c010360c:	c0 
c010360d:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0103614:	c0 
c0103615:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
c010361c:	00 
c010361d:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0103624:	e8 a9 d6 ff ff       	call   c0100cd2 <__panic>
    assert(alloc_page() == NULL);
c0103629:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103630:	e8 9d 07 00 00       	call   c0103dd2 <alloc_pages>
c0103635:	85 c0                	test   %eax,%eax
c0103637:	74 24                	je     c010365d <default_check+0x204>
c0103639:	c7 44 24 0c fe 66 10 	movl   $0xc01066fe,0xc(%esp)
c0103640:	c0 
c0103641:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0103648:	c0 
c0103649:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c0103650:	00 
c0103651:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0103658:	e8 75 d6 ff ff       	call   c0100cd2 <__panic>

    unsigned int nr_free_store = nr_free;
c010365d:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0103662:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103665:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c010366c:	00 00 00 

    free_pages(p0 + 2, 3);
c010366f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103672:	83 c0 28             	add    $0x28,%eax
c0103675:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010367c:	00 
c010367d:	89 04 24             	mov    %eax,(%esp)
c0103680:	e8 85 07 00 00       	call   c0103e0a <free_pages>
    assert(alloc_pages(4) == NULL);
c0103685:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010368c:	e8 41 07 00 00       	call   c0103dd2 <alloc_pages>
c0103691:	85 c0                	test   %eax,%eax
c0103693:	74 24                	je     c01036b9 <default_check+0x260>
c0103695:	c7 44 24 0c a4 67 10 	movl   $0xc01067a4,0xc(%esp)
c010369c:	c0 
c010369d:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c01036a4:	c0 
c01036a5:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
c01036ac:	00 
c01036ad:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c01036b4:	e8 19 d6 ff ff       	call   c0100cd2 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01036b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036bc:	83 c0 28             	add    $0x28,%eax
c01036bf:	83 c0 04             	add    $0x4,%eax
c01036c2:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01036c9:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036cc:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01036cf:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01036d2:	0f a3 10             	bt     %edx,(%eax)
c01036d5:	19 c0                	sbb    %eax,%eax
c01036d7:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01036da:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01036de:	0f 95 c0             	setne  %al
c01036e1:	0f b6 c0             	movzbl %al,%eax
c01036e4:	85 c0                	test   %eax,%eax
c01036e6:	74 0e                	je     c01036f6 <default_check+0x29d>
c01036e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036eb:	83 c0 28             	add    $0x28,%eax
c01036ee:	8b 40 08             	mov    0x8(%eax),%eax
c01036f1:	83 f8 03             	cmp    $0x3,%eax
c01036f4:	74 24                	je     c010371a <default_check+0x2c1>
c01036f6:	c7 44 24 0c bc 67 10 	movl   $0xc01067bc,0xc(%esp)
c01036fd:	c0 
c01036fe:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0103705:	c0 
c0103706:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
c010370d:	00 
c010370e:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0103715:	e8 b8 d5 ff ff       	call   c0100cd2 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010371a:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103721:	e8 ac 06 00 00       	call   c0103dd2 <alloc_pages>
c0103726:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103729:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010372d:	75 24                	jne    c0103753 <default_check+0x2fa>
c010372f:	c7 44 24 0c e8 67 10 	movl   $0xc01067e8,0xc(%esp)
c0103736:	c0 
c0103737:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c010373e:	c0 
c010373f:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c0103746:	00 
c0103747:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c010374e:	e8 7f d5 ff ff       	call   c0100cd2 <__panic>
    assert(alloc_page() == NULL);
c0103753:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010375a:	e8 73 06 00 00       	call   c0103dd2 <alloc_pages>
c010375f:	85 c0                	test   %eax,%eax
c0103761:	74 24                	je     c0103787 <default_check+0x32e>
c0103763:	c7 44 24 0c fe 66 10 	movl   $0xc01066fe,0xc(%esp)
c010376a:	c0 
c010376b:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0103772:	c0 
c0103773:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c010377a:	00 
c010377b:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0103782:	e8 4b d5 ff ff       	call   c0100cd2 <__panic>
    assert(p0 + 2 == p1);
c0103787:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010378a:	83 c0 28             	add    $0x28,%eax
c010378d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103790:	74 24                	je     c01037b6 <default_check+0x35d>
c0103792:	c7 44 24 0c 06 68 10 	movl   $0xc0106806,0xc(%esp)
c0103799:	c0 
c010379a:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c01037a1:	c0 
c01037a2:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c01037a9:	00 
c01037aa:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c01037b1:	e8 1c d5 ff ff       	call   c0100cd2 <__panic>

    p2 = p0 + 1;
c01037b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037b9:	83 c0 14             	add    $0x14,%eax
c01037bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01037bf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01037c6:	00 
c01037c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037ca:	89 04 24             	mov    %eax,(%esp)
c01037cd:	e8 38 06 00 00       	call   c0103e0a <free_pages>
    free_pages(p1, 3);
c01037d2:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01037d9:	00 
c01037da:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037dd:	89 04 24             	mov    %eax,(%esp)
c01037e0:	e8 25 06 00 00       	call   c0103e0a <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01037e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037e8:	83 c0 04             	add    $0x4,%eax
c01037eb:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01037f2:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01037f5:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01037f8:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01037fb:	0f a3 10             	bt     %edx,(%eax)
c01037fe:	19 c0                	sbb    %eax,%eax
c0103800:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103803:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103807:	0f 95 c0             	setne  %al
c010380a:	0f b6 c0             	movzbl %al,%eax
c010380d:	85 c0                	test   %eax,%eax
c010380f:	74 0b                	je     c010381c <default_check+0x3c3>
c0103811:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103814:	8b 40 08             	mov    0x8(%eax),%eax
c0103817:	83 f8 01             	cmp    $0x1,%eax
c010381a:	74 24                	je     c0103840 <default_check+0x3e7>
c010381c:	c7 44 24 0c 14 68 10 	movl   $0xc0106814,0xc(%esp)
c0103823:	c0 
c0103824:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c010382b:	c0 
c010382c:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c0103833:	00 
c0103834:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c010383b:	e8 92 d4 ff ff       	call   c0100cd2 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103840:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103843:	83 c0 04             	add    $0x4,%eax
c0103846:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010384d:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103850:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103853:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103856:	0f a3 10             	bt     %edx,(%eax)
c0103859:	19 c0                	sbb    %eax,%eax
c010385b:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010385e:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103862:	0f 95 c0             	setne  %al
c0103865:	0f b6 c0             	movzbl %al,%eax
c0103868:	85 c0                	test   %eax,%eax
c010386a:	74 0b                	je     c0103877 <default_check+0x41e>
c010386c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010386f:	8b 40 08             	mov    0x8(%eax),%eax
c0103872:	83 f8 03             	cmp    $0x3,%eax
c0103875:	74 24                	je     c010389b <default_check+0x442>
c0103877:	c7 44 24 0c 3c 68 10 	movl   $0xc010683c,0xc(%esp)
c010387e:	c0 
c010387f:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0103886:	c0 
c0103887:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c010388e:	00 
c010388f:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0103896:	e8 37 d4 ff ff       	call   c0100cd2 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010389b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038a2:	e8 2b 05 00 00       	call   c0103dd2 <alloc_pages>
c01038a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01038aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01038ad:	83 e8 14             	sub    $0x14,%eax
c01038b0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01038b3:	74 24                	je     c01038d9 <default_check+0x480>
c01038b5:	c7 44 24 0c 62 68 10 	movl   $0xc0106862,0xc(%esp)
c01038bc:	c0 
c01038bd:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c01038c4:	c0 
c01038c5:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
c01038cc:	00 
c01038cd:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c01038d4:	e8 f9 d3 ff ff       	call   c0100cd2 <__panic>
    free_page(p0);
c01038d9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01038e0:	00 
c01038e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038e4:	89 04 24             	mov    %eax,(%esp)
c01038e7:	e8 1e 05 00 00       	call   c0103e0a <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01038ec:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01038f3:	e8 da 04 00 00       	call   c0103dd2 <alloc_pages>
c01038f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01038fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01038fe:	83 c0 14             	add    $0x14,%eax
c0103901:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103904:	74 24                	je     c010392a <default_check+0x4d1>
c0103906:	c7 44 24 0c 80 68 10 	movl   $0xc0106880,0xc(%esp)
c010390d:	c0 
c010390e:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0103915:	c0 
c0103916:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
c010391d:	00 
c010391e:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0103925:	e8 a8 d3 ff ff       	call   c0100cd2 <__panic>

    free_pages(p0, 2);
c010392a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103931:	00 
c0103932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103935:	89 04 24             	mov    %eax,(%esp)
c0103938:	e8 cd 04 00 00       	call   c0103e0a <free_pages>
    free_page(p2);
c010393d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103944:	00 
c0103945:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103948:	89 04 24             	mov    %eax,(%esp)
c010394b:	e8 ba 04 00 00       	call   c0103e0a <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103950:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103957:	e8 76 04 00 00       	call   c0103dd2 <alloc_pages>
c010395c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010395f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103963:	75 24                	jne    c0103989 <default_check+0x530>
c0103965:	c7 44 24 0c a0 68 10 	movl   $0xc01068a0,0xc(%esp)
c010396c:	c0 
c010396d:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0103974:	c0 
c0103975:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
c010397c:	00 
c010397d:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0103984:	e8 49 d3 ff ff       	call   c0100cd2 <__panic>
    assert(alloc_page() == NULL);
c0103989:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103990:	e8 3d 04 00 00       	call   c0103dd2 <alloc_pages>
c0103995:	85 c0                	test   %eax,%eax
c0103997:	74 24                	je     c01039bd <default_check+0x564>
c0103999:	c7 44 24 0c fe 66 10 	movl   $0xc01066fe,0xc(%esp)
c01039a0:	c0 
c01039a1:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c01039a8:	c0 
c01039a9:	c7 44 24 04 48 01 00 	movl   $0x148,0x4(%esp)
c01039b0:	00 
c01039b1:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c01039b8:	e8 15 d3 ff ff       	call   c0100cd2 <__panic>

    assert(nr_free == 0);
c01039bd:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c01039c2:	85 c0                	test   %eax,%eax
c01039c4:	74 24                	je     c01039ea <default_check+0x591>
c01039c6:	c7 44 24 0c 51 67 10 	movl   $0xc0106751,0xc(%esp)
c01039cd:	c0 
c01039ce:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c01039d5:	c0 
c01039d6:	c7 44 24 04 4a 01 00 	movl   $0x14a,0x4(%esp)
c01039dd:	00 
c01039de:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c01039e5:	e8 e8 d2 ff ff       	call   c0100cd2 <__panic>
    nr_free = nr_free_store;
c01039ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01039ed:	a3 18 af 11 c0       	mov    %eax,0xc011af18

    free_list = free_list_store;
c01039f2:	8b 45 80             	mov    -0x80(%ebp),%eax
c01039f5:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01039f8:	a3 10 af 11 c0       	mov    %eax,0xc011af10
c01039fd:	89 15 14 af 11 c0    	mov    %edx,0xc011af14
    free_pages(p0, 5);
c0103a03:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103a0a:	00 
c0103a0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a0e:	89 04 24             	mov    %eax,(%esp)
c0103a11:	e8 f4 03 00 00       	call   c0103e0a <free_pages>

    le = &free_list;
c0103a16:	c7 45 ec 10 af 11 c0 	movl   $0xc011af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103a1d:	eb 1d                	jmp    c0103a3c <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103a1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a22:	83 e8 0c             	sub    $0xc,%eax
c0103a25:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103a28:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103a2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103a2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103a32:	8b 40 08             	mov    0x8(%eax),%eax
c0103a35:	29 c2                	sub    %eax,%edx
c0103a37:	89 d0                	mov    %edx,%eax
c0103a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a3f:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103a42:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103a45:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103a48:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103a4b:	81 7d ec 10 af 11 c0 	cmpl   $0xc011af10,-0x14(%ebp)
c0103a52:	75 cb                	jne    c0103a1f <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103a54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103a58:	74 24                	je     c0103a7e <default_check+0x625>
c0103a5a:	c7 44 24 0c be 68 10 	movl   $0xc01068be,0xc(%esp)
c0103a61:	c0 
c0103a62:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0103a69:	c0 
c0103a6a:	c7 44 24 04 55 01 00 	movl   $0x155,0x4(%esp)
c0103a71:	00 
c0103a72:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0103a79:	e8 54 d2 ff ff       	call   c0100cd2 <__panic>
    assert(total == 0);
c0103a7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a82:	74 24                	je     c0103aa8 <default_check+0x64f>
c0103a84:	c7 44 24 0c c9 68 10 	movl   $0xc01068c9,0xc(%esp)
c0103a8b:	c0 
c0103a8c:	c7 44 24 08 76 65 10 	movl   $0xc0106576,0x8(%esp)
c0103a93:	c0 
c0103a94:	c7 44 24 04 56 01 00 	movl   $0x156,0x4(%esp)
c0103a9b:	00 
c0103a9c:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0103aa3:	e8 2a d2 ff ff       	call   c0100cd2 <__panic>
}
c0103aa8:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103aae:	5b                   	pop    %ebx
c0103aaf:	5d                   	pop    %ebp
c0103ab0:	c3                   	ret    

c0103ab1 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103ab1:	55                   	push   %ebp
c0103ab2:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103ab4:	8b 55 08             	mov    0x8(%ebp),%edx
c0103ab7:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0103abc:	29 c2                	sub    %eax,%edx
c0103abe:	89 d0                	mov    %edx,%eax
c0103ac0:	c1 f8 02             	sar    $0x2,%eax
c0103ac3:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103ac9:	5d                   	pop    %ebp
c0103aca:	c3                   	ret    

c0103acb <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103acb:	55                   	push   %ebp
c0103acc:	89 e5                	mov    %esp,%ebp
c0103ace:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103ad1:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ad4:	89 04 24             	mov    %eax,(%esp)
c0103ad7:	e8 d5 ff ff ff       	call   c0103ab1 <page2ppn>
c0103adc:	c1 e0 0c             	shl    $0xc,%eax
}
c0103adf:	c9                   	leave  
c0103ae0:	c3                   	ret    

c0103ae1 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103ae1:	55                   	push   %ebp
c0103ae2:	89 e5                	mov    %esp,%ebp
c0103ae4:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103ae7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aea:	c1 e8 0c             	shr    $0xc,%eax
c0103aed:	89 c2                	mov    %eax,%edx
c0103aef:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103af4:	39 c2                	cmp    %eax,%edx
c0103af6:	72 1c                	jb     c0103b14 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103af8:	c7 44 24 08 04 69 10 	movl   $0xc0106904,0x8(%esp)
c0103aff:	c0 
c0103b00:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103b07:	00 
c0103b08:	c7 04 24 23 69 10 c0 	movl   $0xc0106923,(%esp)
c0103b0f:	e8 be d1 ff ff       	call   c0100cd2 <__panic>
    }
    return &pages[PPN(pa)];
c0103b14:	8b 0d 24 af 11 c0    	mov    0xc011af24,%ecx
c0103b1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b1d:	c1 e8 0c             	shr    $0xc,%eax
c0103b20:	89 c2                	mov    %eax,%edx
c0103b22:	89 d0                	mov    %edx,%eax
c0103b24:	c1 e0 02             	shl    $0x2,%eax
c0103b27:	01 d0                	add    %edx,%eax
c0103b29:	c1 e0 02             	shl    $0x2,%eax
c0103b2c:	01 c8                	add    %ecx,%eax
}
c0103b2e:	c9                   	leave  
c0103b2f:	c3                   	ret    

c0103b30 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103b30:	55                   	push   %ebp
c0103b31:	89 e5                	mov    %esp,%ebp
c0103b33:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103b36:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b39:	89 04 24             	mov    %eax,(%esp)
c0103b3c:	e8 8a ff ff ff       	call   c0103acb <page2pa>
c0103b41:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b47:	c1 e8 0c             	shr    $0xc,%eax
c0103b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b4d:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103b52:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103b55:	72 23                	jb     c0103b7a <page2kva+0x4a>
c0103b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b5a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103b5e:	c7 44 24 08 34 69 10 	movl   $0xc0106934,0x8(%esp)
c0103b65:	c0 
c0103b66:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103b6d:	00 
c0103b6e:	c7 04 24 23 69 10 c0 	movl   $0xc0106923,(%esp)
c0103b75:	e8 58 d1 ff ff       	call   c0100cd2 <__panic>
c0103b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b7d:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103b82:	c9                   	leave  
c0103b83:	c3                   	ret    

c0103b84 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103b84:	55                   	push   %ebp
c0103b85:	89 e5                	mov    %esp,%ebp
c0103b87:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103b8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b8d:	83 e0 01             	and    $0x1,%eax
c0103b90:	85 c0                	test   %eax,%eax
c0103b92:	75 1c                	jne    c0103bb0 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103b94:	c7 44 24 08 58 69 10 	movl   $0xc0106958,0x8(%esp)
c0103b9b:	c0 
c0103b9c:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103ba3:	00 
c0103ba4:	c7 04 24 23 69 10 c0 	movl   $0xc0106923,(%esp)
c0103bab:	e8 22 d1 ff ff       	call   c0100cd2 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103bb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bb3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103bb8:	89 04 24             	mov    %eax,(%esp)
c0103bbb:	e8 21 ff ff ff       	call   c0103ae1 <pa2page>
}
c0103bc0:	c9                   	leave  
c0103bc1:	c3                   	ret    

c0103bc2 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0103bc2:	55                   	push   %ebp
c0103bc3:	89 e5                	mov    %esp,%ebp
c0103bc5:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103bc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bcb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103bd0:	89 04 24             	mov    %eax,(%esp)
c0103bd3:	e8 09 ff ff ff       	call   c0103ae1 <pa2page>
}
c0103bd8:	c9                   	leave  
c0103bd9:	c3                   	ret    

c0103bda <page_ref>:

static inline int
page_ref(struct Page *page) {
c0103bda:	55                   	push   %ebp
c0103bdb:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103bdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103be0:	8b 00                	mov    (%eax),%eax
}
c0103be2:	5d                   	pop    %ebp
c0103be3:	c3                   	ret    

c0103be4 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c0103be4:	55                   	push   %ebp
c0103be5:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103be7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bea:	8b 00                	mov    (%eax),%eax
c0103bec:	8d 50 01             	lea    0x1(%eax),%edx
c0103bef:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bf2:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103bf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bf7:	8b 00                	mov    (%eax),%eax
}
c0103bf9:	5d                   	pop    %ebp
c0103bfa:	c3                   	ret    

c0103bfb <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103bfb:	55                   	push   %ebp
c0103bfc:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103bfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c01:	8b 00                	mov    (%eax),%eax
c0103c03:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103c06:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c09:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103c0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c0e:	8b 00                	mov    (%eax),%eax
}
c0103c10:	5d                   	pop    %ebp
c0103c11:	c3                   	ret    

c0103c12 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103c12:	55                   	push   %ebp
c0103c13:	89 e5                	mov    %esp,%ebp
c0103c15:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103c18:	9c                   	pushf  
c0103c19:	58                   	pop    %eax
c0103c1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103c20:	25 00 02 00 00       	and    $0x200,%eax
c0103c25:	85 c0                	test   %eax,%eax
c0103c27:	74 0c                	je     c0103c35 <__intr_save+0x23>
        intr_disable();
c0103c29:	e8 98 da ff ff       	call   c01016c6 <intr_disable>
        return 1;
c0103c2e:	b8 01 00 00 00       	mov    $0x1,%eax
c0103c33:	eb 05                	jmp    c0103c3a <__intr_save+0x28>
    }
    return 0;
c0103c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103c3a:	c9                   	leave  
c0103c3b:	c3                   	ret    

c0103c3c <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103c3c:	55                   	push   %ebp
c0103c3d:	89 e5                	mov    %esp,%ebp
c0103c3f:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103c42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103c46:	74 05                	je     c0103c4d <__intr_restore+0x11>
        intr_enable();
c0103c48:	e8 73 da ff ff       	call   c01016c0 <intr_enable>
    }
}
c0103c4d:	c9                   	leave  
c0103c4e:	c3                   	ret    

c0103c4f <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103c4f:	55                   	push   %ebp
c0103c50:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103c52:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c55:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103c58:	b8 23 00 00 00       	mov    $0x23,%eax
c0103c5d:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103c5f:	b8 23 00 00 00       	mov    $0x23,%eax
c0103c64:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103c66:	b8 10 00 00 00       	mov    $0x10,%eax
c0103c6b:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103c6d:	b8 10 00 00 00       	mov    $0x10,%eax
c0103c72:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103c74:	b8 10 00 00 00       	mov    $0x10,%eax
c0103c79:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103c7b:	ea 82 3c 10 c0 08 00 	ljmp   $0x8,$0xc0103c82
}
c0103c82:	5d                   	pop    %ebp
c0103c83:	c3                   	ret    

c0103c84 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103c84:	55                   	push   %ebp
c0103c85:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103c87:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c8a:	a3 a4 ae 11 c0       	mov    %eax,0xc011aea4
}
c0103c8f:	5d                   	pop    %ebp
c0103c90:	c3                   	ret    

c0103c91 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103c91:	55                   	push   %ebp
c0103c92:	89 e5                	mov    %esp,%ebp
c0103c94:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103c97:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103c9c:	89 04 24             	mov    %eax,(%esp)
c0103c9f:	e8 e0 ff ff ff       	call   c0103c84 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103ca4:	66 c7 05 a8 ae 11 c0 	movw   $0x10,0xc011aea8
c0103cab:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103cad:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103cb4:	68 00 
c0103cb6:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103cbb:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103cc1:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103cc6:	c1 e8 10             	shr    $0x10,%eax
c0103cc9:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103cce:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103cd5:	83 e0 f0             	and    $0xfffffff0,%eax
c0103cd8:	83 c8 09             	or     $0x9,%eax
c0103cdb:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103ce0:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103ce7:	83 e0 ef             	and    $0xffffffef,%eax
c0103cea:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103cef:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103cf6:	83 e0 9f             	and    $0xffffff9f,%eax
c0103cf9:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103cfe:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103d05:	83 c8 80             	or     $0xffffff80,%eax
c0103d08:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103d0d:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103d14:	83 e0 f0             	and    $0xfffffff0,%eax
c0103d17:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103d1c:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103d23:	83 e0 ef             	and    $0xffffffef,%eax
c0103d26:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103d2b:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103d32:	83 e0 df             	and    $0xffffffdf,%eax
c0103d35:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103d3a:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103d41:	83 c8 40             	or     $0x40,%eax
c0103d44:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103d49:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103d50:	83 e0 7f             	and    $0x7f,%eax
c0103d53:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103d58:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103d5d:	c1 e8 18             	shr    $0x18,%eax
c0103d60:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103d65:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103d6c:	e8 de fe ff ff       	call   c0103c4f <lgdt>
c0103d71:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103d77:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103d7b:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103d7e:	c9                   	leave  
c0103d7f:	c3                   	ret    

c0103d80 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103d80:	55                   	push   %ebp
c0103d81:	89 e5                	mov    %esp,%ebp
c0103d83:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103d86:	c7 05 1c af 11 c0 e8 	movl   $0xc01068e8,0xc011af1c
c0103d8d:	68 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103d90:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103d95:	8b 00                	mov    (%eax),%eax
c0103d97:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103d9b:	c7 04 24 84 69 10 c0 	movl   $0xc0106984,(%esp)
c0103da2:	e8 a1 c5 ff ff       	call   c0100348 <cprintf>
    pmm_manager->init();
c0103da7:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103dac:	8b 40 04             	mov    0x4(%eax),%eax
c0103daf:	ff d0                	call   *%eax
}
c0103db1:	c9                   	leave  
c0103db2:	c3                   	ret    

c0103db3 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103db3:	55                   	push   %ebp
c0103db4:	89 e5                	mov    %esp,%ebp
c0103db6:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103db9:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103dbe:	8b 40 08             	mov    0x8(%eax),%eax
c0103dc1:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103dc4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103dc8:	8b 55 08             	mov    0x8(%ebp),%edx
c0103dcb:	89 14 24             	mov    %edx,(%esp)
c0103dce:	ff d0                	call   *%eax
}
c0103dd0:	c9                   	leave  
c0103dd1:	c3                   	ret    

c0103dd2 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103dd2:	55                   	push   %ebp
c0103dd3:	89 e5                	mov    %esp,%ebp
c0103dd5:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103dd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103ddf:	e8 2e fe ff ff       	call   c0103c12 <__intr_save>
c0103de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103de7:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103dec:	8b 40 0c             	mov    0xc(%eax),%eax
c0103def:	8b 55 08             	mov    0x8(%ebp),%edx
c0103df2:	89 14 24             	mov    %edx,(%esp)
c0103df5:	ff d0                	call   *%eax
c0103df7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103dfd:	89 04 24             	mov    %eax,(%esp)
c0103e00:	e8 37 fe ff ff       	call   c0103c3c <__intr_restore>
    return page;
c0103e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103e08:	c9                   	leave  
c0103e09:	c3                   	ret    

c0103e0a <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103e0a:	55                   	push   %ebp
c0103e0b:	89 e5                	mov    %esp,%ebp
c0103e0d:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103e10:	e8 fd fd ff ff       	call   c0103c12 <__intr_save>
c0103e15:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103e18:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103e1d:	8b 40 10             	mov    0x10(%eax),%eax
c0103e20:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103e23:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e27:	8b 55 08             	mov    0x8(%ebp),%edx
c0103e2a:	89 14 24             	mov    %edx,(%esp)
c0103e2d:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e32:	89 04 24             	mov    %eax,(%esp)
c0103e35:	e8 02 fe ff ff       	call   c0103c3c <__intr_restore>
}
c0103e3a:	c9                   	leave  
c0103e3b:	c3                   	ret    

c0103e3c <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103e3c:	55                   	push   %ebp
c0103e3d:	89 e5                	mov    %esp,%ebp
c0103e3f:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103e42:	e8 cb fd ff ff       	call   c0103c12 <__intr_save>
c0103e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103e4a:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103e4f:	8b 40 14             	mov    0x14(%eax),%eax
c0103e52:	ff d0                	call   *%eax
c0103e54:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e5a:	89 04 24             	mov    %eax,(%esp)
c0103e5d:	e8 da fd ff ff       	call   c0103c3c <__intr_restore>
    return ret;
c0103e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103e65:	c9                   	leave  
c0103e66:	c3                   	ret    

c0103e67 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103e67:	55                   	push   %ebp
c0103e68:	89 e5                	mov    %esp,%ebp
c0103e6a:	57                   	push   %edi
c0103e6b:	56                   	push   %esi
c0103e6c:	53                   	push   %ebx
c0103e6d:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103e73:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103e7a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103e81:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103e88:	c7 04 24 9b 69 10 c0 	movl   $0xc010699b,(%esp)
c0103e8f:	e8 b4 c4 ff ff       	call   c0100348 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103e94:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103e9b:	e9 15 01 00 00       	jmp    c0103fb5 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103ea0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ea3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ea6:	89 d0                	mov    %edx,%eax
c0103ea8:	c1 e0 02             	shl    $0x2,%eax
c0103eab:	01 d0                	add    %edx,%eax
c0103ead:	c1 e0 02             	shl    $0x2,%eax
c0103eb0:	01 c8                	add    %ecx,%eax
c0103eb2:	8b 50 08             	mov    0x8(%eax),%edx
c0103eb5:	8b 40 04             	mov    0x4(%eax),%eax
c0103eb8:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103ebb:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103ebe:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ec1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ec4:	89 d0                	mov    %edx,%eax
c0103ec6:	c1 e0 02             	shl    $0x2,%eax
c0103ec9:	01 d0                	add    %edx,%eax
c0103ecb:	c1 e0 02             	shl    $0x2,%eax
c0103ece:	01 c8                	add    %ecx,%eax
c0103ed0:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103ed3:	8b 58 10             	mov    0x10(%eax),%ebx
c0103ed6:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103ed9:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103edc:	01 c8                	add    %ecx,%eax
c0103ede:	11 da                	adc    %ebx,%edx
c0103ee0:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103ee3:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103ee6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ee9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103eec:	89 d0                	mov    %edx,%eax
c0103eee:	c1 e0 02             	shl    $0x2,%eax
c0103ef1:	01 d0                	add    %edx,%eax
c0103ef3:	c1 e0 02             	shl    $0x2,%eax
c0103ef6:	01 c8                	add    %ecx,%eax
c0103ef8:	83 c0 14             	add    $0x14,%eax
c0103efb:	8b 00                	mov    (%eax),%eax
c0103efd:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103f03:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f06:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103f09:	83 c0 ff             	add    $0xffffffff,%eax
c0103f0c:	83 d2 ff             	adc    $0xffffffff,%edx
c0103f0f:	89 c6                	mov    %eax,%esi
c0103f11:	89 d7                	mov    %edx,%edi
c0103f13:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f16:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f19:	89 d0                	mov    %edx,%eax
c0103f1b:	c1 e0 02             	shl    $0x2,%eax
c0103f1e:	01 d0                	add    %edx,%eax
c0103f20:	c1 e0 02             	shl    $0x2,%eax
c0103f23:	01 c8                	add    %ecx,%eax
c0103f25:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103f28:	8b 58 10             	mov    0x10(%eax),%ebx
c0103f2b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103f31:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103f35:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103f39:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103f3d:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103f40:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103f43:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103f47:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103f4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103f4f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103f53:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0103f5a:	e8 e9 c3 ff ff       	call   c0100348 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103f5f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f62:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f65:	89 d0                	mov    %edx,%eax
c0103f67:	c1 e0 02             	shl    $0x2,%eax
c0103f6a:	01 d0                	add    %edx,%eax
c0103f6c:	c1 e0 02             	shl    $0x2,%eax
c0103f6f:	01 c8                	add    %ecx,%eax
c0103f71:	83 c0 14             	add    $0x14,%eax
c0103f74:	8b 00                	mov    (%eax),%eax
c0103f76:	83 f8 01             	cmp    $0x1,%eax
c0103f79:	75 36                	jne    c0103fb1 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103f7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103f81:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103f84:	77 2b                	ja     c0103fb1 <page_init+0x14a>
c0103f86:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103f89:	72 05                	jb     c0103f90 <page_init+0x129>
c0103f8b:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103f8e:	73 21                	jae    c0103fb1 <page_init+0x14a>
c0103f90:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103f94:	77 1b                	ja     c0103fb1 <page_init+0x14a>
c0103f96:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103f9a:	72 09                	jb     c0103fa5 <page_init+0x13e>
c0103f9c:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103fa3:	77 0c                	ja     c0103fb1 <page_init+0x14a>
                maxpa = end;
c0103fa5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103fa8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103fab:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103fae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103fb1:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103fb5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103fb8:	8b 00                	mov    (%eax),%eax
c0103fba:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103fbd:	0f 8f dd fe ff ff    	jg     c0103ea0 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103fc3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103fc7:	72 1d                	jb     c0103fe6 <page_init+0x17f>
c0103fc9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103fcd:	77 09                	ja     c0103fd8 <page_init+0x171>
c0103fcf:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103fd6:	76 0e                	jbe    c0103fe6 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103fd8:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103fdf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103fe6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103fe9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103fec:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103ff0:	c1 ea 0c             	shr    $0xc,%edx
c0103ff3:	a3 80 ae 11 c0       	mov    %eax,0xc011ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103ff8:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103fff:	b8 28 af 11 c0       	mov    $0xc011af28,%eax
c0104004:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104007:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010400a:	01 d0                	add    %edx,%eax
c010400c:	89 45 a8             	mov    %eax,-0x58(%ebp)
c010400f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104012:	ba 00 00 00 00       	mov    $0x0,%edx
c0104017:	f7 75 ac             	divl   -0x54(%ebp)
c010401a:	89 d0                	mov    %edx,%eax
c010401c:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010401f:	29 c2                	sub    %eax,%edx
c0104021:	89 d0                	mov    %edx,%eax
c0104023:	a3 24 af 11 c0       	mov    %eax,0xc011af24

    for (i = 0; i < npage; i ++) {
c0104028:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010402f:	eb 2f                	jmp    c0104060 <page_init+0x1f9>
        SetPageReserved(pages + i);
c0104031:	8b 0d 24 af 11 c0    	mov    0xc011af24,%ecx
c0104037:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010403a:	89 d0                	mov    %edx,%eax
c010403c:	c1 e0 02             	shl    $0x2,%eax
c010403f:	01 d0                	add    %edx,%eax
c0104041:	c1 e0 02             	shl    $0x2,%eax
c0104044:	01 c8                	add    %ecx,%eax
c0104046:	83 c0 04             	add    $0x4,%eax
c0104049:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0104050:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104053:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104056:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104059:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c010405c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104060:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104063:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104068:	39 c2                	cmp    %eax,%edx
c010406a:	72 c5                	jb     c0104031 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c010406c:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0104072:	89 d0                	mov    %edx,%eax
c0104074:	c1 e0 02             	shl    $0x2,%eax
c0104077:	01 d0                	add    %edx,%eax
c0104079:	c1 e0 02             	shl    $0x2,%eax
c010407c:	89 c2                	mov    %eax,%edx
c010407e:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0104083:	01 d0                	add    %edx,%eax
c0104085:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0104088:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c010408f:	77 23                	ja     c01040b4 <page_init+0x24d>
c0104091:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104094:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104098:	c7 44 24 08 d8 69 10 	movl   $0xc01069d8,0x8(%esp)
c010409f:	c0 
c01040a0:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c01040a7:	00 
c01040a8:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c01040af:	e8 1e cc ff ff       	call   c0100cd2 <__panic>
c01040b4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01040b7:	05 00 00 00 40       	add    $0x40000000,%eax
c01040bc:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c01040bf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01040c6:	e9 74 01 00 00       	jmp    c010423f <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01040cb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040d1:	89 d0                	mov    %edx,%eax
c01040d3:	c1 e0 02             	shl    $0x2,%eax
c01040d6:	01 d0                	add    %edx,%eax
c01040d8:	c1 e0 02             	shl    $0x2,%eax
c01040db:	01 c8                	add    %ecx,%eax
c01040dd:	8b 50 08             	mov    0x8(%eax),%edx
c01040e0:	8b 40 04             	mov    0x4(%eax),%eax
c01040e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01040e6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01040e9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040ef:	89 d0                	mov    %edx,%eax
c01040f1:	c1 e0 02             	shl    $0x2,%eax
c01040f4:	01 d0                	add    %edx,%eax
c01040f6:	c1 e0 02             	shl    $0x2,%eax
c01040f9:	01 c8                	add    %ecx,%eax
c01040fb:	8b 48 0c             	mov    0xc(%eax),%ecx
c01040fe:	8b 58 10             	mov    0x10(%eax),%ebx
c0104101:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104104:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104107:	01 c8                	add    %ecx,%eax
c0104109:	11 da                	adc    %ebx,%edx
c010410b:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010410e:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104111:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104114:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104117:	89 d0                	mov    %edx,%eax
c0104119:	c1 e0 02             	shl    $0x2,%eax
c010411c:	01 d0                	add    %edx,%eax
c010411e:	c1 e0 02             	shl    $0x2,%eax
c0104121:	01 c8                	add    %ecx,%eax
c0104123:	83 c0 14             	add    $0x14,%eax
c0104126:	8b 00                	mov    (%eax),%eax
c0104128:	83 f8 01             	cmp    $0x1,%eax
c010412b:	0f 85 0a 01 00 00    	jne    c010423b <page_init+0x3d4>
            if (begin < freemem) {
c0104131:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104134:	ba 00 00 00 00       	mov    $0x0,%edx
c0104139:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010413c:	72 17                	jb     c0104155 <page_init+0x2ee>
c010413e:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104141:	77 05                	ja     c0104148 <page_init+0x2e1>
c0104143:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104146:	76 0d                	jbe    c0104155 <page_init+0x2ee>
                begin = freemem;
c0104148:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010414b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010414e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104155:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104159:	72 1d                	jb     c0104178 <page_init+0x311>
c010415b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010415f:	77 09                	ja     c010416a <page_init+0x303>
c0104161:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104168:	76 0e                	jbe    c0104178 <page_init+0x311>
                end = KMEMSIZE;
c010416a:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104171:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104178:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010417b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010417e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104181:	0f 87 b4 00 00 00    	ja     c010423b <page_init+0x3d4>
c0104187:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010418a:	72 09                	jb     c0104195 <page_init+0x32e>
c010418c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010418f:	0f 83 a6 00 00 00    	jae    c010423b <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0104195:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c010419c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010419f:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01041a2:	01 d0                	add    %edx,%eax
c01041a4:	83 e8 01             	sub    $0x1,%eax
c01041a7:	89 45 98             	mov    %eax,-0x68(%ebp)
c01041aa:	8b 45 98             	mov    -0x68(%ebp),%eax
c01041ad:	ba 00 00 00 00       	mov    $0x0,%edx
c01041b2:	f7 75 9c             	divl   -0x64(%ebp)
c01041b5:	89 d0                	mov    %edx,%eax
c01041b7:	8b 55 98             	mov    -0x68(%ebp),%edx
c01041ba:	29 c2                	sub    %eax,%edx
c01041bc:	89 d0                	mov    %edx,%eax
c01041be:	ba 00 00 00 00       	mov    $0x0,%edx
c01041c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01041c6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01041c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01041cc:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01041cf:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01041d2:	ba 00 00 00 00       	mov    $0x0,%edx
c01041d7:	89 c7                	mov    %eax,%edi
c01041d9:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01041df:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01041e2:	89 d0                	mov    %edx,%eax
c01041e4:	83 e0 00             	and    $0x0,%eax
c01041e7:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01041ea:	8b 45 80             	mov    -0x80(%ebp),%eax
c01041ed:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01041f0:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01041f3:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01041f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01041fc:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01041ff:	77 3a                	ja     c010423b <page_init+0x3d4>
c0104201:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104204:	72 05                	jb     c010420b <page_init+0x3a4>
c0104206:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104209:	73 30                	jae    c010423b <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010420b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010420e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104211:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104214:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104217:	29 c8                	sub    %ecx,%eax
c0104219:	19 da                	sbb    %ebx,%edx
c010421b:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010421f:	c1 ea 0c             	shr    $0xc,%edx
c0104222:	89 c3                	mov    %eax,%ebx
c0104224:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104227:	89 04 24             	mov    %eax,(%esp)
c010422a:	e8 b2 f8 ff ff       	call   c0103ae1 <pa2page>
c010422f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104233:	89 04 24             	mov    %eax,(%esp)
c0104236:	e8 78 fb ff ff       	call   c0103db3 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c010423b:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010423f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104242:	8b 00                	mov    (%eax),%eax
c0104244:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104247:	0f 8f 7e fe ff ff    	jg     c01040cb <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c010424d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104253:	5b                   	pop    %ebx
c0104254:	5e                   	pop    %esi
c0104255:	5f                   	pop    %edi
c0104256:	5d                   	pop    %ebp
c0104257:	c3                   	ret    

c0104258 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104258:	55                   	push   %ebp
c0104259:	89 e5                	mov    %esp,%ebp
c010425b:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010425e:	8b 45 14             	mov    0x14(%ebp),%eax
c0104261:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104264:	31 d0                	xor    %edx,%eax
c0104266:	25 ff 0f 00 00       	and    $0xfff,%eax
c010426b:	85 c0                	test   %eax,%eax
c010426d:	74 24                	je     c0104293 <boot_map_segment+0x3b>
c010426f:	c7 44 24 0c 0a 6a 10 	movl   $0xc0106a0a,0xc(%esp)
c0104276:	c0 
c0104277:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c010427e:	c0 
c010427f:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0104286:	00 
c0104287:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c010428e:	e8 3f ca ff ff       	call   c0100cd2 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104293:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010429a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010429d:	25 ff 0f 00 00       	and    $0xfff,%eax
c01042a2:	89 c2                	mov    %eax,%edx
c01042a4:	8b 45 10             	mov    0x10(%ebp),%eax
c01042a7:	01 c2                	add    %eax,%edx
c01042a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042ac:	01 d0                	add    %edx,%eax
c01042ae:	83 e8 01             	sub    $0x1,%eax
c01042b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01042b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042b7:	ba 00 00 00 00       	mov    $0x0,%edx
c01042bc:	f7 75 f0             	divl   -0x10(%ebp)
c01042bf:	89 d0                	mov    %edx,%eax
c01042c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01042c4:	29 c2                	sub    %eax,%edx
c01042c6:	89 d0                	mov    %edx,%eax
c01042c8:	c1 e8 0c             	shr    $0xc,%eax
c01042cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01042ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01042d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01042dc:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01042df:	8b 45 14             	mov    0x14(%ebp),%eax
c01042e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01042e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01042ed:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01042f0:	eb 6b                	jmp    c010435d <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01042f2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01042f9:	00 
c01042fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104301:	8b 45 08             	mov    0x8(%ebp),%eax
c0104304:	89 04 24             	mov    %eax,(%esp)
c0104307:	e8 82 01 00 00       	call   c010448e <get_pte>
c010430c:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010430f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104313:	75 24                	jne    c0104339 <boot_map_segment+0xe1>
c0104315:	c7 44 24 0c 36 6a 10 	movl   $0xc0106a36,0xc(%esp)
c010431c:	c0 
c010431d:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104324:	c0 
c0104325:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c010432c:	00 
c010432d:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104334:	e8 99 c9 ff ff       	call   c0100cd2 <__panic>
        *ptep = pa | PTE_P | perm;
c0104339:	8b 45 18             	mov    0x18(%ebp),%eax
c010433c:	8b 55 14             	mov    0x14(%ebp),%edx
c010433f:	09 d0                	or     %edx,%eax
c0104341:	83 c8 01             	or     $0x1,%eax
c0104344:	89 c2                	mov    %eax,%edx
c0104346:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104349:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010434b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010434f:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104356:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c010435d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104361:	75 8f                	jne    c01042f2 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104363:	c9                   	leave  
c0104364:	c3                   	ret    

c0104365 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104365:	55                   	push   %ebp
c0104366:	89 e5                	mov    %esp,%ebp
c0104368:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c010436b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104372:	e8 5b fa ff ff       	call   c0103dd2 <alloc_pages>
c0104377:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010437a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010437e:	75 1c                	jne    c010439c <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104380:	c7 44 24 08 43 6a 10 	movl   $0xc0106a43,0x8(%esp)
c0104387:	c0 
c0104388:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c010438f:	00 
c0104390:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104397:	e8 36 c9 ff ff       	call   c0100cd2 <__panic>
    }
    return page2kva(p);
c010439c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010439f:	89 04 24             	mov    %eax,(%esp)
c01043a2:	e8 89 f7 ff ff       	call   c0103b30 <page2kva>
}
c01043a7:	c9                   	leave  
c01043a8:	c3                   	ret    

c01043a9 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01043a9:	55                   	push   %ebp
c01043aa:	89 e5                	mov    %esp,%ebp
c01043ac:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01043af:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01043b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01043b7:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01043be:	77 23                	ja     c01043e3 <pmm_init+0x3a>
c01043c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043c7:	c7 44 24 08 d8 69 10 	movl   $0xc01069d8,0x8(%esp)
c01043ce:	c0 
c01043cf:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01043d6:	00 
c01043d7:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c01043de:	e8 ef c8 ff ff       	call   c0100cd2 <__panic>
c01043e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043e6:	05 00 00 00 40       	add    $0x40000000,%eax
c01043eb:	a3 20 af 11 c0       	mov    %eax,0xc011af20
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01043f0:	e8 8b f9 ff ff       	call   c0103d80 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01043f5:	e8 6d fa ff ff       	call   c0103e67 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01043fa:	e8 4c 02 00 00       	call   c010464b <check_alloc_page>

    check_pgdir();
c01043ff:	e8 65 02 00 00       	call   c0104669 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104404:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104409:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c010440f:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104414:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104417:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010441e:	77 23                	ja     c0104443 <pmm_init+0x9a>
c0104420:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104423:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104427:	c7 44 24 08 d8 69 10 	movl   $0xc01069d8,0x8(%esp)
c010442e:	c0 
c010442f:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0104436:	00 
c0104437:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c010443e:	e8 8f c8 ff ff       	call   c0100cd2 <__panic>
c0104443:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104446:	05 00 00 00 40       	add    $0x40000000,%eax
c010444b:	83 c8 03             	or     $0x3,%eax
c010444e:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104450:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104455:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010445c:	00 
c010445d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104464:	00 
c0104465:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010446c:	38 
c010446d:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104474:	c0 
c0104475:	89 04 24             	mov    %eax,(%esp)
c0104478:	e8 db fd ff ff       	call   c0104258 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010447d:	e8 0f f8 ff ff       	call   c0103c91 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104482:	e8 7d 08 00 00       	call   c0104d04 <check_boot_pgdir>

    print_pgdir();
c0104487:	e8 05 0d 00 00       	call   c0105191 <print_pgdir>

}
c010448c:	c9                   	leave  
c010448d:	c3                   	ret    

c010448e <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010448e:	55                   	push   %ebp
c010448f:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c0104491:	5d                   	pop    %ebp
c0104492:	c3                   	ret    

c0104493 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104493:	55                   	push   %ebp
c0104494:	89 e5                	mov    %esp,%ebp
c0104496:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104499:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01044a0:	00 
c01044a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01044a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01044ab:	89 04 24             	mov    %eax,(%esp)
c01044ae:	e8 db ff ff ff       	call   c010448e <get_pte>
c01044b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01044b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01044ba:	74 08                	je     c01044c4 <get_page+0x31>
        *ptep_store = ptep;
c01044bc:	8b 45 10             	mov    0x10(%ebp),%eax
c01044bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01044c2:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01044c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044c8:	74 1b                	je     c01044e5 <get_page+0x52>
c01044ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044cd:	8b 00                	mov    (%eax),%eax
c01044cf:	83 e0 01             	and    $0x1,%eax
c01044d2:	85 c0                	test   %eax,%eax
c01044d4:	74 0f                	je     c01044e5 <get_page+0x52>
        return pte2page(*ptep);
c01044d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044d9:	8b 00                	mov    (%eax),%eax
c01044db:	89 04 24             	mov    %eax,(%esp)
c01044de:	e8 a1 f6 ff ff       	call   c0103b84 <pte2page>
c01044e3:	eb 05                	jmp    c01044ea <get_page+0x57>
    }
    return NULL;
c01044e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01044ea:	c9                   	leave  
c01044eb:	c3                   	ret    

c01044ec <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01044ec:	55                   	push   %ebp
c01044ed:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c01044ef:	5d                   	pop    %ebp
c01044f0:	c3                   	ret    

c01044f1 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01044f1:	55                   	push   %ebp
c01044f2:	89 e5                	mov    %esp,%ebp
c01044f4:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01044f7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01044fe:	00 
c01044ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104502:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104506:	8b 45 08             	mov    0x8(%ebp),%eax
c0104509:	89 04 24             	mov    %eax,(%esp)
c010450c:	e8 7d ff ff ff       	call   c010448e <get_pte>
c0104511:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c0104514:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0104518:	74 19                	je     c0104533 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010451a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010451d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104521:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104524:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104528:	8b 45 08             	mov    0x8(%ebp),%eax
c010452b:	89 04 24             	mov    %eax,(%esp)
c010452e:	e8 b9 ff ff ff       	call   c01044ec <page_remove_pte>
    }
}
c0104533:	c9                   	leave  
c0104534:	c3                   	ret    

c0104535 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104535:	55                   	push   %ebp
c0104536:	89 e5                	mov    %esp,%ebp
c0104538:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010453b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104542:	00 
c0104543:	8b 45 10             	mov    0x10(%ebp),%eax
c0104546:	89 44 24 04          	mov    %eax,0x4(%esp)
c010454a:	8b 45 08             	mov    0x8(%ebp),%eax
c010454d:	89 04 24             	mov    %eax,(%esp)
c0104550:	e8 39 ff ff ff       	call   c010448e <get_pte>
c0104555:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104558:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010455c:	75 0a                	jne    c0104568 <page_insert+0x33>
        return -E_NO_MEM;
c010455e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104563:	e9 84 00 00 00       	jmp    c01045ec <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104568:	8b 45 0c             	mov    0xc(%ebp),%eax
c010456b:	89 04 24             	mov    %eax,(%esp)
c010456e:	e8 71 f6 ff ff       	call   c0103be4 <page_ref_inc>
    if (*ptep & PTE_P) {
c0104573:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104576:	8b 00                	mov    (%eax),%eax
c0104578:	83 e0 01             	and    $0x1,%eax
c010457b:	85 c0                	test   %eax,%eax
c010457d:	74 3e                	je     c01045bd <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010457f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104582:	8b 00                	mov    (%eax),%eax
c0104584:	89 04 24             	mov    %eax,(%esp)
c0104587:	e8 f8 f5 ff ff       	call   c0103b84 <pte2page>
c010458c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010458f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104592:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104595:	75 0d                	jne    c01045a4 <page_insert+0x6f>
            page_ref_dec(page);
c0104597:	8b 45 0c             	mov    0xc(%ebp),%eax
c010459a:	89 04 24             	mov    %eax,(%esp)
c010459d:	e8 59 f6 ff ff       	call   c0103bfb <page_ref_dec>
c01045a2:	eb 19                	jmp    c01045bd <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01045a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045a7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01045ab:	8b 45 10             	mov    0x10(%ebp),%eax
c01045ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01045b5:	89 04 24             	mov    %eax,(%esp)
c01045b8:	e8 2f ff ff ff       	call   c01044ec <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01045bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045c0:	89 04 24             	mov    %eax,(%esp)
c01045c3:	e8 03 f5 ff ff       	call   c0103acb <page2pa>
c01045c8:	0b 45 14             	or     0x14(%ebp),%eax
c01045cb:	83 c8 01             	or     $0x1,%eax
c01045ce:	89 c2                	mov    %eax,%edx
c01045d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045d3:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01045d5:	8b 45 10             	mov    0x10(%ebp),%eax
c01045d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01045df:	89 04 24             	mov    %eax,(%esp)
c01045e2:	e8 07 00 00 00       	call   c01045ee <tlb_invalidate>
    return 0;
c01045e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01045ec:	c9                   	leave  
c01045ed:	c3                   	ret    

c01045ee <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01045ee:	55                   	push   %ebp
c01045ef:	89 e5                	mov    %esp,%ebp
c01045f1:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01045f4:	0f 20 d8             	mov    %cr3,%eax
c01045f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01045fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01045fd:	89 c2                	mov    %eax,%edx
c01045ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0104602:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104605:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010460c:	77 23                	ja     c0104631 <tlb_invalidate+0x43>
c010460e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104611:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104615:	c7 44 24 08 d8 69 10 	movl   $0xc01069d8,0x8(%esp)
c010461c:	c0 
c010461d:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
c0104624:	00 
c0104625:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c010462c:	e8 a1 c6 ff ff       	call   c0100cd2 <__panic>
c0104631:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104634:	05 00 00 00 40       	add    $0x40000000,%eax
c0104639:	39 c2                	cmp    %eax,%edx
c010463b:	75 0c                	jne    c0104649 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c010463d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104640:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104643:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104646:	0f 01 38             	invlpg (%eax)
    }
}
c0104649:	c9                   	leave  
c010464a:	c3                   	ret    

c010464b <check_alloc_page>:

static void
check_alloc_page(void) {
c010464b:	55                   	push   %ebp
c010464c:	89 e5                	mov    %esp,%ebp
c010464e:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104651:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0104656:	8b 40 18             	mov    0x18(%eax),%eax
c0104659:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010465b:	c7 04 24 5c 6a 10 c0 	movl   $0xc0106a5c,(%esp)
c0104662:	e8 e1 bc ff ff       	call   c0100348 <cprintf>
}
c0104667:	c9                   	leave  
c0104668:	c3                   	ret    

c0104669 <check_pgdir>:

static void
check_pgdir(void) {
c0104669:	55                   	push   %ebp
c010466a:	89 e5                	mov    %esp,%ebp
c010466c:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010466f:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104674:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104679:	76 24                	jbe    c010469f <check_pgdir+0x36>
c010467b:	c7 44 24 0c 7b 6a 10 	movl   $0xc0106a7b,0xc(%esp)
c0104682:	c0 
c0104683:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c010468a:	c0 
c010468b:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
c0104692:	00 
c0104693:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c010469a:	e8 33 c6 ff ff       	call   c0100cd2 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010469f:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01046a4:	85 c0                	test   %eax,%eax
c01046a6:	74 0e                	je     c01046b6 <check_pgdir+0x4d>
c01046a8:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01046ad:	25 ff 0f 00 00       	and    $0xfff,%eax
c01046b2:	85 c0                	test   %eax,%eax
c01046b4:	74 24                	je     c01046da <check_pgdir+0x71>
c01046b6:	c7 44 24 0c 98 6a 10 	movl   $0xc0106a98,0xc(%esp)
c01046bd:	c0 
c01046be:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c01046c5:	c0 
c01046c6:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
c01046cd:	00 
c01046ce:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c01046d5:	e8 f8 c5 ff ff       	call   c0100cd2 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01046da:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01046df:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01046e6:	00 
c01046e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01046ee:	00 
c01046ef:	89 04 24             	mov    %eax,(%esp)
c01046f2:	e8 9c fd ff ff       	call   c0104493 <get_page>
c01046f7:	85 c0                	test   %eax,%eax
c01046f9:	74 24                	je     c010471f <check_pgdir+0xb6>
c01046fb:	c7 44 24 0c d0 6a 10 	movl   $0xc0106ad0,0xc(%esp)
c0104702:	c0 
c0104703:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c010470a:	c0 
c010470b:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
c0104712:	00 
c0104713:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c010471a:	e8 b3 c5 ff ff       	call   c0100cd2 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010471f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104726:	e8 a7 f6 ff ff       	call   c0103dd2 <alloc_pages>
c010472b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010472e:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104733:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010473a:	00 
c010473b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104742:	00 
c0104743:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104746:	89 54 24 04          	mov    %edx,0x4(%esp)
c010474a:	89 04 24             	mov    %eax,(%esp)
c010474d:	e8 e3 fd ff ff       	call   c0104535 <page_insert>
c0104752:	85 c0                	test   %eax,%eax
c0104754:	74 24                	je     c010477a <check_pgdir+0x111>
c0104756:	c7 44 24 0c f8 6a 10 	movl   $0xc0106af8,0xc(%esp)
c010475d:	c0 
c010475e:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104765:	c0 
c0104766:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
c010476d:	00 
c010476e:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104775:	e8 58 c5 ff ff       	call   c0100cd2 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010477a:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010477f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104786:	00 
c0104787:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010478e:	00 
c010478f:	89 04 24             	mov    %eax,(%esp)
c0104792:	e8 f7 fc ff ff       	call   c010448e <get_pte>
c0104797:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010479a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010479e:	75 24                	jne    c01047c4 <check_pgdir+0x15b>
c01047a0:	c7 44 24 0c 24 6b 10 	movl   $0xc0106b24,0xc(%esp)
c01047a7:	c0 
c01047a8:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c01047af:	c0 
c01047b0:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
c01047b7:	00 
c01047b8:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c01047bf:	e8 0e c5 ff ff       	call   c0100cd2 <__panic>
    assert(pte2page(*ptep) == p1);
c01047c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047c7:	8b 00                	mov    (%eax),%eax
c01047c9:	89 04 24             	mov    %eax,(%esp)
c01047cc:	e8 b3 f3 ff ff       	call   c0103b84 <pte2page>
c01047d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01047d4:	74 24                	je     c01047fa <check_pgdir+0x191>
c01047d6:	c7 44 24 0c 51 6b 10 	movl   $0xc0106b51,0xc(%esp)
c01047dd:	c0 
c01047de:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c01047e5:	c0 
c01047e6:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
c01047ed:	00 
c01047ee:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c01047f5:	e8 d8 c4 ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p1) == 1);
c01047fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047fd:	89 04 24             	mov    %eax,(%esp)
c0104800:	e8 d5 f3 ff ff       	call   c0103bda <page_ref>
c0104805:	83 f8 01             	cmp    $0x1,%eax
c0104808:	74 24                	je     c010482e <check_pgdir+0x1c5>
c010480a:	c7 44 24 0c 67 6b 10 	movl   $0xc0106b67,0xc(%esp)
c0104811:	c0 
c0104812:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104819:	c0 
c010481a:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
c0104821:	00 
c0104822:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104829:	e8 a4 c4 ff ff       	call   c0100cd2 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010482e:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104833:	8b 00                	mov    (%eax),%eax
c0104835:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010483a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010483d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104840:	c1 e8 0c             	shr    $0xc,%eax
c0104843:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104846:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c010484b:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010484e:	72 23                	jb     c0104873 <check_pgdir+0x20a>
c0104850:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104853:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104857:	c7 44 24 08 34 69 10 	movl   $0xc0106934,0x8(%esp)
c010485e:	c0 
c010485f:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
c0104866:	00 
c0104867:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c010486e:	e8 5f c4 ff ff       	call   c0100cd2 <__panic>
c0104873:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104876:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010487b:	83 c0 04             	add    $0x4,%eax
c010487e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104881:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104886:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010488d:	00 
c010488e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104895:	00 
c0104896:	89 04 24             	mov    %eax,(%esp)
c0104899:	e8 f0 fb ff ff       	call   c010448e <get_pte>
c010489e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01048a1:	74 24                	je     c01048c7 <check_pgdir+0x25e>
c01048a3:	c7 44 24 0c 7c 6b 10 	movl   $0xc0106b7c,0xc(%esp)
c01048aa:	c0 
c01048ab:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c01048b2:	c0 
c01048b3:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
c01048ba:	00 
c01048bb:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c01048c2:	e8 0b c4 ff ff       	call   c0100cd2 <__panic>

    p2 = alloc_page();
c01048c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01048ce:	e8 ff f4 ff ff       	call   c0103dd2 <alloc_pages>
c01048d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01048d6:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01048db:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c01048e2:	00 
c01048e3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01048ea:	00 
c01048eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01048ee:	89 54 24 04          	mov    %edx,0x4(%esp)
c01048f2:	89 04 24             	mov    %eax,(%esp)
c01048f5:	e8 3b fc ff ff       	call   c0104535 <page_insert>
c01048fa:	85 c0                	test   %eax,%eax
c01048fc:	74 24                	je     c0104922 <check_pgdir+0x2b9>
c01048fe:	c7 44 24 0c a4 6b 10 	movl   $0xc0106ba4,0xc(%esp)
c0104905:	c0 
c0104906:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c010490d:	c0 
c010490e:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
c0104915:	00 
c0104916:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c010491d:	e8 b0 c3 ff ff       	call   c0100cd2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104922:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104927:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010492e:	00 
c010492f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104936:	00 
c0104937:	89 04 24             	mov    %eax,(%esp)
c010493a:	e8 4f fb ff ff       	call   c010448e <get_pte>
c010493f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104942:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104946:	75 24                	jne    c010496c <check_pgdir+0x303>
c0104948:	c7 44 24 0c dc 6b 10 	movl   $0xc0106bdc,0xc(%esp)
c010494f:	c0 
c0104950:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104957:	c0 
c0104958:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
c010495f:	00 
c0104960:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104967:	e8 66 c3 ff ff       	call   c0100cd2 <__panic>
    assert(*ptep & PTE_U);
c010496c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010496f:	8b 00                	mov    (%eax),%eax
c0104971:	83 e0 04             	and    $0x4,%eax
c0104974:	85 c0                	test   %eax,%eax
c0104976:	75 24                	jne    c010499c <check_pgdir+0x333>
c0104978:	c7 44 24 0c 0c 6c 10 	movl   $0xc0106c0c,0xc(%esp)
c010497f:	c0 
c0104980:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104987:	c0 
c0104988:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
c010498f:	00 
c0104990:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104997:	e8 36 c3 ff ff       	call   c0100cd2 <__panic>
    assert(*ptep & PTE_W);
c010499c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010499f:	8b 00                	mov    (%eax),%eax
c01049a1:	83 e0 02             	and    $0x2,%eax
c01049a4:	85 c0                	test   %eax,%eax
c01049a6:	75 24                	jne    c01049cc <check_pgdir+0x363>
c01049a8:	c7 44 24 0c 1a 6c 10 	movl   $0xc0106c1a,0xc(%esp)
c01049af:	c0 
c01049b0:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c01049b7:	c0 
c01049b8:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c01049bf:	00 
c01049c0:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c01049c7:	e8 06 c3 ff ff       	call   c0100cd2 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c01049cc:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01049d1:	8b 00                	mov    (%eax),%eax
c01049d3:	83 e0 04             	and    $0x4,%eax
c01049d6:	85 c0                	test   %eax,%eax
c01049d8:	75 24                	jne    c01049fe <check_pgdir+0x395>
c01049da:	c7 44 24 0c 28 6c 10 	movl   $0xc0106c28,0xc(%esp)
c01049e1:	c0 
c01049e2:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c01049e9:	c0 
c01049ea:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c01049f1:	00 
c01049f2:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c01049f9:	e8 d4 c2 ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p2) == 1);
c01049fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a01:	89 04 24             	mov    %eax,(%esp)
c0104a04:	e8 d1 f1 ff ff       	call   c0103bda <page_ref>
c0104a09:	83 f8 01             	cmp    $0x1,%eax
c0104a0c:	74 24                	je     c0104a32 <check_pgdir+0x3c9>
c0104a0e:	c7 44 24 0c 3e 6c 10 	movl   $0xc0106c3e,0xc(%esp)
c0104a15:	c0 
c0104a16:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104a1d:	c0 
c0104a1e:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c0104a25:	00 
c0104a26:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104a2d:	e8 a0 c2 ff ff       	call   c0100cd2 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104a32:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104a37:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104a3e:	00 
c0104a3f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104a46:	00 
c0104a47:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104a4a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a4e:	89 04 24             	mov    %eax,(%esp)
c0104a51:	e8 df fa ff ff       	call   c0104535 <page_insert>
c0104a56:	85 c0                	test   %eax,%eax
c0104a58:	74 24                	je     c0104a7e <check_pgdir+0x415>
c0104a5a:	c7 44 24 0c 50 6c 10 	movl   $0xc0106c50,0xc(%esp)
c0104a61:	c0 
c0104a62:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104a69:	c0 
c0104a6a:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c0104a71:	00 
c0104a72:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104a79:	e8 54 c2 ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p1) == 2);
c0104a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a81:	89 04 24             	mov    %eax,(%esp)
c0104a84:	e8 51 f1 ff ff       	call   c0103bda <page_ref>
c0104a89:	83 f8 02             	cmp    $0x2,%eax
c0104a8c:	74 24                	je     c0104ab2 <check_pgdir+0x449>
c0104a8e:	c7 44 24 0c 7c 6c 10 	movl   $0xc0106c7c,0xc(%esp)
c0104a95:	c0 
c0104a96:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104a9d:	c0 
c0104a9e:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c0104aa5:	00 
c0104aa6:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104aad:	e8 20 c2 ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p2) == 0);
c0104ab2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ab5:	89 04 24             	mov    %eax,(%esp)
c0104ab8:	e8 1d f1 ff ff       	call   c0103bda <page_ref>
c0104abd:	85 c0                	test   %eax,%eax
c0104abf:	74 24                	je     c0104ae5 <check_pgdir+0x47c>
c0104ac1:	c7 44 24 0c 8e 6c 10 	movl   $0xc0106c8e,0xc(%esp)
c0104ac8:	c0 
c0104ac9:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104ad0:	c0 
c0104ad1:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0104ad8:	00 
c0104ad9:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104ae0:	e8 ed c1 ff ff       	call   c0100cd2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104ae5:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104aea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104af1:	00 
c0104af2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104af9:	00 
c0104afa:	89 04 24             	mov    %eax,(%esp)
c0104afd:	e8 8c f9 ff ff       	call   c010448e <get_pte>
c0104b02:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b09:	75 24                	jne    c0104b2f <check_pgdir+0x4c6>
c0104b0b:	c7 44 24 0c dc 6b 10 	movl   $0xc0106bdc,0xc(%esp)
c0104b12:	c0 
c0104b13:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104b1a:	c0 
c0104b1b:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c0104b22:	00 
c0104b23:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104b2a:	e8 a3 c1 ff ff       	call   c0100cd2 <__panic>
    assert(pte2page(*ptep) == p1);
c0104b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b32:	8b 00                	mov    (%eax),%eax
c0104b34:	89 04 24             	mov    %eax,(%esp)
c0104b37:	e8 48 f0 ff ff       	call   c0103b84 <pte2page>
c0104b3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104b3f:	74 24                	je     c0104b65 <check_pgdir+0x4fc>
c0104b41:	c7 44 24 0c 51 6b 10 	movl   $0xc0106b51,0xc(%esp)
c0104b48:	c0 
c0104b49:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104b50:	c0 
c0104b51:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0104b58:	00 
c0104b59:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104b60:	e8 6d c1 ff ff       	call   c0100cd2 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b68:	8b 00                	mov    (%eax),%eax
c0104b6a:	83 e0 04             	and    $0x4,%eax
c0104b6d:	85 c0                	test   %eax,%eax
c0104b6f:	74 24                	je     c0104b95 <check_pgdir+0x52c>
c0104b71:	c7 44 24 0c a0 6c 10 	movl   $0xc0106ca0,0xc(%esp)
c0104b78:	c0 
c0104b79:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104b80:	c0 
c0104b81:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0104b88:	00 
c0104b89:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104b90:	e8 3d c1 ff ff       	call   c0100cd2 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104b95:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104b9a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ba1:	00 
c0104ba2:	89 04 24             	mov    %eax,(%esp)
c0104ba5:	e8 47 f9 ff ff       	call   c01044f1 <page_remove>
    assert(page_ref(p1) == 1);
c0104baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bad:	89 04 24             	mov    %eax,(%esp)
c0104bb0:	e8 25 f0 ff ff       	call   c0103bda <page_ref>
c0104bb5:	83 f8 01             	cmp    $0x1,%eax
c0104bb8:	74 24                	je     c0104bde <check_pgdir+0x575>
c0104bba:	c7 44 24 0c 67 6b 10 	movl   $0xc0106b67,0xc(%esp)
c0104bc1:	c0 
c0104bc2:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104bc9:	c0 
c0104bca:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0104bd1:	00 
c0104bd2:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104bd9:	e8 f4 c0 ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p2) == 0);
c0104bde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104be1:	89 04 24             	mov    %eax,(%esp)
c0104be4:	e8 f1 ef ff ff       	call   c0103bda <page_ref>
c0104be9:	85 c0                	test   %eax,%eax
c0104beb:	74 24                	je     c0104c11 <check_pgdir+0x5a8>
c0104bed:	c7 44 24 0c 8e 6c 10 	movl   $0xc0106c8e,0xc(%esp)
c0104bf4:	c0 
c0104bf5:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104bfc:	c0 
c0104bfd:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0104c04:	00 
c0104c05:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104c0c:	e8 c1 c0 ff ff       	call   c0100cd2 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104c11:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104c16:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c1d:	00 
c0104c1e:	89 04 24             	mov    %eax,(%esp)
c0104c21:	e8 cb f8 ff ff       	call   c01044f1 <page_remove>
    assert(page_ref(p1) == 0);
c0104c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c29:	89 04 24             	mov    %eax,(%esp)
c0104c2c:	e8 a9 ef ff ff       	call   c0103bda <page_ref>
c0104c31:	85 c0                	test   %eax,%eax
c0104c33:	74 24                	je     c0104c59 <check_pgdir+0x5f0>
c0104c35:	c7 44 24 0c b5 6c 10 	movl   $0xc0106cb5,0xc(%esp)
c0104c3c:	c0 
c0104c3d:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104c44:	c0 
c0104c45:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0104c4c:	00 
c0104c4d:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104c54:	e8 79 c0 ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p2) == 0);
c0104c59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c5c:	89 04 24             	mov    %eax,(%esp)
c0104c5f:	e8 76 ef ff ff       	call   c0103bda <page_ref>
c0104c64:	85 c0                	test   %eax,%eax
c0104c66:	74 24                	je     c0104c8c <check_pgdir+0x623>
c0104c68:	c7 44 24 0c 8e 6c 10 	movl   $0xc0106c8e,0xc(%esp)
c0104c6f:	c0 
c0104c70:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104c77:	c0 
c0104c78:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0104c7f:	00 
c0104c80:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104c87:	e8 46 c0 ff ff       	call   c0100cd2 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104c8c:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104c91:	8b 00                	mov    (%eax),%eax
c0104c93:	89 04 24             	mov    %eax,(%esp)
c0104c96:	e8 27 ef ff ff       	call   c0103bc2 <pde2page>
c0104c9b:	89 04 24             	mov    %eax,(%esp)
c0104c9e:	e8 37 ef ff ff       	call   c0103bda <page_ref>
c0104ca3:	83 f8 01             	cmp    $0x1,%eax
c0104ca6:	74 24                	je     c0104ccc <check_pgdir+0x663>
c0104ca8:	c7 44 24 0c c8 6c 10 	movl   $0xc0106cc8,0xc(%esp)
c0104caf:	c0 
c0104cb0:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104cb7:	c0 
c0104cb8:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0104cbf:	00 
c0104cc0:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104cc7:	e8 06 c0 ff ff       	call   c0100cd2 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104ccc:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104cd1:	8b 00                	mov    (%eax),%eax
c0104cd3:	89 04 24             	mov    %eax,(%esp)
c0104cd6:	e8 e7 ee ff ff       	call   c0103bc2 <pde2page>
c0104cdb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104ce2:	00 
c0104ce3:	89 04 24             	mov    %eax,(%esp)
c0104ce6:	e8 1f f1 ff ff       	call   c0103e0a <free_pages>
    boot_pgdir[0] = 0;
c0104ceb:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104cf0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104cf6:	c7 04 24 ef 6c 10 c0 	movl   $0xc0106cef,(%esp)
c0104cfd:	e8 46 b6 ff ff       	call   c0100348 <cprintf>
}
c0104d02:	c9                   	leave  
c0104d03:	c3                   	ret    

c0104d04 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104d04:	55                   	push   %ebp
c0104d05:	89 e5                	mov    %esp,%ebp
c0104d07:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104d0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104d11:	e9 ca 00 00 00       	jmp    c0104de0 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d19:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d1f:	c1 e8 0c             	shr    $0xc,%eax
c0104d22:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104d25:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104d2a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104d2d:	72 23                	jb     c0104d52 <check_boot_pgdir+0x4e>
c0104d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d32:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d36:	c7 44 24 08 34 69 10 	movl   $0xc0106934,0x8(%esp)
c0104d3d:	c0 
c0104d3e:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104d45:	00 
c0104d46:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104d4d:	e8 80 bf ff ff       	call   c0100cd2 <__panic>
c0104d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d55:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104d5a:	89 c2                	mov    %eax,%edx
c0104d5c:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104d61:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104d68:	00 
c0104d69:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d6d:	89 04 24             	mov    %eax,(%esp)
c0104d70:	e8 19 f7 ff ff       	call   c010448e <get_pte>
c0104d75:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104d78:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104d7c:	75 24                	jne    c0104da2 <check_boot_pgdir+0x9e>
c0104d7e:	c7 44 24 0c 0c 6d 10 	movl   $0xc0106d0c,0xc(%esp)
c0104d85:	c0 
c0104d86:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104d8d:	c0 
c0104d8e:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104d95:	00 
c0104d96:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104d9d:	e8 30 bf ff ff       	call   c0100cd2 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104da2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104da5:	8b 00                	mov    (%eax),%eax
c0104da7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104dac:	89 c2                	mov    %eax,%edx
c0104dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104db1:	39 c2                	cmp    %eax,%edx
c0104db3:	74 24                	je     c0104dd9 <check_boot_pgdir+0xd5>
c0104db5:	c7 44 24 0c 49 6d 10 	movl   $0xc0106d49,0xc(%esp)
c0104dbc:	c0 
c0104dbd:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104dc4:	c0 
c0104dc5:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104dcc:	00 
c0104dcd:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104dd4:	e8 f9 be ff ff       	call   c0100cd2 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104dd9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104de0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104de3:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104de8:	39 c2                	cmp    %eax,%edx
c0104dea:	0f 82 26 ff ff ff    	jb     c0104d16 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104df0:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104df5:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104dfa:	8b 00                	mov    (%eax),%eax
c0104dfc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e01:	89 c2                	mov    %eax,%edx
c0104e03:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104e08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104e0b:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104e12:	77 23                	ja     c0104e37 <check_boot_pgdir+0x133>
c0104e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e17:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e1b:	c7 44 24 08 d8 69 10 	movl   $0xc01069d8,0x8(%esp)
c0104e22:	c0 
c0104e23:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104e2a:	00 
c0104e2b:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104e32:	e8 9b be ff ff       	call   c0100cd2 <__panic>
c0104e37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e3a:	05 00 00 00 40       	add    $0x40000000,%eax
c0104e3f:	39 c2                	cmp    %eax,%edx
c0104e41:	74 24                	je     c0104e67 <check_boot_pgdir+0x163>
c0104e43:	c7 44 24 0c 60 6d 10 	movl   $0xc0106d60,0xc(%esp)
c0104e4a:	c0 
c0104e4b:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104e52:	c0 
c0104e53:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104e5a:	00 
c0104e5b:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104e62:	e8 6b be ff ff       	call   c0100cd2 <__panic>

    assert(boot_pgdir[0] == 0);
c0104e67:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104e6c:	8b 00                	mov    (%eax),%eax
c0104e6e:	85 c0                	test   %eax,%eax
c0104e70:	74 24                	je     c0104e96 <check_boot_pgdir+0x192>
c0104e72:	c7 44 24 0c 94 6d 10 	movl   $0xc0106d94,0xc(%esp)
c0104e79:	c0 
c0104e7a:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104e81:	c0 
c0104e82:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104e89:	00 
c0104e8a:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104e91:	e8 3c be ff ff       	call   c0100cd2 <__panic>

    struct Page *p;
    p = alloc_page();
c0104e96:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e9d:	e8 30 ef ff ff       	call   c0103dd2 <alloc_pages>
c0104ea2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104ea5:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104eaa:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104eb1:	00 
c0104eb2:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104eb9:	00 
c0104eba:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104ebd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ec1:	89 04 24             	mov    %eax,(%esp)
c0104ec4:	e8 6c f6 ff ff       	call   c0104535 <page_insert>
c0104ec9:	85 c0                	test   %eax,%eax
c0104ecb:	74 24                	je     c0104ef1 <check_boot_pgdir+0x1ed>
c0104ecd:	c7 44 24 0c a8 6d 10 	movl   $0xc0106da8,0xc(%esp)
c0104ed4:	c0 
c0104ed5:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104edc:	c0 
c0104edd:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104ee4:	00 
c0104ee5:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104eec:	e8 e1 bd ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p) == 1);
c0104ef1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ef4:	89 04 24             	mov    %eax,(%esp)
c0104ef7:	e8 de ec ff ff       	call   c0103bda <page_ref>
c0104efc:	83 f8 01             	cmp    $0x1,%eax
c0104eff:	74 24                	je     c0104f25 <check_boot_pgdir+0x221>
c0104f01:	c7 44 24 0c d6 6d 10 	movl   $0xc0106dd6,0xc(%esp)
c0104f08:	c0 
c0104f09:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104f10:	c0 
c0104f11:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104f18:	00 
c0104f19:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104f20:	e8 ad bd ff ff       	call   c0100cd2 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104f25:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104f2a:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104f31:	00 
c0104f32:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104f39:	00 
c0104f3a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104f3d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f41:	89 04 24             	mov    %eax,(%esp)
c0104f44:	e8 ec f5 ff ff       	call   c0104535 <page_insert>
c0104f49:	85 c0                	test   %eax,%eax
c0104f4b:	74 24                	je     c0104f71 <check_boot_pgdir+0x26d>
c0104f4d:	c7 44 24 0c e8 6d 10 	movl   $0xc0106de8,0xc(%esp)
c0104f54:	c0 
c0104f55:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104f5c:	c0 
c0104f5d:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104f64:	00 
c0104f65:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104f6c:	e8 61 bd ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p) == 2);
c0104f71:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f74:	89 04 24             	mov    %eax,(%esp)
c0104f77:	e8 5e ec ff ff       	call   c0103bda <page_ref>
c0104f7c:	83 f8 02             	cmp    $0x2,%eax
c0104f7f:	74 24                	je     c0104fa5 <check_boot_pgdir+0x2a1>
c0104f81:	c7 44 24 0c 1f 6e 10 	movl   $0xc0106e1f,0xc(%esp)
c0104f88:	c0 
c0104f89:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104f90:	c0 
c0104f91:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104f98:	00 
c0104f99:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104fa0:	e8 2d bd ff ff       	call   c0100cd2 <__panic>

    const char *str = "ucore: Hello world!!";
c0104fa5:	c7 45 dc 30 6e 10 c0 	movl   $0xc0106e30,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0104fac:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104faf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104fb3:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104fba:	e8 19 0a 00 00       	call   c01059d8 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104fbf:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0104fc6:	00 
c0104fc7:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104fce:	e8 7e 0a 00 00       	call   c0105a51 <strcmp>
c0104fd3:	85 c0                	test   %eax,%eax
c0104fd5:	74 24                	je     c0104ffb <check_boot_pgdir+0x2f7>
c0104fd7:	c7 44 24 0c 48 6e 10 	movl   $0xc0106e48,0xc(%esp)
c0104fde:	c0 
c0104fdf:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c0104fe6:	c0 
c0104fe7:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104fee:	00 
c0104fef:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0104ff6:	e8 d7 bc ff ff       	call   c0100cd2 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104ffb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ffe:	89 04 24             	mov    %eax,(%esp)
c0105001:	e8 2a eb ff ff       	call   c0103b30 <page2kva>
c0105006:	05 00 01 00 00       	add    $0x100,%eax
c010500b:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c010500e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105015:	e8 66 09 00 00       	call   c0105980 <strlen>
c010501a:	85 c0                	test   %eax,%eax
c010501c:	74 24                	je     c0105042 <check_boot_pgdir+0x33e>
c010501e:	c7 44 24 0c 80 6e 10 	movl   $0xc0106e80,0xc(%esp)
c0105025:	c0 
c0105026:	c7 44 24 08 21 6a 10 	movl   $0xc0106a21,0x8(%esp)
c010502d:	c0 
c010502e:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0105035:	00 
c0105036:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c010503d:	e8 90 bc ff ff       	call   c0100cd2 <__panic>

    free_page(p);
c0105042:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105049:	00 
c010504a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010504d:	89 04 24             	mov    %eax,(%esp)
c0105050:	e8 b5 ed ff ff       	call   c0103e0a <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105055:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010505a:	8b 00                	mov    (%eax),%eax
c010505c:	89 04 24             	mov    %eax,(%esp)
c010505f:	e8 5e eb ff ff       	call   c0103bc2 <pde2page>
c0105064:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010506b:	00 
c010506c:	89 04 24             	mov    %eax,(%esp)
c010506f:	e8 96 ed ff ff       	call   c0103e0a <free_pages>
    boot_pgdir[0] = 0;
c0105074:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0105079:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010507f:	c7 04 24 a4 6e 10 c0 	movl   $0xc0106ea4,(%esp)
c0105086:	e8 bd b2 ff ff       	call   c0100348 <cprintf>
}
c010508b:	c9                   	leave  
c010508c:	c3                   	ret    

c010508d <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c010508d:	55                   	push   %ebp
c010508e:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105090:	8b 45 08             	mov    0x8(%ebp),%eax
c0105093:	83 e0 04             	and    $0x4,%eax
c0105096:	85 c0                	test   %eax,%eax
c0105098:	74 07                	je     c01050a1 <perm2str+0x14>
c010509a:	b8 75 00 00 00       	mov    $0x75,%eax
c010509f:	eb 05                	jmp    c01050a6 <perm2str+0x19>
c01050a1:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01050a6:	a2 08 af 11 c0       	mov    %al,0xc011af08
    str[1] = 'r';
c01050ab:	c6 05 09 af 11 c0 72 	movb   $0x72,0xc011af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01050b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01050b5:	83 e0 02             	and    $0x2,%eax
c01050b8:	85 c0                	test   %eax,%eax
c01050ba:	74 07                	je     c01050c3 <perm2str+0x36>
c01050bc:	b8 77 00 00 00       	mov    $0x77,%eax
c01050c1:	eb 05                	jmp    c01050c8 <perm2str+0x3b>
c01050c3:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01050c8:	a2 0a af 11 c0       	mov    %al,0xc011af0a
    str[3] = '\0';
c01050cd:	c6 05 0b af 11 c0 00 	movb   $0x0,0xc011af0b
    return str;
c01050d4:	b8 08 af 11 c0       	mov    $0xc011af08,%eax
}
c01050d9:	5d                   	pop    %ebp
c01050da:	c3                   	ret    

c01050db <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01050db:	55                   	push   %ebp
c01050dc:	89 e5                	mov    %esp,%ebp
c01050de:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01050e1:	8b 45 10             	mov    0x10(%ebp),%eax
c01050e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01050e7:	72 0a                	jb     c01050f3 <get_pgtable_items+0x18>
        return 0;
c01050e9:	b8 00 00 00 00       	mov    $0x0,%eax
c01050ee:	e9 9c 00 00 00       	jmp    c010518f <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c01050f3:	eb 04                	jmp    c01050f9 <get_pgtable_items+0x1e>
        start ++;
c01050f5:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01050f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01050fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01050ff:	73 18                	jae    c0105119 <get_pgtable_items+0x3e>
c0105101:	8b 45 10             	mov    0x10(%ebp),%eax
c0105104:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010510b:	8b 45 14             	mov    0x14(%ebp),%eax
c010510e:	01 d0                	add    %edx,%eax
c0105110:	8b 00                	mov    (%eax),%eax
c0105112:	83 e0 01             	and    $0x1,%eax
c0105115:	85 c0                	test   %eax,%eax
c0105117:	74 dc                	je     c01050f5 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105119:	8b 45 10             	mov    0x10(%ebp),%eax
c010511c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010511f:	73 69                	jae    c010518a <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105121:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105125:	74 08                	je     c010512f <get_pgtable_items+0x54>
            *left_store = start;
c0105127:	8b 45 18             	mov    0x18(%ebp),%eax
c010512a:	8b 55 10             	mov    0x10(%ebp),%edx
c010512d:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010512f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105132:	8d 50 01             	lea    0x1(%eax),%edx
c0105135:	89 55 10             	mov    %edx,0x10(%ebp)
c0105138:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010513f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105142:	01 d0                	add    %edx,%eax
c0105144:	8b 00                	mov    (%eax),%eax
c0105146:	83 e0 07             	and    $0x7,%eax
c0105149:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010514c:	eb 04                	jmp    c0105152 <get_pgtable_items+0x77>
            start ++;
c010514e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105152:	8b 45 10             	mov    0x10(%ebp),%eax
c0105155:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105158:	73 1d                	jae    c0105177 <get_pgtable_items+0x9c>
c010515a:	8b 45 10             	mov    0x10(%ebp),%eax
c010515d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105164:	8b 45 14             	mov    0x14(%ebp),%eax
c0105167:	01 d0                	add    %edx,%eax
c0105169:	8b 00                	mov    (%eax),%eax
c010516b:	83 e0 07             	and    $0x7,%eax
c010516e:	89 c2                	mov    %eax,%edx
c0105170:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105173:	39 c2                	cmp    %eax,%edx
c0105175:	74 d7                	je     c010514e <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105177:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010517b:	74 08                	je     c0105185 <get_pgtable_items+0xaa>
            *right_store = start;
c010517d:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105180:	8b 55 10             	mov    0x10(%ebp),%edx
c0105183:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105185:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105188:	eb 05                	jmp    c010518f <get_pgtable_items+0xb4>
    }
    return 0;
c010518a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010518f:	c9                   	leave  
c0105190:	c3                   	ret    

c0105191 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105191:	55                   	push   %ebp
c0105192:	89 e5                	mov    %esp,%ebp
c0105194:	57                   	push   %edi
c0105195:	56                   	push   %esi
c0105196:	53                   	push   %ebx
c0105197:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010519a:	c7 04 24 c4 6e 10 c0 	movl   $0xc0106ec4,(%esp)
c01051a1:	e8 a2 b1 ff ff       	call   c0100348 <cprintf>
    size_t left, right = 0, perm;
c01051a6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01051ad:	e9 fa 00 00 00       	jmp    c01052ac <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01051b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01051b5:	89 04 24             	mov    %eax,(%esp)
c01051b8:	e8 d0 fe ff ff       	call   c010508d <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01051bd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01051c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01051c3:	29 d1                	sub    %edx,%ecx
c01051c5:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01051c7:	89 d6                	mov    %edx,%esi
c01051c9:	c1 e6 16             	shl    $0x16,%esi
c01051cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01051cf:	89 d3                	mov    %edx,%ebx
c01051d1:	c1 e3 16             	shl    $0x16,%ebx
c01051d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01051d7:	89 d1                	mov    %edx,%ecx
c01051d9:	c1 e1 16             	shl    $0x16,%ecx
c01051dc:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01051df:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01051e2:	29 d7                	sub    %edx,%edi
c01051e4:	89 fa                	mov    %edi,%edx
c01051e6:	89 44 24 14          	mov    %eax,0x14(%esp)
c01051ea:	89 74 24 10          	mov    %esi,0x10(%esp)
c01051ee:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01051f2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01051f6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01051fa:	c7 04 24 f5 6e 10 c0 	movl   $0xc0106ef5,(%esp)
c0105201:	e8 42 b1 ff ff       	call   c0100348 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105206:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105209:	c1 e0 0a             	shl    $0xa,%eax
c010520c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010520f:	eb 54                	jmp    c0105265 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105211:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105214:	89 04 24             	mov    %eax,(%esp)
c0105217:	e8 71 fe ff ff       	call   c010508d <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c010521c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010521f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105222:	29 d1                	sub    %edx,%ecx
c0105224:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105226:	89 d6                	mov    %edx,%esi
c0105228:	c1 e6 0c             	shl    $0xc,%esi
c010522b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010522e:	89 d3                	mov    %edx,%ebx
c0105230:	c1 e3 0c             	shl    $0xc,%ebx
c0105233:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105236:	c1 e2 0c             	shl    $0xc,%edx
c0105239:	89 d1                	mov    %edx,%ecx
c010523b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c010523e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105241:	29 d7                	sub    %edx,%edi
c0105243:	89 fa                	mov    %edi,%edx
c0105245:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105249:	89 74 24 10          	mov    %esi,0x10(%esp)
c010524d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105251:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105255:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105259:	c7 04 24 14 6f 10 c0 	movl   $0xc0106f14,(%esp)
c0105260:	e8 e3 b0 ff ff       	call   c0100348 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105265:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c010526a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010526d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105270:	89 ce                	mov    %ecx,%esi
c0105272:	c1 e6 0a             	shl    $0xa,%esi
c0105275:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105278:	89 cb                	mov    %ecx,%ebx
c010527a:	c1 e3 0a             	shl    $0xa,%ebx
c010527d:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105280:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105284:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105287:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010528b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010528f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105293:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105297:	89 1c 24             	mov    %ebx,(%esp)
c010529a:	e8 3c fe ff ff       	call   c01050db <get_pgtable_items>
c010529f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01052a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01052a6:	0f 85 65 ff ff ff    	jne    c0105211 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01052ac:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c01052b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01052b4:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01052b7:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01052bb:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c01052be:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01052c2:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01052c6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01052ca:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01052d1:	00 
c01052d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01052d9:	e8 fd fd ff ff       	call   c01050db <get_pgtable_items>
c01052de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01052e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01052e5:	0f 85 c7 fe ff ff    	jne    c01051b2 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01052eb:	c7 04 24 38 6f 10 c0 	movl   $0xc0106f38,(%esp)
c01052f2:	e8 51 b0 ff ff       	call   c0100348 <cprintf>
}
c01052f7:	83 c4 4c             	add    $0x4c,%esp
c01052fa:	5b                   	pop    %ebx
c01052fb:	5e                   	pop    %esi
c01052fc:	5f                   	pop    %edi
c01052fd:	5d                   	pop    %ebp
c01052fe:	c3                   	ret    

c01052ff <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01052ff:	55                   	push   %ebp
c0105300:	89 e5                	mov    %esp,%ebp
c0105302:	83 ec 58             	sub    $0x58,%esp
c0105305:	8b 45 10             	mov    0x10(%ebp),%eax
c0105308:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010530b:	8b 45 14             	mov    0x14(%ebp),%eax
c010530e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105311:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105314:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105317:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010531a:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010531d:	8b 45 18             	mov    0x18(%ebp),%eax
c0105320:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105323:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105326:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105329:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010532c:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010532f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105332:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105335:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105339:	74 1c                	je     c0105357 <printnum+0x58>
c010533b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010533e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105343:	f7 75 e4             	divl   -0x1c(%ebp)
c0105346:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105349:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010534c:	ba 00 00 00 00       	mov    $0x0,%edx
c0105351:	f7 75 e4             	divl   -0x1c(%ebp)
c0105354:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105357:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010535a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010535d:	f7 75 e4             	divl   -0x1c(%ebp)
c0105360:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105363:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105366:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105369:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010536c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010536f:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105372:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105375:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105378:	8b 45 18             	mov    0x18(%ebp),%eax
c010537b:	ba 00 00 00 00       	mov    $0x0,%edx
c0105380:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105383:	77 56                	ja     c01053db <printnum+0xdc>
c0105385:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105388:	72 05                	jb     c010538f <printnum+0x90>
c010538a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010538d:	77 4c                	ja     c01053db <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010538f:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105392:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105395:	8b 45 20             	mov    0x20(%ebp),%eax
c0105398:	89 44 24 18          	mov    %eax,0x18(%esp)
c010539c:	89 54 24 14          	mov    %edx,0x14(%esp)
c01053a0:	8b 45 18             	mov    0x18(%ebp),%eax
c01053a3:	89 44 24 10          	mov    %eax,0x10(%esp)
c01053a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01053ad:	89 44 24 08          	mov    %eax,0x8(%esp)
c01053b1:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01053b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053b8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01053bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01053bf:	89 04 24             	mov    %eax,(%esp)
c01053c2:	e8 38 ff ff ff       	call   c01052ff <printnum>
c01053c7:	eb 1c                	jmp    c01053e5 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01053c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01053d0:	8b 45 20             	mov    0x20(%ebp),%eax
c01053d3:	89 04 24             	mov    %eax,(%esp)
c01053d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01053d9:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01053db:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01053df:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01053e3:	7f e4                	jg     c01053c9 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01053e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01053e8:	05 ec 6f 10 c0       	add    $0xc0106fec,%eax
c01053ed:	0f b6 00             	movzbl (%eax),%eax
c01053f0:	0f be c0             	movsbl %al,%eax
c01053f3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01053f6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053fa:	89 04 24             	mov    %eax,(%esp)
c01053fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105400:	ff d0                	call   *%eax
}
c0105402:	c9                   	leave  
c0105403:	c3                   	ret    

c0105404 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105404:	55                   	push   %ebp
c0105405:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105407:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010540b:	7e 14                	jle    c0105421 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010540d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105410:	8b 00                	mov    (%eax),%eax
c0105412:	8d 48 08             	lea    0x8(%eax),%ecx
c0105415:	8b 55 08             	mov    0x8(%ebp),%edx
c0105418:	89 0a                	mov    %ecx,(%edx)
c010541a:	8b 50 04             	mov    0x4(%eax),%edx
c010541d:	8b 00                	mov    (%eax),%eax
c010541f:	eb 30                	jmp    c0105451 <getuint+0x4d>
    }
    else if (lflag) {
c0105421:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105425:	74 16                	je     c010543d <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105427:	8b 45 08             	mov    0x8(%ebp),%eax
c010542a:	8b 00                	mov    (%eax),%eax
c010542c:	8d 48 04             	lea    0x4(%eax),%ecx
c010542f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105432:	89 0a                	mov    %ecx,(%edx)
c0105434:	8b 00                	mov    (%eax),%eax
c0105436:	ba 00 00 00 00       	mov    $0x0,%edx
c010543b:	eb 14                	jmp    c0105451 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010543d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105440:	8b 00                	mov    (%eax),%eax
c0105442:	8d 48 04             	lea    0x4(%eax),%ecx
c0105445:	8b 55 08             	mov    0x8(%ebp),%edx
c0105448:	89 0a                	mov    %ecx,(%edx)
c010544a:	8b 00                	mov    (%eax),%eax
c010544c:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105451:	5d                   	pop    %ebp
c0105452:	c3                   	ret    

c0105453 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105453:	55                   	push   %ebp
c0105454:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105456:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010545a:	7e 14                	jle    c0105470 <getint+0x1d>
        return va_arg(*ap, long long);
c010545c:	8b 45 08             	mov    0x8(%ebp),%eax
c010545f:	8b 00                	mov    (%eax),%eax
c0105461:	8d 48 08             	lea    0x8(%eax),%ecx
c0105464:	8b 55 08             	mov    0x8(%ebp),%edx
c0105467:	89 0a                	mov    %ecx,(%edx)
c0105469:	8b 50 04             	mov    0x4(%eax),%edx
c010546c:	8b 00                	mov    (%eax),%eax
c010546e:	eb 28                	jmp    c0105498 <getint+0x45>
    }
    else if (lflag) {
c0105470:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105474:	74 12                	je     c0105488 <getint+0x35>
        return va_arg(*ap, long);
c0105476:	8b 45 08             	mov    0x8(%ebp),%eax
c0105479:	8b 00                	mov    (%eax),%eax
c010547b:	8d 48 04             	lea    0x4(%eax),%ecx
c010547e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105481:	89 0a                	mov    %ecx,(%edx)
c0105483:	8b 00                	mov    (%eax),%eax
c0105485:	99                   	cltd   
c0105486:	eb 10                	jmp    c0105498 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105488:	8b 45 08             	mov    0x8(%ebp),%eax
c010548b:	8b 00                	mov    (%eax),%eax
c010548d:	8d 48 04             	lea    0x4(%eax),%ecx
c0105490:	8b 55 08             	mov    0x8(%ebp),%edx
c0105493:	89 0a                	mov    %ecx,(%edx)
c0105495:	8b 00                	mov    (%eax),%eax
c0105497:	99                   	cltd   
    }
}
c0105498:	5d                   	pop    %ebp
c0105499:	c3                   	ret    

c010549a <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010549a:	55                   	push   %ebp
c010549b:	89 e5                	mov    %esp,%ebp
c010549d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01054a0:	8d 45 14             	lea    0x14(%ebp),%eax
c01054a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01054a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01054ad:	8b 45 10             	mov    0x10(%ebp),%eax
c01054b0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01054b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01054be:	89 04 24             	mov    %eax,(%esp)
c01054c1:	e8 02 00 00 00       	call   c01054c8 <vprintfmt>
    va_end(ap);
}
c01054c6:	c9                   	leave  
c01054c7:	c3                   	ret    

c01054c8 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01054c8:	55                   	push   %ebp
c01054c9:	89 e5                	mov    %esp,%ebp
c01054cb:	56                   	push   %esi
c01054cc:	53                   	push   %ebx
c01054cd:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01054d0:	eb 18                	jmp    c01054ea <vprintfmt+0x22>
            if (ch == '\0') {
c01054d2:	85 db                	test   %ebx,%ebx
c01054d4:	75 05                	jne    c01054db <vprintfmt+0x13>
                return;
c01054d6:	e9 d1 03 00 00       	jmp    c01058ac <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01054db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054de:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054e2:	89 1c 24             	mov    %ebx,(%esp)
c01054e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01054e8:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01054ea:	8b 45 10             	mov    0x10(%ebp),%eax
c01054ed:	8d 50 01             	lea    0x1(%eax),%edx
c01054f0:	89 55 10             	mov    %edx,0x10(%ebp)
c01054f3:	0f b6 00             	movzbl (%eax),%eax
c01054f6:	0f b6 d8             	movzbl %al,%ebx
c01054f9:	83 fb 25             	cmp    $0x25,%ebx
c01054fc:	75 d4                	jne    c01054d2 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01054fe:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105502:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010550c:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010550f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105516:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105519:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010551c:	8b 45 10             	mov    0x10(%ebp),%eax
c010551f:	8d 50 01             	lea    0x1(%eax),%edx
c0105522:	89 55 10             	mov    %edx,0x10(%ebp)
c0105525:	0f b6 00             	movzbl (%eax),%eax
c0105528:	0f b6 d8             	movzbl %al,%ebx
c010552b:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010552e:	83 f8 55             	cmp    $0x55,%eax
c0105531:	0f 87 44 03 00 00    	ja     c010587b <vprintfmt+0x3b3>
c0105537:	8b 04 85 10 70 10 c0 	mov    -0x3fef8ff0(,%eax,4),%eax
c010553e:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105540:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105544:	eb d6                	jmp    c010551c <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105546:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010554a:	eb d0                	jmp    c010551c <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010554c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105553:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105556:	89 d0                	mov    %edx,%eax
c0105558:	c1 e0 02             	shl    $0x2,%eax
c010555b:	01 d0                	add    %edx,%eax
c010555d:	01 c0                	add    %eax,%eax
c010555f:	01 d8                	add    %ebx,%eax
c0105561:	83 e8 30             	sub    $0x30,%eax
c0105564:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105567:	8b 45 10             	mov    0x10(%ebp),%eax
c010556a:	0f b6 00             	movzbl (%eax),%eax
c010556d:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105570:	83 fb 2f             	cmp    $0x2f,%ebx
c0105573:	7e 0b                	jle    c0105580 <vprintfmt+0xb8>
c0105575:	83 fb 39             	cmp    $0x39,%ebx
c0105578:	7f 06                	jg     c0105580 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010557a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010557e:	eb d3                	jmp    c0105553 <vprintfmt+0x8b>
            goto process_precision;
c0105580:	eb 33                	jmp    c01055b5 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0105582:	8b 45 14             	mov    0x14(%ebp),%eax
c0105585:	8d 50 04             	lea    0x4(%eax),%edx
c0105588:	89 55 14             	mov    %edx,0x14(%ebp)
c010558b:	8b 00                	mov    (%eax),%eax
c010558d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105590:	eb 23                	jmp    c01055b5 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0105592:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105596:	79 0c                	jns    c01055a4 <vprintfmt+0xdc>
                width = 0;
c0105598:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010559f:	e9 78 ff ff ff       	jmp    c010551c <vprintfmt+0x54>
c01055a4:	e9 73 ff ff ff       	jmp    c010551c <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01055a9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01055b0:	e9 67 ff ff ff       	jmp    c010551c <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01055b5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01055b9:	79 12                	jns    c01055cd <vprintfmt+0x105>
                width = precision, precision = -1;
c01055bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055be:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01055c1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01055c8:	e9 4f ff ff ff       	jmp    c010551c <vprintfmt+0x54>
c01055cd:	e9 4a ff ff ff       	jmp    c010551c <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01055d2:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01055d6:	e9 41 ff ff ff       	jmp    c010551c <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01055db:	8b 45 14             	mov    0x14(%ebp),%eax
c01055de:	8d 50 04             	lea    0x4(%eax),%edx
c01055e1:	89 55 14             	mov    %edx,0x14(%ebp)
c01055e4:	8b 00                	mov    (%eax),%eax
c01055e6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01055e9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01055ed:	89 04 24             	mov    %eax,(%esp)
c01055f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01055f3:	ff d0                	call   *%eax
            break;
c01055f5:	e9 ac 02 00 00       	jmp    c01058a6 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01055fa:	8b 45 14             	mov    0x14(%ebp),%eax
c01055fd:	8d 50 04             	lea    0x4(%eax),%edx
c0105600:	89 55 14             	mov    %edx,0x14(%ebp)
c0105603:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105605:	85 db                	test   %ebx,%ebx
c0105607:	79 02                	jns    c010560b <vprintfmt+0x143>
                err = -err;
c0105609:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010560b:	83 fb 06             	cmp    $0x6,%ebx
c010560e:	7f 0b                	jg     c010561b <vprintfmt+0x153>
c0105610:	8b 34 9d d0 6f 10 c0 	mov    -0x3fef9030(,%ebx,4),%esi
c0105617:	85 f6                	test   %esi,%esi
c0105619:	75 23                	jne    c010563e <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c010561b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010561f:	c7 44 24 08 fd 6f 10 	movl   $0xc0106ffd,0x8(%esp)
c0105626:	c0 
c0105627:	8b 45 0c             	mov    0xc(%ebp),%eax
c010562a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010562e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105631:	89 04 24             	mov    %eax,(%esp)
c0105634:	e8 61 fe ff ff       	call   c010549a <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105639:	e9 68 02 00 00       	jmp    c01058a6 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010563e:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105642:	c7 44 24 08 06 70 10 	movl   $0xc0107006,0x8(%esp)
c0105649:	c0 
c010564a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010564d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105651:	8b 45 08             	mov    0x8(%ebp),%eax
c0105654:	89 04 24             	mov    %eax,(%esp)
c0105657:	e8 3e fe ff ff       	call   c010549a <printfmt>
            }
            break;
c010565c:	e9 45 02 00 00       	jmp    c01058a6 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105661:	8b 45 14             	mov    0x14(%ebp),%eax
c0105664:	8d 50 04             	lea    0x4(%eax),%edx
c0105667:	89 55 14             	mov    %edx,0x14(%ebp)
c010566a:	8b 30                	mov    (%eax),%esi
c010566c:	85 f6                	test   %esi,%esi
c010566e:	75 05                	jne    c0105675 <vprintfmt+0x1ad>
                p = "(null)";
c0105670:	be 09 70 10 c0       	mov    $0xc0107009,%esi
            }
            if (width > 0 && padc != '-') {
c0105675:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105679:	7e 3e                	jle    c01056b9 <vprintfmt+0x1f1>
c010567b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010567f:	74 38                	je     c01056b9 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105681:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0105684:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105687:	89 44 24 04          	mov    %eax,0x4(%esp)
c010568b:	89 34 24             	mov    %esi,(%esp)
c010568e:	e8 15 03 00 00       	call   c01059a8 <strnlen>
c0105693:	29 c3                	sub    %eax,%ebx
c0105695:	89 d8                	mov    %ebx,%eax
c0105697:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010569a:	eb 17                	jmp    c01056b3 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c010569c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01056a0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01056a3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01056a7:	89 04 24             	mov    %eax,(%esp)
c01056aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ad:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01056af:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01056b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056b7:	7f e3                	jg     c010569c <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01056b9:	eb 38                	jmp    c01056f3 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c01056bb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01056bf:	74 1f                	je     c01056e0 <vprintfmt+0x218>
c01056c1:	83 fb 1f             	cmp    $0x1f,%ebx
c01056c4:	7e 05                	jle    c01056cb <vprintfmt+0x203>
c01056c6:	83 fb 7e             	cmp    $0x7e,%ebx
c01056c9:	7e 15                	jle    c01056e0 <vprintfmt+0x218>
                    putch('?', putdat);
c01056cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056ce:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056d2:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01056d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01056dc:	ff d0                	call   *%eax
c01056de:	eb 0f                	jmp    c01056ef <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c01056e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056e7:	89 1c 24             	mov    %ebx,(%esp)
c01056ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ed:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01056ef:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01056f3:	89 f0                	mov    %esi,%eax
c01056f5:	8d 70 01             	lea    0x1(%eax),%esi
c01056f8:	0f b6 00             	movzbl (%eax),%eax
c01056fb:	0f be d8             	movsbl %al,%ebx
c01056fe:	85 db                	test   %ebx,%ebx
c0105700:	74 10                	je     c0105712 <vprintfmt+0x24a>
c0105702:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105706:	78 b3                	js     c01056bb <vprintfmt+0x1f3>
c0105708:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010570c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105710:	79 a9                	jns    c01056bb <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105712:	eb 17                	jmp    c010572b <vprintfmt+0x263>
                putch(' ', putdat);
c0105714:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105717:	89 44 24 04          	mov    %eax,0x4(%esp)
c010571b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105722:	8b 45 08             	mov    0x8(%ebp),%eax
c0105725:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105727:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010572b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010572f:	7f e3                	jg     c0105714 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0105731:	e9 70 01 00 00       	jmp    c01058a6 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105736:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105739:	89 44 24 04          	mov    %eax,0x4(%esp)
c010573d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105740:	89 04 24             	mov    %eax,(%esp)
c0105743:	e8 0b fd ff ff       	call   c0105453 <getint>
c0105748:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010574b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010574e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105751:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105754:	85 d2                	test   %edx,%edx
c0105756:	79 26                	jns    c010577e <vprintfmt+0x2b6>
                putch('-', putdat);
c0105758:	8b 45 0c             	mov    0xc(%ebp),%eax
c010575b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010575f:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105766:	8b 45 08             	mov    0x8(%ebp),%eax
c0105769:	ff d0                	call   *%eax
                num = -(long long)num;
c010576b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010576e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105771:	f7 d8                	neg    %eax
c0105773:	83 d2 00             	adc    $0x0,%edx
c0105776:	f7 da                	neg    %edx
c0105778:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010577b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010577e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105785:	e9 a8 00 00 00       	jmp    c0105832 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010578a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010578d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105791:	8d 45 14             	lea    0x14(%ebp),%eax
c0105794:	89 04 24             	mov    %eax,(%esp)
c0105797:	e8 68 fc ff ff       	call   c0105404 <getuint>
c010579c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010579f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01057a2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01057a9:	e9 84 00 00 00       	jmp    c0105832 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01057ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057b5:	8d 45 14             	lea    0x14(%ebp),%eax
c01057b8:	89 04 24             	mov    %eax,(%esp)
c01057bb:	e8 44 fc ff ff       	call   c0105404 <getuint>
c01057c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01057c6:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01057cd:	eb 63                	jmp    c0105832 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c01057cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057d6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01057dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e0:	ff d0                	call   *%eax
            putch('x', putdat);
c01057e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057e9:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01057f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f3:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01057f5:	8b 45 14             	mov    0x14(%ebp),%eax
c01057f8:	8d 50 04             	lea    0x4(%eax),%edx
c01057fb:	89 55 14             	mov    %edx,0x14(%ebp)
c01057fe:	8b 00                	mov    (%eax),%eax
c0105800:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105803:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010580a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105811:	eb 1f                	jmp    c0105832 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105813:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105816:	89 44 24 04          	mov    %eax,0x4(%esp)
c010581a:	8d 45 14             	lea    0x14(%ebp),%eax
c010581d:	89 04 24             	mov    %eax,(%esp)
c0105820:	e8 df fb ff ff       	call   c0105404 <getuint>
c0105825:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105828:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010582b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105832:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105836:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105839:	89 54 24 18          	mov    %edx,0x18(%esp)
c010583d:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105840:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105844:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105848:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010584b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010584e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105852:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105856:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105859:	89 44 24 04          	mov    %eax,0x4(%esp)
c010585d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105860:	89 04 24             	mov    %eax,(%esp)
c0105863:	e8 97 fa ff ff       	call   c01052ff <printnum>
            break;
c0105868:	eb 3c                	jmp    c01058a6 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010586a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010586d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105871:	89 1c 24             	mov    %ebx,(%esp)
c0105874:	8b 45 08             	mov    0x8(%ebp),%eax
c0105877:	ff d0                	call   *%eax
            break;
c0105879:	eb 2b                	jmp    c01058a6 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010587b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010587e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105882:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105889:	8b 45 08             	mov    0x8(%ebp),%eax
c010588c:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c010588e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105892:	eb 04                	jmp    c0105898 <vprintfmt+0x3d0>
c0105894:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105898:	8b 45 10             	mov    0x10(%ebp),%eax
c010589b:	83 e8 01             	sub    $0x1,%eax
c010589e:	0f b6 00             	movzbl (%eax),%eax
c01058a1:	3c 25                	cmp    $0x25,%al
c01058a3:	75 ef                	jne    c0105894 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c01058a5:	90                   	nop
        }
    }
c01058a6:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01058a7:	e9 3e fc ff ff       	jmp    c01054ea <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01058ac:	83 c4 40             	add    $0x40,%esp
c01058af:	5b                   	pop    %ebx
c01058b0:	5e                   	pop    %esi
c01058b1:	5d                   	pop    %ebp
c01058b2:	c3                   	ret    

c01058b3 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01058b3:	55                   	push   %ebp
c01058b4:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01058b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058b9:	8b 40 08             	mov    0x8(%eax),%eax
c01058bc:	8d 50 01             	lea    0x1(%eax),%edx
c01058bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058c2:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01058c5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058c8:	8b 10                	mov    (%eax),%edx
c01058ca:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058cd:	8b 40 04             	mov    0x4(%eax),%eax
c01058d0:	39 c2                	cmp    %eax,%edx
c01058d2:	73 12                	jae    c01058e6 <sprintputch+0x33>
        *b->buf ++ = ch;
c01058d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058d7:	8b 00                	mov    (%eax),%eax
c01058d9:	8d 48 01             	lea    0x1(%eax),%ecx
c01058dc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01058df:	89 0a                	mov    %ecx,(%edx)
c01058e1:	8b 55 08             	mov    0x8(%ebp),%edx
c01058e4:	88 10                	mov    %dl,(%eax)
    }
}
c01058e6:	5d                   	pop    %ebp
c01058e7:	c3                   	ret    

c01058e8 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01058e8:	55                   	push   %ebp
c01058e9:	89 e5                	mov    %esp,%ebp
c01058eb:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01058ee:	8d 45 14             	lea    0x14(%ebp),%eax
c01058f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01058f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01058fb:	8b 45 10             	mov    0x10(%ebp),%eax
c01058fe:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105902:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105905:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105909:	8b 45 08             	mov    0x8(%ebp),%eax
c010590c:	89 04 24             	mov    %eax,(%esp)
c010590f:	e8 08 00 00 00       	call   c010591c <vsnprintf>
c0105914:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105917:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010591a:	c9                   	leave  
c010591b:	c3                   	ret    

c010591c <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c010591c:	55                   	push   %ebp
c010591d:	89 e5                	mov    %esp,%ebp
c010591f:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105922:	8b 45 08             	mov    0x8(%ebp),%eax
c0105925:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105928:	8b 45 0c             	mov    0xc(%ebp),%eax
c010592b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010592e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105931:	01 d0                	add    %edx,%eax
c0105933:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105936:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c010593d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105941:	74 0a                	je     c010594d <vsnprintf+0x31>
c0105943:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105946:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105949:	39 c2                	cmp    %eax,%edx
c010594b:	76 07                	jbe    c0105954 <vsnprintf+0x38>
        return -E_INVAL;
c010594d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105952:	eb 2a                	jmp    c010597e <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105954:	8b 45 14             	mov    0x14(%ebp),%eax
c0105957:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010595b:	8b 45 10             	mov    0x10(%ebp),%eax
c010595e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105962:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105965:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105969:	c7 04 24 b3 58 10 c0 	movl   $0xc01058b3,(%esp)
c0105970:	e8 53 fb ff ff       	call   c01054c8 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105975:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105978:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010597b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010597e:	c9                   	leave  
c010597f:	c3                   	ret    

c0105980 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105980:	55                   	push   %ebp
c0105981:	89 e5                	mov    %esp,%ebp
c0105983:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105986:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010598d:	eb 04                	jmp    c0105993 <strlen+0x13>
        cnt ++;
c010598f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105993:	8b 45 08             	mov    0x8(%ebp),%eax
c0105996:	8d 50 01             	lea    0x1(%eax),%edx
c0105999:	89 55 08             	mov    %edx,0x8(%ebp)
c010599c:	0f b6 00             	movzbl (%eax),%eax
c010599f:	84 c0                	test   %al,%al
c01059a1:	75 ec                	jne    c010598f <strlen+0xf>
        cnt ++;
    }
    return cnt;
c01059a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01059a6:	c9                   	leave  
c01059a7:	c3                   	ret    

c01059a8 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01059a8:	55                   	push   %ebp
c01059a9:	89 e5                	mov    %esp,%ebp
c01059ab:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01059ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01059b5:	eb 04                	jmp    c01059bb <strnlen+0x13>
        cnt ++;
c01059b7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c01059bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01059be:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01059c1:	73 10                	jae    c01059d3 <strnlen+0x2b>
c01059c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01059c6:	8d 50 01             	lea    0x1(%eax),%edx
c01059c9:	89 55 08             	mov    %edx,0x8(%ebp)
c01059cc:	0f b6 00             	movzbl (%eax),%eax
c01059cf:	84 c0                	test   %al,%al
c01059d1:	75 e4                	jne    c01059b7 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c01059d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01059d6:	c9                   	leave  
c01059d7:	c3                   	ret    

c01059d8 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01059d8:	55                   	push   %ebp
c01059d9:	89 e5                	mov    %esp,%ebp
c01059db:	57                   	push   %edi
c01059dc:	56                   	push   %esi
c01059dd:	83 ec 20             	sub    $0x20,%esp
c01059e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01059e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01059e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01059ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01059ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059f2:	89 d1                	mov    %edx,%ecx
c01059f4:	89 c2                	mov    %eax,%edx
c01059f6:	89 ce                	mov    %ecx,%esi
c01059f8:	89 d7                	mov    %edx,%edi
c01059fa:	ac                   	lods   %ds:(%esi),%al
c01059fb:	aa                   	stos   %al,%es:(%edi)
c01059fc:	84 c0                	test   %al,%al
c01059fe:	75 fa                	jne    c01059fa <strcpy+0x22>
c0105a00:	89 fa                	mov    %edi,%edx
c0105a02:	89 f1                	mov    %esi,%ecx
c0105a04:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105a07:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105a0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105a10:	83 c4 20             	add    $0x20,%esp
c0105a13:	5e                   	pop    %esi
c0105a14:	5f                   	pop    %edi
c0105a15:	5d                   	pop    %ebp
c0105a16:	c3                   	ret    

c0105a17 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105a17:	55                   	push   %ebp
c0105a18:	89 e5                	mov    %esp,%ebp
c0105a1a:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105a1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a20:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105a23:	eb 21                	jmp    c0105a46 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105a25:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a28:	0f b6 10             	movzbl (%eax),%edx
c0105a2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a2e:	88 10                	mov    %dl,(%eax)
c0105a30:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a33:	0f b6 00             	movzbl (%eax),%eax
c0105a36:	84 c0                	test   %al,%al
c0105a38:	74 04                	je     c0105a3e <strncpy+0x27>
            src ++;
c0105a3a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105a3e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105a42:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105a46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a4a:	75 d9                	jne    c0105a25 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105a4c:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105a4f:	c9                   	leave  
c0105a50:	c3                   	ret    

c0105a51 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105a51:	55                   	push   %ebp
c0105a52:	89 e5                	mov    %esp,%ebp
c0105a54:	57                   	push   %edi
c0105a55:	56                   	push   %esi
c0105a56:	83 ec 20             	sub    $0x20,%esp
c0105a59:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a62:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105a65:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a6b:	89 d1                	mov    %edx,%ecx
c0105a6d:	89 c2                	mov    %eax,%edx
c0105a6f:	89 ce                	mov    %ecx,%esi
c0105a71:	89 d7                	mov    %edx,%edi
c0105a73:	ac                   	lods   %ds:(%esi),%al
c0105a74:	ae                   	scas   %es:(%edi),%al
c0105a75:	75 08                	jne    c0105a7f <strcmp+0x2e>
c0105a77:	84 c0                	test   %al,%al
c0105a79:	75 f8                	jne    c0105a73 <strcmp+0x22>
c0105a7b:	31 c0                	xor    %eax,%eax
c0105a7d:	eb 04                	jmp    c0105a83 <strcmp+0x32>
c0105a7f:	19 c0                	sbb    %eax,%eax
c0105a81:	0c 01                	or     $0x1,%al
c0105a83:	89 fa                	mov    %edi,%edx
c0105a85:	89 f1                	mov    %esi,%ecx
c0105a87:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a8a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105a8d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105a93:	83 c4 20             	add    $0x20,%esp
c0105a96:	5e                   	pop    %esi
c0105a97:	5f                   	pop    %edi
c0105a98:	5d                   	pop    %ebp
c0105a99:	c3                   	ret    

c0105a9a <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105a9a:	55                   	push   %ebp
c0105a9b:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105a9d:	eb 0c                	jmp    c0105aab <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105a9f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105aa3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105aa7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105aab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105aaf:	74 1a                	je     c0105acb <strncmp+0x31>
c0105ab1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ab4:	0f b6 00             	movzbl (%eax),%eax
c0105ab7:	84 c0                	test   %al,%al
c0105ab9:	74 10                	je     c0105acb <strncmp+0x31>
c0105abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105abe:	0f b6 10             	movzbl (%eax),%edx
c0105ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ac4:	0f b6 00             	movzbl (%eax),%eax
c0105ac7:	38 c2                	cmp    %al,%dl
c0105ac9:	74 d4                	je     c0105a9f <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105acb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105acf:	74 18                	je     c0105ae9 <strncmp+0x4f>
c0105ad1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ad4:	0f b6 00             	movzbl (%eax),%eax
c0105ad7:	0f b6 d0             	movzbl %al,%edx
c0105ada:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105add:	0f b6 00             	movzbl (%eax),%eax
c0105ae0:	0f b6 c0             	movzbl %al,%eax
c0105ae3:	29 c2                	sub    %eax,%edx
c0105ae5:	89 d0                	mov    %edx,%eax
c0105ae7:	eb 05                	jmp    c0105aee <strncmp+0x54>
c0105ae9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105aee:	5d                   	pop    %ebp
c0105aef:	c3                   	ret    

c0105af0 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105af0:	55                   	push   %ebp
c0105af1:	89 e5                	mov    %esp,%ebp
c0105af3:	83 ec 04             	sub    $0x4,%esp
c0105af6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105af9:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105afc:	eb 14                	jmp    c0105b12 <strchr+0x22>
        if (*s == c) {
c0105afe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b01:	0f b6 00             	movzbl (%eax),%eax
c0105b04:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105b07:	75 05                	jne    c0105b0e <strchr+0x1e>
            return (char *)s;
c0105b09:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b0c:	eb 13                	jmp    c0105b21 <strchr+0x31>
        }
        s ++;
c0105b0e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105b12:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b15:	0f b6 00             	movzbl (%eax),%eax
c0105b18:	84 c0                	test   %al,%al
c0105b1a:	75 e2                	jne    c0105afe <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105b1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105b21:	c9                   	leave  
c0105b22:	c3                   	ret    

c0105b23 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105b23:	55                   	push   %ebp
c0105b24:	89 e5                	mov    %esp,%ebp
c0105b26:	83 ec 04             	sub    $0x4,%esp
c0105b29:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b2c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105b2f:	eb 11                	jmp    c0105b42 <strfind+0x1f>
        if (*s == c) {
c0105b31:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b34:	0f b6 00             	movzbl (%eax),%eax
c0105b37:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105b3a:	75 02                	jne    c0105b3e <strfind+0x1b>
            break;
c0105b3c:	eb 0e                	jmp    c0105b4c <strfind+0x29>
        }
        s ++;
c0105b3e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105b42:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b45:	0f b6 00             	movzbl (%eax),%eax
c0105b48:	84 c0                	test   %al,%al
c0105b4a:	75 e5                	jne    c0105b31 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105b4c:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105b4f:	c9                   	leave  
c0105b50:	c3                   	ret    

c0105b51 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105b51:	55                   	push   %ebp
c0105b52:	89 e5                	mov    %esp,%ebp
c0105b54:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105b57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105b5e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105b65:	eb 04                	jmp    c0105b6b <strtol+0x1a>
        s ++;
c0105b67:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105b6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b6e:	0f b6 00             	movzbl (%eax),%eax
c0105b71:	3c 20                	cmp    $0x20,%al
c0105b73:	74 f2                	je     c0105b67 <strtol+0x16>
c0105b75:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b78:	0f b6 00             	movzbl (%eax),%eax
c0105b7b:	3c 09                	cmp    $0x9,%al
c0105b7d:	74 e8                	je     c0105b67 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105b7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b82:	0f b6 00             	movzbl (%eax),%eax
c0105b85:	3c 2b                	cmp    $0x2b,%al
c0105b87:	75 06                	jne    c0105b8f <strtol+0x3e>
        s ++;
c0105b89:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b8d:	eb 15                	jmp    c0105ba4 <strtol+0x53>
    }
    else if (*s == '-') {
c0105b8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b92:	0f b6 00             	movzbl (%eax),%eax
c0105b95:	3c 2d                	cmp    $0x2d,%al
c0105b97:	75 0b                	jne    c0105ba4 <strtol+0x53>
        s ++, neg = 1;
c0105b99:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b9d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105ba4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ba8:	74 06                	je     c0105bb0 <strtol+0x5f>
c0105baa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105bae:	75 24                	jne    c0105bd4 <strtol+0x83>
c0105bb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb3:	0f b6 00             	movzbl (%eax),%eax
c0105bb6:	3c 30                	cmp    $0x30,%al
c0105bb8:	75 1a                	jne    c0105bd4 <strtol+0x83>
c0105bba:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bbd:	83 c0 01             	add    $0x1,%eax
c0105bc0:	0f b6 00             	movzbl (%eax),%eax
c0105bc3:	3c 78                	cmp    $0x78,%al
c0105bc5:	75 0d                	jne    c0105bd4 <strtol+0x83>
        s += 2, base = 16;
c0105bc7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105bcb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105bd2:	eb 2a                	jmp    c0105bfe <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105bd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bd8:	75 17                	jne    c0105bf1 <strtol+0xa0>
c0105bda:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bdd:	0f b6 00             	movzbl (%eax),%eax
c0105be0:	3c 30                	cmp    $0x30,%al
c0105be2:	75 0d                	jne    c0105bf1 <strtol+0xa0>
        s ++, base = 8;
c0105be4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105be8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105bef:	eb 0d                	jmp    c0105bfe <strtol+0xad>
    }
    else if (base == 0) {
c0105bf1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bf5:	75 07                	jne    c0105bfe <strtol+0xad>
        base = 10;
c0105bf7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105bfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c01:	0f b6 00             	movzbl (%eax),%eax
c0105c04:	3c 2f                	cmp    $0x2f,%al
c0105c06:	7e 1b                	jle    c0105c23 <strtol+0xd2>
c0105c08:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c0b:	0f b6 00             	movzbl (%eax),%eax
c0105c0e:	3c 39                	cmp    $0x39,%al
c0105c10:	7f 11                	jg     c0105c23 <strtol+0xd2>
            dig = *s - '0';
c0105c12:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c15:	0f b6 00             	movzbl (%eax),%eax
c0105c18:	0f be c0             	movsbl %al,%eax
c0105c1b:	83 e8 30             	sub    $0x30,%eax
c0105c1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c21:	eb 48                	jmp    c0105c6b <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105c23:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c26:	0f b6 00             	movzbl (%eax),%eax
c0105c29:	3c 60                	cmp    $0x60,%al
c0105c2b:	7e 1b                	jle    c0105c48 <strtol+0xf7>
c0105c2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c30:	0f b6 00             	movzbl (%eax),%eax
c0105c33:	3c 7a                	cmp    $0x7a,%al
c0105c35:	7f 11                	jg     c0105c48 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105c37:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c3a:	0f b6 00             	movzbl (%eax),%eax
c0105c3d:	0f be c0             	movsbl %al,%eax
c0105c40:	83 e8 57             	sub    $0x57,%eax
c0105c43:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c46:	eb 23                	jmp    c0105c6b <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105c48:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c4b:	0f b6 00             	movzbl (%eax),%eax
c0105c4e:	3c 40                	cmp    $0x40,%al
c0105c50:	7e 3d                	jle    c0105c8f <strtol+0x13e>
c0105c52:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c55:	0f b6 00             	movzbl (%eax),%eax
c0105c58:	3c 5a                	cmp    $0x5a,%al
c0105c5a:	7f 33                	jg     c0105c8f <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105c5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5f:	0f b6 00             	movzbl (%eax),%eax
c0105c62:	0f be c0             	movsbl %al,%eax
c0105c65:	83 e8 37             	sub    $0x37,%eax
c0105c68:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c6e:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105c71:	7c 02                	jl     c0105c75 <strtol+0x124>
            break;
c0105c73:	eb 1a                	jmp    c0105c8f <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105c75:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c79:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105c7c:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105c80:	89 c2                	mov    %eax,%edx
c0105c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c85:	01 d0                	add    %edx,%eax
c0105c87:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105c8a:	e9 6f ff ff ff       	jmp    c0105bfe <strtol+0xad>

    if (endptr) {
c0105c8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105c93:	74 08                	je     c0105c9d <strtol+0x14c>
        *endptr = (char *) s;
c0105c95:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c98:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c9b:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105c9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105ca1:	74 07                	je     c0105caa <strtol+0x159>
c0105ca3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105ca6:	f7 d8                	neg    %eax
c0105ca8:	eb 03                	jmp    c0105cad <strtol+0x15c>
c0105caa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105cad:	c9                   	leave  
c0105cae:	c3                   	ret    

c0105caf <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105caf:	55                   	push   %ebp
c0105cb0:	89 e5                	mov    %esp,%ebp
c0105cb2:	57                   	push   %edi
c0105cb3:	83 ec 24             	sub    $0x24,%esp
c0105cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cb9:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105cbc:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105cc0:	8b 55 08             	mov    0x8(%ebp),%edx
c0105cc3:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105cc6:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105cc9:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ccc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105ccf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105cd2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105cd6:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105cd9:	89 d7                	mov    %edx,%edi
c0105cdb:	f3 aa                	rep stos %al,%es:(%edi)
c0105cdd:	89 fa                	mov    %edi,%edx
c0105cdf:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105ce2:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105ce5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105ce8:	83 c4 24             	add    $0x24,%esp
c0105ceb:	5f                   	pop    %edi
c0105cec:	5d                   	pop    %ebp
c0105ced:	c3                   	ret    

c0105cee <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105cee:	55                   	push   %ebp
c0105cef:	89 e5                	mov    %esp,%ebp
c0105cf1:	57                   	push   %edi
c0105cf2:	56                   	push   %esi
c0105cf3:	53                   	push   %ebx
c0105cf4:	83 ec 30             	sub    $0x30,%esp
c0105cf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d00:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d03:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d06:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d0c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105d0f:	73 42                	jae    c0105d53 <memmove+0x65>
c0105d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105d17:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105d1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d20:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105d23:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105d26:	c1 e8 02             	shr    $0x2,%eax
c0105d29:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105d2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105d2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d31:	89 d7                	mov    %edx,%edi
c0105d33:	89 c6                	mov    %eax,%esi
c0105d35:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105d37:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105d3a:	83 e1 03             	and    $0x3,%ecx
c0105d3d:	74 02                	je     c0105d41 <memmove+0x53>
c0105d3f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105d41:	89 f0                	mov    %esi,%eax
c0105d43:	89 fa                	mov    %edi,%edx
c0105d45:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105d48:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105d4b:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d51:	eb 36                	jmp    c0105d89 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105d53:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d56:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105d59:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d5c:	01 c2                	add    %eax,%edx
c0105d5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d61:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d67:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105d6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d6d:	89 c1                	mov    %eax,%ecx
c0105d6f:	89 d8                	mov    %ebx,%eax
c0105d71:	89 d6                	mov    %edx,%esi
c0105d73:	89 c7                	mov    %eax,%edi
c0105d75:	fd                   	std    
c0105d76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105d78:	fc                   	cld    
c0105d79:	89 f8                	mov    %edi,%eax
c0105d7b:	89 f2                	mov    %esi,%edx
c0105d7d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105d80:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105d83:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105d89:	83 c4 30             	add    $0x30,%esp
c0105d8c:	5b                   	pop    %ebx
c0105d8d:	5e                   	pop    %esi
c0105d8e:	5f                   	pop    %edi
c0105d8f:	5d                   	pop    %ebp
c0105d90:	c3                   	ret    

c0105d91 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105d91:	55                   	push   %ebp
c0105d92:	89 e5                	mov    %esp,%ebp
c0105d94:	57                   	push   %edi
c0105d95:	56                   	push   %esi
c0105d96:	83 ec 20             	sub    $0x20,%esp
c0105d99:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105da2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105da5:	8b 45 10             	mov    0x10(%ebp),%eax
c0105da8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105dae:	c1 e8 02             	shr    $0x2,%eax
c0105db1:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105db3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105db9:	89 d7                	mov    %edx,%edi
c0105dbb:	89 c6                	mov    %eax,%esi
c0105dbd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105dbf:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105dc2:	83 e1 03             	and    $0x3,%ecx
c0105dc5:	74 02                	je     c0105dc9 <memcpy+0x38>
c0105dc7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105dc9:	89 f0                	mov    %esi,%eax
c0105dcb:	89 fa                	mov    %edi,%edx
c0105dcd:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105dd0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105dd3:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105dd9:	83 c4 20             	add    $0x20,%esp
c0105ddc:	5e                   	pop    %esi
c0105ddd:	5f                   	pop    %edi
c0105dde:	5d                   	pop    %ebp
c0105ddf:	c3                   	ret    

c0105de0 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105de0:	55                   	push   %ebp
c0105de1:	89 e5                	mov    %esp,%ebp
c0105de3:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105de6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105de9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105dec:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105def:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105df2:	eb 30                	jmp    c0105e24 <memcmp+0x44>
        if (*s1 != *s2) {
c0105df4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105df7:	0f b6 10             	movzbl (%eax),%edx
c0105dfa:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105dfd:	0f b6 00             	movzbl (%eax),%eax
c0105e00:	38 c2                	cmp    %al,%dl
c0105e02:	74 18                	je     c0105e1c <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105e04:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e07:	0f b6 00             	movzbl (%eax),%eax
c0105e0a:	0f b6 d0             	movzbl %al,%edx
c0105e0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e10:	0f b6 00             	movzbl (%eax),%eax
c0105e13:	0f b6 c0             	movzbl %al,%eax
c0105e16:	29 c2                	sub    %eax,%edx
c0105e18:	89 d0                	mov    %edx,%eax
c0105e1a:	eb 1a                	jmp    c0105e36 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105e1c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105e20:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105e24:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e27:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105e2a:	89 55 10             	mov    %edx,0x10(%ebp)
c0105e2d:	85 c0                	test   %eax,%eax
c0105e2f:	75 c3                	jne    c0105df4 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105e31:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105e36:	c9                   	leave  
c0105e37:	c3                   	ret    
