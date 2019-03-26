
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
c010005d:	e8 93 5d 00 00       	call   c0105df5 <memset>

    cons_init();                // init the console
c0100062:	e8 82 15 00 00       	call   c01015e9 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 80 5f 10 c0 	movl   $0xc0105f80,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 9c 5f 10 c0 	movl   $0xc0105f9c,(%esp)
c010007c:	e8 c7 02 00 00       	call   c0100348 <cprintf>

    print_kerninfo();
c0100081:	e8 f6 07 00 00       	call   c010087c <print_kerninfo>

    grade_backtrace();
c0100086:	e8 86 00 00 00       	call   c0100111 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 d0 42 00 00       	call   c0104360 <pmm_init>

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
c0100161:	c7 04 24 a1 5f 10 c0 	movl   $0xc0105fa1,(%esp)
c0100168:	e8 db 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010016d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100171:	0f b7 d0             	movzwl %ax,%edx
c0100174:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100179:	89 54 24 08          	mov    %edx,0x8(%esp)
c010017d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100181:	c7 04 24 af 5f 10 c0 	movl   $0xc0105faf,(%esp)
c0100188:	e8 bb 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100191:	0f b7 d0             	movzwl %ax,%edx
c0100194:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100199:	89 54 24 08          	mov    %edx,0x8(%esp)
c010019d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a1:	c7 04 24 bd 5f 10 c0 	movl   $0xc0105fbd,(%esp)
c01001a8:	e8 9b 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001ad:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b1:	0f b7 d0             	movzwl %ax,%edx
c01001b4:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c1:	c7 04 24 cb 5f 10 c0 	movl   $0xc0105fcb,(%esp)
c01001c8:	e8 7b 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001cd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d1:	0f b7 d0             	movzwl %ax,%edx
c01001d4:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001d9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e1:	c7 04 24 d9 5f 10 c0 	movl   $0xc0105fd9,(%esp)
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
    //LAB1 CHALLENGE 1 : TODO
}
c01001ff:	5d                   	pop    %ebp
c0100200:	c3                   	ret    

c0100201 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100201:	55                   	push   %ebp
c0100202:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
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
c0100211:	c7 04 24 e8 5f 10 c0 	movl   $0xc0105fe8,(%esp)
c0100218:	e8 2b 01 00 00       	call   c0100348 <cprintf>
    lab1_switch_to_user();
c010021d:	e8 da ff ff ff       	call   c01001fc <lab1_switch_to_user>
    lab1_print_cur_status();
c0100222:	e8 0f ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100227:	c7 04 24 08 60 10 c0 	movl   $0xc0106008,(%esp)
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
c0100252:	c7 04 24 27 60 10 c0 	movl   $0xc0106027,(%esp)
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
c010033e:	e8 cb 52 00 00       	call   c010560e <vprintfmt>
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
c0100548:	c7 00 2c 60 10 c0    	movl   $0xc010602c,(%eax)
    info->eip_line = 0;
c010054e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100551:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100558:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055b:	c7 40 08 2c 60 10 c0 	movl   $0xc010602c,0x8(%eax)
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
c010057f:	c7 45 f4 c0 72 10 c0 	movl   $0xc01072c0,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100586:	c7 45 f0 a4 1e 11 c0 	movl   $0xc0111ea4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010058d:	c7 45 ec a5 1e 11 c0 	movl   $0xc0111ea5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100594:	c7 45 e8 cd 48 11 c0 	movl   $0xc01148cd,-0x18(%ebp)

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
c01006f3:	e8 71 55 00 00       	call   c0105c69 <strfind>
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
c0100882:	c7 04 24 36 60 10 c0 	movl   $0xc0106036,(%esp)
c0100889:	e8 ba fa ff ff       	call   c0100348 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010088e:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100895:	c0 
c0100896:	c7 04 24 4f 60 10 c0 	movl   $0xc010604f,(%esp)
c010089d:	e8 a6 fa ff ff       	call   c0100348 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a2:	c7 44 24 04 7e 5f 10 	movl   $0xc0105f7e,0x4(%esp)
c01008a9:	c0 
c01008aa:	c7 04 24 67 60 10 c0 	movl   $0xc0106067,(%esp)
c01008b1:	e8 92 fa ff ff       	call   c0100348 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b6:	c7 44 24 04 00 a0 11 	movl   $0xc011a000,0x4(%esp)
c01008bd:	c0 
c01008be:	c7 04 24 7f 60 10 c0 	movl   $0xc010607f,(%esp)
c01008c5:	e8 7e fa ff ff       	call   c0100348 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008ca:	c7 44 24 04 28 af 11 	movl   $0xc011af28,0x4(%esp)
c01008d1:	c0 
c01008d2:	c7 04 24 97 60 10 c0 	movl   $0xc0106097,(%esp)
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
c0100904:	c7 04 24 b0 60 10 c0 	movl   $0xc01060b0,(%esp)
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
c0100938:	c7 04 24 da 60 10 c0 	movl   $0xc01060da,(%esp)
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
c01009a7:	c7 04 24 f6 60 10 c0 	movl   $0xc01060f6,(%esp)
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
    uint32_t ebp = read_ebp(), eip = read_eip();
c01009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009d7:	e8 d9 ff ff ff       	call   c01009b5 <read_eip>
c01009dc:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c01009df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009e6:	e9 88 00 00 00       	jmp    c0100a73 <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009ee:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f9:	c7 04 24 08 61 10 c0 	movl   $0xc0106108,(%esp)
c0100a00:	e8 43 f9 ff ff       	call   c0100348 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a08:	83 c0 08             	add    $0x8,%eax
c0100a0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100a0e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a15:	eb 25                	jmp    c0100a3c <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
c0100a17:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a1a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a24:	01 d0                	add    %edx,%eax
c0100a26:	8b 00                	mov    (%eax),%eax
c0100a28:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a2c:	c7 04 24 24 61 10 c0 	movl   $0xc0106124,(%esp)
c0100a33:	e8 10 f9 ff ff       	call   c0100348 <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
c0100a38:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a3c:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a40:	7e d5                	jle    c0100a17 <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
c0100a42:	c7 04 24 2c 61 10 c0 	movl   $0xc010612c,(%esp)
c0100a49:	e8 fa f8 ff ff       	call   c0100348 <cprintf>
        print_debuginfo(eip - 1);
c0100a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a51:	83 e8 01             	sub    $0x1,%eax
c0100a54:	89 04 24             	mov    %eax,(%esp)
c0100a57:	e8 b6 fe ff ff       	call   c0100912 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5f:	83 c0 04             	add    $0x4,%eax
c0100a62:	8b 00                	mov    (%eax),%eax
c0100a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6a:	8b 00                	mov    (%eax),%eax
c0100a6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a6f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a77:	74 0a                	je     c0100a83 <print_stackframe+0xbd>
c0100a79:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a7d:	0f 8e 68 ff ff ff    	jle    c01009eb <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
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
c0100ab7:	c7 04 24 b0 61 10 c0 	movl   $0xc01061b0,(%esp)
c0100abe:	e8 73 51 00 00       	call   c0105c36 <strchr>
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
c0100ae1:	c7 04 24 b5 61 10 c0 	movl   $0xc01061b5,(%esp)
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
c0100b24:	c7 04 24 b0 61 10 c0 	movl   $0xc01061b0,(%esp)
c0100b2b:	e8 06 51 00 00       	call   c0105c36 <strchr>
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
c0100b90:	e8 02 50 00 00       	call   c0105b97 <strcmp>
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
c0100bde:	c7 04 24 d3 61 10 c0 	movl   $0xc01061d3,(%esp)
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
c0100bf7:	c7 04 24 ec 61 10 c0 	movl   $0xc01061ec,(%esp)
c0100bfe:	e8 45 f7 ff ff       	call   c0100348 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c03:	c7 04 24 14 62 10 c0 	movl   $0xc0106214,(%esp)
c0100c0a:	e8 39 f7 ff ff       	call   c0100348 <cprintf>

    if (tf != NULL) {
c0100c0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c13:	74 0b                	je     c0100c20 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c15:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c18:	89 04 24             	mov    %eax,(%esp)
c0100c1b:	e8 e8 0d 00 00       	call   c0101a08 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c20:	c7 04 24 39 62 10 c0 	movl   $0xc0106239,(%esp)
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
c0100c8f:	c7 04 24 3d 62 10 c0 	movl   $0xc010623d,(%esp)
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
c0100d01:	c7 04 24 46 62 10 c0 	movl   $0xc0106246,(%esp)
c0100d08:	e8 3b f6 ff ff       	call   c0100348 <cprintf>
    vcprintf(fmt, ap);
c0100d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d10:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d14:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d17:	89 04 24             	mov    %eax,(%esp)
c0100d1a:	e8 f6 f5 ff ff       	call   c0100315 <vcprintf>
    cprintf("\n");
c0100d1f:	c7 04 24 62 62 10 c0 	movl   $0xc0106262,(%esp)
c0100d26:	e8 1d f6 ff ff       	call   c0100348 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d2b:	c7 04 24 64 62 10 c0 	movl   $0xc0106264,(%esp)
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
c0100d69:	c7 04 24 76 62 10 c0 	movl   $0xc0106276,(%esp)
c0100d70:	e8 d3 f5 ff ff       	call   c0100348 <cprintf>
    vcprintf(fmt, ap);
c0100d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d78:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d7c:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d7f:	89 04 24             	mov    %eax,(%esp)
c0100d82:	e8 8e f5 ff ff       	call   c0100315 <vcprintf>
    cprintf("\n");
c0100d87:	c7 04 24 62 62 10 c0 	movl   $0xc0106262,(%esp)
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
c0100de8:	c7 04 24 94 62 10 c0 	movl   $0xc0106294,(%esp)
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
c0101212:	e8 1d 4c 00 00       	call   c0105e34 <memmove>
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
c0101598:	c7 04 24 af 62 10 c0 	movl   $0xc01062af,(%esp)
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
c0101607:	c7 04 24 bb 62 10 c0 	movl   $0xc01062bb,(%esp)
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
c010189b:	c7 04 24 e0 62 10 c0 	movl   $0xc01062e0,(%esp)
c01018a2:	e8 a1 ea ff ff       	call   c0100348 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01018a7:	c7 04 24 ea 62 10 c0 	movl   $0xc01062ea,(%esp)
c01018ae:	e8 95 ea ff ff       	call   c0100348 <cprintf>
    panic("EOT: kernel seems ok.");
c01018b3:	c7 44 24 08 f8 62 10 	movl   $0xc01062f8,0x8(%esp)
c01018ba:	c0 
c01018bb:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01018c2:	00 
c01018c3:	c7 04 24 0e 63 10 c0 	movl   $0xc010630e,(%esp)
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
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01018d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
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
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01019a0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01019a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a7:	3d ff 00 00 00       	cmp    $0xff,%eax
c01019ac:	0f 86 2f ff ff ff    	jbe    c01018e1 <idt_init+0x12>
c01019b2:	c7 45 f8 60 75 11 c0 	movl   $0xc0117560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01019b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019bc:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    lidt(&idt_pd);
}
c01019bf:	c9                   	leave  
c01019c0:	c3                   	ret    

c01019c1 <trapname>:

static const char *
trapname(int trapno) {
c01019c1:	55                   	push   %ebp
c01019c2:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01019c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01019c7:	83 f8 13             	cmp    $0x13,%eax
c01019ca:	77 0c                	ja     c01019d8 <trapname+0x17>
        return excnames[trapno];
c01019cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01019cf:	8b 04 85 60 66 10 c0 	mov    -0x3fef99a0(,%eax,4),%eax
c01019d6:	eb 18                	jmp    c01019f0 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01019d8:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01019dc:	7e 0d                	jle    c01019eb <trapname+0x2a>
c01019de:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01019e2:	7f 07                	jg     c01019eb <trapname+0x2a>
        return "Hardware Interrupt";
c01019e4:	b8 1f 63 10 c0       	mov    $0xc010631f,%eax
c01019e9:	eb 05                	jmp    c01019f0 <trapname+0x2f>
    }
    return "(unknown trap)";
c01019eb:	b8 32 63 10 c0       	mov    $0xc0106332,%eax
}
c01019f0:	5d                   	pop    %ebp
c01019f1:	c3                   	ret    

c01019f2 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01019f2:	55                   	push   %ebp
c01019f3:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01019f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01019f8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01019fc:	66 83 f8 08          	cmp    $0x8,%ax
c0101a00:	0f 94 c0             	sete   %al
c0101a03:	0f b6 c0             	movzbl %al,%eax
}
c0101a06:	5d                   	pop    %ebp
c0101a07:	c3                   	ret    

c0101a08 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a08:	55                   	push   %ebp
c0101a09:	89 e5                	mov    %esp,%ebp
c0101a0b:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a11:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a15:	c7 04 24 73 63 10 c0 	movl   $0xc0106373,(%esp)
c0101a1c:	e8 27 e9 ff ff       	call   c0100348 <cprintf>
    print_regs(&tf->tf_regs);
c0101a21:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a24:	89 04 24             	mov    %eax,(%esp)
c0101a27:	e8 a1 01 00 00       	call   c0101bcd <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a2f:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a33:	0f b7 c0             	movzwl %ax,%eax
c0101a36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a3a:	c7 04 24 84 63 10 c0 	movl   $0xc0106384,(%esp)
c0101a41:	e8 02 e9 ff ff       	call   c0100348 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a46:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a49:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a4d:	0f b7 c0             	movzwl %ax,%eax
c0101a50:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a54:	c7 04 24 97 63 10 c0 	movl   $0xc0106397,(%esp)
c0101a5b:	e8 e8 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a60:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a63:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101a67:	0f b7 c0             	movzwl %ax,%eax
c0101a6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a6e:	c7 04 24 aa 63 10 c0 	movl   $0xc01063aa,(%esp)
c0101a75:	e8 ce e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101a7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a7d:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101a81:	0f b7 c0             	movzwl %ax,%eax
c0101a84:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a88:	c7 04 24 bd 63 10 c0 	movl   $0xc01063bd,(%esp)
c0101a8f:	e8 b4 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a97:	8b 40 30             	mov    0x30(%eax),%eax
c0101a9a:	89 04 24             	mov    %eax,(%esp)
c0101a9d:	e8 1f ff ff ff       	call   c01019c1 <trapname>
c0101aa2:	8b 55 08             	mov    0x8(%ebp),%edx
c0101aa5:	8b 52 30             	mov    0x30(%edx),%edx
c0101aa8:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101aac:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101ab0:	c7 04 24 d0 63 10 c0 	movl   $0xc01063d0,(%esp)
c0101ab7:	e8 8c e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101abc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101abf:	8b 40 34             	mov    0x34(%eax),%eax
c0101ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac6:	c7 04 24 e2 63 10 c0 	movl   $0xc01063e2,(%esp)
c0101acd:	e8 76 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101ad2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad5:	8b 40 38             	mov    0x38(%eax),%eax
c0101ad8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101adc:	c7 04 24 f1 63 10 c0 	movl   $0xc01063f1,(%esp)
c0101ae3:	e8 60 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101ae8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aeb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101aef:	0f b7 c0             	movzwl %ax,%eax
c0101af2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101af6:	c7 04 24 00 64 10 c0 	movl   $0xc0106400,(%esp)
c0101afd:	e8 46 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b02:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b05:	8b 40 40             	mov    0x40(%eax),%eax
c0101b08:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b0c:	c7 04 24 13 64 10 c0 	movl   $0xc0106413,(%esp)
c0101b13:	e8 30 e8 ff ff       	call   c0100348 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b1f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b26:	eb 3e                	jmp    c0101b66 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b28:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2b:	8b 50 40             	mov    0x40(%eax),%edx
c0101b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b31:	21 d0                	and    %edx,%eax
c0101b33:	85 c0                	test   %eax,%eax
c0101b35:	74 28                	je     c0101b5f <print_trapframe+0x157>
c0101b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b3a:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101b41:	85 c0                	test   %eax,%eax
c0101b43:	74 1a                	je     c0101b5f <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b48:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b53:	c7 04 24 22 64 10 c0 	movl   $0xc0106422,(%esp)
c0101b5a:	e8 e9 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b5f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101b63:	d1 65 f0             	shll   -0x10(%ebp)
c0101b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b69:	83 f8 17             	cmp    $0x17,%eax
c0101b6c:	76 ba                	jbe    c0101b28 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101b6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b71:	8b 40 40             	mov    0x40(%eax),%eax
c0101b74:	25 00 30 00 00       	and    $0x3000,%eax
c0101b79:	c1 e8 0c             	shr    $0xc,%eax
c0101b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b80:	c7 04 24 26 64 10 c0 	movl   $0xc0106426,(%esp)
c0101b87:	e8 bc e7 ff ff       	call   c0100348 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8f:	89 04 24             	mov    %eax,(%esp)
c0101b92:	e8 5b fe ff ff       	call   c01019f2 <trap_in_kernel>
c0101b97:	85 c0                	test   %eax,%eax
c0101b99:	75 30                	jne    c0101bcb <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101b9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b9e:	8b 40 44             	mov    0x44(%eax),%eax
c0101ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ba5:	c7 04 24 2f 64 10 c0 	movl   $0xc010642f,(%esp)
c0101bac:	e8 97 e7 ff ff       	call   c0100348 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101bb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb4:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101bb8:	0f b7 c0             	movzwl %ax,%eax
c0101bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bbf:	c7 04 24 3e 64 10 c0 	movl   $0xc010643e,(%esp)
c0101bc6:	e8 7d e7 ff ff       	call   c0100348 <cprintf>
    }
}
c0101bcb:	c9                   	leave  
c0101bcc:	c3                   	ret    

c0101bcd <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101bcd:	55                   	push   %ebp
c0101bce:	89 e5                	mov    %esp,%ebp
c0101bd0:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101bd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd6:	8b 00                	mov    (%eax),%eax
c0101bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bdc:	c7 04 24 51 64 10 c0 	movl   $0xc0106451,(%esp)
c0101be3:	e8 60 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101be8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101beb:	8b 40 04             	mov    0x4(%eax),%eax
c0101bee:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf2:	c7 04 24 60 64 10 c0 	movl   $0xc0106460,(%esp)
c0101bf9:	e8 4a e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101bfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c01:	8b 40 08             	mov    0x8(%eax),%eax
c0101c04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c08:	c7 04 24 6f 64 10 c0 	movl   $0xc010646f,(%esp)
c0101c0f:	e8 34 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c14:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c17:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c1a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c1e:	c7 04 24 7e 64 10 c0 	movl   $0xc010647e,(%esp)
c0101c25:	e8 1e e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2d:	8b 40 10             	mov    0x10(%eax),%eax
c0101c30:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c34:	c7 04 24 8d 64 10 c0 	movl   $0xc010648d,(%esp)
c0101c3b:	e8 08 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c43:	8b 40 14             	mov    0x14(%eax),%eax
c0101c46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c4a:	c7 04 24 9c 64 10 c0 	movl   $0xc010649c,(%esp)
c0101c51:	e8 f2 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c56:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c59:	8b 40 18             	mov    0x18(%eax),%eax
c0101c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c60:	c7 04 24 ab 64 10 c0 	movl   $0xc01064ab,(%esp)
c0101c67:	e8 dc e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101c6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c6f:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101c72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c76:	c7 04 24 ba 64 10 c0 	movl   $0xc01064ba,(%esp)
c0101c7d:	e8 c6 e6 ff ff       	call   c0100348 <cprintf>
}
c0101c82:	c9                   	leave  
c0101c83:	c3                   	ret    

c0101c84 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101c84:	55                   	push   %ebp
c0101c85:	89 e5                	mov    %esp,%ebp
c0101c87:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101c8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c8d:	8b 40 30             	mov    0x30(%eax),%eax
c0101c90:	83 f8 2f             	cmp    $0x2f,%eax
c0101c93:	77 21                	ja     c0101cb6 <trap_dispatch+0x32>
c0101c95:	83 f8 2e             	cmp    $0x2e,%eax
c0101c98:	0f 83 04 01 00 00    	jae    c0101da2 <trap_dispatch+0x11e>
c0101c9e:	83 f8 21             	cmp    $0x21,%eax
c0101ca1:	0f 84 81 00 00 00    	je     c0101d28 <trap_dispatch+0xa4>
c0101ca7:	83 f8 24             	cmp    $0x24,%eax
c0101caa:	74 56                	je     c0101d02 <trap_dispatch+0x7e>
c0101cac:	83 f8 20             	cmp    $0x20,%eax
c0101caf:	74 16                	je     c0101cc7 <trap_dispatch+0x43>
c0101cb1:	e9 b4 00 00 00       	jmp    c0101d6a <trap_dispatch+0xe6>
c0101cb6:	83 e8 78             	sub    $0x78,%eax
c0101cb9:	83 f8 01             	cmp    $0x1,%eax
c0101cbc:	0f 87 a8 00 00 00    	ja     c0101d6a <trap_dispatch+0xe6>
c0101cc2:	e9 87 00 00 00       	jmp    c0101d4e <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101cc7:	a1 0c af 11 c0       	mov    0xc011af0c,%eax
c0101ccc:	83 c0 01             	add    $0x1,%eax
c0101ccf:	a3 0c af 11 c0       	mov    %eax,0xc011af0c
        if (ticks % TICK_NUM == 0) {
c0101cd4:	8b 0d 0c af 11 c0    	mov    0xc011af0c,%ecx
c0101cda:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101cdf:	89 c8                	mov    %ecx,%eax
c0101ce1:	f7 e2                	mul    %edx
c0101ce3:	89 d0                	mov    %edx,%eax
c0101ce5:	c1 e8 05             	shr    $0x5,%eax
c0101ce8:	6b c0 64             	imul   $0x64,%eax,%eax
c0101ceb:	29 c1                	sub    %eax,%ecx
c0101ced:	89 c8                	mov    %ecx,%eax
c0101cef:	85 c0                	test   %eax,%eax
c0101cf1:	75 0a                	jne    c0101cfd <trap_dispatch+0x79>
            print_ticks();
c0101cf3:	e8 95 fb ff ff       	call   c010188d <print_ticks>
        }
        break;
c0101cf8:	e9 a6 00 00 00       	jmp    c0101da3 <trap_dispatch+0x11f>
c0101cfd:	e9 a1 00 00 00       	jmp    c0101da3 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d02:	e8 4a f9 ff ff       	call   c0101651 <cons_getc>
c0101d07:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d0a:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d0e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d12:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d16:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d1a:	c7 04 24 c9 64 10 c0 	movl   $0xc01064c9,(%esp)
c0101d21:	e8 22 e6 ff ff       	call   c0100348 <cprintf>
        break;
c0101d26:	eb 7b                	jmp    c0101da3 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d28:	e8 24 f9 ff ff       	call   c0101651 <cons_getc>
c0101d2d:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d30:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d34:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d38:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d3c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d40:	c7 04 24 db 64 10 c0 	movl   $0xc01064db,(%esp)
c0101d47:	e8 fc e5 ff ff       	call   c0100348 <cprintf>
        break;
c0101d4c:	eb 55                	jmp    c0101da3 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d4e:	c7 44 24 08 ea 64 10 	movl   $0xc01064ea,0x8(%esp)
c0101d55:	c0 
c0101d56:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0101d5d:	00 
c0101d5e:	c7 04 24 0e 63 10 c0 	movl   $0xc010630e,(%esp)
c0101d65:	e8 68 ef ff ff       	call   c0100cd2 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101d6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d6d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101d71:	0f b7 c0             	movzwl %ax,%eax
c0101d74:	83 e0 03             	and    $0x3,%eax
c0101d77:	85 c0                	test   %eax,%eax
c0101d79:	75 28                	jne    c0101da3 <trap_dispatch+0x11f>
            print_trapframe(tf);
c0101d7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d7e:	89 04 24             	mov    %eax,(%esp)
c0101d81:	e8 82 fc ff ff       	call   c0101a08 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101d86:	c7 44 24 08 fa 64 10 	movl   $0xc01064fa,0x8(%esp)
c0101d8d:	c0 
c0101d8e:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0101d95:	00 
c0101d96:	c7 04 24 0e 63 10 c0 	movl   $0xc010630e,(%esp)
c0101d9d:	e8 30 ef ff ff       	call   c0100cd2 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101da2:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101da3:	c9                   	leave  
c0101da4:	c3                   	ret    

c0101da5 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101da5:	55                   	push   %ebp
c0101da6:	89 e5                	mov    %esp,%ebp
c0101da8:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101dab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dae:	89 04 24             	mov    %eax,(%esp)
c0101db1:	e8 ce fe ff ff       	call   c0101c84 <trap_dispatch>
}
c0101db6:	c9                   	leave  
c0101db7:	c3                   	ret    

c0101db8 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101db8:	1e                   	push   %ds
    pushl %es
c0101db9:	06                   	push   %es
    pushl %fs
c0101dba:	0f a0                	push   %fs
    pushl %gs
c0101dbc:	0f a8                	push   %gs
    pushal
c0101dbe:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101dbf:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101dc4:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101dc6:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101dc8:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101dc9:	e8 d7 ff ff ff       	call   c0101da5 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101dce:	5c                   	pop    %esp

c0101dcf <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101dcf:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101dd0:	0f a9                	pop    %gs
    popl %fs
c0101dd2:	0f a1                	pop    %fs
    popl %es
c0101dd4:	07                   	pop    %es
    popl %ds
c0101dd5:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101dd6:	83 c4 08             	add    $0x8,%esp
    iret
c0101dd9:	cf                   	iret   

c0101dda <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101dda:	6a 00                	push   $0x0
  pushl $0
c0101ddc:	6a 00                	push   $0x0
  jmp __alltraps
c0101dde:	e9 d5 ff ff ff       	jmp    c0101db8 <__alltraps>

c0101de3 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101de3:	6a 00                	push   $0x0
  pushl $1
c0101de5:	6a 01                	push   $0x1
  jmp __alltraps
c0101de7:	e9 cc ff ff ff       	jmp    c0101db8 <__alltraps>

c0101dec <vector2>:
.globl vector2
vector2:
  pushl $0
c0101dec:	6a 00                	push   $0x0
  pushl $2
c0101dee:	6a 02                	push   $0x2
  jmp __alltraps
c0101df0:	e9 c3 ff ff ff       	jmp    c0101db8 <__alltraps>

c0101df5 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101df5:	6a 00                	push   $0x0
  pushl $3
c0101df7:	6a 03                	push   $0x3
  jmp __alltraps
c0101df9:	e9 ba ff ff ff       	jmp    c0101db8 <__alltraps>

c0101dfe <vector4>:
.globl vector4
vector4:
  pushl $0
c0101dfe:	6a 00                	push   $0x0
  pushl $4
c0101e00:	6a 04                	push   $0x4
  jmp __alltraps
c0101e02:	e9 b1 ff ff ff       	jmp    c0101db8 <__alltraps>

c0101e07 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e07:	6a 00                	push   $0x0
  pushl $5
c0101e09:	6a 05                	push   $0x5
  jmp __alltraps
c0101e0b:	e9 a8 ff ff ff       	jmp    c0101db8 <__alltraps>

c0101e10 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e10:	6a 00                	push   $0x0
  pushl $6
c0101e12:	6a 06                	push   $0x6
  jmp __alltraps
c0101e14:	e9 9f ff ff ff       	jmp    c0101db8 <__alltraps>

c0101e19 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e19:	6a 00                	push   $0x0
  pushl $7
c0101e1b:	6a 07                	push   $0x7
  jmp __alltraps
c0101e1d:	e9 96 ff ff ff       	jmp    c0101db8 <__alltraps>

c0101e22 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e22:	6a 08                	push   $0x8
  jmp __alltraps
c0101e24:	e9 8f ff ff ff       	jmp    c0101db8 <__alltraps>

c0101e29 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e29:	6a 09                	push   $0x9
  jmp __alltraps
c0101e2b:	e9 88 ff ff ff       	jmp    c0101db8 <__alltraps>

c0101e30 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e30:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e32:	e9 81 ff ff ff       	jmp    c0101db8 <__alltraps>

c0101e37 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e37:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e39:	e9 7a ff ff ff       	jmp    c0101db8 <__alltraps>

c0101e3e <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e3e:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e40:	e9 73 ff ff ff       	jmp    c0101db8 <__alltraps>

c0101e45 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e45:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e47:	e9 6c ff ff ff       	jmp    c0101db8 <__alltraps>

c0101e4c <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e4c:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e4e:	e9 65 ff ff ff       	jmp    c0101db8 <__alltraps>

c0101e53 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e53:	6a 00                	push   $0x0
  pushl $15
c0101e55:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e57:	e9 5c ff ff ff       	jmp    c0101db8 <__alltraps>

c0101e5c <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e5c:	6a 00                	push   $0x0
  pushl $16
c0101e5e:	6a 10                	push   $0x10
  jmp __alltraps
c0101e60:	e9 53 ff ff ff       	jmp    c0101db8 <__alltraps>

c0101e65 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e65:	6a 11                	push   $0x11
  jmp __alltraps
c0101e67:	e9 4c ff ff ff       	jmp    c0101db8 <__alltraps>

c0101e6c <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e6c:	6a 00                	push   $0x0
  pushl $18
c0101e6e:	6a 12                	push   $0x12
  jmp __alltraps
c0101e70:	e9 43 ff ff ff       	jmp    c0101db8 <__alltraps>

c0101e75 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101e75:	6a 00                	push   $0x0
  pushl $19
c0101e77:	6a 13                	push   $0x13
  jmp __alltraps
c0101e79:	e9 3a ff ff ff       	jmp    c0101db8 <__alltraps>

c0101e7e <vector20>:
.globl vector20
vector20:
  pushl $0
c0101e7e:	6a 00                	push   $0x0
  pushl $20
c0101e80:	6a 14                	push   $0x14
  jmp __alltraps
c0101e82:	e9 31 ff ff ff       	jmp    c0101db8 <__alltraps>

c0101e87 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101e87:	6a 00                	push   $0x0
  pushl $21
c0101e89:	6a 15                	push   $0x15
  jmp __alltraps
c0101e8b:	e9 28 ff ff ff       	jmp    c0101db8 <__alltraps>

c0101e90 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101e90:	6a 00                	push   $0x0
  pushl $22
c0101e92:	6a 16                	push   $0x16
  jmp __alltraps
c0101e94:	e9 1f ff ff ff       	jmp    c0101db8 <__alltraps>

c0101e99 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101e99:	6a 00                	push   $0x0
  pushl $23
c0101e9b:	6a 17                	push   $0x17
  jmp __alltraps
c0101e9d:	e9 16 ff ff ff       	jmp    c0101db8 <__alltraps>

c0101ea2 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101ea2:	6a 00                	push   $0x0
  pushl $24
c0101ea4:	6a 18                	push   $0x18
  jmp __alltraps
c0101ea6:	e9 0d ff ff ff       	jmp    c0101db8 <__alltraps>

c0101eab <vector25>:
.globl vector25
vector25:
  pushl $0
c0101eab:	6a 00                	push   $0x0
  pushl $25
c0101ead:	6a 19                	push   $0x19
  jmp __alltraps
c0101eaf:	e9 04 ff ff ff       	jmp    c0101db8 <__alltraps>

c0101eb4 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101eb4:	6a 00                	push   $0x0
  pushl $26
c0101eb6:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101eb8:	e9 fb fe ff ff       	jmp    c0101db8 <__alltraps>

c0101ebd <vector27>:
.globl vector27
vector27:
  pushl $0
c0101ebd:	6a 00                	push   $0x0
  pushl $27
c0101ebf:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101ec1:	e9 f2 fe ff ff       	jmp    c0101db8 <__alltraps>

c0101ec6 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101ec6:	6a 00                	push   $0x0
  pushl $28
c0101ec8:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101eca:	e9 e9 fe ff ff       	jmp    c0101db8 <__alltraps>

c0101ecf <vector29>:
.globl vector29
vector29:
  pushl $0
c0101ecf:	6a 00                	push   $0x0
  pushl $29
c0101ed1:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101ed3:	e9 e0 fe ff ff       	jmp    c0101db8 <__alltraps>

c0101ed8 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101ed8:	6a 00                	push   $0x0
  pushl $30
c0101eda:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101edc:	e9 d7 fe ff ff       	jmp    c0101db8 <__alltraps>

c0101ee1 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101ee1:	6a 00                	push   $0x0
  pushl $31
c0101ee3:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101ee5:	e9 ce fe ff ff       	jmp    c0101db8 <__alltraps>

c0101eea <vector32>:
.globl vector32
vector32:
  pushl $0
c0101eea:	6a 00                	push   $0x0
  pushl $32
c0101eec:	6a 20                	push   $0x20
  jmp __alltraps
c0101eee:	e9 c5 fe ff ff       	jmp    c0101db8 <__alltraps>

c0101ef3 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101ef3:	6a 00                	push   $0x0
  pushl $33
c0101ef5:	6a 21                	push   $0x21
  jmp __alltraps
c0101ef7:	e9 bc fe ff ff       	jmp    c0101db8 <__alltraps>

c0101efc <vector34>:
.globl vector34
vector34:
  pushl $0
c0101efc:	6a 00                	push   $0x0
  pushl $34
c0101efe:	6a 22                	push   $0x22
  jmp __alltraps
c0101f00:	e9 b3 fe ff ff       	jmp    c0101db8 <__alltraps>

c0101f05 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f05:	6a 00                	push   $0x0
  pushl $35
c0101f07:	6a 23                	push   $0x23
  jmp __alltraps
c0101f09:	e9 aa fe ff ff       	jmp    c0101db8 <__alltraps>

c0101f0e <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f0e:	6a 00                	push   $0x0
  pushl $36
c0101f10:	6a 24                	push   $0x24
  jmp __alltraps
c0101f12:	e9 a1 fe ff ff       	jmp    c0101db8 <__alltraps>

c0101f17 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f17:	6a 00                	push   $0x0
  pushl $37
c0101f19:	6a 25                	push   $0x25
  jmp __alltraps
c0101f1b:	e9 98 fe ff ff       	jmp    c0101db8 <__alltraps>

c0101f20 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f20:	6a 00                	push   $0x0
  pushl $38
c0101f22:	6a 26                	push   $0x26
  jmp __alltraps
c0101f24:	e9 8f fe ff ff       	jmp    c0101db8 <__alltraps>

c0101f29 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f29:	6a 00                	push   $0x0
  pushl $39
c0101f2b:	6a 27                	push   $0x27
  jmp __alltraps
c0101f2d:	e9 86 fe ff ff       	jmp    c0101db8 <__alltraps>

c0101f32 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f32:	6a 00                	push   $0x0
  pushl $40
c0101f34:	6a 28                	push   $0x28
  jmp __alltraps
c0101f36:	e9 7d fe ff ff       	jmp    c0101db8 <__alltraps>

c0101f3b <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f3b:	6a 00                	push   $0x0
  pushl $41
c0101f3d:	6a 29                	push   $0x29
  jmp __alltraps
c0101f3f:	e9 74 fe ff ff       	jmp    c0101db8 <__alltraps>

c0101f44 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f44:	6a 00                	push   $0x0
  pushl $42
c0101f46:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f48:	e9 6b fe ff ff       	jmp    c0101db8 <__alltraps>

c0101f4d <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f4d:	6a 00                	push   $0x0
  pushl $43
c0101f4f:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f51:	e9 62 fe ff ff       	jmp    c0101db8 <__alltraps>

c0101f56 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f56:	6a 00                	push   $0x0
  pushl $44
c0101f58:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f5a:	e9 59 fe ff ff       	jmp    c0101db8 <__alltraps>

c0101f5f <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f5f:	6a 00                	push   $0x0
  pushl $45
c0101f61:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f63:	e9 50 fe ff ff       	jmp    c0101db8 <__alltraps>

c0101f68 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f68:	6a 00                	push   $0x0
  pushl $46
c0101f6a:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f6c:	e9 47 fe ff ff       	jmp    c0101db8 <__alltraps>

c0101f71 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101f71:	6a 00                	push   $0x0
  pushl $47
c0101f73:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101f75:	e9 3e fe ff ff       	jmp    c0101db8 <__alltraps>

c0101f7a <vector48>:
.globl vector48
vector48:
  pushl $0
c0101f7a:	6a 00                	push   $0x0
  pushl $48
c0101f7c:	6a 30                	push   $0x30
  jmp __alltraps
c0101f7e:	e9 35 fe ff ff       	jmp    c0101db8 <__alltraps>

c0101f83 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101f83:	6a 00                	push   $0x0
  pushl $49
c0101f85:	6a 31                	push   $0x31
  jmp __alltraps
c0101f87:	e9 2c fe ff ff       	jmp    c0101db8 <__alltraps>

c0101f8c <vector50>:
.globl vector50
vector50:
  pushl $0
c0101f8c:	6a 00                	push   $0x0
  pushl $50
c0101f8e:	6a 32                	push   $0x32
  jmp __alltraps
c0101f90:	e9 23 fe ff ff       	jmp    c0101db8 <__alltraps>

c0101f95 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101f95:	6a 00                	push   $0x0
  pushl $51
c0101f97:	6a 33                	push   $0x33
  jmp __alltraps
c0101f99:	e9 1a fe ff ff       	jmp    c0101db8 <__alltraps>

c0101f9e <vector52>:
.globl vector52
vector52:
  pushl $0
c0101f9e:	6a 00                	push   $0x0
  pushl $52
c0101fa0:	6a 34                	push   $0x34
  jmp __alltraps
c0101fa2:	e9 11 fe ff ff       	jmp    c0101db8 <__alltraps>

c0101fa7 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101fa7:	6a 00                	push   $0x0
  pushl $53
c0101fa9:	6a 35                	push   $0x35
  jmp __alltraps
c0101fab:	e9 08 fe ff ff       	jmp    c0101db8 <__alltraps>

c0101fb0 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101fb0:	6a 00                	push   $0x0
  pushl $54
c0101fb2:	6a 36                	push   $0x36
  jmp __alltraps
c0101fb4:	e9 ff fd ff ff       	jmp    c0101db8 <__alltraps>

c0101fb9 <vector55>:
.globl vector55
vector55:
  pushl $0
c0101fb9:	6a 00                	push   $0x0
  pushl $55
c0101fbb:	6a 37                	push   $0x37
  jmp __alltraps
c0101fbd:	e9 f6 fd ff ff       	jmp    c0101db8 <__alltraps>

c0101fc2 <vector56>:
.globl vector56
vector56:
  pushl $0
c0101fc2:	6a 00                	push   $0x0
  pushl $56
c0101fc4:	6a 38                	push   $0x38
  jmp __alltraps
c0101fc6:	e9 ed fd ff ff       	jmp    c0101db8 <__alltraps>

c0101fcb <vector57>:
.globl vector57
vector57:
  pushl $0
c0101fcb:	6a 00                	push   $0x0
  pushl $57
c0101fcd:	6a 39                	push   $0x39
  jmp __alltraps
c0101fcf:	e9 e4 fd ff ff       	jmp    c0101db8 <__alltraps>

c0101fd4 <vector58>:
.globl vector58
vector58:
  pushl $0
c0101fd4:	6a 00                	push   $0x0
  pushl $58
c0101fd6:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101fd8:	e9 db fd ff ff       	jmp    c0101db8 <__alltraps>

c0101fdd <vector59>:
.globl vector59
vector59:
  pushl $0
c0101fdd:	6a 00                	push   $0x0
  pushl $59
c0101fdf:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101fe1:	e9 d2 fd ff ff       	jmp    c0101db8 <__alltraps>

c0101fe6 <vector60>:
.globl vector60
vector60:
  pushl $0
c0101fe6:	6a 00                	push   $0x0
  pushl $60
c0101fe8:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101fea:	e9 c9 fd ff ff       	jmp    c0101db8 <__alltraps>

c0101fef <vector61>:
.globl vector61
vector61:
  pushl $0
c0101fef:	6a 00                	push   $0x0
  pushl $61
c0101ff1:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101ff3:	e9 c0 fd ff ff       	jmp    c0101db8 <__alltraps>

c0101ff8 <vector62>:
.globl vector62
vector62:
  pushl $0
c0101ff8:	6a 00                	push   $0x0
  pushl $62
c0101ffa:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101ffc:	e9 b7 fd ff ff       	jmp    c0101db8 <__alltraps>

c0102001 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102001:	6a 00                	push   $0x0
  pushl $63
c0102003:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102005:	e9 ae fd ff ff       	jmp    c0101db8 <__alltraps>

c010200a <vector64>:
.globl vector64
vector64:
  pushl $0
c010200a:	6a 00                	push   $0x0
  pushl $64
c010200c:	6a 40                	push   $0x40
  jmp __alltraps
c010200e:	e9 a5 fd ff ff       	jmp    c0101db8 <__alltraps>

c0102013 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102013:	6a 00                	push   $0x0
  pushl $65
c0102015:	6a 41                	push   $0x41
  jmp __alltraps
c0102017:	e9 9c fd ff ff       	jmp    c0101db8 <__alltraps>

c010201c <vector66>:
.globl vector66
vector66:
  pushl $0
c010201c:	6a 00                	push   $0x0
  pushl $66
c010201e:	6a 42                	push   $0x42
  jmp __alltraps
c0102020:	e9 93 fd ff ff       	jmp    c0101db8 <__alltraps>

c0102025 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102025:	6a 00                	push   $0x0
  pushl $67
c0102027:	6a 43                	push   $0x43
  jmp __alltraps
c0102029:	e9 8a fd ff ff       	jmp    c0101db8 <__alltraps>

c010202e <vector68>:
.globl vector68
vector68:
  pushl $0
c010202e:	6a 00                	push   $0x0
  pushl $68
c0102030:	6a 44                	push   $0x44
  jmp __alltraps
c0102032:	e9 81 fd ff ff       	jmp    c0101db8 <__alltraps>

c0102037 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102037:	6a 00                	push   $0x0
  pushl $69
c0102039:	6a 45                	push   $0x45
  jmp __alltraps
c010203b:	e9 78 fd ff ff       	jmp    c0101db8 <__alltraps>

c0102040 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102040:	6a 00                	push   $0x0
  pushl $70
c0102042:	6a 46                	push   $0x46
  jmp __alltraps
c0102044:	e9 6f fd ff ff       	jmp    c0101db8 <__alltraps>

c0102049 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102049:	6a 00                	push   $0x0
  pushl $71
c010204b:	6a 47                	push   $0x47
  jmp __alltraps
c010204d:	e9 66 fd ff ff       	jmp    c0101db8 <__alltraps>

c0102052 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102052:	6a 00                	push   $0x0
  pushl $72
c0102054:	6a 48                	push   $0x48
  jmp __alltraps
c0102056:	e9 5d fd ff ff       	jmp    c0101db8 <__alltraps>

c010205b <vector73>:
.globl vector73
vector73:
  pushl $0
c010205b:	6a 00                	push   $0x0
  pushl $73
c010205d:	6a 49                	push   $0x49
  jmp __alltraps
c010205f:	e9 54 fd ff ff       	jmp    c0101db8 <__alltraps>

c0102064 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102064:	6a 00                	push   $0x0
  pushl $74
c0102066:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102068:	e9 4b fd ff ff       	jmp    c0101db8 <__alltraps>

c010206d <vector75>:
.globl vector75
vector75:
  pushl $0
c010206d:	6a 00                	push   $0x0
  pushl $75
c010206f:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102071:	e9 42 fd ff ff       	jmp    c0101db8 <__alltraps>

c0102076 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102076:	6a 00                	push   $0x0
  pushl $76
c0102078:	6a 4c                	push   $0x4c
  jmp __alltraps
c010207a:	e9 39 fd ff ff       	jmp    c0101db8 <__alltraps>

c010207f <vector77>:
.globl vector77
vector77:
  pushl $0
c010207f:	6a 00                	push   $0x0
  pushl $77
c0102081:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102083:	e9 30 fd ff ff       	jmp    c0101db8 <__alltraps>

c0102088 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102088:	6a 00                	push   $0x0
  pushl $78
c010208a:	6a 4e                	push   $0x4e
  jmp __alltraps
c010208c:	e9 27 fd ff ff       	jmp    c0101db8 <__alltraps>

c0102091 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102091:	6a 00                	push   $0x0
  pushl $79
c0102093:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102095:	e9 1e fd ff ff       	jmp    c0101db8 <__alltraps>

c010209a <vector80>:
.globl vector80
vector80:
  pushl $0
c010209a:	6a 00                	push   $0x0
  pushl $80
c010209c:	6a 50                	push   $0x50
  jmp __alltraps
c010209e:	e9 15 fd ff ff       	jmp    c0101db8 <__alltraps>

c01020a3 <vector81>:
.globl vector81
vector81:
  pushl $0
c01020a3:	6a 00                	push   $0x0
  pushl $81
c01020a5:	6a 51                	push   $0x51
  jmp __alltraps
c01020a7:	e9 0c fd ff ff       	jmp    c0101db8 <__alltraps>

c01020ac <vector82>:
.globl vector82
vector82:
  pushl $0
c01020ac:	6a 00                	push   $0x0
  pushl $82
c01020ae:	6a 52                	push   $0x52
  jmp __alltraps
c01020b0:	e9 03 fd ff ff       	jmp    c0101db8 <__alltraps>

c01020b5 <vector83>:
.globl vector83
vector83:
  pushl $0
c01020b5:	6a 00                	push   $0x0
  pushl $83
c01020b7:	6a 53                	push   $0x53
  jmp __alltraps
c01020b9:	e9 fa fc ff ff       	jmp    c0101db8 <__alltraps>

c01020be <vector84>:
.globl vector84
vector84:
  pushl $0
c01020be:	6a 00                	push   $0x0
  pushl $84
c01020c0:	6a 54                	push   $0x54
  jmp __alltraps
c01020c2:	e9 f1 fc ff ff       	jmp    c0101db8 <__alltraps>

c01020c7 <vector85>:
.globl vector85
vector85:
  pushl $0
c01020c7:	6a 00                	push   $0x0
  pushl $85
c01020c9:	6a 55                	push   $0x55
  jmp __alltraps
c01020cb:	e9 e8 fc ff ff       	jmp    c0101db8 <__alltraps>

c01020d0 <vector86>:
.globl vector86
vector86:
  pushl $0
c01020d0:	6a 00                	push   $0x0
  pushl $86
c01020d2:	6a 56                	push   $0x56
  jmp __alltraps
c01020d4:	e9 df fc ff ff       	jmp    c0101db8 <__alltraps>

c01020d9 <vector87>:
.globl vector87
vector87:
  pushl $0
c01020d9:	6a 00                	push   $0x0
  pushl $87
c01020db:	6a 57                	push   $0x57
  jmp __alltraps
c01020dd:	e9 d6 fc ff ff       	jmp    c0101db8 <__alltraps>

c01020e2 <vector88>:
.globl vector88
vector88:
  pushl $0
c01020e2:	6a 00                	push   $0x0
  pushl $88
c01020e4:	6a 58                	push   $0x58
  jmp __alltraps
c01020e6:	e9 cd fc ff ff       	jmp    c0101db8 <__alltraps>

c01020eb <vector89>:
.globl vector89
vector89:
  pushl $0
c01020eb:	6a 00                	push   $0x0
  pushl $89
c01020ed:	6a 59                	push   $0x59
  jmp __alltraps
c01020ef:	e9 c4 fc ff ff       	jmp    c0101db8 <__alltraps>

c01020f4 <vector90>:
.globl vector90
vector90:
  pushl $0
c01020f4:	6a 00                	push   $0x0
  pushl $90
c01020f6:	6a 5a                	push   $0x5a
  jmp __alltraps
c01020f8:	e9 bb fc ff ff       	jmp    c0101db8 <__alltraps>

c01020fd <vector91>:
.globl vector91
vector91:
  pushl $0
c01020fd:	6a 00                	push   $0x0
  pushl $91
c01020ff:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102101:	e9 b2 fc ff ff       	jmp    c0101db8 <__alltraps>

c0102106 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102106:	6a 00                	push   $0x0
  pushl $92
c0102108:	6a 5c                	push   $0x5c
  jmp __alltraps
c010210a:	e9 a9 fc ff ff       	jmp    c0101db8 <__alltraps>

c010210f <vector93>:
.globl vector93
vector93:
  pushl $0
c010210f:	6a 00                	push   $0x0
  pushl $93
c0102111:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102113:	e9 a0 fc ff ff       	jmp    c0101db8 <__alltraps>

c0102118 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102118:	6a 00                	push   $0x0
  pushl $94
c010211a:	6a 5e                	push   $0x5e
  jmp __alltraps
c010211c:	e9 97 fc ff ff       	jmp    c0101db8 <__alltraps>

c0102121 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102121:	6a 00                	push   $0x0
  pushl $95
c0102123:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102125:	e9 8e fc ff ff       	jmp    c0101db8 <__alltraps>

c010212a <vector96>:
.globl vector96
vector96:
  pushl $0
c010212a:	6a 00                	push   $0x0
  pushl $96
c010212c:	6a 60                	push   $0x60
  jmp __alltraps
c010212e:	e9 85 fc ff ff       	jmp    c0101db8 <__alltraps>

c0102133 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102133:	6a 00                	push   $0x0
  pushl $97
c0102135:	6a 61                	push   $0x61
  jmp __alltraps
c0102137:	e9 7c fc ff ff       	jmp    c0101db8 <__alltraps>

c010213c <vector98>:
.globl vector98
vector98:
  pushl $0
c010213c:	6a 00                	push   $0x0
  pushl $98
c010213e:	6a 62                	push   $0x62
  jmp __alltraps
c0102140:	e9 73 fc ff ff       	jmp    c0101db8 <__alltraps>

c0102145 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102145:	6a 00                	push   $0x0
  pushl $99
c0102147:	6a 63                	push   $0x63
  jmp __alltraps
c0102149:	e9 6a fc ff ff       	jmp    c0101db8 <__alltraps>

c010214e <vector100>:
.globl vector100
vector100:
  pushl $0
c010214e:	6a 00                	push   $0x0
  pushl $100
c0102150:	6a 64                	push   $0x64
  jmp __alltraps
c0102152:	e9 61 fc ff ff       	jmp    c0101db8 <__alltraps>

c0102157 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102157:	6a 00                	push   $0x0
  pushl $101
c0102159:	6a 65                	push   $0x65
  jmp __alltraps
c010215b:	e9 58 fc ff ff       	jmp    c0101db8 <__alltraps>

c0102160 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102160:	6a 00                	push   $0x0
  pushl $102
c0102162:	6a 66                	push   $0x66
  jmp __alltraps
c0102164:	e9 4f fc ff ff       	jmp    c0101db8 <__alltraps>

c0102169 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102169:	6a 00                	push   $0x0
  pushl $103
c010216b:	6a 67                	push   $0x67
  jmp __alltraps
c010216d:	e9 46 fc ff ff       	jmp    c0101db8 <__alltraps>

c0102172 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102172:	6a 00                	push   $0x0
  pushl $104
c0102174:	6a 68                	push   $0x68
  jmp __alltraps
c0102176:	e9 3d fc ff ff       	jmp    c0101db8 <__alltraps>

c010217b <vector105>:
.globl vector105
vector105:
  pushl $0
c010217b:	6a 00                	push   $0x0
  pushl $105
c010217d:	6a 69                	push   $0x69
  jmp __alltraps
c010217f:	e9 34 fc ff ff       	jmp    c0101db8 <__alltraps>

c0102184 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102184:	6a 00                	push   $0x0
  pushl $106
c0102186:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102188:	e9 2b fc ff ff       	jmp    c0101db8 <__alltraps>

c010218d <vector107>:
.globl vector107
vector107:
  pushl $0
c010218d:	6a 00                	push   $0x0
  pushl $107
c010218f:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102191:	e9 22 fc ff ff       	jmp    c0101db8 <__alltraps>

c0102196 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102196:	6a 00                	push   $0x0
  pushl $108
c0102198:	6a 6c                	push   $0x6c
  jmp __alltraps
c010219a:	e9 19 fc ff ff       	jmp    c0101db8 <__alltraps>

c010219f <vector109>:
.globl vector109
vector109:
  pushl $0
c010219f:	6a 00                	push   $0x0
  pushl $109
c01021a1:	6a 6d                	push   $0x6d
  jmp __alltraps
c01021a3:	e9 10 fc ff ff       	jmp    c0101db8 <__alltraps>

c01021a8 <vector110>:
.globl vector110
vector110:
  pushl $0
c01021a8:	6a 00                	push   $0x0
  pushl $110
c01021aa:	6a 6e                	push   $0x6e
  jmp __alltraps
c01021ac:	e9 07 fc ff ff       	jmp    c0101db8 <__alltraps>

c01021b1 <vector111>:
.globl vector111
vector111:
  pushl $0
c01021b1:	6a 00                	push   $0x0
  pushl $111
c01021b3:	6a 6f                	push   $0x6f
  jmp __alltraps
c01021b5:	e9 fe fb ff ff       	jmp    c0101db8 <__alltraps>

c01021ba <vector112>:
.globl vector112
vector112:
  pushl $0
c01021ba:	6a 00                	push   $0x0
  pushl $112
c01021bc:	6a 70                	push   $0x70
  jmp __alltraps
c01021be:	e9 f5 fb ff ff       	jmp    c0101db8 <__alltraps>

c01021c3 <vector113>:
.globl vector113
vector113:
  pushl $0
c01021c3:	6a 00                	push   $0x0
  pushl $113
c01021c5:	6a 71                	push   $0x71
  jmp __alltraps
c01021c7:	e9 ec fb ff ff       	jmp    c0101db8 <__alltraps>

c01021cc <vector114>:
.globl vector114
vector114:
  pushl $0
c01021cc:	6a 00                	push   $0x0
  pushl $114
c01021ce:	6a 72                	push   $0x72
  jmp __alltraps
c01021d0:	e9 e3 fb ff ff       	jmp    c0101db8 <__alltraps>

c01021d5 <vector115>:
.globl vector115
vector115:
  pushl $0
c01021d5:	6a 00                	push   $0x0
  pushl $115
c01021d7:	6a 73                	push   $0x73
  jmp __alltraps
c01021d9:	e9 da fb ff ff       	jmp    c0101db8 <__alltraps>

c01021de <vector116>:
.globl vector116
vector116:
  pushl $0
c01021de:	6a 00                	push   $0x0
  pushl $116
c01021e0:	6a 74                	push   $0x74
  jmp __alltraps
c01021e2:	e9 d1 fb ff ff       	jmp    c0101db8 <__alltraps>

c01021e7 <vector117>:
.globl vector117
vector117:
  pushl $0
c01021e7:	6a 00                	push   $0x0
  pushl $117
c01021e9:	6a 75                	push   $0x75
  jmp __alltraps
c01021eb:	e9 c8 fb ff ff       	jmp    c0101db8 <__alltraps>

c01021f0 <vector118>:
.globl vector118
vector118:
  pushl $0
c01021f0:	6a 00                	push   $0x0
  pushl $118
c01021f2:	6a 76                	push   $0x76
  jmp __alltraps
c01021f4:	e9 bf fb ff ff       	jmp    c0101db8 <__alltraps>

c01021f9 <vector119>:
.globl vector119
vector119:
  pushl $0
c01021f9:	6a 00                	push   $0x0
  pushl $119
c01021fb:	6a 77                	push   $0x77
  jmp __alltraps
c01021fd:	e9 b6 fb ff ff       	jmp    c0101db8 <__alltraps>

c0102202 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102202:	6a 00                	push   $0x0
  pushl $120
c0102204:	6a 78                	push   $0x78
  jmp __alltraps
c0102206:	e9 ad fb ff ff       	jmp    c0101db8 <__alltraps>

c010220b <vector121>:
.globl vector121
vector121:
  pushl $0
c010220b:	6a 00                	push   $0x0
  pushl $121
c010220d:	6a 79                	push   $0x79
  jmp __alltraps
c010220f:	e9 a4 fb ff ff       	jmp    c0101db8 <__alltraps>

c0102214 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102214:	6a 00                	push   $0x0
  pushl $122
c0102216:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102218:	e9 9b fb ff ff       	jmp    c0101db8 <__alltraps>

c010221d <vector123>:
.globl vector123
vector123:
  pushl $0
c010221d:	6a 00                	push   $0x0
  pushl $123
c010221f:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102221:	e9 92 fb ff ff       	jmp    c0101db8 <__alltraps>

c0102226 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102226:	6a 00                	push   $0x0
  pushl $124
c0102228:	6a 7c                	push   $0x7c
  jmp __alltraps
c010222a:	e9 89 fb ff ff       	jmp    c0101db8 <__alltraps>

c010222f <vector125>:
.globl vector125
vector125:
  pushl $0
c010222f:	6a 00                	push   $0x0
  pushl $125
c0102231:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102233:	e9 80 fb ff ff       	jmp    c0101db8 <__alltraps>

c0102238 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102238:	6a 00                	push   $0x0
  pushl $126
c010223a:	6a 7e                	push   $0x7e
  jmp __alltraps
c010223c:	e9 77 fb ff ff       	jmp    c0101db8 <__alltraps>

c0102241 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102241:	6a 00                	push   $0x0
  pushl $127
c0102243:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102245:	e9 6e fb ff ff       	jmp    c0101db8 <__alltraps>

c010224a <vector128>:
.globl vector128
vector128:
  pushl $0
c010224a:	6a 00                	push   $0x0
  pushl $128
c010224c:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102251:	e9 62 fb ff ff       	jmp    c0101db8 <__alltraps>

c0102256 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102256:	6a 00                	push   $0x0
  pushl $129
c0102258:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c010225d:	e9 56 fb ff ff       	jmp    c0101db8 <__alltraps>

c0102262 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102262:	6a 00                	push   $0x0
  pushl $130
c0102264:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102269:	e9 4a fb ff ff       	jmp    c0101db8 <__alltraps>

c010226e <vector131>:
.globl vector131
vector131:
  pushl $0
c010226e:	6a 00                	push   $0x0
  pushl $131
c0102270:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102275:	e9 3e fb ff ff       	jmp    c0101db8 <__alltraps>

c010227a <vector132>:
.globl vector132
vector132:
  pushl $0
c010227a:	6a 00                	push   $0x0
  pushl $132
c010227c:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102281:	e9 32 fb ff ff       	jmp    c0101db8 <__alltraps>

c0102286 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102286:	6a 00                	push   $0x0
  pushl $133
c0102288:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c010228d:	e9 26 fb ff ff       	jmp    c0101db8 <__alltraps>

c0102292 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102292:	6a 00                	push   $0x0
  pushl $134
c0102294:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102299:	e9 1a fb ff ff       	jmp    c0101db8 <__alltraps>

c010229e <vector135>:
.globl vector135
vector135:
  pushl $0
c010229e:	6a 00                	push   $0x0
  pushl $135
c01022a0:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01022a5:	e9 0e fb ff ff       	jmp    c0101db8 <__alltraps>

c01022aa <vector136>:
.globl vector136
vector136:
  pushl $0
c01022aa:	6a 00                	push   $0x0
  pushl $136
c01022ac:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01022b1:	e9 02 fb ff ff       	jmp    c0101db8 <__alltraps>

c01022b6 <vector137>:
.globl vector137
vector137:
  pushl $0
c01022b6:	6a 00                	push   $0x0
  pushl $137
c01022b8:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01022bd:	e9 f6 fa ff ff       	jmp    c0101db8 <__alltraps>

c01022c2 <vector138>:
.globl vector138
vector138:
  pushl $0
c01022c2:	6a 00                	push   $0x0
  pushl $138
c01022c4:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01022c9:	e9 ea fa ff ff       	jmp    c0101db8 <__alltraps>

c01022ce <vector139>:
.globl vector139
vector139:
  pushl $0
c01022ce:	6a 00                	push   $0x0
  pushl $139
c01022d0:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01022d5:	e9 de fa ff ff       	jmp    c0101db8 <__alltraps>

c01022da <vector140>:
.globl vector140
vector140:
  pushl $0
c01022da:	6a 00                	push   $0x0
  pushl $140
c01022dc:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01022e1:	e9 d2 fa ff ff       	jmp    c0101db8 <__alltraps>

c01022e6 <vector141>:
.globl vector141
vector141:
  pushl $0
c01022e6:	6a 00                	push   $0x0
  pushl $141
c01022e8:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01022ed:	e9 c6 fa ff ff       	jmp    c0101db8 <__alltraps>

c01022f2 <vector142>:
.globl vector142
vector142:
  pushl $0
c01022f2:	6a 00                	push   $0x0
  pushl $142
c01022f4:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01022f9:	e9 ba fa ff ff       	jmp    c0101db8 <__alltraps>

c01022fe <vector143>:
.globl vector143
vector143:
  pushl $0
c01022fe:	6a 00                	push   $0x0
  pushl $143
c0102300:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102305:	e9 ae fa ff ff       	jmp    c0101db8 <__alltraps>

c010230a <vector144>:
.globl vector144
vector144:
  pushl $0
c010230a:	6a 00                	push   $0x0
  pushl $144
c010230c:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102311:	e9 a2 fa ff ff       	jmp    c0101db8 <__alltraps>

c0102316 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102316:	6a 00                	push   $0x0
  pushl $145
c0102318:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c010231d:	e9 96 fa ff ff       	jmp    c0101db8 <__alltraps>

c0102322 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102322:	6a 00                	push   $0x0
  pushl $146
c0102324:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102329:	e9 8a fa ff ff       	jmp    c0101db8 <__alltraps>

c010232e <vector147>:
.globl vector147
vector147:
  pushl $0
c010232e:	6a 00                	push   $0x0
  pushl $147
c0102330:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102335:	e9 7e fa ff ff       	jmp    c0101db8 <__alltraps>

c010233a <vector148>:
.globl vector148
vector148:
  pushl $0
c010233a:	6a 00                	push   $0x0
  pushl $148
c010233c:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102341:	e9 72 fa ff ff       	jmp    c0101db8 <__alltraps>

c0102346 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102346:	6a 00                	push   $0x0
  pushl $149
c0102348:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c010234d:	e9 66 fa ff ff       	jmp    c0101db8 <__alltraps>

c0102352 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102352:	6a 00                	push   $0x0
  pushl $150
c0102354:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102359:	e9 5a fa ff ff       	jmp    c0101db8 <__alltraps>

c010235e <vector151>:
.globl vector151
vector151:
  pushl $0
c010235e:	6a 00                	push   $0x0
  pushl $151
c0102360:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102365:	e9 4e fa ff ff       	jmp    c0101db8 <__alltraps>

c010236a <vector152>:
.globl vector152
vector152:
  pushl $0
c010236a:	6a 00                	push   $0x0
  pushl $152
c010236c:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102371:	e9 42 fa ff ff       	jmp    c0101db8 <__alltraps>

c0102376 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102376:	6a 00                	push   $0x0
  pushl $153
c0102378:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c010237d:	e9 36 fa ff ff       	jmp    c0101db8 <__alltraps>

c0102382 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102382:	6a 00                	push   $0x0
  pushl $154
c0102384:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102389:	e9 2a fa ff ff       	jmp    c0101db8 <__alltraps>

c010238e <vector155>:
.globl vector155
vector155:
  pushl $0
c010238e:	6a 00                	push   $0x0
  pushl $155
c0102390:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102395:	e9 1e fa ff ff       	jmp    c0101db8 <__alltraps>

c010239a <vector156>:
.globl vector156
vector156:
  pushl $0
c010239a:	6a 00                	push   $0x0
  pushl $156
c010239c:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01023a1:	e9 12 fa ff ff       	jmp    c0101db8 <__alltraps>

c01023a6 <vector157>:
.globl vector157
vector157:
  pushl $0
c01023a6:	6a 00                	push   $0x0
  pushl $157
c01023a8:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01023ad:	e9 06 fa ff ff       	jmp    c0101db8 <__alltraps>

c01023b2 <vector158>:
.globl vector158
vector158:
  pushl $0
c01023b2:	6a 00                	push   $0x0
  pushl $158
c01023b4:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01023b9:	e9 fa f9 ff ff       	jmp    c0101db8 <__alltraps>

c01023be <vector159>:
.globl vector159
vector159:
  pushl $0
c01023be:	6a 00                	push   $0x0
  pushl $159
c01023c0:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01023c5:	e9 ee f9 ff ff       	jmp    c0101db8 <__alltraps>

c01023ca <vector160>:
.globl vector160
vector160:
  pushl $0
c01023ca:	6a 00                	push   $0x0
  pushl $160
c01023cc:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01023d1:	e9 e2 f9 ff ff       	jmp    c0101db8 <__alltraps>

c01023d6 <vector161>:
.globl vector161
vector161:
  pushl $0
c01023d6:	6a 00                	push   $0x0
  pushl $161
c01023d8:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01023dd:	e9 d6 f9 ff ff       	jmp    c0101db8 <__alltraps>

c01023e2 <vector162>:
.globl vector162
vector162:
  pushl $0
c01023e2:	6a 00                	push   $0x0
  pushl $162
c01023e4:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01023e9:	e9 ca f9 ff ff       	jmp    c0101db8 <__alltraps>

c01023ee <vector163>:
.globl vector163
vector163:
  pushl $0
c01023ee:	6a 00                	push   $0x0
  pushl $163
c01023f0:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01023f5:	e9 be f9 ff ff       	jmp    c0101db8 <__alltraps>

c01023fa <vector164>:
.globl vector164
vector164:
  pushl $0
c01023fa:	6a 00                	push   $0x0
  pushl $164
c01023fc:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102401:	e9 b2 f9 ff ff       	jmp    c0101db8 <__alltraps>

c0102406 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102406:	6a 00                	push   $0x0
  pushl $165
c0102408:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010240d:	e9 a6 f9 ff ff       	jmp    c0101db8 <__alltraps>

c0102412 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102412:	6a 00                	push   $0x0
  pushl $166
c0102414:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102419:	e9 9a f9 ff ff       	jmp    c0101db8 <__alltraps>

c010241e <vector167>:
.globl vector167
vector167:
  pushl $0
c010241e:	6a 00                	push   $0x0
  pushl $167
c0102420:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102425:	e9 8e f9 ff ff       	jmp    c0101db8 <__alltraps>

c010242a <vector168>:
.globl vector168
vector168:
  pushl $0
c010242a:	6a 00                	push   $0x0
  pushl $168
c010242c:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102431:	e9 82 f9 ff ff       	jmp    c0101db8 <__alltraps>

c0102436 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102436:	6a 00                	push   $0x0
  pushl $169
c0102438:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c010243d:	e9 76 f9 ff ff       	jmp    c0101db8 <__alltraps>

c0102442 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102442:	6a 00                	push   $0x0
  pushl $170
c0102444:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102449:	e9 6a f9 ff ff       	jmp    c0101db8 <__alltraps>

c010244e <vector171>:
.globl vector171
vector171:
  pushl $0
c010244e:	6a 00                	push   $0x0
  pushl $171
c0102450:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102455:	e9 5e f9 ff ff       	jmp    c0101db8 <__alltraps>

c010245a <vector172>:
.globl vector172
vector172:
  pushl $0
c010245a:	6a 00                	push   $0x0
  pushl $172
c010245c:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102461:	e9 52 f9 ff ff       	jmp    c0101db8 <__alltraps>

c0102466 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102466:	6a 00                	push   $0x0
  pushl $173
c0102468:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c010246d:	e9 46 f9 ff ff       	jmp    c0101db8 <__alltraps>

c0102472 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102472:	6a 00                	push   $0x0
  pushl $174
c0102474:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102479:	e9 3a f9 ff ff       	jmp    c0101db8 <__alltraps>

c010247e <vector175>:
.globl vector175
vector175:
  pushl $0
c010247e:	6a 00                	push   $0x0
  pushl $175
c0102480:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102485:	e9 2e f9 ff ff       	jmp    c0101db8 <__alltraps>

c010248a <vector176>:
.globl vector176
vector176:
  pushl $0
c010248a:	6a 00                	push   $0x0
  pushl $176
c010248c:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102491:	e9 22 f9 ff ff       	jmp    c0101db8 <__alltraps>

c0102496 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102496:	6a 00                	push   $0x0
  pushl $177
c0102498:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010249d:	e9 16 f9 ff ff       	jmp    c0101db8 <__alltraps>

c01024a2 <vector178>:
.globl vector178
vector178:
  pushl $0
c01024a2:	6a 00                	push   $0x0
  pushl $178
c01024a4:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01024a9:	e9 0a f9 ff ff       	jmp    c0101db8 <__alltraps>

c01024ae <vector179>:
.globl vector179
vector179:
  pushl $0
c01024ae:	6a 00                	push   $0x0
  pushl $179
c01024b0:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01024b5:	e9 fe f8 ff ff       	jmp    c0101db8 <__alltraps>

c01024ba <vector180>:
.globl vector180
vector180:
  pushl $0
c01024ba:	6a 00                	push   $0x0
  pushl $180
c01024bc:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01024c1:	e9 f2 f8 ff ff       	jmp    c0101db8 <__alltraps>

c01024c6 <vector181>:
.globl vector181
vector181:
  pushl $0
c01024c6:	6a 00                	push   $0x0
  pushl $181
c01024c8:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01024cd:	e9 e6 f8 ff ff       	jmp    c0101db8 <__alltraps>

c01024d2 <vector182>:
.globl vector182
vector182:
  pushl $0
c01024d2:	6a 00                	push   $0x0
  pushl $182
c01024d4:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01024d9:	e9 da f8 ff ff       	jmp    c0101db8 <__alltraps>

c01024de <vector183>:
.globl vector183
vector183:
  pushl $0
c01024de:	6a 00                	push   $0x0
  pushl $183
c01024e0:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01024e5:	e9 ce f8 ff ff       	jmp    c0101db8 <__alltraps>

c01024ea <vector184>:
.globl vector184
vector184:
  pushl $0
c01024ea:	6a 00                	push   $0x0
  pushl $184
c01024ec:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01024f1:	e9 c2 f8 ff ff       	jmp    c0101db8 <__alltraps>

c01024f6 <vector185>:
.globl vector185
vector185:
  pushl $0
c01024f6:	6a 00                	push   $0x0
  pushl $185
c01024f8:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01024fd:	e9 b6 f8 ff ff       	jmp    c0101db8 <__alltraps>

c0102502 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102502:	6a 00                	push   $0x0
  pushl $186
c0102504:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102509:	e9 aa f8 ff ff       	jmp    c0101db8 <__alltraps>

c010250e <vector187>:
.globl vector187
vector187:
  pushl $0
c010250e:	6a 00                	push   $0x0
  pushl $187
c0102510:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102515:	e9 9e f8 ff ff       	jmp    c0101db8 <__alltraps>

c010251a <vector188>:
.globl vector188
vector188:
  pushl $0
c010251a:	6a 00                	push   $0x0
  pushl $188
c010251c:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102521:	e9 92 f8 ff ff       	jmp    c0101db8 <__alltraps>

c0102526 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102526:	6a 00                	push   $0x0
  pushl $189
c0102528:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c010252d:	e9 86 f8 ff ff       	jmp    c0101db8 <__alltraps>

c0102532 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102532:	6a 00                	push   $0x0
  pushl $190
c0102534:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102539:	e9 7a f8 ff ff       	jmp    c0101db8 <__alltraps>

c010253e <vector191>:
.globl vector191
vector191:
  pushl $0
c010253e:	6a 00                	push   $0x0
  pushl $191
c0102540:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102545:	e9 6e f8 ff ff       	jmp    c0101db8 <__alltraps>

c010254a <vector192>:
.globl vector192
vector192:
  pushl $0
c010254a:	6a 00                	push   $0x0
  pushl $192
c010254c:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102551:	e9 62 f8 ff ff       	jmp    c0101db8 <__alltraps>

c0102556 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102556:	6a 00                	push   $0x0
  pushl $193
c0102558:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010255d:	e9 56 f8 ff ff       	jmp    c0101db8 <__alltraps>

c0102562 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102562:	6a 00                	push   $0x0
  pushl $194
c0102564:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102569:	e9 4a f8 ff ff       	jmp    c0101db8 <__alltraps>

c010256e <vector195>:
.globl vector195
vector195:
  pushl $0
c010256e:	6a 00                	push   $0x0
  pushl $195
c0102570:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102575:	e9 3e f8 ff ff       	jmp    c0101db8 <__alltraps>

c010257a <vector196>:
.globl vector196
vector196:
  pushl $0
c010257a:	6a 00                	push   $0x0
  pushl $196
c010257c:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102581:	e9 32 f8 ff ff       	jmp    c0101db8 <__alltraps>

c0102586 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102586:	6a 00                	push   $0x0
  pushl $197
c0102588:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c010258d:	e9 26 f8 ff ff       	jmp    c0101db8 <__alltraps>

c0102592 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102592:	6a 00                	push   $0x0
  pushl $198
c0102594:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102599:	e9 1a f8 ff ff       	jmp    c0101db8 <__alltraps>

c010259e <vector199>:
.globl vector199
vector199:
  pushl $0
c010259e:	6a 00                	push   $0x0
  pushl $199
c01025a0:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01025a5:	e9 0e f8 ff ff       	jmp    c0101db8 <__alltraps>

c01025aa <vector200>:
.globl vector200
vector200:
  pushl $0
c01025aa:	6a 00                	push   $0x0
  pushl $200
c01025ac:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01025b1:	e9 02 f8 ff ff       	jmp    c0101db8 <__alltraps>

c01025b6 <vector201>:
.globl vector201
vector201:
  pushl $0
c01025b6:	6a 00                	push   $0x0
  pushl $201
c01025b8:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01025bd:	e9 f6 f7 ff ff       	jmp    c0101db8 <__alltraps>

c01025c2 <vector202>:
.globl vector202
vector202:
  pushl $0
c01025c2:	6a 00                	push   $0x0
  pushl $202
c01025c4:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01025c9:	e9 ea f7 ff ff       	jmp    c0101db8 <__alltraps>

c01025ce <vector203>:
.globl vector203
vector203:
  pushl $0
c01025ce:	6a 00                	push   $0x0
  pushl $203
c01025d0:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01025d5:	e9 de f7 ff ff       	jmp    c0101db8 <__alltraps>

c01025da <vector204>:
.globl vector204
vector204:
  pushl $0
c01025da:	6a 00                	push   $0x0
  pushl $204
c01025dc:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01025e1:	e9 d2 f7 ff ff       	jmp    c0101db8 <__alltraps>

c01025e6 <vector205>:
.globl vector205
vector205:
  pushl $0
c01025e6:	6a 00                	push   $0x0
  pushl $205
c01025e8:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01025ed:	e9 c6 f7 ff ff       	jmp    c0101db8 <__alltraps>

c01025f2 <vector206>:
.globl vector206
vector206:
  pushl $0
c01025f2:	6a 00                	push   $0x0
  pushl $206
c01025f4:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01025f9:	e9 ba f7 ff ff       	jmp    c0101db8 <__alltraps>

c01025fe <vector207>:
.globl vector207
vector207:
  pushl $0
c01025fe:	6a 00                	push   $0x0
  pushl $207
c0102600:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102605:	e9 ae f7 ff ff       	jmp    c0101db8 <__alltraps>

c010260a <vector208>:
.globl vector208
vector208:
  pushl $0
c010260a:	6a 00                	push   $0x0
  pushl $208
c010260c:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102611:	e9 a2 f7 ff ff       	jmp    c0101db8 <__alltraps>

c0102616 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102616:	6a 00                	push   $0x0
  pushl $209
c0102618:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010261d:	e9 96 f7 ff ff       	jmp    c0101db8 <__alltraps>

c0102622 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102622:	6a 00                	push   $0x0
  pushl $210
c0102624:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102629:	e9 8a f7 ff ff       	jmp    c0101db8 <__alltraps>

c010262e <vector211>:
.globl vector211
vector211:
  pushl $0
c010262e:	6a 00                	push   $0x0
  pushl $211
c0102630:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102635:	e9 7e f7 ff ff       	jmp    c0101db8 <__alltraps>

c010263a <vector212>:
.globl vector212
vector212:
  pushl $0
c010263a:	6a 00                	push   $0x0
  pushl $212
c010263c:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102641:	e9 72 f7 ff ff       	jmp    c0101db8 <__alltraps>

c0102646 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102646:	6a 00                	push   $0x0
  pushl $213
c0102648:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010264d:	e9 66 f7 ff ff       	jmp    c0101db8 <__alltraps>

c0102652 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102652:	6a 00                	push   $0x0
  pushl $214
c0102654:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102659:	e9 5a f7 ff ff       	jmp    c0101db8 <__alltraps>

c010265e <vector215>:
.globl vector215
vector215:
  pushl $0
c010265e:	6a 00                	push   $0x0
  pushl $215
c0102660:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102665:	e9 4e f7 ff ff       	jmp    c0101db8 <__alltraps>

c010266a <vector216>:
.globl vector216
vector216:
  pushl $0
c010266a:	6a 00                	push   $0x0
  pushl $216
c010266c:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102671:	e9 42 f7 ff ff       	jmp    c0101db8 <__alltraps>

c0102676 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102676:	6a 00                	push   $0x0
  pushl $217
c0102678:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010267d:	e9 36 f7 ff ff       	jmp    c0101db8 <__alltraps>

c0102682 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102682:	6a 00                	push   $0x0
  pushl $218
c0102684:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102689:	e9 2a f7 ff ff       	jmp    c0101db8 <__alltraps>

c010268e <vector219>:
.globl vector219
vector219:
  pushl $0
c010268e:	6a 00                	push   $0x0
  pushl $219
c0102690:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102695:	e9 1e f7 ff ff       	jmp    c0101db8 <__alltraps>

c010269a <vector220>:
.globl vector220
vector220:
  pushl $0
c010269a:	6a 00                	push   $0x0
  pushl $220
c010269c:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01026a1:	e9 12 f7 ff ff       	jmp    c0101db8 <__alltraps>

c01026a6 <vector221>:
.globl vector221
vector221:
  pushl $0
c01026a6:	6a 00                	push   $0x0
  pushl $221
c01026a8:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01026ad:	e9 06 f7 ff ff       	jmp    c0101db8 <__alltraps>

c01026b2 <vector222>:
.globl vector222
vector222:
  pushl $0
c01026b2:	6a 00                	push   $0x0
  pushl $222
c01026b4:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01026b9:	e9 fa f6 ff ff       	jmp    c0101db8 <__alltraps>

c01026be <vector223>:
.globl vector223
vector223:
  pushl $0
c01026be:	6a 00                	push   $0x0
  pushl $223
c01026c0:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01026c5:	e9 ee f6 ff ff       	jmp    c0101db8 <__alltraps>

c01026ca <vector224>:
.globl vector224
vector224:
  pushl $0
c01026ca:	6a 00                	push   $0x0
  pushl $224
c01026cc:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01026d1:	e9 e2 f6 ff ff       	jmp    c0101db8 <__alltraps>

c01026d6 <vector225>:
.globl vector225
vector225:
  pushl $0
c01026d6:	6a 00                	push   $0x0
  pushl $225
c01026d8:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01026dd:	e9 d6 f6 ff ff       	jmp    c0101db8 <__alltraps>

c01026e2 <vector226>:
.globl vector226
vector226:
  pushl $0
c01026e2:	6a 00                	push   $0x0
  pushl $226
c01026e4:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01026e9:	e9 ca f6 ff ff       	jmp    c0101db8 <__alltraps>

c01026ee <vector227>:
.globl vector227
vector227:
  pushl $0
c01026ee:	6a 00                	push   $0x0
  pushl $227
c01026f0:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01026f5:	e9 be f6 ff ff       	jmp    c0101db8 <__alltraps>

c01026fa <vector228>:
.globl vector228
vector228:
  pushl $0
c01026fa:	6a 00                	push   $0x0
  pushl $228
c01026fc:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102701:	e9 b2 f6 ff ff       	jmp    c0101db8 <__alltraps>

c0102706 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102706:	6a 00                	push   $0x0
  pushl $229
c0102708:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010270d:	e9 a6 f6 ff ff       	jmp    c0101db8 <__alltraps>

c0102712 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102712:	6a 00                	push   $0x0
  pushl $230
c0102714:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102719:	e9 9a f6 ff ff       	jmp    c0101db8 <__alltraps>

c010271e <vector231>:
.globl vector231
vector231:
  pushl $0
c010271e:	6a 00                	push   $0x0
  pushl $231
c0102720:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102725:	e9 8e f6 ff ff       	jmp    c0101db8 <__alltraps>

c010272a <vector232>:
.globl vector232
vector232:
  pushl $0
c010272a:	6a 00                	push   $0x0
  pushl $232
c010272c:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102731:	e9 82 f6 ff ff       	jmp    c0101db8 <__alltraps>

c0102736 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102736:	6a 00                	push   $0x0
  pushl $233
c0102738:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c010273d:	e9 76 f6 ff ff       	jmp    c0101db8 <__alltraps>

c0102742 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102742:	6a 00                	push   $0x0
  pushl $234
c0102744:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102749:	e9 6a f6 ff ff       	jmp    c0101db8 <__alltraps>

c010274e <vector235>:
.globl vector235
vector235:
  pushl $0
c010274e:	6a 00                	push   $0x0
  pushl $235
c0102750:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102755:	e9 5e f6 ff ff       	jmp    c0101db8 <__alltraps>

c010275a <vector236>:
.globl vector236
vector236:
  pushl $0
c010275a:	6a 00                	push   $0x0
  pushl $236
c010275c:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102761:	e9 52 f6 ff ff       	jmp    c0101db8 <__alltraps>

c0102766 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102766:	6a 00                	push   $0x0
  pushl $237
c0102768:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010276d:	e9 46 f6 ff ff       	jmp    c0101db8 <__alltraps>

c0102772 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102772:	6a 00                	push   $0x0
  pushl $238
c0102774:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102779:	e9 3a f6 ff ff       	jmp    c0101db8 <__alltraps>

c010277e <vector239>:
.globl vector239
vector239:
  pushl $0
c010277e:	6a 00                	push   $0x0
  pushl $239
c0102780:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102785:	e9 2e f6 ff ff       	jmp    c0101db8 <__alltraps>

c010278a <vector240>:
.globl vector240
vector240:
  pushl $0
c010278a:	6a 00                	push   $0x0
  pushl $240
c010278c:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102791:	e9 22 f6 ff ff       	jmp    c0101db8 <__alltraps>

c0102796 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102796:	6a 00                	push   $0x0
  pushl $241
c0102798:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010279d:	e9 16 f6 ff ff       	jmp    c0101db8 <__alltraps>

c01027a2 <vector242>:
.globl vector242
vector242:
  pushl $0
c01027a2:	6a 00                	push   $0x0
  pushl $242
c01027a4:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01027a9:	e9 0a f6 ff ff       	jmp    c0101db8 <__alltraps>

c01027ae <vector243>:
.globl vector243
vector243:
  pushl $0
c01027ae:	6a 00                	push   $0x0
  pushl $243
c01027b0:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01027b5:	e9 fe f5 ff ff       	jmp    c0101db8 <__alltraps>

c01027ba <vector244>:
.globl vector244
vector244:
  pushl $0
c01027ba:	6a 00                	push   $0x0
  pushl $244
c01027bc:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01027c1:	e9 f2 f5 ff ff       	jmp    c0101db8 <__alltraps>

c01027c6 <vector245>:
.globl vector245
vector245:
  pushl $0
c01027c6:	6a 00                	push   $0x0
  pushl $245
c01027c8:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01027cd:	e9 e6 f5 ff ff       	jmp    c0101db8 <__alltraps>

c01027d2 <vector246>:
.globl vector246
vector246:
  pushl $0
c01027d2:	6a 00                	push   $0x0
  pushl $246
c01027d4:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01027d9:	e9 da f5 ff ff       	jmp    c0101db8 <__alltraps>

c01027de <vector247>:
.globl vector247
vector247:
  pushl $0
c01027de:	6a 00                	push   $0x0
  pushl $247
c01027e0:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01027e5:	e9 ce f5 ff ff       	jmp    c0101db8 <__alltraps>

c01027ea <vector248>:
.globl vector248
vector248:
  pushl $0
c01027ea:	6a 00                	push   $0x0
  pushl $248
c01027ec:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01027f1:	e9 c2 f5 ff ff       	jmp    c0101db8 <__alltraps>

c01027f6 <vector249>:
.globl vector249
vector249:
  pushl $0
c01027f6:	6a 00                	push   $0x0
  pushl $249
c01027f8:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01027fd:	e9 b6 f5 ff ff       	jmp    c0101db8 <__alltraps>

c0102802 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102802:	6a 00                	push   $0x0
  pushl $250
c0102804:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102809:	e9 aa f5 ff ff       	jmp    c0101db8 <__alltraps>

c010280e <vector251>:
.globl vector251
vector251:
  pushl $0
c010280e:	6a 00                	push   $0x0
  pushl $251
c0102810:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102815:	e9 9e f5 ff ff       	jmp    c0101db8 <__alltraps>

c010281a <vector252>:
.globl vector252
vector252:
  pushl $0
c010281a:	6a 00                	push   $0x0
  pushl $252
c010281c:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102821:	e9 92 f5 ff ff       	jmp    c0101db8 <__alltraps>

c0102826 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102826:	6a 00                	push   $0x0
  pushl $253
c0102828:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010282d:	e9 86 f5 ff ff       	jmp    c0101db8 <__alltraps>

c0102832 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102832:	6a 00                	push   $0x0
  pushl $254
c0102834:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102839:	e9 7a f5 ff ff       	jmp    c0101db8 <__alltraps>

c010283e <vector255>:
.globl vector255
vector255:
  pushl $0
c010283e:	6a 00                	push   $0x0
  pushl $255
c0102840:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102845:	e9 6e f5 ff ff       	jmp    c0101db8 <__alltraps>

c010284a <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010284a:	55                   	push   %ebp
c010284b:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010284d:	8b 55 08             	mov    0x8(%ebp),%edx
c0102850:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0102855:	29 c2                	sub    %eax,%edx
c0102857:	89 d0                	mov    %edx,%eax
c0102859:	c1 f8 02             	sar    $0x2,%eax
c010285c:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102862:	5d                   	pop    %ebp
c0102863:	c3                   	ret    

c0102864 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102864:	55                   	push   %ebp
c0102865:	89 e5                	mov    %esp,%ebp
c0102867:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010286a:	8b 45 08             	mov    0x8(%ebp),%eax
c010286d:	89 04 24             	mov    %eax,(%esp)
c0102870:	e8 d5 ff ff ff       	call   c010284a <page2ppn>
c0102875:	c1 e0 0c             	shl    $0xc,%eax
}
c0102878:	c9                   	leave  
c0102879:	c3                   	ret    

c010287a <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010287a:	55                   	push   %ebp
c010287b:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010287d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102880:	8b 00                	mov    (%eax),%eax
}
c0102882:	5d                   	pop    %ebp
c0102883:	c3                   	ret    

c0102884 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102884:	55                   	push   %ebp
c0102885:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102887:	8b 45 08             	mov    0x8(%ebp),%eax
c010288a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010288d:	89 10                	mov    %edx,(%eax)
}
c010288f:	5d                   	pop    %ebp
c0102890:	c3                   	ret    

c0102891 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0102891:	55                   	push   %ebp
c0102892:	89 e5                	mov    %esp,%ebp
c0102894:	83 ec 10             	sub    $0x10,%esp
c0102897:	c7 45 fc 10 af 11 c0 	movl   $0xc011af10,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010289e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01028a4:	89 50 04             	mov    %edx,0x4(%eax)
c01028a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028aa:	8b 50 04             	mov    0x4(%eax),%edx
c01028ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028b0:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01028b2:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c01028b9:	00 00 00 
}
c01028bc:	c9                   	leave  
c01028bd:	c3                   	ret    

c01028be <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01028be:	55                   	push   %ebp
c01028bf:	89 e5                	mov    %esp,%ebp
c01028c1:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c01028c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01028c8:	75 24                	jne    c01028ee <default_init_memmap+0x30>
c01028ca:	c7 44 24 0c b0 66 10 	movl   $0xc01066b0,0xc(%esp)
c01028d1:	c0 
c01028d2:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01028d9:	c0 
c01028da:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01028e1:	00 
c01028e2:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01028e9:	e8 e4 e3 ff ff       	call   c0100cd2 <__panic>
    struct Page *p = base;
c01028ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01028f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01028f4:	eb 7d                	jmp    c0102973 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c01028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028f9:	83 c0 04             	add    $0x4,%eax
c01028fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102903:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102906:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102909:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010290c:	0f a3 10             	bt     %edx,(%eax)
c010290f:	19 c0                	sbb    %eax,%eax
c0102911:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102914:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102918:	0f 95 c0             	setne  %al
c010291b:	0f b6 c0             	movzbl %al,%eax
c010291e:	85 c0                	test   %eax,%eax
c0102920:	75 24                	jne    c0102946 <default_init_memmap+0x88>
c0102922:	c7 44 24 0c e1 66 10 	movl   $0xc01066e1,0xc(%esp)
c0102929:	c0 
c010292a:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102931:	c0 
c0102932:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0102939:	00 
c010293a:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102941:	e8 8c e3 ff ff       	call   c0100cd2 <__panic>
        p->flags = p->property = 0;
c0102946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102949:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102950:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102953:	8b 50 08             	mov    0x8(%eax),%edx
c0102956:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102959:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c010295c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102963:	00 
c0102964:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102967:	89 04 24             	mov    %eax,(%esp)
c010296a:	e8 15 ff ff ff       	call   c0102884 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c010296f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102973:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102976:	89 d0                	mov    %edx,%eax
c0102978:	c1 e0 02             	shl    $0x2,%eax
c010297b:	01 d0                	add    %edx,%eax
c010297d:	c1 e0 02             	shl    $0x2,%eax
c0102980:	89 c2                	mov    %eax,%edx
c0102982:	8b 45 08             	mov    0x8(%ebp),%eax
c0102985:	01 d0                	add    %edx,%eax
c0102987:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010298a:	0f 85 66 ff ff ff    	jne    c01028f6 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102990:	8b 45 08             	mov    0x8(%ebp),%eax
c0102993:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102996:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102999:	8b 45 08             	mov    0x8(%ebp),%eax
c010299c:	83 c0 04             	add    $0x4,%eax
c010299f:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01029a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01029a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01029ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01029af:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c01029b2:	8b 15 18 af 11 c0    	mov    0xc011af18,%edx
c01029b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01029bb:	01 d0                	add    %edx,%eax
c01029bd:	a3 18 af 11 c0       	mov    %eax,0xc011af18
    list_add_before(&free_list, &(base->page_link));
c01029c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01029c5:	83 c0 0c             	add    $0xc,%eax
c01029c8:	c7 45 dc 10 af 11 c0 	movl   $0xc011af10,-0x24(%ebp)
c01029cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01029d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01029d5:	8b 00                	mov    (%eax),%eax
c01029d7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01029da:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01029dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01029e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01029e3:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01029e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01029e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01029ec:	89 10                	mov    %edx,(%eax)
c01029ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01029f1:	8b 10                	mov    (%eax),%edx
c01029f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01029f6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01029f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01029fc:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01029ff:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a05:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102a08:	89 10                	mov    %edx,(%eax)
}
c0102a0a:	c9                   	leave  
c0102a0b:	c3                   	ret    

c0102a0c <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102a0c:	55                   	push   %ebp
c0102a0d:	89 e5                	mov    %esp,%ebp
c0102a0f:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102a12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102a16:	75 24                	jne    c0102a3c <default_alloc_pages+0x30>
c0102a18:	c7 44 24 0c b0 66 10 	movl   $0xc01066b0,0xc(%esp)
c0102a1f:	c0 
c0102a20:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102a27:	c0 
c0102a28:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c0102a2f:	00 
c0102a30:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102a37:	e8 96 e2 ff ff       	call   c0100cd2 <__panic>
    if (n > nr_free) {
c0102a3c:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0102a41:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a44:	73 0a                	jae    c0102a50 <default_alloc_pages+0x44>
        return NULL;
c0102a46:	b8 00 00 00 00       	mov    $0x0,%eax
c0102a4b:	e9 3d 01 00 00       	jmp    c0102b8d <default_alloc_pages+0x181>
    }
    struct Page *page = NULL;
c0102a50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102a57:	c7 45 f0 10 af 11 c0 	movl   $0xc011af10,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c0102a5e:	eb 1c                	jmp    c0102a7c <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a63:	83 e8 0c             	sub    $0xc,%eax
c0102a66:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0102a69:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a6c:	8b 40 08             	mov    0x8(%eax),%eax
c0102a6f:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a72:	72 08                	jb     c0102a7c <default_alloc_pages+0x70>
            page = p;
c0102a74:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102a7a:	eb 18                	jmp    c0102a94 <default_alloc_pages+0x88>
c0102a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102a82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102a85:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c0102a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102a8b:	81 7d f0 10 af 11 c0 	cmpl   $0xc011af10,-0x10(%ebp)
c0102a92:	75 cc                	jne    c0102a60 <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0102a94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102a98:	0f 84 ec 00 00 00    	je     c0102b8a <default_alloc_pages+0x17e>
        if (page->property > n) {
c0102a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aa1:	8b 40 08             	mov    0x8(%eax),%eax
c0102aa4:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102aa7:	0f 86 8c 00 00 00    	jbe    c0102b39 <default_alloc_pages+0x12d>
            struct Page *p = page + n;
c0102aad:	8b 55 08             	mov    0x8(%ebp),%edx
c0102ab0:	89 d0                	mov    %edx,%eax
c0102ab2:	c1 e0 02             	shl    $0x2,%eax
c0102ab5:	01 d0                	add    %edx,%eax
c0102ab7:	c1 e0 02             	shl    $0x2,%eax
c0102aba:	89 c2                	mov    %eax,%edx
c0102abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102abf:	01 d0                	add    %edx,%eax
c0102ac1:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0102ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ac7:	8b 40 08             	mov    0x8(%eax),%eax
c0102aca:	2b 45 08             	sub    0x8(%ebp),%eax
c0102acd:	89 c2                	mov    %eax,%edx
c0102acf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ad2:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0102ad5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ad8:	83 c0 04             	add    $0x4,%eax
c0102adb:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102ae2:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102ae5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102ae8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102aeb:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c0102aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102af1:	83 c0 0c             	add    $0xc,%eax
c0102af4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102af7:	83 c2 0c             	add    $0xc,%edx
c0102afa:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0102afd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102b00:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b03:	8b 40 04             	mov    0x4(%eax),%eax
c0102b06:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102b09:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0102b0c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102b0f:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102b12:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102b15:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b18:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102b1b:	89 10                	mov    %edx,(%eax)
c0102b1d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b20:	8b 10                	mov    (%eax),%edx
c0102b22:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b25:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102b28:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b2b:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102b2e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102b31:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b34:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102b37:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c0102b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b3c:	83 c0 0c             	add    $0xc,%eax
c0102b3f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102b42:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b45:	8b 40 04             	mov    0x4(%eax),%eax
c0102b48:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b4b:	8b 12                	mov    (%edx),%edx
c0102b4d:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102b50:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b53:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102b56:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102b59:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b5c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b5f:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102b62:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c0102b64:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0102b69:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b6c:	a3 18 af 11 c0       	mov    %eax,0xc011af18
        ClearPageProperty(page);
c0102b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b74:	83 c0 04             	add    $0x4,%eax
c0102b77:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102b7e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b81:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102b84:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102b87:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0102b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102b8d:	c9                   	leave  
c0102b8e:	c3                   	ret    

c0102b8f <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102b8f:	55                   	push   %ebp
c0102b90:	89 e5                	mov    %esp,%ebp
c0102b92:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0102b98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102b9c:	75 24                	jne    c0102bc2 <default_free_pages+0x33>
c0102b9e:	c7 44 24 0c b0 66 10 	movl   $0xc01066b0,0xc(%esp)
c0102ba5:	c0 
c0102ba6:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102bad:	c0 
c0102bae:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0102bb5:	00 
c0102bb6:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102bbd:	e8 10 e1 ff ff       	call   c0100cd2 <__panic>
    struct Page *p = base;
c0102bc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102bc8:	e9 9d 00 00 00       	jmp    c0102c6a <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0102bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bd0:	83 c0 04             	add    $0x4,%eax
c0102bd3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102bda:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102bdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102be0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102be3:	0f a3 10             	bt     %edx,(%eax)
c0102be6:	19 c0                	sbb    %eax,%eax
c0102be8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102beb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102bef:	0f 95 c0             	setne  %al
c0102bf2:	0f b6 c0             	movzbl %al,%eax
c0102bf5:	85 c0                	test   %eax,%eax
c0102bf7:	75 2c                	jne    c0102c25 <default_free_pages+0x96>
c0102bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bfc:	83 c0 04             	add    $0x4,%eax
c0102bff:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102c06:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c09:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102c0f:	0f a3 10             	bt     %edx,(%eax)
c0102c12:	19 c0                	sbb    %eax,%eax
c0102c14:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102c17:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102c1b:	0f 95 c0             	setne  %al
c0102c1e:	0f b6 c0             	movzbl %al,%eax
c0102c21:	85 c0                	test   %eax,%eax
c0102c23:	74 24                	je     c0102c49 <default_free_pages+0xba>
c0102c25:	c7 44 24 0c f4 66 10 	movl   $0xc01066f4,0xc(%esp)
c0102c2c:	c0 
c0102c2d:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102c34:	c0 
c0102c35:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
c0102c3c:	00 
c0102c3d:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102c44:	e8 89 e0 ff ff       	call   c0100cd2 <__panic>
        p->flags = 0;
c0102c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102c53:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102c5a:	00 
c0102c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c5e:	89 04 24             	mov    %eax,(%esp)
c0102c61:	e8 1e fc ff ff       	call   c0102884 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102c66:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102c6a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c6d:	89 d0                	mov    %edx,%eax
c0102c6f:	c1 e0 02             	shl    $0x2,%eax
c0102c72:	01 d0                	add    %edx,%eax
c0102c74:	c1 e0 02             	shl    $0x2,%eax
c0102c77:	89 c2                	mov    %eax,%edx
c0102c79:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c7c:	01 d0                	add    %edx,%eax
c0102c7e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102c81:	0f 85 46 ff ff ff    	jne    c0102bcd <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102c87:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c8a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c8d:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102c90:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c93:	83 c0 04             	add    $0x4,%eax
c0102c96:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102c9d:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102ca0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102ca3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ca6:	0f ab 10             	bts    %edx,(%eax)
c0102ca9:	c7 45 cc 10 af 11 c0 	movl   $0xc011af10,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102cb0:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102cb3:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102cb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102cb9:	e9 08 01 00 00       	jmp    c0102dc6 <default_free_pages+0x237>
        p = le2page(le, page_link);
c0102cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cc1:	83 e8 0c             	sub    $0xc,%eax
c0102cc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cca:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102ccd:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102cd0:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102cd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
c0102cd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cd9:	8b 50 08             	mov    0x8(%eax),%edx
c0102cdc:	89 d0                	mov    %edx,%eax
c0102cde:	c1 e0 02             	shl    $0x2,%eax
c0102ce1:	01 d0                	add    %edx,%eax
c0102ce3:	c1 e0 02             	shl    $0x2,%eax
c0102ce6:	89 c2                	mov    %eax,%edx
c0102ce8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ceb:	01 d0                	add    %edx,%eax
c0102ced:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102cf0:	75 5a                	jne    c0102d4c <default_free_pages+0x1bd>
            base->property += p->property;
c0102cf2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cf5:	8b 50 08             	mov    0x8(%eax),%edx
c0102cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cfb:	8b 40 08             	mov    0x8(%eax),%eax
c0102cfe:	01 c2                	add    %eax,%edx
c0102d00:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d03:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d09:	83 c0 04             	add    $0x4,%eax
c0102d0c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102d13:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d16:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d19:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102d1c:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0102d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d22:	83 c0 0c             	add    $0xc,%eax
c0102d25:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102d28:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d2b:	8b 40 04             	mov    0x4(%eax),%eax
c0102d2e:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102d31:	8b 12                	mov    (%edx),%edx
c0102d33:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102d36:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102d39:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102d3c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102d3f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102d42:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102d45:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102d48:	89 10                	mov    %edx,(%eax)
c0102d4a:	eb 7a                	jmp    c0102dc6 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c0102d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d4f:	8b 50 08             	mov    0x8(%eax),%edx
c0102d52:	89 d0                	mov    %edx,%eax
c0102d54:	c1 e0 02             	shl    $0x2,%eax
c0102d57:	01 d0                	add    %edx,%eax
c0102d59:	c1 e0 02             	shl    $0x2,%eax
c0102d5c:	89 c2                	mov    %eax,%edx
c0102d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d61:	01 d0                	add    %edx,%eax
c0102d63:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102d66:	75 5e                	jne    c0102dc6 <default_free_pages+0x237>
            p->property += base->property;
c0102d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d6b:	8b 50 08             	mov    0x8(%eax),%edx
c0102d6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d71:	8b 40 08             	mov    0x8(%eax),%eax
c0102d74:	01 c2                	add    %eax,%edx
c0102d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d79:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102d7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d7f:	83 c0 04             	add    $0x4,%eax
c0102d82:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0102d89:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0102d8c:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102d8f:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102d92:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0102d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d98:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d9e:	83 c0 0c             	add    $0xc,%eax
c0102da1:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102da4:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102da7:	8b 40 04             	mov    0x4(%eax),%eax
c0102daa:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102dad:	8b 12                	mov    (%edx),%edx
c0102daf:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102db2:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102db5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102db8:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102dbb:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102dbe:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102dc1:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102dc4:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c0102dc6:	81 7d f0 10 af 11 c0 	cmpl   $0xc011af10,-0x10(%ebp)
c0102dcd:	0f 85 eb fe ff ff    	jne    c0102cbe <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
c0102dd3:	8b 15 18 af 11 c0    	mov    0xc011af18,%edx
c0102dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102ddc:	01 d0                	add    %edx,%eax
c0102dde:	a3 18 af 11 c0       	mov    %eax,0xc011af18
c0102de3:	c7 45 9c 10 af 11 c0 	movl   $0xc011af10,-0x64(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102dea:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102ded:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0102df0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102df3:	eb 76                	jmp    c0102e6b <default_free_pages+0x2dc>
        p = le2page(le, page_link);
c0102df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102df8:	83 e8 0c             	sub    $0xc,%eax
c0102dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c0102dfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e01:	8b 50 08             	mov    0x8(%eax),%edx
c0102e04:	89 d0                	mov    %edx,%eax
c0102e06:	c1 e0 02             	shl    $0x2,%eax
c0102e09:	01 d0                	add    %edx,%eax
c0102e0b:	c1 e0 02             	shl    $0x2,%eax
c0102e0e:	89 c2                	mov    %eax,%edx
c0102e10:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e13:	01 d0                	add    %edx,%eax
c0102e15:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102e18:	77 42                	ja     c0102e5c <default_free_pages+0x2cd>
            assert(base + base->property != p);
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
c0102e34:	75 24                	jne    c0102e5a <default_free_pages+0x2cb>
c0102e36:	c7 44 24 0c 19 67 10 	movl   $0xc0106719,0xc(%esp)
c0102e3d:	c0 
c0102e3e:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102e45:	c0 
c0102e46:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0102e4d:	00 
c0102e4e:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102e55:	e8 78 de ff ff       	call   c0100cd2 <__panic>
            break;
c0102e5a:	eb 18                	jmp    c0102e74 <default_free_pages+0x2e5>
c0102e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e5f:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102e62:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e65:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
c0102e68:	89 45 f0             	mov    %eax,-0x10(%ebp)
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
    le = list_next(&free_list);
    while (le != &free_list) {
c0102e6b:	81 7d f0 10 af 11 c0 	cmpl   $0xc011af10,-0x10(%ebp)
c0102e72:	75 81                	jne    c0102df5 <default_free_pages+0x266>
            assert(base + base->property != p);
            break;
        }
        le = list_next(le);
    }
    list_add_before(le, &(base->page_link));
c0102e74:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e77:	8d 50 0c             	lea    0xc(%eax),%edx
c0102e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e7d:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102e80:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102e83:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102e86:	8b 00                	mov    (%eax),%eax
c0102e88:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102e8b:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0102e8e:	89 45 88             	mov    %eax,-0x78(%ebp)
c0102e91:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102e94:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102e97:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102e9a:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102e9d:	89 10                	mov    %edx,(%eax)
c0102e9f:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102ea2:	8b 10                	mov    (%eax),%edx
c0102ea4:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102ea7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102eaa:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102ead:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102eb0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102eb3:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102eb6:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102eb9:	89 10                	mov    %edx,(%eax)
}
c0102ebb:	c9                   	leave  
c0102ebc:	c3                   	ret    

c0102ebd <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102ebd:	55                   	push   %ebp
c0102ebe:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102ec0:	a1 18 af 11 c0       	mov    0xc011af18,%eax
}
c0102ec5:	5d                   	pop    %ebp
c0102ec6:	c3                   	ret    

c0102ec7 <basic_check>:

static void
basic_check(void) {
c0102ec7:	55                   	push   %ebp
c0102ec8:	89 e5                	mov    %esp,%ebp
c0102eca:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102ecd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ed7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102edd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102ee0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ee7:	e8 9d 0e 00 00       	call   c0103d89 <alloc_pages>
c0102eec:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102eef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102ef3:	75 24                	jne    c0102f19 <basic_check+0x52>
c0102ef5:	c7 44 24 0c 34 67 10 	movl   $0xc0106734,0xc(%esp)
c0102efc:	c0 
c0102efd:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102f04:	c0 
c0102f05:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0102f0c:	00 
c0102f0d:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102f14:	e8 b9 dd ff ff       	call   c0100cd2 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102f19:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f20:	e8 64 0e 00 00       	call   c0103d89 <alloc_pages>
c0102f25:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102f2c:	75 24                	jne    c0102f52 <basic_check+0x8b>
c0102f2e:	c7 44 24 0c 50 67 10 	movl   $0xc0106750,0xc(%esp)
c0102f35:	c0 
c0102f36:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102f3d:	c0 
c0102f3e:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0102f45:	00 
c0102f46:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102f4d:	e8 80 dd ff ff       	call   c0100cd2 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102f52:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f59:	e8 2b 0e 00 00       	call   c0103d89 <alloc_pages>
c0102f5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102f65:	75 24                	jne    c0102f8b <basic_check+0xc4>
c0102f67:	c7 44 24 0c 6c 67 10 	movl   $0xc010676c,0xc(%esp)
c0102f6e:	c0 
c0102f6f:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102f76:	c0 
c0102f77:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0102f7e:	00 
c0102f7f:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102f86:	e8 47 dd ff ff       	call   c0100cd2 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102f8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f8e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102f91:	74 10                	je     c0102fa3 <basic_check+0xdc>
c0102f93:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f96:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f99:	74 08                	je     c0102fa3 <basic_check+0xdc>
c0102f9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f9e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102fa1:	75 24                	jne    c0102fc7 <basic_check+0x100>
c0102fa3:	c7 44 24 0c 88 67 10 	movl   $0xc0106788,0xc(%esp)
c0102faa:	c0 
c0102fab:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102fb2:	c0 
c0102fb3:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0102fba:	00 
c0102fbb:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102fc2:	e8 0b dd ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102fc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fca:	89 04 24             	mov    %eax,(%esp)
c0102fcd:	e8 a8 f8 ff ff       	call   c010287a <page_ref>
c0102fd2:	85 c0                	test   %eax,%eax
c0102fd4:	75 1e                	jne    c0102ff4 <basic_check+0x12d>
c0102fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fd9:	89 04 24             	mov    %eax,(%esp)
c0102fdc:	e8 99 f8 ff ff       	call   c010287a <page_ref>
c0102fe1:	85 c0                	test   %eax,%eax
c0102fe3:	75 0f                	jne    c0102ff4 <basic_check+0x12d>
c0102fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fe8:	89 04 24             	mov    %eax,(%esp)
c0102feb:	e8 8a f8 ff ff       	call   c010287a <page_ref>
c0102ff0:	85 c0                	test   %eax,%eax
c0102ff2:	74 24                	je     c0103018 <basic_check+0x151>
c0102ff4:	c7 44 24 0c ac 67 10 	movl   $0xc01067ac,0xc(%esp)
c0102ffb:	c0 
c0102ffc:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103003:	c0 
c0103004:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c010300b:	00 
c010300c:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103013:	e8 ba dc ff ff       	call   c0100cd2 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103018:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010301b:	89 04 24             	mov    %eax,(%esp)
c010301e:	e8 41 f8 ff ff       	call   c0102864 <page2pa>
c0103023:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0103029:	c1 e2 0c             	shl    $0xc,%edx
c010302c:	39 d0                	cmp    %edx,%eax
c010302e:	72 24                	jb     c0103054 <basic_check+0x18d>
c0103030:	c7 44 24 0c e8 67 10 	movl   $0xc01067e8,0xc(%esp)
c0103037:	c0 
c0103038:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010303f:	c0 
c0103040:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103047:	00 
c0103048:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010304f:	e8 7e dc ff ff       	call   c0100cd2 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103054:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103057:	89 04 24             	mov    %eax,(%esp)
c010305a:	e8 05 f8 ff ff       	call   c0102864 <page2pa>
c010305f:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0103065:	c1 e2 0c             	shl    $0xc,%edx
c0103068:	39 d0                	cmp    %edx,%eax
c010306a:	72 24                	jb     c0103090 <basic_check+0x1c9>
c010306c:	c7 44 24 0c 05 68 10 	movl   $0xc0106805,0xc(%esp)
c0103073:	c0 
c0103074:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010307b:	c0 
c010307c:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0103083:	00 
c0103084:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010308b:	e8 42 dc ff ff       	call   c0100cd2 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103090:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103093:	89 04 24             	mov    %eax,(%esp)
c0103096:	e8 c9 f7 ff ff       	call   c0102864 <page2pa>
c010309b:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c01030a1:	c1 e2 0c             	shl    $0xc,%edx
c01030a4:	39 d0                	cmp    %edx,%eax
c01030a6:	72 24                	jb     c01030cc <basic_check+0x205>
c01030a8:	c7 44 24 0c 22 68 10 	movl   $0xc0106822,0xc(%esp)
c01030af:	c0 
c01030b0:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01030b7:	c0 
c01030b8:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c01030bf:	00 
c01030c0:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01030c7:	e8 06 dc ff ff       	call   c0100cd2 <__panic>

    list_entry_t free_list_store = free_list;
c01030cc:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c01030d1:	8b 15 14 af 11 c0    	mov    0xc011af14,%edx
c01030d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01030da:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01030dd:	c7 45 e0 10 af 11 c0 	movl   $0xc011af10,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01030e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01030ea:	89 50 04             	mov    %edx,0x4(%eax)
c01030ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030f0:	8b 50 04             	mov    0x4(%eax),%edx
c01030f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030f6:	89 10                	mov    %edx,(%eax)
c01030f8:	c7 45 dc 10 af 11 c0 	movl   $0xc011af10,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01030ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103102:	8b 40 04             	mov    0x4(%eax),%eax
c0103105:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103108:	0f 94 c0             	sete   %al
c010310b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010310e:	85 c0                	test   %eax,%eax
c0103110:	75 24                	jne    c0103136 <basic_check+0x26f>
c0103112:	c7 44 24 0c 3f 68 10 	movl   $0xc010683f,0xc(%esp)
c0103119:	c0 
c010311a:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103121:	c0 
c0103122:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103129:	00 
c010312a:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103131:	e8 9c db ff ff       	call   c0100cd2 <__panic>

    unsigned int nr_free_store = nr_free;
c0103136:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c010313b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c010313e:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c0103145:	00 00 00 

    assert(alloc_page() == NULL);
c0103148:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010314f:	e8 35 0c 00 00       	call   c0103d89 <alloc_pages>
c0103154:	85 c0                	test   %eax,%eax
c0103156:	74 24                	je     c010317c <basic_check+0x2b5>
c0103158:	c7 44 24 0c 56 68 10 	movl   $0xc0106856,0xc(%esp)
c010315f:	c0 
c0103160:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103167:	c0 
c0103168:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c010316f:	00 
c0103170:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103177:	e8 56 db ff ff       	call   c0100cd2 <__panic>

    free_page(p0);
c010317c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103183:	00 
c0103184:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103187:	89 04 24             	mov    %eax,(%esp)
c010318a:	e8 32 0c 00 00       	call   c0103dc1 <free_pages>
    free_page(p1);
c010318f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103196:	00 
c0103197:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010319a:	89 04 24             	mov    %eax,(%esp)
c010319d:	e8 1f 0c 00 00       	call   c0103dc1 <free_pages>
    free_page(p2);
c01031a2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01031a9:	00 
c01031aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031ad:	89 04 24             	mov    %eax,(%esp)
c01031b0:	e8 0c 0c 00 00       	call   c0103dc1 <free_pages>
    assert(nr_free == 3);
c01031b5:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c01031ba:	83 f8 03             	cmp    $0x3,%eax
c01031bd:	74 24                	je     c01031e3 <basic_check+0x31c>
c01031bf:	c7 44 24 0c 6b 68 10 	movl   $0xc010686b,0xc(%esp)
c01031c6:	c0 
c01031c7:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01031ce:	c0 
c01031cf:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c01031d6:	00 
c01031d7:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01031de:	e8 ef da ff ff       	call   c0100cd2 <__panic>

    assert((p0 = alloc_page()) != NULL);
c01031e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031ea:	e8 9a 0b 00 00       	call   c0103d89 <alloc_pages>
c01031ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01031f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01031f6:	75 24                	jne    c010321c <basic_check+0x355>
c01031f8:	c7 44 24 0c 34 67 10 	movl   $0xc0106734,0xc(%esp)
c01031ff:	c0 
c0103200:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103207:	c0 
c0103208:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c010320f:	00 
c0103210:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103217:	e8 b6 da ff ff       	call   c0100cd2 <__panic>
    assert((p1 = alloc_page()) != NULL);
c010321c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103223:	e8 61 0b 00 00       	call   c0103d89 <alloc_pages>
c0103228:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010322b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010322f:	75 24                	jne    c0103255 <basic_check+0x38e>
c0103231:	c7 44 24 0c 50 67 10 	movl   $0xc0106750,0xc(%esp)
c0103238:	c0 
c0103239:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103240:	c0 
c0103241:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103248:	00 
c0103249:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103250:	e8 7d da ff ff       	call   c0100cd2 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103255:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010325c:	e8 28 0b 00 00       	call   c0103d89 <alloc_pages>
c0103261:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103264:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103268:	75 24                	jne    c010328e <basic_check+0x3c7>
c010326a:	c7 44 24 0c 6c 67 10 	movl   $0xc010676c,0xc(%esp)
c0103271:	c0 
c0103272:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103279:	c0 
c010327a:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0103281:	00 
c0103282:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103289:	e8 44 da ff ff       	call   c0100cd2 <__panic>

    assert(alloc_page() == NULL);
c010328e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103295:	e8 ef 0a 00 00       	call   c0103d89 <alloc_pages>
c010329a:	85 c0                	test   %eax,%eax
c010329c:	74 24                	je     c01032c2 <basic_check+0x3fb>
c010329e:	c7 44 24 0c 56 68 10 	movl   $0xc0106856,0xc(%esp)
c01032a5:	c0 
c01032a6:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01032ad:	c0 
c01032ae:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c01032b5:	00 
c01032b6:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01032bd:	e8 10 da ff ff       	call   c0100cd2 <__panic>

    free_page(p0);
c01032c2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032c9:	00 
c01032ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032cd:	89 04 24             	mov    %eax,(%esp)
c01032d0:	e8 ec 0a 00 00       	call   c0103dc1 <free_pages>
c01032d5:	c7 45 d8 10 af 11 c0 	movl   $0xc011af10,-0x28(%ebp)
c01032dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01032df:	8b 40 04             	mov    0x4(%eax),%eax
c01032e2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01032e5:	0f 94 c0             	sete   %al
c01032e8:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01032eb:	85 c0                	test   %eax,%eax
c01032ed:	74 24                	je     c0103313 <basic_check+0x44c>
c01032ef:	c7 44 24 0c 78 68 10 	movl   $0xc0106878,0xc(%esp)
c01032f6:	c0 
c01032f7:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01032fe:	c0 
c01032ff:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0103306:	00 
c0103307:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010330e:	e8 bf d9 ff ff       	call   c0100cd2 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103313:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010331a:	e8 6a 0a 00 00       	call   c0103d89 <alloc_pages>
c010331f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103322:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103325:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103328:	74 24                	je     c010334e <basic_check+0x487>
c010332a:	c7 44 24 0c 90 68 10 	movl   $0xc0106890,0xc(%esp)
c0103331:	c0 
c0103332:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103339:	c0 
c010333a:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0103341:	00 
c0103342:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103349:	e8 84 d9 ff ff       	call   c0100cd2 <__panic>
    assert(alloc_page() == NULL);
c010334e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103355:	e8 2f 0a 00 00       	call   c0103d89 <alloc_pages>
c010335a:	85 c0                	test   %eax,%eax
c010335c:	74 24                	je     c0103382 <basic_check+0x4bb>
c010335e:	c7 44 24 0c 56 68 10 	movl   $0xc0106856,0xc(%esp)
c0103365:	c0 
c0103366:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010336d:	c0 
c010336e:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103375:	00 
c0103376:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010337d:	e8 50 d9 ff ff       	call   c0100cd2 <__panic>

    assert(nr_free == 0);
c0103382:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0103387:	85 c0                	test   %eax,%eax
c0103389:	74 24                	je     c01033af <basic_check+0x4e8>
c010338b:	c7 44 24 0c a9 68 10 	movl   $0xc01068a9,0xc(%esp)
c0103392:	c0 
c0103393:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010339a:	c0 
c010339b:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c01033a2:	00 
c01033a3:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01033aa:	e8 23 d9 ff ff       	call   c0100cd2 <__panic>
    free_list = free_list_store;
c01033af:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01033b2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01033b5:	a3 10 af 11 c0       	mov    %eax,0xc011af10
c01033ba:	89 15 14 af 11 c0    	mov    %edx,0xc011af14
    nr_free = nr_free_store;
c01033c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033c3:	a3 18 af 11 c0       	mov    %eax,0xc011af18

    free_page(p);
c01033c8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033cf:	00 
c01033d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033d3:	89 04 24             	mov    %eax,(%esp)
c01033d6:	e8 e6 09 00 00       	call   c0103dc1 <free_pages>
    free_page(p1);
c01033db:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033e2:	00 
c01033e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033e6:	89 04 24             	mov    %eax,(%esp)
c01033e9:	e8 d3 09 00 00       	call   c0103dc1 <free_pages>
    free_page(p2);
c01033ee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033f5:	00 
c01033f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033f9:	89 04 24             	mov    %eax,(%esp)
c01033fc:	e8 c0 09 00 00       	call   c0103dc1 <free_pages>
}
c0103401:	c9                   	leave  
c0103402:	c3                   	ret    

c0103403 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103403:	55                   	push   %ebp
c0103404:	89 e5                	mov    %esp,%ebp
c0103406:	53                   	push   %ebx
c0103407:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c010340d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103414:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010341b:	c7 45 ec 10 af 11 c0 	movl   $0xc011af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103422:	eb 6b                	jmp    c010348f <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103424:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103427:	83 e8 0c             	sub    $0xc,%eax
c010342a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c010342d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103430:	83 c0 04             	add    $0x4,%eax
c0103433:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010343a:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010343d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103440:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103443:	0f a3 10             	bt     %edx,(%eax)
c0103446:	19 c0                	sbb    %eax,%eax
c0103448:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c010344b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010344f:	0f 95 c0             	setne  %al
c0103452:	0f b6 c0             	movzbl %al,%eax
c0103455:	85 c0                	test   %eax,%eax
c0103457:	75 24                	jne    c010347d <default_check+0x7a>
c0103459:	c7 44 24 0c b6 68 10 	movl   $0xc01068b6,0xc(%esp)
c0103460:	c0 
c0103461:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103468:	c0 
c0103469:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0103470:	00 
c0103471:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103478:	e8 55 d8 ff ff       	call   c0100cd2 <__panic>
        count ++, total += p->property;
c010347d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103481:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103484:	8b 50 08             	mov    0x8(%eax),%edx
c0103487:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010348a:	01 d0                	add    %edx,%eax
c010348c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010348f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103492:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103495:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103498:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010349b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010349e:	81 7d ec 10 af 11 c0 	cmpl   $0xc011af10,-0x14(%ebp)
c01034a5:	0f 85 79 ff ff ff    	jne    c0103424 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01034ab:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01034ae:	e8 40 09 00 00       	call   c0103df3 <nr_free_pages>
c01034b3:	39 c3                	cmp    %eax,%ebx
c01034b5:	74 24                	je     c01034db <default_check+0xd8>
c01034b7:	c7 44 24 0c c6 68 10 	movl   $0xc01068c6,0xc(%esp)
c01034be:	c0 
c01034bf:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01034c6:	c0 
c01034c7:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01034ce:	00 
c01034cf:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01034d6:	e8 f7 d7 ff ff       	call   c0100cd2 <__panic>

    basic_check();
c01034db:	e8 e7 f9 ff ff       	call   c0102ec7 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01034e0:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01034e7:	e8 9d 08 00 00       	call   c0103d89 <alloc_pages>
c01034ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01034ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01034f3:	75 24                	jne    c0103519 <default_check+0x116>
c01034f5:	c7 44 24 0c df 68 10 	movl   $0xc01068df,0xc(%esp)
c01034fc:	c0 
c01034fd:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103504:	c0 
c0103505:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c010350c:	00 
c010350d:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103514:	e8 b9 d7 ff ff       	call   c0100cd2 <__panic>
    assert(!PageProperty(p0));
c0103519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010351c:	83 c0 04             	add    $0x4,%eax
c010351f:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103526:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103529:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010352c:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010352f:	0f a3 10             	bt     %edx,(%eax)
c0103532:	19 c0                	sbb    %eax,%eax
c0103534:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103537:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010353b:	0f 95 c0             	setne  %al
c010353e:	0f b6 c0             	movzbl %al,%eax
c0103541:	85 c0                	test   %eax,%eax
c0103543:	74 24                	je     c0103569 <default_check+0x166>
c0103545:	c7 44 24 0c ea 68 10 	movl   $0xc01068ea,0xc(%esp)
c010354c:	c0 
c010354d:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103554:	c0 
c0103555:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c010355c:	00 
c010355d:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103564:	e8 69 d7 ff ff       	call   c0100cd2 <__panic>

    list_entry_t free_list_store = free_list;
c0103569:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c010356e:	8b 15 14 af 11 c0    	mov    0xc011af14,%edx
c0103574:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103577:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010357a:	c7 45 b4 10 af 11 c0 	movl   $0xc011af10,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103581:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103584:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103587:	89 50 04             	mov    %edx,0x4(%eax)
c010358a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010358d:	8b 50 04             	mov    0x4(%eax),%edx
c0103590:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103593:	89 10                	mov    %edx,(%eax)
c0103595:	c7 45 b0 10 af 11 c0 	movl   $0xc011af10,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010359c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010359f:	8b 40 04             	mov    0x4(%eax),%eax
c01035a2:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c01035a5:	0f 94 c0             	sete   %al
c01035a8:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01035ab:	85 c0                	test   %eax,%eax
c01035ad:	75 24                	jne    c01035d3 <default_check+0x1d0>
c01035af:	c7 44 24 0c 3f 68 10 	movl   $0xc010683f,0xc(%esp)
c01035b6:	c0 
c01035b7:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01035be:	c0 
c01035bf:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c01035c6:	00 
c01035c7:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01035ce:	e8 ff d6 ff ff       	call   c0100cd2 <__panic>
    assert(alloc_page() == NULL);
c01035d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01035da:	e8 aa 07 00 00       	call   c0103d89 <alloc_pages>
c01035df:	85 c0                	test   %eax,%eax
c01035e1:	74 24                	je     c0103607 <default_check+0x204>
c01035e3:	c7 44 24 0c 56 68 10 	movl   $0xc0106856,0xc(%esp)
c01035ea:	c0 
c01035eb:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01035f2:	c0 
c01035f3:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c01035fa:	00 
c01035fb:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103602:	e8 cb d6 ff ff       	call   c0100cd2 <__panic>

    unsigned int nr_free_store = nr_free;
c0103607:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c010360c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c010360f:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c0103616:	00 00 00 

    free_pages(p0 + 2, 3);
c0103619:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010361c:	83 c0 28             	add    $0x28,%eax
c010361f:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103626:	00 
c0103627:	89 04 24             	mov    %eax,(%esp)
c010362a:	e8 92 07 00 00       	call   c0103dc1 <free_pages>
    assert(alloc_pages(4) == NULL);
c010362f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103636:	e8 4e 07 00 00       	call   c0103d89 <alloc_pages>
c010363b:	85 c0                	test   %eax,%eax
c010363d:	74 24                	je     c0103663 <default_check+0x260>
c010363f:	c7 44 24 0c fc 68 10 	movl   $0xc01068fc,0xc(%esp)
c0103646:	c0 
c0103647:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010364e:	c0 
c010364f:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c0103656:	00 
c0103657:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010365e:	e8 6f d6 ff ff       	call   c0100cd2 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103666:	83 c0 28             	add    $0x28,%eax
c0103669:	83 c0 04             	add    $0x4,%eax
c010366c:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103673:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103676:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103679:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010367c:	0f a3 10             	bt     %edx,(%eax)
c010367f:	19 c0                	sbb    %eax,%eax
c0103681:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103684:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103688:	0f 95 c0             	setne  %al
c010368b:	0f b6 c0             	movzbl %al,%eax
c010368e:	85 c0                	test   %eax,%eax
c0103690:	74 0e                	je     c01036a0 <default_check+0x29d>
c0103692:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103695:	83 c0 28             	add    $0x28,%eax
c0103698:	8b 40 08             	mov    0x8(%eax),%eax
c010369b:	83 f8 03             	cmp    $0x3,%eax
c010369e:	74 24                	je     c01036c4 <default_check+0x2c1>
c01036a0:	c7 44 24 0c 14 69 10 	movl   $0xc0106914,0xc(%esp)
c01036a7:	c0 
c01036a8:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01036af:	c0 
c01036b0:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01036b7:	00 
c01036b8:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01036bf:	e8 0e d6 ff ff       	call   c0100cd2 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01036c4:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01036cb:	e8 b9 06 00 00       	call   c0103d89 <alloc_pages>
c01036d0:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01036d3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01036d7:	75 24                	jne    c01036fd <default_check+0x2fa>
c01036d9:	c7 44 24 0c 40 69 10 	movl   $0xc0106940,0xc(%esp)
c01036e0:	c0 
c01036e1:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01036e8:	c0 
c01036e9:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c01036f0:	00 
c01036f1:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01036f8:	e8 d5 d5 ff ff       	call   c0100cd2 <__panic>
    assert(alloc_page() == NULL);
c01036fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103704:	e8 80 06 00 00       	call   c0103d89 <alloc_pages>
c0103709:	85 c0                	test   %eax,%eax
c010370b:	74 24                	je     c0103731 <default_check+0x32e>
c010370d:	c7 44 24 0c 56 68 10 	movl   $0xc0106856,0xc(%esp)
c0103714:	c0 
c0103715:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010371c:	c0 
c010371d:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0103724:	00 
c0103725:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010372c:	e8 a1 d5 ff ff       	call   c0100cd2 <__panic>
    assert(p0 + 2 == p1);
c0103731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103734:	83 c0 28             	add    $0x28,%eax
c0103737:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010373a:	74 24                	je     c0103760 <default_check+0x35d>
c010373c:	c7 44 24 0c 5e 69 10 	movl   $0xc010695e,0xc(%esp)
c0103743:	c0 
c0103744:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010374b:	c0 
c010374c:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c0103753:	00 
c0103754:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010375b:	e8 72 d5 ff ff       	call   c0100cd2 <__panic>

    p2 = p0 + 1;
c0103760:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103763:	83 c0 14             	add    $0x14,%eax
c0103766:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103769:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103770:	00 
c0103771:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103774:	89 04 24             	mov    %eax,(%esp)
c0103777:	e8 45 06 00 00       	call   c0103dc1 <free_pages>
    free_pages(p1, 3);
c010377c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103783:	00 
c0103784:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103787:	89 04 24             	mov    %eax,(%esp)
c010378a:	e8 32 06 00 00       	call   c0103dc1 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010378f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103792:	83 c0 04             	add    $0x4,%eax
c0103795:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010379c:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010379f:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01037a2:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01037a5:	0f a3 10             	bt     %edx,(%eax)
c01037a8:	19 c0                	sbb    %eax,%eax
c01037aa:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01037ad:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01037b1:	0f 95 c0             	setne  %al
c01037b4:	0f b6 c0             	movzbl %al,%eax
c01037b7:	85 c0                	test   %eax,%eax
c01037b9:	74 0b                	je     c01037c6 <default_check+0x3c3>
c01037bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037be:	8b 40 08             	mov    0x8(%eax),%eax
c01037c1:	83 f8 01             	cmp    $0x1,%eax
c01037c4:	74 24                	je     c01037ea <default_check+0x3e7>
c01037c6:	c7 44 24 0c 6c 69 10 	movl   $0xc010696c,0xc(%esp)
c01037cd:	c0 
c01037ce:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01037d5:	c0 
c01037d6:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c01037dd:	00 
c01037de:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01037e5:	e8 e8 d4 ff ff       	call   c0100cd2 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01037ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037ed:	83 c0 04             	add    $0x4,%eax
c01037f0:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01037f7:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01037fa:	8b 45 90             	mov    -0x70(%ebp),%eax
c01037fd:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103800:	0f a3 10             	bt     %edx,(%eax)
c0103803:	19 c0                	sbb    %eax,%eax
c0103805:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103808:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010380c:	0f 95 c0             	setne  %al
c010380f:	0f b6 c0             	movzbl %al,%eax
c0103812:	85 c0                	test   %eax,%eax
c0103814:	74 0b                	je     c0103821 <default_check+0x41e>
c0103816:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103819:	8b 40 08             	mov    0x8(%eax),%eax
c010381c:	83 f8 03             	cmp    $0x3,%eax
c010381f:	74 24                	je     c0103845 <default_check+0x442>
c0103821:	c7 44 24 0c 94 69 10 	movl   $0xc0106994,0xc(%esp)
c0103828:	c0 
c0103829:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103830:	c0 
c0103831:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c0103838:	00 
c0103839:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103840:	e8 8d d4 ff ff       	call   c0100cd2 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0103845:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010384c:	e8 38 05 00 00       	call   c0103d89 <alloc_pages>
c0103851:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103854:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103857:	83 e8 14             	sub    $0x14,%eax
c010385a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010385d:	74 24                	je     c0103883 <default_check+0x480>
c010385f:	c7 44 24 0c ba 69 10 	movl   $0xc01069ba,0xc(%esp)
c0103866:	c0 
c0103867:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010386e:	c0 
c010386f:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c0103876:	00 
c0103877:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010387e:	e8 4f d4 ff ff       	call   c0100cd2 <__panic>
    free_page(p0);
c0103883:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010388a:	00 
c010388b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010388e:	89 04 24             	mov    %eax,(%esp)
c0103891:	e8 2b 05 00 00       	call   c0103dc1 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103896:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010389d:	e8 e7 04 00 00       	call   c0103d89 <alloc_pages>
c01038a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01038a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01038a8:	83 c0 14             	add    $0x14,%eax
c01038ab:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01038ae:	74 24                	je     c01038d4 <default_check+0x4d1>
c01038b0:	c7 44 24 0c d8 69 10 	movl   $0xc01069d8,0xc(%esp)
c01038b7:	c0 
c01038b8:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01038bf:	c0 
c01038c0:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c01038c7:	00 
c01038c8:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01038cf:	e8 fe d3 ff ff       	call   c0100cd2 <__panic>

    free_pages(p0, 2);
c01038d4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01038db:	00 
c01038dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038df:	89 04 24             	mov    %eax,(%esp)
c01038e2:	e8 da 04 00 00       	call   c0103dc1 <free_pages>
    free_page(p2);
c01038e7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01038ee:	00 
c01038ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01038f2:	89 04 24             	mov    %eax,(%esp)
c01038f5:	e8 c7 04 00 00       	call   c0103dc1 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01038fa:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103901:	e8 83 04 00 00       	call   c0103d89 <alloc_pages>
c0103906:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103909:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010390d:	75 24                	jne    c0103933 <default_check+0x530>
c010390f:	c7 44 24 0c f8 69 10 	movl   $0xc01069f8,0xc(%esp)
c0103916:	c0 
c0103917:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010391e:	c0 
c010391f:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c0103926:	00 
c0103927:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010392e:	e8 9f d3 ff ff       	call   c0100cd2 <__panic>
    assert(alloc_page() == NULL);
c0103933:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010393a:	e8 4a 04 00 00       	call   c0103d89 <alloc_pages>
c010393f:	85 c0                	test   %eax,%eax
c0103941:	74 24                	je     c0103967 <default_check+0x564>
c0103943:	c7 44 24 0c 56 68 10 	movl   $0xc0106856,0xc(%esp)
c010394a:	c0 
c010394b:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103952:	c0 
c0103953:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c010395a:	00 
c010395b:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103962:	e8 6b d3 ff ff       	call   c0100cd2 <__panic>

    assert(nr_free == 0);
c0103967:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c010396c:	85 c0                	test   %eax,%eax
c010396e:	74 24                	je     c0103994 <default_check+0x591>
c0103970:	c7 44 24 0c a9 68 10 	movl   $0xc01068a9,0xc(%esp)
c0103977:	c0 
c0103978:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010397f:	c0 
c0103980:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c0103987:	00 
c0103988:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010398f:	e8 3e d3 ff ff       	call   c0100cd2 <__panic>
    nr_free = nr_free_store;
c0103994:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103997:	a3 18 af 11 c0       	mov    %eax,0xc011af18

    free_list = free_list_store;
c010399c:	8b 45 80             	mov    -0x80(%ebp),%eax
c010399f:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01039a2:	a3 10 af 11 c0       	mov    %eax,0xc011af10
c01039a7:	89 15 14 af 11 c0    	mov    %edx,0xc011af14
    free_pages(p0, 5);
c01039ad:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01039b4:	00 
c01039b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01039b8:	89 04 24             	mov    %eax,(%esp)
c01039bb:	e8 01 04 00 00       	call   c0103dc1 <free_pages>

    le = &free_list;
c01039c0:	c7 45 ec 10 af 11 c0 	movl   $0xc011af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01039c7:	eb 1d                	jmp    c01039e6 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c01039c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039cc:	83 e8 0c             	sub    $0xc,%eax
c01039cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01039d2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01039d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01039d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01039dc:	8b 40 08             	mov    0x8(%eax),%eax
c01039df:	29 c2                	sub    %eax,%edx
c01039e1:	89 d0                	mov    %edx,%eax
c01039e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039e9:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01039ec:	8b 45 88             	mov    -0x78(%ebp),%eax
c01039ef:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01039f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01039f5:	81 7d ec 10 af 11 c0 	cmpl   $0xc011af10,-0x14(%ebp)
c01039fc:	75 cb                	jne    c01039c9 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01039fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103a02:	74 24                	je     c0103a28 <default_check+0x625>
c0103a04:	c7 44 24 0c 16 6a 10 	movl   $0xc0106a16,0xc(%esp)
c0103a0b:	c0 
c0103a0c:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103a13:	c0 
c0103a14:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c0103a1b:	00 
c0103a1c:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103a23:	e8 aa d2 ff ff       	call   c0100cd2 <__panic>
    assert(total == 0);
c0103a28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a2c:	74 24                	je     c0103a52 <default_check+0x64f>
c0103a2e:	c7 44 24 0c 21 6a 10 	movl   $0xc0106a21,0xc(%esp)
c0103a35:	c0 
c0103a36:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103a3d:	c0 
c0103a3e:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c0103a45:	00 
c0103a46:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103a4d:	e8 80 d2 ff ff       	call   c0100cd2 <__panic>
}
c0103a52:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103a58:	5b                   	pop    %ebx
c0103a59:	5d                   	pop    %ebp
c0103a5a:	c3                   	ret    

c0103a5b <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103a5b:	55                   	push   %ebp
c0103a5c:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103a5e:	8b 55 08             	mov    0x8(%ebp),%edx
c0103a61:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0103a66:	29 c2                	sub    %eax,%edx
c0103a68:	89 d0                	mov    %edx,%eax
c0103a6a:	c1 f8 02             	sar    $0x2,%eax
c0103a6d:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103a73:	5d                   	pop    %ebp
c0103a74:	c3                   	ret    

c0103a75 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103a75:	55                   	push   %ebp
c0103a76:	89 e5                	mov    %esp,%ebp
c0103a78:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103a7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a7e:	89 04 24             	mov    %eax,(%esp)
c0103a81:	e8 d5 ff ff ff       	call   c0103a5b <page2ppn>
c0103a86:	c1 e0 0c             	shl    $0xc,%eax
}
c0103a89:	c9                   	leave  
c0103a8a:	c3                   	ret    

c0103a8b <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103a8b:	55                   	push   %ebp
c0103a8c:	89 e5                	mov    %esp,%ebp
c0103a8e:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103a91:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a94:	c1 e8 0c             	shr    $0xc,%eax
c0103a97:	89 c2                	mov    %eax,%edx
c0103a99:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103a9e:	39 c2                	cmp    %eax,%edx
c0103aa0:	72 1c                	jb     c0103abe <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103aa2:	c7 44 24 08 5c 6a 10 	movl   $0xc0106a5c,0x8(%esp)
c0103aa9:	c0 
c0103aaa:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103ab1:	00 
c0103ab2:	c7 04 24 7b 6a 10 c0 	movl   $0xc0106a7b,(%esp)
c0103ab9:	e8 14 d2 ff ff       	call   c0100cd2 <__panic>
    }
    return &pages[PPN(pa)];
c0103abe:	8b 0d 24 af 11 c0    	mov    0xc011af24,%ecx
c0103ac4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ac7:	c1 e8 0c             	shr    $0xc,%eax
c0103aca:	89 c2                	mov    %eax,%edx
c0103acc:	89 d0                	mov    %edx,%eax
c0103ace:	c1 e0 02             	shl    $0x2,%eax
c0103ad1:	01 d0                	add    %edx,%eax
c0103ad3:	c1 e0 02             	shl    $0x2,%eax
c0103ad6:	01 c8                	add    %ecx,%eax
}
c0103ad8:	c9                   	leave  
c0103ad9:	c3                   	ret    

c0103ada <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103ada:	55                   	push   %ebp
c0103adb:	89 e5                	mov    %esp,%ebp
c0103add:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103ae0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ae3:	89 04 24             	mov    %eax,(%esp)
c0103ae6:	e8 8a ff ff ff       	call   c0103a75 <page2pa>
c0103aeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103af1:	c1 e8 0c             	shr    $0xc,%eax
c0103af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103af7:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103afc:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103aff:	72 23                	jb     c0103b24 <page2kva+0x4a>
c0103b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b04:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103b08:	c7 44 24 08 8c 6a 10 	movl   $0xc0106a8c,0x8(%esp)
c0103b0f:	c0 
c0103b10:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103b17:	00 
c0103b18:	c7 04 24 7b 6a 10 c0 	movl   $0xc0106a7b,(%esp)
c0103b1f:	e8 ae d1 ff ff       	call   c0100cd2 <__panic>
c0103b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b27:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103b2c:	c9                   	leave  
c0103b2d:	c3                   	ret    

c0103b2e <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103b2e:	55                   	push   %ebp
c0103b2f:	89 e5                	mov    %esp,%ebp
c0103b31:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103b34:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b37:	83 e0 01             	and    $0x1,%eax
c0103b3a:	85 c0                	test   %eax,%eax
c0103b3c:	75 1c                	jne    c0103b5a <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103b3e:	c7 44 24 08 b0 6a 10 	movl   $0xc0106ab0,0x8(%esp)
c0103b45:	c0 
c0103b46:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103b4d:	00 
c0103b4e:	c7 04 24 7b 6a 10 c0 	movl   $0xc0106a7b,(%esp)
c0103b55:	e8 78 d1 ff ff       	call   c0100cd2 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103b5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b62:	89 04 24             	mov    %eax,(%esp)
c0103b65:	e8 21 ff ff ff       	call   c0103a8b <pa2page>
}
c0103b6a:	c9                   	leave  
c0103b6b:	c3                   	ret    

c0103b6c <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0103b6c:	55                   	push   %ebp
c0103b6d:	89 e5                	mov    %esp,%ebp
c0103b6f:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103b72:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b75:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b7a:	89 04 24             	mov    %eax,(%esp)
c0103b7d:	e8 09 ff ff ff       	call   c0103a8b <pa2page>
}
c0103b82:	c9                   	leave  
c0103b83:	c3                   	ret    

c0103b84 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0103b84:	55                   	push   %ebp
c0103b85:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103b87:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b8a:	8b 00                	mov    (%eax),%eax
}
c0103b8c:	5d                   	pop    %ebp
c0103b8d:	c3                   	ret    

c0103b8e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103b8e:	55                   	push   %ebp
c0103b8f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103b91:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b94:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103b97:	89 10                	mov    %edx,(%eax)
}
c0103b99:	5d                   	pop    %ebp
c0103b9a:	c3                   	ret    

c0103b9b <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103b9b:	55                   	push   %ebp
c0103b9c:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103b9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ba1:	8b 00                	mov    (%eax),%eax
c0103ba3:	8d 50 01             	lea    0x1(%eax),%edx
c0103ba6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ba9:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103bab:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bae:	8b 00                	mov    (%eax),%eax
}
c0103bb0:	5d                   	pop    %ebp
c0103bb1:	c3                   	ret    

c0103bb2 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103bb2:	55                   	push   %ebp
c0103bb3:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103bb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bb8:	8b 00                	mov    (%eax),%eax
c0103bba:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103bbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bc0:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103bc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bc5:	8b 00                	mov    (%eax),%eax
}
c0103bc7:	5d                   	pop    %ebp
c0103bc8:	c3                   	ret    

c0103bc9 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103bc9:	55                   	push   %ebp
c0103bca:	89 e5                	mov    %esp,%ebp
c0103bcc:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103bcf:	9c                   	pushf  
c0103bd0:	58                   	pop    %eax
c0103bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103bd7:	25 00 02 00 00       	and    $0x200,%eax
c0103bdc:	85 c0                	test   %eax,%eax
c0103bde:	74 0c                	je     c0103bec <__intr_save+0x23>
        intr_disable();
c0103be0:	e8 e1 da ff ff       	call   c01016c6 <intr_disable>
        return 1;
c0103be5:	b8 01 00 00 00       	mov    $0x1,%eax
c0103bea:	eb 05                	jmp    c0103bf1 <__intr_save+0x28>
    }
    return 0;
c0103bec:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103bf1:	c9                   	leave  
c0103bf2:	c3                   	ret    

c0103bf3 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103bf3:	55                   	push   %ebp
c0103bf4:	89 e5                	mov    %esp,%ebp
c0103bf6:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103bf9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103bfd:	74 05                	je     c0103c04 <__intr_restore+0x11>
        intr_enable();
c0103bff:	e8 bc da ff ff       	call   c01016c0 <intr_enable>
    }
}
c0103c04:	c9                   	leave  
c0103c05:	c3                   	ret    

c0103c06 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103c06:	55                   	push   %ebp
c0103c07:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103c09:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c0c:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103c0f:	b8 23 00 00 00       	mov    $0x23,%eax
c0103c14:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103c16:	b8 23 00 00 00       	mov    $0x23,%eax
c0103c1b:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103c1d:	b8 10 00 00 00       	mov    $0x10,%eax
c0103c22:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103c24:	b8 10 00 00 00       	mov    $0x10,%eax
c0103c29:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103c2b:	b8 10 00 00 00       	mov    $0x10,%eax
c0103c30:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103c32:	ea 39 3c 10 c0 08 00 	ljmp   $0x8,$0xc0103c39
}
c0103c39:	5d                   	pop    %ebp
c0103c3a:	c3                   	ret    

c0103c3b <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103c3b:	55                   	push   %ebp
c0103c3c:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103c3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c41:	a3 a4 ae 11 c0       	mov    %eax,0xc011aea4
}
c0103c46:	5d                   	pop    %ebp
c0103c47:	c3                   	ret    

c0103c48 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103c48:	55                   	push   %ebp
c0103c49:	89 e5                	mov    %esp,%ebp
c0103c4b:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103c4e:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103c53:	89 04 24             	mov    %eax,(%esp)
c0103c56:	e8 e0 ff ff ff       	call   c0103c3b <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103c5b:	66 c7 05 a8 ae 11 c0 	movw   $0x10,0xc011aea8
c0103c62:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103c64:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103c6b:	68 00 
c0103c6d:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103c72:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103c78:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103c7d:	c1 e8 10             	shr    $0x10,%eax
c0103c80:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103c85:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c8c:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c8f:	83 c8 09             	or     $0x9,%eax
c0103c92:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c97:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c9e:	83 e0 ef             	and    $0xffffffef,%eax
c0103ca1:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103ca6:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103cad:	83 e0 9f             	and    $0xffffff9f,%eax
c0103cb0:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103cb5:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103cbc:	83 c8 80             	or     $0xffffff80,%eax
c0103cbf:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103cc4:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103ccb:	83 e0 f0             	and    $0xfffffff0,%eax
c0103cce:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cd3:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103cda:	83 e0 ef             	and    $0xffffffef,%eax
c0103cdd:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103ce2:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103ce9:	83 e0 df             	and    $0xffffffdf,%eax
c0103cec:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cf1:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103cf8:	83 c8 40             	or     $0x40,%eax
c0103cfb:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103d00:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103d07:	83 e0 7f             	and    $0x7f,%eax
c0103d0a:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103d0f:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103d14:	c1 e8 18             	shr    $0x18,%eax
c0103d17:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103d1c:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103d23:	e8 de fe ff ff       	call   c0103c06 <lgdt>
c0103d28:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103d2e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103d32:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103d35:	c9                   	leave  
c0103d36:	c3                   	ret    

c0103d37 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103d37:	55                   	push   %ebp
c0103d38:	89 e5                	mov    %esp,%ebp
c0103d3a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103d3d:	c7 05 1c af 11 c0 40 	movl   $0xc0106a40,0xc011af1c
c0103d44:	6a 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103d47:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103d4c:	8b 00                	mov    (%eax),%eax
c0103d4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103d52:	c7 04 24 dc 6a 10 c0 	movl   $0xc0106adc,(%esp)
c0103d59:	e8 ea c5 ff ff       	call   c0100348 <cprintf>
    pmm_manager->init();
c0103d5e:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103d63:	8b 40 04             	mov    0x4(%eax),%eax
c0103d66:	ff d0                	call   *%eax
}
c0103d68:	c9                   	leave  
c0103d69:	c3                   	ret    

c0103d6a <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103d6a:	55                   	push   %ebp
c0103d6b:	89 e5                	mov    %esp,%ebp
c0103d6d:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103d70:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103d75:	8b 40 08             	mov    0x8(%eax),%eax
c0103d78:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d7b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d7f:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d82:	89 14 24             	mov    %edx,(%esp)
c0103d85:	ff d0                	call   *%eax
}
c0103d87:	c9                   	leave  
c0103d88:	c3                   	ret    

c0103d89 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103d89:	55                   	push   %ebp
c0103d8a:	89 e5                	mov    %esp,%ebp
c0103d8c:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103d8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d96:	e8 2e fe ff ff       	call   c0103bc9 <__intr_save>
c0103d9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103d9e:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103da3:	8b 40 0c             	mov    0xc(%eax),%eax
c0103da6:	8b 55 08             	mov    0x8(%ebp),%edx
c0103da9:	89 14 24             	mov    %edx,(%esp)
c0103dac:	ff d0                	call   *%eax
c0103dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103db4:	89 04 24             	mov    %eax,(%esp)
c0103db7:	e8 37 fe ff ff       	call   c0103bf3 <__intr_restore>
    return page;
c0103dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103dbf:	c9                   	leave  
c0103dc0:	c3                   	ret    

c0103dc1 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103dc1:	55                   	push   %ebp
c0103dc2:	89 e5                	mov    %esp,%ebp
c0103dc4:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103dc7:	e8 fd fd ff ff       	call   c0103bc9 <__intr_save>
c0103dcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103dcf:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103dd4:	8b 40 10             	mov    0x10(%eax),%eax
c0103dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103dda:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103dde:	8b 55 08             	mov    0x8(%ebp),%edx
c0103de1:	89 14 24             	mov    %edx,(%esp)
c0103de4:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103de9:	89 04 24             	mov    %eax,(%esp)
c0103dec:	e8 02 fe ff ff       	call   c0103bf3 <__intr_restore>
}
c0103df1:	c9                   	leave  
c0103df2:	c3                   	ret    

c0103df3 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103df3:	55                   	push   %ebp
c0103df4:	89 e5                	mov    %esp,%ebp
c0103df6:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103df9:	e8 cb fd ff ff       	call   c0103bc9 <__intr_save>
c0103dfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103e01:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103e06:	8b 40 14             	mov    0x14(%eax),%eax
c0103e09:	ff d0                	call   *%eax
c0103e0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e11:	89 04 24             	mov    %eax,(%esp)
c0103e14:	e8 da fd ff ff       	call   c0103bf3 <__intr_restore>
    return ret;
c0103e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103e1c:	c9                   	leave  
c0103e1d:	c3                   	ret    

c0103e1e <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103e1e:	55                   	push   %ebp
c0103e1f:	89 e5                	mov    %esp,%ebp
c0103e21:	57                   	push   %edi
c0103e22:	56                   	push   %esi
c0103e23:	53                   	push   %ebx
c0103e24:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103e2a:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103e31:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103e38:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103e3f:	c7 04 24 f3 6a 10 c0 	movl   $0xc0106af3,(%esp)
c0103e46:	e8 fd c4 ff ff       	call   c0100348 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103e4b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103e52:	e9 15 01 00 00       	jmp    c0103f6c <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103e57:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e5a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e5d:	89 d0                	mov    %edx,%eax
c0103e5f:	c1 e0 02             	shl    $0x2,%eax
c0103e62:	01 d0                	add    %edx,%eax
c0103e64:	c1 e0 02             	shl    $0x2,%eax
c0103e67:	01 c8                	add    %ecx,%eax
c0103e69:	8b 50 08             	mov    0x8(%eax),%edx
c0103e6c:	8b 40 04             	mov    0x4(%eax),%eax
c0103e6f:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103e72:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103e75:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e78:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e7b:	89 d0                	mov    %edx,%eax
c0103e7d:	c1 e0 02             	shl    $0x2,%eax
c0103e80:	01 d0                	add    %edx,%eax
c0103e82:	c1 e0 02             	shl    $0x2,%eax
c0103e85:	01 c8                	add    %ecx,%eax
c0103e87:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e8a:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e8d:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e90:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e93:	01 c8                	add    %ecx,%eax
c0103e95:	11 da                	adc    %ebx,%edx
c0103e97:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103e9a:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103e9d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ea0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ea3:	89 d0                	mov    %edx,%eax
c0103ea5:	c1 e0 02             	shl    $0x2,%eax
c0103ea8:	01 d0                	add    %edx,%eax
c0103eaa:	c1 e0 02             	shl    $0x2,%eax
c0103ead:	01 c8                	add    %ecx,%eax
c0103eaf:	83 c0 14             	add    $0x14,%eax
c0103eb2:	8b 00                	mov    (%eax),%eax
c0103eb4:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103eba:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103ebd:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103ec0:	83 c0 ff             	add    $0xffffffff,%eax
c0103ec3:	83 d2 ff             	adc    $0xffffffff,%edx
c0103ec6:	89 c6                	mov    %eax,%esi
c0103ec8:	89 d7                	mov    %edx,%edi
c0103eca:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ecd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ed0:	89 d0                	mov    %edx,%eax
c0103ed2:	c1 e0 02             	shl    $0x2,%eax
c0103ed5:	01 d0                	add    %edx,%eax
c0103ed7:	c1 e0 02             	shl    $0x2,%eax
c0103eda:	01 c8                	add    %ecx,%eax
c0103edc:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103edf:	8b 58 10             	mov    0x10(%eax),%ebx
c0103ee2:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103ee8:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103eec:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103ef0:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103ef4:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103ef7:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103efa:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103efe:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103f02:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103f06:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103f0a:	c7 04 24 00 6b 10 c0 	movl   $0xc0106b00,(%esp)
c0103f11:	e8 32 c4 ff ff       	call   c0100348 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103f16:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f19:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f1c:	89 d0                	mov    %edx,%eax
c0103f1e:	c1 e0 02             	shl    $0x2,%eax
c0103f21:	01 d0                	add    %edx,%eax
c0103f23:	c1 e0 02             	shl    $0x2,%eax
c0103f26:	01 c8                	add    %ecx,%eax
c0103f28:	83 c0 14             	add    $0x14,%eax
c0103f2b:	8b 00                	mov    (%eax),%eax
c0103f2d:	83 f8 01             	cmp    $0x1,%eax
c0103f30:	75 36                	jne    c0103f68 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103f32:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103f38:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103f3b:	77 2b                	ja     c0103f68 <page_init+0x14a>
c0103f3d:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103f40:	72 05                	jb     c0103f47 <page_init+0x129>
c0103f42:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103f45:	73 21                	jae    c0103f68 <page_init+0x14a>
c0103f47:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103f4b:	77 1b                	ja     c0103f68 <page_init+0x14a>
c0103f4d:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103f51:	72 09                	jb     c0103f5c <page_init+0x13e>
c0103f53:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103f5a:	77 0c                	ja     c0103f68 <page_init+0x14a>
                maxpa = end;
c0103f5c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f5f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103f62:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103f65:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103f68:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f6c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103f6f:	8b 00                	mov    (%eax),%eax
c0103f71:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103f74:	0f 8f dd fe ff ff    	jg     c0103e57 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103f7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f7e:	72 1d                	jb     c0103f9d <page_init+0x17f>
c0103f80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f84:	77 09                	ja     c0103f8f <page_init+0x171>
c0103f86:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103f8d:	76 0e                	jbe    c0103f9d <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103f8f:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103f96:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103f9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103fa0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103fa3:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103fa7:	c1 ea 0c             	shr    $0xc,%edx
c0103faa:	a3 80 ae 11 c0       	mov    %eax,0xc011ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103faf:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103fb6:	b8 28 af 11 c0       	mov    $0xc011af28,%eax
c0103fbb:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103fbe:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103fc1:	01 d0                	add    %edx,%eax
c0103fc3:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103fc6:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103fc9:	ba 00 00 00 00       	mov    $0x0,%edx
c0103fce:	f7 75 ac             	divl   -0x54(%ebp)
c0103fd1:	89 d0                	mov    %edx,%eax
c0103fd3:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103fd6:	29 c2                	sub    %eax,%edx
c0103fd8:	89 d0                	mov    %edx,%eax
c0103fda:	a3 24 af 11 c0       	mov    %eax,0xc011af24

    for (i = 0; i < npage; i ++) {
c0103fdf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103fe6:	eb 2f                	jmp    c0104017 <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103fe8:	8b 0d 24 af 11 c0    	mov    0xc011af24,%ecx
c0103fee:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ff1:	89 d0                	mov    %edx,%eax
c0103ff3:	c1 e0 02             	shl    $0x2,%eax
c0103ff6:	01 d0                	add    %edx,%eax
c0103ff8:	c1 e0 02             	shl    $0x2,%eax
c0103ffb:	01 c8                	add    %ecx,%eax
c0103ffd:	83 c0 04             	add    $0x4,%eax
c0104000:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0104007:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010400a:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010400d:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104010:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0104013:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104017:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010401a:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c010401f:	39 c2                	cmp    %eax,%edx
c0104021:	72 c5                	jb     c0103fe8 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104023:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0104029:	89 d0                	mov    %edx,%eax
c010402b:	c1 e0 02             	shl    $0x2,%eax
c010402e:	01 d0                	add    %edx,%eax
c0104030:	c1 e0 02             	shl    $0x2,%eax
c0104033:	89 c2                	mov    %eax,%edx
c0104035:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c010403a:	01 d0                	add    %edx,%eax
c010403c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c010403f:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0104046:	77 23                	ja     c010406b <page_init+0x24d>
c0104048:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010404b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010404f:	c7 44 24 08 30 6b 10 	movl   $0xc0106b30,0x8(%esp)
c0104056:	c0 
c0104057:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c010405e:	00 
c010405f:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104066:	e8 67 cc ff ff       	call   c0100cd2 <__panic>
c010406b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010406e:	05 00 00 00 40       	add    $0x40000000,%eax
c0104073:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104076:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010407d:	e9 74 01 00 00       	jmp    c01041f6 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104082:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104085:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104088:	89 d0                	mov    %edx,%eax
c010408a:	c1 e0 02             	shl    $0x2,%eax
c010408d:	01 d0                	add    %edx,%eax
c010408f:	c1 e0 02             	shl    $0x2,%eax
c0104092:	01 c8                	add    %ecx,%eax
c0104094:	8b 50 08             	mov    0x8(%eax),%edx
c0104097:	8b 40 04             	mov    0x4(%eax),%eax
c010409a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010409d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01040a0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040a3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040a6:	89 d0                	mov    %edx,%eax
c01040a8:	c1 e0 02             	shl    $0x2,%eax
c01040ab:	01 d0                	add    %edx,%eax
c01040ad:	c1 e0 02             	shl    $0x2,%eax
c01040b0:	01 c8                	add    %ecx,%eax
c01040b2:	8b 48 0c             	mov    0xc(%eax),%ecx
c01040b5:	8b 58 10             	mov    0x10(%eax),%ebx
c01040b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040be:	01 c8                	add    %ecx,%eax
c01040c0:	11 da                	adc    %ebx,%edx
c01040c2:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01040c5:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01040c8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040ce:	89 d0                	mov    %edx,%eax
c01040d0:	c1 e0 02             	shl    $0x2,%eax
c01040d3:	01 d0                	add    %edx,%eax
c01040d5:	c1 e0 02             	shl    $0x2,%eax
c01040d8:	01 c8                	add    %ecx,%eax
c01040da:	83 c0 14             	add    $0x14,%eax
c01040dd:	8b 00                	mov    (%eax),%eax
c01040df:	83 f8 01             	cmp    $0x1,%eax
c01040e2:	0f 85 0a 01 00 00    	jne    c01041f2 <page_init+0x3d4>
            if (begin < freemem) {
c01040e8:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01040eb:	ba 00 00 00 00       	mov    $0x0,%edx
c01040f0:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01040f3:	72 17                	jb     c010410c <page_init+0x2ee>
c01040f5:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01040f8:	77 05                	ja     c01040ff <page_init+0x2e1>
c01040fa:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01040fd:	76 0d                	jbe    c010410c <page_init+0x2ee>
                begin = freemem;
c01040ff:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104102:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104105:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c010410c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104110:	72 1d                	jb     c010412f <page_init+0x311>
c0104112:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104116:	77 09                	ja     c0104121 <page_init+0x303>
c0104118:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010411f:	76 0e                	jbe    c010412f <page_init+0x311>
                end = KMEMSIZE;
c0104121:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104128:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010412f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104132:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104135:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104138:	0f 87 b4 00 00 00    	ja     c01041f2 <page_init+0x3d4>
c010413e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104141:	72 09                	jb     c010414c <page_init+0x32e>
c0104143:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104146:	0f 83 a6 00 00 00    	jae    c01041f2 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c010414c:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104153:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104156:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104159:	01 d0                	add    %edx,%eax
c010415b:	83 e8 01             	sub    $0x1,%eax
c010415e:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104161:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104164:	ba 00 00 00 00       	mov    $0x0,%edx
c0104169:	f7 75 9c             	divl   -0x64(%ebp)
c010416c:	89 d0                	mov    %edx,%eax
c010416e:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104171:	29 c2                	sub    %eax,%edx
c0104173:	89 d0                	mov    %edx,%eax
c0104175:	ba 00 00 00 00       	mov    $0x0,%edx
c010417a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010417d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104180:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104183:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104186:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104189:	ba 00 00 00 00       	mov    $0x0,%edx
c010418e:	89 c7                	mov    %eax,%edi
c0104190:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104196:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104199:	89 d0                	mov    %edx,%eax
c010419b:	83 e0 00             	and    $0x0,%eax
c010419e:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01041a1:	8b 45 80             	mov    -0x80(%ebp),%eax
c01041a4:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01041a7:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01041aa:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01041ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041b0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01041b3:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01041b6:	77 3a                	ja     c01041f2 <page_init+0x3d4>
c01041b8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01041bb:	72 05                	jb     c01041c2 <page_init+0x3a4>
c01041bd:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01041c0:	73 30                	jae    c01041f2 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01041c2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01041c5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01041c8:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01041cb:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01041ce:	29 c8                	sub    %ecx,%eax
c01041d0:	19 da                	sbb    %ebx,%edx
c01041d2:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01041d6:	c1 ea 0c             	shr    $0xc,%edx
c01041d9:	89 c3                	mov    %eax,%ebx
c01041db:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041de:	89 04 24             	mov    %eax,(%esp)
c01041e1:	e8 a5 f8 ff ff       	call   c0103a8b <pa2page>
c01041e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01041ea:	89 04 24             	mov    %eax,(%esp)
c01041ed:	e8 78 fb ff ff       	call   c0103d6a <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01041f2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01041f6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01041f9:	8b 00                	mov    (%eax),%eax
c01041fb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01041fe:	0f 8f 7e fe ff ff    	jg     c0104082 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104204:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c010420a:	5b                   	pop    %ebx
c010420b:	5e                   	pop    %esi
c010420c:	5f                   	pop    %edi
c010420d:	5d                   	pop    %ebp
c010420e:	c3                   	ret    

c010420f <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010420f:	55                   	push   %ebp
c0104210:	89 e5                	mov    %esp,%ebp
c0104212:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104215:	8b 45 14             	mov    0x14(%ebp),%eax
c0104218:	8b 55 0c             	mov    0xc(%ebp),%edx
c010421b:	31 d0                	xor    %edx,%eax
c010421d:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104222:	85 c0                	test   %eax,%eax
c0104224:	74 24                	je     c010424a <boot_map_segment+0x3b>
c0104226:	c7 44 24 0c 62 6b 10 	movl   $0xc0106b62,0xc(%esp)
c010422d:	c0 
c010422e:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104235:	c0 
c0104236:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c010423d:	00 
c010423e:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104245:	e8 88 ca ff ff       	call   c0100cd2 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010424a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104251:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104254:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104259:	89 c2                	mov    %eax,%edx
c010425b:	8b 45 10             	mov    0x10(%ebp),%eax
c010425e:	01 c2                	add    %eax,%edx
c0104260:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104263:	01 d0                	add    %edx,%eax
c0104265:	83 e8 01             	sub    $0x1,%eax
c0104268:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010426b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010426e:	ba 00 00 00 00       	mov    $0x0,%edx
c0104273:	f7 75 f0             	divl   -0x10(%ebp)
c0104276:	89 d0                	mov    %edx,%eax
c0104278:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010427b:	29 c2                	sub    %eax,%edx
c010427d:	89 d0                	mov    %edx,%eax
c010427f:	c1 e8 0c             	shr    $0xc,%eax
c0104282:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104285:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104288:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010428b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010428e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104293:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104296:	8b 45 14             	mov    0x14(%ebp),%eax
c0104299:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010429c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010429f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01042a4:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01042a7:	eb 6b                	jmp    c0104314 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01042a9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01042b0:	00 
c01042b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01042b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01042bb:	89 04 24             	mov    %eax,(%esp)
c01042be:	e8 82 01 00 00       	call   c0104445 <get_pte>
c01042c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01042c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01042ca:	75 24                	jne    c01042f0 <boot_map_segment+0xe1>
c01042cc:	c7 44 24 0c 8e 6b 10 	movl   $0xc0106b8e,0xc(%esp)
c01042d3:	c0 
c01042d4:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c01042db:	c0 
c01042dc:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c01042e3:	00 
c01042e4:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c01042eb:	e8 e2 c9 ff ff       	call   c0100cd2 <__panic>
        *ptep = pa | PTE_P | perm;
c01042f0:	8b 45 18             	mov    0x18(%ebp),%eax
c01042f3:	8b 55 14             	mov    0x14(%ebp),%edx
c01042f6:	09 d0                	or     %edx,%eax
c01042f8:	83 c8 01             	or     $0x1,%eax
c01042fb:	89 c2                	mov    %eax,%edx
c01042fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104300:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104302:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104306:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010430d:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104314:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104318:	75 8f                	jne    c01042a9 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c010431a:	c9                   	leave  
c010431b:	c3                   	ret    

c010431c <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010431c:	55                   	push   %ebp
c010431d:	89 e5                	mov    %esp,%ebp
c010431f:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104322:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104329:	e8 5b fa ff ff       	call   c0103d89 <alloc_pages>
c010432e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104331:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104335:	75 1c                	jne    c0104353 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104337:	c7 44 24 08 9b 6b 10 	movl   $0xc0106b9b,0x8(%esp)
c010433e:	c0 
c010433f:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0104346:	00 
c0104347:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c010434e:	e8 7f c9 ff ff       	call   c0100cd2 <__panic>
    }
    return page2kva(p);
c0104353:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104356:	89 04 24             	mov    %eax,(%esp)
c0104359:	e8 7c f7 ff ff       	call   c0103ada <page2kva>
}
c010435e:	c9                   	leave  
c010435f:	c3                   	ret    

c0104360 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104360:	55                   	push   %ebp
c0104361:	89 e5                	mov    %esp,%ebp
c0104363:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0104366:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010436b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010436e:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104375:	77 23                	ja     c010439a <pmm_init+0x3a>
c0104377:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010437a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010437e:	c7 44 24 08 30 6b 10 	movl   $0xc0106b30,0x8(%esp)
c0104385:	c0 
c0104386:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010438d:	00 
c010438e:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104395:	e8 38 c9 ff ff       	call   c0100cd2 <__panic>
c010439a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010439d:	05 00 00 00 40       	add    $0x40000000,%eax
c01043a2:	a3 20 af 11 c0       	mov    %eax,0xc011af20
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01043a7:	e8 8b f9 ff ff       	call   c0103d37 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01043ac:	e8 6d fa ff ff       	call   c0103e1e <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01043b1:	e8 db 03 00 00       	call   c0104791 <check_alloc_page>

    check_pgdir();
c01043b6:	e8 f4 03 00 00       	call   c01047af <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01043bb:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01043c0:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01043c6:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01043cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043ce:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01043d5:	77 23                	ja     c01043fa <pmm_init+0x9a>
c01043d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043da:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043de:	c7 44 24 08 30 6b 10 	movl   $0xc0106b30,0x8(%esp)
c01043e5:	c0 
c01043e6:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c01043ed:	00 
c01043ee:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c01043f5:	e8 d8 c8 ff ff       	call   c0100cd2 <__panic>
c01043fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043fd:	05 00 00 00 40       	add    $0x40000000,%eax
c0104402:	83 c8 03             	or     $0x3,%eax
c0104405:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104407:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010440c:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104413:	00 
c0104414:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010441b:	00 
c010441c:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104423:	38 
c0104424:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c010442b:	c0 
c010442c:	89 04 24             	mov    %eax,(%esp)
c010442f:	e8 db fd ff ff       	call   c010420f <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104434:	e8 0f f8 ff ff       	call   c0103c48 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104439:	e8 0c 0a 00 00       	call   c0104e4a <check_boot_pgdir>

    print_pgdir();
c010443e:	e8 94 0e 00 00       	call   c01052d7 <print_pgdir>

}
c0104443:	c9                   	leave  
c0104444:	c3                   	ret    

c0104445 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104445:	55                   	push   %ebp
c0104446:	89 e5                	mov    %esp,%ebp
c0104448:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c010444b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010444e:	c1 e8 16             	shr    $0x16,%eax
c0104451:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104458:	8b 45 08             	mov    0x8(%ebp),%eax
c010445b:	01 d0                	add    %edx,%eax
c010445d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c0104460:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104463:	8b 00                	mov    (%eax),%eax
c0104465:	83 e0 01             	and    $0x1,%eax
c0104468:	85 c0                	test   %eax,%eax
c010446a:	0f 85 af 00 00 00    	jne    c010451f <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c0104470:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104474:	74 15                	je     c010448b <get_pte+0x46>
c0104476:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010447d:	e8 07 f9 ff ff       	call   c0103d89 <alloc_pages>
c0104482:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104485:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104489:	75 0a                	jne    c0104495 <get_pte+0x50>
            return NULL;
c010448b:	b8 00 00 00 00       	mov    $0x0,%eax
c0104490:	e9 e6 00 00 00       	jmp    c010457b <get_pte+0x136>
        }
        set_page_ref(page, 1);
c0104495:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010449c:	00 
c010449d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044a0:	89 04 24             	mov    %eax,(%esp)
c01044a3:	e8 e6 f6 ff ff       	call   c0103b8e <set_page_ref>
        uintptr_t pa = page2pa(page);
c01044a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044ab:	89 04 24             	mov    %eax,(%esp)
c01044ae:	e8 c2 f5 ff ff       	call   c0103a75 <page2pa>
c01044b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c01044b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01044bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044bf:	c1 e8 0c             	shr    $0xc,%eax
c01044c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01044c5:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01044ca:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01044cd:	72 23                	jb     c01044f2 <get_pte+0xad>
c01044cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01044d6:	c7 44 24 08 8c 6a 10 	movl   $0xc0106a8c,0x8(%esp)
c01044dd:	c0 
c01044de:	c7 44 24 04 72 01 00 	movl   $0x172,0x4(%esp)
c01044e5:	00 
c01044e6:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c01044ed:	e8 e0 c7 ff ff       	call   c0100cd2 <__panic>
c01044f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044f5:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01044fa:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104501:	00 
c0104502:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104509:	00 
c010450a:	89 04 24             	mov    %eax,(%esp)
c010450d:	e8 e3 18 00 00       	call   c0105df5 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0104512:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104515:	83 c8 07             	or     $0x7,%eax
c0104518:	89 c2                	mov    %eax,%edx
c010451a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010451d:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c010451f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104522:	8b 00                	mov    (%eax),%eax
c0104524:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104529:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010452c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010452f:	c1 e8 0c             	shr    $0xc,%eax
c0104532:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104535:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c010453a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010453d:	72 23                	jb     c0104562 <get_pte+0x11d>
c010453f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104542:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104546:	c7 44 24 08 8c 6a 10 	movl   $0xc0106a8c,0x8(%esp)
c010454d:	c0 
c010454e:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
c0104555:	00 
c0104556:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c010455d:	e8 70 c7 ff ff       	call   c0100cd2 <__panic>
c0104562:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104565:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010456a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010456d:	c1 ea 0c             	shr    $0xc,%edx
c0104570:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0104576:	c1 e2 02             	shl    $0x2,%edx
c0104579:	01 d0                	add    %edx,%eax
}
c010457b:	c9                   	leave  
c010457c:	c3                   	ret    

c010457d <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010457d:	55                   	push   %ebp
c010457e:	89 e5                	mov    %esp,%ebp
c0104580:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104583:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010458a:	00 
c010458b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010458e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104592:	8b 45 08             	mov    0x8(%ebp),%eax
c0104595:	89 04 24             	mov    %eax,(%esp)
c0104598:	e8 a8 fe ff ff       	call   c0104445 <get_pte>
c010459d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01045a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01045a4:	74 08                	je     c01045ae <get_page+0x31>
        *ptep_store = ptep;
c01045a6:	8b 45 10             	mov    0x10(%ebp),%eax
c01045a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01045ac:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01045ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01045b2:	74 1b                	je     c01045cf <get_page+0x52>
c01045b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045b7:	8b 00                	mov    (%eax),%eax
c01045b9:	83 e0 01             	and    $0x1,%eax
c01045bc:	85 c0                	test   %eax,%eax
c01045be:	74 0f                	je     c01045cf <get_page+0x52>
        return pte2page(*ptep);
c01045c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045c3:	8b 00                	mov    (%eax),%eax
c01045c5:	89 04 24             	mov    %eax,(%esp)
c01045c8:	e8 61 f5 ff ff       	call   c0103b2e <pte2page>
c01045cd:	eb 05                	jmp    c01045d4 <get_page+0x57>
    }
    return NULL;
c01045cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01045d4:	c9                   	leave  
c01045d5:	c3                   	ret    

c01045d6 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01045d6:	55                   	push   %ebp
c01045d7:	89 e5                	mov    %esp,%ebp
c01045d9:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c01045dc:	8b 45 10             	mov    0x10(%ebp),%eax
c01045df:	8b 00                	mov    (%eax),%eax
c01045e1:	83 e0 01             	and    $0x1,%eax
c01045e4:	85 c0                	test   %eax,%eax
c01045e6:	74 4d                	je     c0104635 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c01045e8:	8b 45 10             	mov    0x10(%ebp),%eax
c01045eb:	8b 00                	mov    (%eax),%eax
c01045ed:	89 04 24             	mov    %eax,(%esp)
c01045f0:	e8 39 f5 ff ff       	call   c0103b2e <pte2page>
c01045f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c01045f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045fb:	89 04 24             	mov    %eax,(%esp)
c01045fe:	e8 af f5 ff ff       	call   c0103bb2 <page_ref_dec>
c0104603:	85 c0                	test   %eax,%eax
c0104605:	75 13                	jne    c010461a <page_remove_pte+0x44>
            free_page(page);
c0104607:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010460e:	00 
c010460f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104612:	89 04 24             	mov    %eax,(%esp)
c0104615:	e8 a7 f7 ff ff       	call   c0103dc1 <free_pages>
        }
        *ptep = 0;
c010461a:	8b 45 10             	mov    0x10(%ebp),%eax
c010461d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0104623:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104626:	89 44 24 04          	mov    %eax,0x4(%esp)
c010462a:	8b 45 08             	mov    0x8(%ebp),%eax
c010462d:	89 04 24             	mov    %eax,(%esp)
c0104630:	e8 ff 00 00 00       	call   c0104734 <tlb_invalidate>
    }
}
c0104635:	c9                   	leave  
c0104636:	c3                   	ret    

c0104637 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104637:	55                   	push   %ebp
c0104638:	89 e5                	mov    %esp,%ebp
c010463a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010463d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104644:	00 
c0104645:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104648:	89 44 24 04          	mov    %eax,0x4(%esp)
c010464c:	8b 45 08             	mov    0x8(%ebp),%eax
c010464f:	89 04 24             	mov    %eax,(%esp)
c0104652:	e8 ee fd ff ff       	call   c0104445 <get_pte>
c0104657:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c010465a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010465e:	74 19                	je     c0104679 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104660:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104663:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104667:	8b 45 0c             	mov    0xc(%ebp),%eax
c010466a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010466e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104671:	89 04 24             	mov    %eax,(%esp)
c0104674:	e8 5d ff ff ff       	call   c01045d6 <page_remove_pte>
    }
}
c0104679:	c9                   	leave  
c010467a:	c3                   	ret    

c010467b <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010467b:	55                   	push   %ebp
c010467c:	89 e5                	mov    %esp,%ebp
c010467e:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104681:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104688:	00 
c0104689:	8b 45 10             	mov    0x10(%ebp),%eax
c010468c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104690:	8b 45 08             	mov    0x8(%ebp),%eax
c0104693:	89 04 24             	mov    %eax,(%esp)
c0104696:	e8 aa fd ff ff       	call   c0104445 <get_pte>
c010469b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010469e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046a2:	75 0a                	jne    c01046ae <page_insert+0x33>
        return -E_NO_MEM;
c01046a4:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01046a9:	e9 84 00 00 00       	jmp    c0104732 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01046ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046b1:	89 04 24             	mov    %eax,(%esp)
c01046b4:	e8 e2 f4 ff ff       	call   c0103b9b <page_ref_inc>
    if (*ptep & PTE_P) {
c01046b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046bc:	8b 00                	mov    (%eax),%eax
c01046be:	83 e0 01             	and    $0x1,%eax
c01046c1:	85 c0                	test   %eax,%eax
c01046c3:	74 3e                	je     c0104703 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01046c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046c8:	8b 00                	mov    (%eax),%eax
c01046ca:	89 04 24             	mov    %eax,(%esp)
c01046cd:	e8 5c f4 ff ff       	call   c0103b2e <pte2page>
c01046d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01046d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01046db:	75 0d                	jne    c01046ea <page_insert+0x6f>
            page_ref_dec(page);
c01046dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046e0:	89 04 24             	mov    %eax,(%esp)
c01046e3:	e8 ca f4 ff ff       	call   c0103bb2 <page_ref_dec>
c01046e8:	eb 19                	jmp    c0104703 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01046ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046ed:	89 44 24 08          	mov    %eax,0x8(%esp)
c01046f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01046f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01046fb:	89 04 24             	mov    %eax,(%esp)
c01046fe:	e8 d3 fe ff ff       	call   c01045d6 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104703:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104706:	89 04 24             	mov    %eax,(%esp)
c0104709:	e8 67 f3 ff ff       	call   c0103a75 <page2pa>
c010470e:	0b 45 14             	or     0x14(%ebp),%eax
c0104711:	83 c8 01             	or     $0x1,%eax
c0104714:	89 c2                	mov    %eax,%edx
c0104716:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104719:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010471b:	8b 45 10             	mov    0x10(%ebp),%eax
c010471e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104722:	8b 45 08             	mov    0x8(%ebp),%eax
c0104725:	89 04 24             	mov    %eax,(%esp)
c0104728:	e8 07 00 00 00       	call   c0104734 <tlb_invalidate>
    return 0;
c010472d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104732:	c9                   	leave  
c0104733:	c3                   	ret    

c0104734 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104734:	55                   	push   %ebp
c0104735:	89 e5                	mov    %esp,%ebp
c0104737:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010473a:	0f 20 d8             	mov    %cr3,%eax
c010473d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104740:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0104743:	89 c2                	mov    %eax,%edx
c0104745:	8b 45 08             	mov    0x8(%ebp),%eax
c0104748:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010474b:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104752:	77 23                	ja     c0104777 <tlb_invalidate+0x43>
c0104754:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104757:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010475b:	c7 44 24 08 30 6b 10 	movl   $0xc0106b30,0x8(%esp)
c0104762:	c0 
c0104763:	c7 44 24 04 d7 01 00 	movl   $0x1d7,0x4(%esp)
c010476a:	00 
c010476b:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104772:	e8 5b c5 ff ff       	call   c0100cd2 <__panic>
c0104777:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010477a:	05 00 00 00 40       	add    $0x40000000,%eax
c010477f:	39 c2                	cmp    %eax,%edx
c0104781:	75 0c                	jne    c010478f <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0104783:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104786:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104789:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010478c:	0f 01 38             	invlpg (%eax)
    }
}
c010478f:	c9                   	leave  
c0104790:	c3                   	ret    

c0104791 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104791:	55                   	push   %ebp
c0104792:	89 e5                	mov    %esp,%ebp
c0104794:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104797:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c010479c:	8b 40 18             	mov    0x18(%eax),%eax
c010479f:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01047a1:	c7 04 24 b4 6b 10 c0 	movl   $0xc0106bb4,(%esp)
c01047a8:	e8 9b bb ff ff       	call   c0100348 <cprintf>
}
c01047ad:	c9                   	leave  
c01047ae:	c3                   	ret    

c01047af <check_pgdir>:

static void
check_pgdir(void) {
c01047af:	55                   	push   %ebp
c01047b0:	89 e5                	mov    %esp,%ebp
c01047b2:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01047b5:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01047ba:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01047bf:	76 24                	jbe    c01047e5 <check_pgdir+0x36>
c01047c1:	c7 44 24 0c d3 6b 10 	movl   $0xc0106bd3,0xc(%esp)
c01047c8:	c0 
c01047c9:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c01047d0:	c0 
c01047d1:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c01047d8:	00 
c01047d9:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c01047e0:	e8 ed c4 ff ff       	call   c0100cd2 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01047e5:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01047ea:	85 c0                	test   %eax,%eax
c01047ec:	74 0e                	je     c01047fc <check_pgdir+0x4d>
c01047ee:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01047f3:	25 ff 0f 00 00       	and    $0xfff,%eax
c01047f8:	85 c0                	test   %eax,%eax
c01047fa:	74 24                	je     c0104820 <check_pgdir+0x71>
c01047fc:	c7 44 24 0c f0 6b 10 	movl   $0xc0106bf0,0xc(%esp)
c0104803:	c0 
c0104804:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c010480b:	c0 
c010480c:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c0104813:	00 
c0104814:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c010481b:	e8 b2 c4 ff ff       	call   c0100cd2 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104820:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104825:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010482c:	00 
c010482d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104834:	00 
c0104835:	89 04 24             	mov    %eax,(%esp)
c0104838:	e8 40 fd ff ff       	call   c010457d <get_page>
c010483d:	85 c0                	test   %eax,%eax
c010483f:	74 24                	je     c0104865 <check_pgdir+0xb6>
c0104841:	c7 44 24 0c 28 6c 10 	movl   $0xc0106c28,0xc(%esp)
c0104848:	c0 
c0104849:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104850:	c0 
c0104851:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c0104858:	00 
c0104859:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104860:	e8 6d c4 ff ff       	call   c0100cd2 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104865:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010486c:	e8 18 f5 ff ff       	call   c0103d89 <alloc_pages>
c0104871:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104874:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104879:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104880:	00 
c0104881:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104888:	00 
c0104889:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010488c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104890:	89 04 24             	mov    %eax,(%esp)
c0104893:	e8 e3 fd ff ff       	call   c010467b <page_insert>
c0104898:	85 c0                	test   %eax,%eax
c010489a:	74 24                	je     c01048c0 <check_pgdir+0x111>
c010489c:	c7 44 24 0c 50 6c 10 	movl   $0xc0106c50,0xc(%esp)
c01048a3:	c0 
c01048a4:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c01048ab:	c0 
c01048ac:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c01048b3:	00 
c01048b4:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c01048bb:	e8 12 c4 ff ff       	call   c0100cd2 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01048c0:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01048c5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048cc:	00 
c01048cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01048d4:	00 
c01048d5:	89 04 24             	mov    %eax,(%esp)
c01048d8:	e8 68 fb ff ff       	call   c0104445 <get_pte>
c01048dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01048e4:	75 24                	jne    c010490a <check_pgdir+0x15b>
c01048e6:	c7 44 24 0c 7c 6c 10 	movl   $0xc0106c7c,0xc(%esp)
c01048ed:	c0 
c01048ee:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c01048f5:	c0 
c01048f6:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c01048fd:	00 
c01048fe:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104905:	e8 c8 c3 ff ff       	call   c0100cd2 <__panic>
    assert(pte2page(*ptep) == p1);
c010490a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010490d:	8b 00                	mov    (%eax),%eax
c010490f:	89 04 24             	mov    %eax,(%esp)
c0104912:	e8 17 f2 ff ff       	call   c0103b2e <pte2page>
c0104917:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010491a:	74 24                	je     c0104940 <check_pgdir+0x191>
c010491c:	c7 44 24 0c a9 6c 10 	movl   $0xc0106ca9,0xc(%esp)
c0104923:	c0 
c0104924:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c010492b:	c0 
c010492c:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c0104933:	00 
c0104934:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c010493b:	e8 92 c3 ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p1) == 1);
c0104940:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104943:	89 04 24             	mov    %eax,(%esp)
c0104946:	e8 39 f2 ff ff       	call   c0103b84 <page_ref>
c010494b:	83 f8 01             	cmp    $0x1,%eax
c010494e:	74 24                	je     c0104974 <check_pgdir+0x1c5>
c0104950:	c7 44 24 0c bf 6c 10 	movl   $0xc0106cbf,0xc(%esp)
c0104957:	c0 
c0104958:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c010495f:	c0 
c0104960:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c0104967:	00 
c0104968:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c010496f:	e8 5e c3 ff ff       	call   c0100cd2 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104974:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104979:	8b 00                	mov    (%eax),%eax
c010497b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104980:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104983:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104986:	c1 e8 0c             	shr    $0xc,%eax
c0104989:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010498c:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104991:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104994:	72 23                	jb     c01049b9 <check_pgdir+0x20a>
c0104996:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104999:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010499d:	c7 44 24 08 8c 6a 10 	movl   $0xc0106a8c,0x8(%esp)
c01049a4:	c0 
c01049a5:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c01049ac:	00 
c01049ad:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c01049b4:	e8 19 c3 ff ff       	call   c0100cd2 <__panic>
c01049b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049bc:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01049c1:	83 c0 04             	add    $0x4,%eax
c01049c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01049c7:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01049cc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049d3:	00 
c01049d4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01049db:	00 
c01049dc:	89 04 24             	mov    %eax,(%esp)
c01049df:	e8 61 fa ff ff       	call   c0104445 <get_pte>
c01049e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01049e7:	74 24                	je     c0104a0d <check_pgdir+0x25e>
c01049e9:	c7 44 24 0c d4 6c 10 	movl   $0xc0106cd4,0xc(%esp)
c01049f0:	c0 
c01049f1:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c01049f8:	c0 
c01049f9:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c0104a00:	00 
c0104a01:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104a08:	e8 c5 c2 ff ff       	call   c0100cd2 <__panic>

    p2 = alloc_page();
c0104a0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a14:	e8 70 f3 ff ff       	call   c0103d89 <alloc_pages>
c0104a19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104a1c:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104a21:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104a28:	00 
c0104a29:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104a30:	00 
c0104a31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104a34:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a38:	89 04 24             	mov    %eax,(%esp)
c0104a3b:	e8 3b fc ff ff       	call   c010467b <page_insert>
c0104a40:	85 c0                	test   %eax,%eax
c0104a42:	74 24                	je     c0104a68 <check_pgdir+0x2b9>
c0104a44:	c7 44 24 0c fc 6c 10 	movl   $0xc0106cfc,0xc(%esp)
c0104a4b:	c0 
c0104a4c:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104a53:	c0 
c0104a54:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0104a5b:	00 
c0104a5c:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104a63:	e8 6a c2 ff ff       	call   c0100cd2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104a68:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104a6d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a74:	00 
c0104a75:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a7c:	00 
c0104a7d:	89 04 24             	mov    %eax,(%esp)
c0104a80:	e8 c0 f9 ff ff       	call   c0104445 <get_pte>
c0104a85:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a88:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a8c:	75 24                	jne    c0104ab2 <check_pgdir+0x303>
c0104a8e:	c7 44 24 0c 34 6d 10 	movl   $0xc0106d34,0xc(%esp)
c0104a95:	c0 
c0104a96:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104a9d:	c0 
c0104a9e:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0104aa5:	00 
c0104aa6:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104aad:	e8 20 c2 ff ff       	call   c0100cd2 <__panic>
    assert(*ptep & PTE_U);
c0104ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ab5:	8b 00                	mov    (%eax),%eax
c0104ab7:	83 e0 04             	and    $0x4,%eax
c0104aba:	85 c0                	test   %eax,%eax
c0104abc:	75 24                	jne    c0104ae2 <check_pgdir+0x333>
c0104abe:	c7 44 24 0c 64 6d 10 	movl   $0xc0106d64,0xc(%esp)
c0104ac5:	c0 
c0104ac6:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104acd:	c0 
c0104ace:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0104ad5:	00 
c0104ad6:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104add:	e8 f0 c1 ff ff       	call   c0100cd2 <__panic>
    assert(*ptep & PTE_W);
c0104ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ae5:	8b 00                	mov    (%eax),%eax
c0104ae7:	83 e0 02             	and    $0x2,%eax
c0104aea:	85 c0                	test   %eax,%eax
c0104aec:	75 24                	jne    c0104b12 <check_pgdir+0x363>
c0104aee:	c7 44 24 0c 72 6d 10 	movl   $0xc0106d72,0xc(%esp)
c0104af5:	c0 
c0104af6:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104afd:	c0 
c0104afe:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c0104b05:	00 
c0104b06:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104b0d:	e8 c0 c1 ff ff       	call   c0100cd2 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104b12:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104b17:	8b 00                	mov    (%eax),%eax
c0104b19:	83 e0 04             	and    $0x4,%eax
c0104b1c:	85 c0                	test   %eax,%eax
c0104b1e:	75 24                	jne    c0104b44 <check_pgdir+0x395>
c0104b20:	c7 44 24 0c 80 6d 10 	movl   $0xc0106d80,0xc(%esp)
c0104b27:	c0 
c0104b28:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104b2f:	c0 
c0104b30:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0104b37:	00 
c0104b38:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104b3f:	e8 8e c1 ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p2) == 1);
c0104b44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b47:	89 04 24             	mov    %eax,(%esp)
c0104b4a:	e8 35 f0 ff ff       	call   c0103b84 <page_ref>
c0104b4f:	83 f8 01             	cmp    $0x1,%eax
c0104b52:	74 24                	je     c0104b78 <check_pgdir+0x3c9>
c0104b54:	c7 44 24 0c 96 6d 10 	movl   $0xc0106d96,0xc(%esp)
c0104b5b:	c0 
c0104b5c:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104b63:	c0 
c0104b64:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0104b6b:	00 
c0104b6c:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104b73:	e8 5a c1 ff ff       	call   c0100cd2 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104b78:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104b7d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104b84:	00 
c0104b85:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104b8c:	00 
c0104b8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104b90:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104b94:	89 04 24             	mov    %eax,(%esp)
c0104b97:	e8 df fa ff ff       	call   c010467b <page_insert>
c0104b9c:	85 c0                	test   %eax,%eax
c0104b9e:	74 24                	je     c0104bc4 <check_pgdir+0x415>
c0104ba0:	c7 44 24 0c a8 6d 10 	movl   $0xc0106da8,0xc(%esp)
c0104ba7:	c0 
c0104ba8:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104baf:	c0 
c0104bb0:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0104bb7:	00 
c0104bb8:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104bbf:	e8 0e c1 ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p1) == 2);
c0104bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bc7:	89 04 24             	mov    %eax,(%esp)
c0104bca:	e8 b5 ef ff ff       	call   c0103b84 <page_ref>
c0104bcf:	83 f8 02             	cmp    $0x2,%eax
c0104bd2:	74 24                	je     c0104bf8 <check_pgdir+0x449>
c0104bd4:	c7 44 24 0c d4 6d 10 	movl   $0xc0106dd4,0xc(%esp)
c0104bdb:	c0 
c0104bdc:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104be3:	c0 
c0104be4:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0104beb:	00 
c0104bec:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104bf3:	e8 da c0 ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p2) == 0);
c0104bf8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bfb:	89 04 24             	mov    %eax,(%esp)
c0104bfe:	e8 81 ef ff ff       	call   c0103b84 <page_ref>
c0104c03:	85 c0                	test   %eax,%eax
c0104c05:	74 24                	je     c0104c2b <check_pgdir+0x47c>
c0104c07:	c7 44 24 0c e6 6d 10 	movl   $0xc0106de6,0xc(%esp)
c0104c0e:	c0 
c0104c0f:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104c16:	c0 
c0104c17:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0104c1e:	00 
c0104c1f:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104c26:	e8 a7 c0 ff ff       	call   c0100cd2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104c2b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104c30:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c37:	00 
c0104c38:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c3f:	00 
c0104c40:	89 04 24             	mov    %eax,(%esp)
c0104c43:	e8 fd f7 ff ff       	call   c0104445 <get_pte>
c0104c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c4f:	75 24                	jne    c0104c75 <check_pgdir+0x4c6>
c0104c51:	c7 44 24 0c 34 6d 10 	movl   $0xc0106d34,0xc(%esp)
c0104c58:	c0 
c0104c59:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104c60:	c0 
c0104c61:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0104c68:	00 
c0104c69:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104c70:	e8 5d c0 ff ff       	call   c0100cd2 <__panic>
    assert(pte2page(*ptep) == p1);
c0104c75:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c78:	8b 00                	mov    (%eax),%eax
c0104c7a:	89 04 24             	mov    %eax,(%esp)
c0104c7d:	e8 ac ee ff ff       	call   c0103b2e <pte2page>
c0104c82:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104c85:	74 24                	je     c0104cab <check_pgdir+0x4fc>
c0104c87:	c7 44 24 0c a9 6c 10 	movl   $0xc0106ca9,0xc(%esp)
c0104c8e:	c0 
c0104c8f:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104c96:	c0 
c0104c97:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0104c9e:	00 
c0104c9f:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104ca6:	e8 27 c0 ff ff       	call   c0100cd2 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cae:	8b 00                	mov    (%eax),%eax
c0104cb0:	83 e0 04             	and    $0x4,%eax
c0104cb3:	85 c0                	test   %eax,%eax
c0104cb5:	74 24                	je     c0104cdb <check_pgdir+0x52c>
c0104cb7:	c7 44 24 0c f8 6d 10 	movl   $0xc0106df8,0xc(%esp)
c0104cbe:	c0 
c0104cbf:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104cc6:	c0 
c0104cc7:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0104cce:	00 
c0104ccf:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104cd6:	e8 f7 bf ff ff       	call   c0100cd2 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104cdb:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104ce0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ce7:	00 
c0104ce8:	89 04 24             	mov    %eax,(%esp)
c0104ceb:	e8 47 f9 ff ff       	call   c0104637 <page_remove>
    assert(page_ref(p1) == 1);
c0104cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cf3:	89 04 24             	mov    %eax,(%esp)
c0104cf6:	e8 89 ee ff ff       	call   c0103b84 <page_ref>
c0104cfb:	83 f8 01             	cmp    $0x1,%eax
c0104cfe:	74 24                	je     c0104d24 <check_pgdir+0x575>
c0104d00:	c7 44 24 0c bf 6c 10 	movl   $0xc0106cbf,0xc(%esp)
c0104d07:	c0 
c0104d08:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104d0f:	c0 
c0104d10:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104d17:	00 
c0104d18:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104d1f:	e8 ae bf ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p2) == 0);
c0104d24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d27:	89 04 24             	mov    %eax,(%esp)
c0104d2a:	e8 55 ee ff ff       	call   c0103b84 <page_ref>
c0104d2f:	85 c0                	test   %eax,%eax
c0104d31:	74 24                	je     c0104d57 <check_pgdir+0x5a8>
c0104d33:	c7 44 24 0c e6 6d 10 	movl   $0xc0106de6,0xc(%esp)
c0104d3a:	c0 
c0104d3b:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104d42:	c0 
c0104d43:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104d4a:	00 
c0104d4b:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104d52:	e8 7b bf ff ff       	call   c0100cd2 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104d57:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104d5c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104d63:	00 
c0104d64:	89 04 24             	mov    %eax,(%esp)
c0104d67:	e8 cb f8 ff ff       	call   c0104637 <page_remove>
    assert(page_ref(p1) == 0);
c0104d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d6f:	89 04 24             	mov    %eax,(%esp)
c0104d72:	e8 0d ee ff ff       	call   c0103b84 <page_ref>
c0104d77:	85 c0                	test   %eax,%eax
c0104d79:	74 24                	je     c0104d9f <check_pgdir+0x5f0>
c0104d7b:	c7 44 24 0c 0d 6e 10 	movl   $0xc0106e0d,0xc(%esp)
c0104d82:	c0 
c0104d83:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104d8a:	c0 
c0104d8b:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0104d92:	00 
c0104d93:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104d9a:	e8 33 bf ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p2) == 0);
c0104d9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104da2:	89 04 24             	mov    %eax,(%esp)
c0104da5:	e8 da ed ff ff       	call   c0103b84 <page_ref>
c0104daa:	85 c0                	test   %eax,%eax
c0104dac:	74 24                	je     c0104dd2 <check_pgdir+0x623>
c0104dae:	c7 44 24 0c e6 6d 10 	movl   $0xc0106de6,0xc(%esp)
c0104db5:	c0 
c0104db6:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104dbd:	c0 
c0104dbe:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104dc5:	00 
c0104dc6:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104dcd:	e8 00 bf ff ff       	call   c0100cd2 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104dd2:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104dd7:	8b 00                	mov    (%eax),%eax
c0104dd9:	89 04 24             	mov    %eax,(%esp)
c0104ddc:	e8 8b ed ff ff       	call   c0103b6c <pde2page>
c0104de1:	89 04 24             	mov    %eax,(%esp)
c0104de4:	e8 9b ed ff ff       	call   c0103b84 <page_ref>
c0104de9:	83 f8 01             	cmp    $0x1,%eax
c0104dec:	74 24                	je     c0104e12 <check_pgdir+0x663>
c0104dee:	c7 44 24 0c 20 6e 10 	movl   $0xc0106e20,0xc(%esp)
c0104df5:	c0 
c0104df6:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104dfd:	c0 
c0104dfe:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104e05:	00 
c0104e06:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104e0d:	e8 c0 be ff ff       	call   c0100cd2 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104e12:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104e17:	8b 00                	mov    (%eax),%eax
c0104e19:	89 04 24             	mov    %eax,(%esp)
c0104e1c:	e8 4b ed ff ff       	call   c0103b6c <pde2page>
c0104e21:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e28:	00 
c0104e29:	89 04 24             	mov    %eax,(%esp)
c0104e2c:	e8 90 ef ff ff       	call   c0103dc1 <free_pages>
    boot_pgdir[0] = 0;
c0104e31:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104e36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104e3c:	c7 04 24 47 6e 10 c0 	movl   $0xc0106e47,(%esp)
c0104e43:	e8 00 b5 ff ff       	call   c0100348 <cprintf>
}
c0104e48:	c9                   	leave  
c0104e49:	c3                   	ret    

c0104e4a <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104e4a:	55                   	push   %ebp
c0104e4b:	89 e5                	mov    %esp,%ebp
c0104e4d:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104e50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104e57:	e9 ca 00 00 00       	jmp    c0104f26 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e65:	c1 e8 0c             	shr    $0xc,%eax
c0104e68:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e6b:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104e70:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104e73:	72 23                	jb     c0104e98 <check_boot_pgdir+0x4e>
c0104e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e78:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e7c:	c7 44 24 08 8c 6a 10 	movl   $0xc0106a8c,0x8(%esp)
c0104e83:	c0 
c0104e84:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104e8b:	00 
c0104e8c:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104e93:	e8 3a be ff ff       	call   c0100cd2 <__panic>
c0104e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e9b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104ea0:	89 c2                	mov    %eax,%edx
c0104ea2:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104ea7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104eae:	00 
c0104eaf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104eb3:	89 04 24             	mov    %eax,(%esp)
c0104eb6:	e8 8a f5 ff ff       	call   c0104445 <get_pte>
c0104ebb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104ebe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104ec2:	75 24                	jne    c0104ee8 <check_boot_pgdir+0x9e>
c0104ec4:	c7 44 24 0c 64 6e 10 	movl   $0xc0106e64,0xc(%esp)
c0104ecb:	c0 
c0104ecc:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104ed3:	c0 
c0104ed4:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104edb:	00 
c0104edc:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104ee3:	e8 ea bd ff ff       	call   c0100cd2 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104ee8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104eeb:	8b 00                	mov    (%eax),%eax
c0104eed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104ef2:	89 c2                	mov    %eax,%edx
c0104ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ef7:	39 c2                	cmp    %eax,%edx
c0104ef9:	74 24                	je     c0104f1f <check_boot_pgdir+0xd5>
c0104efb:	c7 44 24 0c a1 6e 10 	movl   $0xc0106ea1,0xc(%esp)
c0104f02:	c0 
c0104f03:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104f0a:	c0 
c0104f0b:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104f12:	00 
c0104f13:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104f1a:	e8 b3 bd ff ff       	call   c0100cd2 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104f1f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104f26:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104f29:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104f2e:	39 c2                	cmp    %eax,%edx
c0104f30:	0f 82 26 ff ff ff    	jb     c0104e5c <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104f36:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104f3b:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104f40:	8b 00                	mov    (%eax),%eax
c0104f42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f47:	89 c2                	mov    %eax,%edx
c0104f49:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104f4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f51:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104f58:	77 23                	ja     c0104f7d <check_boot_pgdir+0x133>
c0104f5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f5d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f61:	c7 44 24 08 30 6b 10 	movl   $0xc0106b30,0x8(%esp)
c0104f68:	c0 
c0104f69:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104f70:	00 
c0104f71:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104f78:	e8 55 bd ff ff       	call   c0100cd2 <__panic>
c0104f7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f80:	05 00 00 00 40       	add    $0x40000000,%eax
c0104f85:	39 c2                	cmp    %eax,%edx
c0104f87:	74 24                	je     c0104fad <check_boot_pgdir+0x163>
c0104f89:	c7 44 24 0c b8 6e 10 	movl   $0xc0106eb8,0xc(%esp)
c0104f90:	c0 
c0104f91:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104f98:	c0 
c0104f99:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104fa0:	00 
c0104fa1:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104fa8:	e8 25 bd ff ff       	call   c0100cd2 <__panic>

    assert(boot_pgdir[0] == 0);
c0104fad:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104fb2:	8b 00                	mov    (%eax),%eax
c0104fb4:	85 c0                	test   %eax,%eax
c0104fb6:	74 24                	je     c0104fdc <check_boot_pgdir+0x192>
c0104fb8:	c7 44 24 0c ec 6e 10 	movl   $0xc0106eec,0xc(%esp)
c0104fbf:	c0 
c0104fc0:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0104fc7:	c0 
c0104fc8:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104fcf:	00 
c0104fd0:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104fd7:	e8 f6 bc ff ff       	call   c0100cd2 <__panic>

    struct Page *p;
    p = alloc_page();
c0104fdc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104fe3:	e8 a1 ed ff ff       	call   c0103d89 <alloc_pages>
c0104fe8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104feb:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104ff0:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104ff7:	00 
c0104ff8:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104fff:	00 
c0105000:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105003:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105007:	89 04 24             	mov    %eax,(%esp)
c010500a:	e8 6c f6 ff ff       	call   c010467b <page_insert>
c010500f:	85 c0                	test   %eax,%eax
c0105011:	74 24                	je     c0105037 <check_boot_pgdir+0x1ed>
c0105013:	c7 44 24 0c 00 6f 10 	movl   $0xc0106f00,0xc(%esp)
c010501a:	c0 
c010501b:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0105022:	c0 
c0105023:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c010502a:	00 
c010502b:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0105032:	e8 9b bc ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p) == 1);
c0105037:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010503a:	89 04 24             	mov    %eax,(%esp)
c010503d:	e8 42 eb ff ff       	call   c0103b84 <page_ref>
c0105042:	83 f8 01             	cmp    $0x1,%eax
c0105045:	74 24                	je     c010506b <check_boot_pgdir+0x221>
c0105047:	c7 44 24 0c 2e 6f 10 	movl   $0xc0106f2e,0xc(%esp)
c010504e:	c0 
c010504f:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0105056:	c0 
c0105057:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c010505e:	00 
c010505f:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0105066:	e8 67 bc ff ff       	call   c0100cd2 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c010506b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0105070:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105077:	00 
c0105078:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010507f:	00 
c0105080:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105083:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105087:	89 04 24             	mov    %eax,(%esp)
c010508a:	e8 ec f5 ff ff       	call   c010467b <page_insert>
c010508f:	85 c0                	test   %eax,%eax
c0105091:	74 24                	je     c01050b7 <check_boot_pgdir+0x26d>
c0105093:	c7 44 24 0c 40 6f 10 	movl   $0xc0106f40,0xc(%esp)
c010509a:	c0 
c010509b:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c01050a2:	c0 
c01050a3:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c01050aa:	00 
c01050ab:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c01050b2:	e8 1b bc ff ff       	call   c0100cd2 <__panic>
    assert(page_ref(p) == 2);
c01050b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050ba:	89 04 24             	mov    %eax,(%esp)
c01050bd:	e8 c2 ea ff ff       	call   c0103b84 <page_ref>
c01050c2:	83 f8 02             	cmp    $0x2,%eax
c01050c5:	74 24                	je     c01050eb <check_boot_pgdir+0x2a1>
c01050c7:	c7 44 24 0c 77 6f 10 	movl   $0xc0106f77,0xc(%esp)
c01050ce:	c0 
c01050cf:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c01050d6:	c0 
c01050d7:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c01050de:	00 
c01050df:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c01050e6:	e8 e7 bb ff ff       	call   c0100cd2 <__panic>

    const char *str = "ucore: Hello world!!";
c01050eb:	c7 45 dc 88 6f 10 c0 	movl   $0xc0106f88,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01050f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050f9:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105100:	e8 19 0a 00 00       	call   c0105b1e <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105105:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c010510c:	00 
c010510d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105114:	e8 7e 0a 00 00       	call   c0105b97 <strcmp>
c0105119:	85 c0                	test   %eax,%eax
c010511b:	74 24                	je     c0105141 <check_boot_pgdir+0x2f7>
c010511d:	c7 44 24 0c a0 6f 10 	movl   $0xc0106fa0,0xc(%esp)
c0105124:	c0 
c0105125:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c010512c:	c0 
c010512d:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0105134:	00 
c0105135:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c010513c:	e8 91 bb ff ff       	call   c0100cd2 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105141:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105144:	89 04 24             	mov    %eax,(%esp)
c0105147:	e8 8e e9 ff ff       	call   c0103ada <page2kva>
c010514c:	05 00 01 00 00       	add    $0x100,%eax
c0105151:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105154:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010515b:	e8 66 09 00 00       	call   c0105ac6 <strlen>
c0105160:	85 c0                	test   %eax,%eax
c0105162:	74 24                	je     c0105188 <check_boot_pgdir+0x33e>
c0105164:	c7 44 24 0c d8 6f 10 	movl   $0xc0106fd8,0xc(%esp)
c010516b:	c0 
c010516c:	c7 44 24 08 79 6b 10 	movl   $0xc0106b79,0x8(%esp)
c0105173:	c0 
c0105174:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c010517b:	00 
c010517c:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0105183:	e8 4a bb ff ff       	call   c0100cd2 <__panic>

    free_page(p);
c0105188:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010518f:	00 
c0105190:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105193:	89 04 24             	mov    %eax,(%esp)
c0105196:	e8 26 ec ff ff       	call   c0103dc1 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c010519b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01051a0:	8b 00                	mov    (%eax),%eax
c01051a2:	89 04 24             	mov    %eax,(%esp)
c01051a5:	e8 c2 e9 ff ff       	call   c0103b6c <pde2page>
c01051aa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051b1:	00 
c01051b2:	89 04 24             	mov    %eax,(%esp)
c01051b5:	e8 07 ec ff ff       	call   c0103dc1 <free_pages>
    boot_pgdir[0] = 0;
c01051ba:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01051bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01051c5:	c7 04 24 fc 6f 10 c0 	movl   $0xc0106ffc,(%esp)
c01051cc:	e8 77 b1 ff ff       	call   c0100348 <cprintf>
}
c01051d1:	c9                   	leave  
c01051d2:	c3                   	ret    

c01051d3 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01051d3:	55                   	push   %ebp
c01051d4:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01051d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01051d9:	83 e0 04             	and    $0x4,%eax
c01051dc:	85 c0                	test   %eax,%eax
c01051de:	74 07                	je     c01051e7 <perm2str+0x14>
c01051e0:	b8 75 00 00 00       	mov    $0x75,%eax
c01051e5:	eb 05                	jmp    c01051ec <perm2str+0x19>
c01051e7:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01051ec:	a2 08 af 11 c0       	mov    %al,0xc011af08
    str[1] = 'r';
c01051f1:	c6 05 09 af 11 c0 72 	movb   $0x72,0xc011af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01051f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01051fb:	83 e0 02             	and    $0x2,%eax
c01051fe:	85 c0                	test   %eax,%eax
c0105200:	74 07                	je     c0105209 <perm2str+0x36>
c0105202:	b8 77 00 00 00       	mov    $0x77,%eax
c0105207:	eb 05                	jmp    c010520e <perm2str+0x3b>
c0105209:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010520e:	a2 0a af 11 c0       	mov    %al,0xc011af0a
    str[3] = '\0';
c0105213:	c6 05 0b af 11 c0 00 	movb   $0x0,0xc011af0b
    return str;
c010521a:	b8 08 af 11 c0       	mov    $0xc011af08,%eax
}
c010521f:	5d                   	pop    %ebp
c0105220:	c3                   	ret    

c0105221 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105221:	55                   	push   %ebp
c0105222:	89 e5                	mov    %esp,%ebp
c0105224:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105227:	8b 45 10             	mov    0x10(%ebp),%eax
c010522a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010522d:	72 0a                	jb     c0105239 <get_pgtable_items+0x18>
        return 0;
c010522f:	b8 00 00 00 00       	mov    $0x0,%eax
c0105234:	e9 9c 00 00 00       	jmp    c01052d5 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105239:	eb 04                	jmp    c010523f <get_pgtable_items+0x1e>
        start ++;
c010523b:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c010523f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105242:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105245:	73 18                	jae    c010525f <get_pgtable_items+0x3e>
c0105247:	8b 45 10             	mov    0x10(%ebp),%eax
c010524a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105251:	8b 45 14             	mov    0x14(%ebp),%eax
c0105254:	01 d0                	add    %edx,%eax
c0105256:	8b 00                	mov    (%eax),%eax
c0105258:	83 e0 01             	and    $0x1,%eax
c010525b:	85 c0                	test   %eax,%eax
c010525d:	74 dc                	je     c010523b <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c010525f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105262:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105265:	73 69                	jae    c01052d0 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105267:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010526b:	74 08                	je     c0105275 <get_pgtable_items+0x54>
            *left_store = start;
c010526d:	8b 45 18             	mov    0x18(%ebp),%eax
c0105270:	8b 55 10             	mov    0x10(%ebp),%edx
c0105273:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105275:	8b 45 10             	mov    0x10(%ebp),%eax
c0105278:	8d 50 01             	lea    0x1(%eax),%edx
c010527b:	89 55 10             	mov    %edx,0x10(%ebp)
c010527e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105285:	8b 45 14             	mov    0x14(%ebp),%eax
c0105288:	01 d0                	add    %edx,%eax
c010528a:	8b 00                	mov    (%eax),%eax
c010528c:	83 e0 07             	and    $0x7,%eax
c010528f:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105292:	eb 04                	jmp    c0105298 <get_pgtable_items+0x77>
            start ++;
c0105294:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105298:	8b 45 10             	mov    0x10(%ebp),%eax
c010529b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010529e:	73 1d                	jae    c01052bd <get_pgtable_items+0x9c>
c01052a0:	8b 45 10             	mov    0x10(%ebp),%eax
c01052a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01052aa:	8b 45 14             	mov    0x14(%ebp),%eax
c01052ad:	01 d0                	add    %edx,%eax
c01052af:	8b 00                	mov    (%eax),%eax
c01052b1:	83 e0 07             	and    $0x7,%eax
c01052b4:	89 c2                	mov    %eax,%edx
c01052b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052b9:	39 c2                	cmp    %eax,%edx
c01052bb:	74 d7                	je     c0105294 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01052bd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01052c1:	74 08                	je     c01052cb <get_pgtable_items+0xaa>
            *right_store = start;
c01052c3:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01052c6:	8b 55 10             	mov    0x10(%ebp),%edx
c01052c9:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01052cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052ce:	eb 05                	jmp    c01052d5 <get_pgtable_items+0xb4>
    }
    return 0;
c01052d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01052d5:	c9                   	leave  
c01052d6:	c3                   	ret    

c01052d7 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01052d7:	55                   	push   %ebp
c01052d8:	89 e5                	mov    %esp,%ebp
c01052da:	57                   	push   %edi
c01052db:	56                   	push   %esi
c01052dc:	53                   	push   %ebx
c01052dd:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01052e0:	c7 04 24 1c 70 10 c0 	movl   $0xc010701c,(%esp)
c01052e7:	e8 5c b0 ff ff       	call   c0100348 <cprintf>
    size_t left, right = 0, perm;
c01052ec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01052f3:	e9 fa 00 00 00       	jmp    c01053f2 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01052f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052fb:	89 04 24             	mov    %eax,(%esp)
c01052fe:	e8 d0 fe ff ff       	call   c01051d3 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105303:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105306:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105309:	29 d1                	sub    %edx,%ecx
c010530b:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010530d:	89 d6                	mov    %edx,%esi
c010530f:	c1 e6 16             	shl    $0x16,%esi
c0105312:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105315:	89 d3                	mov    %edx,%ebx
c0105317:	c1 e3 16             	shl    $0x16,%ebx
c010531a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010531d:	89 d1                	mov    %edx,%ecx
c010531f:	c1 e1 16             	shl    $0x16,%ecx
c0105322:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105325:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105328:	29 d7                	sub    %edx,%edi
c010532a:	89 fa                	mov    %edi,%edx
c010532c:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105330:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105334:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105338:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010533c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105340:	c7 04 24 4d 70 10 c0 	movl   $0xc010704d,(%esp)
c0105347:	e8 fc af ff ff       	call   c0100348 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c010534c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010534f:	c1 e0 0a             	shl    $0xa,%eax
c0105352:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105355:	eb 54                	jmp    c01053ab <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105357:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010535a:	89 04 24             	mov    %eax,(%esp)
c010535d:	e8 71 fe ff ff       	call   c01051d3 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105362:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105365:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105368:	29 d1                	sub    %edx,%ecx
c010536a:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010536c:	89 d6                	mov    %edx,%esi
c010536e:	c1 e6 0c             	shl    $0xc,%esi
c0105371:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105374:	89 d3                	mov    %edx,%ebx
c0105376:	c1 e3 0c             	shl    $0xc,%ebx
c0105379:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010537c:	c1 e2 0c             	shl    $0xc,%edx
c010537f:	89 d1                	mov    %edx,%ecx
c0105381:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105384:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105387:	29 d7                	sub    %edx,%edi
c0105389:	89 fa                	mov    %edi,%edx
c010538b:	89 44 24 14          	mov    %eax,0x14(%esp)
c010538f:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105393:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105397:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010539b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010539f:	c7 04 24 6c 70 10 c0 	movl   $0xc010706c,(%esp)
c01053a6:	e8 9d af ff ff       	call   c0100348 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01053ab:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01053b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01053b3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01053b6:	89 ce                	mov    %ecx,%esi
c01053b8:	c1 e6 0a             	shl    $0xa,%esi
c01053bb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01053be:	89 cb                	mov    %ecx,%ebx
c01053c0:	c1 e3 0a             	shl    $0xa,%ebx
c01053c3:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01053c6:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01053ca:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01053cd:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01053d1:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01053d5:	89 44 24 08          	mov    %eax,0x8(%esp)
c01053d9:	89 74 24 04          	mov    %esi,0x4(%esp)
c01053dd:	89 1c 24             	mov    %ebx,(%esp)
c01053e0:	e8 3c fe ff ff       	call   c0105221 <get_pgtable_items>
c01053e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01053ec:	0f 85 65 ff ff ff    	jne    c0105357 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01053f2:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c01053f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01053fa:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01053fd:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105401:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105404:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105408:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010540c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105410:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105417:	00 
c0105418:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010541f:	e8 fd fd ff ff       	call   c0105221 <get_pgtable_items>
c0105424:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105427:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010542b:	0f 85 c7 fe ff ff    	jne    c01052f8 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105431:	c7 04 24 90 70 10 c0 	movl   $0xc0107090,(%esp)
c0105438:	e8 0b af ff ff       	call   c0100348 <cprintf>
}
c010543d:	83 c4 4c             	add    $0x4c,%esp
c0105440:	5b                   	pop    %ebx
c0105441:	5e                   	pop    %esi
c0105442:	5f                   	pop    %edi
c0105443:	5d                   	pop    %ebp
c0105444:	c3                   	ret    

c0105445 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105445:	55                   	push   %ebp
c0105446:	89 e5                	mov    %esp,%ebp
c0105448:	83 ec 58             	sub    $0x58,%esp
c010544b:	8b 45 10             	mov    0x10(%ebp),%eax
c010544e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105451:	8b 45 14             	mov    0x14(%ebp),%eax
c0105454:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105457:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010545a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010545d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105460:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105463:	8b 45 18             	mov    0x18(%ebp),%eax
c0105466:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105469:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010546c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010546f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105472:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105475:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105478:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010547b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010547f:	74 1c                	je     c010549d <printnum+0x58>
c0105481:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105484:	ba 00 00 00 00       	mov    $0x0,%edx
c0105489:	f7 75 e4             	divl   -0x1c(%ebp)
c010548c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010548f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105492:	ba 00 00 00 00       	mov    $0x0,%edx
c0105497:	f7 75 e4             	divl   -0x1c(%ebp)
c010549a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010549d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054a3:	f7 75 e4             	divl   -0x1c(%ebp)
c01054a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01054ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054af:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01054b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01054b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054bb:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01054be:	8b 45 18             	mov    0x18(%ebp),%eax
c01054c1:	ba 00 00 00 00       	mov    $0x0,%edx
c01054c6:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054c9:	77 56                	ja     c0105521 <printnum+0xdc>
c01054cb:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054ce:	72 05                	jb     c01054d5 <printnum+0x90>
c01054d0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01054d3:	77 4c                	ja     c0105521 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01054d5:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01054d8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01054db:	8b 45 20             	mov    0x20(%ebp),%eax
c01054de:	89 44 24 18          	mov    %eax,0x18(%esp)
c01054e2:	89 54 24 14          	mov    %edx,0x14(%esp)
c01054e6:	8b 45 18             	mov    0x18(%ebp),%eax
c01054e9:	89 44 24 10          	mov    %eax,0x10(%esp)
c01054ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01054f3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01054f7:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01054fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105502:	8b 45 08             	mov    0x8(%ebp),%eax
c0105505:	89 04 24             	mov    %eax,(%esp)
c0105508:	e8 38 ff ff ff       	call   c0105445 <printnum>
c010550d:	eb 1c                	jmp    c010552b <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010550f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105512:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105516:	8b 45 20             	mov    0x20(%ebp),%eax
c0105519:	89 04 24             	mov    %eax,(%esp)
c010551c:	8b 45 08             	mov    0x8(%ebp),%eax
c010551f:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0105521:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105525:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105529:	7f e4                	jg     c010550f <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010552b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010552e:	05 44 71 10 c0       	add    $0xc0107144,%eax
c0105533:	0f b6 00             	movzbl (%eax),%eax
c0105536:	0f be c0             	movsbl %al,%eax
c0105539:	8b 55 0c             	mov    0xc(%ebp),%edx
c010553c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105540:	89 04 24             	mov    %eax,(%esp)
c0105543:	8b 45 08             	mov    0x8(%ebp),%eax
c0105546:	ff d0                	call   *%eax
}
c0105548:	c9                   	leave  
c0105549:	c3                   	ret    

c010554a <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010554a:	55                   	push   %ebp
c010554b:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010554d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105551:	7e 14                	jle    c0105567 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105553:	8b 45 08             	mov    0x8(%ebp),%eax
c0105556:	8b 00                	mov    (%eax),%eax
c0105558:	8d 48 08             	lea    0x8(%eax),%ecx
c010555b:	8b 55 08             	mov    0x8(%ebp),%edx
c010555e:	89 0a                	mov    %ecx,(%edx)
c0105560:	8b 50 04             	mov    0x4(%eax),%edx
c0105563:	8b 00                	mov    (%eax),%eax
c0105565:	eb 30                	jmp    c0105597 <getuint+0x4d>
    }
    else if (lflag) {
c0105567:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010556b:	74 16                	je     c0105583 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010556d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105570:	8b 00                	mov    (%eax),%eax
c0105572:	8d 48 04             	lea    0x4(%eax),%ecx
c0105575:	8b 55 08             	mov    0x8(%ebp),%edx
c0105578:	89 0a                	mov    %ecx,(%edx)
c010557a:	8b 00                	mov    (%eax),%eax
c010557c:	ba 00 00 00 00       	mov    $0x0,%edx
c0105581:	eb 14                	jmp    c0105597 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105583:	8b 45 08             	mov    0x8(%ebp),%eax
c0105586:	8b 00                	mov    (%eax),%eax
c0105588:	8d 48 04             	lea    0x4(%eax),%ecx
c010558b:	8b 55 08             	mov    0x8(%ebp),%edx
c010558e:	89 0a                	mov    %ecx,(%edx)
c0105590:	8b 00                	mov    (%eax),%eax
c0105592:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105597:	5d                   	pop    %ebp
c0105598:	c3                   	ret    

c0105599 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105599:	55                   	push   %ebp
c010559a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010559c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01055a0:	7e 14                	jle    c01055b6 <getint+0x1d>
        return va_arg(*ap, long long);
c01055a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a5:	8b 00                	mov    (%eax),%eax
c01055a7:	8d 48 08             	lea    0x8(%eax),%ecx
c01055aa:	8b 55 08             	mov    0x8(%ebp),%edx
c01055ad:	89 0a                	mov    %ecx,(%edx)
c01055af:	8b 50 04             	mov    0x4(%eax),%edx
c01055b2:	8b 00                	mov    (%eax),%eax
c01055b4:	eb 28                	jmp    c01055de <getint+0x45>
    }
    else if (lflag) {
c01055b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01055ba:	74 12                	je     c01055ce <getint+0x35>
        return va_arg(*ap, long);
c01055bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01055bf:	8b 00                	mov    (%eax),%eax
c01055c1:	8d 48 04             	lea    0x4(%eax),%ecx
c01055c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01055c7:	89 0a                	mov    %ecx,(%edx)
c01055c9:	8b 00                	mov    (%eax),%eax
c01055cb:	99                   	cltd   
c01055cc:	eb 10                	jmp    c01055de <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01055ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01055d1:	8b 00                	mov    (%eax),%eax
c01055d3:	8d 48 04             	lea    0x4(%eax),%ecx
c01055d6:	8b 55 08             	mov    0x8(%ebp),%edx
c01055d9:	89 0a                	mov    %ecx,(%edx)
c01055db:	8b 00                	mov    (%eax),%eax
c01055dd:	99                   	cltd   
    }
}
c01055de:	5d                   	pop    %ebp
c01055df:	c3                   	ret    

c01055e0 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01055e0:	55                   	push   %ebp
c01055e1:	89 e5                	mov    %esp,%ebp
c01055e3:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01055e6:	8d 45 14             	lea    0x14(%ebp),%eax
c01055e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01055ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01055f3:	8b 45 10             	mov    0x10(%ebp),%eax
c01055f6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01055fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105601:	8b 45 08             	mov    0x8(%ebp),%eax
c0105604:	89 04 24             	mov    %eax,(%esp)
c0105607:	e8 02 00 00 00       	call   c010560e <vprintfmt>
    va_end(ap);
}
c010560c:	c9                   	leave  
c010560d:	c3                   	ret    

c010560e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010560e:	55                   	push   %ebp
c010560f:	89 e5                	mov    %esp,%ebp
c0105611:	56                   	push   %esi
c0105612:	53                   	push   %ebx
c0105613:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105616:	eb 18                	jmp    c0105630 <vprintfmt+0x22>
            if (ch == '\0') {
c0105618:	85 db                	test   %ebx,%ebx
c010561a:	75 05                	jne    c0105621 <vprintfmt+0x13>
                return;
c010561c:	e9 d1 03 00 00       	jmp    c01059f2 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0105621:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105624:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105628:	89 1c 24             	mov    %ebx,(%esp)
c010562b:	8b 45 08             	mov    0x8(%ebp),%eax
c010562e:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105630:	8b 45 10             	mov    0x10(%ebp),%eax
c0105633:	8d 50 01             	lea    0x1(%eax),%edx
c0105636:	89 55 10             	mov    %edx,0x10(%ebp)
c0105639:	0f b6 00             	movzbl (%eax),%eax
c010563c:	0f b6 d8             	movzbl %al,%ebx
c010563f:	83 fb 25             	cmp    $0x25,%ebx
c0105642:	75 d4                	jne    c0105618 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105644:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105648:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010564f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105652:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105655:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010565c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010565f:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105662:	8b 45 10             	mov    0x10(%ebp),%eax
c0105665:	8d 50 01             	lea    0x1(%eax),%edx
c0105668:	89 55 10             	mov    %edx,0x10(%ebp)
c010566b:	0f b6 00             	movzbl (%eax),%eax
c010566e:	0f b6 d8             	movzbl %al,%ebx
c0105671:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105674:	83 f8 55             	cmp    $0x55,%eax
c0105677:	0f 87 44 03 00 00    	ja     c01059c1 <vprintfmt+0x3b3>
c010567d:	8b 04 85 68 71 10 c0 	mov    -0x3fef8e98(,%eax,4),%eax
c0105684:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105686:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010568a:	eb d6                	jmp    c0105662 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010568c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105690:	eb d0                	jmp    c0105662 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105692:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105699:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010569c:	89 d0                	mov    %edx,%eax
c010569e:	c1 e0 02             	shl    $0x2,%eax
c01056a1:	01 d0                	add    %edx,%eax
c01056a3:	01 c0                	add    %eax,%eax
c01056a5:	01 d8                	add    %ebx,%eax
c01056a7:	83 e8 30             	sub    $0x30,%eax
c01056aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01056ad:	8b 45 10             	mov    0x10(%ebp),%eax
c01056b0:	0f b6 00             	movzbl (%eax),%eax
c01056b3:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01056b6:	83 fb 2f             	cmp    $0x2f,%ebx
c01056b9:	7e 0b                	jle    c01056c6 <vprintfmt+0xb8>
c01056bb:	83 fb 39             	cmp    $0x39,%ebx
c01056be:	7f 06                	jg     c01056c6 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01056c0:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01056c4:	eb d3                	jmp    c0105699 <vprintfmt+0x8b>
            goto process_precision;
c01056c6:	eb 33                	jmp    c01056fb <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01056c8:	8b 45 14             	mov    0x14(%ebp),%eax
c01056cb:	8d 50 04             	lea    0x4(%eax),%edx
c01056ce:	89 55 14             	mov    %edx,0x14(%ebp)
c01056d1:	8b 00                	mov    (%eax),%eax
c01056d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01056d6:	eb 23                	jmp    c01056fb <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01056d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056dc:	79 0c                	jns    c01056ea <vprintfmt+0xdc>
                width = 0;
c01056de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01056e5:	e9 78 ff ff ff       	jmp    c0105662 <vprintfmt+0x54>
c01056ea:	e9 73 ff ff ff       	jmp    c0105662 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01056ef:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01056f6:	e9 67 ff ff ff       	jmp    c0105662 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01056fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056ff:	79 12                	jns    c0105713 <vprintfmt+0x105>
                width = precision, precision = -1;
c0105701:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105704:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105707:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010570e:	e9 4f ff ff ff       	jmp    c0105662 <vprintfmt+0x54>
c0105713:	e9 4a ff ff ff       	jmp    c0105662 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105718:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010571c:	e9 41 ff ff ff       	jmp    c0105662 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105721:	8b 45 14             	mov    0x14(%ebp),%eax
c0105724:	8d 50 04             	lea    0x4(%eax),%edx
c0105727:	89 55 14             	mov    %edx,0x14(%ebp)
c010572a:	8b 00                	mov    (%eax),%eax
c010572c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010572f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105733:	89 04 24             	mov    %eax,(%esp)
c0105736:	8b 45 08             	mov    0x8(%ebp),%eax
c0105739:	ff d0                	call   *%eax
            break;
c010573b:	e9 ac 02 00 00       	jmp    c01059ec <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105740:	8b 45 14             	mov    0x14(%ebp),%eax
c0105743:	8d 50 04             	lea    0x4(%eax),%edx
c0105746:	89 55 14             	mov    %edx,0x14(%ebp)
c0105749:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010574b:	85 db                	test   %ebx,%ebx
c010574d:	79 02                	jns    c0105751 <vprintfmt+0x143>
                err = -err;
c010574f:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105751:	83 fb 06             	cmp    $0x6,%ebx
c0105754:	7f 0b                	jg     c0105761 <vprintfmt+0x153>
c0105756:	8b 34 9d 28 71 10 c0 	mov    -0x3fef8ed8(,%ebx,4),%esi
c010575d:	85 f6                	test   %esi,%esi
c010575f:	75 23                	jne    c0105784 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0105761:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105765:	c7 44 24 08 55 71 10 	movl   $0xc0107155,0x8(%esp)
c010576c:	c0 
c010576d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105770:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105774:	8b 45 08             	mov    0x8(%ebp),%eax
c0105777:	89 04 24             	mov    %eax,(%esp)
c010577a:	e8 61 fe ff ff       	call   c01055e0 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010577f:	e9 68 02 00 00       	jmp    c01059ec <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105784:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105788:	c7 44 24 08 5e 71 10 	movl   $0xc010715e,0x8(%esp)
c010578f:	c0 
c0105790:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105793:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105797:	8b 45 08             	mov    0x8(%ebp),%eax
c010579a:	89 04 24             	mov    %eax,(%esp)
c010579d:	e8 3e fe ff ff       	call   c01055e0 <printfmt>
            }
            break;
c01057a2:	e9 45 02 00 00       	jmp    c01059ec <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01057a7:	8b 45 14             	mov    0x14(%ebp),%eax
c01057aa:	8d 50 04             	lea    0x4(%eax),%edx
c01057ad:	89 55 14             	mov    %edx,0x14(%ebp)
c01057b0:	8b 30                	mov    (%eax),%esi
c01057b2:	85 f6                	test   %esi,%esi
c01057b4:	75 05                	jne    c01057bb <vprintfmt+0x1ad>
                p = "(null)";
c01057b6:	be 61 71 10 c0       	mov    $0xc0107161,%esi
            }
            if (width > 0 && padc != '-') {
c01057bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057bf:	7e 3e                	jle    c01057ff <vprintfmt+0x1f1>
c01057c1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01057c5:	74 38                	je     c01057ff <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057c7:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01057ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057d1:	89 34 24             	mov    %esi,(%esp)
c01057d4:	e8 15 03 00 00       	call   c0105aee <strnlen>
c01057d9:	29 c3                	sub    %eax,%ebx
c01057db:	89 d8                	mov    %ebx,%eax
c01057dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057e0:	eb 17                	jmp    c01057f9 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01057e2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01057e6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01057e9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057ed:	89 04 24             	mov    %eax,(%esp)
c01057f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f3:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057f5:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01057f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057fd:	7f e3                	jg     c01057e2 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01057ff:	eb 38                	jmp    c0105839 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105801:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105805:	74 1f                	je     c0105826 <vprintfmt+0x218>
c0105807:	83 fb 1f             	cmp    $0x1f,%ebx
c010580a:	7e 05                	jle    c0105811 <vprintfmt+0x203>
c010580c:	83 fb 7e             	cmp    $0x7e,%ebx
c010580f:	7e 15                	jle    c0105826 <vprintfmt+0x218>
                    putch('?', putdat);
c0105811:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105814:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105818:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010581f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105822:	ff d0                	call   *%eax
c0105824:	eb 0f                	jmp    c0105835 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0105826:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105829:	89 44 24 04          	mov    %eax,0x4(%esp)
c010582d:	89 1c 24             	mov    %ebx,(%esp)
c0105830:	8b 45 08             	mov    0x8(%ebp),%eax
c0105833:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105835:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105839:	89 f0                	mov    %esi,%eax
c010583b:	8d 70 01             	lea    0x1(%eax),%esi
c010583e:	0f b6 00             	movzbl (%eax),%eax
c0105841:	0f be d8             	movsbl %al,%ebx
c0105844:	85 db                	test   %ebx,%ebx
c0105846:	74 10                	je     c0105858 <vprintfmt+0x24a>
c0105848:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010584c:	78 b3                	js     c0105801 <vprintfmt+0x1f3>
c010584e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105852:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105856:	79 a9                	jns    c0105801 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105858:	eb 17                	jmp    c0105871 <vprintfmt+0x263>
                putch(' ', putdat);
c010585a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010585d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105861:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105868:	8b 45 08             	mov    0x8(%ebp),%eax
c010586b:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010586d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105871:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105875:	7f e3                	jg     c010585a <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0105877:	e9 70 01 00 00       	jmp    c01059ec <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010587c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010587f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105883:	8d 45 14             	lea    0x14(%ebp),%eax
c0105886:	89 04 24             	mov    %eax,(%esp)
c0105889:	e8 0b fd ff ff       	call   c0105599 <getint>
c010588e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105891:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105894:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105897:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010589a:	85 d2                	test   %edx,%edx
c010589c:	79 26                	jns    c01058c4 <vprintfmt+0x2b6>
                putch('-', putdat);
c010589e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058a5:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01058ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01058af:	ff d0                	call   *%eax
                num = -(long long)num;
c01058b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058b7:	f7 d8                	neg    %eax
c01058b9:	83 d2 00             	adc    $0x0,%edx
c01058bc:	f7 da                	neg    %edx
c01058be:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01058c4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058cb:	e9 a8 00 00 00       	jmp    c0105978 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01058d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058d7:	8d 45 14             	lea    0x14(%ebp),%eax
c01058da:	89 04 24             	mov    %eax,(%esp)
c01058dd:	e8 68 fc ff ff       	call   c010554a <getuint>
c01058e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01058e8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058ef:	e9 84 00 00 00       	jmp    c0105978 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01058f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058fb:	8d 45 14             	lea    0x14(%ebp),%eax
c01058fe:	89 04 24             	mov    %eax,(%esp)
c0105901:	e8 44 fc ff ff       	call   c010554a <getuint>
c0105906:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105909:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010590c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105913:	eb 63                	jmp    c0105978 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105915:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105918:	89 44 24 04          	mov    %eax,0x4(%esp)
c010591c:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105923:	8b 45 08             	mov    0x8(%ebp),%eax
c0105926:	ff d0                	call   *%eax
            putch('x', putdat);
c0105928:	8b 45 0c             	mov    0xc(%ebp),%eax
c010592b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010592f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105936:	8b 45 08             	mov    0x8(%ebp),%eax
c0105939:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010593b:	8b 45 14             	mov    0x14(%ebp),%eax
c010593e:	8d 50 04             	lea    0x4(%eax),%edx
c0105941:	89 55 14             	mov    %edx,0x14(%ebp)
c0105944:	8b 00                	mov    (%eax),%eax
c0105946:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105949:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105950:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105957:	eb 1f                	jmp    c0105978 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105959:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010595c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105960:	8d 45 14             	lea    0x14(%ebp),%eax
c0105963:	89 04 24             	mov    %eax,(%esp)
c0105966:	e8 df fb ff ff       	call   c010554a <getuint>
c010596b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010596e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105971:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105978:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010597c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010597f:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105983:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105986:	89 54 24 14          	mov    %edx,0x14(%esp)
c010598a:	89 44 24 10          	mov    %eax,0x10(%esp)
c010598e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105991:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105994:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105998:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010599c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010599f:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01059a6:	89 04 24             	mov    %eax,(%esp)
c01059a9:	e8 97 fa ff ff       	call   c0105445 <printnum>
            break;
c01059ae:	eb 3c                	jmp    c01059ec <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01059b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059b7:	89 1c 24             	mov    %ebx,(%esp)
c01059ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01059bd:	ff d0                	call   *%eax
            break;
c01059bf:	eb 2b                	jmp    c01059ec <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01059c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059c4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059c8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01059cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01059d2:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01059d4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059d8:	eb 04                	jmp    c01059de <vprintfmt+0x3d0>
c01059da:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059de:	8b 45 10             	mov    0x10(%ebp),%eax
c01059e1:	83 e8 01             	sub    $0x1,%eax
c01059e4:	0f b6 00             	movzbl (%eax),%eax
c01059e7:	3c 25                	cmp    $0x25,%al
c01059e9:	75 ef                	jne    c01059da <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c01059eb:	90                   	nop
        }
    }
c01059ec:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01059ed:	e9 3e fc ff ff       	jmp    c0105630 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01059f2:	83 c4 40             	add    $0x40,%esp
c01059f5:	5b                   	pop    %ebx
c01059f6:	5e                   	pop    %esi
c01059f7:	5d                   	pop    %ebp
c01059f8:	c3                   	ret    

c01059f9 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01059f9:	55                   	push   %ebp
c01059fa:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01059fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ff:	8b 40 08             	mov    0x8(%eax),%eax
c0105a02:	8d 50 01             	lea    0x1(%eax),%edx
c0105a05:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a08:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a0e:	8b 10                	mov    (%eax),%edx
c0105a10:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a13:	8b 40 04             	mov    0x4(%eax),%eax
c0105a16:	39 c2                	cmp    %eax,%edx
c0105a18:	73 12                	jae    c0105a2c <sprintputch+0x33>
        *b->buf ++ = ch;
c0105a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a1d:	8b 00                	mov    (%eax),%eax
c0105a1f:	8d 48 01             	lea    0x1(%eax),%ecx
c0105a22:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a25:	89 0a                	mov    %ecx,(%edx)
c0105a27:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a2a:	88 10                	mov    %dl,(%eax)
    }
}
c0105a2c:	5d                   	pop    %ebp
c0105a2d:	c3                   	ret    

c0105a2e <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105a2e:	55                   	push   %ebp
c0105a2f:	89 e5                	mov    %esp,%ebp
c0105a31:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105a34:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a37:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a41:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a44:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a48:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a52:	89 04 24             	mov    %eax,(%esp)
c0105a55:	e8 08 00 00 00       	call   c0105a62 <vsnprintf>
c0105a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a60:	c9                   	leave  
c0105a61:	c3                   	ret    

c0105a62 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105a62:	55                   	push   %ebp
c0105a63:	89 e5                	mov    %esp,%ebp
c0105a65:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105a68:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a6e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a71:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a74:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a77:	01 d0                	add    %edx,%eax
c0105a79:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105a83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105a87:	74 0a                	je     c0105a93 <vsnprintf+0x31>
c0105a89:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a8f:	39 c2                	cmp    %eax,%edx
c0105a91:	76 07                	jbe    c0105a9a <vsnprintf+0x38>
        return -E_INVAL;
c0105a93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105a98:	eb 2a                	jmp    c0105ac4 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105a9a:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a9d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105aa1:	8b 45 10             	mov    0x10(%ebp),%eax
c0105aa4:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105aa8:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105aab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105aaf:	c7 04 24 f9 59 10 c0 	movl   $0xc01059f9,(%esp)
c0105ab6:	e8 53 fb ff ff       	call   c010560e <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105abb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105abe:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105ac4:	c9                   	leave  
c0105ac5:	c3                   	ret    

c0105ac6 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105ac6:	55                   	push   %ebp
c0105ac7:	89 e5                	mov    %esp,%ebp
c0105ac9:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105acc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105ad3:	eb 04                	jmp    c0105ad9 <strlen+0x13>
        cnt ++;
c0105ad5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105ad9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105adc:	8d 50 01             	lea    0x1(%eax),%edx
c0105adf:	89 55 08             	mov    %edx,0x8(%ebp)
c0105ae2:	0f b6 00             	movzbl (%eax),%eax
c0105ae5:	84 c0                	test   %al,%al
c0105ae7:	75 ec                	jne    c0105ad5 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105ae9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105aec:	c9                   	leave  
c0105aed:	c3                   	ret    

c0105aee <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105aee:	55                   	push   %ebp
c0105aef:	89 e5                	mov    %esp,%ebp
c0105af1:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105af4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105afb:	eb 04                	jmp    c0105b01 <strnlen+0x13>
        cnt ++;
c0105afd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105b01:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b04:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105b07:	73 10                	jae    c0105b19 <strnlen+0x2b>
c0105b09:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b0c:	8d 50 01             	lea    0x1(%eax),%edx
c0105b0f:	89 55 08             	mov    %edx,0x8(%ebp)
c0105b12:	0f b6 00             	movzbl (%eax),%eax
c0105b15:	84 c0                	test   %al,%al
c0105b17:	75 e4                	jne    c0105afd <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105b19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b1c:	c9                   	leave  
c0105b1d:	c3                   	ret    

c0105b1e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105b1e:	55                   	push   %ebp
c0105b1f:	89 e5                	mov    %esp,%ebp
c0105b21:	57                   	push   %edi
c0105b22:	56                   	push   %esi
c0105b23:	83 ec 20             	sub    $0x20,%esp
c0105b26:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105b32:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b38:	89 d1                	mov    %edx,%ecx
c0105b3a:	89 c2                	mov    %eax,%edx
c0105b3c:	89 ce                	mov    %ecx,%esi
c0105b3e:	89 d7                	mov    %edx,%edi
c0105b40:	ac                   	lods   %ds:(%esi),%al
c0105b41:	aa                   	stos   %al,%es:(%edi)
c0105b42:	84 c0                	test   %al,%al
c0105b44:	75 fa                	jne    c0105b40 <strcpy+0x22>
c0105b46:	89 fa                	mov    %edi,%edx
c0105b48:	89 f1                	mov    %esi,%ecx
c0105b4a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105b4d:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105b50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105b56:	83 c4 20             	add    $0x20,%esp
c0105b59:	5e                   	pop    %esi
c0105b5a:	5f                   	pop    %edi
c0105b5b:	5d                   	pop    %ebp
c0105b5c:	c3                   	ret    

c0105b5d <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105b5d:	55                   	push   %ebp
c0105b5e:	89 e5                	mov    %esp,%ebp
c0105b60:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105b63:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b66:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105b69:	eb 21                	jmp    c0105b8c <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b6e:	0f b6 10             	movzbl (%eax),%edx
c0105b71:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b74:	88 10                	mov    %dl,(%eax)
c0105b76:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b79:	0f b6 00             	movzbl (%eax),%eax
c0105b7c:	84 c0                	test   %al,%al
c0105b7e:	74 04                	je     c0105b84 <strncpy+0x27>
            src ++;
c0105b80:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105b84:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105b88:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105b8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b90:	75 d9                	jne    c0105b6b <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105b92:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105b95:	c9                   	leave  
c0105b96:	c3                   	ret    

c0105b97 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105b97:	55                   	push   %ebp
c0105b98:	89 e5                	mov    %esp,%ebp
c0105b9a:	57                   	push   %edi
c0105b9b:	56                   	push   %esi
c0105b9c:	83 ec 20             	sub    $0x20,%esp
c0105b9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ba8:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105bab:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bb1:	89 d1                	mov    %edx,%ecx
c0105bb3:	89 c2                	mov    %eax,%edx
c0105bb5:	89 ce                	mov    %ecx,%esi
c0105bb7:	89 d7                	mov    %edx,%edi
c0105bb9:	ac                   	lods   %ds:(%esi),%al
c0105bba:	ae                   	scas   %es:(%edi),%al
c0105bbb:	75 08                	jne    c0105bc5 <strcmp+0x2e>
c0105bbd:	84 c0                	test   %al,%al
c0105bbf:	75 f8                	jne    c0105bb9 <strcmp+0x22>
c0105bc1:	31 c0                	xor    %eax,%eax
c0105bc3:	eb 04                	jmp    c0105bc9 <strcmp+0x32>
c0105bc5:	19 c0                	sbb    %eax,%eax
c0105bc7:	0c 01                	or     $0x1,%al
c0105bc9:	89 fa                	mov    %edi,%edx
c0105bcb:	89 f1                	mov    %esi,%ecx
c0105bcd:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105bd0:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105bd3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105bd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105bd9:	83 c4 20             	add    $0x20,%esp
c0105bdc:	5e                   	pop    %esi
c0105bdd:	5f                   	pop    %edi
c0105bde:	5d                   	pop    %ebp
c0105bdf:	c3                   	ret    

c0105be0 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105be0:	55                   	push   %ebp
c0105be1:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105be3:	eb 0c                	jmp    c0105bf1 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105be5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105be9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105bed:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105bf1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bf5:	74 1a                	je     c0105c11 <strncmp+0x31>
c0105bf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bfa:	0f b6 00             	movzbl (%eax),%eax
c0105bfd:	84 c0                	test   %al,%al
c0105bff:	74 10                	je     c0105c11 <strncmp+0x31>
c0105c01:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c04:	0f b6 10             	movzbl (%eax),%edx
c0105c07:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c0a:	0f b6 00             	movzbl (%eax),%eax
c0105c0d:	38 c2                	cmp    %al,%dl
c0105c0f:	74 d4                	je     c0105be5 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105c11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c15:	74 18                	je     c0105c2f <strncmp+0x4f>
c0105c17:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c1a:	0f b6 00             	movzbl (%eax),%eax
c0105c1d:	0f b6 d0             	movzbl %al,%edx
c0105c20:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c23:	0f b6 00             	movzbl (%eax),%eax
c0105c26:	0f b6 c0             	movzbl %al,%eax
c0105c29:	29 c2                	sub    %eax,%edx
c0105c2b:	89 d0                	mov    %edx,%eax
c0105c2d:	eb 05                	jmp    c0105c34 <strncmp+0x54>
c0105c2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c34:	5d                   	pop    %ebp
c0105c35:	c3                   	ret    

c0105c36 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105c36:	55                   	push   %ebp
c0105c37:	89 e5                	mov    %esp,%ebp
c0105c39:	83 ec 04             	sub    $0x4,%esp
c0105c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c3f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c42:	eb 14                	jmp    c0105c58 <strchr+0x22>
        if (*s == c) {
c0105c44:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c47:	0f b6 00             	movzbl (%eax),%eax
c0105c4a:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105c4d:	75 05                	jne    c0105c54 <strchr+0x1e>
            return (char *)s;
c0105c4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c52:	eb 13                	jmp    c0105c67 <strchr+0x31>
        }
        s ++;
c0105c54:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105c58:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5b:	0f b6 00             	movzbl (%eax),%eax
c0105c5e:	84 c0                	test   %al,%al
c0105c60:	75 e2                	jne    c0105c44 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105c62:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c67:	c9                   	leave  
c0105c68:	c3                   	ret    

c0105c69 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105c69:	55                   	push   %ebp
c0105c6a:	89 e5                	mov    %esp,%ebp
c0105c6c:	83 ec 04             	sub    $0x4,%esp
c0105c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c72:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c75:	eb 11                	jmp    c0105c88 <strfind+0x1f>
        if (*s == c) {
c0105c77:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c7a:	0f b6 00             	movzbl (%eax),%eax
c0105c7d:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105c80:	75 02                	jne    c0105c84 <strfind+0x1b>
            break;
c0105c82:	eb 0e                	jmp    c0105c92 <strfind+0x29>
        }
        s ++;
c0105c84:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105c88:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c8b:	0f b6 00             	movzbl (%eax),%eax
c0105c8e:	84 c0                	test   %al,%al
c0105c90:	75 e5                	jne    c0105c77 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105c92:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105c95:	c9                   	leave  
c0105c96:	c3                   	ret    

c0105c97 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105c97:	55                   	push   %ebp
c0105c98:	89 e5                	mov    %esp,%ebp
c0105c9a:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105c9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105ca4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105cab:	eb 04                	jmp    c0105cb1 <strtol+0x1a>
        s ++;
c0105cad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105cb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cb4:	0f b6 00             	movzbl (%eax),%eax
c0105cb7:	3c 20                	cmp    $0x20,%al
c0105cb9:	74 f2                	je     c0105cad <strtol+0x16>
c0105cbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cbe:	0f b6 00             	movzbl (%eax),%eax
c0105cc1:	3c 09                	cmp    $0x9,%al
c0105cc3:	74 e8                	je     c0105cad <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105cc5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc8:	0f b6 00             	movzbl (%eax),%eax
c0105ccb:	3c 2b                	cmp    $0x2b,%al
c0105ccd:	75 06                	jne    c0105cd5 <strtol+0x3e>
        s ++;
c0105ccf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105cd3:	eb 15                	jmp    c0105cea <strtol+0x53>
    }
    else if (*s == '-') {
c0105cd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd8:	0f b6 00             	movzbl (%eax),%eax
c0105cdb:	3c 2d                	cmp    $0x2d,%al
c0105cdd:	75 0b                	jne    c0105cea <strtol+0x53>
        s ++, neg = 1;
c0105cdf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105ce3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105cea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cee:	74 06                	je     c0105cf6 <strtol+0x5f>
c0105cf0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105cf4:	75 24                	jne    c0105d1a <strtol+0x83>
c0105cf6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cf9:	0f b6 00             	movzbl (%eax),%eax
c0105cfc:	3c 30                	cmp    $0x30,%al
c0105cfe:	75 1a                	jne    c0105d1a <strtol+0x83>
c0105d00:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d03:	83 c0 01             	add    $0x1,%eax
c0105d06:	0f b6 00             	movzbl (%eax),%eax
c0105d09:	3c 78                	cmp    $0x78,%al
c0105d0b:	75 0d                	jne    c0105d1a <strtol+0x83>
        s += 2, base = 16;
c0105d0d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105d11:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105d18:	eb 2a                	jmp    c0105d44 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105d1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d1e:	75 17                	jne    c0105d37 <strtol+0xa0>
c0105d20:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d23:	0f b6 00             	movzbl (%eax),%eax
c0105d26:	3c 30                	cmp    $0x30,%al
c0105d28:	75 0d                	jne    c0105d37 <strtol+0xa0>
        s ++, base = 8;
c0105d2a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d2e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105d35:	eb 0d                	jmp    c0105d44 <strtol+0xad>
    }
    else if (base == 0) {
c0105d37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d3b:	75 07                	jne    c0105d44 <strtol+0xad>
        base = 10;
c0105d3d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105d44:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d47:	0f b6 00             	movzbl (%eax),%eax
c0105d4a:	3c 2f                	cmp    $0x2f,%al
c0105d4c:	7e 1b                	jle    c0105d69 <strtol+0xd2>
c0105d4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d51:	0f b6 00             	movzbl (%eax),%eax
c0105d54:	3c 39                	cmp    $0x39,%al
c0105d56:	7f 11                	jg     c0105d69 <strtol+0xd2>
            dig = *s - '0';
c0105d58:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d5b:	0f b6 00             	movzbl (%eax),%eax
c0105d5e:	0f be c0             	movsbl %al,%eax
c0105d61:	83 e8 30             	sub    $0x30,%eax
c0105d64:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d67:	eb 48                	jmp    c0105db1 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105d69:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d6c:	0f b6 00             	movzbl (%eax),%eax
c0105d6f:	3c 60                	cmp    $0x60,%al
c0105d71:	7e 1b                	jle    c0105d8e <strtol+0xf7>
c0105d73:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d76:	0f b6 00             	movzbl (%eax),%eax
c0105d79:	3c 7a                	cmp    $0x7a,%al
c0105d7b:	7f 11                	jg     c0105d8e <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105d7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d80:	0f b6 00             	movzbl (%eax),%eax
c0105d83:	0f be c0             	movsbl %al,%eax
c0105d86:	83 e8 57             	sub    $0x57,%eax
c0105d89:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d8c:	eb 23                	jmp    c0105db1 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105d8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d91:	0f b6 00             	movzbl (%eax),%eax
c0105d94:	3c 40                	cmp    $0x40,%al
c0105d96:	7e 3d                	jle    c0105dd5 <strtol+0x13e>
c0105d98:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d9b:	0f b6 00             	movzbl (%eax),%eax
c0105d9e:	3c 5a                	cmp    $0x5a,%al
c0105da0:	7f 33                	jg     c0105dd5 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105da2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105da5:	0f b6 00             	movzbl (%eax),%eax
c0105da8:	0f be c0             	movsbl %al,%eax
c0105dab:	83 e8 37             	sub    $0x37,%eax
c0105dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105db4:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105db7:	7c 02                	jl     c0105dbb <strtol+0x124>
            break;
c0105db9:	eb 1a                	jmp    c0105dd5 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105dbb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105dbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105dc2:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105dc6:	89 c2                	mov    %eax,%edx
c0105dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105dcb:	01 d0                	add    %edx,%eax
c0105dcd:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105dd0:	e9 6f ff ff ff       	jmp    c0105d44 <strtol+0xad>

    if (endptr) {
c0105dd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105dd9:	74 08                	je     c0105de3 <strtol+0x14c>
        *endptr = (char *) s;
c0105ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dde:	8b 55 08             	mov    0x8(%ebp),%edx
c0105de1:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105de3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105de7:	74 07                	je     c0105df0 <strtol+0x159>
c0105de9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105dec:	f7 d8                	neg    %eax
c0105dee:	eb 03                	jmp    c0105df3 <strtol+0x15c>
c0105df0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105df3:	c9                   	leave  
c0105df4:	c3                   	ret    

c0105df5 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105df5:	55                   	push   %ebp
c0105df6:	89 e5                	mov    %esp,%ebp
c0105df8:	57                   	push   %edi
c0105df9:	83 ec 24             	sub    $0x24,%esp
c0105dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dff:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105e02:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105e06:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e09:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105e0c:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105e0f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e12:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105e15:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105e18:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105e1c:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105e1f:	89 d7                	mov    %edx,%edi
c0105e21:	f3 aa                	rep stos %al,%es:(%edi)
c0105e23:	89 fa                	mov    %edi,%edx
c0105e25:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105e28:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105e2e:	83 c4 24             	add    $0x24,%esp
c0105e31:	5f                   	pop    %edi
c0105e32:	5d                   	pop    %ebp
c0105e33:	c3                   	ret    

c0105e34 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105e34:	55                   	push   %ebp
c0105e35:	89 e5                	mov    %esp,%ebp
c0105e37:	57                   	push   %edi
c0105e38:	56                   	push   %esi
c0105e39:	53                   	push   %ebx
c0105e3a:	83 ec 30             	sub    $0x30,%esp
c0105e3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e40:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e43:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e46:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e49:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e4c:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e52:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105e55:	73 42                	jae    c0105e99 <memmove+0x65>
c0105e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e60:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105e63:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e66:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e69:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e6c:	c1 e8 02             	shr    $0x2,%eax
c0105e6f:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105e71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105e74:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e77:	89 d7                	mov    %edx,%edi
c0105e79:	89 c6                	mov    %eax,%esi
c0105e7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e7d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e80:	83 e1 03             	and    $0x3,%ecx
c0105e83:	74 02                	je     c0105e87 <memmove+0x53>
c0105e85:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e87:	89 f0                	mov    %esi,%eax
c0105e89:	89 fa                	mov    %edi,%edx
c0105e8b:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105e8e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105e91:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105e94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e97:	eb 36                	jmp    c0105ecf <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105e99:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e9c:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105e9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ea2:	01 c2                	add    %eax,%edx
c0105ea4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ea7:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ead:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105eb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105eb3:	89 c1                	mov    %eax,%ecx
c0105eb5:	89 d8                	mov    %ebx,%eax
c0105eb7:	89 d6                	mov    %edx,%esi
c0105eb9:	89 c7                	mov    %eax,%edi
c0105ebb:	fd                   	std    
c0105ebc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105ebe:	fc                   	cld    
c0105ebf:	89 f8                	mov    %edi,%eax
c0105ec1:	89 f2                	mov    %esi,%edx
c0105ec3:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105ec6:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105ec9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105ecf:	83 c4 30             	add    $0x30,%esp
c0105ed2:	5b                   	pop    %ebx
c0105ed3:	5e                   	pop    %esi
c0105ed4:	5f                   	pop    %edi
c0105ed5:	5d                   	pop    %ebp
c0105ed6:	c3                   	ret    

c0105ed7 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105ed7:	55                   	push   %ebp
c0105ed8:	89 e5                	mov    %esp,%ebp
c0105eda:	57                   	push   %edi
c0105edb:	56                   	push   %esi
c0105edc:	83 ec 20             	sub    $0x20,%esp
c0105edf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ee2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ee8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105eeb:	8b 45 10             	mov    0x10(%ebp),%eax
c0105eee:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105ef1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ef4:	c1 e8 02             	shr    $0x2,%eax
c0105ef7:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105ef9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105eff:	89 d7                	mov    %edx,%edi
c0105f01:	89 c6                	mov    %eax,%esi
c0105f03:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105f05:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105f08:	83 e1 03             	and    $0x3,%ecx
c0105f0b:	74 02                	je     c0105f0f <memcpy+0x38>
c0105f0d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f0f:	89 f0                	mov    %esi,%eax
c0105f11:	89 fa                	mov    %edi,%edx
c0105f13:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105f16:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105f19:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105f1f:	83 c4 20             	add    $0x20,%esp
c0105f22:	5e                   	pop    %esi
c0105f23:	5f                   	pop    %edi
c0105f24:	5d                   	pop    %ebp
c0105f25:	c3                   	ret    

c0105f26 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105f26:	55                   	push   %ebp
c0105f27:	89 e5                	mov    %esp,%ebp
c0105f29:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105f2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105f32:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f35:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105f38:	eb 30                	jmp    c0105f6a <memcmp+0x44>
        if (*s1 != *s2) {
c0105f3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f3d:	0f b6 10             	movzbl (%eax),%edx
c0105f40:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f43:	0f b6 00             	movzbl (%eax),%eax
c0105f46:	38 c2                	cmp    %al,%dl
c0105f48:	74 18                	je     c0105f62 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105f4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f4d:	0f b6 00             	movzbl (%eax),%eax
c0105f50:	0f b6 d0             	movzbl %al,%edx
c0105f53:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f56:	0f b6 00             	movzbl (%eax),%eax
c0105f59:	0f b6 c0             	movzbl %al,%eax
c0105f5c:	29 c2                	sub    %eax,%edx
c0105f5e:	89 d0                	mov    %edx,%eax
c0105f60:	eb 1a                	jmp    c0105f7c <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105f62:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105f66:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105f6a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f6d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105f70:	89 55 10             	mov    %edx,0x10(%ebp)
c0105f73:	85 c0                	test   %eax,%eax
c0105f75:	75 c3                	jne    c0105f3a <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105f77:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f7c:	c9                   	leave  
c0105f7d:	c3                   	ret    
