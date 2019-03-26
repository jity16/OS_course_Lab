
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 80 11 40       	mov    $0x40118000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 80 11 00       	mov    %eax,0x118000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	ba 28 af 11 00       	mov    $0x11af28,%edx
  100041:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  100046:	29 c2                	sub    %eax,%edx
  100048:	89 d0                	mov    %edx,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  10005d:	e8 4d 5c 00 00       	call   105caf <memset>

    cons_init();                // init the console
  100062:	e8 82 15 00 00       	call   1015e9 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 40 5e 10 00 	movl   $0x105e40,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 5c 5e 10 00 	movl   $0x105e5c,(%esp)
  10007c:	e8 c7 02 00 00       	call   100348 <cprintf>

    print_kerninfo();
  100081:	e8 f6 07 00 00       	call   10087c <print_kerninfo>

    grade_backtrace();
  100086:	e8 86 00 00 00       	call   100111 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 19 43 00 00       	call   1043a9 <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 bd 16 00 00       	call   101752 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 35 18 00 00       	call   1018cf <idt_init>

    clock_init();               // init clock interrupt
  10009a:	e8 00 0d 00 00       	call   100d9f <clock_init>
    intr_enable();              // enable irq interrupt
  10009f:	e8 1c 16 00 00       	call   1016c0 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a4:	eb fe                	jmp    1000a4 <kern_init+0x6e>

001000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a6:	55                   	push   %ebp
  1000a7:	89 e5                	mov    %esp,%ebp
  1000a9:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000b3:	00 
  1000b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000bb:	00 
  1000bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000c3:	e8 f8 0b 00 00       	call   100cc0 <mon_backtrace>
}
  1000c8:	c9                   	leave  
  1000c9:	c3                   	ret    

001000ca <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000ca:	55                   	push   %ebp
  1000cb:	89 e5                	mov    %esp,%ebp
  1000cd:	53                   	push   %ebx
  1000ce:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000d1:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000d7:	8d 55 08             	lea    0x8(%ebp),%edx
  1000da:	8b 45 08             	mov    0x8(%ebp),%eax
  1000dd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000e5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000e9:	89 04 24             	mov    %eax,(%esp)
  1000ec:	e8 b5 ff ff ff       	call   1000a6 <grade_backtrace2>
}
  1000f1:	83 c4 14             	add    $0x14,%esp
  1000f4:	5b                   	pop    %ebx
  1000f5:	5d                   	pop    %ebp
  1000f6:	c3                   	ret    

001000f7 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000f7:	55                   	push   %ebp
  1000f8:	89 e5                	mov    %esp,%ebp
  1000fa:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000fd:	8b 45 10             	mov    0x10(%ebp),%eax
  100100:	89 44 24 04          	mov    %eax,0x4(%esp)
  100104:	8b 45 08             	mov    0x8(%ebp),%eax
  100107:	89 04 24             	mov    %eax,(%esp)
  10010a:	e8 bb ff ff ff       	call   1000ca <grade_backtrace1>
}
  10010f:	c9                   	leave  
  100110:	c3                   	ret    

00100111 <grade_backtrace>:

void
grade_backtrace(void) {
  100111:	55                   	push   %ebp
  100112:	89 e5                	mov    %esp,%ebp
  100114:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  100117:	b8 36 00 10 00       	mov    $0x100036,%eax
  10011c:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100123:	ff 
  100124:	89 44 24 04          	mov    %eax,0x4(%esp)
  100128:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10012f:	e8 c3 ff ff ff       	call   1000f7 <grade_backtrace0>
}
  100134:	c9                   	leave  
  100135:	c3                   	ret    

00100136 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100136:	55                   	push   %ebp
  100137:	89 e5                	mov    %esp,%ebp
  100139:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10013c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10013f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100142:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100145:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100148:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10014c:	0f b7 c0             	movzwl %ax,%eax
  10014f:	83 e0 03             	and    $0x3,%eax
  100152:	89 c2                	mov    %eax,%edx
  100154:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100159:	89 54 24 08          	mov    %edx,0x8(%esp)
  10015d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100161:	c7 04 24 61 5e 10 00 	movl   $0x105e61,(%esp)
  100168:	e8 db 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10016d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100171:	0f b7 d0             	movzwl %ax,%edx
  100174:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100179:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100181:	c7 04 24 6f 5e 10 00 	movl   $0x105e6f,(%esp)
  100188:	e8 bb 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100191:	0f b7 d0             	movzwl %ax,%edx
  100194:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100199:	89 54 24 08          	mov    %edx,0x8(%esp)
  10019d:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a1:	c7 04 24 7d 5e 10 00 	movl   $0x105e7d,(%esp)
  1001a8:	e8 9b 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001ad:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b1:	0f b7 d0             	movzwl %ax,%edx
  1001b4:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c1:	c7 04 24 8b 5e 10 00 	movl   $0x105e8b,(%esp)
  1001c8:	e8 7b 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001cd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d1:	0f b7 d0             	movzwl %ax,%edx
  1001d4:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001d9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e1:	c7 04 24 99 5e 10 00 	movl   $0x105e99,(%esp)
  1001e8:	e8 5b 01 00 00       	call   100348 <cprintf>
    round ++;
  1001ed:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001f2:	83 c0 01             	add    $0x1,%eax
  1001f5:	a3 00 a0 11 00       	mov    %eax,0x11a000
}
  1001fa:	c9                   	leave  
  1001fb:	c3                   	ret    

001001fc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001fc:	55                   	push   %ebp
  1001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : 2016010308
}
  1001ff:	5d                   	pop    %ebp
  100200:	c3                   	ret    

00100201 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100201:	55                   	push   %ebp
  100202:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  2016010308
}
  100204:	5d                   	pop    %ebp
  100205:	c3                   	ret    

00100206 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100206:	55                   	push   %ebp
  100207:	89 e5                	mov    %esp,%ebp
  100209:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10020c:	e8 25 ff ff ff       	call   100136 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100211:	c7 04 24 a8 5e 10 00 	movl   $0x105ea8,(%esp)
  100218:	e8 2b 01 00 00       	call   100348 <cprintf>
    lab1_switch_to_user();
  10021d:	e8 da ff ff ff       	call   1001fc <lab1_switch_to_user>
    lab1_print_cur_status();
  100222:	e8 0f ff ff ff       	call   100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100227:	c7 04 24 c8 5e 10 00 	movl   $0x105ec8,(%esp)
  10022e:	e8 15 01 00 00       	call   100348 <cprintf>
    lab1_switch_to_kernel();
  100233:	e8 c9 ff ff ff       	call   100201 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100238:	e8 f9 fe ff ff       	call   100136 <lab1_print_cur_status>
}
  10023d:	c9                   	leave  
  10023e:	c3                   	ret    

0010023f <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10023f:	55                   	push   %ebp
  100240:	89 e5                	mov    %esp,%ebp
  100242:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100245:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100249:	74 13                	je     10025e <readline+0x1f>
        cprintf("%s", prompt);
  10024b:	8b 45 08             	mov    0x8(%ebp),%eax
  10024e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100252:	c7 04 24 e7 5e 10 00 	movl   $0x105ee7,(%esp)
  100259:	e8 ea 00 00 00       	call   100348 <cprintf>
    }
    int i = 0, c;
  10025e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100265:	e8 66 01 00 00       	call   1003d0 <getchar>
  10026a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10026d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100271:	79 07                	jns    10027a <readline+0x3b>
            return NULL;
  100273:	b8 00 00 00 00       	mov    $0x0,%eax
  100278:	eb 79                	jmp    1002f3 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10027a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10027e:	7e 28                	jle    1002a8 <readline+0x69>
  100280:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100287:	7f 1f                	jg     1002a8 <readline+0x69>
            cputchar(c);
  100289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10028c:	89 04 24             	mov    %eax,(%esp)
  10028f:	e8 da 00 00 00       	call   10036e <cputchar>
            buf[i ++] = c;
  100294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100297:	8d 50 01             	lea    0x1(%eax),%edx
  10029a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10029d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1002a0:	88 90 20 a0 11 00    	mov    %dl,0x11a020(%eax)
  1002a6:	eb 46                	jmp    1002ee <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  1002a8:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002ac:	75 17                	jne    1002c5 <readline+0x86>
  1002ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002b2:	7e 11                	jle    1002c5 <readline+0x86>
            cputchar(c);
  1002b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b7:	89 04 24             	mov    %eax,(%esp)
  1002ba:	e8 af 00 00 00       	call   10036e <cputchar>
            i --;
  1002bf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002c3:	eb 29                	jmp    1002ee <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002c5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002c9:	74 06                	je     1002d1 <readline+0x92>
  1002cb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002cf:	75 1d                	jne    1002ee <readline+0xaf>
            cputchar(c);
  1002d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002d4:	89 04 24             	mov    %eax,(%esp)
  1002d7:	e8 92 00 00 00       	call   10036e <cputchar>
            buf[i] = '\0';
  1002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002df:	05 20 a0 11 00       	add    $0x11a020,%eax
  1002e4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002e7:	b8 20 a0 11 00       	mov    $0x11a020,%eax
  1002ec:	eb 05                	jmp    1002f3 <readline+0xb4>
        }
    }
  1002ee:	e9 72 ff ff ff       	jmp    100265 <readline+0x26>
}
  1002f3:	c9                   	leave  
  1002f4:	c3                   	ret    

001002f5 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002f5:	55                   	push   %ebp
  1002f6:	89 e5                	mov    %esp,%ebp
  1002f8:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fe:	89 04 24             	mov    %eax,(%esp)
  100301:	e8 0f 13 00 00       	call   101615 <cons_putc>
    (*cnt) ++;
  100306:	8b 45 0c             	mov    0xc(%ebp),%eax
  100309:	8b 00                	mov    (%eax),%eax
  10030b:	8d 50 01             	lea    0x1(%eax),%edx
  10030e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100311:	89 10                	mov    %edx,(%eax)
}
  100313:	c9                   	leave  
  100314:	c3                   	ret    

00100315 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100315:	55                   	push   %ebp
  100316:	89 e5                	mov    %esp,%ebp
  100318:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10031b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100322:	8b 45 0c             	mov    0xc(%ebp),%eax
  100325:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100329:	8b 45 08             	mov    0x8(%ebp),%eax
  10032c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100330:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100333:	89 44 24 04          	mov    %eax,0x4(%esp)
  100337:	c7 04 24 f5 02 10 00 	movl   $0x1002f5,(%esp)
  10033e:	e8 85 51 00 00       	call   1054c8 <vprintfmt>
    return cnt;
  100343:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100346:	c9                   	leave  
  100347:	c3                   	ret    

00100348 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100348:	55                   	push   %ebp
  100349:	89 e5                	mov    %esp,%ebp
  10034b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10034e:	8d 45 0c             	lea    0xc(%ebp),%eax
  100351:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100354:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100357:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035b:	8b 45 08             	mov    0x8(%ebp),%eax
  10035e:	89 04 24             	mov    %eax,(%esp)
  100361:	e8 af ff ff ff       	call   100315 <vcprintf>
  100366:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100369:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10036c:	c9                   	leave  
  10036d:	c3                   	ret    

0010036e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10036e:	55                   	push   %ebp
  10036f:	89 e5                	mov    %esp,%ebp
  100371:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100374:	8b 45 08             	mov    0x8(%ebp),%eax
  100377:	89 04 24             	mov    %eax,(%esp)
  10037a:	e8 96 12 00 00       	call   101615 <cons_putc>
}
  10037f:	c9                   	leave  
  100380:	c3                   	ret    

00100381 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100381:	55                   	push   %ebp
  100382:	89 e5                	mov    %esp,%ebp
  100384:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100387:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10038e:	eb 13                	jmp    1003a3 <cputs+0x22>
        cputch(c, &cnt);
  100390:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100394:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100397:	89 54 24 04          	mov    %edx,0x4(%esp)
  10039b:	89 04 24             	mov    %eax,(%esp)
  10039e:	e8 52 ff ff ff       	call   1002f5 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1003a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1003a6:	8d 50 01             	lea    0x1(%eax),%edx
  1003a9:	89 55 08             	mov    %edx,0x8(%ebp)
  1003ac:	0f b6 00             	movzbl (%eax),%eax
  1003af:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003b2:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003b6:	75 d8                	jne    100390 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003bf:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003c6:	e8 2a ff ff ff       	call   1002f5 <cputch>
    return cnt;
  1003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003ce:	c9                   	leave  
  1003cf:	c3                   	ret    

001003d0 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003d0:	55                   	push   %ebp
  1003d1:	89 e5                	mov    %esp,%ebp
  1003d3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003d6:	e8 76 12 00 00       	call   101651 <cons_getc>
  1003db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003e2:	74 f2                	je     1003d6 <getchar+0x6>
        /* do nothing */;
    return c;
  1003e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003e7:	c9                   	leave  
  1003e8:	c3                   	ret    

001003e9 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003e9:	55                   	push   %ebp
  1003ea:	89 e5                	mov    %esp,%ebp
  1003ec:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003f2:	8b 00                	mov    (%eax),%eax
  1003f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003f7:	8b 45 10             	mov    0x10(%ebp),%eax
  1003fa:	8b 00                	mov    (%eax),%eax
  1003fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100406:	e9 d2 00 00 00       	jmp    1004dd <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  10040b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10040e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100411:	01 d0                	add    %edx,%eax
  100413:	89 c2                	mov    %eax,%edx
  100415:	c1 ea 1f             	shr    $0x1f,%edx
  100418:	01 d0                	add    %edx,%eax
  10041a:	d1 f8                	sar    %eax
  10041c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100422:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100425:	eb 04                	jmp    10042b <stab_binsearch+0x42>
            m --;
  100427:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10042e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100431:	7c 1f                	jl     100452 <stab_binsearch+0x69>
  100433:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100436:	89 d0                	mov    %edx,%eax
  100438:	01 c0                	add    %eax,%eax
  10043a:	01 d0                	add    %edx,%eax
  10043c:	c1 e0 02             	shl    $0x2,%eax
  10043f:	89 c2                	mov    %eax,%edx
  100441:	8b 45 08             	mov    0x8(%ebp),%eax
  100444:	01 d0                	add    %edx,%eax
  100446:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10044a:	0f b6 c0             	movzbl %al,%eax
  10044d:	3b 45 14             	cmp    0x14(%ebp),%eax
  100450:	75 d5                	jne    100427 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100455:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100458:	7d 0b                	jge    100465 <stab_binsearch+0x7c>
            l = true_m + 1;
  10045a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045d:	83 c0 01             	add    $0x1,%eax
  100460:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100463:	eb 78                	jmp    1004dd <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100465:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10046c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10046f:	89 d0                	mov    %edx,%eax
  100471:	01 c0                	add    %eax,%eax
  100473:	01 d0                	add    %edx,%eax
  100475:	c1 e0 02             	shl    $0x2,%eax
  100478:	89 c2                	mov    %eax,%edx
  10047a:	8b 45 08             	mov    0x8(%ebp),%eax
  10047d:	01 d0                	add    %edx,%eax
  10047f:	8b 40 08             	mov    0x8(%eax),%eax
  100482:	3b 45 18             	cmp    0x18(%ebp),%eax
  100485:	73 13                	jae    10049a <stab_binsearch+0xb1>
            *region_left = m;
  100487:	8b 45 0c             	mov    0xc(%ebp),%eax
  10048a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10048d:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10048f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100492:	83 c0 01             	add    $0x1,%eax
  100495:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100498:	eb 43                	jmp    1004dd <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10049a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049d:	89 d0                	mov    %edx,%eax
  10049f:	01 c0                	add    %eax,%eax
  1004a1:	01 d0                	add    %edx,%eax
  1004a3:	c1 e0 02             	shl    $0x2,%eax
  1004a6:	89 c2                	mov    %eax,%edx
  1004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ab:	01 d0                	add    %edx,%eax
  1004ad:	8b 40 08             	mov    0x8(%eax),%eax
  1004b0:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004b3:	76 16                	jbe    1004cb <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004bb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004be:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c3:	83 e8 01             	sub    $0x1,%eax
  1004c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004c9:	eb 12                	jmp    1004dd <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004d1:	89 10                	mov    %edx,(%eax)
            l = m;
  1004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004d9:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004e3:	0f 8e 22 ff ff ff    	jle    10040b <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004ed:	75 0f                	jne    1004fe <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f2:	8b 00                	mov    (%eax),%eax
  1004f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004f7:	8b 45 10             	mov    0x10(%ebp),%eax
  1004fa:	89 10                	mov    %edx,(%eax)
  1004fc:	eb 3f                	jmp    10053d <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004fe:	8b 45 10             	mov    0x10(%ebp),%eax
  100501:	8b 00                	mov    (%eax),%eax
  100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100506:	eb 04                	jmp    10050c <stab_binsearch+0x123>
  100508:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  10050c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050f:	8b 00                	mov    (%eax),%eax
  100511:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100514:	7d 1f                	jge    100535 <stab_binsearch+0x14c>
  100516:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100519:	89 d0                	mov    %edx,%eax
  10051b:	01 c0                	add    %eax,%eax
  10051d:	01 d0                	add    %edx,%eax
  10051f:	c1 e0 02             	shl    $0x2,%eax
  100522:	89 c2                	mov    %eax,%edx
  100524:	8b 45 08             	mov    0x8(%ebp),%eax
  100527:	01 d0                	add    %edx,%eax
  100529:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10052d:	0f b6 c0             	movzbl %al,%eax
  100530:	3b 45 14             	cmp    0x14(%ebp),%eax
  100533:	75 d3                	jne    100508 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100535:	8b 45 0c             	mov    0xc(%ebp),%eax
  100538:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10053b:	89 10                	mov    %edx,(%eax)
    }
}
  10053d:	c9                   	leave  
  10053e:	c3                   	ret    

0010053f <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10053f:	55                   	push   %ebp
  100540:	89 e5                	mov    %esp,%ebp
  100542:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100545:	8b 45 0c             	mov    0xc(%ebp),%eax
  100548:	c7 00 ec 5e 10 00    	movl   $0x105eec,(%eax)
    info->eip_line = 0;
  10054e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100551:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100558:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055b:	c7 40 08 ec 5e 10 00 	movl   $0x105eec,0x8(%eax)
    info->eip_fn_namelen = 9;
  100562:	8b 45 0c             	mov    0xc(%ebp),%eax
  100565:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10056c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056f:	8b 55 08             	mov    0x8(%ebp),%edx
  100572:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100575:	8b 45 0c             	mov    0xc(%ebp),%eax
  100578:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10057f:	c7 45 f4 68 71 10 00 	movl   $0x107168,-0xc(%ebp)
    stab_end = __STAB_END__;
  100586:	c7 45 f0 30 1b 11 00 	movl   $0x111b30,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10058d:	c7 45 ec 31 1b 11 00 	movl   $0x111b31,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100594:	c7 45 e8 7b 45 11 00 	movl   $0x11457b,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10059b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1005a1:	76 0d                	jbe    1005b0 <debuginfo_eip+0x71>
  1005a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005a6:	83 e8 01             	sub    $0x1,%eax
  1005a9:	0f b6 00             	movzbl (%eax),%eax
  1005ac:	84 c0                	test   %al,%al
  1005ae:	74 0a                	je     1005ba <debuginfo_eip+0x7b>
        return -1;
  1005b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005b5:	e9 c0 02 00 00       	jmp    10087a <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c7:	29 c2                	sub    %eax,%edx
  1005c9:	89 d0                	mov    %edx,%eax
  1005cb:	c1 f8 02             	sar    $0x2,%eax
  1005ce:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005d4:	83 e8 01             	sub    $0x1,%eax
  1005d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005da:	8b 45 08             	mov    0x8(%ebp),%eax
  1005dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005e1:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005e8:	00 
  1005e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005fa:	89 04 24             	mov    %eax,(%esp)
  1005fd:	e8 e7 fd ff ff       	call   1003e9 <stab_binsearch>
    if (lfile == 0)
  100602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100605:	85 c0                	test   %eax,%eax
  100607:	75 0a                	jne    100613 <debuginfo_eip+0xd4>
        return -1;
  100609:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10060e:	e9 67 02 00 00       	jmp    10087a <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100616:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100619:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10061c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10061f:	8b 45 08             	mov    0x8(%ebp),%eax
  100622:	89 44 24 10          	mov    %eax,0x10(%esp)
  100626:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  10062d:	00 
  10062e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100631:	89 44 24 08          	mov    %eax,0x8(%esp)
  100635:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100638:	89 44 24 04          	mov    %eax,0x4(%esp)
  10063c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10063f:	89 04 24             	mov    %eax,(%esp)
  100642:	e8 a2 fd ff ff       	call   1003e9 <stab_binsearch>

    if (lfun <= rfun) {
  100647:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10064a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10064d:	39 c2                	cmp    %eax,%edx
  10064f:	7f 7c                	jg     1006cd <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100651:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100654:	89 c2                	mov    %eax,%edx
  100656:	89 d0                	mov    %edx,%eax
  100658:	01 c0                	add    %eax,%eax
  10065a:	01 d0                	add    %edx,%eax
  10065c:	c1 e0 02             	shl    $0x2,%eax
  10065f:	89 c2                	mov    %eax,%edx
  100661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100664:	01 d0                	add    %edx,%eax
  100666:	8b 10                	mov    (%eax),%edx
  100668:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10066b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10066e:	29 c1                	sub    %eax,%ecx
  100670:	89 c8                	mov    %ecx,%eax
  100672:	39 c2                	cmp    %eax,%edx
  100674:	73 22                	jae    100698 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100676:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100679:	89 c2                	mov    %eax,%edx
  10067b:	89 d0                	mov    %edx,%eax
  10067d:	01 c0                	add    %eax,%eax
  10067f:	01 d0                	add    %edx,%eax
  100681:	c1 e0 02             	shl    $0x2,%eax
  100684:	89 c2                	mov    %eax,%edx
  100686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100689:	01 d0                	add    %edx,%eax
  10068b:	8b 10                	mov    (%eax),%edx
  10068d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100690:	01 c2                	add    %eax,%edx
  100692:	8b 45 0c             	mov    0xc(%ebp),%eax
  100695:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100698:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10069b:	89 c2                	mov    %eax,%edx
  10069d:	89 d0                	mov    %edx,%eax
  10069f:	01 c0                	add    %eax,%eax
  1006a1:	01 d0                	add    %edx,%eax
  1006a3:	c1 e0 02             	shl    $0x2,%eax
  1006a6:	89 c2                	mov    %eax,%edx
  1006a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006ab:	01 d0                	add    %edx,%eax
  1006ad:	8b 50 08             	mov    0x8(%eax),%edx
  1006b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b3:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b9:	8b 40 10             	mov    0x10(%eax),%eax
  1006bc:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006cb:	eb 15                	jmp    1006e2 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d0:	8b 55 08             	mov    0x8(%ebp),%edx
  1006d3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006df:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e5:	8b 40 08             	mov    0x8(%eax),%eax
  1006e8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006ef:	00 
  1006f0:	89 04 24             	mov    %eax,(%esp)
  1006f3:	e8 2b 54 00 00       	call   105b23 <strfind>
  1006f8:	89 c2                	mov    %eax,%edx
  1006fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006fd:	8b 40 08             	mov    0x8(%eax),%eax
  100700:	29 c2                	sub    %eax,%edx
  100702:	8b 45 0c             	mov    0xc(%ebp),%eax
  100705:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100708:	8b 45 08             	mov    0x8(%ebp),%eax
  10070b:	89 44 24 10          	mov    %eax,0x10(%esp)
  10070f:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100716:	00 
  100717:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10071a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10071e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100721:	89 44 24 04          	mov    %eax,0x4(%esp)
  100725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100728:	89 04 24             	mov    %eax,(%esp)
  10072b:	e8 b9 fc ff ff       	call   1003e9 <stab_binsearch>
    if (lline <= rline) {
  100730:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100733:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100736:	39 c2                	cmp    %eax,%edx
  100738:	7f 24                	jg     10075e <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10073a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10073d:	89 c2                	mov    %eax,%edx
  10073f:	89 d0                	mov    %edx,%eax
  100741:	01 c0                	add    %eax,%eax
  100743:	01 d0                	add    %edx,%eax
  100745:	c1 e0 02             	shl    $0x2,%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074d:	01 d0                	add    %edx,%eax
  10074f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100753:	0f b7 d0             	movzwl %ax,%edx
  100756:	8b 45 0c             	mov    0xc(%ebp),%eax
  100759:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10075c:	eb 13                	jmp    100771 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  10075e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100763:	e9 12 01 00 00       	jmp    10087a <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100768:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10076b:	83 e8 01             	sub    $0x1,%eax
  10076e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100771:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100777:	39 c2                	cmp    %eax,%edx
  100779:	7c 56                	jl     1007d1 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10077b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10077e:	89 c2                	mov    %eax,%edx
  100780:	89 d0                	mov    %edx,%eax
  100782:	01 c0                	add    %eax,%eax
  100784:	01 d0                	add    %edx,%eax
  100786:	c1 e0 02             	shl    $0x2,%eax
  100789:	89 c2                	mov    %eax,%edx
  10078b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10078e:	01 d0                	add    %edx,%eax
  100790:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100794:	3c 84                	cmp    $0x84,%al
  100796:	74 39                	je     1007d1 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100798:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10079b:	89 c2                	mov    %eax,%edx
  10079d:	89 d0                	mov    %edx,%eax
  10079f:	01 c0                	add    %eax,%eax
  1007a1:	01 d0                	add    %edx,%eax
  1007a3:	c1 e0 02             	shl    $0x2,%eax
  1007a6:	89 c2                	mov    %eax,%edx
  1007a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ab:	01 d0                	add    %edx,%eax
  1007ad:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007b1:	3c 64                	cmp    $0x64,%al
  1007b3:	75 b3                	jne    100768 <debuginfo_eip+0x229>
  1007b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007b8:	89 c2                	mov    %eax,%edx
  1007ba:	89 d0                	mov    %edx,%eax
  1007bc:	01 c0                	add    %eax,%eax
  1007be:	01 d0                	add    %edx,%eax
  1007c0:	c1 e0 02             	shl    $0x2,%eax
  1007c3:	89 c2                	mov    %eax,%edx
  1007c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c8:	01 d0                	add    %edx,%eax
  1007ca:	8b 40 08             	mov    0x8(%eax),%eax
  1007cd:	85 c0                	test   %eax,%eax
  1007cf:	74 97                	je     100768 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007d7:	39 c2                	cmp    %eax,%edx
  1007d9:	7c 46                	jl     100821 <debuginfo_eip+0x2e2>
  1007db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007de:	89 c2                	mov    %eax,%edx
  1007e0:	89 d0                	mov    %edx,%eax
  1007e2:	01 c0                	add    %eax,%eax
  1007e4:	01 d0                	add    %edx,%eax
  1007e6:	c1 e0 02             	shl    $0x2,%eax
  1007e9:	89 c2                	mov    %eax,%edx
  1007eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ee:	01 d0                	add    %edx,%eax
  1007f0:	8b 10                	mov    (%eax),%edx
  1007f2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007f8:	29 c1                	sub    %eax,%ecx
  1007fa:	89 c8                	mov    %ecx,%eax
  1007fc:	39 c2                	cmp    %eax,%edx
  1007fe:	73 21                	jae    100821 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100803:	89 c2                	mov    %eax,%edx
  100805:	89 d0                	mov    %edx,%eax
  100807:	01 c0                	add    %eax,%eax
  100809:	01 d0                	add    %edx,%eax
  10080b:	c1 e0 02             	shl    $0x2,%eax
  10080e:	89 c2                	mov    %eax,%edx
  100810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100813:	01 d0                	add    %edx,%eax
  100815:	8b 10                	mov    (%eax),%edx
  100817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10081a:	01 c2                	add    %eax,%edx
  10081c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081f:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100821:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100824:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100827:	39 c2                	cmp    %eax,%edx
  100829:	7d 4a                	jge    100875 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10082b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10082e:	83 c0 01             	add    $0x1,%eax
  100831:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100834:	eb 18                	jmp    10084e <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100836:	8b 45 0c             	mov    0xc(%ebp),%eax
  100839:	8b 40 14             	mov    0x14(%eax),%eax
  10083c:	8d 50 01             	lea    0x1(%eax),%edx
  10083f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100842:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100845:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100848:	83 c0 01             	add    $0x1,%eax
  10084b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100851:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100854:	39 c2                	cmp    %eax,%edx
  100856:	7d 1d                	jge    100875 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085b:	89 c2                	mov    %eax,%edx
  10085d:	89 d0                	mov    %edx,%eax
  10085f:	01 c0                	add    %eax,%eax
  100861:	01 d0                	add    %edx,%eax
  100863:	c1 e0 02             	shl    $0x2,%eax
  100866:	89 c2                	mov    %eax,%edx
  100868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086b:	01 d0                	add    %edx,%eax
  10086d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100871:	3c a0                	cmp    $0xa0,%al
  100873:	74 c1                	je     100836 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100875:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10087a:	c9                   	leave  
  10087b:	c3                   	ret    

0010087c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  10087c:	55                   	push   %ebp
  10087d:	89 e5                	mov    %esp,%ebp
  10087f:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100882:	c7 04 24 f6 5e 10 00 	movl   $0x105ef6,(%esp)
  100889:	e8 ba fa ff ff       	call   100348 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10088e:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  100895:	00 
  100896:	c7 04 24 0f 5f 10 00 	movl   $0x105f0f,(%esp)
  10089d:	e8 a6 fa ff ff       	call   100348 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008a2:	c7 44 24 04 38 5e 10 	movl   $0x105e38,0x4(%esp)
  1008a9:	00 
  1008aa:	c7 04 24 27 5f 10 00 	movl   $0x105f27,(%esp)
  1008b1:	e8 92 fa ff ff       	call   100348 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008b6:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008bd:	00 
  1008be:	c7 04 24 3f 5f 10 00 	movl   $0x105f3f,(%esp)
  1008c5:	e8 7e fa ff ff       	call   100348 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008ca:	c7 44 24 04 28 af 11 	movl   $0x11af28,0x4(%esp)
  1008d1:	00 
  1008d2:	c7 04 24 57 5f 10 00 	movl   $0x105f57,(%esp)
  1008d9:	e8 6a fa ff ff       	call   100348 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008de:	b8 28 af 11 00       	mov    $0x11af28,%eax
  1008e3:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008e9:	b8 36 00 10 00       	mov    $0x100036,%eax
  1008ee:	29 c2                	sub    %eax,%edx
  1008f0:	89 d0                	mov    %edx,%eax
  1008f2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008f8:	85 c0                	test   %eax,%eax
  1008fa:	0f 48 c2             	cmovs  %edx,%eax
  1008fd:	c1 f8 0a             	sar    $0xa,%eax
  100900:	89 44 24 04          	mov    %eax,0x4(%esp)
  100904:	c7 04 24 70 5f 10 00 	movl   $0x105f70,(%esp)
  10090b:	e8 38 fa ff ff       	call   100348 <cprintf>
}
  100910:	c9                   	leave  
  100911:	c3                   	ret    

00100912 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100912:	55                   	push   %ebp
  100913:	89 e5                	mov    %esp,%ebp
  100915:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10091b:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10091e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100922:	8b 45 08             	mov    0x8(%ebp),%eax
  100925:	89 04 24             	mov    %eax,(%esp)
  100928:	e8 12 fc ff ff       	call   10053f <debuginfo_eip>
  10092d:	85 c0                	test   %eax,%eax
  10092f:	74 15                	je     100946 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100931:	8b 45 08             	mov    0x8(%ebp),%eax
  100934:	89 44 24 04          	mov    %eax,0x4(%esp)
  100938:	c7 04 24 9a 5f 10 00 	movl   $0x105f9a,(%esp)
  10093f:	e8 04 fa ff ff       	call   100348 <cprintf>
  100944:	eb 6d                	jmp    1009b3 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100946:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10094d:	eb 1c                	jmp    10096b <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  10094f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100955:	01 d0                	add    %edx,%eax
  100957:	0f b6 00             	movzbl (%eax),%eax
  10095a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100960:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100963:	01 ca                	add    %ecx,%edx
  100965:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100967:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10096b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10096e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100971:	7f dc                	jg     10094f <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100973:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10097c:	01 d0                	add    %edx,%eax
  10097e:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100981:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100984:	8b 55 08             	mov    0x8(%ebp),%edx
  100987:	89 d1                	mov    %edx,%ecx
  100989:	29 c1                	sub    %eax,%ecx
  10098b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10098e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100991:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100995:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10099b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10099f:	89 54 24 08          	mov    %edx,0x8(%esp)
  1009a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009a7:	c7 04 24 b6 5f 10 00 	movl   $0x105fb6,(%esp)
  1009ae:	e8 95 f9 ff ff       	call   100348 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009b3:	c9                   	leave  
  1009b4:	c3                   	ret    

001009b5 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009b5:	55                   	push   %ebp
  1009b6:	89 e5                	mov    %esp,%ebp
  1009b8:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009bb:	8b 45 04             	mov    0x4(%ebp),%eax
  1009be:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009c4:	c9                   	leave  
  1009c5:	c3                   	ret    

001009c6 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009c6:	55                   	push   %ebp
  1009c7:	89 e5                	mov    %esp,%ebp
  1009c9:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009cc:	89 e8                	mov    %ebp,%eax
  1009ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
        uint32_t ebp = read_ebp(); //(1) call read_ebp() to get the value of ebp. the type is (uint32_t);
  1009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        uint32_t eip = read_eip(); //(2) call read_eip() to get the value of eip. the type is (uint32_t);
  1009d7:	e8 d9 ff ff ff       	call   1009b5 <read_eip>
  1009dc:	89 45 f0             	mov    %eax,-0x10(%ebp)

        int i = 0;
  1009df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
        while(ebp != 0 && i < STACKFRAME_DEPTH) {   // (3) from 0 .. STACKFRAME_DEPTH
  1009e6:	e9 88 00 00 00       	jmp    100a73 <print_stackframe+0xad>
            cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);       //(3.1) printf value of ebp, eip
  1009eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f9:	c7 04 24 c8 5f 10 00 	movl   $0x105fc8,(%esp)
  100a00:	e8 43 f9 ff ff       	call   100348 <cprintf>
            uint32_t *args = (uint32_t *)ebp + 2;      // (3.2) (uint32_t)calling arguments [0..4] = the contents in address (uint32_t)ebp +2 [0..4]                           
  100a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a08:	83 c0 08             	add    $0x8,%eax
  100a0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            int j = 0;
  100a0e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            while(j < 4){           
  100a15:	eb 25                	jmp    100a3c <print_stackframe+0x76>
                cprintf("0x%08x ", args[j]);
  100a17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a1a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a24:	01 d0                	add    %edx,%eax
  100a26:	8b 00                	mov    (%eax),%eax
  100a28:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a2c:	c7 04 24 e4 5f 10 00 	movl   $0x105fe4,(%esp)
  100a33:	e8 10 f9 ff ff       	call   100348 <cprintf>
                j ++;
  100a38:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
        int i = 0;
        while(ebp != 0 && i < STACKFRAME_DEPTH) {   // (3) from 0 .. STACKFRAME_DEPTH
            cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);       //(3.1) printf value of ebp, eip
            uint32_t *args = (uint32_t *)ebp + 2;      // (3.2) (uint32_t)calling arguments [0..4] = the contents in address (uint32_t)ebp +2 [0..4]                           
            int j = 0;
            while(j < 4){           
  100a3c:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a40:	7e d5                	jle    100a17 <print_stackframe+0x51>
                cprintf("0x%08x ", args[j]);
                j ++;
            }
            cprintf("\n");      //(3.3) cprintf("\n");
  100a42:	c7 04 24 ec 5f 10 00 	movl   $0x105fec,(%esp)
  100a49:	e8 fa f8 ff ff       	call   100348 <cprintf>
            print_debuginfo(eip - 1);//(3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
  100a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a51:	83 e8 01             	sub    $0x1,%eax
  100a54:	89 04 24             	mov    %eax,(%esp)
  100a57:	e8 b6 fe ff ff       	call   100912 <print_debuginfo>
            eip = ((uint32_t *)ebp)[1]; //(3.5) popup a calling stackframe
  100a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5f:	83 c0 04             	add    $0x4,%eax
  100a62:	8b 00                	mov    (%eax),%eax
  100a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
            ebp = ((uint32_t *)ebp)[0]; 
  100a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a6a:	8b 00                	mov    (%eax),%eax
  100a6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            i++;
  100a6f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
      */
        uint32_t ebp = read_ebp(); //(1) call read_ebp() to get the value of ebp. the type is (uint32_t);
        uint32_t eip = read_eip(); //(2) call read_eip() to get the value of eip. the type is (uint32_t);

        int i = 0;
        while(ebp != 0 && i < STACKFRAME_DEPTH) {   // (3) from 0 .. STACKFRAME_DEPTH
  100a73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a77:	74 0a                	je     100a83 <print_stackframe+0xbd>
  100a79:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a7d:	0f 8e 68 ff ff ff    	jle    1009eb <print_stackframe+0x25>
            print_debuginfo(eip - 1);//(3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
            eip = ((uint32_t *)ebp)[1]; //(3.5) popup a calling stackframe
            ebp = ((uint32_t *)ebp)[0]; 
            i++;
        }
}
  100a83:	c9                   	leave  
  100a84:	c3                   	ret    

00100a85 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a85:	55                   	push   %ebp
  100a86:	89 e5                	mov    %esp,%ebp
  100a88:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a92:	eb 0c                	jmp    100aa0 <parse+0x1b>
            *buf ++ = '\0';
  100a94:	8b 45 08             	mov    0x8(%ebp),%eax
  100a97:	8d 50 01             	lea    0x1(%eax),%edx
  100a9a:	89 55 08             	mov    %edx,0x8(%ebp)
  100a9d:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa3:	0f b6 00             	movzbl (%eax),%eax
  100aa6:	84 c0                	test   %al,%al
  100aa8:	74 1d                	je     100ac7 <parse+0x42>
  100aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  100aad:	0f b6 00             	movzbl (%eax),%eax
  100ab0:	0f be c0             	movsbl %al,%eax
  100ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab7:	c7 04 24 70 60 10 00 	movl   $0x106070,(%esp)
  100abe:	e8 2d 50 00 00       	call   105af0 <strchr>
  100ac3:	85 c0                	test   %eax,%eax
  100ac5:	75 cd                	jne    100a94 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  100aca:	0f b6 00             	movzbl (%eax),%eax
  100acd:	84 c0                	test   %al,%al
  100acf:	75 02                	jne    100ad3 <parse+0x4e>
            break;
  100ad1:	eb 67                	jmp    100b3a <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ad3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ad7:	75 14                	jne    100aed <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ad9:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ae0:	00 
  100ae1:	c7 04 24 75 60 10 00 	movl   $0x106075,(%esp)
  100ae8:	e8 5b f8 ff ff       	call   100348 <cprintf>
        }
        argv[argc ++] = buf;
  100aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100af0:	8d 50 01             	lea    0x1(%eax),%edx
  100af3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100af6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100afd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b00:	01 c2                	add    %eax,%edx
  100b02:	8b 45 08             	mov    0x8(%ebp),%eax
  100b05:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b07:	eb 04                	jmp    100b0d <parse+0x88>
            buf ++;
  100b09:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b10:	0f b6 00             	movzbl (%eax),%eax
  100b13:	84 c0                	test   %al,%al
  100b15:	74 1d                	je     100b34 <parse+0xaf>
  100b17:	8b 45 08             	mov    0x8(%ebp),%eax
  100b1a:	0f b6 00             	movzbl (%eax),%eax
  100b1d:	0f be c0             	movsbl %al,%eax
  100b20:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b24:	c7 04 24 70 60 10 00 	movl   $0x106070,(%esp)
  100b2b:	e8 c0 4f 00 00       	call   105af0 <strchr>
  100b30:	85 c0                	test   %eax,%eax
  100b32:	74 d5                	je     100b09 <parse+0x84>
            buf ++;
        }
    }
  100b34:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b35:	e9 66 ff ff ff       	jmp    100aa0 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b3d:	c9                   	leave  
  100b3e:	c3                   	ret    

00100b3f <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b3f:	55                   	push   %ebp
  100b40:	89 e5                	mov    %esp,%ebp
  100b42:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b45:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b48:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4f:	89 04 24             	mov    %eax,(%esp)
  100b52:	e8 2e ff ff ff       	call   100a85 <parse>
  100b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b5e:	75 0a                	jne    100b6a <runcmd+0x2b>
        return 0;
  100b60:	b8 00 00 00 00       	mov    $0x0,%eax
  100b65:	e9 85 00 00 00       	jmp    100bef <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b71:	eb 5c                	jmp    100bcf <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b73:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b79:	89 d0                	mov    %edx,%eax
  100b7b:	01 c0                	add    %eax,%eax
  100b7d:	01 d0                	add    %edx,%eax
  100b7f:	c1 e0 02             	shl    $0x2,%eax
  100b82:	05 00 70 11 00       	add    $0x117000,%eax
  100b87:	8b 00                	mov    (%eax),%eax
  100b89:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b8d:	89 04 24             	mov    %eax,(%esp)
  100b90:	e8 bc 4e 00 00       	call   105a51 <strcmp>
  100b95:	85 c0                	test   %eax,%eax
  100b97:	75 32                	jne    100bcb <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b9c:	89 d0                	mov    %edx,%eax
  100b9e:	01 c0                	add    %eax,%eax
  100ba0:	01 d0                	add    %edx,%eax
  100ba2:	c1 e0 02             	shl    $0x2,%eax
  100ba5:	05 00 70 11 00       	add    $0x117000,%eax
  100baa:	8b 40 08             	mov    0x8(%eax),%eax
  100bad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100bb0:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bb6:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bba:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bbd:	83 c2 04             	add    $0x4,%edx
  100bc0:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bc4:	89 0c 24             	mov    %ecx,(%esp)
  100bc7:	ff d0                	call   *%eax
  100bc9:	eb 24                	jmp    100bef <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bcb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bd2:	83 f8 02             	cmp    $0x2,%eax
  100bd5:	76 9c                	jbe    100b73 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bd7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bda:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bde:	c7 04 24 93 60 10 00 	movl   $0x106093,(%esp)
  100be5:	e8 5e f7 ff ff       	call   100348 <cprintf>
    return 0;
  100bea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bef:	c9                   	leave  
  100bf0:	c3                   	ret    

00100bf1 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bf1:	55                   	push   %ebp
  100bf2:	89 e5                	mov    %esp,%ebp
  100bf4:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bf7:	c7 04 24 ac 60 10 00 	movl   $0x1060ac,(%esp)
  100bfe:	e8 45 f7 ff ff       	call   100348 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c03:	c7 04 24 d4 60 10 00 	movl   $0x1060d4,(%esp)
  100c0a:	e8 39 f7 ff ff       	call   100348 <cprintf>

    if (tf != NULL) {
  100c0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c13:	74 0b                	je     100c20 <kmonitor+0x2f>
        print_trapframe(tf);
  100c15:	8b 45 08             	mov    0x8(%ebp),%eax
  100c18:	89 04 24             	mov    %eax,(%esp)
  100c1b:	e8 67 0e 00 00       	call   101a87 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c20:	c7 04 24 f9 60 10 00 	movl   $0x1060f9,(%esp)
  100c27:	e8 13 f6 ff ff       	call   10023f <readline>
  100c2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c33:	74 18                	je     100c4d <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c35:	8b 45 08             	mov    0x8(%ebp),%eax
  100c38:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c3f:	89 04 24             	mov    %eax,(%esp)
  100c42:	e8 f8 fe ff ff       	call   100b3f <runcmd>
  100c47:	85 c0                	test   %eax,%eax
  100c49:	79 02                	jns    100c4d <kmonitor+0x5c>
                break;
  100c4b:	eb 02                	jmp    100c4f <kmonitor+0x5e>
            }
        }
    }
  100c4d:	eb d1                	jmp    100c20 <kmonitor+0x2f>
}
  100c4f:	c9                   	leave  
  100c50:	c3                   	ret    

00100c51 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c51:	55                   	push   %ebp
  100c52:	89 e5                	mov    %esp,%ebp
  100c54:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c5e:	eb 3f                	jmp    100c9f <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c63:	89 d0                	mov    %edx,%eax
  100c65:	01 c0                	add    %eax,%eax
  100c67:	01 d0                	add    %edx,%eax
  100c69:	c1 e0 02             	shl    $0x2,%eax
  100c6c:	05 00 70 11 00       	add    $0x117000,%eax
  100c71:	8b 48 04             	mov    0x4(%eax),%ecx
  100c74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c77:	89 d0                	mov    %edx,%eax
  100c79:	01 c0                	add    %eax,%eax
  100c7b:	01 d0                	add    %edx,%eax
  100c7d:	c1 e0 02             	shl    $0x2,%eax
  100c80:	05 00 70 11 00       	add    $0x117000,%eax
  100c85:	8b 00                	mov    (%eax),%eax
  100c87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c8f:	c7 04 24 fd 60 10 00 	movl   $0x1060fd,(%esp)
  100c96:	e8 ad f6 ff ff       	call   100348 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c9b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca2:	83 f8 02             	cmp    $0x2,%eax
  100ca5:	76 b9                	jbe    100c60 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100ca7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cac:	c9                   	leave  
  100cad:	c3                   	ret    

00100cae <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100cae:	55                   	push   %ebp
  100caf:	89 e5                	mov    %esp,%ebp
  100cb1:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cb4:	e8 c3 fb ff ff       	call   10087c <print_kerninfo>
    return 0;
  100cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cbe:	c9                   	leave  
  100cbf:	c3                   	ret    

00100cc0 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cc0:	55                   	push   %ebp
  100cc1:	89 e5                	mov    %esp,%ebp
  100cc3:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cc6:	e8 fb fc ff ff       	call   1009c6 <print_stackframe>
    return 0;
  100ccb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cd0:	c9                   	leave  
  100cd1:	c3                   	ret    

00100cd2 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cd2:	55                   	push   %ebp
  100cd3:	89 e5                	mov    %esp,%ebp
  100cd5:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cd8:	a1 20 a4 11 00       	mov    0x11a420,%eax
  100cdd:	85 c0                	test   %eax,%eax
  100cdf:	74 02                	je     100ce3 <__panic+0x11>
        goto panic_dead;
  100ce1:	eb 59                	jmp    100d3c <__panic+0x6a>
    }
    is_panic = 1;
  100ce3:	c7 05 20 a4 11 00 01 	movl   $0x1,0x11a420
  100cea:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ced:	8d 45 14             	lea    0x14(%ebp),%eax
  100cf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cf6:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  100cfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d01:	c7 04 24 06 61 10 00 	movl   $0x106106,(%esp)
  100d08:	e8 3b f6 ff ff       	call   100348 <cprintf>
    vcprintf(fmt, ap);
  100d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d10:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d14:	8b 45 10             	mov    0x10(%ebp),%eax
  100d17:	89 04 24             	mov    %eax,(%esp)
  100d1a:	e8 f6 f5 ff ff       	call   100315 <vcprintf>
    cprintf("\n");
  100d1f:	c7 04 24 22 61 10 00 	movl   $0x106122,(%esp)
  100d26:	e8 1d f6 ff ff       	call   100348 <cprintf>
    
    cprintf("stack trackback:\n");
  100d2b:	c7 04 24 24 61 10 00 	movl   $0x106124,(%esp)
  100d32:	e8 11 f6 ff ff       	call   100348 <cprintf>
    print_stackframe();
  100d37:	e8 8a fc ff ff       	call   1009c6 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d3c:	e8 85 09 00 00       	call   1016c6 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d48:	e8 a4 fe ff ff       	call   100bf1 <kmonitor>
    }
  100d4d:	eb f2                	jmp    100d41 <__panic+0x6f>

00100d4f <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d4f:	55                   	push   %ebp
  100d50:	89 e5                	mov    %esp,%ebp
  100d52:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d55:	8d 45 14             	lea    0x14(%ebp),%eax
  100d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d62:	8b 45 08             	mov    0x8(%ebp),%eax
  100d65:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d69:	c7 04 24 36 61 10 00 	movl   $0x106136,(%esp)
  100d70:	e8 d3 f5 ff ff       	call   100348 <cprintf>
    vcprintf(fmt, ap);
  100d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d78:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d7c:	8b 45 10             	mov    0x10(%ebp),%eax
  100d7f:	89 04 24             	mov    %eax,(%esp)
  100d82:	e8 8e f5 ff ff       	call   100315 <vcprintf>
    cprintf("\n");
  100d87:	c7 04 24 22 61 10 00 	movl   $0x106122,(%esp)
  100d8e:	e8 b5 f5 ff ff       	call   100348 <cprintf>
    va_end(ap);
}
  100d93:	c9                   	leave  
  100d94:	c3                   	ret    

00100d95 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d95:	55                   	push   %ebp
  100d96:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d98:	a1 20 a4 11 00       	mov    0x11a420,%eax
}
  100d9d:	5d                   	pop    %ebp
  100d9e:	c3                   	ret    

00100d9f <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d9f:	55                   	push   %ebp
  100da0:	89 e5                	mov    %esp,%ebp
  100da2:	83 ec 28             	sub    $0x28,%esp
  100da5:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100dab:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100daf:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100db3:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100db7:	ee                   	out    %al,(%dx)
  100db8:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100dbe:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100dc2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dc6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dca:	ee                   	out    %al,(%dx)
  100dcb:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dd1:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dd5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dd9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ddd:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dde:	c7 05 0c af 11 00 00 	movl   $0x0,0x11af0c
  100de5:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100de8:	c7 04 24 54 61 10 00 	movl   $0x106154,(%esp)
  100def:	e8 54 f5 ff ff       	call   100348 <cprintf>
    pic_enable(IRQ_TIMER);
  100df4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dfb:	e8 24 09 00 00       	call   101724 <pic_enable>
}
  100e00:	c9                   	leave  
  100e01:	c3                   	ret    

00100e02 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e02:	55                   	push   %ebp
  100e03:	89 e5                	mov    %esp,%ebp
  100e05:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e08:	9c                   	pushf  
  100e09:	58                   	pop    %eax
  100e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e10:	25 00 02 00 00       	and    $0x200,%eax
  100e15:	85 c0                	test   %eax,%eax
  100e17:	74 0c                	je     100e25 <__intr_save+0x23>
        intr_disable();
  100e19:	e8 a8 08 00 00       	call   1016c6 <intr_disable>
        return 1;
  100e1e:	b8 01 00 00 00       	mov    $0x1,%eax
  100e23:	eb 05                	jmp    100e2a <__intr_save+0x28>
    }
    return 0;
  100e25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e2a:	c9                   	leave  
  100e2b:	c3                   	ret    

00100e2c <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e2c:	55                   	push   %ebp
  100e2d:	89 e5                	mov    %esp,%ebp
  100e2f:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e36:	74 05                	je     100e3d <__intr_restore+0x11>
        intr_enable();
  100e38:	e8 83 08 00 00       	call   1016c0 <intr_enable>
    }
}
  100e3d:	c9                   	leave  
  100e3e:	c3                   	ret    

00100e3f <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e3f:	55                   	push   %ebp
  100e40:	89 e5                	mov    %esp,%ebp
  100e42:	83 ec 10             	sub    $0x10,%esp
  100e45:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e4b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e4f:	89 c2                	mov    %eax,%edx
  100e51:	ec                   	in     (%dx),%al
  100e52:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e55:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e5b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e5f:	89 c2                	mov    %eax,%edx
  100e61:	ec                   	in     (%dx),%al
  100e62:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e65:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e6b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e6f:	89 c2                	mov    %eax,%edx
  100e71:	ec                   	in     (%dx),%al
  100e72:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e75:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e7b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e7f:	89 c2                	mov    %eax,%edx
  100e81:	ec                   	in     (%dx),%al
  100e82:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e85:	c9                   	leave  
  100e86:	c3                   	ret    

00100e87 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e87:	55                   	push   %ebp
  100e88:	89 e5                	mov    %esp,%ebp
  100e8a:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e8d:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e97:	0f b7 00             	movzwl (%eax),%eax
  100e9a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea1:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea9:	0f b7 00             	movzwl (%eax),%eax
  100eac:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100eb0:	74 12                	je     100ec4 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100eb2:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100eb9:	66 c7 05 46 a4 11 00 	movw   $0x3b4,0x11a446
  100ec0:	b4 03 
  100ec2:	eb 13                	jmp    100ed7 <cga_init+0x50>
    } else {
        *cp = was;
  100ec4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec7:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ecb:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ece:	66 c7 05 46 a4 11 00 	movw   $0x3d4,0x11a446
  100ed5:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ed7:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100ede:	0f b7 c0             	movzwl %ax,%eax
  100ee1:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ee5:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ee9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100eed:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ef1:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ef2:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100ef9:	83 c0 01             	add    $0x1,%eax
  100efc:	0f b7 c0             	movzwl %ax,%eax
  100eff:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f03:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f07:	89 c2                	mov    %eax,%edx
  100f09:	ec                   	in     (%dx),%al
  100f0a:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f0d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f11:	0f b6 c0             	movzbl %al,%eax
  100f14:	c1 e0 08             	shl    $0x8,%eax
  100f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f1a:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f21:	0f b7 c0             	movzwl %ax,%eax
  100f24:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f28:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f2c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f30:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f34:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f35:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f3c:	83 c0 01             	add    $0x1,%eax
  100f3f:	0f b7 c0             	movzwl %ax,%eax
  100f42:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f46:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f4a:	89 c2                	mov    %eax,%edx
  100f4c:	ec                   	in     (%dx),%al
  100f4d:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f50:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f54:	0f b6 c0             	movzbl %al,%eax
  100f57:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f5d:	a3 40 a4 11 00       	mov    %eax,0x11a440
    crt_pos = pos;
  100f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f65:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
}
  100f6b:	c9                   	leave  
  100f6c:	c3                   	ret    

00100f6d <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f6d:	55                   	push   %ebp
  100f6e:	89 e5                	mov    %esp,%ebp
  100f70:	83 ec 48             	sub    $0x48,%esp
  100f73:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f79:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f7d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f81:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f85:	ee                   	out    %al,(%dx)
  100f86:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f8c:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f90:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f94:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f98:	ee                   	out    %al,(%dx)
  100f99:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f9f:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100fa3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100fa7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fab:	ee                   	out    %al,(%dx)
  100fac:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fb2:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fb6:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fba:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fbe:	ee                   	out    %al,(%dx)
  100fbf:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fc5:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fc9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fcd:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fd1:	ee                   	out    %al,(%dx)
  100fd2:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fd8:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fdc:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fe0:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fe4:	ee                   	out    %al,(%dx)
  100fe5:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100feb:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fef:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100ff3:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100ff7:	ee                   	out    %al,(%dx)
  100ff8:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ffe:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  101002:	89 c2                	mov    %eax,%edx
  101004:	ec                   	in     (%dx),%al
  101005:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  101008:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10100c:	3c ff                	cmp    $0xff,%al
  10100e:	0f 95 c0             	setne  %al
  101011:	0f b6 c0             	movzbl %al,%eax
  101014:	a3 48 a4 11 00       	mov    %eax,0x11a448
  101019:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10101f:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101023:	89 c2                	mov    %eax,%edx
  101025:	ec                   	in     (%dx),%al
  101026:	88 45 d5             	mov    %al,-0x2b(%ebp)
  101029:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  10102f:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101033:	89 c2                	mov    %eax,%edx
  101035:	ec                   	in     (%dx),%al
  101036:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101039:	a1 48 a4 11 00       	mov    0x11a448,%eax
  10103e:	85 c0                	test   %eax,%eax
  101040:	74 0c                	je     10104e <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101042:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101049:	e8 d6 06 00 00       	call   101724 <pic_enable>
    }
}
  10104e:	c9                   	leave  
  10104f:	c3                   	ret    

00101050 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101050:	55                   	push   %ebp
  101051:	89 e5                	mov    %esp,%ebp
  101053:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101056:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10105d:	eb 09                	jmp    101068 <lpt_putc_sub+0x18>
        delay();
  10105f:	e8 db fd ff ff       	call   100e3f <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101064:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101068:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10106e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101072:	89 c2                	mov    %eax,%edx
  101074:	ec                   	in     (%dx),%al
  101075:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101078:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10107c:	84 c0                	test   %al,%al
  10107e:	78 09                	js     101089 <lpt_putc_sub+0x39>
  101080:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101087:	7e d6                	jle    10105f <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101089:	8b 45 08             	mov    0x8(%ebp),%eax
  10108c:	0f b6 c0             	movzbl %al,%eax
  10108f:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101095:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101098:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10109c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010a0:	ee                   	out    %al,(%dx)
  1010a1:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010a7:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  1010ab:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010af:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010b3:	ee                   	out    %al,(%dx)
  1010b4:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010ba:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010be:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010c2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010c6:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010c7:	c9                   	leave  
  1010c8:	c3                   	ret    

001010c9 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010c9:	55                   	push   %ebp
  1010ca:	89 e5                	mov    %esp,%ebp
  1010cc:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010cf:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010d3:	74 0d                	je     1010e2 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d8:	89 04 24             	mov    %eax,(%esp)
  1010db:	e8 70 ff ff ff       	call   101050 <lpt_putc_sub>
  1010e0:	eb 24                	jmp    101106 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010e2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010e9:	e8 62 ff ff ff       	call   101050 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010ee:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010f5:	e8 56 ff ff ff       	call   101050 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010fa:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101101:	e8 4a ff ff ff       	call   101050 <lpt_putc_sub>
    }
}
  101106:	c9                   	leave  
  101107:	c3                   	ret    

00101108 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101108:	55                   	push   %ebp
  101109:	89 e5                	mov    %esp,%ebp
  10110b:	53                   	push   %ebx
  10110c:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10110f:	8b 45 08             	mov    0x8(%ebp),%eax
  101112:	b0 00                	mov    $0x0,%al
  101114:	85 c0                	test   %eax,%eax
  101116:	75 07                	jne    10111f <cga_putc+0x17>
        c |= 0x0700;
  101118:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10111f:	8b 45 08             	mov    0x8(%ebp),%eax
  101122:	0f b6 c0             	movzbl %al,%eax
  101125:	83 f8 0a             	cmp    $0xa,%eax
  101128:	74 4c                	je     101176 <cga_putc+0x6e>
  10112a:	83 f8 0d             	cmp    $0xd,%eax
  10112d:	74 57                	je     101186 <cga_putc+0x7e>
  10112f:	83 f8 08             	cmp    $0x8,%eax
  101132:	0f 85 88 00 00 00    	jne    1011c0 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101138:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10113f:	66 85 c0             	test   %ax,%ax
  101142:	74 30                	je     101174 <cga_putc+0x6c>
            crt_pos --;
  101144:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10114b:	83 e8 01             	sub    $0x1,%eax
  10114e:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101154:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101159:	0f b7 15 44 a4 11 00 	movzwl 0x11a444,%edx
  101160:	0f b7 d2             	movzwl %dx,%edx
  101163:	01 d2                	add    %edx,%edx
  101165:	01 c2                	add    %eax,%edx
  101167:	8b 45 08             	mov    0x8(%ebp),%eax
  10116a:	b0 00                	mov    $0x0,%al
  10116c:	83 c8 20             	or     $0x20,%eax
  10116f:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101172:	eb 72                	jmp    1011e6 <cga_putc+0xde>
  101174:	eb 70                	jmp    1011e6 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101176:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10117d:	83 c0 50             	add    $0x50,%eax
  101180:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101186:	0f b7 1d 44 a4 11 00 	movzwl 0x11a444,%ebx
  10118d:	0f b7 0d 44 a4 11 00 	movzwl 0x11a444,%ecx
  101194:	0f b7 c1             	movzwl %cx,%eax
  101197:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10119d:	c1 e8 10             	shr    $0x10,%eax
  1011a0:	89 c2                	mov    %eax,%edx
  1011a2:	66 c1 ea 06          	shr    $0x6,%dx
  1011a6:	89 d0                	mov    %edx,%eax
  1011a8:	c1 e0 02             	shl    $0x2,%eax
  1011ab:	01 d0                	add    %edx,%eax
  1011ad:	c1 e0 04             	shl    $0x4,%eax
  1011b0:	29 c1                	sub    %eax,%ecx
  1011b2:	89 ca                	mov    %ecx,%edx
  1011b4:	89 d8                	mov    %ebx,%eax
  1011b6:	29 d0                	sub    %edx,%eax
  1011b8:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
        break;
  1011be:	eb 26                	jmp    1011e6 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011c0:	8b 0d 40 a4 11 00    	mov    0x11a440,%ecx
  1011c6:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011cd:	8d 50 01             	lea    0x1(%eax),%edx
  1011d0:	66 89 15 44 a4 11 00 	mov    %dx,0x11a444
  1011d7:	0f b7 c0             	movzwl %ax,%eax
  1011da:	01 c0                	add    %eax,%eax
  1011dc:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011df:	8b 45 08             	mov    0x8(%ebp),%eax
  1011e2:	66 89 02             	mov    %ax,(%edx)
        break;
  1011e5:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011e6:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011ed:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011f1:	76 5b                	jbe    10124e <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011f3:	a1 40 a4 11 00       	mov    0x11a440,%eax
  1011f8:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011fe:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101203:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10120a:	00 
  10120b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10120f:	89 04 24             	mov    %eax,(%esp)
  101212:	e8 d7 4a 00 00       	call   105cee <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101217:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10121e:	eb 15                	jmp    101235 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101220:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101225:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101228:	01 d2                	add    %edx,%edx
  10122a:	01 d0                	add    %edx,%eax
  10122c:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101231:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101235:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10123c:	7e e2                	jle    101220 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10123e:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101245:	83 e8 50             	sub    $0x50,%eax
  101248:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10124e:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  101255:	0f b7 c0             	movzwl %ax,%eax
  101258:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10125c:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101260:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101264:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101268:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101269:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101270:	66 c1 e8 08          	shr    $0x8,%ax
  101274:	0f b6 c0             	movzbl %al,%eax
  101277:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  10127e:	83 c2 01             	add    $0x1,%edx
  101281:	0f b7 d2             	movzwl %dx,%edx
  101284:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101288:	88 45 ed             	mov    %al,-0x13(%ebp)
  10128b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10128f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101293:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101294:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  10129b:	0f b7 c0             	movzwl %ax,%eax
  10129e:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  1012a2:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  1012a6:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012aa:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012ae:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1012af:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1012b6:	0f b6 c0             	movzbl %al,%eax
  1012b9:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  1012c0:	83 c2 01             	add    $0x1,%edx
  1012c3:	0f b7 d2             	movzwl %dx,%edx
  1012c6:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012ca:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012cd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012d1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012d5:	ee                   	out    %al,(%dx)
}
  1012d6:	83 c4 34             	add    $0x34,%esp
  1012d9:	5b                   	pop    %ebx
  1012da:	5d                   	pop    %ebp
  1012db:	c3                   	ret    

001012dc <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012dc:	55                   	push   %ebp
  1012dd:	89 e5                	mov    %esp,%ebp
  1012df:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012e9:	eb 09                	jmp    1012f4 <serial_putc_sub+0x18>
        delay();
  1012eb:	e8 4f fb ff ff       	call   100e3f <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012f0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012f4:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012fa:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012fe:	89 c2                	mov    %eax,%edx
  101300:	ec                   	in     (%dx),%al
  101301:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101304:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101308:	0f b6 c0             	movzbl %al,%eax
  10130b:	83 e0 20             	and    $0x20,%eax
  10130e:	85 c0                	test   %eax,%eax
  101310:	75 09                	jne    10131b <serial_putc_sub+0x3f>
  101312:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101319:	7e d0                	jle    1012eb <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  10131b:	8b 45 08             	mov    0x8(%ebp),%eax
  10131e:	0f b6 c0             	movzbl %al,%eax
  101321:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101327:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10132a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10132e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101332:	ee                   	out    %al,(%dx)
}
  101333:	c9                   	leave  
  101334:	c3                   	ret    

00101335 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101335:	55                   	push   %ebp
  101336:	89 e5                	mov    %esp,%ebp
  101338:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10133b:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10133f:	74 0d                	je     10134e <serial_putc+0x19>
        serial_putc_sub(c);
  101341:	8b 45 08             	mov    0x8(%ebp),%eax
  101344:	89 04 24             	mov    %eax,(%esp)
  101347:	e8 90 ff ff ff       	call   1012dc <serial_putc_sub>
  10134c:	eb 24                	jmp    101372 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  10134e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101355:	e8 82 ff ff ff       	call   1012dc <serial_putc_sub>
        serial_putc_sub(' ');
  10135a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101361:	e8 76 ff ff ff       	call   1012dc <serial_putc_sub>
        serial_putc_sub('\b');
  101366:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10136d:	e8 6a ff ff ff       	call   1012dc <serial_putc_sub>
    }
}
  101372:	c9                   	leave  
  101373:	c3                   	ret    

00101374 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101374:	55                   	push   %ebp
  101375:	89 e5                	mov    %esp,%ebp
  101377:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10137a:	eb 33                	jmp    1013af <cons_intr+0x3b>
        if (c != 0) {
  10137c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101380:	74 2d                	je     1013af <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101382:	a1 64 a6 11 00       	mov    0x11a664,%eax
  101387:	8d 50 01             	lea    0x1(%eax),%edx
  10138a:	89 15 64 a6 11 00    	mov    %edx,0x11a664
  101390:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101393:	88 90 60 a4 11 00    	mov    %dl,0x11a460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101399:	a1 64 a6 11 00       	mov    0x11a664,%eax
  10139e:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013a3:	75 0a                	jne    1013af <cons_intr+0x3b>
                cons.wpos = 0;
  1013a5:	c7 05 64 a6 11 00 00 	movl   $0x0,0x11a664
  1013ac:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  1013af:	8b 45 08             	mov    0x8(%ebp),%eax
  1013b2:	ff d0                	call   *%eax
  1013b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013b7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013bb:	75 bf                	jne    10137c <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013bd:	c9                   	leave  
  1013be:	c3                   	ret    

001013bf <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013bf:	55                   	push   %ebp
  1013c0:	89 e5                	mov    %esp,%ebp
  1013c2:	83 ec 10             	sub    $0x10,%esp
  1013c5:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013cb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013cf:	89 c2                	mov    %eax,%edx
  1013d1:	ec                   	in     (%dx),%al
  1013d2:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013d5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013d9:	0f b6 c0             	movzbl %al,%eax
  1013dc:	83 e0 01             	and    $0x1,%eax
  1013df:	85 c0                	test   %eax,%eax
  1013e1:	75 07                	jne    1013ea <serial_proc_data+0x2b>
        return -1;
  1013e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013e8:	eb 2a                	jmp    101414 <serial_proc_data+0x55>
  1013ea:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013f0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013f4:	89 c2                	mov    %eax,%edx
  1013f6:	ec                   	in     (%dx),%al
  1013f7:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013fa:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013fe:	0f b6 c0             	movzbl %al,%eax
  101401:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101404:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101408:	75 07                	jne    101411 <serial_proc_data+0x52>
        c = '\b';
  10140a:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101411:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101414:	c9                   	leave  
  101415:	c3                   	ret    

00101416 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101416:	55                   	push   %ebp
  101417:	89 e5                	mov    %esp,%ebp
  101419:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10141c:	a1 48 a4 11 00       	mov    0x11a448,%eax
  101421:	85 c0                	test   %eax,%eax
  101423:	74 0c                	je     101431 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101425:	c7 04 24 bf 13 10 00 	movl   $0x1013bf,(%esp)
  10142c:	e8 43 ff ff ff       	call   101374 <cons_intr>
    }
}
  101431:	c9                   	leave  
  101432:	c3                   	ret    

00101433 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101433:	55                   	push   %ebp
  101434:	89 e5                	mov    %esp,%ebp
  101436:	83 ec 38             	sub    $0x38,%esp
  101439:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10143f:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101443:	89 c2                	mov    %eax,%edx
  101445:	ec                   	in     (%dx),%al
  101446:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101449:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10144d:	0f b6 c0             	movzbl %al,%eax
  101450:	83 e0 01             	and    $0x1,%eax
  101453:	85 c0                	test   %eax,%eax
  101455:	75 0a                	jne    101461 <kbd_proc_data+0x2e>
        return -1;
  101457:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10145c:	e9 59 01 00 00       	jmp    1015ba <kbd_proc_data+0x187>
  101461:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101467:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10146b:	89 c2                	mov    %eax,%edx
  10146d:	ec                   	in     (%dx),%al
  10146e:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101471:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101475:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101478:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10147c:	75 17                	jne    101495 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10147e:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101483:	83 c8 40             	or     $0x40,%eax
  101486:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  10148b:	b8 00 00 00 00       	mov    $0x0,%eax
  101490:	e9 25 01 00 00       	jmp    1015ba <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101499:	84 c0                	test   %al,%al
  10149b:	79 47                	jns    1014e4 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10149d:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014a2:	83 e0 40             	and    $0x40,%eax
  1014a5:	85 c0                	test   %eax,%eax
  1014a7:	75 09                	jne    1014b2 <kbd_proc_data+0x7f>
  1014a9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ad:	83 e0 7f             	and    $0x7f,%eax
  1014b0:	eb 04                	jmp    1014b6 <kbd_proc_data+0x83>
  1014b2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b6:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014b9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014bd:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  1014c4:	83 c8 40             	or     $0x40,%eax
  1014c7:	0f b6 c0             	movzbl %al,%eax
  1014ca:	f7 d0                	not    %eax
  1014cc:	89 c2                	mov    %eax,%edx
  1014ce:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014d3:	21 d0                	and    %edx,%eax
  1014d5:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  1014da:	b8 00 00 00 00       	mov    $0x0,%eax
  1014df:	e9 d6 00 00 00       	jmp    1015ba <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014e4:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014e9:	83 e0 40             	and    $0x40,%eax
  1014ec:	85 c0                	test   %eax,%eax
  1014ee:	74 11                	je     101501 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014f0:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014f4:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014f9:	83 e0 bf             	and    $0xffffffbf,%eax
  1014fc:	a3 68 a6 11 00       	mov    %eax,0x11a668
    }

    shift |= shiftcode[data];
  101501:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101505:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  10150c:	0f b6 d0             	movzbl %al,%edx
  10150f:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101514:	09 d0                	or     %edx,%eax
  101516:	a3 68 a6 11 00       	mov    %eax,0x11a668
    shift ^= togglecode[data];
  10151b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10151f:	0f b6 80 40 71 11 00 	movzbl 0x117140(%eax),%eax
  101526:	0f b6 d0             	movzbl %al,%edx
  101529:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10152e:	31 d0                	xor    %edx,%eax
  101530:	a3 68 a6 11 00       	mov    %eax,0x11a668

    c = charcode[shift & (CTL | SHIFT)][data];
  101535:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10153a:	83 e0 03             	and    $0x3,%eax
  10153d:	8b 14 85 40 75 11 00 	mov    0x117540(,%eax,4),%edx
  101544:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101548:	01 d0                	add    %edx,%eax
  10154a:	0f b6 00             	movzbl (%eax),%eax
  10154d:	0f b6 c0             	movzbl %al,%eax
  101550:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101553:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101558:	83 e0 08             	and    $0x8,%eax
  10155b:	85 c0                	test   %eax,%eax
  10155d:	74 22                	je     101581 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10155f:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101563:	7e 0c                	jle    101571 <kbd_proc_data+0x13e>
  101565:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101569:	7f 06                	jg     101571 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  10156b:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10156f:	eb 10                	jmp    101581 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101571:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101575:	7e 0a                	jle    101581 <kbd_proc_data+0x14e>
  101577:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10157b:	7f 04                	jg     101581 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10157d:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101581:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101586:	f7 d0                	not    %eax
  101588:	83 e0 06             	and    $0x6,%eax
  10158b:	85 c0                	test   %eax,%eax
  10158d:	75 28                	jne    1015b7 <kbd_proc_data+0x184>
  10158f:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101596:	75 1f                	jne    1015b7 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101598:	c7 04 24 6f 61 10 00 	movl   $0x10616f,(%esp)
  10159f:	e8 a4 ed ff ff       	call   100348 <cprintf>
  1015a4:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015aa:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1015ae:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015b2:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015b6:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015ba:	c9                   	leave  
  1015bb:	c3                   	ret    

001015bc <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015bc:	55                   	push   %ebp
  1015bd:	89 e5                	mov    %esp,%ebp
  1015bf:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015c2:	c7 04 24 33 14 10 00 	movl   $0x101433,(%esp)
  1015c9:	e8 a6 fd ff ff       	call   101374 <cons_intr>
}
  1015ce:	c9                   	leave  
  1015cf:	c3                   	ret    

001015d0 <kbd_init>:

static void
kbd_init(void) {
  1015d0:	55                   	push   %ebp
  1015d1:	89 e5                	mov    %esp,%ebp
  1015d3:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015d6:	e8 e1 ff ff ff       	call   1015bc <kbd_intr>
    pic_enable(IRQ_KBD);
  1015db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015e2:	e8 3d 01 00 00       	call   101724 <pic_enable>
}
  1015e7:	c9                   	leave  
  1015e8:	c3                   	ret    

001015e9 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015e9:	55                   	push   %ebp
  1015ea:	89 e5                	mov    %esp,%ebp
  1015ec:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015ef:	e8 93 f8 ff ff       	call   100e87 <cga_init>
    serial_init();
  1015f4:	e8 74 f9 ff ff       	call   100f6d <serial_init>
    kbd_init();
  1015f9:	e8 d2 ff ff ff       	call   1015d0 <kbd_init>
    if (!serial_exists) {
  1015fe:	a1 48 a4 11 00       	mov    0x11a448,%eax
  101603:	85 c0                	test   %eax,%eax
  101605:	75 0c                	jne    101613 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101607:	c7 04 24 7b 61 10 00 	movl   $0x10617b,(%esp)
  10160e:	e8 35 ed ff ff       	call   100348 <cprintf>
    }
}
  101613:	c9                   	leave  
  101614:	c3                   	ret    

00101615 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101615:	55                   	push   %ebp
  101616:	89 e5                	mov    %esp,%ebp
  101618:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  10161b:	e8 e2 f7 ff ff       	call   100e02 <__intr_save>
  101620:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101623:	8b 45 08             	mov    0x8(%ebp),%eax
  101626:	89 04 24             	mov    %eax,(%esp)
  101629:	e8 9b fa ff ff       	call   1010c9 <lpt_putc>
        cga_putc(c);
  10162e:	8b 45 08             	mov    0x8(%ebp),%eax
  101631:	89 04 24             	mov    %eax,(%esp)
  101634:	e8 cf fa ff ff       	call   101108 <cga_putc>
        serial_putc(c);
  101639:	8b 45 08             	mov    0x8(%ebp),%eax
  10163c:	89 04 24             	mov    %eax,(%esp)
  10163f:	e8 f1 fc ff ff       	call   101335 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101647:	89 04 24             	mov    %eax,(%esp)
  10164a:	e8 dd f7 ff ff       	call   100e2c <__intr_restore>
}
  10164f:	c9                   	leave  
  101650:	c3                   	ret    

00101651 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101651:	55                   	push   %ebp
  101652:	89 e5                	mov    %esp,%ebp
  101654:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101657:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10165e:	e8 9f f7 ff ff       	call   100e02 <__intr_save>
  101663:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101666:	e8 ab fd ff ff       	call   101416 <serial_intr>
        kbd_intr();
  10166b:	e8 4c ff ff ff       	call   1015bc <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101670:	8b 15 60 a6 11 00    	mov    0x11a660,%edx
  101676:	a1 64 a6 11 00       	mov    0x11a664,%eax
  10167b:	39 c2                	cmp    %eax,%edx
  10167d:	74 31                	je     1016b0 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  10167f:	a1 60 a6 11 00       	mov    0x11a660,%eax
  101684:	8d 50 01             	lea    0x1(%eax),%edx
  101687:	89 15 60 a6 11 00    	mov    %edx,0x11a660
  10168d:	0f b6 80 60 a4 11 00 	movzbl 0x11a460(%eax),%eax
  101694:	0f b6 c0             	movzbl %al,%eax
  101697:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10169a:	a1 60 a6 11 00       	mov    0x11a660,%eax
  10169f:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016a4:	75 0a                	jne    1016b0 <cons_getc+0x5f>
                cons.rpos = 0;
  1016a6:	c7 05 60 a6 11 00 00 	movl   $0x0,0x11a660
  1016ad:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1016b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016b3:	89 04 24             	mov    %eax,(%esp)
  1016b6:	e8 71 f7 ff ff       	call   100e2c <__intr_restore>
    return c;
  1016bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016be:	c9                   	leave  
  1016bf:	c3                   	ret    

001016c0 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016c0:	55                   	push   %ebp
  1016c1:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016c3:	fb                   	sti    
    sti();
}
  1016c4:	5d                   	pop    %ebp
  1016c5:	c3                   	ret    

001016c6 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016c6:	55                   	push   %ebp
  1016c7:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016c9:	fa                   	cli    
    cli();
}
  1016ca:	5d                   	pop    %ebp
  1016cb:	c3                   	ret    

001016cc <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016cc:	55                   	push   %ebp
  1016cd:	89 e5                	mov    %esp,%ebp
  1016cf:	83 ec 14             	sub    $0x14,%esp
  1016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1016d5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016d9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016dd:	66 a3 50 75 11 00    	mov    %ax,0x117550
    if (did_init) {
  1016e3:	a1 6c a6 11 00       	mov    0x11a66c,%eax
  1016e8:	85 c0                	test   %eax,%eax
  1016ea:	74 36                	je     101722 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016ec:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016f0:	0f b6 c0             	movzbl %al,%eax
  1016f3:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016f9:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016fc:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101700:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101704:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101705:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101709:	66 c1 e8 08          	shr    $0x8,%ax
  10170d:	0f b6 c0             	movzbl %al,%eax
  101710:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101716:	88 45 f9             	mov    %al,-0x7(%ebp)
  101719:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10171d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101721:	ee                   	out    %al,(%dx)
    }
}
  101722:	c9                   	leave  
  101723:	c3                   	ret    

00101724 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101724:	55                   	push   %ebp
  101725:	89 e5                	mov    %esp,%ebp
  101727:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10172a:	8b 45 08             	mov    0x8(%ebp),%eax
  10172d:	ba 01 00 00 00       	mov    $0x1,%edx
  101732:	89 c1                	mov    %eax,%ecx
  101734:	d3 e2                	shl    %cl,%edx
  101736:	89 d0                	mov    %edx,%eax
  101738:	f7 d0                	not    %eax
  10173a:	89 c2                	mov    %eax,%edx
  10173c:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  101743:	21 d0                	and    %edx,%eax
  101745:	0f b7 c0             	movzwl %ax,%eax
  101748:	89 04 24             	mov    %eax,(%esp)
  10174b:	e8 7c ff ff ff       	call   1016cc <pic_setmask>
}
  101750:	c9                   	leave  
  101751:	c3                   	ret    

00101752 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101752:	55                   	push   %ebp
  101753:	89 e5                	mov    %esp,%ebp
  101755:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101758:	c7 05 6c a6 11 00 01 	movl   $0x1,0x11a66c
  10175f:	00 00 00 
  101762:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101768:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10176c:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101770:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101774:	ee                   	out    %al,(%dx)
  101775:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10177b:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  10177f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101783:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101787:	ee                   	out    %al,(%dx)
  101788:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10178e:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101792:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101796:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10179a:	ee                   	out    %al,(%dx)
  10179b:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1017a1:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1017a5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1017a9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017ad:	ee                   	out    %al,(%dx)
  1017ae:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1017b4:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017b8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017bc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017c0:	ee                   	out    %al,(%dx)
  1017c1:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017c7:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017cb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017cf:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017d3:	ee                   	out    %al,(%dx)
  1017d4:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017da:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017de:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017e2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017e6:	ee                   	out    %al,(%dx)
  1017e7:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017ed:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017f1:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017f5:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017f9:	ee                   	out    %al,(%dx)
  1017fa:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101800:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101804:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101808:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10180c:	ee                   	out    %al,(%dx)
  10180d:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101813:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101817:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10181b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10181f:	ee                   	out    %al,(%dx)
  101820:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101826:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10182a:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10182e:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101832:	ee                   	out    %al,(%dx)
  101833:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101839:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10183d:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101841:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101845:	ee                   	out    %al,(%dx)
  101846:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10184c:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101850:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101854:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101858:	ee                   	out    %al,(%dx)
  101859:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  10185f:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101863:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101867:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10186b:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10186c:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  101873:	66 83 f8 ff          	cmp    $0xffff,%ax
  101877:	74 12                	je     10188b <pic_init+0x139>
        pic_setmask(irq_mask);
  101879:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  101880:	0f b7 c0             	movzwl %ax,%eax
  101883:	89 04 24             	mov    %eax,(%esp)
  101886:	e8 41 fe ff ff       	call   1016cc <pic_setmask>
    }
}
  10188b:	c9                   	leave  
  10188c:	c3                   	ret    

0010188d <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10188d:	55                   	push   %ebp
  10188e:	89 e5                	mov    %esp,%ebp
  101890:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101893:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10189a:	00 
  10189b:	c7 04 24 a0 61 10 00 	movl   $0x1061a0,(%esp)
  1018a2:	e8 a1 ea ff ff       	call   100348 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1018a7:	c7 04 24 aa 61 10 00 	movl   $0x1061aa,(%esp)
  1018ae:	e8 95 ea ff ff       	call   100348 <cprintf>
    panic("EOT: kernel seems ok.");
  1018b3:	c7 44 24 08 b8 61 10 	movl   $0x1061b8,0x8(%esp)
  1018ba:	00 
  1018bb:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018c2:	00 
  1018c3:	c7 04 24 ce 61 10 00 	movl   $0x1061ce,(%esp)
  1018ca:	e8 03 f4 ff ff       	call   100cd2 <__panic>

001018cf <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018cf:	55                   	push   %ebp
  1018d0:	89 e5                	mov    %esp,%ebp
  1018d2:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];   //define ISR's entry addrs _vectors[]
    int i = 0;
  1018d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    //arguments：0 means interrupt，GD_KTEXT means kernel text
    //use SETGATE macro to setup each item of IDT
    while(i < sizeof(idt) / sizeof(struct gatedesc)) {
  1018dc:	e9 c3 00 00 00       	jmp    1019a4 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e4:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  1018eb:	89 c2                	mov    %eax,%edx
  1018ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f0:	66 89 14 c5 80 a6 11 	mov    %dx,0x11a680(,%eax,8)
  1018f7:	00 
  1018f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fb:	66 c7 04 c5 82 a6 11 	movw   $0x8,0x11a682(,%eax,8)
  101902:	00 08 00 
  101905:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101908:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  10190f:	00 
  101910:	83 e2 e0             	and    $0xffffffe0,%edx
  101913:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  10191a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191d:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  101924:	00 
  101925:	83 e2 1f             	and    $0x1f,%edx
  101928:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  10192f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101932:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101939:	00 
  10193a:	83 e2 f0             	and    $0xfffffff0,%edx
  10193d:	83 ca 0e             	or     $0xe,%edx
  101940:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101947:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194a:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101951:	00 
  101952:	83 e2 ef             	and    $0xffffffef,%edx
  101955:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  10195c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195f:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101966:	00 
  101967:	83 e2 9f             	and    $0xffffff9f,%edx
  10196a:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101971:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101974:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  10197b:	00 
  10197c:	83 ca 80             	or     $0xffffff80,%edx
  10197f:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101986:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101989:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  101990:	c1 e8 10             	shr    $0x10,%eax
  101993:	89 c2                	mov    %eax,%edx
  101995:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101998:	66 89 14 c5 86 a6 11 	mov    %dx,0x11a686(,%eax,8)
  10199f:	00 
        i ++;
  1019a0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
      */
    extern uintptr_t __vectors[];   //define ISR's entry addrs _vectors[]
    int i = 0;
    //arguments：0 means interrupt，GD_KTEXT means kernel text
    //use SETGATE macro to setup each item of IDT
    while(i < sizeof(idt) / sizeof(struct gatedesc)) {
  1019a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a7:	3d ff 00 00 00       	cmp    $0xff,%eax
  1019ac:	0f 86 2f ff ff ff    	jbe    1018e1 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
        i ++;
    }
    // switch from user state to kernel state
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1019b2:	a1 c4 77 11 00       	mov    0x1177c4,%eax
  1019b7:	66 a3 48 aa 11 00    	mov    %ax,0x11aa48
  1019bd:	66 c7 05 4a aa 11 00 	movw   $0x8,0x11aa4a
  1019c4:	08 00 
  1019c6:	0f b6 05 4c aa 11 00 	movzbl 0x11aa4c,%eax
  1019cd:	83 e0 e0             	and    $0xffffffe0,%eax
  1019d0:	a2 4c aa 11 00       	mov    %al,0x11aa4c
  1019d5:	0f b6 05 4c aa 11 00 	movzbl 0x11aa4c,%eax
  1019dc:	83 e0 1f             	and    $0x1f,%eax
  1019df:	a2 4c aa 11 00       	mov    %al,0x11aa4c
  1019e4:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  1019eb:	83 e0 f0             	and    $0xfffffff0,%eax
  1019ee:	83 c8 0e             	or     $0xe,%eax
  1019f1:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  1019f6:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  1019fd:	83 e0 ef             	and    $0xffffffef,%eax
  101a00:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101a05:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  101a0c:	83 c8 60             	or     $0x60,%eax
  101a0f:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101a14:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  101a1b:	83 c8 80             	or     $0xffffff80,%eax
  101a1e:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101a23:	a1 c4 77 11 00       	mov    0x1177c4,%eax
  101a28:	c1 e8 10             	shr    $0x10,%eax
  101a2b:	66 a3 4e aa 11 00    	mov    %ax,0x11aa4e
  101a31:	c7 45 f8 60 75 11 00 	movl   $0x117560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a3b:	0f 01 18             	lidtl  (%eax)
    //let CPU know where is IDT by using 'lidt' instruction
    lidt(&idt_pd);
}
  101a3e:	c9                   	leave  
  101a3f:	c3                   	ret    

00101a40 <trapname>:

static const char *
trapname(int trapno) {
  101a40:	55                   	push   %ebp
  101a41:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a43:	8b 45 08             	mov    0x8(%ebp),%eax
  101a46:	83 f8 13             	cmp    $0x13,%eax
  101a49:	77 0c                	ja     101a57 <trapname+0x17>
        return excnames[trapno];
  101a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4e:	8b 04 85 20 65 10 00 	mov    0x106520(,%eax,4),%eax
  101a55:	eb 18                	jmp    101a6f <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a57:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a5b:	7e 0d                	jle    101a6a <trapname+0x2a>
  101a5d:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a61:	7f 07                	jg     101a6a <trapname+0x2a>
        return "Hardware Interrupt";
  101a63:	b8 df 61 10 00       	mov    $0x1061df,%eax
  101a68:	eb 05                	jmp    101a6f <trapname+0x2f>
    }
    return "(unknown trap)";
  101a6a:	b8 f2 61 10 00       	mov    $0x1061f2,%eax
}
  101a6f:	5d                   	pop    %ebp
  101a70:	c3                   	ret    

00101a71 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a71:	55                   	push   %ebp
  101a72:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a74:	8b 45 08             	mov    0x8(%ebp),%eax
  101a77:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a7b:	66 83 f8 08          	cmp    $0x8,%ax
  101a7f:	0f 94 c0             	sete   %al
  101a82:	0f b6 c0             	movzbl %al,%eax
}
  101a85:	5d                   	pop    %ebp
  101a86:	c3                   	ret    

00101a87 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a87:	55                   	push   %ebp
  101a88:	89 e5                	mov    %esp,%ebp
  101a8a:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a90:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a94:	c7 04 24 33 62 10 00 	movl   $0x106233,(%esp)
  101a9b:	e8 a8 e8 ff ff       	call   100348 <cprintf>
    print_regs(&tf->tf_regs);
  101aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa3:	89 04 24             	mov    %eax,(%esp)
  101aa6:	e8 a1 01 00 00       	call   101c4c <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101aab:	8b 45 08             	mov    0x8(%ebp),%eax
  101aae:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101ab2:	0f b7 c0             	movzwl %ax,%eax
  101ab5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab9:	c7 04 24 44 62 10 00 	movl   $0x106244,(%esp)
  101ac0:	e8 83 e8 ff ff       	call   100348 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac8:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101acc:	0f b7 c0             	movzwl %ax,%eax
  101acf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad3:	c7 04 24 57 62 10 00 	movl   $0x106257,(%esp)
  101ada:	e8 69 e8 ff ff       	call   100348 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101adf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae2:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101ae6:	0f b7 c0             	movzwl %ax,%eax
  101ae9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aed:	c7 04 24 6a 62 10 00 	movl   $0x10626a,(%esp)
  101af4:	e8 4f e8 ff ff       	call   100348 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101af9:	8b 45 08             	mov    0x8(%ebp),%eax
  101afc:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b00:	0f b7 c0             	movzwl %ax,%eax
  101b03:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b07:	c7 04 24 7d 62 10 00 	movl   $0x10627d,(%esp)
  101b0e:	e8 35 e8 ff ff       	call   100348 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b13:	8b 45 08             	mov    0x8(%ebp),%eax
  101b16:	8b 40 30             	mov    0x30(%eax),%eax
  101b19:	89 04 24             	mov    %eax,(%esp)
  101b1c:	e8 1f ff ff ff       	call   101a40 <trapname>
  101b21:	8b 55 08             	mov    0x8(%ebp),%edx
  101b24:	8b 52 30             	mov    0x30(%edx),%edx
  101b27:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b2b:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b2f:	c7 04 24 90 62 10 00 	movl   $0x106290,(%esp)
  101b36:	e8 0d e8 ff ff       	call   100348 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3e:	8b 40 34             	mov    0x34(%eax),%eax
  101b41:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b45:	c7 04 24 a2 62 10 00 	movl   $0x1062a2,(%esp)
  101b4c:	e8 f7 e7 ff ff       	call   100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b51:	8b 45 08             	mov    0x8(%ebp),%eax
  101b54:	8b 40 38             	mov    0x38(%eax),%eax
  101b57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5b:	c7 04 24 b1 62 10 00 	movl   $0x1062b1,(%esp)
  101b62:	e8 e1 e7 ff ff       	call   100348 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b67:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b6e:	0f b7 c0             	movzwl %ax,%eax
  101b71:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b75:	c7 04 24 c0 62 10 00 	movl   $0x1062c0,(%esp)
  101b7c:	e8 c7 e7 ff ff       	call   100348 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b81:	8b 45 08             	mov    0x8(%ebp),%eax
  101b84:	8b 40 40             	mov    0x40(%eax),%eax
  101b87:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8b:	c7 04 24 d3 62 10 00 	movl   $0x1062d3,(%esp)
  101b92:	e8 b1 e7 ff ff       	call   100348 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b9e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ba5:	eb 3e                	jmp    101be5 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  101baa:	8b 50 40             	mov    0x40(%eax),%edx
  101bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101bb0:	21 d0                	and    %edx,%eax
  101bb2:	85 c0                	test   %eax,%eax
  101bb4:	74 28                	je     101bde <print_trapframe+0x157>
  101bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bb9:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101bc0:	85 c0                	test   %eax,%eax
  101bc2:	74 1a                	je     101bde <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bc7:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101bce:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd2:	c7 04 24 e2 62 10 00 	movl   $0x1062e2,(%esp)
  101bd9:	e8 6a e7 ff ff       	call   100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bde:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101be2:	d1 65 f0             	shll   -0x10(%ebp)
  101be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101be8:	83 f8 17             	cmp    $0x17,%eax
  101beb:	76 ba                	jbe    101ba7 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bed:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf0:	8b 40 40             	mov    0x40(%eax),%eax
  101bf3:	25 00 30 00 00       	and    $0x3000,%eax
  101bf8:	c1 e8 0c             	shr    $0xc,%eax
  101bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bff:	c7 04 24 e6 62 10 00 	movl   $0x1062e6,(%esp)
  101c06:	e8 3d e7 ff ff       	call   100348 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0e:	89 04 24             	mov    %eax,(%esp)
  101c11:	e8 5b fe ff ff       	call   101a71 <trap_in_kernel>
  101c16:	85 c0                	test   %eax,%eax
  101c18:	75 30                	jne    101c4a <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1d:	8b 40 44             	mov    0x44(%eax),%eax
  101c20:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c24:	c7 04 24 ef 62 10 00 	movl   $0x1062ef,(%esp)
  101c2b:	e8 18 e7 ff ff       	call   100348 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c30:	8b 45 08             	mov    0x8(%ebp),%eax
  101c33:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c37:	0f b7 c0             	movzwl %ax,%eax
  101c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3e:	c7 04 24 fe 62 10 00 	movl   $0x1062fe,(%esp)
  101c45:	e8 fe e6 ff ff       	call   100348 <cprintf>
    }
}
  101c4a:	c9                   	leave  
  101c4b:	c3                   	ret    

00101c4c <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c4c:	55                   	push   %ebp
  101c4d:	89 e5                	mov    %esp,%ebp
  101c4f:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c52:	8b 45 08             	mov    0x8(%ebp),%eax
  101c55:	8b 00                	mov    (%eax),%eax
  101c57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5b:	c7 04 24 11 63 10 00 	movl   $0x106311,(%esp)
  101c62:	e8 e1 e6 ff ff       	call   100348 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c67:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6a:	8b 40 04             	mov    0x4(%eax),%eax
  101c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c71:	c7 04 24 20 63 10 00 	movl   $0x106320,(%esp)
  101c78:	e8 cb e6 ff ff       	call   100348 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c80:	8b 40 08             	mov    0x8(%eax),%eax
  101c83:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c87:	c7 04 24 2f 63 10 00 	movl   $0x10632f,(%esp)
  101c8e:	e8 b5 e6 ff ff       	call   100348 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c93:	8b 45 08             	mov    0x8(%ebp),%eax
  101c96:	8b 40 0c             	mov    0xc(%eax),%eax
  101c99:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9d:	c7 04 24 3e 63 10 00 	movl   $0x10633e,(%esp)
  101ca4:	e8 9f e6 ff ff       	call   100348 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cac:	8b 40 10             	mov    0x10(%eax),%eax
  101caf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb3:	c7 04 24 4d 63 10 00 	movl   $0x10634d,(%esp)
  101cba:	e8 89 e6 ff ff       	call   100348 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc2:	8b 40 14             	mov    0x14(%eax),%eax
  101cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc9:	c7 04 24 5c 63 10 00 	movl   $0x10635c,(%esp)
  101cd0:	e8 73 e6 ff ff       	call   100348 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd8:	8b 40 18             	mov    0x18(%eax),%eax
  101cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cdf:	c7 04 24 6b 63 10 00 	movl   $0x10636b,(%esp)
  101ce6:	e8 5d e6 ff ff       	call   100348 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cee:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf5:	c7 04 24 7a 63 10 00 	movl   $0x10637a,(%esp)
  101cfc:	e8 47 e6 ff ff       	call   100348 <cprintf>
}
  101d01:	c9                   	leave  
  101d02:	c3                   	ret    

00101d03 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d03:	55                   	push   %ebp
  101d04:	89 e5                	mov    %esp,%ebp
  101d06:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101d09:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0c:	8b 40 30             	mov    0x30(%eax),%eax
  101d0f:	83 f8 2f             	cmp    $0x2f,%eax
  101d12:	77 21                	ja     101d35 <trap_dispatch+0x32>
  101d14:	83 f8 2e             	cmp    $0x2e,%eax
  101d17:	0f 83 04 01 00 00    	jae    101e21 <trap_dispatch+0x11e>
  101d1d:	83 f8 21             	cmp    $0x21,%eax
  101d20:	0f 84 81 00 00 00    	je     101da7 <trap_dispatch+0xa4>
  101d26:	83 f8 24             	cmp    $0x24,%eax
  101d29:	74 56                	je     101d81 <trap_dispatch+0x7e>
  101d2b:	83 f8 20             	cmp    $0x20,%eax
  101d2e:	74 16                	je     101d46 <trap_dispatch+0x43>
  101d30:	e9 b4 00 00 00       	jmp    101de9 <trap_dispatch+0xe6>
  101d35:	83 e8 78             	sub    $0x78,%eax
  101d38:	83 f8 01             	cmp    $0x1,%eax
  101d3b:	0f 87 a8 00 00 00    	ja     101de9 <trap_dispatch+0xe6>
  101d41:	e9 87 00 00 00       	jmp    101dcd <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101d46:	a1 0c af 11 00       	mov    0x11af0c,%eax
  101d4b:	83 c0 01             	add    $0x1,%eax
  101d4e:	a3 0c af 11 00       	mov    %eax,0x11af0c
        if (ticks % TICK_NUM == 0) {
  101d53:	8b 0d 0c af 11 00    	mov    0x11af0c,%ecx
  101d59:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d5e:	89 c8                	mov    %ecx,%eax
  101d60:	f7 e2                	mul    %edx
  101d62:	89 d0                	mov    %edx,%eax
  101d64:	c1 e8 05             	shr    $0x5,%eax
  101d67:	6b c0 64             	imul   $0x64,%eax,%eax
  101d6a:	29 c1                	sub    %eax,%ecx
  101d6c:	89 c8                	mov    %ecx,%eax
  101d6e:	85 c0                	test   %eax,%eax
  101d70:	75 0a                	jne    101d7c <trap_dispatch+0x79>
            print_ticks();
  101d72:	e8 16 fb ff ff       	call   10188d <print_ticks>
        }
        break;
  101d77:	e9 a6 00 00 00       	jmp    101e22 <trap_dispatch+0x11f>
  101d7c:	e9 a1 00 00 00       	jmp    101e22 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d81:	e8 cb f8 ff ff       	call   101651 <cons_getc>
  101d86:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d89:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d8d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d91:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d95:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d99:	c7 04 24 89 63 10 00 	movl   $0x106389,(%esp)
  101da0:	e8 a3 e5 ff ff       	call   100348 <cprintf>
        break;
  101da5:	eb 7b                	jmp    101e22 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101da7:	e8 a5 f8 ff ff       	call   101651 <cons_getc>
  101dac:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101daf:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101db3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101db7:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dbf:	c7 04 24 9b 63 10 00 	movl   $0x10639b,(%esp)
  101dc6:	e8 7d e5 ff ff       	call   100348 <cprintf>
        break;
  101dcb:	eb 55                	jmp    101e22 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101dcd:	c7 44 24 08 aa 63 10 	movl   $0x1063aa,0x8(%esp)
  101dd4:	00 
  101dd5:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  101ddc:	00 
  101ddd:	c7 04 24 ce 61 10 00 	movl   $0x1061ce,(%esp)
  101de4:	e8 e9 ee ff ff       	call   100cd2 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101de9:	8b 45 08             	mov    0x8(%ebp),%eax
  101dec:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101df0:	0f b7 c0             	movzwl %ax,%eax
  101df3:	83 e0 03             	and    $0x3,%eax
  101df6:	85 c0                	test   %eax,%eax
  101df8:	75 28                	jne    101e22 <trap_dispatch+0x11f>
            print_trapframe(tf);
  101dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  101dfd:	89 04 24             	mov    %eax,(%esp)
  101e00:	e8 82 fc ff ff       	call   101a87 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e05:	c7 44 24 08 ba 63 10 	movl   $0x1063ba,0x8(%esp)
  101e0c:	00 
  101e0d:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
  101e14:	00 
  101e15:	c7 04 24 ce 61 10 00 	movl   $0x1061ce,(%esp)
  101e1c:	e8 b1 ee ff ff       	call   100cd2 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e21:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e22:	c9                   	leave  
  101e23:	c3                   	ret    

00101e24 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e24:	55                   	push   %ebp
  101e25:	89 e5                	mov    %esp,%ebp
  101e27:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e2d:	89 04 24             	mov    %eax,(%esp)
  101e30:	e8 ce fe ff ff       	call   101d03 <trap_dispatch>
}
  101e35:	c9                   	leave  
  101e36:	c3                   	ret    

00101e37 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e37:	1e                   	push   %ds
    pushl %es
  101e38:	06                   	push   %es
    pushl %fs
  101e39:	0f a0                	push   %fs
    pushl %gs
  101e3b:	0f a8                	push   %gs
    pushal
  101e3d:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e3e:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e43:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e45:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e47:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e48:	e8 d7 ff ff ff       	call   101e24 <trap>

    # pop the pushed stack pointer
    popl %esp
  101e4d:	5c                   	pop    %esp

00101e4e <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e4e:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e4f:	0f a9                	pop    %gs
    popl %fs
  101e51:	0f a1                	pop    %fs
    popl %es
  101e53:	07                   	pop    %es
    popl %ds
  101e54:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e55:	83 c4 08             	add    $0x8,%esp
    iret
  101e58:	cf                   	iret   

00101e59 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e59:	6a 00                	push   $0x0
  pushl $0
  101e5b:	6a 00                	push   $0x0
  jmp __alltraps
  101e5d:	e9 d5 ff ff ff       	jmp    101e37 <__alltraps>

00101e62 <vector1>:
.globl vector1
vector1:
  pushl $0
  101e62:	6a 00                	push   $0x0
  pushl $1
  101e64:	6a 01                	push   $0x1
  jmp __alltraps
  101e66:	e9 cc ff ff ff       	jmp    101e37 <__alltraps>

00101e6b <vector2>:
.globl vector2
vector2:
  pushl $0
  101e6b:	6a 00                	push   $0x0
  pushl $2
  101e6d:	6a 02                	push   $0x2
  jmp __alltraps
  101e6f:	e9 c3 ff ff ff       	jmp    101e37 <__alltraps>

00101e74 <vector3>:
.globl vector3
vector3:
  pushl $0
  101e74:	6a 00                	push   $0x0
  pushl $3
  101e76:	6a 03                	push   $0x3
  jmp __alltraps
  101e78:	e9 ba ff ff ff       	jmp    101e37 <__alltraps>

00101e7d <vector4>:
.globl vector4
vector4:
  pushl $0
  101e7d:	6a 00                	push   $0x0
  pushl $4
  101e7f:	6a 04                	push   $0x4
  jmp __alltraps
  101e81:	e9 b1 ff ff ff       	jmp    101e37 <__alltraps>

00101e86 <vector5>:
.globl vector5
vector5:
  pushl $0
  101e86:	6a 00                	push   $0x0
  pushl $5
  101e88:	6a 05                	push   $0x5
  jmp __alltraps
  101e8a:	e9 a8 ff ff ff       	jmp    101e37 <__alltraps>

00101e8f <vector6>:
.globl vector6
vector6:
  pushl $0
  101e8f:	6a 00                	push   $0x0
  pushl $6
  101e91:	6a 06                	push   $0x6
  jmp __alltraps
  101e93:	e9 9f ff ff ff       	jmp    101e37 <__alltraps>

00101e98 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e98:	6a 00                	push   $0x0
  pushl $7
  101e9a:	6a 07                	push   $0x7
  jmp __alltraps
  101e9c:	e9 96 ff ff ff       	jmp    101e37 <__alltraps>

00101ea1 <vector8>:
.globl vector8
vector8:
  pushl $8
  101ea1:	6a 08                	push   $0x8
  jmp __alltraps
  101ea3:	e9 8f ff ff ff       	jmp    101e37 <__alltraps>

00101ea8 <vector9>:
.globl vector9
vector9:
  pushl $0
  101ea8:	6a 00                	push   $0x0
  pushl $9
  101eaa:	6a 09                	push   $0x9
  jmp __alltraps
  101eac:	e9 86 ff ff ff       	jmp    101e37 <__alltraps>

00101eb1 <vector10>:
.globl vector10
vector10:
  pushl $10
  101eb1:	6a 0a                	push   $0xa
  jmp __alltraps
  101eb3:	e9 7f ff ff ff       	jmp    101e37 <__alltraps>

00101eb8 <vector11>:
.globl vector11
vector11:
  pushl $11
  101eb8:	6a 0b                	push   $0xb
  jmp __alltraps
  101eba:	e9 78 ff ff ff       	jmp    101e37 <__alltraps>

00101ebf <vector12>:
.globl vector12
vector12:
  pushl $12
  101ebf:	6a 0c                	push   $0xc
  jmp __alltraps
  101ec1:	e9 71 ff ff ff       	jmp    101e37 <__alltraps>

00101ec6 <vector13>:
.globl vector13
vector13:
  pushl $13
  101ec6:	6a 0d                	push   $0xd
  jmp __alltraps
  101ec8:	e9 6a ff ff ff       	jmp    101e37 <__alltraps>

00101ecd <vector14>:
.globl vector14
vector14:
  pushl $14
  101ecd:	6a 0e                	push   $0xe
  jmp __alltraps
  101ecf:	e9 63 ff ff ff       	jmp    101e37 <__alltraps>

00101ed4 <vector15>:
.globl vector15
vector15:
  pushl $0
  101ed4:	6a 00                	push   $0x0
  pushl $15
  101ed6:	6a 0f                	push   $0xf
  jmp __alltraps
  101ed8:	e9 5a ff ff ff       	jmp    101e37 <__alltraps>

00101edd <vector16>:
.globl vector16
vector16:
  pushl $0
  101edd:	6a 00                	push   $0x0
  pushl $16
  101edf:	6a 10                	push   $0x10
  jmp __alltraps
  101ee1:	e9 51 ff ff ff       	jmp    101e37 <__alltraps>

00101ee6 <vector17>:
.globl vector17
vector17:
  pushl $17
  101ee6:	6a 11                	push   $0x11
  jmp __alltraps
  101ee8:	e9 4a ff ff ff       	jmp    101e37 <__alltraps>

00101eed <vector18>:
.globl vector18
vector18:
  pushl $0
  101eed:	6a 00                	push   $0x0
  pushl $18
  101eef:	6a 12                	push   $0x12
  jmp __alltraps
  101ef1:	e9 41 ff ff ff       	jmp    101e37 <__alltraps>

00101ef6 <vector19>:
.globl vector19
vector19:
  pushl $0
  101ef6:	6a 00                	push   $0x0
  pushl $19
  101ef8:	6a 13                	push   $0x13
  jmp __alltraps
  101efa:	e9 38 ff ff ff       	jmp    101e37 <__alltraps>

00101eff <vector20>:
.globl vector20
vector20:
  pushl $0
  101eff:	6a 00                	push   $0x0
  pushl $20
  101f01:	6a 14                	push   $0x14
  jmp __alltraps
  101f03:	e9 2f ff ff ff       	jmp    101e37 <__alltraps>

00101f08 <vector21>:
.globl vector21
vector21:
  pushl $0
  101f08:	6a 00                	push   $0x0
  pushl $21
  101f0a:	6a 15                	push   $0x15
  jmp __alltraps
  101f0c:	e9 26 ff ff ff       	jmp    101e37 <__alltraps>

00101f11 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f11:	6a 00                	push   $0x0
  pushl $22
  101f13:	6a 16                	push   $0x16
  jmp __alltraps
  101f15:	e9 1d ff ff ff       	jmp    101e37 <__alltraps>

00101f1a <vector23>:
.globl vector23
vector23:
  pushl $0
  101f1a:	6a 00                	push   $0x0
  pushl $23
  101f1c:	6a 17                	push   $0x17
  jmp __alltraps
  101f1e:	e9 14 ff ff ff       	jmp    101e37 <__alltraps>

00101f23 <vector24>:
.globl vector24
vector24:
  pushl $0
  101f23:	6a 00                	push   $0x0
  pushl $24
  101f25:	6a 18                	push   $0x18
  jmp __alltraps
  101f27:	e9 0b ff ff ff       	jmp    101e37 <__alltraps>

00101f2c <vector25>:
.globl vector25
vector25:
  pushl $0
  101f2c:	6a 00                	push   $0x0
  pushl $25
  101f2e:	6a 19                	push   $0x19
  jmp __alltraps
  101f30:	e9 02 ff ff ff       	jmp    101e37 <__alltraps>

00101f35 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f35:	6a 00                	push   $0x0
  pushl $26
  101f37:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f39:	e9 f9 fe ff ff       	jmp    101e37 <__alltraps>

00101f3e <vector27>:
.globl vector27
vector27:
  pushl $0
  101f3e:	6a 00                	push   $0x0
  pushl $27
  101f40:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f42:	e9 f0 fe ff ff       	jmp    101e37 <__alltraps>

00101f47 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f47:	6a 00                	push   $0x0
  pushl $28
  101f49:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f4b:	e9 e7 fe ff ff       	jmp    101e37 <__alltraps>

00101f50 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f50:	6a 00                	push   $0x0
  pushl $29
  101f52:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f54:	e9 de fe ff ff       	jmp    101e37 <__alltraps>

00101f59 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f59:	6a 00                	push   $0x0
  pushl $30
  101f5b:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f5d:	e9 d5 fe ff ff       	jmp    101e37 <__alltraps>

00101f62 <vector31>:
.globl vector31
vector31:
  pushl $0
  101f62:	6a 00                	push   $0x0
  pushl $31
  101f64:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f66:	e9 cc fe ff ff       	jmp    101e37 <__alltraps>

00101f6b <vector32>:
.globl vector32
vector32:
  pushl $0
  101f6b:	6a 00                	push   $0x0
  pushl $32
  101f6d:	6a 20                	push   $0x20
  jmp __alltraps
  101f6f:	e9 c3 fe ff ff       	jmp    101e37 <__alltraps>

00101f74 <vector33>:
.globl vector33
vector33:
  pushl $0
  101f74:	6a 00                	push   $0x0
  pushl $33
  101f76:	6a 21                	push   $0x21
  jmp __alltraps
  101f78:	e9 ba fe ff ff       	jmp    101e37 <__alltraps>

00101f7d <vector34>:
.globl vector34
vector34:
  pushl $0
  101f7d:	6a 00                	push   $0x0
  pushl $34
  101f7f:	6a 22                	push   $0x22
  jmp __alltraps
  101f81:	e9 b1 fe ff ff       	jmp    101e37 <__alltraps>

00101f86 <vector35>:
.globl vector35
vector35:
  pushl $0
  101f86:	6a 00                	push   $0x0
  pushl $35
  101f88:	6a 23                	push   $0x23
  jmp __alltraps
  101f8a:	e9 a8 fe ff ff       	jmp    101e37 <__alltraps>

00101f8f <vector36>:
.globl vector36
vector36:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $36
  101f91:	6a 24                	push   $0x24
  jmp __alltraps
  101f93:	e9 9f fe ff ff       	jmp    101e37 <__alltraps>

00101f98 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f98:	6a 00                	push   $0x0
  pushl $37
  101f9a:	6a 25                	push   $0x25
  jmp __alltraps
  101f9c:	e9 96 fe ff ff       	jmp    101e37 <__alltraps>

00101fa1 <vector38>:
.globl vector38
vector38:
  pushl $0
  101fa1:	6a 00                	push   $0x0
  pushl $38
  101fa3:	6a 26                	push   $0x26
  jmp __alltraps
  101fa5:	e9 8d fe ff ff       	jmp    101e37 <__alltraps>

00101faa <vector39>:
.globl vector39
vector39:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $39
  101fac:	6a 27                	push   $0x27
  jmp __alltraps
  101fae:	e9 84 fe ff ff       	jmp    101e37 <__alltraps>

00101fb3 <vector40>:
.globl vector40
vector40:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $40
  101fb5:	6a 28                	push   $0x28
  jmp __alltraps
  101fb7:	e9 7b fe ff ff       	jmp    101e37 <__alltraps>

00101fbc <vector41>:
.globl vector41
vector41:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $41
  101fbe:	6a 29                	push   $0x29
  jmp __alltraps
  101fc0:	e9 72 fe ff ff       	jmp    101e37 <__alltraps>

00101fc5 <vector42>:
.globl vector42
vector42:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $42
  101fc7:	6a 2a                	push   $0x2a
  jmp __alltraps
  101fc9:	e9 69 fe ff ff       	jmp    101e37 <__alltraps>

00101fce <vector43>:
.globl vector43
vector43:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $43
  101fd0:	6a 2b                	push   $0x2b
  jmp __alltraps
  101fd2:	e9 60 fe ff ff       	jmp    101e37 <__alltraps>

00101fd7 <vector44>:
.globl vector44
vector44:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $44
  101fd9:	6a 2c                	push   $0x2c
  jmp __alltraps
  101fdb:	e9 57 fe ff ff       	jmp    101e37 <__alltraps>

00101fe0 <vector45>:
.globl vector45
vector45:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $45
  101fe2:	6a 2d                	push   $0x2d
  jmp __alltraps
  101fe4:	e9 4e fe ff ff       	jmp    101e37 <__alltraps>

00101fe9 <vector46>:
.globl vector46
vector46:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $46
  101feb:	6a 2e                	push   $0x2e
  jmp __alltraps
  101fed:	e9 45 fe ff ff       	jmp    101e37 <__alltraps>

00101ff2 <vector47>:
.globl vector47
vector47:
  pushl $0
  101ff2:	6a 00                	push   $0x0
  pushl $47
  101ff4:	6a 2f                	push   $0x2f
  jmp __alltraps
  101ff6:	e9 3c fe ff ff       	jmp    101e37 <__alltraps>

00101ffb <vector48>:
.globl vector48
vector48:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $48
  101ffd:	6a 30                	push   $0x30
  jmp __alltraps
  101fff:	e9 33 fe ff ff       	jmp    101e37 <__alltraps>

00102004 <vector49>:
.globl vector49
vector49:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $49
  102006:	6a 31                	push   $0x31
  jmp __alltraps
  102008:	e9 2a fe ff ff       	jmp    101e37 <__alltraps>

0010200d <vector50>:
.globl vector50
vector50:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $50
  10200f:	6a 32                	push   $0x32
  jmp __alltraps
  102011:	e9 21 fe ff ff       	jmp    101e37 <__alltraps>

00102016 <vector51>:
.globl vector51
vector51:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $51
  102018:	6a 33                	push   $0x33
  jmp __alltraps
  10201a:	e9 18 fe ff ff       	jmp    101e37 <__alltraps>

0010201f <vector52>:
.globl vector52
vector52:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $52
  102021:	6a 34                	push   $0x34
  jmp __alltraps
  102023:	e9 0f fe ff ff       	jmp    101e37 <__alltraps>

00102028 <vector53>:
.globl vector53
vector53:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $53
  10202a:	6a 35                	push   $0x35
  jmp __alltraps
  10202c:	e9 06 fe ff ff       	jmp    101e37 <__alltraps>

00102031 <vector54>:
.globl vector54
vector54:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $54
  102033:	6a 36                	push   $0x36
  jmp __alltraps
  102035:	e9 fd fd ff ff       	jmp    101e37 <__alltraps>

0010203a <vector55>:
.globl vector55
vector55:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $55
  10203c:	6a 37                	push   $0x37
  jmp __alltraps
  10203e:	e9 f4 fd ff ff       	jmp    101e37 <__alltraps>

00102043 <vector56>:
.globl vector56
vector56:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $56
  102045:	6a 38                	push   $0x38
  jmp __alltraps
  102047:	e9 eb fd ff ff       	jmp    101e37 <__alltraps>

0010204c <vector57>:
.globl vector57
vector57:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $57
  10204e:	6a 39                	push   $0x39
  jmp __alltraps
  102050:	e9 e2 fd ff ff       	jmp    101e37 <__alltraps>

00102055 <vector58>:
.globl vector58
vector58:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $58
  102057:	6a 3a                	push   $0x3a
  jmp __alltraps
  102059:	e9 d9 fd ff ff       	jmp    101e37 <__alltraps>

0010205e <vector59>:
.globl vector59
vector59:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $59
  102060:	6a 3b                	push   $0x3b
  jmp __alltraps
  102062:	e9 d0 fd ff ff       	jmp    101e37 <__alltraps>

00102067 <vector60>:
.globl vector60
vector60:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $60
  102069:	6a 3c                	push   $0x3c
  jmp __alltraps
  10206b:	e9 c7 fd ff ff       	jmp    101e37 <__alltraps>

00102070 <vector61>:
.globl vector61
vector61:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $61
  102072:	6a 3d                	push   $0x3d
  jmp __alltraps
  102074:	e9 be fd ff ff       	jmp    101e37 <__alltraps>

00102079 <vector62>:
.globl vector62
vector62:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $62
  10207b:	6a 3e                	push   $0x3e
  jmp __alltraps
  10207d:	e9 b5 fd ff ff       	jmp    101e37 <__alltraps>

00102082 <vector63>:
.globl vector63
vector63:
  pushl $0
  102082:	6a 00                	push   $0x0
  pushl $63
  102084:	6a 3f                	push   $0x3f
  jmp __alltraps
  102086:	e9 ac fd ff ff       	jmp    101e37 <__alltraps>

0010208b <vector64>:
.globl vector64
vector64:
  pushl $0
  10208b:	6a 00                	push   $0x0
  pushl $64
  10208d:	6a 40                	push   $0x40
  jmp __alltraps
  10208f:	e9 a3 fd ff ff       	jmp    101e37 <__alltraps>

00102094 <vector65>:
.globl vector65
vector65:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $65
  102096:	6a 41                	push   $0x41
  jmp __alltraps
  102098:	e9 9a fd ff ff       	jmp    101e37 <__alltraps>

0010209d <vector66>:
.globl vector66
vector66:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $66
  10209f:	6a 42                	push   $0x42
  jmp __alltraps
  1020a1:	e9 91 fd ff ff       	jmp    101e37 <__alltraps>

001020a6 <vector67>:
.globl vector67
vector67:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $67
  1020a8:	6a 43                	push   $0x43
  jmp __alltraps
  1020aa:	e9 88 fd ff ff       	jmp    101e37 <__alltraps>

001020af <vector68>:
.globl vector68
vector68:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $68
  1020b1:	6a 44                	push   $0x44
  jmp __alltraps
  1020b3:	e9 7f fd ff ff       	jmp    101e37 <__alltraps>

001020b8 <vector69>:
.globl vector69
vector69:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $69
  1020ba:	6a 45                	push   $0x45
  jmp __alltraps
  1020bc:	e9 76 fd ff ff       	jmp    101e37 <__alltraps>

001020c1 <vector70>:
.globl vector70
vector70:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $70
  1020c3:	6a 46                	push   $0x46
  jmp __alltraps
  1020c5:	e9 6d fd ff ff       	jmp    101e37 <__alltraps>

001020ca <vector71>:
.globl vector71
vector71:
  pushl $0
  1020ca:	6a 00                	push   $0x0
  pushl $71
  1020cc:	6a 47                	push   $0x47
  jmp __alltraps
  1020ce:	e9 64 fd ff ff       	jmp    101e37 <__alltraps>

001020d3 <vector72>:
.globl vector72
vector72:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $72
  1020d5:	6a 48                	push   $0x48
  jmp __alltraps
  1020d7:	e9 5b fd ff ff       	jmp    101e37 <__alltraps>

001020dc <vector73>:
.globl vector73
vector73:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $73
  1020de:	6a 49                	push   $0x49
  jmp __alltraps
  1020e0:	e9 52 fd ff ff       	jmp    101e37 <__alltraps>

001020e5 <vector74>:
.globl vector74
vector74:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $74
  1020e7:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020e9:	e9 49 fd ff ff       	jmp    101e37 <__alltraps>

001020ee <vector75>:
.globl vector75
vector75:
  pushl $0
  1020ee:	6a 00                	push   $0x0
  pushl $75
  1020f0:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020f2:	e9 40 fd ff ff       	jmp    101e37 <__alltraps>

001020f7 <vector76>:
.globl vector76
vector76:
  pushl $0
  1020f7:	6a 00                	push   $0x0
  pushl $76
  1020f9:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020fb:	e9 37 fd ff ff       	jmp    101e37 <__alltraps>

00102100 <vector77>:
.globl vector77
vector77:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $77
  102102:	6a 4d                	push   $0x4d
  jmp __alltraps
  102104:	e9 2e fd ff ff       	jmp    101e37 <__alltraps>

00102109 <vector78>:
.globl vector78
vector78:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $78
  10210b:	6a 4e                	push   $0x4e
  jmp __alltraps
  10210d:	e9 25 fd ff ff       	jmp    101e37 <__alltraps>

00102112 <vector79>:
.globl vector79
vector79:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $79
  102114:	6a 4f                	push   $0x4f
  jmp __alltraps
  102116:	e9 1c fd ff ff       	jmp    101e37 <__alltraps>

0010211b <vector80>:
.globl vector80
vector80:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $80
  10211d:	6a 50                	push   $0x50
  jmp __alltraps
  10211f:	e9 13 fd ff ff       	jmp    101e37 <__alltraps>

00102124 <vector81>:
.globl vector81
vector81:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $81
  102126:	6a 51                	push   $0x51
  jmp __alltraps
  102128:	e9 0a fd ff ff       	jmp    101e37 <__alltraps>

0010212d <vector82>:
.globl vector82
vector82:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $82
  10212f:	6a 52                	push   $0x52
  jmp __alltraps
  102131:	e9 01 fd ff ff       	jmp    101e37 <__alltraps>

00102136 <vector83>:
.globl vector83
vector83:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $83
  102138:	6a 53                	push   $0x53
  jmp __alltraps
  10213a:	e9 f8 fc ff ff       	jmp    101e37 <__alltraps>

0010213f <vector84>:
.globl vector84
vector84:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $84
  102141:	6a 54                	push   $0x54
  jmp __alltraps
  102143:	e9 ef fc ff ff       	jmp    101e37 <__alltraps>

00102148 <vector85>:
.globl vector85
vector85:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $85
  10214a:	6a 55                	push   $0x55
  jmp __alltraps
  10214c:	e9 e6 fc ff ff       	jmp    101e37 <__alltraps>

00102151 <vector86>:
.globl vector86
vector86:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $86
  102153:	6a 56                	push   $0x56
  jmp __alltraps
  102155:	e9 dd fc ff ff       	jmp    101e37 <__alltraps>

0010215a <vector87>:
.globl vector87
vector87:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $87
  10215c:	6a 57                	push   $0x57
  jmp __alltraps
  10215e:	e9 d4 fc ff ff       	jmp    101e37 <__alltraps>

00102163 <vector88>:
.globl vector88
vector88:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $88
  102165:	6a 58                	push   $0x58
  jmp __alltraps
  102167:	e9 cb fc ff ff       	jmp    101e37 <__alltraps>

0010216c <vector89>:
.globl vector89
vector89:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $89
  10216e:	6a 59                	push   $0x59
  jmp __alltraps
  102170:	e9 c2 fc ff ff       	jmp    101e37 <__alltraps>

00102175 <vector90>:
.globl vector90
vector90:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $90
  102177:	6a 5a                	push   $0x5a
  jmp __alltraps
  102179:	e9 b9 fc ff ff       	jmp    101e37 <__alltraps>

0010217e <vector91>:
.globl vector91
vector91:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $91
  102180:	6a 5b                	push   $0x5b
  jmp __alltraps
  102182:	e9 b0 fc ff ff       	jmp    101e37 <__alltraps>

00102187 <vector92>:
.globl vector92
vector92:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $92
  102189:	6a 5c                	push   $0x5c
  jmp __alltraps
  10218b:	e9 a7 fc ff ff       	jmp    101e37 <__alltraps>

00102190 <vector93>:
.globl vector93
vector93:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $93
  102192:	6a 5d                	push   $0x5d
  jmp __alltraps
  102194:	e9 9e fc ff ff       	jmp    101e37 <__alltraps>

00102199 <vector94>:
.globl vector94
vector94:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $94
  10219b:	6a 5e                	push   $0x5e
  jmp __alltraps
  10219d:	e9 95 fc ff ff       	jmp    101e37 <__alltraps>

001021a2 <vector95>:
.globl vector95
vector95:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $95
  1021a4:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021a6:	e9 8c fc ff ff       	jmp    101e37 <__alltraps>

001021ab <vector96>:
.globl vector96
vector96:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $96
  1021ad:	6a 60                	push   $0x60
  jmp __alltraps
  1021af:	e9 83 fc ff ff       	jmp    101e37 <__alltraps>

001021b4 <vector97>:
.globl vector97
vector97:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $97
  1021b6:	6a 61                	push   $0x61
  jmp __alltraps
  1021b8:	e9 7a fc ff ff       	jmp    101e37 <__alltraps>

001021bd <vector98>:
.globl vector98
vector98:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $98
  1021bf:	6a 62                	push   $0x62
  jmp __alltraps
  1021c1:	e9 71 fc ff ff       	jmp    101e37 <__alltraps>

001021c6 <vector99>:
.globl vector99
vector99:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $99
  1021c8:	6a 63                	push   $0x63
  jmp __alltraps
  1021ca:	e9 68 fc ff ff       	jmp    101e37 <__alltraps>

001021cf <vector100>:
.globl vector100
vector100:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $100
  1021d1:	6a 64                	push   $0x64
  jmp __alltraps
  1021d3:	e9 5f fc ff ff       	jmp    101e37 <__alltraps>

001021d8 <vector101>:
.globl vector101
vector101:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $101
  1021da:	6a 65                	push   $0x65
  jmp __alltraps
  1021dc:	e9 56 fc ff ff       	jmp    101e37 <__alltraps>

001021e1 <vector102>:
.globl vector102
vector102:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $102
  1021e3:	6a 66                	push   $0x66
  jmp __alltraps
  1021e5:	e9 4d fc ff ff       	jmp    101e37 <__alltraps>

001021ea <vector103>:
.globl vector103
vector103:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $103
  1021ec:	6a 67                	push   $0x67
  jmp __alltraps
  1021ee:	e9 44 fc ff ff       	jmp    101e37 <__alltraps>

001021f3 <vector104>:
.globl vector104
vector104:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $104
  1021f5:	6a 68                	push   $0x68
  jmp __alltraps
  1021f7:	e9 3b fc ff ff       	jmp    101e37 <__alltraps>

001021fc <vector105>:
.globl vector105
vector105:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $105
  1021fe:	6a 69                	push   $0x69
  jmp __alltraps
  102200:	e9 32 fc ff ff       	jmp    101e37 <__alltraps>

00102205 <vector106>:
.globl vector106
vector106:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $106
  102207:	6a 6a                	push   $0x6a
  jmp __alltraps
  102209:	e9 29 fc ff ff       	jmp    101e37 <__alltraps>

0010220e <vector107>:
.globl vector107
vector107:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $107
  102210:	6a 6b                	push   $0x6b
  jmp __alltraps
  102212:	e9 20 fc ff ff       	jmp    101e37 <__alltraps>

00102217 <vector108>:
.globl vector108
vector108:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $108
  102219:	6a 6c                	push   $0x6c
  jmp __alltraps
  10221b:	e9 17 fc ff ff       	jmp    101e37 <__alltraps>

00102220 <vector109>:
.globl vector109
vector109:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $109
  102222:	6a 6d                	push   $0x6d
  jmp __alltraps
  102224:	e9 0e fc ff ff       	jmp    101e37 <__alltraps>

00102229 <vector110>:
.globl vector110
vector110:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $110
  10222b:	6a 6e                	push   $0x6e
  jmp __alltraps
  10222d:	e9 05 fc ff ff       	jmp    101e37 <__alltraps>

00102232 <vector111>:
.globl vector111
vector111:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $111
  102234:	6a 6f                	push   $0x6f
  jmp __alltraps
  102236:	e9 fc fb ff ff       	jmp    101e37 <__alltraps>

0010223b <vector112>:
.globl vector112
vector112:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $112
  10223d:	6a 70                	push   $0x70
  jmp __alltraps
  10223f:	e9 f3 fb ff ff       	jmp    101e37 <__alltraps>

00102244 <vector113>:
.globl vector113
vector113:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $113
  102246:	6a 71                	push   $0x71
  jmp __alltraps
  102248:	e9 ea fb ff ff       	jmp    101e37 <__alltraps>

0010224d <vector114>:
.globl vector114
vector114:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $114
  10224f:	6a 72                	push   $0x72
  jmp __alltraps
  102251:	e9 e1 fb ff ff       	jmp    101e37 <__alltraps>

00102256 <vector115>:
.globl vector115
vector115:
  pushl $0
  102256:	6a 00                	push   $0x0
  pushl $115
  102258:	6a 73                	push   $0x73
  jmp __alltraps
  10225a:	e9 d8 fb ff ff       	jmp    101e37 <__alltraps>

0010225f <vector116>:
.globl vector116
vector116:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $116
  102261:	6a 74                	push   $0x74
  jmp __alltraps
  102263:	e9 cf fb ff ff       	jmp    101e37 <__alltraps>

00102268 <vector117>:
.globl vector117
vector117:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $117
  10226a:	6a 75                	push   $0x75
  jmp __alltraps
  10226c:	e9 c6 fb ff ff       	jmp    101e37 <__alltraps>

00102271 <vector118>:
.globl vector118
vector118:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $118
  102273:	6a 76                	push   $0x76
  jmp __alltraps
  102275:	e9 bd fb ff ff       	jmp    101e37 <__alltraps>

0010227a <vector119>:
.globl vector119
vector119:
  pushl $0
  10227a:	6a 00                	push   $0x0
  pushl $119
  10227c:	6a 77                	push   $0x77
  jmp __alltraps
  10227e:	e9 b4 fb ff ff       	jmp    101e37 <__alltraps>

00102283 <vector120>:
.globl vector120
vector120:
  pushl $0
  102283:	6a 00                	push   $0x0
  pushl $120
  102285:	6a 78                	push   $0x78
  jmp __alltraps
  102287:	e9 ab fb ff ff       	jmp    101e37 <__alltraps>

0010228c <vector121>:
.globl vector121
vector121:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $121
  10228e:	6a 79                	push   $0x79
  jmp __alltraps
  102290:	e9 a2 fb ff ff       	jmp    101e37 <__alltraps>

00102295 <vector122>:
.globl vector122
vector122:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $122
  102297:	6a 7a                	push   $0x7a
  jmp __alltraps
  102299:	e9 99 fb ff ff       	jmp    101e37 <__alltraps>

0010229e <vector123>:
.globl vector123
vector123:
  pushl $0
  10229e:	6a 00                	push   $0x0
  pushl $123
  1022a0:	6a 7b                	push   $0x7b
  jmp __alltraps
  1022a2:	e9 90 fb ff ff       	jmp    101e37 <__alltraps>

001022a7 <vector124>:
.globl vector124
vector124:
  pushl $0
  1022a7:	6a 00                	push   $0x0
  pushl $124
  1022a9:	6a 7c                	push   $0x7c
  jmp __alltraps
  1022ab:	e9 87 fb ff ff       	jmp    101e37 <__alltraps>

001022b0 <vector125>:
.globl vector125
vector125:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $125
  1022b2:	6a 7d                	push   $0x7d
  jmp __alltraps
  1022b4:	e9 7e fb ff ff       	jmp    101e37 <__alltraps>

001022b9 <vector126>:
.globl vector126
vector126:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $126
  1022bb:	6a 7e                	push   $0x7e
  jmp __alltraps
  1022bd:	e9 75 fb ff ff       	jmp    101e37 <__alltraps>

001022c2 <vector127>:
.globl vector127
vector127:
  pushl $0
  1022c2:	6a 00                	push   $0x0
  pushl $127
  1022c4:	6a 7f                	push   $0x7f
  jmp __alltraps
  1022c6:	e9 6c fb ff ff       	jmp    101e37 <__alltraps>

001022cb <vector128>:
.globl vector128
vector128:
  pushl $0
  1022cb:	6a 00                	push   $0x0
  pushl $128
  1022cd:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1022d2:	e9 60 fb ff ff       	jmp    101e37 <__alltraps>

001022d7 <vector129>:
.globl vector129
vector129:
  pushl $0
  1022d7:	6a 00                	push   $0x0
  pushl $129
  1022d9:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022de:	e9 54 fb ff ff       	jmp    101e37 <__alltraps>

001022e3 <vector130>:
.globl vector130
vector130:
  pushl $0
  1022e3:	6a 00                	push   $0x0
  pushl $130
  1022e5:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022ea:	e9 48 fb ff ff       	jmp    101e37 <__alltraps>

001022ef <vector131>:
.globl vector131
vector131:
  pushl $0
  1022ef:	6a 00                	push   $0x0
  pushl $131
  1022f1:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022f6:	e9 3c fb ff ff       	jmp    101e37 <__alltraps>

001022fb <vector132>:
.globl vector132
vector132:
  pushl $0
  1022fb:	6a 00                	push   $0x0
  pushl $132
  1022fd:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102302:	e9 30 fb ff ff       	jmp    101e37 <__alltraps>

00102307 <vector133>:
.globl vector133
vector133:
  pushl $0
  102307:	6a 00                	push   $0x0
  pushl $133
  102309:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10230e:	e9 24 fb ff ff       	jmp    101e37 <__alltraps>

00102313 <vector134>:
.globl vector134
vector134:
  pushl $0
  102313:	6a 00                	push   $0x0
  pushl $134
  102315:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10231a:	e9 18 fb ff ff       	jmp    101e37 <__alltraps>

0010231f <vector135>:
.globl vector135
vector135:
  pushl $0
  10231f:	6a 00                	push   $0x0
  pushl $135
  102321:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102326:	e9 0c fb ff ff       	jmp    101e37 <__alltraps>

0010232b <vector136>:
.globl vector136
vector136:
  pushl $0
  10232b:	6a 00                	push   $0x0
  pushl $136
  10232d:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102332:	e9 00 fb ff ff       	jmp    101e37 <__alltraps>

00102337 <vector137>:
.globl vector137
vector137:
  pushl $0
  102337:	6a 00                	push   $0x0
  pushl $137
  102339:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10233e:	e9 f4 fa ff ff       	jmp    101e37 <__alltraps>

00102343 <vector138>:
.globl vector138
vector138:
  pushl $0
  102343:	6a 00                	push   $0x0
  pushl $138
  102345:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10234a:	e9 e8 fa ff ff       	jmp    101e37 <__alltraps>

0010234f <vector139>:
.globl vector139
vector139:
  pushl $0
  10234f:	6a 00                	push   $0x0
  pushl $139
  102351:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102356:	e9 dc fa ff ff       	jmp    101e37 <__alltraps>

0010235b <vector140>:
.globl vector140
vector140:
  pushl $0
  10235b:	6a 00                	push   $0x0
  pushl $140
  10235d:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102362:	e9 d0 fa ff ff       	jmp    101e37 <__alltraps>

00102367 <vector141>:
.globl vector141
vector141:
  pushl $0
  102367:	6a 00                	push   $0x0
  pushl $141
  102369:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10236e:	e9 c4 fa ff ff       	jmp    101e37 <__alltraps>

00102373 <vector142>:
.globl vector142
vector142:
  pushl $0
  102373:	6a 00                	push   $0x0
  pushl $142
  102375:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10237a:	e9 b8 fa ff ff       	jmp    101e37 <__alltraps>

0010237f <vector143>:
.globl vector143
vector143:
  pushl $0
  10237f:	6a 00                	push   $0x0
  pushl $143
  102381:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102386:	e9 ac fa ff ff       	jmp    101e37 <__alltraps>

0010238b <vector144>:
.globl vector144
vector144:
  pushl $0
  10238b:	6a 00                	push   $0x0
  pushl $144
  10238d:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102392:	e9 a0 fa ff ff       	jmp    101e37 <__alltraps>

00102397 <vector145>:
.globl vector145
vector145:
  pushl $0
  102397:	6a 00                	push   $0x0
  pushl $145
  102399:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10239e:	e9 94 fa ff ff       	jmp    101e37 <__alltraps>

001023a3 <vector146>:
.globl vector146
vector146:
  pushl $0
  1023a3:	6a 00                	push   $0x0
  pushl $146
  1023a5:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1023aa:	e9 88 fa ff ff       	jmp    101e37 <__alltraps>

001023af <vector147>:
.globl vector147
vector147:
  pushl $0
  1023af:	6a 00                	push   $0x0
  pushl $147
  1023b1:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1023b6:	e9 7c fa ff ff       	jmp    101e37 <__alltraps>

001023bb <vector148>:
.globl vector148
vector148:
  pushl $0
  1023bb:	6a 00                	push   $0x0
  pushl $148
  1023bd:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1023c2:	e9 70 fa ff ff       	jmp    101e37 <__alltraps>

001023c7 <vector149>:
.globl vector149
vector149:
  pushl $0
  1023c7:	6a 00                	push   $0x0
  pushl $149
  1023c9:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1023ce:	e9 64 fa ff ff       	jmp    101e37 <__alltraps>

001023d3 <vector150>:
.globl vector150
vector150:
  pushl $0
  1023d3:	6a 00                	push   $0x0
  pushl $150
  1023d5:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023da:	e9 58 fa ff ff       	jmp    101e37 <__alltraps>

001023df <vector151>:
.globl vector151
vector151:
  pushl $0
  1023df:	6a 00                	push   $0x0
  pushl $151
  1023e1:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023e6:	e9 4c fa ff ff       	jmp    101e37 <__alltraps>

001023eb <vector152>:
.globl vector152
vector152:
  pushl $0
  1023eb:	6a 00                	push   $0x0
  pushl $152
  1023ed:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023f2:	e9 40 fa ff ff       	jmp    101e37 <__alltraps>

001023f7 <vector153>:
.globl vector153
vector153:
  pushl $0
  1023f7:	6a 00                	push   $0x0
  pushl $153
  1023f9:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1023fe:	e9 34 fa ff ff       	jmp    101e37 <__alltraps>

00102403 <vector154>:
.globl vector154
vector154:
  pushl $0
  102403:	6a 00                	push   $0x0
  pushl $154
  102405:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10240a:	e9 28 fa ff ff       	jmp    101e37 <__alltraps>

0010240f <vector155>:
.globl vector155
vector155:
  pushl $0
  10240f:	6a 00                	push   $0x0
  pushl $155
  102411:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102416:	e9 1c fa ff ff       	jmp    101e37 <__alltraps>

0010241b <vector156>:
.globl vector156
vector156:
  pushl $0
  10241b:	6a 00                	push   $0x0
  pushl $156
  10241d:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102422:	e9 10 fa ff ff       	jmp    101e37 <__alltraps>

00102427 <vector157>:
.globl vector157
vector157:
  pushl $0
  102427:	6a 00                	push   $0x0
  pushl $157
  102429:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10242e:	e9 04 fa ff ff       	jmp    101e37 <__alltraps>

00102433 <vector158>:
.globl vector158
vector158:
  pushl $0
  102433:	6a 00                	push   $0x0
  pushl $158
  102435:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10243a:	e9 f8 f9 ff ff       	jmp    101e37 <__alltraps>

0010243f <vector159>:
.globl vector159
vector159:
  pushl $0
  10243f:	6a 00                	push   $0x0
  pushl $159
  102441:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102446:	e9 ec f9 ff ff       	jmp    101e37 <__alltraps>

0010244b <vector160>:
.globl vector160
vector160:
  pushl $0
  10244b:	6a 00                	push   $0x0
  pushl $160
  10244d:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102452:	e9 e0 f9 ff ff       	jmp    101e37 <__alltraps>

00102457 <vector161>:
.globl vector161
vector161:
  pushl $0
  102457:	6a 00                	push   $0x0
  pushl $161
  102459:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10245e:	e9 d4 f9 ff ff       	jmp    101e37 <__alltraps>

00102463 <vector162>:
.globl vector162
vector162:
  pushl $0
  102463:	6a 00                	push   $0x0
  pushl $162
  102465:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10246a:	e9 c8 f9 ff ff       	jmp    101e37 <__alltraps>

0010246f <vector163>:
.globl vector163
vector163:
  pushl $0
  10246f:	6a 00                	push   $0x0
  pushl $163
  102471:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102476:	e9 bc f9 ff ff       	jmp    101e37 <__alltraps>

0010247b <vector164>:
.globl vector164
vector164:
  pushl $0
  10247b:	6a 00                	push   $0x0
  pushl $164
  10247d:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102482:	e9 b0 f9 ff ff       	jmp    101e37 <__alltraps>

00102487 <vector165>:
.globl vector165
vector165:
  pushl $0
  102487:	6a 00                	push   $0x0
  pushl $165
  102489:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10248e:	e9 a4 f9 ff ff       	jmp    101e37 <__alltraps>

00102493 <vector166>:
.globl vector166
vector166:
  pushl $0
  102493:	6a 00                	push   $0x0
  pushl $166
  102495:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10249a:	e9 98 f9 ff ff       	jmp    101e37 <__alltraps>

0010249f <vector167>:
.globl vector167
vector167:
  pushl $0
  10249f:	6a 00                	push   $0x0
  pushl $167
  1024a1:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024a6:	e9 8c f9 ff ff       	jmp    101e37 <__alltraps>

001024ab <vector168>:
.globl vector168
vector168:
  pushl $0
  1024ab:	6a 00                	push   $0x0
  pushl $168
  1024ad:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1024b2:	e9 80 f9 ff ff       	jmp    101e37 <__alltraps>

001024b7 <vector169>:
.globl vector169
vector169:
  pushl $0
  1024b7:	6a 00                	push   $0x0
  pushl $169
  1024b9:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1024be:	e9 74 f9 ff ff       	jmp    101e37 <__alltraps>

001024c3 <vector170>:
.globl vector170
vector170:
  pushl $0
  1024c3:	6a 00                	push   $0x0
  pushl $170
  1024c5:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1024ca:	e9 68 f9 ff ff       	jmp    101e37 <__alltraps>

001024cf <vector171>:
.globl vector171
vector171:
  pushl $0
  1024cf:	6a 00                	push   $0x0
  pushl $171
  1024d1:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1024d6:	e9 5c f9 ff ff       	jmp    101e37 <__alltraps>

001024db <vector172>:
.globl vector172
vector172:
  pushl $0
  1024db:	6a 00                	push   $0x0
  pushl $172
  1024dd:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024e2:	e9 50 f9 ff ff       	jmp    101e37 <__alltraps>

001024e7 <vector173>:
.globl vector173
vector173:
  pushl $0
  1024e7:	6a 00                	push   $0x0
  pushl $173
  1024e9:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1024ee:	e9 44 f9 ff ff       	jmp    101e37 <__alltraps>

001024f3 <vector174>:
.globl vector174
vector174:
  pushl $0
  1024f3:	6a 00                	push   $0x0
  pushl $174
  1024f5:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024fa:	e9 38 f9 ff ff       	jmp    101e37 <__alltraps>

001024ff <vector175>:
.globl vector175
vector175:
  pushl $0
  1024ff:	6a 00                	push   $0x0
  pushl $175
  102501:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102506:	e9 2c f9 ff ff       	jmp    101e37 <__alltraps>

0010250b <vector176>:
.globl vector176
vector176:
  pushl $0
  10250b:	6a 00                	push   $0x0
  pushl $176
  10250d:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102512:	e9 20 f9 ff ff       	jmp    101e37 <__alltraps>

00102517 <vector177>:
.globl vector177
vector177:
  pushl $0
  102517:	6a 00                	push   $0x0
  pushl $177
  102519:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10251e:	e9 14 f9 ff ff       	jmp    101e37 <__alltraps>

00102523 <vector178>:
.globl vector178
vector178:
  pushl $0
  102523:	6a 00                	push   $0x0
  pushl $178
  102525:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10252a:	e9 08 f9 ff ff       	jmp    101e37 <__alltraps>

0010252f <vector179>:
.globl vector179
vector179:
  pushl $0
  10252f:	6a 00                	push   $0x0
  pushl $179
  102531:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102536:	e9 fc f8 ff ff       	jmp    101e37 <__alltraps>

0010253b <vector180>:
.globl vector180
vector180:
  pushl $0
  10253b:	6a 00                	push   $0x0
  pushl $180
  10253d:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102542:	e9 f0 f8 ff ff       	jmp    101e37 <__alltraps>

00102547 <vector181>:
.globl vector181
vector181:
  pushl $0
  102547:	6a 00                	push   $0x0
  pushl $181
  102549:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10254e:	e9 e4 f8 ff ff       	jmp    101e37 <__alltraps>

00102553 <vector182>:
.globl vector182
vector182:
  pushl $0
  102553:	6a 00                	push   $0x0
  pushl $182
  102555:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10255a:	e9 d8 f8 ff ff       	jmp    101e37 <__alltraps>

0010255f <vector183>:
.globl vector183
vector183:
  pushl $0
  10255f:	6a 00                	push   $0x0
  pushl $183
  102561:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102566:	e9 cc f8 ff ff       	jmp    101e37 <__alltraps>

0010256b <vector184>:
.globl vector184
vector184:
  pushl $0
  10256b:	6a 00                	push   $0x0
  pushl $184
  10256d:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102572:	e9 c0 f8 ff ff       	jmp    101e37 <__alltraps>

00102577 <vector185>:
.globl vector185
vector185:
  pushl $0
  102577:	6a 00                	push   $0x0
  pushl $185
  102579:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10257e:	e9 b4 f8 ff ff       	jmp    101e37 <__alltraps>

00102583 <vector186>:
.globl vector186
vector186:
  pushl $0
  102583:	6a 00                	push   $0x0
  pushl $186
  102585:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10258a:	e9 a8 f8 ff ff       	jmp    101e37 <__alltraps>

0010258f <vector187>:
.globl vector187
vector187:
  pushl $0
  10258f:	6a 00                	push   $0x0
  pushl $187
  102591:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102596:	e9 9c f8 ff ff       	jmp    101e37 <__alltraps>

0010259b <vector188>:
.globl vector188
vector188:
  pushl $0
  10259b:	6a 00                	push   $0x0
  pushl $188
  10259d:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1025a2:	e9 90 f8 ff ff       	jmp    101e37 <__alltraps>

001025a7 <vector189>:
.globl vector189
vector189:
  pushl $0
  1025a7:	6a 00                	push   $0x0
  pushl $189
  1025a9:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1025ae:	e9 84 f8 ff ff       	jmp    101e37 <__alltraps>

001025b3 <vector190>:
.globl vector190
vector190:
  pushl $0
  1025b3:	6a 00                	push   $0x0
  pushl $190
  1025b5:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1025ba:	e9 78 f8 ff ff       	jmp    101e37 <__alltraps>

001025bf <vector191>:
.globl vector191
vector191:
  pushl $0
  1025bf:	6a 00                	push   $0x0
  pushl $191
  1025c1:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1025c6:	e9 6c f8 ff ff       	jmp    101e37 <__alltraps>

001025cb <vector192>:
.globl vector192
vector192:
  pushl $0
  1025cb:	6a 00                	push   $0x0
  pushl $192
  1025cd:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1025d2:	e9 60 f8 ff ff       	jmp    101e37 <__alltraps>

001025d7 <vector193>:
.globl vector193
vector193:
  pushl $0
  1025d7:	6a 00                	push   $0x0
  pushl $193
  1025d9:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025de:	e9 54 f8 ff ff       	jmp    101e37 <__alltraps>

001025e3 <vector194>:
.globl vector194
vector194:
  pushl $0
  1025e3:	6a 00                	push   $0x0
  pushl $194
  1025e5:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025ea:	e9 48 f8 ff ff       	jmp    101e37 <__alltraps>

001025ef <vector195>:
.globl vector195
vector195:
  pushl $0
  1025ef:	6a 00                	push   $0x0
  pushl $195
  1025f1:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025f6:	e9 3c f8 ff ff       	jmp    101e37 <__alltraps>

001025fb <vector196>:
.globl vector196
vector196:
  pushl $0
  1025fb:	6a 00                	push   $0x0
  pushl $196
  1025fd:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102602:	e9 30 f8 ff ff       	jmp    101e37 <__alltraps>

00102607 <vector197>:
.globl vector197
vector197:
  pushl $0
  102607:	6a 00                	push   $0x0
  pushl $197
  102609:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10260e:	e9 24 f8 ff ff       	jmp    101e37 <__alltraps>

00102613 <vector198>:
.globl vector198
vector198:
  pushl $0
  102613:	6a 00                	push   $0x0
  pushl $198
  102615:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10261a:	e9 18 f8 ff ff       	jmp    101e37 <__alltraps>

0010261f <vector199>:
.globl vector199
vector199:
  pushl $0
  10261f:	6a 00                	push   $0x0
  pushl $199
  102621:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102626:	e9 0c f8 ff ff       	jmp    101e37 <__alltraps>

0010262b <vector200>:
.globl vector200
vector200:
  pushl $0
  10262b:	6a 00                	push   $0x0
  pushl $200
  10262d:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102632:	e9 00 f8 ff ff       	jmp    101e37 <__alltraps>

00102637 <vector201>:
.globl vector201
vector201:
  pushl $0
  102637:	6a 00                	push   $0x0
  pushl $201
  102639:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10263e:	e9 f4 f7 ff ff       	jmp    101e37 <__alltraps>

00102643 <vector202>:
.globl vector202
vector202:
  pushl $0
  102643:	6a 00                	push   $0x0
  pushl $202
  102645:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10264a:	e9 e8 f7 ff ff       	jmp    101e37 <__alltraps>

0010264f <vector203>:
.globl vector203
vector203:
  pushl $0
  10264f:	6a 00                	push   $0x0
  pushl $203
  102651:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102656:	e9 dc f7 ff ff       	jmp    101e37 <__alltraps>

0010265b <vector204>:
.globl vector204
vector204:
  pushl $0
  10265b:	6a 00                	push   $0x0
  pushl $204
  10265d:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102662:	e9 d0 f7 ff ff       	jmp    101e37 <__alltraps>

00102667 <vector205>:
.globl vector205
vector205:
  pushl $0
  102667:	6a 00                	push   $0x0
  pushl $205
  102669:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10266e:	e9 c4 f7 ff ff       	jmp    101e37 <__alltraps>

00102673 <vector206>:
.globl vector206
vector206:
  pushl $0
  102673:	6a 00                	push   $0x0
  pushl $206
  102675:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10267a:	e9 b8 f7 ff ff       	jmp    101e37 <__alltraps>

0010267f <vector207>:
.globl vector207
vector207:
  pushl $0
  10267f:	6a 00                	push   $0x0
  pushl $207
  102681:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102686:	e9 ac f7 ff ff       	jmp    101e37 <__alltraps>

0010268b <vector208>:
.globl vector208
vector208:
  pushl $0
  10268b:	6a 00                	push   $0x0
  pushl $208
  10268d:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102692:	e9 a0 f7 ff ff       	jmp    101e37 <__alltraps>

00102697 <vector209>:
.globl vector209
vector209:
  pushl $0
  102697:	6a 00                	push   $0x0
  pushl $209
  102699:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10269e:	e9 94 f7 ff ff       	jmp    101e37 <__alltraps>

001026a3 <vector210>:
.globl vector210
vector210:
  pushl $0
  1026a3:	6a 00                	push   $0x0
  pushl $210
  1026a5:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1026aa:	e9 88 f7 ff ff       	jmp    101e37 <__alltraps>

001026af <vector211>:
.globl vector211
vector211:
  pushl $0
  1026af:	6a 00                	push   $0x0
  pushl $211
  1026b1:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1026b6:	e9 7c f7 ff ff       	jmp    101e37 <__alltraps>

001026bb <vector212>:
.globl vector212
vector212:
  pushl $0
  1026bb:	6a 00                	push   $0x0
  pushl $212
  1026bd:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1026c2:	e9 70 f7 ff ff       	jmp    101e37 <__alltraps>

001026c7 <vector213>:
.globl vector213
vector213:
  pushl $0
  1026c7:	6a 00                	push   $0x0
  pushl $213
  1026c9:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1026ce:	e9 64 f7 ff ff       	jmp    101e37 <__alltraps>

001026d3 <vector214>:
.globl vector214
vector214:
  pushl $0
  1026d3:	6a 00                	push   $0x0
  pushl $214
  1026d5:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026da:	e9 58 f7 ff ff       	jmp    101e37 <__alltraps>

001026df <vector215>:
.globl vector215
vector215:
  pushl $0
  1026df:	6a 00                	push   $0x0
  pushl $215
  1026e1:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026e6:	e9 4c f7 ff ff       	jmp    101e37 <__alltraps>

001026eb <vector216>:
.globl vector216
vector216:
  pushl $0
  1026eb:	6a 00                	push   $0x0
  pushl $216
  1026ed:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026f2:	e9 40 f7 ff ff       	jmp    101e37 <__alltraps>

001026f7 <vector217>:
.globl vector217
vector217:
  pushl $0
  1026f7:	6a 00                	push   $0x0
  pushl $217
  1026f9:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1026fe:	e9 34 f7 ff ff       	jmp    101e37 <__alltraps>

00102703 <vector218>:
.globl vector218
vector218:
  pushl $0
  102703:	6a 00                	push   $0x0
  pushl $218
  102705:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10270a:	e9 28 f7 ff ff       	jmp    101e37 <__alltraps>

0010270f <vector219>:
.globl vector219
vector219:
  pushl $0
  10270f:	6a 00                	push   $0x0
  pushl $219
  102711:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102716:	e9 1c f7 ff ff       	jmp    101e37 <__alltraps>

0010271b <vector220>:
.globl vector220
vector220:
  pushl $0
  10271b:	6a 00                	push   $0x0
  pushl $220
  10271d:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102722:	e9 10 f7 ff ff       	jmp    101e37 <__alltraps>

00102727 <vector221>:
.globl vector221
vector221:
  pushl $0
  102727:	6a 00                	push   $0x0
  pushl $221
  102729:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10272e:	e9 04 f7 ff ff       	jmp    101e37 <__alltraps>

00102733 <vector222>:
.globl vector222
vector222:
  pushl $0
  102733:	6a 00                	push   $0x0
  pushl $222
  102735:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10273a:	e9 f8 f6 ff ff       	jmp    101e37 <__alltraps>

0010273f <vector223>:
.globl vector223
vector223:
  pushl $0
  10273f:	6a 00                	push   $0x0
  pushl $223
  102741:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102746:	e9 ec f6 ff ff       	jmp    101e37 <__alltraps>

0010274b <vector224>:
.globl vector224
vector224:
  pushl $0
  10274b:	6a 00                	push   $0x0
  pushl $224
  10274d:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102752:	e9 e0 f6 ff ff       	jmp    101e37 <__alltraps>

00102757 <vector225>:
.globl vector225
vector225:
  pushl $0
  102757:	6a 00                	push   $0x0
  pushl $225
  102759:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10275e:	e9 d4 f6 ff ff       	jmp    101e37 <__alltraps>

00102763 <vector226>:
.globl vector226
vector226:
  pushl $0
  102763:	6a 00                	push   $0x0
  pushl $226
  102765:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10276a:	e9 c8 f6 ff ff       	jmp    101e37 <__alltraps>

0010276f <vector227>:
.globl vector227
vector227:
  pushl $0
  10276f:	6a 00                	push   $0x0
  pushl $227
  102771:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102776:	e9 bc f6 ff ff       	jmp    101e37 <__alltraps>

0010277b <vector228>:
.globl vector228
vector228:
  pushl $0
  10277b:	6a 00                	push   $0x0
  pushl $228
  10277d:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102782:	e9 b0 f6 ff ff       	jmp    101e37 <__alltraps>

00102787 <vector229>:
.globl vector229
vector229:
  pushl $0
  102787:	6a 00                	push   $0x0
  pushl $229
  102789:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10278e:	e9 a4 f6 ff ff       	jmp    101e37 <__alltraps>

00102793 <vector230>:
.globl vector230
vector230:
  pushl $0
  102793:	6a 00                	push   $0x0
  pushl $230
  102795:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10279a:	e9 98 f6 ff ff       	jmp    101e37 <__alltraps>

0010279f <vector231>:
.globl vector231
vector231:
  pushl $0
  10279f:	6a 00                	push   $0x0
  pushl $231
  1027a1:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027a6:	e9 8c f6 ff ff       	jmp    101e37 <__alltraps>

001027ab <vector232>:
.globl vector232
vector232:
  pushl $0
  1027ab:	6a 00                	push   $0x0
  pushl $232
  1027ad:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1027b2:	e9 80 f6 ff ff       	jmp    101e37 <__alltraps>

001027b7 <vector233>:
.globl vector233
vector233:
  pushl $0
  1027b7:	6a 00                	push   $0x0
  pushl $233
  1027b9:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1027be:	e9 74 f6 ff ff       	jmp    101e37 <__alltraps>

001027c3 <vector234>:
.globl vector234
vector234:
  pushl $0
  1027c3:	6a 00                	push   $0x0
  pushl $234
  1027c5:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1027ca:	e9 68 f6 ff ff       	jmp    101e37 <__alltraps>

001027cf <vector235>:
.globl vector235
vector235:
  pushl $0
  1027cf:	6a 00                	push   $0x0
  pushl $235
  1027d1:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1027d6:	e9 5c f6 ff ff       	jmp    101e37 <__alltraps>

001027db <vector236>:
.globl vector236
vector236:
  pushl $0
  1027db:	6a 00                	push   $0x0
  pushl $236
  1027dd:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027e2:	e9 50 f6 ff ff       	jmp    101e37 <__alltraps>

001027e7 <vector237>:
.globl vector237
vector237:
  pushl $0
  1027e7:	6a 00                	push   $0x0
  pushl $237
  1027e9:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1027ee:	e9 44 f6 ff ff       	jmp    101e37 <__alltraps>

001027f3 <vector238>:
.globl vector238
vector238:
  pushl $0
  1027f3:	6a 00                	push   $0x0
  pushl $238
  1027f5:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027fa:	e9 38 f6 ff ff       	jmp    101e37 <__alltraps>

001027ff <vector239>:
.globl vector239
vector239:
  pushl $0
  1027ff:	6a 00                	push   $0x0
  pushl $239
  102801:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102806:	e9 2c f6 ff ff       	jmp    101e37 <__alltraps>

0010280b <vector240>:
.globl vector240
vector240:
  pushl $0
  10280b:	6a 00                	push   $0x0
  pushl $240
  10280d:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102812:	e9 20 f6 ff ff       	jmp    101e37 <__alltraps>

00102817 <vector241>:
.globl vector241
vector241:
  pushl $0
  102817:	6a 00                	push   $0x0
  pushl $241
  102819:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10281e:	e9 14 f6 ff ff       	jmp    101e37 <__alltraps>

00102823 <vector242>:
.globl vector242
vector242:
  pushl $0
  102823:	6a 00                	push   $0x0
  pushl $242
  102825:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10282a:	e9 08 f6 ff ff       	jmp    101e37 <__alltraps>

0010282f <vector243>:
.globl vector243
vector243:
  pushl $0
  10282f:	6a 00                	push   $0x0
  pushl $243
  102831:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102836:	e9 fc f5 ff ff       	jmp    101e37 <__alltraps>

0010283b <vector244>:
.globl vector244
vector244:
  pushl $0
  10283b:	6a 00                	push   $0x0
  pushl $244
  10283d:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102842:	e9 f0 f5 ff ff       	jmp    101e37 <__alltraps>

00102847 <vector245>:
.globl vector245
vector245:
  pushl $0
  102847:	6a 00                	push   $0x0
  pushl $245
  102849:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10284e:	e9 e4 f5 ff ff       	jmp    101e37 <__alltraps>

00102853 <vector246>:
.globl vector246
vector246:
  pushl $0
  102853:	6a 00                	push   $0x0
  pushl $246
  102855:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10285a:	e9 d8 f5 ff ff       	jmp    101e37 <__alltraps>

0010285f <vector247>:
.globl vector247
vector247:
  pushl $0
  10285f:	6a 00                	push   $0x0
  pushl $247
  102861:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102866:	e9 cc f5 ff ff       	jmp    101e37 <__alltraps>

0010286b <vector248>:
.globl vector248
vector248:
  pushl $0
  10286b:	6a 00                	push   $0x0
  pushl $248
  10286d:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102872:	e9 c0 f5 ff ff       	jmp    101e37 <__alltraps>

00102877 <vector249>:
.globl vector249
vector249:
  pushl $0
  102877:	6a 00                	push   $0x0
  pushl $249
  102879:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10287e:	e9 b4 f5 ff ff       	jmp    101e37 <__alltraps>

00102883 <vector250>:
.globl vector250
vector250:
  pushl $0
  102883:	6a 00                	push   $0x0
  pushl $250
  102885:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10288a:	e9 a8 f5 ff ff       	jmp    101e37 <__alltraps>

0010288f <vector251>:
.globl vector251
vector251:
  pushl $0
  10288f:	6a 00                	push   $0x0
  pushl $251
  102891:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102896:	e9 9c f5 ff ff       	jmp    101e37 <__alltraps>

0010289b <vector252>:
.globl vector252
vector252:
  pushl $0
  10289b:	6a 00                	push   $0x0
  pushl $252
  10289d:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1028a2:	e9 90 f5 ff ff       	jmp    101e37 <__alltraps>

001028a7 <vector253>:
.globl vector253
vector253:
  pushl $0
  1028a7:	6a 00                	push   $0x0
  pushl $253
  1028a9:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1028ae:	e9 84 f5 ff ff       	jmp    101e37 <__alltraps>

001028b3 <vector254>:
.globl vector254
vector254:
  pushl $0
  1028b3:	6a 00                	push   $0x0
  pushl $254
  1028b5:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1028ba:	e9 78 f5 ff ff       	jmp    101e37 <__alltraps>

001028bf <vector255>:
.globl vector255
vector255:
  pushl $0
  1028bf:	6a 00                	push   $0x0
  pushl $255
  1028c1:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1028c6:	e9 6c f5 ff ff       	jmp    101e37 <__alltraps>

001028cb <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1028cb:	55                   	push   %ebp
  1028cc:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1028ce:	8b 55 08             	mov    0x8(%ebp),%edx
  1028d1:	a1 24 af 11 00       	mov    0x11af24,%eax
  1028d6:	29 c2                	sub    %eax,%edx
  1028d8:	89 d0                	mov    %edx,%eax
  1028da:	c1 f8 02             	sar    $0x2,%eax
  1028dd:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1028e3:	5d                   	pop    %ebp
  1028e4:	c3                   	ret    

001028e5 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1028e5:	55                   	push   %ebp
  1028e6:	89 e5                	mov    %esp,%ebp
  1028e8:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1028ee:	89 04 24             	mov    %eax,(%esp)
  1028f1:	e8 d5 ff ff ff       	call   1028cb <page2ppn>
  1028f6:	c1 e0 0c             	shl    $0xc,%eax
}
  1028f9:	c9                   	leave  
  1028fa:	c3                   	ret    

001028fb <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1028fb:	55                   	push   %ebp
  1028fc:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1028fe:	8b 45 08             	mov    0x8(%ebp),%eax
  102901:	8b 00                	mov    (%eax),%eax
}
  102903:	5d                   	pop    %ebp
  102904:	c3                   	ret    

00102905 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102905:	55                   	push   %ebp
  102906:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102908:	8b 45 08             	mov    0x8(%ebp),%eax
  10290b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10290e:	89 10                	mov    %edx,(%eax)
}
  102910:	5d                   	pop    %ebp
  102911:	c3                   	ret    

00102912 <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

//initialize the `free_list` and set `nr_free` to 0.
static void
default_init(void) {
  102912:	55                   	push   %ebp
  102913:	89 e5                	mov    %esp,%ebp
  102915:	83 ec 10             	sub    $0x10,%esp
  102918:	c7 45 fc 10 af 11 00 	movl   $0x11af10,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10291f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102922:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102925:	89 50 04             	mov    %edx,0x4(%eax)
  102928:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10292b:	8b 50 04             	mov    0x4(%eax),%edx
  10292e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102931:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  102933:	c7 05 18 af 11 00 00 	movl   $0x0,0x11af18
  10293a:	00 00 00 
}
  10293d:	c9                   	leave  
  10293e:	c3                   	ret    

0010293f <default_init_memmap>:

//initialize a free block
static void
default_init_memmap(struct Page *base, size_t n) {
  10293f:	55                   	push   %ebp
  102940:	89 e5                	mov    %esp,%ebp
  102942:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  102945:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102949:	75 24                	jne    10296f <default_init_memmap+0x30>
  10294b:	c7 44 24 0c 70 65 10 	movl   $0x106570,0xc(%esp)
  102952:	00 
  102953:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  10295a:	00 
  10295b:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
  102962:	00 
  102963:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  10296a:	e8 63 e3 ff ff       	call   100cd2 <__panic>
    struct Page *p = base;
  10296f:	8b 45 08             	mov    0x8(%ebp),%eax
  102972:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102975:	eb 7d                	jmp    1029f4 <default_init_memmap+0xb5>
        assert(PageReserved(p));
  102977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10297a:	83 c0 04             	add    $0x4,%eax
  10297d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102984:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102987:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10298a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10298d:	0f a3 10             	bt     %edx,(%eax)
  102990:	19 c0                	sbb    %eax,%eax
  102992:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102995:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102999:	0f 95 c0             	setne  %al
  10299c:	0f b6 c0             	movzbl %al,%eax
  10299f:	85 c0                	test   %eax,%eax
  1029a1:	75 24                	jne    1029c7 <default_init_memmap+0x88>
  1029a3:	c7 44 24 0c a1 65 10 	movl   $0x1065a1,0xc(%esp)
  1029aa:	00 
  1029ab:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  1029b2:	00 
  1029b3:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
  1029ba:	00 
  1029bb:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  1029c2:	e8 0b e3 ff ff       	call   100cd2 <__panic>
        p->flags = p->property = 0;
  1029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029ca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029d4:	8b 50 08             	mov    0x8(%eax),%edx
  1029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029da:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  1029dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1029e4:	00 
  1029e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029e8:	89 04 24             	mov    %eax,(%esp)
  1029eb:	e8 15 ff ff ff       	call   102905 <set_page_ref>
//initialize a free block
static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  1029f0:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1029f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029f7:	89 d0                	mov    %edx,%eax
  1029f9:	c1 e0 02             	shl    $0x2,%eax
  1029fc:	01 d0                	add    %edx,%eax
  1029fe:	c1 e0 02             	shl    $0x2,%eax
  102a01:	89 c2                	mov    %eax,%edx
  102a03:	8b 45 08             	mov    0x8(%ebp),%eax
  102a06:	01 d0                	add    %edx,%eax
  102a08:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102a0b:	0f 85 66 ff ff ff    	jne    102977 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102a11:	8b 45 08             	mov    0x8(%ebp),%eax
  102a14:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a17:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a1d:	83 c0 04             	add    $0x4,%eax
  102a20:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102a27:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102a2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a2d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102a30:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  102a33:	8b 15 18 af 11 00    	mov    0x11af18,%edx
  102a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a3c:	01 d0                	add    %edx,%eax
  102a3e:	a3 18 af 11 00       	mov    %eax,0x11af18
    list_add(&free_list, &(base->page_link));
  102a43:	8b 45 08             	mov    0x8(%ebp),%eax
  102a46:	83 c0 0c             	add    $0xc,%eax
  102a49:	c7 45 dc 10 af 11 00 	movl   $0x11af10,-0x24(%ebp)
  102a50:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102a53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a56:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  102a59:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a5c:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102a5f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a62:	8b 40 04             	mov    0x4(%eax),%eax
  102a65:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102a68:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102a6b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a6e:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102a71:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102a74:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102a77:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102a7a:	89 10                	mov    %edx,(%eax)
  102a7c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102a7f:	8b 10                	mov    (%eax),%edx
  102a81:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102a84:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102a87:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a8a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102a8d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102a90:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a93:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102a96:	89 10                	mov    %edx,(%eax)
}
  102a98:	c9                   	leave  
  102a99:	c3                   	ret    

00102a9a <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102a9a:	55                   	push   %ebp
  102a9b:	89 e5                	mov    %esp,%ebp
  102a9d:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102aa0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102aa4:	75 24                	jne    102aca <default_alloc_pages+0x30>
  102aa6:	c7 44 24 0c 70 65 10 	movl   $0x106570,0xc(%esp)
  102aad:	00 
  102aae:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  102ab5:	00 
  102ab6:	c7 44 24 04 7e 00 00 	movl   $0x7e,0x4(%esp)
  102abd:	00 
  102abe:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  102ac5:	e8 08 e2 ff ff       	call   100cd2 <__panic>
    if (n > nr_free) {
  102aca:	a1 18 af 11 00       	mov    0x11af18,%eax
  102acf:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ad2:	73 0a                	jae    102ade <default_alloc_pages+0x44>
        return NULL;
  102ad4:	b8 00 00 00 00       	mov    $0x0,%eax
  102ad9:	e9 2a 01 00 00       	jmp    102c08 <default_alloc_pages+0x16e>
    }
    struct Page *page = NULL;
  102ade:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102ae5:	c7 45 f0 10 af 11 00 	movl   $0x11af10,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102aec:	eb 1c                	jmp    102b0a <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102af1:	83 e8 0c             	sub    $0xc,%eax
  102af4:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  102af7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102afa:	8b 40 08             	mov    0x8(%eax),%eax
  102afd:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b00:	72 08                	jb     102b0a <default_alloc_pages+0x70>
            page = p;
  102b02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b05:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102b08:	eb 18                	jmp    102b22 <default_alloc_pages+0x88>
  102b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102b10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b13:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b19:	81 7d f0 10 af 11 00 	cmpl   $0x11af10,-0x10(%ebp)
  102b20:	75 cc                	jne    102aee <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
  102b22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102b26:	0f 84 d9 00 00 00    	je     102c05 <default_alloc_pages+0x16b>
        list_del(&(page->page_link));
  102b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b2f:	83 c0 0c             	add    $0xc,%eax
  102b32:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102b35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b38:	8b 40 04             	mov    0x4(%eax),%eax
  102b3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102b3e:	8b 12                	mov    (%edx),%edx
  102b40:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102b43:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102b46:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b49:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102b4c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102b4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b52:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102b55:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
  102b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b5a:	8b 40 08             	mov    0x8(%eax),%eax
  102b5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b60:	76 7d                	jbe    102bdf <default_alloc_pages+0x145>
            struct Page *p = page + n;
  102b62:	8b 55 08             	mov    0x8(%ebp),%edx
  102b65:	89 d0                	mov    %edx,%eax
  102b67:	c1 e0 02             	shl    $0x2,%eax
  102b6a:	01 d0                	add    %edx,%eax
  102b6c:	c1 e0 02             	shl    $0x2,%eax
  102b6f:	89 c2                	mov    %eax,%edx
  102b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b74:	01 d0                	add    %edx,%eax
  102b76:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  102b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b7c:	8b 40 08             	mov    0x8(%eax),%eax
  102b7f:	2b 45 08             	sub    0x8(%ebp),%eax
  102b82:	89 c2                	mov    %eax,%edx
  102b84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b87:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
  102b8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b8d:	83 c0 0c             	add    $0xc,%eax
  102b90:	c7 45 d4 10 af 11 00 	movl   $0x11af10,-0x2c(%ebp)
  102b97:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102b9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102b9d:	89 45 cc             	mov    %eax,-0x34(%ebp)
  102ba0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ba3:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102ba6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102ba9:	8b 40 04             	mov    0x4(%eax),%eax
  102bac:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102baf:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102bb2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102bb5:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102bb8:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102bbb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102bbe:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102bc1:	89 10                	mov    %edx,(%eax)
  102bc3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102bc6:	8b 10                	mov    (%eax),%edx
  102bc8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102bcb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102bce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102bd1:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102bd4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102bd7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102bda:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102bdd:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
  102bdf:	a1 18 af 11 00       	mov    0x11af18,%eax
  102be4:	2b 45 08             	sub    0x8(%ebp),%eax
  102be7:	a3 18 af 11 00       	mov    %eax,0x11af18
        ClearPageProperty(page);
  102bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bef:	83 c0 04             	add    $0x4,%eax
  102bf2:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102bf9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102bfc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102bff:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102c02:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  102c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102c08:	c9                   	leave  
  102c09:	c3                   	ret    

00102c0a <default_free_pages>:
//  *  change some pages' `p->property` correctly.

//'default_free_pages':re-link the pages into the free list, 
// and may merge small free blocks into the big ones.
static void
default_free_pages(struct Page *base, size_t n) {
  102c0a:	55                   	push   %ebp
  102c0b:	89 e5                	mov    %esp,%ebp
  102c0d:	81 ec a8 00 00 00    	sub    $0xa8,%esp
    assert(n > 0);
  102c13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c17:	75 24                	jne    102c3d <default_free_pages+0x33>
  102c19:	c7 44 24 0c 70 65 10 	movl   $0x106570,0xc(%esp)
  102c20:	00 
  102c21:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  102c28:	00 
  102c29:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  102c30:	00 
  102c31:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  102c38:	e8 95 e0 ff ff       	call   100cd2 <__panic>
    struct Page *p = base;
  102c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102c43:	e9 9d 00 00 00       	jmp    102ce5 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  102c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c4b:	83 c0 04             	add    $0x4,%eax
  102c4e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  102c55:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102c5e:	0f a3 10             	bt     %edx,(%eax)
  102c61:	19 c0                	sbb    %eax,%eax
  102c63:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
  102c66:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102c6a:	0f 95 c0             	setne  %al
  102c6d:	0f b6 c0             	movzbl %al,%eax
  102c70:	85 c0                	test   %eax,%eax
  102c72:	75 2c                	jne    102ca0 <default_free_pages+0x96>
  102c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c77:	83 c0 04             	add    $0x4,%eax
  102c7a:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  102c81:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c84:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102c87:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102c8a:	0f a3 10             	bt     %edx,(%eax)
  102c8d:	19 c0                	sbb    %eax,%eax
  102c8f:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
  102c92:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  102c96:	0f 95 c0             	setne  %al
  102c99:	0f b6 c0             	movzbl %al,%eax
  102c9c:	85 c0                	test   %eax,%eax
  102c9e:	74 24                	je     102cc4 <default_free_pages+0xba>
  102ca0:	c7 44 24 0c b4 65 10 	movl   $0x1065b4,0xc(%esp)
  102ca7:	00 
  102ca8:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  102caf:	00 
  102cb0:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
  102cb7:	00 
  102cb8:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  102cbf:	e8 0e e0 ff ff       	call   100cd2 <__panic>
        p->flags = 0;
  102cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cc7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102cce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102cd5:	00 
  102cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cd9:	89 04 24             	mov    %eax,(%esp)
  102cdc:	e8 24 fc ff ff       	call   102905 <set_page_ref>
// and may merge small free blocks into the big ones.
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102ce1:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102ce5:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ce8:	89 d0                	mov    %edx,%eax
  102cea:	c1 e0 02             	shl    $0x2,%eax
  102ced:	01 d0                	add    %edx,%eax
  102cef:	c1 e0 02             	shl    $0x2,%eax
  102cf2:	89 c2                	mov    %eax,%edx
  102cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf7:	01 d0                	add    %edx,%eax
  102cf9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102cfc:	0f 85 46 ff ff ff    	jne    102c48 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102d02:	8b 45 08             	mov    0x8(%ebp),%eax
  102d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d08:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0e:	83 c0 04             	add    $0x4,%eax
  102d11:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  102d18:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d1b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102d1e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102d21:	0f ab 10             	bts    %edx,(%eax)
  102d24:	c7 45 c4 10 af 11 00 	movl   $0x11af10,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102d2b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d2e:	8b 40 04             	mov    0x4(%eax),%eax
    //search the free list for its correct position 
    list_entry_t *next_entry = list_next(&free_list);
  102d31:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (next_entry != &free_list && le2page(next_entry, page_link) < base)
  102d34:	eb 0f                	jmp    102d45 <default_free_pages+0x13b>
  102d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d39:	89 45 c0             	mov    %eax,-0x40(%ebp)
  102d3c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102d3f:	8b 40 04             	mov    0x4(%eax),%eax
        next_entry = list_next(next_entry);
  102d42:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    base->property = n;
    SetPageProperty(base);
    //search the free list for its correct position 
    list_entry_t *next_entry = list_next(&free_list);
    while (next_entry != &free_list && le2page(next_entry, page_link) < base)
  102d45:	81 7d f0 10 af 11 00 	cmpl   $0x11af10,-0x10(%ebp)
  102d4c:	74 0b                	je     102d59 <default_free_pages+0x14f>
  102d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d51:	83 e8 0c             	sub    $0xc,%eax
  102d54:	3b 45 08             	cmp    0x8(%ebp),%eax
  102d57:	72 dd                	jb     102d36 <default_free_pages+0x12c>
  102d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d5c:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102d5f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102d62:	8b 00                	mov    (%eax),%eax
        next_entry = list_next(next_entry);
    //merge blocks at lower or higher addresses
    list_entry_t *prev_entry = list_prev(next_entry);
  102d64:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *insert_entry = prev_entry;
  102d67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (prev_entry != &free_list) {
  102d6d:	81 7d ec 10 af 11 00 	cmpl   $0x11af10,-0x14(%ebp)
  102d74:	0f 84 8e 00 00 00    	je     102e08 <default_free_pages+0x1fe>
        p = le2page(prev_entry, page_link);
  102d7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d7d:	83 e8 0c             	sub    $0xc,%eax
  102d80:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (p + p->property == base) {
  102d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d86:	8b 50 08             	mov    0x8(%eax),%edx
  102d89:	89 d0                	mov    %edx,%eax
  102d8b:	c1 e0 02             	shl    $0x2,%eax
  102d8e:	01 d0                	add    %edx,%eax
  102d90:	c1 e0 02             	shl    $0x2,%eax
  102d93:	89 c2                	mov    %eax,%edx
  102d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d98:	01 d0                	add    %edx,%eax
  102d9a:	3b 45 08             	cmp    0x8(%ebp),%eax
  102d9d:	75 69                	jne    102e08 <default_free_pages+0x1fe>
            p->property += base->property;
  102d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102da2:	8b 50 08             	mov    0x8(%eax),%edx
  102da5:	8b 45 08             	mov    0x8(%ebp),%eax
  102da8:	8b 40 08             	mov    0x8(%eax),%eax
  102dab:	01 c2                	add    %eax,%edx
  102dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102db0:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102db3:	8b 45 08             	mov    0x8(%ebp),%eax
  102db6:	83 c0 04             	add    $0x4,%eax
  102db9:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102dc0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102dc3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102dc6:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102dc9:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  102dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dcf:	89 45 08             	mov    %eax,0x8(%ebp)
  102dd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102dd5:	89 45 b0             	mov    %eax,-0x50(%ebp)
  102dd8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102ddb:	8b 00                	mov    (%eax),%eax
            insert_entry = list_prev(prev_entry);
  102ddd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102de0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102de3:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102de6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102de9:	8b 40 04             	mov    0x4(%eax),%eax
  102dec:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102def:	8b 12                	mov    (%edx),%edx
  102df1:	89 55 a8             	mov    %edx,-0x58(%ebp)
  102df4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102df7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102dfa:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102dfd:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102e00:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102e03:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102e06:	89 10                	mov    %edx,(%eax)
            list_del(prev_entry);
        }
    }
    if (next_entry != &free_list) {
  102e08:	81 7d f0 10 af 11 00 	cmpl   $0x11af10,-0x10(%ebp)
  102e0f:	74 7a                	je     102e8b <default_free_pages+0x281>
        p = le2page(next_entry, page_link);
  102e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e14:	83 e8 0c             	sub    $0xc,%eax
  102e17:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property == p) {
  102e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1d:	8b 50 08             	mov    0x8(%eax),%edx
  102e20:	89 d0                	mov    %edx,%eax
  102e22:	c1 e0 02             	shl    $0x2,%eax
  102e25:	01 d0                	add    %edx,%eax
  102e27:	c1 e0 02             	shl    $0x2,%eax
  102e2a:	89 c2                	mov    %eax,%edx
  102e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e2f:	01 d0                	add    %edx,%eax
  102e31:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102e34:	75 55                	jne    102e8b <default_free_pages+0x281>
            base->property += p->property;
  102e36:	8b 45 08             	mov    0x8(%ebp),%eax
  102e39:	8b 50 08             	mov    0x8(%eax),%edx
  102e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e3f:	8b 40 08             	mov    0x8(%eax),%eax
  102e42:	01 c2                	add    %eax,%edx
  102e44:	8b 45 08             	mov    0x8(%ebp),%eax
  102e47:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e4d:	83 c0 04             	add    $0x4,%eax
  102e50:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  102e57:	89 45 9c             	mov    %eax,-0x64(%ebp)
  102e5a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102e5d:	8b 55 a0             	mov    -0x60(%ebp),%edx
  102e60:	0f b3 10             	btr    %edx,(%eax)
  102e63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e66:	89 45 98             	mov    %eax,-0x68(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102e69:	8b 45 98             	mov    -0x68(%ebp),%eax
  102e6c:	8b 40 04             	mov    0x4(%eax),%eax
  102e6f:	8b 55 98             	mov    -0x68(%ebp),%edx
  102e72:	8b 12                	mov    (%edx),%edx
  102e74:	89 55 94             	mov    %edx,-0x6c(%ebp)
  102e77:	89 45 90             	mov    %eax,-0x70(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102e7a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102e7d:	8b 55 90             	mov    -0x70(%ebp),%edx
  102e80:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102e83:	8b 45 90             	mov    -0x70(%ebp),%eax
  102e86:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102e89:	89 10                	mov    %edx,(%eax)
    //         base = p;
    //         list_del(&(p->page_link));
    //     }
    // }
    //insert into free list
    nr_free += n;
  102e8b:	8b 15 18 af 11 00    	mov    0x11af18,%edx
  102e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e94:	01 d0                	add    %edx,%eax
  102e96:	a3 18 af 11 00       	mov    %eax,0x11af18
    list_add(&free_list, &(base->page_link));
  102e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e9e:	83 c0 0c             	add    $0xc,%eax
  102ea1:	c7 45 8c 10 af 11 00 	movl   $0x11af10,-0x74(%ebp)
  102ea8:	89 45 88             	mov    %eax,-0x78(%ebp)
  102eab:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102eae:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102eb1:	8b 45 88             	mov    -0x78(%ebp),%eax
  102eb4:	89 45 80             	mov    %eax,-0x80(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102eb7:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102eba:	8b 40 04             	mov    0x4(%eax),%eax
  102ebd:	8b 55 80             	mov    -0x80(%ebp),%edx
  102ec0:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  102ec6:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102ec9:	89 95 78 ff ff ff    	mov    %edx,-0x88(%ebp)
  102ecf:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102ed5:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  102edb:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  102ee1:	89 10                	mov    %edx,(%eax)
  102ee3:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  102ee9:	8b 10                	mov    (%eax),%edx
  102eeb:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  102ef1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102ef4:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  102efa:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  102f00:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102f03:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  102f09:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  102f0f:	89 10                	mov    %edx,(%eax)
}
  102f11:	c9                   	leave  
  102f12:	c3                   	ret    

00102f13 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102f13:	55                   	push   %ebp
  102f14:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102f16:	a1 18 af 11 00       	mov    0x11af18,%eax
}
  102f1b:	5d                   	pop    %ebp
  102f1c:	c3                   	ret    

00102f1d <basic_check>:

static void
basic_check(void) {
  102f1d:	55                   	push   %ebp
  102f1e:	89 e5                	mov    %esp,%ebp
  102f20:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102f23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f33:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102f36:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f3d:	e8 90 0e 00 00       	call   103dd2 <alloc_pages>
  102f42:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f45:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102f49:	75 24                	jne    102f6f <basic_check+0x52>
  102f4b:	c7 44 24 0c d9 65 10 	movl   $0x1065d9,0xc(%esp)
  102f52:	00 
  102f53:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  102f5a:	00 
  102f5b:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  102f62:	00 
  102f63:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  102f6a:	e8 63 dd ff ff       	call   100cd2 <__panic>
    assert((p1 = alloc_page()) != NULL);
  102f6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f76:	e8 57 0e 00 00       	call   103dd2 <alloc_pages>
  102f7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102f82:	75 24                	jne    102fa8 <basic_check+0x8b>
  102f84:	c7 44 24 0c f5 65 10 	movl   $0x1065f5,0xc(%esp)
  102f8b:	00 
  102f8c:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  102f93:	00 
  102f94:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  102f9b:	00 
  102f9c:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  102fa3:	e8 2a dd ff ff       	call   100cd2 <__panic>
    assert((p2 = alloc_page()) != NULL);
  102fa8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102faf:	e8 1e 0e 00 00       	call   103dd2 <alloc_pages>
  102fb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102fb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102fbb:	75 24                	jne    102fe1 <basic_check+0xc4>
  102fbd:	c7 44 24 0c 11 66 10 	movl   $0x106611,0xc(%esp)
  102fc4:	00 
  102fc5:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  102fcc:	00 
  102fcd:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  102fd4:	00 
  102fd5:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  102fdc:	e8 f1 dc ff ff       	call   100cd2 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102fe1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fe4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102fe7:	74 10                	je     102ff9 <basic_check+0xdc>
  102fe9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102fef:	74 08                	je     102ff9 <basic_check+0xdc>
  102ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ff4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ff7:	75 24                	jne    10301d <basic_check+0x100>
  102ff9:	c7 44 24 0c 30 66 10 	movl   $0x106630,0xc(%esp)
  103000:	00 
  103001:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  103008:	00 
  103009:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  103010:	00 
  103011:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  103018:	e8 b5 dc ff ff       	call   100cd2 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  10301d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103020:	89 04 24             	mov    %eax,(%esp)
  103023:	e8 d3 f8 ff ff       	call   1028fb <page_ref>
  103028:	85 c0                	test   %eax,%eax
  10302a:	75 1e                	jne    10304a <basic_check+0x12d>
  10302c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10302f:	89 04 24             	mov    %eax,(%esp)
  103032:	e8 c4 f8 ff ff       	call   1028fb <page_ref>
  103037:	85 c0                	test   %eax,%eax
  103039:	75 0f                	jne    10304a <basic_check+0x12d>
  10303b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10303e:	89 04 24             	mov    %eax,(%esp)
  103041:	e8 b5 f8 ff ff       	call   1028fb <page_ref>
  103046:	85 c0                	test   %eax,%eax
  103048:	74 24                	je     10306e <basic_check+0x151>
  10304a:	c7 44 24 0c 54 66 10 	movl   $0x106654,0xc(%esp)
  103051:	00 
  103052:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  103059:	00 
  10305a:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  103061:	00 
  103062:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  103069:	e8 64 dc ff ff       	call   100cd2 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  10306e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103071:	89 04 24             	mov    %eax,(%esp)
  103074:	e8 6c f8 ff ff       	call   1028e5 <page2pa>
  103079:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  10307f:	c1 e2 0c             	shl    $0xc,%edx
  103082:	39 d0                	cmp    %edx,%eax
  103084:	72 24                	jb     1030aa <basic_check+0x18d>
  103086:	c7 44 24 0c 90 66 10 	movl   $0x106690,0xc(%esp)
  10308d:	00 
  10308e:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  103095:	00 
  103096:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  10309d:	00 
  10309e:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  1030a5:	e8 28 dc ff ff       	call   100cd2 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1030aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030ad:	89 04 24             	mov    %eax,(%esp)
  1030b0:	e8 30 f8 ff ff       	call   1028e5 <page2pa>
  1030b5:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  1030bb:	c1 e2 0c             	shl    $0xc,%edx
  1030be:	39 d0                	cmp    %edx,%eax
  1030c0:	72 24                	jb     1030e6 <basic_check+0x1c9>
  1030c2:	c7 44 24 0c ad 66 10 	movl   $0x1066ad,0xc(%esp)
  1030c9:	00 
  1030ca:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  1030d1:	00 
  1030d2:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  1030d9:	00 
  1030da:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  1030e1:	e8 ec db ff ff       	call   100cd2 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  1030e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030e9:	89 04 24             	mov    %eax,(%esp)
  1030ec:	e8 f4 f7 ff ff       	call   1028e5 <page2pa>
  1030f1:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  1030f7:	c1 e2 0c             	shl    $0xc,%edx
  1030fa:	39 d0                	cmp    %edx,%eax
  1030fc:	72 24                	jb     103122 <basic_check+0x205>
  1030fe:	c7 44 24 0c ca 66 10 	movl   $0x1066ca,0xc(%esp)
  103105:	00 
  103106:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  10310d:	00 
  10310e:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  103115:	00 
  103116:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  10311d:	e8 b0 db ff ff       	call   100cd2 <__panic>

    list_entry_t free_list_store = free_list;
  103122:	a1 10 af 11 00       	mov    0x11af10,%eax
  103127:	8b 15 14 af 11 00    	mov    0x11af14,%edx
  10312d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103130:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103133:	c7 45 e0 10 af 11 00 	movl   $0x11af10,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10313a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10313d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103140:	89 50 04             	mov    %edx,0x4(%eax)
  103143:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103146:	8b 50 04             	mov    0x4(%eax),%edx
  103149:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10314c:	89 10                	mov    %edx,(%eax)
  10314e:	c7 45 dc 10 af 11 00 	movl   $0x11af10,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103155:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103158:	8b 40 04             	mov    0x4(%eax),%eax
  10315b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10315e:	0f 94 c0             	sete   %al
  103161:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103164:	85 c0                	test   %eax,%eax
  103166:	75 24                	jne    10318c <basic_check+0x26f>
  103168:	c7 44 24 0c e7 66 10 	movl   $0x1066e7,0xc(%esp)
  10316f:	00 
  103170:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  103177:	00 
  103178:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  10317f:	00 
  103180:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  103187:	e8 46 db ff ff       	call   100cd2 <__panic>

    unsigned int nr_free_store = nr_free;
  10318c:	a1 18 af 11 00       	mov    0x11af18,%eax
  103191:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  103194:	c7 05 18 af 11 00 00 	movl   $0x0,0x11af18
  10319b:	00 00 00 

    assert(alloc_page() == NULL);
  10319e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031a5:	e8 28 0c 00 00       	call   103dd2 <alloc_pages>
  1031aa:	85 c0                	test   %eax,%eax
  1031ac:	74 24                	je     1031d2 <basic_check+0x2b5>
  1031ae:	c7 44 24 0c fe 66 10 	movl   $0x1066fe,0xc(%esp)
  1031b5:	00 
  1031b6:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  1031bd:	00 
  1031be:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  1031c5:	00 
  1031c6:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  1031cd:	e8 00 db ff ff       	call   100cd2 <__panic>

    free_page(p0);
  1031d2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1031d9:	00 
  1031da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031dd:	89 04 24             	mov    %eax,(%esp)
  1031e0:	e8 25 0c 00 00       	call   103e0a <free_pages>
    free_page(p1);
  1031e5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1031ec:	00 
  1031ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031f0:	89 04 24             	mov    %eax,(%esp)
  1031f3:	e8 12 0c 00 00       	call   103e0a <free_pages>
    free_page(p2);
  1031f8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1031ff:	00 
  103200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103203:	89 04 24             	mov    %eax,(%esp)
  103206:	e8 ff 0b 00 00       	call   103e0a <free_pages>
    assert(nr_free == 3);
  10320b:	a1 18 af 11 00       	mov    0x11af18,%eax
  103210:	83 f8 03             	cmp    $0x3,%eax
  103213:	74 24                	je     103239 <basic_check+0x31c>
  103215:	c7 44 24 0c 13 67 10 	movl   $0x106713,0xc(%esp)
  10321c:	00 
  10321d:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  103224:	00 
  103225:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  10322c:	00 
  10322d:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  103234:	e8 99 da ff ff       	call   100cd2 <__panic>

    assert((p0 = alloc_page()) != NULL);
  103239:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103240:	e8 8d 0b 00 00       	call   103dd2 <alloc_pages>
  103245:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103248:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10324c:	75 24                	jne    103272 <basic_check+0x355>
  10324e:	c7 44 24 0c d9 65 10 	movl   $0x1065d9,0xc(%esp)
  103255:	00 
  103256:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  10325d:	00 
  10325e:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  103265:	00 
  103266:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  10326d:	e8 60 da ff ff       	call   100cd2 <__panic>
    assert((p1 = alloc_page()) != NULL);
  103272:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103279:	e8 54 0b 00 00       	call   103dd2 <alloc_pages>
  10327e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103281:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103285:	75 24                	jne    1032ab <basic_check+0x38e>
  103287:	c7 44 24 0c f5 65 10 	movl   $0x1065f5,0xc(%esp)
  10328e:	00 
  10328f:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  103296:	00 
  103297:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  10329e:	00 
  10329f:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  1032a6:	e8 27 da ff ff       	call   100cd2 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1032ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032b2:	e8 1b 0b 00 00       	call   103dd2 <alloc_pages>
  1032b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1032ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1032be:	75 24                	jne    1032e4 <basic_check+0x3c7>
  1032c0:	c7 44 24 0c 11 66 10 	movl   $0x106611,0xc(%esp)
  1032c7:	00 
  1032c8:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  1032cf:	00 
  1032d0:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  1032d7:	00 
  1032d8:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  1032df:	e8 ee d9 ff ff       	call   100cd2 <__panic>

    assert(alloc_page() == NULL);
  1032e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032eb:	e8 e2 0a 00 00       	call   103dd2 <alloc_pages>
  1032f0:	85 c0                	test   %eax,%eax
  1032f2:	74 24                	je     103318 <basic_check+0x3fb>
  1032f4:	c7 44 24 0c fe 66 10 	movl   $0x1066fe,0xc(%esp)
  1032fb:	00 
  1032fc:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  103303:	00 
  103304:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  10330b:	00 
  10330c:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  103313:	e8 ba d9 ff ff       	call   100cd2 <__panic>

    free_page(p0);
  103318:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10331f:	00 
  103320:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103323:	89 04 24             	mov    %eax,(%esp)
  103326:	e8 df 0a 00 00       	call   103e0a <free_pages>
  10332b:	c7 45 d8 10 af 11 00 	movl   $0x11af10,-0x28(%ebp)
  103332:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103335:	8b 40 04             	mov    0x4(%eax),%eax
  103338:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10333b:	0f 94 c0             	sete   %al
  10333e:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  103341:	85 c0                	test   %eax,%eax
  103343:	74 24                	je     103369 <basic_check+0x44c>
  103345:	c7 44 24 0c 20 67 10 	movl   $0x106720,0xc(%esp)
  10334c:	00 
  10334d:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  103354:	00 
  103355:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  10335c:	00 
  10335d:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  103364:	e8 69 d9 ff ff       	call   100cd2 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  103369:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103370:	e8 5d 0a 00 00       	call   103dd2 <alloc_pages>
  103375:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103378:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10337b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10337e:	74 24                	je     1033a4 <basic_check+0x487>
  103380:	c7 44 24 0c 38 67 10 	movl   $0x106738,0xc(%esp)
  103387:	00 
  103388:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  10338f:	00 
  103390:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  103397:	00 
  103398:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  10339f:	e8 2e d9 ff ff       	call   100cd2 <__panic>
    assert(alloc_page() == NULL);
  1033a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033ab:	e8 22 0a 00 00       	call   103dd2 <alloc_pages>
  1033b0:	85 c0                	test   %eax,%eax
  1033b2:	74 24                	je     1033d8 <basic_check+0x4bb>
  1033b4:	c7 44 24 0c fe 66 10 	movl   $0x1066fe,0xc(%esp)
  1033bb:	00 
  1033bc:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  1033c3:	00 
  1033c4:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  1033cb:	00 
  1033cc:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  1033d3:	e8 fa d8 ff ff       	call   100cd2 <__panic>

    assert(nr_free == 0);
  1033d8:	a1 18 af 11 00       	mov    0x11af18,%eax
  1033dd:	85 c0                	test   %eax,%eax
  1033df:	74 24                	je     103405 <basic_check+0x4e8>
  1033e1:	c7 44 24 0c 51 67 10 	movl   $0x106751,0xc(%esp)
  1033e8:	00 
  1033e9:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  1033f0:	00 
  1033f1:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  1033f8:	00 
  1033f9:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  103400:	e8 cd d8 ff ff       	call   100cd2 <__panic>
    free_list = free_list_store;
  103405:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103408:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10340b:	a3 10 af 11 00       	mov    %eax,0x11af10
  103410:	89 15 14 af 11 00    	mov    %edx,0x11af14
    nr_free = nr_free_store;
  103416:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103419:	a3 18 af 11 00       	mov    %eax,0x11af18

    free_page(p);
  10341e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103425:	00 
  103426:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103429:	89 04 24             	mov    %eax,(%esp)
  10342c:	e8 d9 09 00 00       	call   103e0a <free_pages>
    free_page(p1);
  103431:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103438:	00 
  103439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10343c:	89 04 24             	mov    %eax,(%esp)
  10343f:	e8 c6 09 00 00       	call   103e0a <free_pages>
    free_page(p2);
  103444:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10344b:	00 
  10344c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10344f:	89 04 24             	mov    %eax,(%esp)
  103452:	e8 b3 09 00 00       	call   103e0a <free_pages>
}
  103457:	c9                   	leave  
  103458:	c3                   	ret    

00103459 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  103459:	55                   	push   %ebp
  10345a:	89 e5                	mov    %esp,%ebp
  10345c:	53                   	push   %ebx
  10345d:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  103463:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10346a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  103471:	c7 45 ec 10 af 11 00 	movl   $0x11af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103478:	eb 6b                	jmp    1034e5 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  10347a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10347d:	83 e8 0c             	sub    $0xc,%eax
  103480:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  103483:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103486:	83 c0 04             	add    $0x4,%eax
  103489:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103490:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103493:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103496:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103499:	0f a3 10             	bt     %edx,(%eax)
  10349c:	19 c0                	sbb    %eax,%eax
  10349e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1034a1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1034a5:	0f 95 c0             	setne  %al
  1034a8:	0f b6 c0             	movzbl %al,%eax
  1034ab:	85 c0                	test   %eax,%eax
  1034ad:	75 24                	jne    1034d3 <default_check+0x7a>
  1034af:	c7 44 24 0c 5e 67 10 	movl   $0x10675e,0xc(%esp)
  1034b6:	00 
  1034b7:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  1034be:	00 
  1034bf:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
  1034c6:	00 
  1034c7:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  1034ce:	e8 ff d7 ff ff       	call   100cd2 <__panic>
        count ++, total += p->property;
  1034d3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1034d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034da:	8b 50 08             	mov    0x8(%eax),%edx
  1034dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034e0:	01 d0                	add    %edx,%eax
  1034e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034e8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1034eb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1034ee:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1034f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1034f4:	81 7d ec 10 af 11 00 	cmpl   $0x11af10,-0x14(%ebp)
  1034fb:	0f 85 79 ff ff ff    	jne    10347a <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  103501:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  103504:	e8 33 09 00 00       	call   103e3c <nr_free_pages>
  103509:	39 c3                	cmp    %eax,%ebx
  10350b:	74 24                	je     103531 <default_check+0xd8>
  10350d:	c7 44 24 0c 6e 67 10 	movl   $0x10676e,0xc(%esp)
  103514:	00 
  103515:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  10351c:	00 
  10351d:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  103524:	00 
  103525:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  10352c:	e8 a1 d7 ff ff       	call   100cd2 <__panic>

    basic_check();
  103531:	e8 e7 f9 ff ff       	call   102f1d <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103536:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10353d:	e8 90 08 00 00       	call   103dd2 <alloc_pages>
  103542:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  103545:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103549:	75 24                	jne    10356f <default_check+0x116>
  10354b:	c7 44 24 0c 87 67 10 	movl   $0x106787,0xc(%esp)
  103552:	00 
  103553:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  10355a:	00 
  10355b:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  103562:	00 
  103563:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  10356a:	e8 63 d7 ff ff       	call   100cd2 <__panic>
    assert(!PageProperty(p0));
  10356f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103572:	83 c0 04             	add    $0x4,%eax
  103575:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  10357c:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10357f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103582:	8b 55 c0             	mov    -0x40(%ebp),%edx
  103585:	0f a3 10             	bt     %edx,(%eax)
  103588:	19 c0                	sbb    %eax,%eax
  10358a:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  10358d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  103591:	0f 95 c0             	setne  %al
  103594:	0f b6 c0             	movzbl %al,%eax
  103597:	85 c0                	test   %eax,%eax
  103599:	74 24                	je     1035bf <default_check+0x166>
  10359b:	c7 44 24 0c 92 67 10 	movl   $0x106792,0xc(%esp)
  1035a2:	00 
  1035a3:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  1035aa:	00 
  1035ab:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  1035b2:	00 
  1035b3:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  1035ba:	e8 13 d7 ff ff       	call   100cd2 <__panic>

    list_entry_t free_list_store = free_list;
  1035bf:	a1 10 af 11 00       	mov    0x11af10,%eax
  1035c4:	8b 15 14 af 11 00    	mov    0x11af14,%edx
  1035ca:	89 45 80             	mov    %eax,-0x80(%ebp)
  1035cd:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1035d0:	c7 45 b4 10 af 11 00 	movl   $0x11af10,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1035d7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1035da:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1035dd:	89 50 04             	mov    %edx,0x4(%eax)
  1035e0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1035e3:	8b 50 04             	mov    0x4(%eax),%edx
  1035e6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1035e9:	89 10                	mov    %edx,(%eax)
  1035eb:	c7 45 b0 10 af 11 00 	movl   $0x11af10,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1035f2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1035f5:	8b 40 04             	mov    0x4(%eax),%eax
  1035f8:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  1035fb:	0f 94 c0             	sete   %al
  1035fe:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103601:	85 c0                	test   %eax,%eax
  103603:	75 24                	jne    103629 <default_check+0x1d0>
  103605:	c7 44 24 0c e7 66 10 	movl   $0x1066e7,0xc(%esp)
  10360c:	00 
  10360d:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  103614:	00 
  103615:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
  10361c:	00 
  10361d:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  103624:	e8 a9 d6 ff ff       	call   100cd2 <__panic>
    assert(alloc_page() == NULL);
  103629:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103630:	e8 9d 07 00 00       	call   103dd2 <alloc_pages>
  103635:	85 c0                	test   %eax,%eax
  103637:	74 24                	je     10365d <default_check+0x204>
  103639:	c7 44 24 0c fe 66 10 	movl   $0x1066fe,0xc(%esp)
  103640:	00 
  103641:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  103648:	00 
  103649:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
  103650:	00 
  103651:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  103658:	e8 75 d6 ff ff       	call   100cd2 <__panic>

    unsigned int nr_free_store = nr_free;
  10365d:	a1 18 af 11 00       	mov    0x11af18,%eax
  103662:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  103665:	c7 05 18 af 11 00 00 	movl   $0x0,0x11af18
  10366c:	00 00 00 

    free_pages(p0 + 2, 3);
  10366f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103672:	83 c0 28             	add    $0x28,%eax
  103675:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10367c:	00 
  10367d:	89 04 24             	mov    %eax,(%esp)
  103680:	e8 85 07 00 00       	call   103e0a <free_pages>
    assert(alloc_pages(4) == NULL);
  103685:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10368c:	e8 41 07 00 00       	call   103dd2 <alloc_pages>
  103691:	85 c0                	test   %eax,%eax
  103693:	74 24                	je     1036b9 <default_check+0x260>
  103695:	c7 44 24 0c a4 67 10 	movl   $0x1067a4,0xc(%esp)
  10369c:	00 
  10369d:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  1036a4:	00 
  1036a5:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
  1036ac:	00 
  1036ad:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  1036b4:	e8 19 d6 ff ff       	call   100cd2 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1036b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036bc:	83 c0 28             	add    $0x28,%eax
  1036bf:	83 c0 04             	add    $0x4,%eax
  1036c2:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1036c9:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036cc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1036cf:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1036d2:	0f a3 10             	bt     %edx,(%eax)
  1036d5:	19 c0                	sbb    %eax,%eax
  1036d7:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1036da:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1036de:	0f 95 c0             	setne  %al
  1036e1:	0f b6 c0             	movzbl %al,%eax
  1036e4:	85 c0                	test   %eax,%eax
  1036e6:	74 0e                	je     1036f6 <default_check+0x29d>
  1036e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036eb:	83 c0 28             	add    $0x28,%eax
  1036ee:	8b 40 08             	mov    0x8(%eax),%eax
  1036f1:	83 f8 03             	cmp    $0x3,%eax
  1036f4:	74 24                	je     10371a <default_check+0x2c1>
  1036f6:	c7 44 24 0c bc 67 10 	movl   $0x1067bc,0xc(%esp)
  1036fd:	00 
  1036fe:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  103705:	00 
  103706:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
  10370d:	00 
  10370e:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  103715:	e8 b8 d5 ff ff       	call   100cd2 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  10371a:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  103721:	e8 ac 06 00 00       	call   103dd2 <alloc_pages>
  103726:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103729:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10372d:	75 24                	jne    103753 <default_check+0x2fa>
  10372f:	c7 44 24 0c e8 67 10 	movl   $0x1067e8,0xc(%esp)
  103736:	00 
  103737:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  10373e:	00 
  10373f:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
  103746:	00 
  103747:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  10374e:	e8 7f d5 ff ff       	call   100cd2 <__panic>
    assert(alloc_page() == NULL);
  103753:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10375a:	e8 73 06 00 00       	call   103dd2 <alloc_pages>
  10375f:	85 c0                	test   %eax,%eax
  103761:	74 24                	je     103787 <default_check+0x32e>
  103763:	c7 44 24 0c fe 66 10 	movl   $0x1066fe,0xc(%esp)
  10376a:	00 
  10376b:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  103772:	00 
  103773:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
  10377a:	00 
  10377b:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  103782:	e8 4b d5 ff ff       	call   100cd2 <__panic>
    assert(p0 + 2 == p1);
  103787:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10378a:	83 c0 28             	add    $0x28,%eax
  10378d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103790:	74 24                	je     1037b6 <default_check+0x35d>
  103792:	c7 44 24 0c 06 68 10 	movl   $0x106806,0xc(%esp)
  103799:	00 
  10379a:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  1037a1:	00 
  1037a2:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  1037a9:	00 
  1037aa:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  1037b1:	e8 1c d5 ff ff       	call   100cd2 <__panic>

    p2 = p0 + 1;
  1037b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037b9:	83 c0 14             	add    $0x14,%eax
  1037bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  1037bf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1037c6:	00 
  1037c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037ca:	89 04 24             	mov    %eax,(%esp)
  1037cd:	e8 38 06 00 00       	call   103e0a <free_pages>
    free_pages(p1, 3);
  1037d2:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1037d9:	00 
  1037da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037dd:	89 04 24             	mov    %eax,(%esp)
  1037e0:	e8 25 06 00 00       	call   103e0a <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1037e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037e8:	83 c0 04             	add    $0x4,%eax
  1037eb:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1037f2:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1037f5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1037f8:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1037fb:	0f a3 10             	bt     %edx,(%eax)
  1037fe:	19 c0                	sbb    %eax,%eax
  103800:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  103803:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103807:	0f 95 c0             	setne  %al
  10380a:	0f b6 c0             	movzbl %al,%eax
  10380d:	85 c0                	test   %eax,%eax
  10380f:	74 0b                	je     10381c <default_check+0x3c3>
  103811:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103814:	8b 40 08             	mov    0x8(%eax),%eax
  103817:	83 f8 01             	cmp    $0x1,%eax
  10381a:	74 24                	je     103840 <default_check+0x3e7>
  10381c:	c7 44 24 0c 14 68 10 	movl   $0x106814,0xc(%esp)
  103823:	00 
  103824:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  10382b:	00 
  10382c:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
  103833:	00 
  103834:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  10383b:	e8 92 d4 ff ff       	call   100cd2 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103840:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103843:	83 c0 04             	add    $0x4,%eax
  103846:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  10384d:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103850:	8b 45 90             	mov    -0x70(%ebp),%eax
  103853:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103856:	0f a3 10             	bt     %edx,(%eax)
  103859:	19 c0                	sbb    %eax,%eax
  10385b:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  10385e:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103862:	0f 95 c0             	setne  %al
  103865:	0f b6 c0             	movzbl %al,%eax
  103868:	85 c0                	test   %eax,%eax
  10386a:	74 0b                	je     103877 <default_check+0x41e>
  10386c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10386f:	8b 40 08             	mov    0x8(%eax),%eax
  103872:	83 f8 03             	cmp    $0x3,%eax
  103875:	74 24                	je     10389b <default_check+0x442>
  103877:	c7 44 24 0c 3c 68 10 	movl   $0x10683c,0xc(%esp)
  10387e:	00 
  10387f:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  103886:	00 
  103887:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
  10388e:	00 
  10388f:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  103896:	e8 37 d4 ff ff       	call   100cd2 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  10389b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1038a2:	e8 2b 05 00 00       	call   103dd2 <alloc_pages>
  1038a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1038aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1038ad:	83 e8 14             	sub    $0x14,%eax
  1038b0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1038b3:	74 24                	je     1038d9 <default_check+0x480>
  1038b5:	c7 44 24 0c 62 68 10 	movl   $0x106862,0xc(%esp)
  1038bc:	00 
  1038bd:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  1038c4:	00 
  1038c5:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
  1038cc:	00 
  1038cd:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  1038d4:	e8 f9 d3 ff ff       	call   100cd2 <__panic>
    free_page(p0);
  1038d9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1038e0:	00 
  1038e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038e4:	89 04 24             	mov    %eax,(%esp)
  1038e7:	e8 1e 05 00 00       	call   103e0a <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1038ec:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1038f3:	e8 da 04 00 00       	call   103dd2 <alloc_pages>
  1038f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1038fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1038fe:	83 c0 14             	add    $0x14,%eax
  103901:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103904:	74 24                	je     10392a <default_check+0x4d1>
  103906:	c7 44 24 0c 80 68 10 	movl   $0x106880,0xc(%esp)
  10390d:	00 
  10390e:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  103915:	00 
  103916:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
  10391d:	00 
  10391e:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  103925:	e8 a8 d3 ff ff       	call   100cd2 <__panic>

    free_pages(p0, 2);
  10392a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103931:	00 
  103932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103935:	89 04 24             	mov    %eax,(%esp)
  103938:	e8 cd 04 00 00       	call   103e0a <free_pages>
    free_page(p2);
  10393d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103944:	00 
  103945:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103948:	89 04 24             	mov    %eax,(%esp)
  10394b:	e8 ba 04 00 00       	call   103e0a <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103950:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103957:	e8 76 04 00 00       	call   103dd2 <alloc_pages>
  10395c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10395f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103963:	75 24                	jne    103989 <default_check+0x530>
  103965:	c7 44 24 0c a0 68 10 	movl   $0x1068a0,0xc(%esp)
  10396c:	00 
  10396d:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  103974:	00 
  103975:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
  10397c:	00 
  10397d:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  103984:	e8 49 d3 ff ff       	call   100cd2 <__panic>
    assert(alloc_page() == NULL);
  103989:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103990:	e8 3d 04 00 00       	call   103dd2 <alloc_pages>
  103995:	85 c0                	test   %eax,%eax
  103997:	74 24                	je     1039bd <default_check+0x564>
  103999:	c7 44 24 0c fe 66 10 	movl   $0x1066fe,0xc(%esp)
  1039a0:	00 
  1039a1:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  1039a8:	00 
  1039a9:	c7 44 24 04 48 01 00 	movl   $0x148,0x4(%esp)
  1039b0:	00 
  1039b1:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  1039b8:	e8 15 d3 ff ff       	call   100cd2 <__panic>

    assert(nr_free == 0);
  1039bd:	a1 18 af 11 00       	mov    0x11af18,%eax
  1039c2:	85 c0                	test   %eax,%eax
  1039c4:	74 24                	je     1039ea <default_check+0x591>
  1039c6:	c7 44 24 0c 51 67 10 	movl   $0x106751,0xc(%esp)
  1039cd:	00 
  1039ce:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  1039d5:	00 
  1039d6:	c7 44 24 04 4a 01 00 	movl   $0x14a,0x4(%esp)
  1039dd:	00 
  1039de:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  1039e5:	e8 e8 d2 ff ff       	call   100cd2 <__panic>
    nr_free = nr_free_store;
  1039ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1039ed:	a3 18 af 11 00       	mov    %eax,0x11af18

    free_list = free_list_store;
  1039f2:	8b 45 80             	mov    -0x80(%ebp),%eax
  1039f5:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1039f8:	a3 10 af 11 00       	mov    %eax,0x11af10
  1039fd:	89 15 14 af 11 00    	mov    %edx,0x11af14
    free_pages(p0, 5);
  103a03:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103a0a:	00 
  103a0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a0e:	89 04 24             	mov    %eax,(%esp)
  103a11:	e8 f4 03 00 00       	call   103e0a <free_pages>

    le = &free_list;
  103a16:	c7 45 ec 10 af 11 00 	movl   $0x11af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103a1d:	eb 1d                	jmp    103a3c <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103a1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103a22:	83 e8 0c             	sub    $0xc,%eax
  103a25:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103a28:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103a2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103a2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103a32:	8b 40 08             	mov    0x8(%eax),%eax
  103a35:	29 c2                	sub    %eax,%edx
  103a37:	89 d0                	mov    %edx,%eax
  103a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103a3f:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103a42:	8b 45 88             	mov    -0x78(%ebp),%eax
  103a45:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103a48:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103a4b:	81 7d ec 10 af 11 00 	cmpl   $0x11af10,-0x14(%ebp)
  103a52:	75 cb                	jne    103a1f <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103a54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103a58:	74 24                	je     103a7e <default_check+0x625>
  103a5a:	c7 44 24 0c be 68 10 	movl   $0x1068be,0xc(%esp)
  103a61:	00 
  103a62:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  103a69:	00 
  103a6a:	c7 44 24 04 55 01 00 	movl   $0x155,0x4(%esp)
  103a71:	00 
  103a72:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  103a79:	e8 54 d2 ff ff       	call   100cd2 <__panic>
    assert(total == 0);
  103a7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a82:	74 24                	je     103aa8 <default_check+0x64f>
  103a84:	c7 44 24 0c c9 68 10 	movl   $0x1068c9,0xc(%esp)
  103a8b:	00 
  103a8c:	c7 44 24 08 76 65 10 	movl   $0x106576,0x8(%esp)
  103a93:	00 
  103a94:	c7 44 24 04 56 01 00 	movl   $0x156,0x4(%esp)
  103a9b:	00 
  103a9c:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  103aa3:	e8 2a d2 ff ff       	call   100cd2 <__panic>
}
  103aa8:	81 c4 94 00 00 00    	add    $0x94,%esp
  103aae:	5b                   	pop    %ebx
  103aaf:	5d                   	pop    %ebp
  103ab0:	c3                   	ret    

00103ab1 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103ab1:	55                   	push   %ebp
  103ab2:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103ab4:	8b 55 08             	mov    0x8(%ebp),%edx
  103ab7:	a1 24 af 11 00       	mov    0x11af24,%eax
  103abc:	29 c2                	sub    %eax,%edx
  103abe:	89 d0                	mov    %edx,%eax
  103ac0:	c1 f8 02             	sar    $0x2,%eax
  103ac3:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103ac9:	5d                   	pop    %ebp
  103aca:	c3                   	ret    

00103acb <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103acb:	55                   	push   %ebp
  103acc:	89 e5                	mov    %esp,%ebp
  103ace:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  103ad4:	89 04 24             	mov    %eax,(%esp)
  103ad7:	e8 d5 ff ff ff       	call   103ab1 <page2ppn>
  103adc:	c1 e0 0c             	shl    $0xc,%eax
}
  103adf:	c9                   	leave  
  103ae0:	c3                   	ret    

00103ae1 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103ae1:	55                   	push   %ebp
  103ae2:	89 e5                	mov    %esp,%ebp
  103ae4:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  103aea:	c1 e8 0c             	shr    $0xc,%eax
  103aed:	89 c2                	mov    %eax,%edx
  103aef:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103af4:	39 c2                	cmp    %eax,%edx
  103af6:	72 1c                	jb     103b14 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103af8:	c7 44 24 08 04 69 10 	movl   $0x106904,0x8(%esp)
  103aff:	00 
  103b00:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103b07:	00 
  103b08:	c7 04 24 23 69 10 00 	movl   $0x106923,(%esp)
  103b0f:	e8 be d1 ff ff       	call   100cd2 <__panic>
    }
    return &pages[PPN(pa)];
  103b14:	8b 0d 24 af 11 00    	mov    0x11af24,%ecx
  103b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  103b1d:	c1 e8 0c             	shr    $0xc,%eax
  103b20:	89 c2                	mov    %eax,%edx
  103b22:	89 d0                	mov    %edx,%eax
  103b24:	c1 e0 02             	shl    $0x2,%eax
  103b27:	01 d0                	add    %edx,%eax
  103b29:	c1 e0 02             	shl    $0x2,%eax
  103b2c:	01 c8                	add    %ecx,%eax
}
  103b2e:	c9                   	leave  
  103b2f:	c3                   	ret    

00103b30 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103b30:	55                   	push   %ebp
  103b31:	89 e5                	mov    %esp,%ebp
  103b33:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103b36:	8b 45 08             	mov    0x8(%ebp),%eax
  103b39:	89 04 24             	mov    %eax,(%esp)
  103b3c:	e8 8a ff ff ff       	call   103acb <page2pa>
  103b41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b47:	c1 e8 0c             	shr    $0xc,%eax
  103b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b4d:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103b52:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103b55:	72 23                	jb     103b7a <page2kva+0x4a>
  103b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b5a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103b5e:	c7 44 24 08 34 69 10 	movl   $0x106934,0x8(%esp)
  103b65:	00 
  103b66:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103b6d:	00 
  103b6e:	c7 04 24 23 69 10 00 	movl   $0x106923,(%esp)
  103b75:	e8 58 d1 ff ff       	call   100cd2 <__panic>
  103b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b7d:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103b82:	c9                   	leave  
  103b83:	c3                   	ret    

00103b84 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103b84:	55                   	push   %ebp
  103b85:	89 e5                	mov    %esp,%ebp
  103b87:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  103b8d:	83 e0 01             	and    $0x1,%eax
  103b90:	85 c0                	test   %eax,%eax
  103b92:	75 1c                	jne    103bb0 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103b94:	c7 44 24 08 58 69 10 	movl   $0x106958,0x8(%esp)
  103b9b:	00 
  103b9c:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103ba3:	00 
  103ba4:	c7 04 24 23 69 10 00 	movl   $0x106923,(%esp)
  103bab:	e8 22 d1 ff ff       	call   100cd2 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  103bb3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103bb8:	89 04 24             	mov    %eax,(%esp)
  103bbb:	e8 21 ff ff ff       	call   103ae1 <pa2page>
}
  103bc0:	c9                   	leave  
  103bc1:	c3                   	ret    

00103bc2 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  103bc2:	55                   	push   %ebp
  103bc3:	89 e5                	mov    %esp,%ebp
  103bc5:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  103bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  103bcb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103bd0:	89 04 24             	mov    %eax,(%esp)
  103bd3:	e8 09 ff ff ff       	call   103ae1 <pa2page>
}
  103bd8:	c9                   	leave  
  103bd9:	c3                   	ret    

00103bda <page_ref>:

static inline int
page_ref(struct Page *page) {
  103bda:	55                   	push   %ebp
  103bdb:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  103be0:	8b 00                	mov    (%eax),%eax
}
  103be2:	5d                   	pop    %ebp
  103be3:	c3                   	ret    

00103be4 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
  103be4:	55                   	push   %ebp
  103be5:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103be7:	8b 45 08             	mov    0x8(%ebp),%eax
  103bea:	8b 00                	mov    (%eax),%eax
  103bec:	8d 50 01             	lea    0x1(%eax),%edx
  103bef:	8b 45 08             	mov    0x8(%ebp),%eax
  103bf2:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  103bf7:	8b 00                	mov    (%eax),%eax
}
  103bf9:	5d                   	pop    %ebp
  103bfa:	c3                   	ret    

00103bfb <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103bfb:	55                   	push   %ebp
  103bfc:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  103c01:	8b 00                	mov    (%eax),%eax
  103c03:	8d 50 ff             	lea    -0x1(%eax),%edx
  103c06:	8b 45 08             	mov    0x8(%ebp),%eax
  103c09:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  103c0e:	8b 00                	mov    (%eax),%eax
}
  103c10:	5d                   	pop    %ebp
  103c11:	c3                   	ret    

00103c12 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103c12:	55                   	push   %ebp
  103c13:	89 e5                	mov    %esp,%ebp
  103c15:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103c18:	9c                   	pushf  
  103c19:	58                   	pop    %eax
  103c1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103c20:	25 00 02 00 00       	and    $0x200,%eax
  103c25:	85 c0                	test   %eax,%eax
  103c27:	74 0c                	je     103c35 <__intr_save+0x23>
        intr_disable();
  103c29:	e8 98 da ff ff       	call   1016c6 <intr_disable>
        return 1;
  103c2e:	b8 01 00 00 00       	mov    $0x1,%eax
  103c33:	eb 05                	jmp    103c3a <__intr_save+0x28>
    }
    return 0;
  103c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103c3a:	c9                   	leave  
  103c3b:	c3                   	ret    

00103c3c <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103c3c:	55                   	push   %ebp
  103c3d:	89 e5                	mov    %esp,%ebp
  103c3f:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103c42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103c46:	74 05                	je     103c4d <__intr_restore+0x11>
        intr_enable();
  103c48:	e8 73 da ff ff       	call   1016c0 <intr_enable>
    }
}
  103c4d:	c9                   	leave  
  103c4e:	c3                   	ret    

00103c4f <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103c4f:	55                   	push   %ebp
  103c50:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103c52:	8b 45 08             	mov    0x8(%ebp),%eax
  103c55:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103c58:	b8 23 00 00 00       	mov    $0x23,%eax
  103c5d:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103c5f:	b8 23 00 00 00       	mov    $0x23,%eax
  103c64:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103c66:	b8 10 00 00 00       	mov    $0x10,%eax
  103c6b:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103c6d:	b8 10 00 00 00       	mov    $0x10,%eax
  103c72:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103c74:	b8 10 00 00 00       	mov    $0x10,%eax
  103c79:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103c7b:	ea 82 3c 10 00 08 00 	ljmp   $0x8,$0x103c82
}
  103c82:	5d                   	pop    %ebp
  103c83:	c3                   	ret    

00103c84 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103c84:	55                   	push   %ebp
  103c85:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103c87:	8b 45 08             	mov    0x8(%ebp),%eax
  103c8a:	a3 a4 ae 11 00       	mov    %eax,0x11aea4
}
  103c8f:	5d                   	pop    %ebp
  103c90:	c3                   	ret    

00103c91 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103c91:	55                   	push   %ebp
  103c92:	89 e5                	mov    %esp,%ebp
  103c94:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103c97:	b8 00 70 11 00       	mov    $0x117000,%eax
  103c9c:	89 04 24             	mov    %eax,(%esp)
  103c9f:	e8 e0 ff ff ff       	call   103c84 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103ca4:	66 c7 05 a8 ae 11 00 	movw   $0x10,0x11aea8
  103cab:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103cad:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103cb4:	68 00 
  103cb6:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  103cbb:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103cc1:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  103cc6:	c1 e8 10             	shr    $0x10,%eax
  103cc9:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103cce:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103cd5:	83 e0 f0             	and    $0xfffffff0,%eax
  103cd8:	83 c8 09             	or     $0x9,%eax
  103cdb:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103ce0:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103ce7:	83 e0 ef             	and    $0xffffffef,%eax
  103cea:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103cef:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103cf6:	83 e0 9f             	and    $0xffffff9f,%eax
  103cf9:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103cfe:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103d05:	83 c8 80             	or     $0xffffff80,%eax
  103d08:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103d0d:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103d14:	83 e0 f0             	and    $0xfffffff0,%eax
  103d17:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103d1c:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103d23:	83 e0 ef             	and    $0xffffffef,%eax
  103d26:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103d2b:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103d32:	83 e0 df             	and    $0xffffffdf,%eax
  103d35:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103d3a:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103d41:	83 c8 40             	or     $0x40,%eax
  103d44:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103d49:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103d50:	83 e0 7f             	and    $0x7f,%eax
  103d53:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103d58:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  103d5d:	c1 e8 18             	shr    $0x18,%eax
  103d60:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103d65:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103d6c:	e8 de fe ff ff       	call   103c4f <lgdt>
  103d71:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103d77:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103d7b:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103d7e:	c9                   	leave  
  103d7f:	c3                   	ret    

00103d80 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103d80:	55                   	push   %ebp
  103d81:	89 e5                	mov    %esp,%ebp
  103d83:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103d86:	c7 05 1c af 11 00 e8 	movl   $0x1068e8,0x11af1c
  103d8d:	68 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103d90:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103d95:	8b 00                	mov    (%eax),%eax
  103d97:	89 44 24 04          	mov    %eax,0x4(%esp)
  103d9b:	c7 04 24 84 69 10 00 	movl   $0x106984,(%esp)
  103da2:	e8 a1 c5 ff ff       	call   100348 <cprintf>
    pmm_manager->init();
  103da7:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103dac:	8b 40 04             	mov    0x4(%eax),%eax
  103daf:	ff d0                	call   *%eax
}
  103db1:	c9                   	leave  
  103db2:	c3                   	ret    

00103db3 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103db3:	55                   	push   %ebp
  103db4:	89 e5                	mov    %esp,%ebp
  103db6:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103db9:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103dbe:	8b 40 08             	mov    0x8(%eax),%eax
  103dc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  103dc4:	89 54 24 04          	mov    %edx,0x4(%esp)
  103dc8:	8b 55 08             	mov    0x8(%ebp),%edx
  103dcb:	89 14 24             	mov    %edx,(%esp)
  103dce:	ff d0                	call   *%eax
}
  103dd0:	c9                   	leave  
  103dd1:	c3                   	ret    

00103dd2 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103dd2:	55                   	push   %ebp
  103dd3:	89 e5                	mov    %esp,%ebp
  103dd5:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103dd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103ddf:	e8 2e fe ff ff       	call   103c12 <__intr_save>
  103de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103de7:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103dec:	8b 40 0c             	mov    0xc(%eax),%eax
  103def:	8b 55 08             	mov    0x8(%ebp),%edx
  103df2:	89 14 24             	mov    %edx,(%esp)
  103df5:	ff d0                	call   *%eax
  103df7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103dfd:	89 04 24             	mov    %eax,(%esp)
  103e00:	e8 37 fe ff ff       	call   103c3c <__intr_restore>
    return page;
  103e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103e08:	c9                   	leave  
  103e09:	c3                   	ret    

00103e0a <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103e0a:	55                   	push   %ebp
  103e0b:	89 e5                	mov    %esp,%ebp
  103e0d:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103e10:	e8 fd fd ff ff       	call   103c12 <__intr_save>
  103e15:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103e18:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103e1d:	8b 40 10             	mov    0x10(%eax),%eax
  103e20:	8b 55 0c             	mov    0xc(%ebp),%edx
  103e23:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e27:	8b 55 08             	mov    0x8(%ebp),%edx
  103e2a:	89 14 24             	mov    %edx,(%esp)
  103e2d:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e32:	89 04 24             	mov    %eax,(%esp)
  103e35:	e8 02 fe ff ff       	call   103c3c <__intr_restore>
}
  103e3a:	c9                   	leave  
  103e3b:	c3                   	ret    

00103e3c <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103e3c:	55                   	push   %ebp
  103e3d:	89 e5                	mov    %esp,%ebp
  103e3f:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103e42:	e8 cb fd ff ff       	call   103c12 <__intr_save>
  103e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103e4a:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103e4f:	8b 40 14             	mov    0x14(%eax),%eax
  103e52:	ff d0                	call   *%eax
  103e54:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e5a:	89 04 24             	mov    %eax,(%esp)
  103e5d:	e8 da fd ff ff       	call   103c3c <__intr_restore>
    return ret;
  103e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103e65:	c9                   	leave  
  103e66:	c3                   	ret    

00103e67 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103e67:	55                   	push   %ebp
  103e68:	89 e5                	mov    %esp,%ebp
  103e6a:	57                   	push   %edi
  103e6b:	56                   	push   %esi
  103e6c:	53                   	push   %ebx
  103e6d:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103e73:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103e7a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103e81:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103e88:	c7 04 24 9b 69 10 00 	movl   $0x10699b,(%esp)
  103e8f:	e8 b4 c4 ff ff       	call   100348 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103e94:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103e9b:	e9 15 01 00 00       	jmp    103fb5 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103ea0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103ea3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ea6:	89 d0                	mov    %edx,%eax
  103ea8:	c1 e0 02             	shl    $0x2,%eax
  103eab:	01 d0                	add    %edx,%eax
  103ead:	c1 e0 02             	shl    $0x2,%eax
  103eb0:	01 c8                	add    %ecx,%eax
  103eb2:	8b 50 08             	mov    0x8(%eax),%edx
  103eb5:	8b 40 04             	mov    0x4(%eax),%eax
  103eb8:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103ebb:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103ebe:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103ec1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ec4:	89 d0                	mov    %edx,%eax
  103ec6:	c1 e0 02             	shl    $0x2,%eax
  103ec9:	01 d0                	add    %edx,%eax
  103ecb:	c1 e0 02             	shl    $0x2,%eax
  103ece:	01 c8                	add    %ecx,%eax
  103ed0:	8b 48 0c             	mov    0xc(%eax),%ecx
  103ed3:	8b 58 10             	mov    0x10(%eax),%ebx
  103ed6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103ed9:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103edc:	01 c8                	add    %ecx,%eax
  103ede:	11 da                	adc    %ebx,%edx
  103ee0:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103ee3:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103ee6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103ee9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103eec:	89 d0                	mov    %edx,%eax
  103eee:	c1 e0 02             	shl    $0x2,%eax
  103ef1:	01 d0                	add    %edx,%eax
  103ef3:	c1 e0 02             	shl    $0x2,%eax
  103ef6:	01 c8                	add    %ecx,%eax
  103ef8:	83 c0 14             	add    $0x14,%eax
  103efb:	8b 00                	mov    (%eax),%eax
  103efd:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103f03:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103f06:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103f09:	83 c0 ff             	add    $0xffffffff,%eax
  103f0c:	83 d2 ff             	adc    $0xffffffff,%edx
  103f0f:	89 c6                	mov    %eax,%esi
  103f11:	89 d7                	mov    %edx,%edi
  103f13:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f16:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f19:	89 d0                	mov    %edx,%eax
  103f1b:	c1 e0 02             	shl    $0x2,%eax
  103f1e:	01 d0                	add    %edx,%eax
  103f20:	c1 e0 02             	shl    $0x2,%eax
  103f23:	01 c8                	add    %ecx,%eax
  103f25:	8b 48 0c             	mov    0xc(%eax),%ecx
  103f28:	8b 58 10             	mov    0x10(%eax),%ebx
  103f2b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103f31:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103f35:	89 74 24 14          	mov    %esi,0x14(%esp)
  103f39:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103f3d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103f40:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103f43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103f47:	89 54 24 10          	mov    %edx,0x10(%esp)
  103f4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103f4f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103f53:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  103f5a:	e8 e9 c3 ff ff       	call   100348 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103f5f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f62:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f65:	89 d0                	mov    %edx,%eax
  103f67:	c1 e0 02             	shl    $0x2,%eax
  103f6a:	01 d0                	add    %edx,%eax
  103f6c:	c1 e0 02             	shl    $0x2,%eax
  103f6f:	01 c8                	add    %ecx,%eax
  103f71:	83 c0 14             	add    $0x14,%eax
  103f74:	8b 00                	mov    (%eax),%eax
  103f76:	83 f8 01             	cmp    $0x1,%eax
  103f79:	75 36                	jne    103fb1 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103f7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103f81:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103f84:	77 2b                	ja     103fb1 <page_init+0x14a>
  103f86:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103f89:	72 05                	jb     103f90 <page_init+0x129>
  103f8b:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103f8e:	73 21                	jae    103fb1 <page_init+0x14a>
  103f90:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103f94:	77 1b                	ja     103fb1 <page_init+0x14a>
  103f96:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103f9a:	72 09                	jb     103fa5 <page_init+0x13e>
  103f9c:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103fa3:	77 0c                	ja     103fb1 <page_init+0x14a>
                maxpa = end;
  103fa5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103fa8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103fab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103fae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103fb1:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103fb5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103fb8:	8b 00                	mov    (%eax),%eax
  103fba:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103fbd:	0f 8f dd fe ff ff    	jg     103ea0 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103fc3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103fc7:	72 1d                	jb     103fe6 <page_init+0x17f>
  103fc9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103fcd:	77 09                	ja     103fd8 <page_init+0x171>
  103fcf:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103fd6:	76 0e                	jbe    103fe6 <page_init+0x17f>
        maxpa = KMEMSIZE;
  103fd8:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103fdf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103fe6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103fe9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103fec:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103ff0:	c1 ea 0c             	shr    $0xc,%edx
  103ff3:	a3 80 ae 11 00       	mov    %eax,0x11ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103ff8:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103fff:	b8 28 af 11 00       	mov    $0x11af28,%eax
  104004:	8d 50 ff             	lea    -0x1(%eax),%edx
  104007:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10400a:	01 d0                	add    %edx,%eax
  10400c:	89 45 a8             	mov    %eax,-0x58(%ebp)
  10400f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104012:	ba 00 00 00 00       	mov    $0x0,%edx
  104017:	f7 75 ac             	divl   -0x54(%ebp)
  10401a:	89 d0                	mov    %edx,%eax
  10401c:	8b 55 a8             	mov    -0x58(%ebp),%edx
  10401f:	29 c2                	sub    %eax,%edx
  104021:	89 d0                	mov    %edx,%eax
  104023:	a3 24 af 11 00       	mov    %eax,0x11af24

    for (i = 0; i < npage; i ++) {
  104028:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10402f:	eb 2f                	jmp    104060 <page_init+0x1f9>
        SetPageReserved(pages + i);
  104031:	8b 0d 24 af 11 00    	mov    0x11af24,%ecx
  104037:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10403a:	89 d0                	mov    %edx,%eax
  10403c:	c1 e0 02             	shl    $0x2,%eax
  10403f:	01 d0                	add    %edx,%eax
  104041:	c1 e0 02             	shl    $0x2,%eax
  104044:	01 c8                	add    %ecx,%eax
  104046:	83 c0 04             	add    $0x4,%eax
  104049:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  104050:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104053:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104056:	8b 55 90             	mov    -0x70(%ebp),%edx
  104059:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  10405c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104060:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104063:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104068:	39 c2                	cmp    %eax,%edx
  10406a:	72 c5                	jb     104031 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  10406c:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  104072:	89 d0                	mov    %edx,%eax
  104074:	c1 e0 02             	shl    $0x2,%eax
  104077:	01 d0                	add    %edx,%eax
  104079:	c1 e0 02             	shl    $0x2,%eax
  10407c:	89 c2                	mov    %eax,%edx
  10407e:	a1 24 af 11 00       	mov    0x11af24,%eax
  104083:	01 d0                	add    %edx,%eax
  104085:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  104088:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  10408f:	77 23                	ja     1040b4 <page_init+0x24d>
  104091:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104094:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104098:	c7 44 24 08 d8 69 10 	movl   $0x1069d8,0x8(%esp)
  10409f:	00 
  1040a0:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  1040a7:	00 
  1040a8:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  1040af:	e8 1e cc ff ff       	call   100cd2 <__panic>
  1040b4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1040b7:	05 00 00 00 40       	add    $0x40000000,%eax
  1040bc:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  1040bf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1040c6:	e9 74 01 00 00       	jmp    10423f <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  1040cb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1040ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040d1:	89 d0                	mov    %edx,%eax
  1040d3:	c1 e0 02             	shl    $0x2,%eax
  1040d6:	01 d0                	add    %edx,%eax
  1040d8:	c1 e0 02             	shl    $0x2,%eax
  1040db:	01 c8                	add    %ecx,%eax
  1040dd:	8b 50 08             	mov    0x8(%eax),%edx
  1040e0:	8b 40 04             	mov    0x4(%eax),%eax
  1040e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1040e6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1040e9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1040ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040ef:	89 d0                	mov    %edx,%eax
  1040f1:	c1 e0 02             	shl    $0x2,%eax
  1040f4:	01 d0                	add    %edx,%eax
  1040f6:	c1 e0 02             	shl    $0x2,%eax
  1040f9:	01 c8                	add    %ecx,%eax
  1040fb:	8b 48 0c             	mov    0xc(%eax),%ecx
  1040fe:	8b 58 10             	mov    0x10(%eax),%ebx
  104101:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104104:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104107:	01 c8                	add    %ecx,%eax
  104109:	11 da                	adc    %ebx,%edx
  10410b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10410e:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  104111:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104114:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104117:	89 d0                	mov    %edx,%eax
  104119:	c1 e0 02             	shl    $0x2,%eax
  10411c:	01 d0                	add    %edx,%eax
  10411e:	c1 e0 02             	shl    $0x2,%eax
  104121:	01 c8                	add    %ecx,%eax
  104123:	83 c0 14             	add    $0x14,%eax
  104126:	8b 00                	mov    (%eax),%eax
  104128:	83 f8 01             	cmp    $0x1,%eax
  10412b:	0f 85 0a 01 00 00    	jne    10423b <page_init+0x3d4>
            if (begin < freemem) {
  104131:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104134:	ba 00 00 00 00       	mov    $0x0,%edx
  104139:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10413c:	72 17                	jb     104155 <page_init+0x2ee>
  10413e:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104141:	77 05                	ja     104148 <page_init+0x2e1>
  104143:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  104146:	76 0d                	jbe    104155 <page_init+0x2ee>
                begin = freemem;
  104148:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10414b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10414e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  104155:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104159:	72 1d                	jb     104178 <page_init+0x311>
  10415b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10415f:	77 09                	ja     10416a <page_init+0x303>
  104161:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  104168:	76 0e                	jbe    104178 <page_init+0x311>
                end = KMEMSIZE;
  10416a:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  104171:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  104178:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10417b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10417e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104181:	0f 87 b4 00 00 00    	ja     10423b <page_init+0x3d4>
  104187:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10418a:	72 09                	jb     104195 <page_init+0x32e>
  10418c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10418f:	0f 83 a6 00 00 00    	jae    10423b <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  104195:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  10419c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10419f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1041a2:	01 d0                	add    %edx,%eax
  1041a4:	83 e8 01             	sub    $0x1,%eax
  1041a7:	89 45 98             	mov    %eax,-0x68(%ebp)
  1041aa:	8b 45 98             	mov    -0x68(%ebp),%eax
  1041ad:	ba 00 00 00 00       	mov    $0x0,%edx
  1041b2:	f7 75 9c             	divl   -0x64(%ebp)
  1041b5:	89 d0                	mov    %edx,%eax
  1041b7:	8b 55 98             	mov    -0x68(%ebp),%edx
  1041ba:	29 c2                	sub    %eax,%edx
  1041bc:	89 d0                	mov    %edx,%eax
  1041be:	ba 00 00 00 00       	mov    $0x0,%edx
  1041c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1041c6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1041c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1041cc:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1041cf:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1041d2:	ba 00 00 00 00       	mov    $0x0,%edx
  1041d7:	89 c7                	mov    %eax,%edi
  1041d9:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  1041df:	89 7d 80             	mov    %edi,-0x80(%ebp)
  1041e2:	89 d0                	mov    %edx,%eax
  1041e4:	83 e0 00             	and    $0x0,%eax
  1041e7:	89 45 84             	mov    %eax,-0x7c(%ebp)
  1041ea:	8b 45 80             	mov    -0x80(%ebp),%eax
  1041ed:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1041f0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1041f3:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  1041f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1041f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1041fc:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1041ff:	77 3a                	ja     10423b <page_init+0x3d4>
  104201:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104204:	72 05                	jb     10420b <page_init+0x3a4>
  104206:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104209:	73 30                	jae    10423b <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  10420b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  10420e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  104211:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104214:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104217:	29 c8                	sub    %ecx,%eax
  104219:	19 da                	sbb    %ebx,%edx
  10421b:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10421f:	c1 ea 0c             	shr    $0xc,%edx
  104222:	89 c3                	mov    %eax,%ebx
  104224:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104227:	89 04 24             	mov    %eax,(%esp)
  10422a:	e8 b2 f8 ff ff       	call   103ae1 <pa2page>
  10422f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104233:	89 04 24             	mov    %eax,(%esp)
  104236:	e8 78 fb ff ff       	call   103db3 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  10423b:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  10423f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104242:	8b 00                	mov    (%eax),%eax
  104244:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104247:	0f 8f 7e fe ff ff    	jg     1040cb <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  10424d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104253:	5b                   	pop    %ebx
  104254:	5e                   	pop    %esi
  104255:	5f                   	pop    %edi
  104256:	5d                   	pop    %ebp
  104257:	c3                   	ret    

00104258 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  104258:	55                   	push   %ebp
  104259:	89 e5                	mov    %esp,%ebp
  10425b:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10425e:	8b 45 14             	mov    0x14(%ebp),%eax
  104261:	8b 55 0c             	mov    0xc(%ebp),%edx
  104264:	31 d0                	xor    %edx,%eax
  104266:	25 ff 0f 00 00       	and    $0xfff,%eax
  10426b:	85 c0                	test   %eax,%eax
  10426d:	74 24                	je     104293 <boot_map_segment+0x3b>
  10426f:	c7 44 24 0c 0a 6a 10 	movl   $0x106a0a,0xc(%esp)
  104276:	00 
  104277:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  10427e:	00 
  10427f:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  104286:	00 
  104287:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  10428e:	e8 3f ca ff ff       	call   100cd2 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  104293:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  10429a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10429d:	25 ff 0f 00 00       	and    $0xfff,%eax
  1042a2:	89 c2                	mov    %eax,%edx
  1042a4:	8b 45 10             	mov    0x10(%ebp),%eax
  1042a7:	01 c2                	add    %eax,%edx
  1042a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1042ac:	01 d0                	add    %edx,%eax
  1042ae:	83 e8 01             	sub    $0x1,%eax
  1042b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1042b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1042b7:	ba 00 00 00 00       	mov    $0x0,%edx
  1042bc:	f7 75 f0             	divl   -0x10(%ebp)
  1042bf:	89 d0                	mov    %edx,%eax
  1042c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1042c4:	29 c2                	sub    %eax,%edx
  1042c6:	89 d0                	mov    %edx,%eax
  1042c8:	c1 e8 0c             	shr    $0xc,%eax
  1042cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1042ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1042d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1042d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1042dc:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1042df:	8b 45 14             	mov    0x14(%ebp),%eax
  1042e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1042e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1042e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1042ed:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1042f0:	eb 6b                	jmp    10435d <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1042f2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1042f9:	00 
  1042fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  104301:	8b 45 08             	mov    0x8(%ebp),%eax
  104304:	89 04 24             	mov    %eax,(%esp)
  104307:	e8 82 01 00 00       	call   10448e <get_pte>
  10430c:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  10430f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104313:	75 24                	jne    104339 <boot_map_segment+0xe1>
  104315:	c7 44 24 0c 36 6a 10 	movl   $0x106a36,0xc(%esp)
  10431c:	00 
  10431d:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104324:	00 
  104325:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  10432c:	00 
  10432d:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104334:	e8 99 c9 ff ff       	call   100cd2 <__panic>
        *ptep = pa | PTE_P | perm;
  104339:	8b 45 18             	mov    0x18(%ebp),%eax
  10433c:	8b 55 14             	mov    0x14(%ebp),%edx
  10433f:	09 d0                	or     %edx,%eax
  104341:	83 c8 01             	or     $0x1,%eax
  104344:	89 c2                	mov    %eax,%edx
  104346:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104349:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10434b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10434f:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  104356:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  10435d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104361:	75 8f                	jne    1042f2 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  104363:	c9                   	leave  
  104364:	c3                   	ret    

00104365 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  104365:	55                   	push   %ebp
  104366:	89 e5                	mov    %esp,%ebp
  104368:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  10436b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104372:	e8 5b fa ff ff       	call   103dd2 <alloc_pages>
  104377:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10437a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10437e:	75 1c                	jne    10439c <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  104380:	c7 44 24 08 43 6a 10 	movl   $0x106a43,0x8(%esp)
  104387:	00 
  104388:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  10438f:	00 
  104390:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104397:	e8 36 c9 ff ff       	call   100cd2 <__panic>
    }
    return page2kva(p);
  10439c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10439f:	89 04 24             	mov    %eax,(%esp)
  1043a2:	e8 89 f7 ff ff       	call   103b30 <page2kva>
}
  1043a7:	c9                   	leave  
  1043a8:	c3                   	ret    

001043a9 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1043a9:	55                   	push   %ebp
  1043aa:	89 e5                	mov    %esp,%ebp
  1043ac:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  1043af:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1043b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1043b7:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1043be:	77 23                	ja     1043e3 <pmm_init+0x3a>
  1043c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1043c7:	c7 44 24 08 d8 69 10 	movl   $0x1069d8,0x8(%esp)
  1043ce:	00 
  1043cf:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1043d6:	00 
  1043d7:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  1043de:	e8 ef c8 ff ff       	call   100cd2 <__panic>
  1043e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043e6:	05 00 00 00 40       	add    $0x40000000,%eax
  1043eb:	a3 20 af 11 00       	mov    %eax,0x11af20
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1043f0:	e8 8b f9 ff ff       	call   103d80 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1043f5:	e8 6d fa ff ff       	call   103e67 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1043fa:	e8 4c 02 00 00       	call   10464b <check_alloc_page>

    check_pgdir();
  1043ff:	e8 65 02 00 00       	call   104669 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104404:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104409:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  10440f:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104414:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104417:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10441e:	77 23                	ja     104443 <pmm_init+0x9a>
  104420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104423:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104427:	c7 44 24 08 d8 69 10 	movl   $0x1069d8,0x8(%esp)
  10442e:	00 
  10442f:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  104436:	00 
  104437:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  10443e:	e8 8f c8 ff ff       	call   100cd2 <__panic>
  104443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104446:	05 00 00 00 40       	add    $0x40000000,%eax
  10444b:	83 c8 03             	or     $0x3,%eax
  10444e:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  104450:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104455:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  10445c:	00 
  10445d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104464:	00 
  104465:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  10446c:	38 
  10446d:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  104474:	c0 
  104475:	89 04 24             	mov    %eax,(%esp)
  104478:	e8 db fd ff ff       	call   104258 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10447d:	e8 0f f8 ff ff       	call   103c91 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  104482:	e8 7d 08 00 00       	call   104d04 <check_boot_pgdir>

    print_pgdir();
  104487:	e8 05 0d 00 00       	call   105191 <print_pgdir>

}
  10448c:	c9                   	leave  
  10448d:	c3                   	ret    

0010448e <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  10448e:	55                   	push   %ebp
  10448f:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  104491:	5d                   	pop    %ebp
  104492:	c3                   	ret    

00104493 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  104493:	55                   	push   %ebp
  104494:	89 e5                	mov    %esp,%ebp
  104496:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104499:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1044a0:	00 
  1044a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1044ab:	89 04 24             	mov    %eax,(%esp)
  1044ae:	e8 db ff ff ff       	call   10448e <get_pte>
  1044b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1044b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1044ba:	74 08                	je     1044c4 <get_page+0x31>
        *ptep_store = ptep;
  1044bc:	8b 45 10             	mov    0x10(%ebp),%eax
  1044bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1044c2:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1044c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044c8:	74 1b                	je     1044e5 <get_page+0x52>
  1044ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044cd:	8b 00                	mov    (%eax),%eax
  1044cf:	83 e0 01             	and    $0x1,%eax
  1044d2:	85 c0                	test   %eax,%eax
  1044d4:	74 0f                	je     1044e5 <get_page+0x52>
        return pte2page(*ptep);
  1044d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044d9:	8b 00                	mov    (%eax),%eax
  1044db:	89 04 24             	mov    %eax,(%esp)
  1044de:	e8 a1 f6 ff ff       	call   103b84 <pte2page>
  1044e3:	eb 05                	jmp    1044ea <get_page+0x57>
    }
    return NULL;
  1044e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1044ea:	c9                   	leave  
  1044eb:	c3                   	ret    

001044ec <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1044ec:	55                   	push   %ebp
  1044ed:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  1044ef:	5d                   	pop    %ebp
  1044f0:	c3                   	ret    

001044f1 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1044f1:	55                   	push   %ebp
  1044f2:	89 e5                	mov    %esp,%ebp
  1044f4:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1044f7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1044fe:	00 
  1044ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  104502:	89 44 24 04          	mov    %eax,0x4(%esp)
  104506:	8b 45 08             	mov    0x8(%ebp),%eax
  104509:	89 04 24             	mov    %eax,(%esp)
  10450c:	e8 7d ff ff ff       	call   10448e <get_pte>
  104511:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  104514:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  104518:	74 19                	je     104533 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  10451a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10451d:	89 44 24 08          	mov    %eax,0x8(%esp)
  104521:	8b 45 0c             	mov    0xc(%ebp),%eax
  104524:	89 44 24 04          	mov    %eax,0x4(%esp)
  104528:	8b 45 08             	mov    0x8(%ebp),%eax
  10452b:	89 04 24             	mov    %eax,(%esp)
  10452e:	e8 b9 ff ff ff       	call   1044ec <page_remove_pte>
    }
}
  104533:	c9                   	leave  
  104534:	c3                   	ret    

00104535 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  104535:	55                   	push   %ebp
  104536:	89 e5                	mov    %esp,%ebp
  104538:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  10453b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104542:	00 
  104543:	8b 45 10             	mov    0x10(%ebp),%eax
  104546:	89 44 24 04          	mov    %eax,0x4(%esp)
  10454a:	8b 45 08             	mov    0x8(%ebp),%eax
  10454d:	89 04 24             	mov    %eax,(%esp)
  104550:	e8 39 ff ff ff       	call   10448e <get_pte>
  104555:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  104558:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10455c:	75 0a                	jne    104568 <page_insert+0x33>
        return -E_NO_MEM;
  10455e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  104563:	e9 84 00 00 00       	jmp    1045ec <page_insert+0xb7>
    }
    page_ref_inc(page);
  104568:	8b 45 0c             	mov    0xc(%ebp),%eax
  10456b:	89 04 24             	mov    %eax,(%esp)
  10456e:	e8 71 f6 ff ff       	call   103be4 <page_ref_inc>
    if (*ptep & PTE_P) {
  104573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104576:	8b 00                	mov    (%eax),%eax
  104578:	83 e0 01             	and    $0x1,%eax
  10457b:	85 c0                	test   %eax,%eax
  10457d:	74 3e                	je     1045bd <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  10457f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104582:	8b 00                	mov    (%eax),%eax
  104584:	89 04 24             	mov    %eax,(%esp)
  104587:	e8 f8 f5 ff ff       	call   103b84 <pte2page>
  10458c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  10458f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104592:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104595:	75 0d                	jne    1045a4 <page_insert+0x6f>
            page_ref_dec(page);
  104597:	8b 45 0c             	mov    0xc(%ebp),%eax
  10459a:	89 04 24             	mov    %eax,(%esp)
  10459d:	e8 59 f6 ff ff       	call   103bfb <page_ref_dec>
  1045a2:	eb 19                	jmp    1045bd <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1045a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1045ab:	8b 45 10             	mov    0x10(%ebp),%eax
  1045ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1045b5:	89 04 24             	mov    %eax,(%esp)
  1045b8:	e8 2f ff ff ff       	call   1044ec <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1045bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045c0:	89 04 24             	mov    %eax,(%esp)
  1045c3:	e8 03 f5 ff ff       	call   103acb <page2pa>
  1045c8:	0b 45 14             	or     0x14(%ebp),%eax
  1045cb:	83 c8 01             	or     $0x1,%eax
  1045ce:	89 c2                	mov    %eax,%edx
  1045d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045d3:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1045d5:	8b 45 10             	mov    0x10(%ebp),%eax
  1045d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1045df:	89 04 24             	mov    %eax,(%esp)
  1045e2:	e8 07 00 00 00       	call   1045ee <tlb_invalidate>
    return 0;
  1045e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1045ec:	c9                   	leave  
  1045ed:	c3                   	ret    

001045ee <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1045ee:	55                   	push   %ebp
  1045ef:	89 e5                	mov    %esp,%ebp
  1045f1:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1045f4:	0f 20 d8             	mov    %cr3,%eax
  1045f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1045fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  1045fd:	89 c2                	mov    %eax,%edx
  1045ff:	8b 45 08             	mov    0x8(%ebp),%eax
  104602:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104605:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10460c:	77 23                	ja     104631 <tlb_invalidate+0x43>
  10460e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104611:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104615:	c7 44 24 08 d8 69 10 	movl   $0x1069d8,0x8(%esp)
  10461c:	00 
  10461d:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
  104624:	00 
  104625:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  10462c:	e8 a1 c6 ff ff       	call   100cd2 <__panic>
  104631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104634:	05 00 00 00 40       	add    $0x40000000,%eax
  104639:	39 c2                	cmp    %eax,%edx
  10463b:	75 0c                	jne    104649 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  10463d:	8b 45 0c             	mov    0xc(%ebp),%eax
  104640:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  104643:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104646:	0f 01 38             	invlpg (%eax)
    }
}
  104649:	c9                   	leave  
  10464a:	c3                   	ret    

0010464b <check_alloc_page>:

static void
check_alloc_page(void) {
  10464b:	55                   	push   %ebp
  10464c:	89 e5                	mov    %esp,%ebp
  10464e:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  104651:	a1 1c af 11 00       	mov    0x11af1c,%eax
  104656:	8b 40 18             	mov    0x18(%eax),%eax
  104659:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  10465b:	c7 04 24 5c 6a 10 00 	movl   $0x106a5c,(%esp)
  104662:	e8 e1 bc ff ff       	call   100348 <cprintf>
}
  104667:	c9                   	leave  
  104668:	c3                   	ret    

00104669 <check_pgdir>:

static void
check_pgdir(void) {
  104669:	55                   	push   %ebp
  10466a:	89 e5                	mov    %esp,%ebp
  10466c:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  10466f:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104674:	3d 00 80 03 00       	cmp    $0x38000,%eax
  104679:	76 24                	jbe    10469f <check_pgdir+0x36>
  10467b:	c7 44 24 0c 7b 6a 10 	movl   $0x106a7b,0xc(%esp)
  104682:	00 
  104683:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  10468a:	00 
  10468b:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
  104692:	00 
  104693:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  10469a:	e8 33 c6 ff ff       	call   100cd2 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10469f:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1046a4:	85 c0                	test   %eax,%eax
  1046a6:	74 0e                	je     1046b6 <check_pgdir+0x4d>
  1046a8:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1046ad:	25 ff 0f 00 00       	and    $0xfff,%eax
  1046b2:	85 c0                	test   %eax,%eax
  1046b4:	74 24                	je     1046da <check_pgdir+0x71>
  1046b6:	c7 44 24 0c 98 6a 10 	movl   $0x106a98,0xc(%esp)
  1046bd:	00 
  1046be:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  1046c5:	00 
  1046c6:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
  1046cd:	00 
  1046ce:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  1046d5:	e8 f8 c5 ff ff       	call   100cd2 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1046da:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1046df:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1046e6:	00 
  1046e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1046ee:	00 
  1046ef:	89 04 24             	mov    %eax,(%esp)
  1046f2:	e8 9c fd ff ff       	call   104493 <get_page>
  1046f7:	85 c0                	test   %eax,%eax
  1046f9:	74 24                	je     10471f <check_pgdir+0xb6>
  1046fb:	c7 44 24 0c d0 6a 10 	movl   $0x106ad0,0xc(%esp)
  104702:	00 
  104703:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  10470a:	00 
  10470b:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
  104712:	00 
  104713:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  10471a:	e8 b3 c5 ff ff       	call   100cd2 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  10471f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104726:	e8 a7 f6 ff ff       	call   103dd2 <alloc_pages>
  10472b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  10472e:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104733:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10473a:	00 
  10473b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104742:	00 
  104743:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104746:	89 54 24 04          	mov    %edx,0x4(%esp)
  10474a:	89 04 24             	mov    %eax,(%esp)
  10474d:	e8 e3 fd ff ff       	call   104535 <page_insert>
  104752:	85 c0                	test   %eax,%eax
  104754:	74 24                	je     10477a <check_pgdir+0x111>
  104756:	c7 44 24 0c f8 6a 10 	movl   $0x106af8,0xc(%esp)
  10475d:	00 
  10475e:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104765:	00 
  104766:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
  10476d:	00 
  10476e:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104775:	e8 58 c5 ff ff       	call   100cd2 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  10477a:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10477f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104786:	00 
  104787:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10478e:	00 
  10478f:	89 04 24             	mov    %eax,(%esp)
  104792:	e8 f7 fc ff ff       	call   10448e <get_pte>
  104797:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10479a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10479e:	75 24                	jne    1047c4 <check_pgdir+0x15b>
  1047a0:	c7 44 24 0c 24 6b 10 	movl   $0x106b24,0xc(%esp)
  1047a7:	00 
  1047a8:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  1047af:	00 
  1047b0:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
  1047b7:	00 
  1047b8:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  1047bf:	e8 0e c5 ff ff       	call   100cd2 <__panic>
    assert(pte2page(*ptep) == p1);
  1047c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047c7:	8b 00                	mov    (%eax),%eax
  1047c9:	89 04 24             	mov    %eax,(%esp)
  1047cc:	e8 b3 f3 ff ff       	call   103b84 <pte2page>
  1047d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1047d4:	74 24                	je     1047fa <check_pgdir+0x191>
  1047d6:	c7 44 24 0c 51 6b 10 	movl   $0x106b51,0xc(%esp)
  1047dd:	00 
  1047de:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  1047e5:	00 
  1047e6:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
  1047ed:	00 
  1047ee:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  1047f5:	e8 d8 c4 ff ff       	call   100cd2 <__panic>
    assert(page_ref(p1) == 1);
  1047fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047fd:	89 04 24             	mov    %eax,(%esp)
  104800:	e8 d5 f3 ff ff       	call   103bda <page_ref>
  104805:	83 f8 01             	cmp    $0x1,%eax
  104808:	74 24                	je     10482e <check_pgdir+0x1c5>
  10480a:	c7 44 24 0c 67 6b 10 	movl   $0x106b67,0xc(%esp)
  104811:	00 
  104812:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104819:	00 
  10481a:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
  104821:	00 
  104822:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104829:	e8 a4 c4 ff ff       	call   100cd2 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  10482e:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104833:	8b 00                	mov    (%eax),%eax
  104835:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10483a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10483d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104840:	c1 e8 0c             	shr    $0xc,%eax
  104843:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104846:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  10484b:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10484e:	72 23                	jb     104873 <check_pgdir+0x20a>
  104850:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104853:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104857:	c7 44 24 08 34 69 10 	movl   $0x106934,0x8(%esp)
  10485e:	00 
  10485f:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
  104866:	00 
  104867:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  10486e:	e8 5f c4 ff ff       	call   100cd2 <__panic>
  104873:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104876:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10487b:	83 c0 04             	add    $0x4,%eax
  10487e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104881:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104886:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10488d:	00 
  10488e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104895:	00 
  104896:	89 04 24             	mov    %eax,(%esp)
  104899:	e8 f0 fb ff ff       	call   10448e <get_pte>
  10489e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1048a1:	74 24                	je     1048c7 <check_pgdir+0x25e>
  1048a3:	c7 44 24 0c 7c 6b 10 	movl   $0x106b7c,0xc(%esp)
  1048aa:	00 
  1048ab:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  1048b2:	00 
  1048b3:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
  1048ba:	00 
  1048bb:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  1048c2:	e8 0b c4 ff ff       	call   100cd2 <__panic>

    p2 = alloc_page();
  1048c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1048ce:	e8 ff f4 ff ff       	call   103dd2 <alloc_pages>
  1048d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  1048d6:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1048db:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  1048e2:	00 
  1048e3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1048ea:	00 
  1048eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1048ee:	89 54 24 04          	mov    %edx,0x4(%esp)
  1048f2:	89 04 24             	mov    %eax,(%esp)
  1048f5:	e8 3b fc ff ff       	call   104535 <page_insert>
  1048fa:	85 c0                	test   %eax,%eax
  1048fc:	74 24                	je     104922 <check_pgdir+0x2b9>
  1048fe:	c7 44 24 0c a4 6b 10 	movl   $0x106ba4,0xc(%esp)
  104905:	00 
  104906:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  10490d:	00 
  10490e:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
  104915:	00 
  104916:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  10491d:	e8 b0 c3 ff ff       	call   100cd2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104922:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104927:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10492e:	00 
  10492f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104936:	00 
  104937:	89 04 24             	mov    %eax,(%esp)
  10493a:	e8 4f fb ff ff       	call   10448e <get_pte>
  10493f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104942:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104946:	75 24                	jne    10496c <check_pgdir+0x303>
  104948:	c7 44 24 0c dc 6b 10 	movl   $0x106bdc,0xc(%esp)
  10494f:	00 
  104950:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104957:	00 
  104958:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
  10495f:	00 
  104960:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104967:	e8 66 c3 ff ff       	call   100cd2 <__panic>
    assert(*ptep & PTE_U);
  10496c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10496f:	8b 00                	mov    (%eax),%eax
  104971:	83 e0 04             	and    $0x4,%eax
  104974:	85 c0                	test   %eax,%eax
  104976:	75 24                	jne    10499c <check_pgdir+0x333>
  104978:	c7 44 24 0c 0c 6c 10 	movl   $0x106c0c,0xc(%esp)
  10497f:	00 
  104980:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104987:	00 
  104988:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
  10498f:	00 
  104990:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104997:	e8 36 c3 ff ff       	call   100cd2 <__panic>
    assert(*ptep & PTE_W);
  10499c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10499f:	8b 00                	mov    (%eax),%eax
  1049a1:	83 e0 02             	and    $0x2,%eax
  1049a4:	85 c0                	test   %eax,%eax
  1049a6:	75 24                	jne    1049cc <check_pgdir+0x363>
  1049a8:	c7 44 24 0c 1a 6c 10 	movl   $0x106c1a,0xc(%esp)
  1049af:	00 
  1049b0:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  1049b7:	00 
  1049b8:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  1049bf:	00 
  1049c0:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  1049c7:	e8 06 c3 ff ff       	call   100cd2 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  1049cc:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1049d1:	8b 00                	mov    (%eax),%eax
  1049d3:	83 e0 04             	and    $0x4,%eax
  1049d6:	85 c0                	test   %eax,%eax
  1049d8:	75 24                	jne    1049fe <check_pgdir+0x395>
  1049da:	c7 44 24 0c 28 6c 10 	movl   $0x106c28,0xc(%esp)
  1049e1:	00 
  1049e2:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  1049e9:	00 
  1049ea:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  1049f1:	00 
  1049f2:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  1049f9:	e8 d4 c2 ff ff       	call   100cd2 <__panic>
    assert(page_ref(p2) == 1);
  1049fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a01:	89 04 24             	mov    %eax,(%esp)
  104a04:	e8 d1 f1 ff ff       	call   103bda <page_ref>
  104a09:	83 f8 01             	cmp    $0x1,%eax
  104a0c:	74 24                	je     104a32 <check_pgdir+0x3c9>
  104a0e:	c7 44 24 0c 3e 6c 10 	movl   $0x106c3e,0xc(%esp)
  104a15:	00 
  104a16:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104a1d:	00 
  104a1e:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  104a25:	00 
  104a26:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104a2d:	e8 a0 c2 ff ff       	call   100cd2 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104a32:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104a37:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104a3e:	00 
  104a3f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104a46:	00 
  104a47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104a4a:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a4e:	89 04 24             	mov    %eax,(%esp)
  104a51:	e8 df fa ff ff       	call   104535 <page_insert>
  104a56:	85 c0                	test   %eax,%eax
  104a58:	74 24                	je     104a7e <check_pgdir+0x415>
  104a5a:	c7 44 24 0c 50 6c 10 	movl   $0x106c50,0xc(%esp)
  104a61:	00 
  104a62:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104a69:	00 
  104a6a:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
  104a71:	00 
  104a72:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104a79:	e8 54 c2 ff ff       	call   100cd2 <__panic>
    assert(page_ref(p1) == 2);
  104a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a81:	89 04 24             	mov    %eax,(%esp)
  104a84:	e8 51 f1 ff ff       	call   103bda <page_ref>
  104a89:	83 f8 02             	cmp    $0x2,%eax
  104a8c:	74 24                	je     104ab2 <check_pgdir+0x449>
  104a8e:	c7 44 24 0c 7c 6c 10 	movl   $0x106c7c,0xc(%esp)
  104a95:	00 
  104a96:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104a9d:	00 
  104a9e:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  104aa5:	00 
  104aa6:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104aad:	e8 20 c2 ff ff       	call   100cd2 <__panic>
    assert(page_ref(p2) == 0);
  104ab2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ab5:	89 04 24             	mov    %eax,(%esp)
  104ab8:	e8 1d f1 ff ff       	call   103bda <page_ref>
  104abd:	85 c0                	test   %eax,%eax
  104abf:	74 24                	je     104ae5 <check_pgdir+0x47c>
  104ac1:	c7 44 24 0c 8e 6c 10 	movl   $0x106c8e,0xc(%esp)
  104ac8:	00 
  104ac9:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104ad0:	00 
  104ad1:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  104ad8:	00 
  104ad9:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104ae0:	e8 ed c1 ff ff       	call   100cd2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104ae5:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104aea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104af1:	00 
  104af2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104af9:	00 
  104afa:	89 04 24             	mov    %eax,(%esp)
  104afd:	e8 8c f9 ff ff       	call   10448e <get_pte>
  104b02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104b05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104b09:	75 24                	jne    104b2f <check_pgdir+0x4c6>
  104b0b:	c7 44 24 0c dc 6b 10 	movl   $0x106bdc,0xc(%esp)
  104b12:	00 
  104b13:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104b1a:	00 
  104b1b:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  104b22:	00 
  104b23:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104b2a:	e8 a3 c1 ff ff       	call   100cd2 <__panic>
    assert(pte2page(*ptep) == p1);
  104b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b32:	8b 00                	mov    (%eax),%eax
  104b34:	89 04 24             	mov    %eax,(%esp)
  104b37:	e8 48 f0 ff ff       	call   103b84 <pte2page>
  104b3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104b3f:	74 24                	je     104b65 <check_pgdir+0x4fc>
  104b41:	c7 44 24 0c 51 6b 10 	movl   $0x106b51,0xc(%esp)
  104b48:	00 
  104b49:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104b50:	00 
  104b51:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  104b58:	00 
  104b59:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104b60:	e8 6d c1 ff ff       	call   100cd2 <__panic>
    assert((*ptep & PTE_U) == 0);
  104b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b68:	8b 00                	mov    (%eax),%eax
  104b6a:	83 e0 04             	and    $0x4,%eax
  104b6d:	85 c0                	test   %eax,%eax
  104b6f:	74 24                	je     104b95 <check_pgdir+0x52c>
  104b71:	c7 44 24 0c a0 6c 10 	movl   $0x106ca0,0xc(%esp)
  104b78:	00 
  104b79:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104b80:	00 
  104b81:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  104b88:	00 
  104b89:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104b90:	e8 3d c1 ff ff       	call   100cd2 <__panic>

    page_remove(boot_pgdir, 0x0);
  104b95:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104b9a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104ba1:	00 
  104ba2:	89 04 24             	mov    %eax,(%esp)
  104ba5:	e8 47 f9 ff ff       	call   1044f1 <page_remove>
    assert(page_ref(p1) == 1);
  104baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bad:	89 04 24             	mov    %eax,(%esp)
  104bb0:	e8 25 f0 ff ff       	call   103bda <page_ref>
  104bb5:	83 f8 01             	cmp    $0x1,%eax
  104bb8:	74 24                	je     104bde <check_pgdir+0x575>
  104bba:	c7 44 24 0c 67 6b 10 	movl   $0x106b67,0xc(%esp)
  104bc1:	00 
  104bc2:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104bc9:	00 
  104bca:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  104bd1:	00 
  104bd2:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104bd9:	e8 f4 c0 ff ff       	call   100cd2 <__panic>
    assert(page_ref(p2) == 0);
  104bde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104be1:	89 04 24             	mov    %eax,(%esp)
  104be4:	e8 f1 ef ff ff       	call   103bda <page_ref>
  104be9:	85 c0                	test   %eax,%eax
  104beb:	74 24                	je     104c11 <check_pgdir+0x5a8>
  104bed:	c7 44 24 0c 8e 6c 10 	movl   $0x106c8e,0xc(%esp)
  104bf4:	00 
  104bf5:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104bfc:	00 
  104bfd:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  104c04:	00 
  104c05:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104c0c:	e8 c1 c0 ff ff       	call   100cd2 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104c11:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104c16:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c1d:	00 
  104c1e:	89 04 24             	mov    %eax,(%esp)
  104c21:	e8 cb f8 ff ff       	call   1044f1 <page_remove>
    assert(page_ref(p1) == 0);
  104c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c29:	89 04 24             	mov    %eax,(%esp)
  104c2c:	e8 a9 ef ff ff       	call   103bda <page_ref>
  104c31:	85 c0                	test   %eax,%eax
  104c33:	74 24                	je     104c59 <check_pgdir+0x5f0>
  104c35:	c7 44 24 0c b5 6c 10 	movl   $0x106cb5,0xc(%esp)
  104c3c:	00 
  104c3d:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104c44:	00 
  104c45:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  104c4c:	00 
  104c4d:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104c54:	e8 79 c0 ff ff       	call   100cd2 <__panic>
    assert(page_ref(p2) == 0);
  104c59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c5c:	89 04 24             	mov    %eax,(%esp)
  104c5f:	e8 76 ef ff ff       	call   103bda <page_ref>
  104c64:	85 c0                	test   %eax,%eax
  104c66:	74 24                	je     104c8c <check_pgdir+0x623>
  104c68:	c7 44 24 0c 8e 6c 10 	movl   $0x106c8e,0xc(%esp)
  104c6f:	00 
  104c70:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104c77:	00 
  104c78:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  104c7f:	00 
  104c80:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104c87:	e8 46 c0 ff ff       	call   100cd2 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104c8c:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104c91:	8b 00                	mov    (%eax),%eax
  104c93:	89 04 24             	mov    %eax,(%esp)
  104c96:	e8 27 ef ff ff       	call   103bc2 <pde2page>
  104c9b:	89 04 24             	mov    %eax,(%esp)
  104c9e:	e8 37 ef ff ff       	call   103bda <page_ref>
  104ca3:	83 f8 01             	cmp    $0x1,%eax
  104ca6:	74 24                	je     104ccc <check_pgdir+0x663>
  104ca8:	c7 44 24 0c c8 6c 10 	movl   $0x106cc8,0xc(%esp)
  104caf:	00 
  104cb0:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104cb7:	00 
  104cb8:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  104cbf:	00 
  104cc0:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104cc7:	e8 06 c0 ff ff       	call   100cd2 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104ccc:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104cd1:	8b 00                	mov    (%eax),%eax
  104cd3:	89 04 24             	mov    %eax,(%esp)
  104cd6:	e8 e7 ee ff ff       	call   103bc2 <pde2page>
  104cdb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ce2:	00 
  104ce3:	89 04 24             	mov    %eax,(%esp)
  104ce6:	e8 1f f1 ff ff       	call   103e0a <free_pages>
    boot_pgdir[0] = 0;
  104ceb:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104cf0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104cf6:	c7 04 24 ef 6c 10 00 	movl   $0x106cef,(%esp)
  104cfd:	e8 46 b6 ff ff       	call   100348 <cprintf>
}
  104d02:	c9                   	leave  
  104d03:	c3                   	ret    

00104d04 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104d04:	55                   	push   %ebp
  104d05:	89 e5                	mov    %esp,%ebp
  104d07:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104d0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104d11:	e9 ca 00 00 00       	jmp    104de0 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d1f:	c1 e8 0c             	shr    $0xc,%eax
  104d22:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104d25:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104d2a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104d2d:	72 23                	jb     104d52 <check_boot_pgdir+0x4e>
  104d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d32:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104d36:	c7 44 24 08 34 69 10 	movl   $0x106934,0x8(%esp)
  104d3d:	00 
  104d3e:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104d45:	00 
  104d46:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104d4d:	e8 80 bf ff ff       	call   100cd2 <__panic>
  104d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d55:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104d5a:	89 c2                	mov    %eax,%edx
  104d5c:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104d61:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104d68:	00 
  104d69:	89 54 24 04          	mov    %edx,0x4(%esp)
  104d6d:	89 04 24             	mov    %eax,(%esp)
  104d70:	e8 19 f7 ff ff       	call   10448e <get_pte>
  104d75:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104d78:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104d7c:	75 24                	jne    104da2 <check_boot_pgdir+0x9e>
  104d7e:	c7 44 24 0c 0c 6d 10 	movl   $0x106d0c,0xc(%esp)
  104d85:	00 
  104d86:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104d8d:	00 
  104d8e:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104d95:	00 
  104d96:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104d9d:	e8 30 bf ff ff       	call   100cd2 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104da2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104da5:	8b 00                	mov    (%eax),%eax
  104da7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104dac:	89 c2                	mov    %eax,%edx
  104dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104db1:	39 c2                	cmp    %eax,%edx
  104db3:	74 24                	je     104dd9 <check_boot_pgdir+0xd5>
  104db5:	c7 44 24 0c 49 6d 10 	movl   $0x106d49,0xc(%esp)
  104dbc:	00 
  104dbd:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104dc4:	00 
  104dc5:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104dcc:	00 
  104dcd:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104dd4:	e8 f9 be ff ff       	call   100cd2 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104dd9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104de0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104de3:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104de8:	39 c2                	cmp    %eax,%edx
  104dea:	0f 82 26 ff ff ff    	jb     104d16 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104df0:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104df5:	05 ac 0f 00 00       	add    $0xfac,%eax
  104dfa:	8b 00                	mov    (%eax),%eax
  104dfc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104e01:	89 c2                	mov    %eax,%edx
  104e03:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104e08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104e0b:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104e12:	77 23                	ja     104e37 <check_boot_pgdir+0x133>
  104e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104e1b:	c7 44 24 08 d8 69 10 	movl   $0x1069d8,0x8(%esp)
  104e22:	00 
  104e23:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104e2a:	00 
  104e2b:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104e32:	e8 9b be ff ff       	call   100cd2 <__panic>
  104e37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e3a:	05 00 00 00 40       	add    $0x40000000,%eax
  104e3f:	39 c2                	cmp    %eax,%edx
  104e41:	74 24                	je     104e67 <check_boot_pgdir+0x163>
  104e43:	c7 44 24 0c 60 6d 10 	movl   $0x106d60,0xc(%esp)
  104e4a:	00 
  104e4b:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104e52:	00 
  104e53:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104e5a:	00 
  104e5b:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104e62:	e8 6b be ff ff       	call   100cd2 <__panic>

    assert(boot_pgdir[0] == 0);
  104e67:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104e6c:	8b 00                	mov    (%eax),%eax
  104e6e:	85 c0                	test   %eax,%eax
  104e70:	74 24                	je     104e96 <check_boot_pgdir+0x192>
  104e72:	c7 44 24 0c 94 6d 10 	movl   $0x106d94,0xc(%esp)
  104e79:	00 
  104e7a:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104e81:	00 
  104e82:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104e89:	00 
  104e8a:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104e91:	e8 3c be ff ff       	call   100cd2 <__panic>

    struct Page *p;
    p = alloc_page();
  104e96:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e9d:	e8 30 ef ff ff       	call   103dd2 <alloc_pages>
  104ea2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104ea5:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104eaa:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104eb1:	00 
  104eb2:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104eb9:	00 
  104eba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104ebd:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ec1:	89 04 24             	mov    %eax,(%esp)
  104ec4:	e8 6c f6 ff ff       	call   104535 <page_insert>
  104ec9:	85 c0                	test   %eax,%eax
  104ecb:	74 24                	je     104ef1 <check_boot_pgdir+0x1ed>
  104ecd:	c7 44 24 0c a8 6d 10 	movl   $0x106da8,0xc(%esp)
  104ed4:	00 
  104ed5:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104edc:	00 
  104edd:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104ee4:	00 
  104ee5:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104eec:	e8 e1 bd ff ff       	call   100cd2 <__panic>
    assert(page_ref(p) == 1);
  104ef1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ef4:	89 04 24             	mov    %eax,(%esp)
  104ef7:	e8 de ec ff ff       	call   103bda <page_ref>
  104efc:	83 f8 01             	cmp    $0x1,%eax
  104eff:	74 24                	je     104f25 <check_boot_pgdir+0x221>
  104f01:	c7 44 24 0c d6 6d 10 	movl   $0x106dd6,0xc(%esp)
  104f08:	00 
  104f09:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104f10:	00 
  104f11:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104f18:	00 
  104f19:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104f20:	e8 ad bd ff ff       	call   100cd2 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104f25:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104f2a:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104f31:	00 
  104f32:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104f39:	00 
  104f3a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104f3d:	89 54 24 04          	mov    %edx,0x4(%esp)
  104f41:	89 04 24             	mov    %eax,(%esp)
  104f44:	e8 ec f5 ff ff       	call   104535 <page_insert>
  104f49:	85 c0                	test   %eax,%eax
  104f4b:	74 24                	je     104f71 <check_boot_pgdir+0x26d>
  104f4d:	c7 44 24 0c e8 6d 10 	movl   $0x106de8,0xc(%esp)
  104f54:	00 
  104f55:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104f5c:	00 
  104f5d:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104f64:	00 
  104f65:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104f6c:	e8 61 bd ff ff       	call   100cd2 <__panic>
    assert(page_ref(p) == 2);
  104f71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104f74:	89 04 24             	mov    %eax,(%esp)
  104f77:	e8 5e ec ff ff       	call   103bda <page_ref>
  104f7c:	83 f8 02             	cmp    $0x2,%eax
  104f7f:	74 24                	je     104fa5 <check_boot_pgdir+0x2a1>
  104f81:	c7 44 24 0c 1f 6e 10 	movl   $0x106e1f,0xc(%esp)
  104f88:	00 
  104f89:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104f90:	00 
  104f91:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104f98:	00 
  104f99:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104fa0:	e8 2d bd ff ff       	call   100cd2 <__panic>

    const char *str = "ucore: Hello world!!";
  104fa5:	c7 45 dc 30 6e 10 00 	movl   $0x106e30,-0x24(%ebp)
    strcpy((void *)0x100, str);
  104fac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104faf:	89 44 24 04          	mov    %eax,0x4(%esp)
  104fb3:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104fba:	e8 19 0a 00 00       	call   1059d8 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104fbf:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  104fc6:	00 
  104fc7:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104fce:	e8 7e 0a 00 00       	call   105a51 <strcmp>
  104fd3:	85 c0                	test   %eax,%eax
  104fd5:	74 24                	je     104ffb <check_boot_pgdir+0x2f7>
  104fd7:	c7 44 24 0c 48 6e 10 	movl   $0x106e48,0xc(%esp)
  104fde:	00 
  104fdf:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  104fe6:	00 
  104fe7:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104fee:	00 
  104fef:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  104ff6:	e8 d7 bc ff ff       	call   100cd2 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  104ffb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ffe:	89 04 24             	mov    %eax,(%esp)
  105001:	e8 2a eb ff ff       	call   103b30 <page2kva>
  105006:	05 00 01 00 00       	add    $0x100,%eax
  10500b:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  10500e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105015:	e8 66 09 00 00       	call   105980 <strlen>
  10501a:	85 c0                	test   %eax,%eax
  10501c:	74 24                	je     105042 <check_boot_pgdir+0x33e>
  10501e:	c7 44 24 0c 80 6e 10 	movl   $0x106e80,0xc(%esp)
  105025:	00 
  105026:	c7 44 24 08 21 6a 10 	movl   $0x106a21,0x8(%esp)
  10502d:	00 
  10502e:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  105035:	00 
  105036:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  10503d:	e8 90 bc ff ff       	call   100cd2 <__panic>

    free_page(p);
  105042:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105049:	00 
  10504a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10504d:	89 04 24             	mov    %eax,(%esp)
  105050:	e8 b5 ed ff ff       	call   103e0a <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  105055:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10505a:	8b 00                	mov    (%eax),%eax
  10505c:	89 04 24             	mov    %eax,(%esp)
  10505f:	e8 5e eb ff ff       	call   103bc2 <pde2page>
  105064:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10506b:	00 
  10506c:	89 04 24             	mov    %eax,(%esp)
  10506f:	e8 96 ed ff ff       	call   103e0a <free_pages>
    boot_pgdir[0] = 0;
  105074:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  105079:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  10507f:	c7 04 24 a4 6e 10 00 	movl   $0x106ea4,(%esp)
  105086:	e8 bd b2 ff ff       	call   100348 <cprintf>
}
  10508b:	c9                   	leave  
  10508c:	c3                   	ret    

0010508d <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  10508d:	55                   	push   %ebp
  10508e:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105090:	8b 45 08             	mov    0x8(%ebp),%eax
  105093:	83 e0 04             	and    $0x4,%eax
  105096:	85 c0                	test   %eax,%eax
  105098:	74 07                	je     1050a1 <perm2str+0x14>
  10509a:	b8 75 00 00 00       	mov    $0x75,%eax
  10509f:	eb 05                	jmp    1050a6 <perm2str+0x19>
  1050a1:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1050a6:	a2 08 af 11 00       	mov    %al,0x11af08
    str[1] = 'r';
  1050ab:	c6 05 09 af 11 00 72 	movb   $0x72,0x11af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1050b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1050b5:	83 e0 02             	and    $0x2,%eax
  1050b8:	85 c0                	test   %eax,%eax
  1050ba:	74 07                	je     1050c3 <perm2str+0x36>
  1050bc:	b8 77 00 00 00       	mov    $0x77,%eax
  1050c1:	eb 05                	jmp    1050c8 <perm2str+0x3b>
  1050c3:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1050c8:	a2 0a af 11 00       	mov    %al,0x11af0a
    str[3] = '\0';
  1050cd:	c6 05 0b af 11 00 00 	movb   $0x0,0x11af0b
    return str;
  1050d4:	b8 08 af 11 00       	mov    $0x11af08,%eax
}
  1050d9:	5d                   	pop    %ebp
  1050da:	c3                   	ret    

001050db <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1050db:	55                   	push   %ebp
  1050dc:	89 e5                	mov    %esp,%ebp
  1050de:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1050e1:	8b 45 10             	mov    0x10(%ebp),%eax
  1050e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1050e7:	72 0a                	jb     1050f3 <get_pgtable_items+0x18>
        return 0;
  1050e9:	b8 00 00 00 00       	mov    $0x0,%eax
  1050ee:	e9 9c 00 00 00       	jmp    10518f <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  1050f3:	eb 04                	jmp    1050f9 <get_pgtable_items+0x1e>
        start ++;
  1050f5:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  1050f9:	8b 45 10             	mov    0x10(%ebp),%eax
  1050fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1050ff:	73 18                	jae    105119 <get_pgtable_items+0x3e>
  105101:	8b 45 10             	mov    0x10(%ebp),%eax
  105104:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10510b:	8b 45 14             	mov    0x14(%ebp),%eax
  10510e:	01 d0                	add    %edx,%eax
  105110:	8b 00                	mov    (%eax),%eax
  105112:	83 e0 01             	and    $0x1,%eax
  105115:	85 c0                	test   %eax,%eax
  105117:	74 dc                	je     1050f5 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  105119:	8b 45 10             	mov    0x10(%ebp),%eax
  10511c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10511f:	73 69                	jae    10518a <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  105121:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105125:	74 08                	je     10512f <get_pgtable_items+0x54>
            *left_store = start;
  105127:	8b 45 18             	mov    0x18(%ebp),%eax
  10512a:	8b 55 10             	mov    0x10(%ebp),%edx
  10512d:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  10512f:	8b 45 10             	mov    0x10(%ebp),%eax
  105132:	8d 50 01             	lea    0x1(%eax),%edx
  105135:	89 55 10             	mov    %edx,0x10(%ebp)
  105138:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10513f:	8b 45 14             	mov    0x14(%ebp),%eax
  105142:	01 d0                	add    %edx,%eax
  105144:	8b 00                	mov    (%eax),%eax
  105146:	83 e0 07             	and    $0x7,%eax
  105149:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  10514c:	eb 04                	jmp    105152 <get_pgtable_items+0x77>
            start ++;
  10514e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  105152:	8b 45 10             	mov    0x10(%ebp),%eax
  105155:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105158:	73 1d                	jae    105177 <get_pgtable_items+0x9c>
  10515a:	8b 45 10             	mov    0x10(%ebp),%eax
  10515d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105164:	8b 45 14             	mov    0x14(%ebp),%eax
  105167:	01 d0                	add    %edx,%eax
  105169:	8b 00                	mov    (%eax),%eax
  10516b:	83 e0 07             	and    $0x7,%eax
  10516e:	89 c2                	mov    %eax,%edx
  105170:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105173:	39 c2                	cmp    %eax,%edx
  105175:	74 d7                	je     10514e <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  105177:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10517b:	74 08                	je     105185 <get_pgtable_items+0xaa>
            *right_store = start;
  10517d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105180:	8b 55 10             	mov    0x10(%ebp),%edx
  105183:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  105185:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105188:	eb 05                	jmp    10518f <get_pgtable_items+0xb4>
    }
    return 0;
  10518a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10518f:	c9                   	leave  
  105190:	c3                   	ret    

00105191 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  105191:	55                   	push   %ebp
  105192:	89 e5                	mov    %esp,%ebp
  105194:	57                   	push   %edi
  105195:	56                   	push   %esi
  105196:	53                   	push   %ebx
  105197:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10519a:	c7 04 24 c4 6e 10 00 	movl   $0x106ec4,(%esp)
  1051a1:	e8 a2 b1 ff ff       	call   100348 <cprintf>
    size_t left, right = 0, perm;
  1051a6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1051ad:	e9 fa 00 00 00       	jmp    1052ac <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1051b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1051b5:	89 04 24             	mov    %eax,(%esp)
  1051b8:	e8 d0 fe ff ff       	call   10508d <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1051bd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1051c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1051c3:	29 d1                	sub    %edx,%ecx
  1051c5:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1051c7:	89 d6                	mov    %edx,%esi
  1051c9:	c1 e6 16             	shl    $0x16,%esi
  1051cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1051cf:	89 d3                	mov    %edx,%ebx
  1051d1:	c1 e3 16             	shl    $0x16,%ebx
  1051d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1051d7:	89 d1                	mov    %edx,%ecx
  1051d9:	c1 e1 16             	shl    $0x16,%ecx
  1051dc:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1051df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1051e2:	29 d7                	sub    %edx,%edi
  1051e4:	89 fa                	mov    %edi,%edx
  1051e6:	89 44 24 14          	mov    %eax,0x14(%esp)
  1051ea:	89 74 24 10          	mov    %esi,0x10(%esp)
  1051ee:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1051f2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1051f6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1051fa:	c7 04 24 f5 6e 10 00 	movl   $0x106ef5,(%esp)
  105201:	e8 42 b1 ff ff       	call   100348 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  105206:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105209:	c1 e0 0a             	shl    $0xa,%eax
  10520c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10520f:	eb 54                	jmp    105265 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105211:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105214:	89 04 24             	mov    %eax,(%esp)
  105217:	e8 71 fe ff ff       	call   10508d <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  10521c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10521f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105222:	29 d1                	sub    %edx,%ecx
  105224:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105226:	89 d6                	mov    %edx,%esi
  105228:	c1 e6 0c             	shl    $0xc,%esi
  10522b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10522e:	89 d3                	mov    %edx,%ebx
  105230:	c1 e3 0c             	shl    $0xc,%ebx
  105233:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105236:	c1 e2 0c             	shl    $0xc,%edx
  105239:	89 d1                	mov    %edx,%ecx
  10523b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  10523e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105241:	29 d7                	sub    %edx,%edi
  105243:	89 fa                	mov    %edi,%edx
  105245:	89 44 24 14          	mov    %eax,0x14(%esp)
  105249:	89 74 24 10          	mov    %esi,0x10(%esp)
  10524d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105251:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105255:	89 54 24 04          	mov    %edx,0x4(%esp)
  105259:	c7 04 24 14 6f 10 00 	movl   $0x106f14,(%esp)
  105260:	e8 e3 b0 ff ff       	call   100348 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105265:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  10526a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10526d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105270:	89 ce                	mov    %ecx,%esi
  105272:	c1 e6 0a             	shl    $0xa,%esi
  105275:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  105278:	89 cb                	mov    %ecx,%ebx
  10527a:	c1 e3 0a             	shl    $0xa,%ebx
  10527d:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  105280:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105284:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  105287:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10528b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10528f:	89 44 24 08          	mov    %eax,0x8(%esp)
  105293:	89 74 24 04          	mov    %esi,0x4(%esp)
  105297:	89 1c 24             	mov    %ebx,(%esp)
  10529a:	e8 3c fe ff ff       	call   1050db <get_pgtable_items>
  10529f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1052a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1052a6:	0f 85 65 ff ff ff    	jne    105211 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1052ac:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  1052b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1052b4:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  1052b7:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1052bb:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  1052be:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1052c2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1052c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1052ca:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1052d1:	00 
  1052d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1052d9:	e8 fd fd ff ff       	call   1050db <get_pgtable_items>
  1052de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1052e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1052e5:	0f 85 c7 fe ff ff    	jne    1051b2 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1052eb:	c7 04 24 38 6f 10 00 	movl   $0x106f38,(%esp)
  1052f2:	e8 51 b0 ff ff       	call   100348 <cprintf>
}
  1052f7:	83 c4 4c             	add    $0x4c,%esp
  1052fa:	5b                   	pop    %ebx
  1052fb:	5e                   	pop    %esi
  1052fc:	5f                   	pop    %edi
  1052fd:	5d                   	pop    %ebp
  1052fe:	c3                   	ret    

001052ff <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1052ff:	55                   	push   %ebp
  105300:	89 e5                	mov    %esp,%ebp
  105302:	83 ec 58             	sub    $0x58,%esp
  105305:	8b 45 10             	mov    0x10(%ebp),%eax
  105308:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10530b:	8b 45 14             	mov    0x14(%ebp),%eax
  10530e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105311:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105314:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105317:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10531a:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10531d:	8b 45 18             	mov    0x18(%ebp),%eax
  105320:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105323:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105326:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105329:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10532c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10532f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105332:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105335:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105339:	74 1c                	je     105357 <printnum+0x58>
  10533b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10533e:	ba 00 00 00 00       	mov    $0x0,%edx
  105343:	f7 75 e4             	divl   -0x1c(%ebp)
  105346:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10534c:	ba 00 00 00 00       	mov    $0x0,%edx
  105351:	f7 75 e4             	divl   -0x1c(%ebp)
  105354:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105357:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10535a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10535d:	f7 75 e4             	divl   -0x1c(%ebp)
  105360:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105363:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105366:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105369:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10536c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10536f:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105372:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105375:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105378:	8b 45 18             	mov    0x18(%ebp),%eax
  10537b:	ba 00 00 00 00       	mov    $0x0,%edx
  105380:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105383:	77 56                	ja     1053db <printnum+0xdc>
  105385:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105388:	72 05                	jb     10538f <printnum+0x90>
  10538a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  10538d:	77 4c                	ja     1053db <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  10538f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105392:	8d 50 ff             	lea    -0x1(%eax),%edx
  105395:	8b 45 20             	mov    0x20(%ebp),%eax
  105398:	89 44 24 18          	mov    %eax,0x18(%esp)
  10539c:	89 54 24 14          	mov    %edx,0x14(%esp)
  1053a0:	8b 45 18             	mov    0x18(%ebp),%eax
  1053a3:	89 44 24 10          	mov    %eax,0x10(%esp)
  1053a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1053aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1053ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053b1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1053b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1053b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1053bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1053bf:	89 04 24             	mov    %eax,(%esp)
  1053c2:	e8 38 ff ff ff       	call   1052ff <printnum>
  1053c7:	eb 1c                	jmp    1053e5 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1053c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1053cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1053d0:	8b 45 20             	mov    0x20(%ebp),%eax
  1053d3:	89 04 24             	mov    %eax,(%esp)
  1053d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1053d9:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1053db:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1053df:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1053e3:	7f e4                	jg     1053c9 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1053e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1053e8:	05 ec 6f 10 00       	add    $0x106fec,%eax
  1053ed:	0f b6 00             	movzbl (%eax),%eax
  1053f0:	0f be c0             	movsbl %al,%eax
  1053f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  1053f6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1053fa:	89 04 24             	mov    %eax,(%esp)
  1053fd:	8b 45 08             	mov    0x8(%ebp),%eax
  105400:	ff d0                	call   *%eax
}
  105402:	c9                   	leave  
  105403:	c3                   	ret    

00105404 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105404:	55                   	push   %ebp
  105405:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105407:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10540b:	7e 14                	jle    105421 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  10540d:	8b 45 08             	mov    0x8(%ebp),%eax
  105410:	8b 00                	mov    (%eax),%eax
  105412:	8d 48 08             	lea    0x8(%eax),%ecx
  105415:	8b 55 08             	mov    0x8(%ebp),%edx
  105418:	89 0a                	mov    %ecx,(%edx)
  10541a:	8b 50 04             	mov    0x4(%eax),%edx
  10541d:	8b 00                	mov    (%eax),%eax
  10541f:	eb 30                	jmp    105451 <getuint+0x4d>
    }
    else if (lflag) {
  105421:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105425:	74 16                	je     10543d <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105427:	8b 45 08             	mov    0x8(%ebp),%eax
  10542a:	8b 00                	mov    (%eax),%eax
  10542c:	8d 48 04             	lea    0x4(%eax),%ecx
  10542f:	8b 55 08             	mov    0x8(%ebp),%edx
  105432:	89 0a                	mov    %ecx,(%edx)
  105434:	8b 00                	mov    (%eax),%eax
  105436:	ba 00 00 00 00       	mov    $0x0,%edx
  10543b:	eb 14                	jmp    105451 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10543d:	8b 45 08             	mov    0x8(%ebp),%eax
  105440:	8b 00                	mov    (%eax),%eax
  105442:	8d 48 04             	lea    0x4(%eax),%ecx
  105445:	8b 55 08             	mov    0x8(%ebp),%edx
  105448:	89 0a                	mov    %ecx,(%edx)
  10544a:	8b 00                	mov    (%eax),%eax
  10544c:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105451:	5d                   	pop    %ebp
  105452:	c3                   	ret    

00105453 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105453:	55                   	push   %ebp
  105454:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105456:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10545a:	7e 14                	jle    105470 <getint+0x1d>
        return va_arg(*ap, long long);
  10545c:	8b 45 08             	mov    0x8(%ebp),%eax
  10545f:	8b 00                	mov    (%eax),%eax
  105461:	8d 48 08             	lea    0x8(%eax),%ecx
  105464:	8b 55 08             	mov    0x8(%ebp),%edx
  105467:	89 0a                	mov    %ecx,(%edx)
  105469:	8b 50 04             	mov    0x4(%eax),%edx
  10546c:	8b 00                	mov    (%eax),%eax
  10546e:	eb 28                	jmp    105498 <getint+0x45>
    }
    else if (lflag) {
  105470:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105474:	74 12                	je     105488 <getint+0x35>
        return va_arg(*ap, long);
  105476:	8b 45 08             	mov    0x8(%ebp),%eax
  105479:	8b 00                	mov    (%eax),%eax
  10547b:	8d 48 04             	lea    0x4(%eax),%ecx
  10547e:	8b 55 08             	mov    0x8(%ebp),%edx
  105481:	89 0a                	mov    %ecx,(%edx)
  105483:	8b 00                	mov    (%eax),%eax
  105485:	99                   	cltd   
  105486:	eb 10                	jmp    105498 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105488:	8b 45 08             	mov    0x8(%ebp),%eax
  10548b:	8b 00                	mov    (%eax),%eax
  10548d:	8d 48 04             	lea    0x4(%eax),%ecx
  105490:	8b 55 08             	mov    0x8(%ebp),%edx
  105493:	89 0a                	mov    %ecx,(%edx)
  105495:	8b 00                	mov    (%eax),%eax
  105497:	99                   	cltd   
    }
}
  105498:	5d                   	pop    %ebp
  105499:	c3                   	ret    

0010549a <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10549a:	55                   	push   %ebp
  10549b:	89 e5                	mov    %esp,%ebp
  10549d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1054a0:	8d 45 14             	lea    0x14(%ebp),%eax
  1054a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1054a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1054a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1054ad:	8b 45 10             	mov    0x10(%ebp),%eax
  1054b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1054be:	89 04 24             	mov    %eax,(%esp)
  1054c1:	e8 02 00 00 00       	call   1054c8 <vprintfmt>
    va_end(ap);
}
  1054c6:	c9                   	leave  
  1054c7:	c3                   	ret    

001054c8 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1054c8:	55                   	push   %ebp
  1054c9:	89 e5                	mov    %esp,%ebp
  1054cb:	56                   	push   %esi
  1054cc:	53                   	push   %ebx
  1054cd:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1054d0:	eb 18                	jmp    1054ea <vprintfmt+0x22>
            if (ch == '\0') {
  1054d2:	85 db                	test   %ebx,%ebx
  1054d4:	75 05                	jne    1054db <vprintfmt+0x13>
                return;
  1054d6:	e9 d1 03 00 00       	jmp    1058ac <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  1054db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054de:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054e2:	89 1c 24             	mov    %ebx,(%esp)
  1054e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1054e8:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1054ea:	8b 45 10             	mov    0x10(%ebp),%eax
  1054ed:	8d 50 01             	lea    0x1(%eax),%edx
  1054f0:	89 55 10             	mov    %edx,0x10(%ebp)
  1054f3:	0f b6 00             	movzbl (%eax),%eax
  1054f6:	0f b6 d8             	movzbl %al,%ebx
  1054f9:	83 fb 25             	cmp    $0x25,%ebx
  1054fc:	75 d4                	jne    1054d2 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  1054fe:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105502:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10550c:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10550f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105516:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105519:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10551c:	8b 45 10             	mov    0x10(%ebp),%eax
  10551f:	8d 50 01             	lea    0x1(%eax),%edx
  105522:	89 55 10             	mov    %edx,0x10(%ebp)
  105525:	0f b6 00             	movzbl (%eax),%eax
  105528:	0f b6 d8             	movzbl %al,%ebx
  10552b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10552e:	83 f8 55             	cmp    $0x55,%eax
  105531:	0f 87 44 03 00 00    	ja     10587b <vprintfmt+0x3b3>
  105537:	8b 04 85 10 70 10 00 	mov    0x107010(,%eax,4),%eax
  10553e:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105540:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105544:	eb d6                	jmp    10551c <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105546:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10554a:	eb d0                	jmp    10551c <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10554c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105553:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105556:	89 d0                	mov    %edx,%eax
  105558:	c1 e0 02             	shl    $0x2,%eax
  10555b:	01 d0                	add    %edx,%eax
  10555d:	01 c0                	add    %eax,%eax
  10555f:	01 d8                	add    %ebx,%eax
  105561:	83 e8 30             	sub    $0x30,%eax
  105564:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105567:	8b 45 10             	mov    0x10(%ebp),%eax
  10556a:	0f b6 00             	movzbl (%eax),%eax
  10556d:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105570:	83 fb 2f             	cmp    $0x2f,%ebx
  105573:	7e 0b                	jle    105580 <vprintfmt+0xb8>
  105575:	83 fb 39             	cmp    $0x39,%ebx
  105578:	7f 06                	jg     105580 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10557a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  10557e:	eb d3                	jmp    105553 <vprintfmt+0x8b>
            goto process_precision;
  105580:	eb 33                	jmp    1055b5 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  105582:	8b 45 14             	mov    0x14(%ebp),%eax
  105585:	8d 50 04             	lea    0x4(%eax),%edx
  105588:	89 55 14             	mov    %edx,0x14(%ebp)
  10558b:	8b 00                	mov    (%eax),%eax
  10558d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105590:	eb 23                	jmp    1055b5 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  105592:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105596:	79 0c                	jns    1055a4 <vprintfmt+0xdc>
                width = 0;
  105598:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10559f:	e9 78 ff ff ff       	jmp    10551c <vprintfmt+0x54>
  1055a4:	e9 73 ff ff ff       	jmp    10551c <vprintfmt+0x54>

        case '#':
            altflag = 1;
  1055a9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1055b0:	e9 67 ff ff ff       	jmp    10551c <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  1055b5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1055b9:	79 12                	jns    1055cd <vprintfmt+0x105>
                width = precision, precision = -1;
  1055bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1055be:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1055c1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1055c8:	e9 4f ff ff ff       	jmp    10551c <vprintfmt+0x54>
  1055cd:	e9 4a ff ff ff       	jmp    10551c <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1055d2:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1055d6:	e9 41 ff ff ff       	jmp    10551c <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1055db:	8b 45 14             	mov    0x14(%ebp),%eax
  1055de:	8d 50 04             	lea    0x4(%eax),%edx
  1055e1:	89 55 14             	mov    %edx,0x14(%ebp)
  1055e4:	8b 00                	mov    (%eax),%eax
  1055e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1055e9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1055ed:	89 04 24             	mov    %eax,(%esp)
  1055f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1055f3:	ff d0                	call   *%eax
            break;
  1055f5:	e9 ac 02 00 00       	jmp    1058a6 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1055fa:	8b 45 14             	mov    0x14(%ebp),%eax
  1055fd:	8d 50 04             	lea    0x4(%eax),%edx
  105600:	89 55 14             	mov    %edx,0x14(%ebp)
  105603:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105605:	85 db                	test   %ebx,%ebx
  105607:	79 02                	jns    10560b <vprintfmt+0x143>
                err = -err;
  105609:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10560b:	83 fb 06             	cmp    $0x6,%ebx
  10560e:	7f 0b                	jg     10561b <vprintfmt+0x153>
  105610:	8b 34 9d d0 6f 10 00 	mov    0x106fd0(,%ebx,4),%esi
  105617:	85 f6                	test   %esi,%esi
  105619:	75 23                	jne    10563e <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  10561b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10561f:	c7 44 24 08 fd 6f 10 	movl   $0x106ffd,0x8(%esp)
  105626:	00 
  105627:	8b 45 0c             	mov    0xc(%ebp),%eax
  10562a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10562e:	8b 45 08             	mov    0x8(%ebp),%eax
  105631:	89 04 24             	mov    %eax,(%esp)
  105634:	e8 61 fe ff ff       	call   10549a <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105639:	e9 68 02 00 00       	jmp    1058a6 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  10563e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105642:	c7 44 24 08 06 70 10 	movl   $0x107006,0x8(%esp)
  105649:	00 
  10564a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10564d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105651:	8b 45 08             	mov    0x8(%ebp),%eax
  105654:	89 04 24             	mov    %eax,(%esp)
  105657:	e8 3e fe ff ff       	call   10549a <printfmt>
            }
            break;
  10565c:	e9 45 02 00 00       	jmp    1058a6 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105661:	8b 45 14             	mov    0x14(%ebp),%eax
  105664:	8d 50 04             	lea    0x4(%eax),%edx
  105667:	89 55 14             	mov    %edx,0x14(%ebp)
  10566a:	8b 30                	mov    (%eax),%esi
  10566c:	85 f6                	test   %esi,%esi
  10566e:	75 05                	jne    105675 <vprintfmt+0x1ad>
                p = "(null)";
  105670:	be 09 70 10 00       	mov    $0x107009,%esi
            }
            if (width > 0 && padc != '-') {
  105675:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105679:	7e 3e                	jle    1056b9 <vprintfmt+0x1f1>
  10567b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  10567f:	74 38                	je     1056b9 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105681:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105684:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105687:	89 44 24 04          	mov    %eax,0x4(%esp)
  10568b:	89 34 24             	mov    %esi,(%esp)
  10568e:	e8 15 03 00 00       	call   1059a8 <strnlen>
  105693:	29 c3                	sub    %eax,%ebx
  105695:	89 d8                	mov    %ebx,%eax
  105697:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10569a:	eb 17                	jmp    1056b3 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  10569c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1056a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  1056a3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1056a7:	89 04 24             	mov    %eax,(%esp)
  1056aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1056ad:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1056af:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1056b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056b7:	7f e3                	jg     10569c <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1056b9:	eb 38                	jmp    1056f3 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  1056bb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1056bf:	74 1f                	je     1056e0 <vprintfmt+0x218>
  1056c1:	83 fb 1f             	cmp    $0x1f,%ebx
  1056c4:	7e 05                	jle    1056cb <vprintfmt+0x203>
  1056c6:	83 fb 7e             	cmp    $0x7e,%ebx
  1056c9:	7e 15                	jle    1056e0 <vprintfmt+0x218>
                    putch('?', putdat);
  1056cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056d2:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1056d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1056dc:	ff d0                	call   *%eax
  1056de:	eb 0f                	jmp    1056ef <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  1056e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056e7:	89 1c 24             	mov    %ebx,(%esp)
  1056ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1056ed:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1056ef:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1056f3:	89 f0                	mov    %esi,%eax
  1056f5:	8d 70 01             	lea    0x1(%eax),%esi
  1056f8:	0f b6 00             	movzbl (%eax),%eax
  1056fb:	0f be d8             	movsbl %al,%ebx
  1056fe:	85 db                	test   %ebx,%ebx
  105700:	74 10                	je     105712 <vprintfmt+0x24a>
  105702:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105706:	78 b3                	js     1056bb <vprintfmt+0x1f3>
  105708:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  10570c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105710:	79 a9                	jns    1056bb <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105712:	eb 17                	jmp    10572b <vprintfmt+0x263>
                putch(' ', putdat);
  105714:	8b 45 0c             	mov    0xc(%ebp),%eax
  105717:	89 44 24 04          	mov    %eax,0x4(%esp)
  10571b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105722:	8b 45 08             	mov    0x8(%ebp),%eax
  105725:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105727:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10572b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10572f:	7f e3                	jg     105714 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  105731:	e9 70 01 00 00       	jmp    1058a6 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105736:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105739:	89 44 24 04          	mov    %eax,0x4(%esp)
  10573d:	8d 45 14             	lea    0x14(%ebp),%eax
  105740:	89 04 24             	mov    %eax,(%esp)
  105743:	e8 0b fd ff ff       	call   105453 <getint>
  105748:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10574b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10574e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105751:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105754:	85 d2                	test   %edx,%edx
  105756:	79 26                	jns    10577e <vprintfmt+0x2b6>
                putch('-', putdat);
  105758:	8b 45 0c             	mov    0xc(%ebp),%eax
  10575b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10575f:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105766:	8b 45 08             	mov    0x8(%ebp),%eax
  105769:	ff d0                	call   *%eax
                num = -(long long)num;
  10576b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10576e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105771:	f7 d8                	neg    %eax
  105773:	83 d2 00             	adc    $0x0,%edx
  105776:	f7 da                	neg    %edx
  105778:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10577b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10577e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105785:	e9 a8 00 00 00       	jmp    105832 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  10578a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10578d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105791:	8d 45 14             	lea    0x14(%ebp),%eax
  105794:	89 04 24             	mov    %eax,(%esp)
  105797:	e8 68 fc ff ff       	call   105404 <getuint>
  10579c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10579f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1057a2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1057a9:	e9 84 00 00 00       	jmp    105832 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1057ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1057b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057b5:	8d 45 14             	lea    0x14(%ebp),%eax
  1057b8:	89 04 24             	mov    %eax,(%esp)
  1057bb:	e8 44 fc ff ff       	call   105404 <getuint>
  1057c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1057c6:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1057cd:	eb 63                	jmp    105832 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  1057cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057d6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1057dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1057e0:	ff d0                	call   *%eax
            putch('x', putdat);
  1057e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057e9:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  1057f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1057f3:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1057f5:	8b 45 14             	mov    0x14(%ebp),%eax
  1057f8:	8d 50 04             	lea    0x4(%eax),%edx
  1057fb:	89 55 14             	mov    %edx,0x14(%ebp)
  1057fe:	8b 00                	mov    (%eax),%eax
  105800:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105803:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10580a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105811:	eb 1f                	jmp    105832 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105813:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105816:	89 44 24 04          	mov    %eax,0x4(%esp)
  10581a:	8d 45 14             	lea    0x14(%ebp),%eax
  10581d:	89 04 24             	mov    %eax,(%esp)
  105820:	e8 df fb ff ff       	call   105404 <getuint>
  105825:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105828:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10582b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105832:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105836:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105839:	89 54 24 18          	mov    %edx,0x18(%esp)
  10583d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105840:	89 54 24 14          	mov    %edx,0x14(%esp)
  105844:	89 44 24 10          	mov    %eax,0x10(%esp)
  105848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10584b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10584e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105852:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105856:	8b 45 0c             	mov    0xc(%ebp),%eax
  105859:	89 44 24 04          	mov    %eax,0x4(%esp)
  10585d:	8b 45 08             	mov    0x8(%ebp),%eax
  105860:	89 04 24             	mov    %eax,(%esp)
  105863:	e8 97 fa ff ff       	call   1052ff <printnum>
            break;
  105868:	eb 3c                	jmp    1058a6 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10586a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10586d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105871:	89 1c 24             	mov    %ebx,(%esp)
  105874:	8b 45 08             	mov    0x8(%ebp),%eax
  105877:	ff d0                	call   *%eax
            break;
  105879:	eb 2b                	jmp    1058a6 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10587b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10587e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105882:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105889:	8b 45 08             	mov    0x8(%ebp),%eax
  10588c:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  10588e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105892:	eb 04                	jmp    105898 <vprintfmt+0x3d0>
  105894:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105898:	8b 45 10             	mov    0x10(%ebp),%eax
  10589b:	83 e8 01             	sub    $0x1,%eax
  10589e:	0f b6 00             	movzbl (%eax),%eax
  1058a1:	3c 25                	cmp    $0x25,%al
  1058a3:	75 ef                	jne    105894 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  1058a5:	90                   	nop
        }
    }
  1058a6:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1058a7:	e9 3e fc ff ff       	jmp    1054ea <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1058ac:	83 c4 40             	add    $0x40,%esp
  1058af:	5b                   	pop    %ebx
  1058b0:	5e                   	pop    %esi
  1058b1:	5d                   	pop    %ebp
  1058b2:	c3                   	ret    

001058b3 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1058b3:	55                   	push   %ebp
  1058b4:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1058b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058b9:	8b 40 08             	mov    0x8(%eax),%eax
  1058bc:	8d 50 01             	lea    0x1(%eax),%edx
  1058bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058c2:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1058c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058c8:	8b 10                	mov    (%eax),%edx
  1058ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058cd:	8b 40 04             	mov    0x4(%eax),%eax
  1058d0:	39 c2                	cmp    %eax,%edx
  1058d2:	73 12                	jae    1058e6 <sprintputch+0x33>
        *b->buf ++ = ch;
  1058d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058d7:	8b 00                	mov    (%eax),%eax
  1058d9:	8d 48 01             	lea    0x1(%eax),%ecx
  1058dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  1058df:	89 0a                	mov    %ecx,(%edx)
  1058e1:	8b 55 08             	mov    0x8(%ebp),%edx
  1058e4:	88 10                	mov    %dl,(%eax)
    }
}
  1058e6:	5d                   	pop    %ebp
  1058e7:	c3                   	ret    

001058e8 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1058e8:	55                   	push   %ebp
  1058e9:	89 e5                	mov    %esp,%ebp
  1058eb:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1058ee:	8d 45 14             	lea    0x14(%ebp),%eax
  1058f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1058f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1058fb:	8b 45 10             	mov    0x10(%ebp),%eax
  1058fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  105902:	8b 45 0c             	mov    0xc(%ebp),%eax
  105905:	89 44 24 04          	mov    %eax,0x4(%esp)
  105909:	8b 45 08             	mov    0x8(%ebp),%eax
  10590c:	89 04 24             	mov    %eax,(%esp)
  10590f:	e8 08 00 00 00       	call   10591c <vsnprintf>
  105914:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105917:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10591a:	c9                   	leave  
  10591b:	c3                   	ret    

0010591c <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10591c:	55                   	push   %ebp
  10591d:	89 e5                	mov    %esp,%ebp
  10591f:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105922:	8b 45 08             	mov    0x8(%ebp),%eax
  105925:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105928:	8b 45 0c             	mov    0xc(%ebp),%eax
  10592b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10592e:	8b 45 08             	mov    0x8(%ebp),%eax
  105931:	01 d0                	add    %edx,%eax
  105933:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105936:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10593d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105941:	74 0a                	je     10594d <vsnprintf+0x31>
  105943:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105949:	39 c2                	cmp    %eax,%edx
  10594b:	76 07                	jbe    105954 <vsnprintf+0x38>
        return -E_INVAL;
  10594d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105952:	eb 2a                	jmp    10597e <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105954:	8b 45 14             	mov    0x14(%ebp),%eax
  105957:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10595b:	8b 45 10             	mov    0x10(%ebp),%eax
  10595e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105962:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105965:	89 44 24 04          	mov    %eax,0x4(%esp)
  105969:	c7 04 24 b3 58 10 00 	movl   $0x1058b3,(%esp)
  105970:	e8 53 fb ff ff       	call   1054c8 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105975:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105978:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10597b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10597e:	c9                   	leave  
  10597f:	c3                   	ret    

00105980 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105980:	55                   	push   %ebp
  105981:	89 e5                	mov    %esp,%ebp
  105983:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105986:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  10598d:	eb 04                	jmp    105993 <strlen+0x13>
        cnt ++;
  10598f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105993:	8b 45 08             	mov    0x8(%ebp),%eax
  105996:	8d 50 01             	lea    0x1(%eax),%edx
  105999:	89 55 08             	mov    %edx,0x8(%ebp)
  10599c:	0f b6 00             	movzbl (%eax),%eax
  10599f:	84 c0                	test   %al,%al
  1059a1:	75 ec                	jne    10598f <strlen+0xf>
        cnt ++;
    }
    return cnt;
  1059a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1059a6:	c9                   	leave  
  1059a7:	c3                   	ret    

001059a8 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1059a8:	55                   	push   %ebp
  1059a9:	89 e5                	mov    %esp,%ebp
  1059ab:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1059ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1059b5:	eb 04                	jmp    1059bb <strnlen+0x13>
        cnt ++;
  1059b7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  1059bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1059be:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1059c1:	73 10                	jae    1059d3 <strnlen+0x2b>
  1059c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1059c6:	8d 50 01             	lea    0x1(%eax),%edx
  1059c9:	89 55 08             	mov    %edx,0x8(%ebp)
  1059cc:	0f b6 00             	movzbl (%eax),%eax
  1059cf:	84 c0                	test   %al,%al
  1059d1:	75 e4                	jne    1059b7 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  1059d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1059d6:	c9                   	leave  
  1059d7:	c3                   	ret    

001059d8 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1059d8:	55                   	push   %ebp
  1059d9:	89 e5                	mov    %esp,%ebp
  1059db:	57                   	push   %edi
  1059dc:	56                   	push   %esi
  1059dd:	83 ec 20             	sub    $0x20,%esp
  1059e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1059e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1059e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1059ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1059ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1059f2:	89 d1                	mov    %edx,%ecx
  1059f4:	89 c2                	mov    %eax,%edx
  1059f6:	89 ce                	mov    %ecx,%esi
  1059f8:	89 d7                	mov    %edx,%edi
  1059fa:	ac                   	lods   %ds:(%esi),%al
  1059fb:	aa                   	stos   %al,%es:(%edi)
  1059fc:	84 c0                	test   %al,%al
  1059fe:	75 fa                	jne    1059fa <strcpy+0x22>
  105a00:	89 fa                	mov    %edi,%edx
  105a02:	89 f1                	mov    %esi,%ecx
  105a04:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105a07:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105a0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105a10:	83 c4 20             	add    $0x20,%esp
  105a13:	5e                   	pop    %esi
  105a14:	5f                   	pop    %edi
  105a15:	5d                   	pop    %ebp
  105a16:	c3                   	ret    

00105a17 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105a17:	55                   	push   %ebp
  105a18:	89 e5                	mov    %esp,%ebp
  105a1a:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  105a20:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105a23:	eb 21                	jmp    105a46 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a28:	0f b6 10             	movzbl (%eax),%edx
  105a2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a2e:	88 10                	mov    %dl,(%eax)
  105a30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a33:	0f b6 00             	movzbl (%eax),%eax
  105a36:	84 c0                	test   %al,%al
  105a38:	74 04                	je     105a3e <strncpy+0x27>
            src ++;
  105a3a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105a3e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105a42:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105a46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a4a:	75 d9                	jne    105a25 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105a4c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105a4f:	c9                   	leave  
  105a50:	c3                   	ret    

00105a51 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105a51:	55                   	push   %ebp
  105a52:	89 e5                	mov    %esp,%ebp
  105a54:	57                   	push   %edi
  105a55:	56                   	push   %esi
  105a56:	83 ec 20             	sub    $0x20,%esp
  105a59:	8b 45 08             	mov    0x8(%ebp),%eax
  105a5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a62:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105a65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a6b:	89 d1                	mov    %edx,%ecx
  105a6d:	89 c2                	mov    %eax,%edx
  105a6f:	89 ce                	mov    %ecx,%esi
  105a71:	89 d7                	mov    %edx,%edi
  105a73:	ac                   	lods   %ds:(%esi),%al
  105a74:	ae                   	scas   %es:(%edi),%al
  105a75:	75 08                	jne    105a7f <strcmp+0x2e>
  105a77:	84 c0                	test   %al,%al
  105a79:	75 f8                	jne    105a73 <strcmp+0x22>
  105a7b:	31 c0                	xor    %eax,%eax
  105a7d:	eb 04                	jmp    105a83 <strcmp+0x32>
  105a7f:	19 c0                	sbb    %eax,%eax
  105a81:	0c 01                	or     $0x1,%al
  105a83:	89 fa                	mov    %edi,%edx
  105a85:	89 f1                	mov    %esi,%ecx
  105a87:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a8a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105a8d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105a93:	83 c4 20             	add    $0x20,%esp
  105a96:	5e                   	pop    %esi
  105a97:	5f                   	pop    %edi
  105a98:	5d                   	pop    %ebp
  105a99:	c3                   	ret    

00105a9a <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105a9a:	55                   	push   %ebp
  105a9b:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105a9d:	eb 0c                	jmp    105aab <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105a9f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105aa3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105aa7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105aab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105aaf:	74 1a                	je     105acb <strncmp+0x31>
  105ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  105ab4:	0f b6 00             	movzbl (%eax),%eax
  105ab7:	84 c0                	test   %al,%al
  105ab9:	74 10                	je     105acb <strncmp+0x31>
  105abb:	8b 45 08             	mov    0x8(%ebp),%eax
  105abe:	0f b6 10             	movzbl (%eax),%edx
  105ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ac4:	0f b6 00             	movzbl (%eax),%eax
  105ac7:	38 c2                	cmp    %al,%dl
  105ac9:	74 d4                	je     105a9f <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105acb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105acf:	74 18                	je     105ae9 <strncmp+0x4f>
  105ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  105ad4:	0f b6 00             	movzbl (%eax),%eax
  105ad7:	0f b6 d0             	movzbl %al,%edx
  105ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  105add:	0f b6 00             	movzbl (%eax),%eax
  105ae0:	0f b6 c0             	movzbl %al,%eax
  105ae3:	29 c2                	sub    %eax,%edx
  105ae5:	89 d0                	mov    %edx,%eax
  105ae7:	eb 05                	jmp    105aee <strncmp+0x54>
  105ae9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105aee:	5d                   	pop    %ebp
  105aef:	c3                   	ret    

00105af0 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105af0:	55                   	push   %ebp
  105af1:	89 e5                	mov    %esp,%ebp
  105af3:	83 ec 04             	sub    $0x4,%esp
  105af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105af9:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105afc:	eb 14                	jmp    105b12 <strchr+0x22>
        if (*s == c) {
  105afe:	8b 45 08             	mov    0x8(%ebp),%eax
  105b01:	0f b6 00             	movzbl (%eax),%eax
  105b04:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105b07:	75 05                	jne    105b0e <strchr+0x1e>
            return (char *)s;
  105b09:	8b 45 08             	mov    0x8(%ebp),%eax
  105b0c:	eb 13                	jmp    105b21 <strchr+0x31>
        }
        s ++;
  105b0e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105b12:	8b 45 08             	mov    0x8(%ebp),%eax
  105b15:	0f b6 00             	movzbl (%eax),%eax
  105b18:	84 c0                	test   %al,%al
  105b1a:	75 e2                	jne    105afe <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105b1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105b21:	c9                   	leave  
  105b22:	c3                   	ret    

00105b23 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105b23:	55                   	push   %ebp
  105b24:	89 e5                	mov    %esp,%ebp
  105b26:	83 ec 04             	sub    $0x4,%esp
  105b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b2c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105b2f:	eb 11                	jmp    105b42 <strfind+0x1f>
        if (*s == c) {
  105b31:	8b 45 08             	mov    0x8(%ebp),%eax
  105b34:	0f b6 00             	movzbl (%eax),%eax
  105b37:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105b3a:	75 02                	jne    105b3e <strfind+0x1b>
            break;
  105b3c:	eb 0e                	jmp    105b4c <strfind+0x29>
        }
        s ++;
  105b3e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105b42:	8b 45 08             	mov    0x8(%ebp),%eax
  105b45:	0f b6 00             	movzbl (%eax),%eax
  105b48:	84 c0                	test   %al,%al
  105b4a:	75 e5                	jne    105b31 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105b4c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105b4f:	c9                   	leave  
  105b50:	c3                   	ret    

00105b51 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105b51:	55                   	push   %ebp
  105b52:	89 e5                	mov    %esp,%ebp
  105b54:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105b57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105b5e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105b65:	eb 04                	jmp    105b6b <strtol+0x1a>
        s ++;
  105b67:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  105b6e:	0f b6 00             	movzbl (%eax),%eax
  105b71:	3c 20                	cmp    $0x20,%al
  105b73:	74 f2                	je     105b67 <strtol+0x16>
  105b75:	8b 45 08             	mov    0x8(%ebp),%eax
  105b78:	0f b6 00             	movzbl (%eax),%eax
  105b7b:	3c 09                	cmp    $0x9,%al
  105b7d:	74 e8                	je     105b67 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  105b82:	0f b6 00             	movzbl (%eax),%eax
  105b85:	3c 2b                	cmp    $0x2b,%al
  105b87:	75 06                	jne    105b8f <strtol+0x3e>
        s ++;
  105b89:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105b8d:	eb 15                	jmp    105ba4 <strtol+0x53>
    }
    else if (*s == '-') {
  105b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  105b92:	0f b6 00             	movzbl (%eax),%eax
  105b95:	3c 2d                	cmp    $0x2d,%al
  105b97:	75 0b                	jne    105ba4 <strtol+0x53>
        s ++, neg = 1;
  105b99:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105b9d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105ba4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ba8:	74 06                	je     105bb0 <strtol+0x5f>
  105baa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105bae:	75 24                	jne    105bd4 <strtol+0x83>
  105bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  105bb3:	0f b6 00             	movzbl (%eax),%eax
  105bb6:	3c 30                	cmp    $0x30,%al
  105bb8:	75 1a                	jne    105bd4 <strtol+0x83>
  105bba:	8b 45 08             	mov    0x8(%ebp),%eax
  105bbd:	83 c0 01             	add    $0x1,%eax
  105bc0:	0f b6 00             	movzbl (%eax),%eax
  105bc3:	3c 78                	cmp    $0x78,%al
  105bc5:	75 0d                	jne    105bd4 <strtol+0x83>
        s += 2, base = 16;
  105bc7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105bcb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105bd2:	eb 2a                	jmp    105bfe <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105bd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105bd8:	75 17                	jne    105bf1 <strtol+0xa0>
  105bda:	8b 45 08             	mov    0x8(%ebp),%eax
  105bdd:	0f b6 00             	movzbl (%eax),%eax
  105be0:	3c 30                	cmp    $0x30,%al
  105be2:	75 0d                	jne    105bf1 <strtol+0xa0>
        s ++, base = 8;
  105be4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105be8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105bef:	eb 0d                	jmp    105bfe <strtol+0xad>
    }
    else if (base == 0) {
  105bf1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105bf5:	75 07                	jne    105bfe <strtol+0xad>
        base = 10;
  105bf7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  105c01:	0f b6 00             	movzbl (%eax),%eax
  105c04:	3c 2f                	cmp    $0x2f,%al
  105c06:	7e 1b                	jle    105c23 <strtol+0xd2>
  105c08:	8b 45 08             	mov    0x8(%ebp),%eax
  105c0b:	0f b6 00             	movzbl (%eax),%eax
  105c0e:	3c 39                	cmp    $0x39,%al
  105c10:	7f 11                	jg     105c23 <strtol+0xd2>
            dig = *s - '0';
  105c12:	8b 45 08             	mov    0x8(%ebp),%eax
  105c15:	0f b6 00             	movzbl (%eax),%eax
  105c18:	0f be c0             	movsbl %al,%eax
  105c1b:	83 e8 30             	sub    $0x30,%eax
  105c1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105c21:	eb 48                	jmp    105c6b <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105c23:	8b 45 08             	mov    0x8(%ebp),%eax
  105c26:	0f b6 00             	movzbl (%eax),%eax
  105c29:	3c 60                	cmp    $0x60,%al
  105c2b:	7e 1b                	jle    105c48 <strtol+0xf7>
  105c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  105c30:	0f b6 00             	movzbl (%eax),%eax
  105c33:	3c 7a                	cmp    $0x7a,%al
  105c35:	7f 11                	jg     105c48 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105c37:	8b 45 08             	mov    0x8(%ebp),%eax
  105c3a:	0f b6 00             	movzbl (%eax),%eax
  105c3d:	0f be c0             	movsbl %al,%eax
  105c40:	83 e8 57             	sub    $0x57,%eax
  105c43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105c46:	eb 23                	jmp    105c6b <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105c48:	8b 45 08             	mov    0x8(%ebp),%eax
  105c4b:	0f b6 00             	movzbl (%eax),%eax
  105c4e:	3c 40                	cmp    $0x40,%al
  105c50:	7e 3d                	jle    105c8f <strtol+0x13e>
  105c52:	8b 45 08             	mov    0x8(%ebp),%eax
  105c55:	0f b6 00             	movzbl (%eax),%eax
  105c58:	3c 5a                	cmp    $0x5a,%al
  105c5a:	7f 33                	jg     105c8f <strtol+0x13e>
            dig = *s - 'A' + 10;
  105c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c5f:	0f b6 00             	movzbl (%eax),%eax
  105c62:	0f be c0             	movsbl %al,%eax
  105c65:	83 e8 37             	sub    $0x37,%eax
  105c68:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c6e:	3b 45 10             	cmp    0x10(%ebp),%eax
  105c71:	7c 02                	jl     105c75 <strtol+0x124>
            break;
  105c73:	eb 1a                	jmp    105c8f <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105c75:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105c7c:	0f af 45 10          	imul   0x10(%ebp),%eax
  105c80:	89 c2                	mov    %eax,%edx
  105c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c85:	01 d0                	add    %edx,%eax
  105c87:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105c8a:	e9 6f ff ff ff       	jmp    105bfe <strtol+0xad>

    if (endptr) {
  105c8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105c93:	74 08                	je     105c9d <strtol+0x14c>
        *endptr = (char *) s;
  105c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c98:	8b 55 08             	mov    0x8(%ebp),%edx
  105c9b:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105c9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105ca1:	74 07                	je     105caa <strtol+0x159>
  105ca3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105ca6:	f7 d8                	neg    %eax
  105ca8:	eb 03                	jmp    105cad <strtol+0x15c>
  105caa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105cad:	c9                   	leave  
  105cae:	c3                   	ret    

00105caf <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105caf:	55                   	push   %ebp
  105cb0:	89 e5                	mov    %esp,%ebp
  105cb2:	57                   	push   %edi
  105cb3:	83 ec 24             	sub    $0x24,%esp
  105cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cb9:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105cbc:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105cc0:	8b 55 08             	mov    0x8(%ebp),%edx
  105cc3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105cc6:	88 45 f7             	mov    %al,-0x9(%ebp)
  105cc9:	8b 45 10             	mov    0x10(%ebp),%eax
  105ccc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105ccf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105cd2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105cd6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105cd9:	89 d7                	mov    %edx,%edi
  105cdb:	f3 aa                	rep stos %al,%es:(%edi)
  105cdd:	89 fa                	mov    %edi,%edx
  105cdf:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105ce2:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105ce5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105ce8:	83 c4 24             	add    $0x24,%esp
  105ceb:	5f                   	pop    %edi
  105cec:	5d                   	pop    %ebp
  105ced:	c3                   	ret    

00105cee <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105cee:	55                   	push   %ebp
  105cef:	89 e5                	mov    %esp,%ebp
  105cf1:	57                   	push   %edi
  105cf2:	56                   	push   %esi
  105cf3:	53                   	push   %ebx
  105cf4:	83 ec 30             	sub    $0x30,%esp
  105cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  105cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d00:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105d03:	8b 45 10             	mov    0x10(%ebp),%eax
  105d06:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d0c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105d0f:	73 42                	jae    105d53 <memmove+0x65>
  105d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105d17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105d1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d20:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105d23:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105d26:	c1 e8 02             	shr    $0x2,%eax
  105d29:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105d2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105d2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105d31:	89 d7                	mov    %edx,%edi
  105d33:	89 c6                	mov    %eax,%esi
  105d35:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105d37:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105d3a:	83 e1 03             	and    $0x3,%ecx
  105d3d:	74 02                	je     105d41 <memmove+0x53>
  105d3f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105d41:	89 f0                	mov    %esi,%eax
  105d43:	89 fa                	mov    %edi,%edx
  105d45:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105d48:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105d4b:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105d51:	eb 36                	jmp    105d89 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105d53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d56:	8d 50 ff             	lea    -0x1(%eax),%edx
  105d59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d5c:	01 c2                	add    %eax,%edx
  105d5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d61:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d67:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105d6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d6d:	89 c1                	mov    %eax,%ecx
  105d6f:	89 d8                	mov    %ebx,%eax
  105d71:	89 d6                	mov    %edx,%esi
  105d73:	89 c7                	mov    %eax,%edi
  105d75:	fd                   	std    
  105d76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105d78:	fc                   	cld    
  105d79:	89 f8                	mov    %edi,%eax
  105d7b:	89 f2                	mov    %esi,%edx
  105d7d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105d80:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105d83:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105d89:	83 c4 30             	add    $0x30,%esp
  105d8c:	5b                   	pop    %ebx
  105d8d:	5e                   	pop    %esi
  105d8e:	5f                   	pop    %edi
  105d8f:	5d                   	pop    %ebp
  105d90:	c3                   	ret    

00105d91 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105d91:	55                   	push   %ebp
  105d92:	89 e5                	mov    %esp,%ebp
  105d94:	57                   	push   %edi
  105d95:	56                   	push   %esi
  105d96:	83 ec 20             	sub    $0x20,%esp
  105d99:	8b 45 08             	mov    0x8(%ebp),%eax
  105d9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105da2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105da5:	8b 45 10             	mov    0x10(%ebp),%eax
  105da8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105dae:	c1 e8 02             	shr    $0x2,%eax
  105db1:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105db3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105db9:	89 d7                	mov    %edx,%edi
  105dbb:	89 c6                	mov    %eax,%esi
  105dbd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105dbf:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105dc2:	83 e1 03             	and    $0x3,%ecx
  105dc5:	74 02                	je     105dc9 <memcpy+0x38>
  105dc7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105dc9:	89 f0                	mov    %esi,%eax
  105dcb:	89 fa                	mov    %edi,%edx
  105dcd:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105dd0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105dd3:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105dd9:	83 c4 20             	add    $0x20,%esp
  105ddc:	5e                   	pop    %esi
  105ddd:	5f                   	pop    %edi
  105dde:	5d                   	pop    %ebp
  105ddf:	c3                   	ret    

00105de0 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105de0:	55                   	push   %ebp
  105de1:	89 e5                	mov    %esp,%ebp
  105de3:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105de6:	8b 45 08             	mov    0x8(%ebp),%eax
  105de9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105dec:	8b 45 0c             	mov    0xc(%ebp),%eax
  105def:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105df2:	eb 30                	jmp    105e24 <memcmp+0x44>
        if (*s1 != *s2) {
  105df4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105df7:	0f b6 10             	movzbl (%eax),%edx
  105dfa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105dfd:	0f b6 00             	movzbl (%eax),%eax
  105e00:	38 c2                	cmp    %al,%dl
  105e02:	74 18                	je     105e1c <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105e04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105e07:	0f b6 00             	movzbl (%eax),%eax
  105e0a:	0f b6 d0             	movzbl %al,%edx
  105e0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e10:	0f b6 00             	movzbl (%eax),%eax
  105e13:	0f b6 c0             	movzbl %al,%eax
  105e16:	29 c2                	sub    %eax,%edx
  105e18:	89 d0                	mov    %edx,%eax
  105e1a:	eb 1a                	jmp    105e36 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105e1c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105e20:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105e24:	8b 45 10             	mov    0x10(%ebp),%eax
  105e27:	8d 50 ff             	lea    -0x1(%eax),%edx
  105e2a:	89 55 10             	mov    %edx,0x10(%ebp)
  105e2d:	85 c0                	test   %eax,%eax
  105e2f:	75 c3                	jne    105df4 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105e31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105e36:	c9                   	leave  
  105e37:	c3                   	ret    
