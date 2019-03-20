
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 f5 32 00 00       	call   103321 <memset>

    cons_init();                // init the console
  10002c:	e8 45 15 00 00       	call   101576 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 c0 34 10 00 	movl   $0x1034c0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 dc 34 10 00 	movl   $0x1034dc,(%esp)
  100046:	e8 c7 02 00 00       	call   100312 <cprintf>

    print_kerninfo();
  10004b:	e8 f6 07 00 00       	call   100846 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 0d 29 00 00       	call   102967 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 5a 16 00 00       	call   1016b9 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 d2 17 00 00       	call   101836 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 00 0d 00 00       	call   100d69 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 b9 15 00 00       	call   101627 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 f8 0b 00 00       	call   100c8a <mon_backtrace>
}
  100092:	c9                   	leave  
  100093:	c3                   	ret    

00100094 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100094:	55                   	push   %ebp
  100095:	89 e5                	mov    %esp,%ebp
  100097:	53                   	push   %ebx
  100098:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  10009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a1:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b3:	89 04 24             	mov    %eax,(%esp)
  1000b6:	e8 b5 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bb:	83 c4 14             	add    $0x14,%esp
  1000be:	5b                   	pop    %ebx
  1000bf:	5d                   	pop    %ebp
  1000c0:	c3                   	ret    

001000c1 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1000ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 04 24             	mov    %eax,(%esp)
  1000d4:	e8 bb ff ff ff       	call   100094 <grade_backtrace1>
}
  1000d9:	c9                   	leave  
  1000da:	c3                   	ret    

001000db <grade_backtrace>:

void
grade_backtrace(void) {
  1000db:	55                   	push   %ebp
  1000dc:	89 e5                	mov    %esp,%ebp
  1000de:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e1:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e6:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000ed:	ff 
  1000ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000f9:	e8 c3 ff ff ff       	call   1000c1 <grade_backtrace0>
}
  1000fe:	c9                   	leave  
  1000ff:	c3                   	ret    

00100100 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100100:	55                   	push   %ebp
  100101:	89 e5                	mov    %esp,%ebp
  100103:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100106:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100109:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10010f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100112:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100116:	0f b7 c0             	movzwl %ax,%eax
  100119:	83 e0 03             	and    $0x3,%eax
  10011c:	89 c2                	mov    %eax,%edx
  10011e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100123:	89 54 24 08          	mov    %edx,0x8(%esp)
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 e1 34 10 00 	movl   $0x1034e1,(%esp)
  100132:	e8 db 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 ef 34 10 00 	movl   $0x1034ef,(%esp)
  100152:	e8 bb 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 fd 34 10 00 	movl   $0x1034fd,(%esp)
  100172:	e8 9b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 0b 35 10 00 	movl   $0x10350b,(%esp)
  100192:	e8 7b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 19 35 10 00 	movl   $0x103519,(%esp)
  1001b2:	e8 5b 01 00 00       	call   100312 <cprintf>
    round ++;
  1001b7:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001bc:	83 c0 01             	add    $0x1,%eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	c9                   	leave  
  1001c5:	c3                   	ret    

001001c6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c6:	55                   	push   %ebp
  1001c7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001c9:	5d                   	pop    %ebp
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ce:	5d                   	pop    %ebp
  1001cf:	c3                   	ret    

001001d0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
  1001d3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d6:	e8 25 ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001db:	c7 04 24 28 35 10 00 	movl   $0x103528,(%esp)
  1001e2:	e8 2b 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 48 35 10 00 	movl   $0x103548,(%esp)
  1001f8:	e8 15 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_kernel();
  1001fd:	e8 c9 ff ff ff       	call   1001cb <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100202:	e8 f9 fe ff ff       	call   100100 <lab1_print_cur_status>
}
  100207:	c9                   	leave  
  100208:	c3                   	ret    

00100209 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100209:	55                   	push   %ebp
  10020a:	89 e5                	mov    %esp,%ebp
  10020c:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10020f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100213:	74 13                	je     100228 <readline+0x1f>
        cprintf("%s", prompt);
  100215:	8b 45 08             	mov    0x8(%ebp),%eax
  100218:	89 44 24 04          	mov    %eax,0x4(%esp)
  10021c:	c7 04 24 67 35 10 00 	movl   $0x103567,(%esp)
  100223:	e8 ea 00 00 00       	call   100312 <cprintf>
    }
    int i = 0, c;
  100228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10022f:	e8 66 01 00 00       	call   10039a <getchar>
  100234:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10023b:	79 07                	jns    100244 <readline+0x3b>
            return NULL;
  10023d:	b8 00 00 00 00       	mov    $0x0,%eax
  100242:	eb 79                	jmp    1002bd <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100244:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100248:	7e 28                	jle    100272 <readline+0x69>
  10024a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100251:	7f 1f                	jg     100272 <readline+0x69>
            cputchar(c);
  100253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100256:	89 04 24             	mov    %eax,(%esp)
  100259:	e8 da 00 00 00       	call   100338 <cputchar>
            buf[i ++] = c;
  10025e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100261:	8d 50 01             	lea    0x1(%eax),%edx
  100264:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100267:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10026a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100270:	eb 46                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100272:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100276:	75 17                	jne    10028f <readline+0x86>
  100278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10027c:	7e 11                	jle    10028f <readline+0x86>
            cputchar(c);
  10027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100281:	89 04 24             	mov    %eax,(%esp)
  100284:	e8 af 00 00 00       	call   100338 <cputchar>
            i --;
  100289:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10028d:	eb 29                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10028f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100293:	74 06                	je     10029b <readline+0x92>
  100295:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100299:	75 1d                	jne    1002b8 <readline+0xaf>
            cputchar(c);
  10029b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029e:	89 04 24             	mov    %eax,(%esp)
  1002a1:	e8 92 00 00 00       	call   100338 <cputchar>
            buf[i] = '\0';
  1002a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002a9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002ae:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002b6:	eb 05                	jmp    1002bd <readline+0xb4>
        }
    }
  1002b8:	e9 72 ff ff ff       	jmp    10022f <readline+0x26>
}
  1002bd:	c9                   	leave  
  1002be:	c3                   	ret    

001002bf <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002bf:	55                   	push   %ebp
  1002c0:	89 e5                	mov    %esp,%ebp
  1002c2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 d2 12 00 00       	call   1015a2 <cons_putc>
    (*cnt) ++;
  1002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d3:	8b 00                	mov    (%eax),%eax
  1002d5:	8d 50 01             	lea    0x1(%eax),%edx
  1002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002db:	89 10                	mov    %edx,(%eax)
}
  1002dd:	c9                   	leave  
  1002de:	c3                   	ret    

001002df <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002df:	55                   	push   %ebp
  1002e0:	89 e5                	mov    %esp,%ebp
  1002e2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100301:	c7 04 24 bf 02 10 00 	movl   $0x1002bf,(%esp)
  100308:	e8 2d 28 00 00       	call   102b3a <vprintfmt>
    return cnt;
  10030d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100310:	c9                   	leave  
  100311:	c3                   	ret    

00100312 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100312:	55                   	push   %ebp
  100313:	89 e5                	mov    %esp,%ebp
  100315:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100318:	8d 45 0c             	lea    0xc(%ebp),%eax
  10031b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10031e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100321:	89 44 24 04          	mov    %eax,0x4(%esp)
  100325:	8b 45 08             	mov    0x8(%ebp),%eax
  100328:	89 04 24             	mov    %eax,(%esp)
  10032b:	e8 af ff ff ff       	call   1002df <vcprintf>
  100330:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100333:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100336:	c9                   	leave  
  100337:	c3                   	ret    

00100338 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100338:	55                   	push   %ebp
  100339:	89 e5                	mov    %esp,%ebp
  10033b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10033e:	8b 45 08             	mov    0x8(%ebp),%eax
  100341:	89 04 24             	mov    %eax,(%esp)
  100344:	e8 59 12 00 00       	call   1015a2 <cons_putc>
}
  100349:	c9                   	leave  
  10034a:	c3                   	ret    

0010034b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100351:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100358:	eb 13                	jmp    10036d <cputs+0x22>
        cputch(c, &cnt);
  10035a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10035e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100361:	89 54 24 04          	mov    %edx,0x4(%esp)
  100365:	89 04 24             	mov    %eax,(%esp)
  100368:	e8 52 ff ff ff       	call   1002bf <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10036d:	8b 45 08             	mov    0x8(%ebp),%eax
  100370:	8d 50 01             	lea    0x1(%eax),%edx
  100373:	89 55 08             	mov    %edx,0x8(%ebp)
  100376:	0f b6 00             	movzbl (%eax),%eax
  100379:	88 45 f7             	mov    %al,-0x9(%ebp)
  10037c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100380:	75 d8                	jne    10035a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100382:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100385:	89 44 24 04          	mov    %eax,0x4(%esp)
  100389:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100390:	e8 2a ff ff ff       	call   1002bf <cputch>
    return cnt;
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100398:	c9                   	leave  
  100399:	c3                   	ret    

0010039a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10039a:	55                   	push   %ebp
  10039b:	89 e5                	mov    %esp,%ebp
  10039d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003a0:	e8 26 12 00 00       	call   1015cb <cons_getc>
  1003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ac:	74 f2                	je     1003a0 <getchar+0x6>
        /* do nothing */;
    return c;
  1003ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003bc:	8b 00                	mov    (%eax),%eax
  1003be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003c4:	8b 00                	mov    (%eax),%eax
  1003c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003d0:	e9 d2 00 00 00       	jmp    1004a7 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003db:	01 d0                	add    %edx,%eax
  1003dd:	89 c2                	mov    %eax,%edx
  1003df:	c1 ea 1f             	shr    $0x1f,%edx
  1003e2:	01 d0                	add    %edx,%eax
  1003e4:	d1 f8                	sar    %eax
  1003e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003ec:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ef:	eb 04                	jmp    1003f5 <stab_binsearch+0x42>
            m --;
  1003f1:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1003fb:	7c 1f                	jl     10041c <stab_binsearch+0x69>
  1003fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100400:	89 d0                	mov    %edx,%eax
  100402:	01 c0                	add    %eax,%eax
  100404:	01 d0                	add    %edx,%eax
  100406:	c1 e0 02             	shl    $0x2,%eax
  100409:	89 c2                	mov    %eax,%edx
  10040b:	8b 45 08             	mov    0x8(%ebp),%eax
  10040e:	01 d0                	add    %edx,%eax
  100410:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100414:	0f b6 c0             	movzbl %al,%eax
  100417:	3b 45 14             	cmp    0x14(%ebp),%eax
  10041a:	75 d5                	jne    1003f1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100422:	7d 0b                	jge    10042f <stab_binsearch+0x7c>
            l = true_m + 1;
  100424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100427:	83 c0 01             	add    $0x1,%eax
  10042a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10042d:	eb 78                	jmp    1004a7 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10042f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100439:	89 d0                	mov    %edx,%eax
  10043b:	01 c0                	add    %eax,%eax
  10043d:	01 d0                	add    %edx,%eax
  10043f:	c1 e0 02             	shl    $0x2,%eax
  100442:	89 c2                	mov    %eax,%edx
  100444:	8b 45 08             	mov    0x8(%ebp),%eax
  100447:	01 d0                	add    %edx,%eax
  100449:	8b 40 08             	mov    0x8(%eax),%eax
  10044c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10044f:	73 13                	jae    100464 <stab_binsearch+0xb1>
            *region_left = m;
  100451:	8b 45 0c             	mov    0xc(%ebp),%eax
  100454:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100457:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045c:	83 c0 01             	add    $0x1,%eax
  10045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100462:	eb 43                	jmp    1004a7 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100467:	89 d0                	mov    %edx,%eax
  100469:	01 c0                	add    %eax,%eax
  10046b:	01 d0                	add    %edx,%eax
  10046d:	c1 e0 02             	shl    $0x2,%eax
  100470:	89 c2                	mov    %eax,%edx
  100472:	8b 45 08             	mov    0x8(%ebp),%eax
  100475:	01 d0                	add    %edx,%eax
  100477:	8b 40 08             	mov    0x8(%eax),%eax
  10047a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10047d:	76 16                	jbe    100495 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10047f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100482:	8d 50 ff             	lea    -0x1(%eax),%edx
  100485:	8b 45 10             	mov    0x10(%ebp),%eax
  100488:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10048d:	83 e8 01             	sub    $0x1,%eax
  100490:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100493:	eb 12                	jmp    1004a7 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100495:	8b 45 0c             	mov    0xc(%ebp),%eax
  100498:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049b:	89 10                	mov    %edx,(%eax)
            l = m;
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a3:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004ad:	0f 8e 22 ff ff ff    	jle    1003d5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004b7:	75 0f                	jne    1004c8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bc:	8b 00                	mov    (%eax),%eax
  1004be:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c4:	89 10                	mov    %edx,(%eax)
  1004c6:	eb 3f                	jmp    100507 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004cb:	8b 00                	mov    (%eax),%eax
  1004cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004d0:	eb 04                	jmp    1004d6 <stab_binsearch+0x123>
  1004d2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d9:	8b 00                	mov    (%eax),%eax
  1004db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004de:	7d 1f                	jge    1004ff <stab_binsearch+0x14c>
  1004e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e3:	89 d0                	mov    %edx,%eax
  1004e5:	01 c0                	add    %eax,%eax
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	c1 e0 02             	shl    $0x2,%eax
  1004ec:	89 c2                	mov    %eax,%edx
  1004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f1:	01 d0                	add    %edx,%eax
  1004f3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f7:	0f b6 c0             	movzbl %al,%eax
  1004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004fd:	75 d3                	jne    1004d2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100505:	89 10                	mov    %edx,(%eax)
    }
}
  100507:	c9                   	leave  
  100508:	c3                   	ret    

00100509 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100509:	55                   	push   %ebp
  10050a:	89 e5                	mov    %esp,%ebp
  10050c:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100512:	c7 00 6c 35 10 00    	movl   $0x10356c,(%eax)
    info->eip_line = 0;
  100518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100522:	8b 45 0c             	mov    0xc(%ebp),%eax
  100525:	c7 40 08 6c 35 10 00 	movl   $0x10356c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100536:	8b 45 0c             	mov    0xc(%ebp),%eax
  100539:	8b 55 08             	mov    0x8(%ebp),%edx
  10053c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10053f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100542:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100549:	c7 45 f4 ec 3d 10 00 	movl   $0x103dec,-0xc(%ebp)
    stab_end = __STAB_END__;
  100550:	c7 45 f0 68 b5 10 00 	movl   $0x10b568,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100557:	c7 45 ec 69 b5 10 00 	movl   $0x10b569,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055e:	c7 45 e8 54 d5 10 00 	movl   $0x10d554,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100568:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10056b:	76 0d                	jbe    10057a <debuginfo_eip+0x71>
  10056d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100570:	83 e8 01             	sub    $0x1,%eax
  100573:	0f b6 00             	movzbl (%eax),%eax
  100576:	84 c0                	test   %al,%al
  100578:	74 0a                	je     100584 <debuginfo_eip+0x7b>
        return -1;
  10057a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10057f:	e9 c0 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100584:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100591:	29 c2                	sub    %eax,%edx
  100593:	89 d0                	mov    %edx,%eax
  100595:	c1 f8 02             	sar    $0x2,%eax
  100598:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10059e:	83 e8 01             	sub    $0x1,%eax
  1005a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005ab:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005b2:	00 
  1005b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c4:	89 04 24             	mov    %eax,(%esp)
  1005c7:	e8 e7 fd ff ff       	call   1003b3 <stab_binsearch>
    if (lfile == 0)
  1005cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005cf:	85 c0                	test   %eax,%eax
  1005d1:	75 0a                	jne    1005dd <debuginfo_eip+0xd4>
        return -1;
  1005d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005d8:	e9 67 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f0:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1005f7:	00 
  1005f8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100602:	89 44 24 04          	mov    %eax,0x4(%esp)
  100606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100609:	89 04 24             	mov    %eax,(%esp)
  10060c:	e8 a2 fd ff ff       	call   1003b3 <stab_binsearch>

    if (lfun <= rfun) {
  100611:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100614:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100617:	39 c2                	cmp    %eax,%edx
  100619:	7f 7c                	jg     100697 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10061b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10061e:	89 c2                	mov    %eax,%edx
  100620:	89 d0                	mov    %edx,%eax
  100622:	01 c0                	add    %eax,%eax
  100624:	01 d0                	add    %edx,%eax
  100626:	c1 e0 02             	shl    $0x2,%eax
  100629:	89 c2                	mov    %eax,%edx
  10062b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10062e:	01 d0                	add    %edx,%eax
  100630:	8b 10                	mov    (%eax),%edx
  100632:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100638:	29 c1                	sub    %eax,%ecx
  10063a:	89 c8                	mov    %ecx,%eax
  10063c:	39 c2                	cmp    %eax,%edx
  10063e:	73 22                	jae    100662 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100643:	89 c2                	mov    %eax,%edx
  100645:	89 d0                	mov    %edx,%eax
  100647:	01 c0                	add    %eax,%eax
  100649:	01 d0                	add    %edx,%eax
  10064b:	c1 e0 02             	shl    $0x2,%eax
  10064e:	89 c2                	mov    %eax,%edx
  100650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100653:	01 d0                	add    %edx,%eax
  100655:	8b 10                	mov    (%eax),%edx
  100657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10065a:	01 c2                	add    %eax,%edx
  10065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100662:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100665:	89 c2                	mov    %eax,%edx
  100667:	89 d0                	mov    %edx,%eax
  100669:	01 c0                	add    %eax,%eax
  10066b:	01 d0                	add    %edx,%eax
  10066d:	c1 e0 02             	shl    $0x2,%eax
  100670:	89 c2                	mov    %eax,%edx
  100672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100675:	01 d0                	add    %edx,%eax
  100677:	8b 50 08             	mov    0x8(%eax),%edx
  10067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	8b 40 10             	mov    0x10(%eax),%eax
  100686:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100689:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10068f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100692:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100695:	eb 15                	jmp    1006ac <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100697:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069a:	8b 55 08             	mov    0x8(%ebp),%edx
  10069d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006af:	8b 40 08             	mov    0x8(%eax),%eax
  1006b2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006b9:	00 
  1006ba:	89 04 24             	mov    %eax,(%esp)
  1006bd:	e8 d3 2a 00 00       	call   103195 <strfind>
  1006c2:	89 c2                	mov    %eax,%edx
  1006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c7:	8b 40 08             	mov    0x8(%eax),%eax
  1006ca:	29 c2                	sub    %eax,%edx
  1006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cf:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006d9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e0:	00 
  1006e1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f2:	89 04 24             	mov    %eax,(%esp)
  1006f5:	e8 b9 fc ff ff       	call   1003b3 <stab_binsearch>
    if (lline <= rline) {
  1006fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100700:	39 c2                	cmp    %eax,%edx
  100702:	7f 24                	jg     100728 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100704:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100707:	89 c2                	mov    %eax,%edx
  100709:	89 d0                	mov    %edx,%eax
  10070b:	01 c0                	add    %eax,%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	c1 e0 02             	shl    $0x2,%eax
  100712:	89 c2                	mov    %eax,%edx
  100714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100717:	01 d0                	add    %edx,%eax
  100719:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10071d:	0f b7 d0             	movzwl %ax,%edx
  100720:	8b 45 0c             	mov    0xc(%ebp),%eax
  100723:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100726:	eb 13                	jmp    10073b <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10072d:	e9 12 01 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100735:	83 e8 01             	sub    $0x1,%eax
  100738:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10073e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100741:	39 c2                	cmp    %eax,%edx
  100743:	7c 56                	jl     10079b <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	89 d0                	mov    %edx,%eax
  10074c:	01 c0                	add    %eax,%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	c1 e0 02             	shl    $0x2,%eax
  100753:	89 c2                	mov    %eax,%edx
  100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100758:	01 d0                	add    %edx,%eax
  10075a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10075e:	3c 84                	cmp    $0x84,%al
  100760:	74 39                	je     10079b <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100762:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100765:	89 c2                	mov    %eax,%edx
  100767:	89 d0                	mov    %edx,%eax
  100769:	01 c0                	add    %eax,%eax
  10076b:	01 d0                	add    %edx,%eax
  10076d:	c1 e0 02             	shl    $0x2,%eax
  100770:	89 c2                	mov    %eax,%edx
  100772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077b:	3c 64                	cmp    $0x64,%al
  10077d:	75 b3                	jne    100732 <debuginfo_eip+0x229>
  10077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100782:	89 c2                	mov    %eax,%edx
  100784:	89 d0                	mov    %edx,%eax
  100786:	01 c0                	add    %eax,%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	c1 e0 02             	shl    $0x2,%eax
  10078d:	89 c2                	mov    %eax,%edx
  10078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100792:	01 d0                	add    %edx,%eax
  100794:	8b 40 08             	mov    0x8(%eax),%eax
  100797:	85 c0                	test   %eax,%eax
  100799:	74 97                	je     100732 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10079b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10079e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a1:	39 c2                	cmp    %eax,%edx
  1007a3:	7c 46                	jl     1007eb <debuginfo_eip+0x2e2>
  1007a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007a8:	89 c2                	mov    %eax,%edx
  1007aa:	89 d0                	mov    %edx,%eax
  1007ac:	01 c0                	add    %eax,%eax
  1007ae:	01 d0                	add    %edx,%eax
  1007b0:	c1 e0 02             	shl    $0x2,%eax
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	8b 10                	mov    (%eax),%edx
  1007bc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007c2:	29 c1                	sub    %eax,%ecx
  1007c4:	89 c8                	mov    %ecx,%eax
  1007c6:	39 c2                	cmp    %eax,%edx
  1007c8:	73 21                	jae    1007eb <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007cd:	89 c2                	mov    %eax,%edx
  1007cf:	89 d0                	mov    %edx,%eax
  1007d1:	01 c0                	add    %eax,%eax
  1007d3:	01 d0                	add    %edx,%eax
  1007d5:	c1 e0 02             	shl    $0x2,%eax
  1007d8:	89 c2                	mov    %eax,%edx
  1007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dd:	01 d0                	add    %edx,%eax
  1007df:	8b 10                	mov    (%eax),%edx
  1007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e4:	01 c2                	add    %eax,%edx
  1007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f1:	39 c2                	cmp    %eax,%edx
  1007f3:	7d 4a                	jge    10083f <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1007f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007f8:	83 c0 01             	add    $0x1,%eax
  1007fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007fe:	eb 18                	jmp    100818 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100800:	8b 45 0c             	mov    0xc(%ebp),%eax
  100803:	8b 40 14             	mov    0x14(%eax),%eax
  100806:	8d 50 01             	lea    0x1(%eax),%edx
  100809:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10080f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100812:	83 c0 01             	add    $0x1,%eax
  100815:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100818:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10081e:	39 c2                	cmp    %eax,%edx
  100820:	7d 1d                	jge    10083f <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100825:	89 c2                	mov    %eax,%edx
  100827:	89 d0                	mov    %edx,%eax
  100829:	01 c0                	add    %eax,%eax
  10082b:	01 d0                	add    %edx,%eax
  10082d:	c1 e0 02             	shl    $0x2,%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100835:	01 d0                	add    %edx,%eax
  100837:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10083b:	3c a0                	cmp    $0xa0,%al
  10083d:	74 c1                	je     100800 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10083f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100844:	c9                   	leave  
  100845:	c3                   	ret    

00100846 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100846:	55                   	push   %ebp
  100847:	89 e5                	mov    %esp,%ebp
  100849:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10084c:	c7 04 24 76 35 10 00 	movl   $0x103576,(%esp)
  100853:	e8 ba fa ff ff       	call   100312 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100858:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085f:	00 
  100860:	c7 04 24 8f 35 10 00 	movl   $0x10358f,(%esp)
  100867:	e8 a6 fa ff ff       	call   100312 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10086c:	c7 44 24 04 aa 34 10 	movl   $0x1034aa,0x4(%esp)
  100873:	00 
  100874:	c7 04 24 a7 35 10 00 	movl   $0x1035a7,(%esp)
  10087b:	e8 92 fa ff ff       	call   100312 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100880:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100887:	00 
  100888:	c7 04 24 bf 35 10 00 	movl   $0x1035bf,(%esp)
  10088f:	e8 7e fa ff ff       	call   100312 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100894:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  10089b:	00 
  10089c:	c7 04 24 d7 35 10 00 	movl   $0x1035d7,(%esp)
  1008a3:	e8 6a fa ff ff       	call   100312 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008a8:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  1008ad:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008b3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008b8:	29 c2                	sub    %eax,%edx
  1008ba:	89 d0                	mov    %edx,%eax
  1008bc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c2:	85 c0                	test   %eax,%eax
  1008c4:	0f 48 c2             	cmovs  %edx,%eax
  1008c7:	c1 f8 0a             	sar    $0xa,%eax
  1008ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ce:	c7 04 24 f0 35 10 00 	movl   $0x1035f0,(%esp)
  1008d5:	e8 38 fa ff ff       	call   100312 <cprintf>
}
  1008da:	c9                   	leave  
  1008db:	c3                   	ret    

001008dc <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008dc:	55                   	push   %ebp
  1008dd:	89 e5                	mov    %esp,%ebp
  1008df:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ef:	89 04 24             	mov    %eax,(%esp)
  1008f2:	e8 12 fc ff ff       	call   100509 <debuginfo_eip>
  1008f7:	85 c0                	test   %eax,%eax
  1008f9:	74 15                	je     100910 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1008fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100902:	c7 04 24 1a 36 10 00 	movl   $0x10361a,(%esp)
  100909:	e8 04 fa ff ff       	call   100312 <cprintf>
  10090e:	eb 6d                	jmp    10097d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100917:	eb 1c                	jmp    100935 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100919:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10091c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10091f:	01 d0                	add    %edx,%eax
  100921:	0f b6 00             	movzbl (%eax),%eax
  100924:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10092a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10092d:	01 ca                	add    %ecx,%edx
  10092f:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100931:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100938:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10093b:	7f dc                	jg     100919 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10093d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10094b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10094e:	8b 55 08             	mov    0x8(%ebp),%edx
  100951:	89 d1                	mov    %edx,%ecx
  100953:	29 c1                	sub    %eax,%ecx
  100955:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100958:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10095b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10095f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100965:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100969:	89 54 24 08          	mov    %edx,0x8(%esp)
  10096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100971:	c7 04 24 36 36 10 00 	movl   $0x103636,(%esp)
  100978:	e8 95 f9 ff ff       	call   100312 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10097d:	c9                   	leave  
  10097e:	c3                   	ret    

0010097f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10097f:	55                   	push   %ebp
  100980:	89 e5                	mov    %esp,%ebp
  100982:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100985:	8b 45 04             	mov    0x4(%ebp),%eax
  100988:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10098b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10098e:	c9                   	leave  
  10098f:	c3                   	ret    

00100990 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100990:	55                   	push   %ebp
  100991:	89 e5                	mov    %esp,%ebp
  100993:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100996:	89 e8                	mov    %ebp,%eax
  100998:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  10099b:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(); //(1) call read_ebp() to get the value of ebp. the type is (uint32_t);
  10099e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip = read_eip(); //(2) call read_eip() to get the value of eip. the type is (uint32_t);
  1009a1:	e8 d9 ff ff ff       	call   10097f <read_eip>
  1009a6:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i = 0;
  1009a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(ebp != 0 && i < STACKFRAME_DEPTH) {
  1009b0:	e9 88 00 00 00       	jmp    100a3d <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);       //(3.1) printf value of ebp, eip
  1009b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009c3:	c7 04 24 48 36 10 00 	movl   $0x103648,(%esp)
  1009ca:	e8 43 f9 ff ff       	call   100312 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;      // (3.2) (uint32_t)calling arguments [0..4] = the contents in address (uint32_t)ebp +2 [0..4]                           
  1009cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d2:	83 c0 08             	add    $0x8,%eax
  1009d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        int j = 0;
  1009d8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
        while(j < 4){           
  1009df:	eb 25                	jmp    100a06 <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
  1009e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1009ee:	01 d0                	add    %edx,%eax
  1009f0:	8b 00                	mov    (%eax),%eax
  1009f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f6:	c7 04 24 64 36 10 00 	movl   $0x103664,(%esp)
  1009fd:	e8 10 f9 ff ff       	call   100312 <cprintf>
            j ++;
  100a02:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    int i = 0;
    while(ebp != 0 && i < STACKFRAME_DEPTH) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);       //(3.1) printf value of ebp, eip
        uint32_t *args = (uint32_t *)ebp + 2;      // (3.2) (uint32_t)calling arguments [0..4] = the contents in address (uint32_t)ebp +2 [0..4]                           
        int j = 0;
        while(j < 4){           
  100a06:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a0a:	7e d5                	jle    1009e1 <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
            j ++;
        }
        cprintf("\n");      //(3.3) cprintf("\n");
  100a0c:	c7 04 24 6c 36 10 00 	movl   $0x10366c,(%esp)
  100a13:	e8 fa f8 ff ff       	call   100312 <cprintf>
        print_debuginfo(eip - 1);//(3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
  100a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a1b:	83 e8 01             	sub    $0x1,%eax
  100a1e:	89 04 24             	mov    %eax,(%esp)
  100a21:	e8 b6 fe ff ff       	call   1008dc <print_debuginfo>
        eip = ((uint32_t *)ebp)[1]; //(3.5) popup a calling stackframe
  100a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a29:	83 c0 04             	add    $0x4,%eax
  100a2c:	8b 00                	mov    (%eax),%eax
  100a2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0]; 
  100a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a34:	8b 00                	mov    (%eax),%eax
  100a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
        i++;
  100a39:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
      */
    uint32_t ebp = read_ebp(); //(1) call read_ebp() to get the value of ebp. the type is (uint32_t);
    uint32_t eip = read_eip(); //(2) call read_eip() to get the value of eip. the type is (uint32_t);

    int i = 0;
    while(ebp != 0 && i < STACKFRAME_DEPTH) {
  100a3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a41:	74 0a                	je     100a4d <print_stackframe+0xbd>
  100a43:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a47:	0f 8e 68 ff ff ff    	jle    1009b5 <print_stackframe+0x25>
        print_debuginfo(eip - 1);//(3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
        eip = ((uint32_t *)ebp)[1]; //(3.5) popup a calling stackframe
        ebp = ((uint32_t *)ebp)[0]; 
        i++;
    }
}
  100a4d:	c9                   	leave  
  100a4e:	c3                   	ret    

00100a4f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a4f:	55                   	push   %ebp
  100a50:	89 e5                	mov    %esp,%ebp
  100a52:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a5c:	eb 0c                	jmp    100a6a <parse+0x1b>
            *buf ++ = '\0';
  100a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  100a61:	8d 50 01             	lea    0x1(%eax),%edx
  100a64:	89 55 08             	mov    %edx,0x8(%ebp)
  100a67:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  100a6d:	0f b6 00             	movzbl (%eax),%eax
  100a70:	84 c0                	test   %al,%al
  100a72:	74 1d                	je     100a91 <parse+0x42>
  100a74:	8b 45 08             	mov    0x8(%ebp),%eax
  100a77:	0f b6 00             	movzbl (%eax),%eax
  100a7a:	0f be c0             	movsbl %al,%eax
  100a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a81:	c7 04 24 f0 36 10 00 	movl   $0x1036f0,(%esp)
  100a88:	e8 d5 26 00 00       	call   103162 <strchr>
  100a8d:	85 c0                	test   %eax,%eax
  100a8f:	75 cd                	jne    100a5e <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a91:	8b 45 08             	mov    0x8(%ebp),%eax
  100a94:	0f b6 00             	movzbl (%eax),%eax
  100a97:	84 c0                	test   %al,%al
  100a99:	75 02                	jne    100a9d <parse+0x4e>
            break;
  100a9b:	eb 67                	jmp    100b04 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a9d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100aa1:	75 14                	jne    100ab7 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100aa3:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100aaa:	00 
  100aab:	c7 04 24 f5 36 10 00 	movl   $0x1036f5,(%esp)
  100ab2:	e8 5b f8 ff ff       	call   100312 <cprintf>
        }
        argv[argc ++] = buf;
  100ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aba:	8d 50 01             	lea    0x1(%eax),%edx
  100abd:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ac0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
  100aca:	01 c2                	add    %eax,%edx
  100acc:	8b 45 08             	mov    0x8(%ebp),%eax
  100acf:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ad1:	eb 04                	jmp    100ad7 <parse+0x88>
            buf ++;
  100ad3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  100ada:	0f b6 00             	movzbl (%eax),%eax
  100add:	84 c0                	test   %al,%al
  100adf:	74 1d                	je     100afe <parse+0xaf>
  100ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae4:	0f b6 00             	movzbl (%eax),%eax
  100ae7:	0f be c0             	movsbl %al,%eax
  100aea:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aee:	c7 04 24 f0 36 10 00 	movl   $0x1036f0,(%esp)
  100af5:	e8 68 26 00 00       	call   103162 <strchr>
  100afa:	85 c0                	test   %eax,%eax
  100afc:	74 d5                	je     100ad3 <parse+0x84>
            buf ++;
        }
    }
  100afe:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100aff:	e9 66 ff ff ff       	jmp    100a6a <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b07:	c9                   	leave  
  100b08:	c3                   	ret    

00100b09 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b09:	55                   	push   %ebp
  100b0a:	89 e5                	mov    %esp,%ebp
  100b0c:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b0f:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b12:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b16:	8b 45 08             	mov    0x8(%ebp),%eax
  100b19:	89 04 24             	mov    %eax,(%esp)
  100b1c:	e8 2e ff ff ff       	call   100a4f <parse>
  100b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b28:	75 0a                	jne    100b34 <runcmd+0x2b>
        return 0;
  100b2a:	b8 00 00 00 00       	mov    $0x0,%eax
  100b2f:	e9 85 00 00 00       	jmp    100bb9 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b3b:	eb 5c                	jmp    100b99 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b3d:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b43:	89 d0                	mov    %edx,%eax
  100b45:	01 c0                	add    %eax,%eax
  100b47:	01 d0                	add    %edx,%eax
  100b49:	c1 e0 02             	shl    $0x2,%eax
  100b4c:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b51:	8b 00                	mov    (%eax),%eax
  100b53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b57:	89 04 24             	mov    %eax,(%esp)
  100b5a:	e8 64 25 00 00       	call   1030c3 <strcmp>
  100b5f:	85 c0                	test   %eax,%eax
  100b61:	75 32                	jne    100b95 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b66:	89 d0                	mov    %edx,%eax
  100b68:	01 c0                	add    %eax,%eax
  100b6a:	01 d0                	add    %edx,%eax
  100b6c:	c1 e0 02             	shl    $0x2,%eax
  100b6f:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b74:	8b 40 08             	mov    0x8(%eax),%eax
  100b77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b7a:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b80:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b84:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b87:	83 c2 04             	add    $0x4,%edx
  100b8a:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b8e:	89 0c 24             	mov    %ecx,(%esp)
  100b91:	ff d0                	call   *%eax
  100b93:	eb 24                	jmp    100bb9 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b95:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b9c:	83 f8 02             	cmp    $0x2,%eax
  100b9f:	76 9c                	jbe    100b3d <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100ba1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ba8:	c7 04 24 13 37 10 00 	movl   $0x103713,(%esp)
  100baf:	e8 5e f7 ff ff       	call   100312 <cprintf>
    return 0;
  100bb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bb9:	c9                   	leave  
  100bba:	c3                   	ret    

00100bbb <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bbb:	55                   	push   %ebp
  100bbc:	89 e5                	mov    %esp,%ebp
  100bbe:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bc1:	c7 04 24 2c 37 10 00 	movl   $0x10372c,(%esp)
  100bc8:	e8 45 f7 ff ff       	call   100312 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bcd:	c7 04 24 54 37 10 00 	movl   $0x103754,(%esp)
  100bd4:	e8 39 f7 ff ff       	call   100312 <cprintf>

    if (tf != NULL) {
  100bd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bdd:	74 0b                	je     100bea <kmonitor+0x2f>
        print_trapframe(tf);
  100bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  100be2:	89 04 24             	mov    %eax,(%esp)
  100be5:	e8 04 0e 00 00       	call   1019ee <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bea:	c7 04 24 79 37 10 00 	movl   $0x103779,(%esp)
  100bf1:	e8 13 f6 ff ff       	call   100209 <readline>
  100bf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100bfd:	74 18                	je     100c17 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100bff:	8b 45 08             	mov    0x8(%ebp),%eax
  100c02:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c09:	89 04 24             	mov    %eax,(%esp)
  100c0c:	e8 f8 fe ff ff       	call   100b09 <runcmd>
  100c11:	85 c0                	test   %eax,%eax
  100c13:	79 02                	jns    100c17 <kmonitor+0x5c>
                break;
  100c15:	eb 02                	jmp    100c19 <kmonitor+0x5e>
            }
        }
    }
  100c17:	eb d1                	jmp    100bea <kmonitor+0x2f>
}
  100c19:	c9                   	leave  
  100c1a:	c3                   	ret    

00100c1b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c1b:	55                   	push   %ebp
  100c1c:	89 e5                	mov    %esp,%ebp
  100c1e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c28:	eb 3f                	jmp    100c69 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c2d:	89 d0                	mov    %edx,%eax
  100c2f:	01 c0                	add    %eax,%eax
  100c31:	01 d0                	add    %edx,%eax
  100c33:	c1 e0 02             	shl    $0x2,%eax
  100c36:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c3b:	8b 48 04             	mov    0x4(%eax),%ecx
  100c3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c41:	89 d0                	mov    %edx,%eax
  100c43:	01 c0                	add    %eax,%eax
  100c45:	01 d0                	add    %edx,%eax
  100c47:	c1 e0 02             	shl    $0x2,%eax
  100c4a:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c4f:	8b 00                	mov    (%eax),%eax
  100c51:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c55:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c59:	c7 04 24 7d 37 10 00 	movl   $0x10377d,(%esp)
  100c60:	e8 ad f6 ff ff       	call   100312 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c6c:	83 f8 02             	cmp    $0x2,%eax
  100c6f:	76 b9                	jbe    100c2a <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c76:	c9                   	leave  
  100c77:	c3                   	ret    

00100c78 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c78:	55                   	push   %ebp
  100c79:	89 e5                	mov    %esp,%ebp
  100c7b:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c7e:	e8 c3 fb ff ff       	call   100846 <print_kerninfo>
    return 0;
  100c83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c88:	c9                   	leave  
  100c89:	c3                   	ret    

00100c8a <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c8a:	55                   	push   %ebp
  100c8b:	89 e5                	mov    %esp,%ebp
  100c8d:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c90:	e8 fb fc ff ff       	call   100990 <print_stackframe>
    return 0;
  100c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c9a:	c9                   	leave  
  100c9b:	c3                   	ret    

00100c9c <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c9c:	55                   	push   %ebp
  100c9d:	89 e5                	mov    %esp,%ebp
  100c9f:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ca2:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100ca7:	85 c0                	test   %eax,%eax
  100ca9:	74 02                	je     100cad <__panic+0x11>
        goto panic_dead;
  100cab:	eb 59                	jmp    100d06 <__panic+0x6a>
    }
    is_panic = 1;
  100cad:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100cb4:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cb7:	8d 45 14             	lea    0x14(%ebp),%eax
  100cba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cc0:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  100cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ccb:	c7 04 24 86 37 10 00 	movl   $0x103786,(%esp)
  100cd2:	e8 3b f6 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cda:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cde:	8b 45 10             	mov    0x10(%ebp),%eax
  100ce1:	89 04 24             	mov    %eax,(%esp)
  100ce4:	e8 f6 f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100ce9:	c7 04 24 a2 37 10 00 	movl   $0x1037a2,(%esp)
  100cf0:	e8 1d f6 ff ff       	call   100312 <cprintf>
    
    cprintf("stack trackback:\n");
  100cf5:	c7 04 24 a4 37 10 00 	movl   $0x1037a4,(%esp)
  100cfc:	e8 11 f6 ff ff       	call   100312 <cprintf>
    print_stackframe();
  100d01:	e8 8a fc ff ff       	call   100990 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d06:	e8 22 09 00 00       	call   10162d <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d0b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d12:	e8 a4 fe ff ff       	call   100bbb <kmonitor>
    }
  100d17:	eb f2                	jmp    100d0b <__panic+0x6f>

00100d19 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d19:	55                   	push   %ebp
  100d1a:	89 e5                	mov    %esp,%ebp
  100d1c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d1f:	8d 45 14             	lea    0x14(%ebp),%eax
  100d22:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d28:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  100d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d33:	c7 04 24 b6 37 10 00 	movl   $0x1037b6,(%esp)
  100d3a:	e8 d3 f5 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d42:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d46:	8b 45 10             	mov    0x10(%ebp),%eax
  100d49:	89 04 24             	mov    %eax,(%esp)
  100d4c:	e8 8e f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100d51:	c7 04 24 a2 37 10 00 	movl   $0x1037a2,(%esp)
  100d58:	e8 b5 f5 ff ff       	call   100312 <cprintf>
    va_end(ap);
}
  100d5d:	c9                   	leave  
  100d5e:	c3                   	ret    

00100d5f <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d5f:	55                   	push   %ebp
  100d60:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d62:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d67:	5d                   	pop    %ebp
  100d68:	c3                   	ret    

00100d69 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d69:	55                   	push   %ebp
  100d6a:	89 e5                	mov    %esp,%ebp
  100d6c:	83 ec 28             	sub    $0x28,%esp
  100d6f:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d75:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d79:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d7d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d81:	ee                   	out    %al,(%dx)
  100d82:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d88:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d8c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d90:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d94:	ee                   	out    %al,(%dx)
  100d95:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d9b:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d9f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100da3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100da7:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100da8:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100daf:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100db2:	c7 04 24 d4 37 10 00 	movl   $0x1037d4,(%esp)
  100db9:	e8 54 f5 ff ff       	call   100312 <cprintf>
    pic_enable(IRQ_TIMER);
  100dbe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dc5:	e8 c1 08 00 00       	call   10168b <pic_enable>
}
  100dca:	c9                   	leave  
  100dcb:	c3                   	ret    

00100dcc <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dcc:	55                   	push   %ebp
  100dcd:	89 e5                	mov    %esp,%ebp
  100dcf:	83 ec 10             	sub    $0x10,%esp
  100dd2:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dd8:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100ddc:	89 c2                	mov    %eax,%edx
  100dde:	ec                   	in     (%dx),%al
  100ddf:	88 45 fd             	mov    %al,-0x3(%ebp)
  100de2:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100de8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dec:	89 c2                	mov    %eax,%edx
  100dee:	ec                   	in     (%dx),%al
  100def:	88 45 f9             	mov    %al,-0x7(%ebp)
  100df2:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100df8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100dfc:	89 c2                	mov    %eax,%edx
  100dfe:	ec                   	in     (%dx),%al
  100dff:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e02:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e08:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e0c:	89 c2                	mov    %eax,%edx
  100e0e:	ec                   	in     (%dx),%al
  100e0f:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e12:	c9                   	leave  
  100e13:	c3                   	ret    

00100e14 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e14:	55                   	push   %ebp
  100e15:	89 e5                	mov    %esp,%ebp
  100e17:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e1a:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e24:	0f b7 00             	movzwl (%eax),%eax
  100e27:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e2e:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e36:	0f b7 00             	movzwl (%eax),%eax
  100e39:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e3d:	74 12                	je     100e51 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e3f:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e46:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e4d:	b4 03 
  100e4f:	eb 13                	jmp    100e64 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e54:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e58:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e5b:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e62:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e64:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e6b:	0f b7 c0             	movzwl %ax,%eax
  100e6e:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e72:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e76:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e7a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e7e:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e7f:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e86:	83 c0 01             	add    $0x1,%eax
  100e89:	0f b7 c0             	movzwl %ax,%eax
  100e8c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e90:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e94:	89 c2                	mov    %eax,%edx
  100e96:	ec                   	in     (%dx),%al
  100e97:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e9a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e9e:	0f b6 c0             	movzbl %al,%eax
  100ea1:	c1 e0 08             	shl    $0x8,%eax
  100ea4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ea7:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eae:	0f b7 c0             	movzwl %ax,%eax
  100eb1:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100eb5:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eb9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ebd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ec1:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ec2:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ec9:	83 c0 01             	add    $0x1,%eax
  100ecc:	0f b7 c0             	movzwl %ax,%eax
  100ecf:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ed3:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ed7:	89 c2                	mov    %eax,%edx
  100ed9:	ec                   	in     (%dx),%al
  100eda:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100edd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ee1:	0f b6 c0             	movzbl %al,%eax
  100ee4:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ee7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eea:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ef2:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ef8:	c9                   	leave  
  100ef9:	c3                   	ret    

00100efa <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100efa:	55                   	push   %ebp
  100efb:	89 e5                	mov    %esp,%ebp
  100efd:	83 ec 48             	sub    $0x48,%esp
  100f00:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f06:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f0a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f0e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f12:	ee                   	out    %al,(%dx)
  100f13:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f19:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f1d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f21:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f25:	ee                   	out    %al,(%dx)
  100f26:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f2c:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f30:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f34:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f38:	ee                   	out    %al,(%dx)
  100f39:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f3f:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f43:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f47:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f4b:	ee                   	out    %al,(%dx)
  100f4c:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f52:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f56:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f5a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f5e:	ee                   	out    %al,(%dx)
  100f5f:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f65:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f69:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f6d:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f71:	ee                   	out    %al,(%dx)
  100f72:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f78:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f7c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f80:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f84:	ee                   	out    %al,(%dx)
  100f85:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f8b:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f8f:	89 c2                	mov    %eax,%edx
  100f91:	ec                   	in     (%dx),%al
  100f92:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f95:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f99:	3c ff                	cmp    $0xff,%al
  100f9b:	0f 95 c0             	setne  %al
  100f9e:	0f b6 c0             	movzbl %al,%eax
  100fa1:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100fa6:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fac:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100fb0:	89 c2                	mov    %eax,%edx
  100fb2:	ec                   	in     (%dx),%al
  100fb3:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fb6:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fbc:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fc0:	89 c2                	mov    %eax,%edx
  100fc2:	ec                   	in     (%dx),%al
  100fc3:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fc6:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fcb:	85 c0                	test   %eax,%eax
  100fcd:	74 0c                	je     100fdb <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fcf:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fd6:	e8 b0 06 00 00       	call   10168b <pic_enable>
    }
}
  100fdb:	c9                   	leave  
  100fdc:	c3                   	ret    

00100fdd <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fdd:	55                   	push   %ebp
  100fde:	89 e5                	mov    %esp,%ebp
  100fe0:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fe3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fea:	eb 09                	jmp    100ff5 <lpt_putc_sub+0x18>
        delay();
  100fec:	e8 db fd ff ff       	call   100dcc <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100ff1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100ff5:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100ffb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fff:	89 c2                	mov    %eax,%edx
  101001:	ec                   	in     (%dx),%al
  101002:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101005:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101009:	84 c0                	test   %al,%al
  10100b:	78 09                	js     101016 <lpt_putc_sub+0x39>
  10100d:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101014:	7e d6                	jle    100fec <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101016:	8b 45 08             	mov    0x8(%ebp),%eax
  101019:	0f b6 c0             	movzbl %al,%eax
  10101c:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101022:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101025:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101029:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10102d:	ee                   	out    %al,(%dx)
  10102e:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101034:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101038:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10103c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101040:	ee                   	out    %al,(%dx)
  101041:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101047:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10104b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10104f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101053:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101054:	c9                   	leave  
  101055:	c3                   	ret    

00101056 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101056:	55                   	push   %ebp
  101057:	89 e5                	mov    %esp,%ebp
  101059:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10105c:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101060:	74 0d                	je     10106f <lpt_putc+0x19>
        lpt_putc_sub(c);
  101062:	8b 45 08             	mov    0x8(%ebp),%eax
  101065:	89 04 24             	mov    %eax,(%esp)
  101068:	e8 70 ff ff ff       	call   100fdd <lpt_putc_sub>
  10106d:	eb 24                	jmp    101093 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  10106f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101076:	e8 62 ff ff ff       	call   100fdd <lpt_putc_sub>
        lpt_putc_sub(' ');
  10107b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101082:	e8 56 ff ff ff       	call   100fdd <lpt_putc_sub>
        lpt_putc_sub('\b');
  101087:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10108e:	e8 4a ff ff ff       	call   100fdd <lpt_putc_sub>
    }
}
  101093:	c9                   	leave  
  101094:	c3                   	ret    

00101095 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101095:	55                   	push   %ebp
  101096:	89 e5                	mov    %esp,%ebp
  101098:	53                   	push   %ebx
  101099:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10109c:	8b 45 08             	mov    0x8(%ebp),%eax
  10109f:	b0 00                	mov    $0x0,%al
  1010a1:	85 c0                	test   %eax,%eax
  1010a3:	75 07                	jne    1010ac <cga_putc+0x17>
        c |= 0x0700;
  1010a5:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1010af:	0f b6 c0             	movzbl %al,%eax
  1010b2:	83 f8 0a             	cmp    $0xa,%eax
  1010b5:	74 4c                	je     101103 <cga_putc+0x6e>
  1010b7:	83 f8 0d             	cmp    $0xd,%eax
  1010ba:	74 57                	je     101113 <cga_putc+0x7e>
  1010bc:	83 f8 08             	cmp    $0x8,%eax
  1010bf:	0f 85 88 00 00 00    	jne    10114d <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010c5:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010cc:	66 85 c0             	test   %ax,%ax
  1010cf:	74 30                	je     101101 <cga_putc+0x6c>
            crt_pos --;
  1010d1:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010d8:	83 e8 01             	sub    $0x1,%eax
  1010db:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010e1:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010e6:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010ed:	0f b7 d2             	movzwl %dx,%edx
  1010f0:	01 d2                	add    %edx,%edx
  1010f2:	01 c2                	add    %eax,%edx
  1010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f7:	b0 00                	mov    $0x0,%al
  1010f9:	83 c8 20             	or     $0x20,%eax
  1010fc:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010ff:	eb 72                	jmp    101173 <cga_putc+0xde>
  101101:	eb 70                	jmp    101173 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101103:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10110a:	83 c0 50             	add    $0x50,%eax
  10110d:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101113:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  10111a:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101121:	0f b7 c1             	movzwl %cx,%eax
  101124:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10112a:	c1 e8 10             	shr    $0x10,%eax
  10112d:	89 c2                	mov    %eax,%edx
  10112f:	66 c1 ea 06          	shr    $0x6,%dx
  101133:	89 d0                	mov    %edx,%eax
  101135:	c1 e0 02             	shl    $0x2,%eax
  101138:	01 d0                	add    %edx,%eax
  10113a:	c1 e0 04             	shl    $0x4,%eax
  10113d:	29 c1                	sub    %eax,%ecx
  10113f:	89 ca                	mov    %ecx,%edx
  101141:	89 d8                	mov    %ebx,%eax
  101143:	29 d0                	sub    %edx,%eax
  101145:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10114b:	eb 26                	jmp    101173 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10114d:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101153:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10115a:	8d 50 01             	lea    0x1(%eax),%edx
  10115d:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101164:	0f b7 c0             	movzwl %ax,%eax
  101167:	01 c0                	add    %eax,%eax
  101169:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10116c:	8b 45 08             	mov    0x8(%ebp),%eax
  10116f:	66 89 02             	mov    %ax,(%edx)
        break;
  101172:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101173:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10117a:	66 3d cf 07          	cmp    $0x7cf,%ax
  10117e:	76 5b                	jbe    1011db <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101180:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101185:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10118b:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101190:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101197:	00 
  101198:	89 54 24 04          	mov    %edx,0x4(%esp)
  10119c:	89 04 24             	mov    %eax,(%esp)
  10119f:	e8 bc 21 00 00       	call   103360 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011a4:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011ab:	eb 15                	jmp    1011c2 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011ad:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011b5:	01 d2                	add    %edx,%edx
  1011b7:	01 d0                	add    %edx,%eax
  1011b9:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011be:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011c2:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011c9:	7e e2                	jle    1011ad <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011cb:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011d2:	83 e8 50             	sub    $0x50,%eax
  1011d5:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011db:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011e2:	0f b7 c0             	movzwl %ax,%eax
  1011e5:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011e9:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011ed:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011f1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011f5:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011f6:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011fd:	66 c1 e8 08          	shr    $0x8,%ax
  101201:	0f b6 c0             	movzbl %al,%eax
  101204:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10120b:	83 c2 01             	add    $0x1,%edx
  10120e:	0f b7 d2             	movzwl %dx,%edx
  101211:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101215:	88 45 ed             	mov    %al,-0x13(%ebp)
  101218:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10121c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101220:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101221:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101228:	0f b7 c0             	movzwl %ax,%eax
  10122b:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10122f:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101233:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101237:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10123b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10123c:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101243:	0f b6 c0             	movzbl %al,%eax
  101246:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10124d:	83 c2 01             	add    $0x1,%edx
  101250:	0f b7 d2             	movzwl %dx,%edx
  101253:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101257:	88 45 e5             	mov    %al,-0x1b(%ebp)
  10125a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10125e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101262:	ee                   	out    %al,(%dx)
}
  101263:	83 c4 34             	add    $0x34,%esp
  101266:	5b                   	pop    %ebx
  101267:	5d                   	pop    %ebp
  101268:	c3                   	ret    

00101269 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101269:	55                   	push   %ebp
  10126a:	89 e5                	mov    %esp,%ebp
  10126c:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10126f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101276:	eb 09                	jmp    101281 <serial_putc_sub+0x18>
        delay();
  101278:	e8 4f fb ff ff       	call   100dcc <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10127d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101281:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101287:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10128b:	89 c2                	mov    %eax,%edx
  10128d:	ec                   	in     (%dx),%al
  10128e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101291:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101295:	0f b6 c0             	movzbl %al,%eax
  101298:	83 e0 20             	and    $0x20,%eax
  10129b:	85 c0                	test   %eax,%eax
  10129d:	75 09                	jne    1012a8 <serial_putc_sub+0x3f>
  10129f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012a6:	7e d0                	jle    101278 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1012ab:	0f b6 c0             	movzbl %al,%eax
  1012ae:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012b4:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012b7:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012bb:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012bf:	ee                   	out    %al,(%dx)
}
  1012c0:	c9                   	leave  
  1012c1:	c3                   	ret    

001012c2 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012c2:	55                   	push   %ebp
  1012c3:	89 e5                	mov    %esp,%ebp
  1012c5:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012c8:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012cc:	74 0d                	je     1012db <serial_putc+0x19>
        serial_putc_sub(c);
  1012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1012d1:	89 04 24             	mov    %eax,(%esp)
  1012d4:	e8 90 ff ff ff       	call   101269 <serial_putc_sub>
  1012d9:	eb 24                	jmp    1012ff <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012db:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012e2:	e8 82 ff ff ff       	call   101269 <serial_putc_sub>
        serial_putc_sub(' ');
  1012e7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012ee:	e8 76 ff ff ff       	call   101269 <serial_putc_sub>
        serial_putc_sub('\b');
  1012f3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012fa:	e8 6a ff ff ff       	call   101269 <serial_putc_sub>
    }
}
  1012ff:	c9                   	leave  
  101300:	c3                   	ret    

00101301 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101301:	55                   	push   %ebp
  101302:	89 e5                	mov    %esp,%ebp
  101304:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101307:	eb 33                	jmp    10133c <cons_intr+0x3b>
        if (c != 0) {
  101309:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10130d:	74 2d                	je     10133c <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10130f:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101314:	8d 50 01             	lea    0x1(%eax),%edx
  101317:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  10131d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101320:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101326:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10132b:	3d 00 02 00 00       	cmp    $0x200,%eax
  101330:	75 0a                	jne    10133c <cons_intr+0x3b>
                cons.wpos = 0;
  101332:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101339:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10133c:	8b 45 08             	mov    0x8(%ebp),%eax
  10133f:	ff d0                	call   *%eax
  101341:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101344:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101348:	75 bf                	jne    101309 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10134a:	c9                   	leave  
  10134b:	c3                   	ret    

0010134c <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10134c:	55                   	push   %ebp
  10134d:	89 e5                	mov    %esp,%ebp
  10134f:	83 ec 10             	sub    $0x10,%esp
  101352:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101358:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10135c:	89 c2                	mov    %eax,%edx
  10135e:	ec                   	in     (%dx),%al
  10135f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101362:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101366:	0f b6 c0             	movzbl %al,%eax
  101369:	83 e0 01             	and    $0x1,%eax
  10136c:	85 c0                	test   %eax,%eax
  10136e:	75 07                	jne    101377 <serial_proc_data+0x2b>
        return -1;
  101370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101375:	eb 2a                	jmp    1013a1 <serial_proc_data+0x55>
  101377:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10137d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101381:	89 c2                	mov    %eax,%edx
  101383:	ec                   	in     (%dx),%al
  101384:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101387:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10138b:	0f b6 c0             	movzbl %al,%eax
  10138e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101391:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101395:	75 07                	jne    10139e <serial_proc_data+0x52>
        c = '\b';
  101397:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10139e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013a1:	c9                   	leave  
  1013a2:	c3                   	ret    

001013a3 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013a3:	55                   	push   %ebp
  1013a4:	89 e5                	mov    %esp,%ebp
  1013a6:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013a9:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013ae:	85 c0                	test   %eax,%eax
  1013b0:	74 0c                	je     1013be <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013b2:	c7 04 24 4c 13 10 00 	movl   $0x10134c,(%esp)
  1013b9:	e8 43 ff ff ff       	call   101301 <cons_intr>
    }
}
  1013be:	c9                   	leave  
  1013bf:	c3                   	ret    

001013c0 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013c0:	55                   	push   %ebp
  1013c1:	89 e5                	mov    %esp,%ebp
  1013c3:	83 ec 38             	sub    $0x38,%esp
  1013c6:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013cc:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013d0:	89 c2                	mov    %eax,%edx
  1013d2:	ec                   	in     (%dx),%al
  1013d3:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013d6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013da:	0f b6 c0             	movzbl %al,%eax
  1013dd:	83 e0 01             	and    $0x1,%eax
  1013e0:	85 c0                	test   %eax,%eax
  1013e2:	75 0a                	jne    1013ee <kbd_proc_data+0x2e>
        return -1;
  1013e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013e9:	e9 59 01 00 00       	jmp    101547 <kbd_proc_data+0x187>
  1013ee:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013f4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013f8:	89 c2                	mov    %eax,%edx
  1013fa:	ec                   	in     (%dx),%al
  1013fb:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013fe:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101402:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101405:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101409:	75 17                	jne    101422 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10140b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101410:	83 c8 40             	or     $0x40,%eax
  101413:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101418:	b8 00 00 00 00       	mov    $0x0,%eax
  10141d:	e9 25 01 00 00       	jmp    101547 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101422:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101426:	84 c0                	test   %al,%al
  101428:	79 47                	jns    101471 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10142a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10142f:	83 e0 40             	and    $0x40,%eax
  101432:	85 c0                	test   %eax,%eax
  101434:	75 09                	jne    10143f <kbd_proc_data+0x7f>
  101436:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10143a:	83 e0 7f             	and    $0x7f,%eax
  10143d:	eb 04                	jmp    101443 <kbd_proc_data+0x83>
  10143f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101443:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101446:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10144a:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101451:	83 c8 40             	or     $0x40,%eax
  101454:	0f b6 c0             	movzbl %al,%eax
  101457:	f7 d0                	not    %eax
  101459:	89 c2                	mov    %eax,%edx
  10145b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101460:	21 d0                	and    %edx,%eax
  101462:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101467:	b8 00 00 00 00       	mov    $0x0,%eax
  10146c:	e9 d6 00 00 00       	jmp    101547 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101471:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101476:	83 e0 40             	and    $0x40,%eax
  101479:	85 c0                	test   %eax,%eax
  10147b:	74 11                	je     10148e <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10147d:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101481:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101486:	83 e0 bf             	and    $0xffffffbf,%eax
  101489:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10148e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101492:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101499:	0f b6 d0             	movzbl %al,%edx
  10149c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a1:	09 d0                	or     %edx,%eax
  1014a3:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014a8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ac:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014b3:	0f b6 d0             	movzbl %al,%edx
  1014b6:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014bb:	31 d0                	xor    %edx,%eax
  1014bd:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014c2:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c7:	83 e0 03             	and    $0x3,%eax
  1014ca:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014d1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d5:	01 d0                	add    %edx,%eax
  1014d7:	0f b6 00             	movzbl (%eax),%eax
  1014da:	0f b6 c0             	movzbl %al,%eax
  1014dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014e0:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014e5:	83 e0 08             	and    $0x8,%eax
  1014e8:	85 c0                	test   %eax,%eax
  1014ea:	74 22                	je     10150e <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014ec:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014f0:	7e 0c                	jle    1014fe <kbd_proc_data+0x13e>
  1014f2:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014f6:	7f 06                	jg     1014fe <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014f8:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014fc:	eb 10                	jmp    10150e <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014fe:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101502:	7e 0a                	jle    10150e <kbd_proc_data+0x14e>
  101504:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101508:	7f 04                	jg     10150e <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10150a:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10150e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101513:	f7 d0                	not    %eax
  101515:	83 e0 06             	and    $0x6,%eax
  101518:	85 c0                	test   %eax,%eax
  10151a:	75 28                	jne    101544 <kbd_proc_data+0x184>
  10151c:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101523:	75 1f                	jne    101544 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101525:	c7 04 24 ef 37 10 00 	movl   $0x1037ef,(%esp)
  10152c:	e8 e1 ed ff ff       	call   100312 <cprintf>
  101531:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101537:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10153b:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10153f:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101543:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101544:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101547:	c9                   	leave  
  101548:	c3                   	ret    

00101549 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101549:	55                   	push   %ebp
  10154a:	89 e5                	mov    %esp,%ebp
  10154c:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10154f:	c7 04 24 c0 13 10 00 	movl   $0x1013c0,(%esp)
  101556:	e8 a6 fd ff ff       	call   101301 <cons_intr>
}
  10155b:	c9                   	leave  
  10155c:	c3                   	ret    

0010155d <kbd_init>:

static void
kbd_init(void) {
  10155d:	55                   	push   %ebp
  10155e:	89 e5                	mov    %esp,%ebp
  101560:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101563:	e8 e1 ff ff ff       	call   101549 <kbd_intr>
    pic_enable(IRQ_KBD);
  101568:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10156f:	e8 17 01 00 00       	call   10168b <pic_enable>
}
  101574:	c9                   	leave  
  101575:	c3                   	ret    

00101576 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101576:	55                   	push   %ebp
  101577:	89 e5                	mov    %esp,%ebp
  101579:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10157c:	e8 93 f8 ff ff       	call   100e14 <cga_init>
    serial_init();
  101581:	e8 74 f9 ff ff       	call   100efa <serial_init>
    kbd_init();
  101586:	e8 d2 ff ff ff       	call   10155d <kbd_init>
    if (!serial_exists) {
  10158b:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101590:	85 c0                	test   %eax,%eax
  101592:	75 0c                	jne    1015a0 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101594:	c7 04 24 fb 37 10 00 	movl   $0x1037fb,(%esp)
  10159b:	e8 72 ed ff ff       	call   100312 <cprintf>
    }
}
  1015a0:	c9                   	leave  
  1015a1:	c3                   	ret    

001015a2 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015a2:	55                   	push   %ebp
  1015a3:	89 e5                	mov    %esp,%ebp
  1015a5:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1015ab:	89 04 24             	mov    %eax,(%esp)
  1015ae:	e8 a3 fa ff ff       	call   101056 <lpt_putc>
    cga_putc(c);
  1015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b6:	89 04 24             	mov    %eax,(%esp)
  1015b9:	e8 d7 fa ff ff       	call   101095 <cga_putc>
    serial_putc(c);
  1015be:	8b 45 08             	mov    0x8(%ebp),%eax
  1015c1:	89 04 24             	mov    %eax,(%esp)
  1015c4:	e8 f9 fc ff ff       	call   1012c2 <serial_putc>
}
  1015c9:	c9                   	leave  
  1015ca:	c3                   	ret    

001015cb <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015cb:	55                   	push   %ebp
  1015cc:	89 e5                	mov    %esp,%ebp
  1015ce:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015d1:	e8 cd fd ff ff       	call   1013a3 <serial_intr>
    kbd_intr();
  1015d6:	e8 6e ff ff ff       	call   101549 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015db:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015e1:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015e6:	39 c2                	cmp    %eax,%edx
  1015e8:	74 36                	je     101620 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015ea:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015ef:	8d 50 01             	lea    0x1(%eax),%edx
  1015f2:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015f8:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015ff:	0f b6 c0             	movzbl %al,%eax
  101602:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101605:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10160a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10160f:	75 0a                	jne    10161b <cons_getc+0x50>
            cons.rpos = 0;
  101611:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101618:	00 00 00 
        }
        return c;
  10161b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10161e:	eb 05                	jmp    101625 <cons_getc+0x5a>
    }
    return 0;
  101620:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101625:	c9                   	leave  
  101626:	c3                   	ret    

00101627 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101627:	55                   	push   %ebp
  101628:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10162a:	fb                   	sti    
    sti();
}
  10162b:	5d                   	pop    %ebp
  10162c:	c3                   	ret    

0010162d <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10162d:	55                   	push   %ebp
  10162e:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101630:	fa                   	cli    
    cli();
}
  101631:	5d                   	pop    %ebp
  101632:	c3                   	ret    

00101633 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101633:	55                   	push   %ebp
  101634:	89 e5                	mov    %esp,%ebp
  101636:	83 ec 14             	sub    $0x14,%esp
  101639:	8b 45 08             	mov    0x8(%ebp),%eax
  10163c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101640:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101644:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10164a:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  10164f:	85 c0                	test   %eax,%eax
  101651:	74 36                	je     101689 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101653:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101657:	0f b6 c0             	movzbl %al,%eax
  10165a:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101660:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101663:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101667:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10166b:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10166c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101670:	66 c1 e8 08          	shr    $0x8,%ax
  101674:	0f b6 c0             	movzbl %al,%eax
  101677:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10167d:	88 45 f9             	mov    %al,-0x7(%ebp)
  101680:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101684:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101688:	ee                   	out    %al,(%dx)
    }
}
  101689:	c9                   	leave  
  10168a:	c3                   	ret    

0010168b <pic_enable>:

void
pic_enable(unsigned int irq) {
  10168b:	55                   	push   %ebp
  10168c:	89 e5                	mov    %esp,%ebp
  10168e:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101691:	8b 45 08             	mov    0x8(%ebp),%eax
  101694:	ba 01 00 00 00       	mov    $0x1,%edx
  101699:	89 c1                	mov    %eax,%ecx
  10169b:	d3 e2                	shl    %cl,%edx
  10169d:	89 d0                	mov    %edx,%eax
  10169f:	f7 d0                	not    %eax
  1016a1:	89 c2                	mov    %eax,%edx
  1016a3:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016aa:	21 d0                	and    %edx,%eax
  1016ac:	0f b7 c0             	movzwl %ax,%eax
  1016af:	89 04 24             	mov    %eax,(%esp)
  1016b2:	e8 7c ff ff ff       	call   101633 <pic_setmask>
}
  1016b7:	c9                   	leave  
  1016b8:	c3                   	ret    

001016b9 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016b9:	55                   	push   %ebp
  1016ba:	89 e5                	mov    %esp,%ebp
  1016bc:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016bf:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016c6:	00 00 00 
  1016c9:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016cf:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016d3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016d7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016db:	ee                   	out    %al,(%dx)
  1016dc:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016e2:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016e6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016ea:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016ee:	ee                   	out    %al,(%dx)
  1016ef:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016f5:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016f9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016fd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101701:	ee                   	out    %al,(%dx)
  101702:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101708:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10170c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101710:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101714:	ee                   	out    %al,(%dx)
  101715:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10171b:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  10171f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101723:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101727:	ee                   	out    %al,(%dx)
  101728:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  10172e:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101732:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101736:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10173a:	ee                   	out    %al,(%dx)
  10173b:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101741:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101745:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101749:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10174d:	ee                   	out    %al,(%dx)
  10174e:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101754:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101758:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10175c:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101760:	ee                   	out    %al,(%dx)
  101761:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101767:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10176b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10176f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101773:	ee                   	out    %al,(%dx)
  101774:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10177a:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  10177e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101782:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101786:	ee                   	out    %al,(%dx)
  101787:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10178d:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101791:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101795:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101799:	ee                   	out    %al,(%dx)
  10179a:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017a0:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  1017a4:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017a8:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017ac:	ee                   	out    %al,(%dx)
  1017ad:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017b3:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017b7:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017bb:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017bf:	ee                   	out    %al,(%dx)
  1017c0:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017c6:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017ca:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017ce:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017d2:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017d3:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017da:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017de:	74 12                	je     1017f2 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017e0:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017e7:	0f b7 c0             	movzwl %ax,%eax
  1017ea:	89 04 24             	mov    %eax,(%esp)
  1017ed:	e8 41 fe ff ff       	call   101633 <pic_setmask>
    }
}
  1017f2:	c9                   	leave  
  1017f3:	c3                   	ret    

001017f4 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017f4:	55                   	push   %ebp
  1017f5:	89 e5                	mov    %esp,%ebp
  1017f7:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017fa:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101801:	00 
  101802:	c7 04 24 20 38 10 00 	movl   $0x103820,(%esp)
  101809:	e8 04 eb ff ff       	call   100312 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10180e:	c7 04 24 2a 38 10 00 	movl   $0x10382a,(%esp)
  101815:	e8 f8 ea ff ff       	call   100312 <cprintf>
    panic("EOT: kernel seems ok.");
  10181a:	c7 44 24 08 38 38 10 	movl   $0x103838,0x8(%esp)
  101821:	00 
  101822:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  101829:	00 
  10182a:	c7 04 24 4e 38 10 00 	movl   $0x10384e,(%esp)
  101831:	e8 66 f4 ff ff       	call   100c9c <__panic>

00101836 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101836:	55                   	push   %ebp
  101837:	89 e5                	mov    %esp,%ebp
  101839:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];   //define ISR's entry addrs _vectors[]
    int i = 0;
  10183c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    //arguments：0 means interrupt，GD_KTEXT means kernel text
    //use SETGATE macro to setup each item of IDT
    while(i < sizeof(idt) / sizeof(struct gatedesc)) {
  101843:	e9 c3 00 00 00       	jmp    10190b <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101848:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10184b:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101852:	89 c2                	mov    %eax,%edx
  101854:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101857:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  10185e:	00 
  10185f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101862:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101869:	00 08 00 
  10186c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10186f:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101876:	00 
  101877:	83 e2 e0             	and    $0xffffffe0,%edx
  10187a:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101881:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101884:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10188b:	00 
  10188c:	83 e2 1f             	and    $0x1f,%edx
  10188f:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101896:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101899:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018a0:	00 
  1018a1:	83 e2 f0             	and    $0xfffffff0,%edx
  1018a4:	83 ca 0e             	or     $0xe,%edx
  1018a7:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b1:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018b8:	00 
  1018b9:	83 e2 ef             	and    $0xffffffef,%edx
  1018bc:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c6:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018cd:	00 
  1018ce:	83 e2 9f             	and    $0xffffff9f,%edx
  1018d1:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018db:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018e2:	00 
  1018e3:	83 ca 80             	or     $0xffffff80,%edx
  1018e6:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f0:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018f7:	c1 e8 10             	shr    $0x10,%eax
  1018fa:	89 c2                	mov    %eax,%edx
  1018fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ff:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  101906:	00 
        i ++;
  101907:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
      */
    extern uintptr_t __vectors[];   //define ISR's entry addrs _vectors[]
    int i = 0;
    //arguments：0 means interrupt，GD_KTEXT means kernel text
    //use SETGATE macro to setup each item of IDT
    while(i < sizeof(idt) / sizeof(struct gatedesc)) {
  10190b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190e:	3d ff 00 00 00       	cmp    $0xff,%eax
  101913:	0f 86 2f ff ff ff    	jbe    101848 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
        i ++;
    }
    // switch from user state to kernel state
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101919:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10191e:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  101924:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  10192b:	08 00 
  10192d:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101934:	83 e0 e0             	and    $0xffffffe0,%eax
  101937:	a2 6c f4 10 00       	mov    %al,0x10f46c
  10193c:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101943:	83 e0 1f             	and    $0x1f,%eax
  101946:	a2 6c f4 10 00       	mov    %al,0x10f46c
  10194b:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101952:	83 e0 f0             	and    $0xfffffff0,%eax
  101955:	83 c8 0e             	or     $0xe,%eax
  101958:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10195d:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101964:	83 e0 ef             	and    $0xffffffef,%eax
  101967:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10196c:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101973:	83 c8 60             	or     $0x60,%eax
  101976:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10197b:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101982:	83 c8 80             	or     $0xffffff80,%eax
  101985:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10198a:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10198f:	c1 e8 10             	shr    $0x10,%eax
  101992:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101998:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  10199f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019a2:	0f 01 18             	lidtl  (%eax)
    //let CPU know where is IDT by using 'lidt' instruction
    lidt(&idt_pd);
}
  1019a5:	c9                   	leave  
  1019a6:	c3                   	ret    

001019a7 <trapname>:

static const char *
trapname(int trapno) {
  1019a7:	55                   	push   %ebp
  1019a8:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ad:	83 f8 13             	cmp    $0x13,%eax
  1019b0:	77 0c                	ja     1019be <trapname+0x17>
        return excnames[trapno];
  1019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b5:	8b 04 85 a0 3b 10 00 	mov    0x103ba0(,%eax,4),%eax
  1019bc:	eb 18                	jmp    1019d6 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019be:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019c2:	7e 0d                	jle    1019d1 <trapname+0x2a>
  1019c4:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019c8:	7f 07                	jg     1019d1 <trapname+0x2a>
        return "Hardware Interrupt";
  1019ca:	b8 5f 38 10 00       	mov    $0x10385f,%eax
  1019cf:	eb 05                	jmp    1019d6 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019d1:	b8 72 38 10 00       	mov    $0x103872,%eax
}
  1019d6:	5d                   	pop    %ebp
  1019d7:	c3                   	ret    

001019d8 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019d8:	55                   	push   %ebp
  1019d9:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019db:	8b 45 08             	mov    0x8(%ebp),%eax
  1019de:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019e2:	66 83 f8 08          	cmp    $0x8,%ax
  1019e6:	0f 94 c0             	sete   %al
  1019e9:	0f b6 c0             	movzbl %al,%eax
}
  1019ec:	5d                   	pop    %ebp
  1019ed:	c3                   	ret    

001019ee <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019ee:	55                   	push   %ebp
  1019ef:	89 e5                	mov    %esp,%ebp
  1019f1:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019fb:	c7 04 24 b3 38 10 00 	movl   $0x1038b3,(%esp)
  101a02:	e8 0b e9 ff ff       	call   100312 <cprintf>
    print_regs(&tf->tf_regs);
  101a07:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0a:	89 04 24             	mov    %eax,(%esp)
  101a0d:	e8 a1 01 00 00       	call   101bb3 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a12:	8b 45 08             	mov    0x8(%ebp),%eax
  101a15:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a19:	0f b7 c0             	movzwl %ax,%eax
  101a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a20:	c7 04 24 c4 38 10 00 	movl   $0x1038c4,(%esp)
  101a27:	e8 e6 e8 ff ff       	call   100312 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2f:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a33:	0f b7 c0             	movzwl %ax,%eax
  101a36:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a3a:	c7 04 24 d7 38 10 00 	movl   $0x1038d7,(%esp)
  101a41:	e8 cc e8 ff ff       	call   100312 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a46:	8b 45 08             	mov    0x8(%ebp),%eax
  101a49:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a4d:	0f b7 c0             	movzwl %ax,%eax
  101a50:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a54:	c7 04 24 ea 38 10 00 	movl   $0x1038ea,(%esp)
  101a5b:	e8 b2 e8 ff ff       	call   100312 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a60:	8b 45 08             	mov    0x8(%ebp),%eax
  101a63:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a67:	0f b7 c0             	movzwl %ax,%eax
  101a6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a6e:	c7 04 24 fd 38 10 00 	movl   $0x1038fd,(%esp)
  101a75:	e8 98 e8 ff ff       	call   100312 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7d:	8b 40 30             	mov    0x30(%eax),%eax
  101a80:	89 04 24             	mov    %eax,(%esp)
  101a83:	e8 1f ff ff ff       	call   1019a7 <trapname>
  101a88:	8b 55 08             	mov    0x8(%ebp),%edx
  101a8b:	8b 52 30             	mov    0x30(%edx),%edx
  101a8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a92:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a96:	c7 04 24 10 39 10 00 	movl   $0x103910,(%esp)
  101a9d:	e8 70 e8 ff ff       	call   100312 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa5:	8b 40 34             	mov    0x34(%eax),%eax
  101aa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aac:	c7 04 24 22 39 10 00 	movl   $0x103922,(%esp)
  101ab3:	e8 5a e8 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  101abb:	8b 40 38             	mov    0x38(%eax),%eax
  101abe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac2:	c7 04 24 31 39 10 00 	movl   $0x103931,(%esp)
  101ac9:	e8 44 e8 ff ff       	call   100312 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101ace:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ad5:	0f b7 c0             	movzwl %ax,%eax
  101ad8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101adc:	c7 04 24 40 39 10 00 	movl   $0x103940,(%esp)
  101ae3:	e8 2a e8 ff ff       	call   100312 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  101aeb:	8b 40 40             	mov    0x40(%eax),%eax
  101aee:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af2:	c7 04 24 53 39 10 00 	movl   $0x103953,(%esp)
  101af9:	e8 14 e8 ff ff       	call   100312 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101afe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b05:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b0c:	eb 3e                	jmp    101b4c <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b11:	8b 50 40             	mov    0x40(%eax),%edx
  101b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b17:	21 d0                	and    %edx,%eax
  101b19:	85 c0                	test   %eax,%eax
  101b1b:	74 28                	je     101b45 <print_trapframe+0x157>
  101b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b20:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b27:	85 c0                	test   %eax,%eax
  101b29:	74 1a                	je     101b45 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b2e:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b35:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b39:	c7 04 24 62 39 10 00 	movl   $0x103962,(%esp)
  101b40:	e8 cd e7 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b45:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b49:	d1 65 f0             	shll   -0x10(%ebp)
  101b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b4f:	83 f8 17             	cmp    $0x17,%eax
  101b52:	76 ba                	jbe    101b0e <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b54:	8b 45 08             	mov    0x8(%ebp),%eax
  101b57:	8b 40 40             	mov    0x40(%eax),%eax
  101b5a:	25 00 30 00 00       	and    $0x3000,%eax
  101b5f:	c1 e8 0c             	shr    $0xc,%eax
  101b62:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b66:	c7 04 24 66 39 10 00 	movl   $0x103966,(%esp)
  101b6d:	e8 a0 e7 ff ff       	call   100312 <cprintf>

    if (!trap_in_kernel(tf)) {
  101b72:	8b 45 08             	mov    0x8(%ebp),%eax
  101b75:	89 04 24             	mov    %eax,(%esp)
  101b78:	e8 5b fe ff ff       	call   1019d8 <trap_in_kernel>
  101b7d:	85 c0                	test   %eax,%eax
  101b7f:	75 30                	jne    101bb1 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b81:	8b 45 08             	mov    0x8(%ebp),%eax
  101b84:	8b 40 44             	mov    0x44(%eax),%eax
  101b87:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8b:	c7 04 24 6f 39 10 00 	movl   $0x10396f,(%esp)
  101b92:	e8 7b e7 ff ff       	call   100312 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b97:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9a:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b9e:	0f b7 c0             	movzwl %ax,%eax
  101ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba5:	c7 04 24 7e 39 10 00 	movl   $0x10397e,(%esp)
  101bac:	e8 61 e7 ff ff       	call   100312 <cprintf>
    }
}
  101bb1:	c9                   	leave  
  101bb2:	c3                   	ret    

00101bb3 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bb3:	55                   	push   %ebp
  101bb4:	89 e5                	mov    %esp,%ebp
  101bb6:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbc:	8b 00                	mov    (%eax),%eax
  101bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc2:	c7 04 24 91 39 10 00 	movl   $0x103991,(%esp)
  101bc9:	e8 44 e7 ff ff       	call   100312 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bce:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd1:	8b 40 04             	mov    0x4(%eax),%eax
  101bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd8:	c7 04 24 a0 39 10 00 	movl   $0x1039a0,(%esp)
  101bdf:	e8 2e e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101be4:	8b 45 08             	mov    0x8(%ebp),%eax
  101be7:	8b 40 08             	mov    0x8(%eax),%eax
  101bea:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bee:	c7 04 24 af 39 10 00 	movl   $0x1039af,(%esp)
  101bf5:	e8 18 e7 ff ff       	call   100312 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfd:	8b 40 0c             	mov    0xc(%eax),%eax
  101c00:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c04:	c7 04 24 be 39 10 00 	movl   $0x1039be,(%esp)
  101c0b:	e8 02 e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c10:	8b 45 08             	mov    0x8(%ebp),%eax
  101c13:	8b 40 10             	mov    0x10(%eax),%eax
  101c16:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c1a:	c7 04 24 cd 39 10 00 	movl   $0x1039cd,(%esp)
  101c21:	e8 ec e6 ff ff       	call   100312 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c26:	8b 45 08             	mov    0x8(%ebp),%eax
  101c29:	8b 40 14             	mov    0x14(%eax),%eax
  101c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c30:	c7 04 24 dc 39 10 00 	movl   $0x1039dc,(%esp)
  101c37:	e8 d6 e6 ff ff       	call   100312 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3f:	8b 40 18             	mov    0x18(%eax),%eax
  101c42:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c46:	c7 04 24 eb 39 10 00 	movl   $0x1039eb,(%esp)
  101c4d:	e8 c0 e6 ff ff       	call   100312 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c52:	8b 45 08             	mov    0x8(%ebp),%eax
  101c55:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c58:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5c:	c7 04 24 fa 39 10 00 	movl   $0x1039fa,(%esp)
  101c63:	e8 aa e6 ff ff       	call   100312 <cprintf>
}
  101c68:	c9                   	leave  
  101c69:	c3                   	ret    

00101c6a <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c6a:	55                   	push   %ebp
  101c6b:	89 e5                	mov    %esp,%ebp
  101c6d:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c70:	8b 45 08             	mov    0x8(%ebp),%eax
  101c73:	8b 40 30             	mov    0x30(%eax),%eax
  101c76:	83 f8 2f             	cmp    $0x2f,%eax
  101c79:	77 21                	ja     101c9c <trap_dispatch+0x32>
  101c7b:	83 f8 2e             	cmp    $0x2e,%eax
  101c7e:	0f 83 04 01 00 00    	jae    101d88 <trap_dispatch+0x11e>
  101c84:	83 f8 21             	cmp    $0x21,%eax
  101c87:	0f 84 81 00 00 00    	je     101d0e <trap_dispatch+0xa4>
  101c8d:	83 f8 24             	cmp    $0x24,%eax
  101c90:	74 56                	je     101ce8 <trap_dispatch+0x7e>
  101c92:	83 f8 20             	cmp    $0x20,%eax
  101c95:	74 16                	je     101cad <trap_dispatch+0x43>
  101c97:	e9 b4 00 00 00       	jmp    101d50 <trap_dispatch+0xe6>
  101c9c:	83 e8 78             	sub    $0x78,%eax
  101c9f:	83 f8 01             	cmp    $0x1,%eax
  101ca2:	0f 87 a8 00 00 00    	ja     101d50 <trap_dispatch+0xe6>
  101ca8:	e9 87 00 00 00       	jmp    101d34 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101cad:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101cb2:	83 c0 01             	add    $0x1,%eax
  101cb5:	a3 08 f9 10 00       	mov    %eax,0x10f908
        if (ticks % TICK_NUM == 0) {
  101cba:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101cc0:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101cc5:	89 c8                	mov    %ecx,%eax
  101cc7:	f7 e2                	mul    %edx
  101cc9:	89 d0                	mov    %edx,%eax
  101ccb:	c1 e8 05             	shr    $0x5,%eax
  101cce:	6b c0 64             	imul   $0x64,%eax,%eax
  101cd1:	29 c1                	sub    %eax,%ecx
  101cd3:	89 c8                	mov    %ecx,%eax
  101cd5:	85 c0                	test   %eax,%eax
  101cd7:	75 0a                	jne    101ce3 <trap_dispatch+0x79>
            print_ticks();
  101cd9:	e8 16 fb ff ff       	call   1017f4 <print_ticks>
        }
        break;
  101cde:	e9 a6 00 00 00       	jmp    101d89 <trap_dispatch+0x11f>
  101ce3:	e9 a1 00 00 00       	jmp    101d89 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ce8:	e8 de f8 ff ff       	call   1015cb <cons_getc>
  101ced:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101cf0:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cf4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cf8:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d00:	c7 04 24 09 3a 10 00 	movl   $0x103a09,(%esp)
  101d07:	e8 06 e6 ff ff       	call   100312 <cprintf>
        break;
  101d0c:	eb 7b                	jmp    101d89 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d0e:	e8 b8 f8 ff ff       	call   1015cb <cons_getc>
  101d13:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d16:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d1a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d1e:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d22:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d26:	c7 04 24 1b 3a 10 00 	movl   $0x103a1b,(%esp)
  101d2d:	e8 e0 e5 ff ff       	call   100312 <cprintf>
        break;
  101d32:	eb 55                	jmp    101d89 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d34:	c7 44 24 08 2a 3a 10 	movl   $0x103a2a,0x8(%esp)
  101d3b:	00 
  101d3c:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  101d43:	00 
  101d44:	c7 04 24 4e 38 10 00 	movl   $0x10384e,(%esp)
  101d4b:	e8 4c ef ff ff       	call   100c9c <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d50:	8b 45 08             	mov    0x8(%ebp),%eax
  101d53:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d57:	0f b7 c0             	movzwl %ax,%eax
  101d5a:	83 e0 03             	and    $0x3,%eax
  101d5d:	85 c0                	test   %eax,%eax
  101d5f:	75 28                	jne    101d89 <trap_dispatch+0x11f>
            print_trapframe(tf);
  101d61:	8b 45 08             	mov    0x8(%ebp),%eax
  101d64:	89 04 24             	mov    %eax,(%esp)
  101d67:	e8 82 fc ff ff       	call   1019ee <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d6c:	c7 44 24 08 3a 3a 10 	movl   $0x103a3a,0x8(%esp)
  101d73:	00 
  101d74:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
  101d7b:	00 
  101d7c:	c7 04 24 4e 38 10 00 	movl   $0x10384e,(%esp)
  101d83:	e8 14 ef ff ff       	call   100c9c <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d88:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d89:	c9                   	leave  
  101d8a:	c3                   	ret    

00101d8b <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d8b:	55                   	push   %ebp
  101d8c:	89 e5                	mov    %esp,%ebp
  101d8e:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d91:	8b 45 08             	mov    0x8(%ebp),%eax
  101d94:	89 04 24             	mov    %eax,(%esp)
  101d97:	e8 ce fe ff ff       	call   101c6a <trap_dispatch>
}
  101d9c:	c9                   	leave  
  101d9d:	c3                   	ret    

00101d9e <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101d9e:	1e                   	push   %ds
    pushl %es
  101d9f:	06                   	push   %es
    pushl %fs
  101da0:	0f a0                	push   %fs
    pushl %gs
  101da2:	0f a8                	push   %gs
    pushal
  101da4:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101da5:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101daa:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101dac:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101dae:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101daf:	e8 d7 ff ff ff       	call   101d8b <trap>

    # pop the pushed stack pointer
    popl %esp
  101db4:	5c                   	pop    %esp

00101db5 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101db5:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101db6:	0f a9                	pop    %gs
    popl %fs
  101db8:	0f a1                	pop    %fs
    popl %es
  101dba:	07                   	pop    %es
    popl %ds
  101dbb:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101dbc:	83 c4 08             	add    $0x8,%esp
    iret
  101dbf:	cf                   	iret   

00101dc0 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101dc0:	6a 00                	push   $0x0
  pushl $0
  101dc2:	6a 00                	push   $0x0
  jmp __alltraps
  101dc4:	e9 d5 ff ff ff       	jmp    101d9e <__alltraps>

00101dc9 <vector1>:
.globl vector1
vector1:
  pushl $0
  101dc9:	6a 00                	push   $0x0
  pushl $1
  101dcb:	6a 01                	push   $0x1
  jmp __alltraps
  101dcd:	e9 cc ff ff ff       	jmp    101d9e <__alltraps>

00101dd2 <vector2>:
.globl vector2
vector2:
  pushl $0
  101dd2:	6a 00                	push   $0x0
  pushl $2
  101dd4:	6a 02                	push   $0x2
  jmp __alltraps
  101dd6:	e9 c3 ff ff ff       	jmp    101d9e <__alltraps>

00101ddb <vector3>:
.globl vector3
vector3:
  pushl $0
  101ddb:	6a 00                	push   $0x0
  pushl $3
  101ddd:	6a 03                	push   $0x3
  jmp __alltraps
  101ddf:	e9 ba ff ff ff       	jmp    101d9e <__alltraps>

00101de4 <vector4>:
.globl vector4
vector4:
  pushl $0
  101de4:	6a 00                	push   $0x0
  pushl $4
  101de6:	6a 04                	push   $0x4
  jmp __alltraps
  101de8:	e9 b1 ff ff ff       	jmp    101d9e <__alltraps>

00101ded <vector5>:
.globl vector5
vector5:
  pushl $0
  101ded:	6a 00                	push   $0x0
  pushl $5
  101def:	6a 05                	push   $0x5
  jmp __alltraps
  101df1:	e9 a8 ff ff ff       	jmp    101d9e <__alltraps>

00101df6 <vector6>:
.globl vector6
vector6:
  pushl $0
  101df6:	6a 00                	push   $0x0
  pushl $6
  101df8:	6a 06                	push   $0x6
  jmp __alltraps
  101dfa:	e9 9f ff ff ff       	jmp    101d9e <__alltraps>

00101dff <vector7>:
.globl vector7
vector7:
  pushl $0
  101dff:	6a 00                	push   $0x0
  pushl $7
  101e01:	6a 07                	push   $0x7
  jmp __alltraps
  101e03:	e9 96 ff ff ff       	jmp    101d9e <__alltraps>

00101e08 <vector8>:
.globl vector8
vector8:
  pushl $8
  101e08:	6a 08                	push   $0x8
  jmp __alltraps
  101e0a:	e9 8f ff ff ff       	jmp    101d9e <__alltraps>

00101e0f <vector9>:
.globl vector9
vector9:
  pushl $0
  101e0f:	6a 00                	push   $0x0
  pushl $9
  101e11:	6a 09                	push   $0x9
  jmp __alltraps
  101e13:	e9 86 ff ff ff       	jmp    101d9e <__alltraps>

00101e18 <vector10>:
.globl vector10
vector10:
  pushl $10
  101e18:	6a 0a                	push   $0xa
  jmp __alltraps
  101e1a:	e9 7f ff ff ff       	jmp    101d9e <__alltraps>

00101e1f <vector11>:
.globl vector11
vector11:
  pushl $11
  101e1f:	6a 0b                	push   $0xb
  jmp __alltraps
  101e21:	e9 78 ff ff ff       	jmp    101d9e <__alltraps>

00101e26 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e26:	6a 0c                	push   $0xc
  jmp __alltraps
  101e28:	e9 71 ff ff ff       	jmp    101d9e <__alltraps>

00101e2d <vector13>:
.globl vector13
vector13:
  pushl $13
  101e2d:	6a 0d                	push   $0xd
  jmp __alltraps
  101e2f:	e9 6a ff ff ff       	jmp    101d9e <__alltraps>

00101e34 <vector14>:
.globl vector14
vector14:
  pushl $14
  101e34:	6a 0e                	push   $0xe
  jmp __alltraps
  101e36:	e9 63 ff ff ff       	jmp    101d9e <__alltraps>

00101e3b <vector15>:
.globl vector15
vector15:
  pushl $0
  101e3b:	6a 00                	push   $0x0
  pushl $15
  101e3d:	6a 0f                	push   $0xf
  jmp __alltraps
  101e3f:	e9 5a ff ff ff       	jmp    101d9e <__alltraps>

00101e44 <vector16>:
.globl vector16
vector16:
  pushl $0
  101e44:	6a 00                	push   $0x0
  pushl $16
  101e46:	6a 10                	push   $0x10
  jmp __alltraps
  101e48:	e9 51 ff ff ff       	jmp    101d9e <__alltraps>

00101e4d <vector17>:
.globl vector17
vector17:
  pushl $17
  101e4d:	6a 11                	push   $0x11
  jmp __alltraps
  101e4f:	e9 4a ff ff ff       	jmp    101d9e <__alltraps>

00101e54 <vector18>:
.globl vector18
vector18:
  pushl $0
  101e54:	6a 00                	push   $0x0
  pushl $18
  101e56:	6a 12                	push   $0x12
  jmp __alltraps
  101e58:	e9 41 ff ff ff       	jmp    101d9e <__alltraps>

00101e5d <vector19>:
.globl vector19
vector19:
  pushl $0
  101e5d:	6a 00                	push   $0x0
  pushl $19
  101e5f:	6a 13                	push   $0x13
  jmp __alltraps
  101e61:	e9 38 ff ff ff       	jmp    101d9e <__alltraps>

00101e66 <vector20>:
.globl vector20
vector20:
  pushl $0
  101e66:	6a 00                	push   $0x0
  pushl $20
  101e68:	6a 14                	push   $0x14
  jmp __alltraps
  101e6a:	e9 2f ff ff ff       	jmp    101d9e <__alltraps>

00101e6f <vector21>:
.globl vector21
vector21:
  pushl $0
  101e6f:	6a 00                	push   $0x0
  pushl $21
  101e71:	6a 15                	push   $0x15
  jmp __alltraps
  101e73:	e9 26 ff ff ff       	jmp    101d9e <__alltraps>

00101e78 <vector22>:
.globl vector22
vector22:
  pushl $0
  101e78:	6a 00                	push   $0x0
  pushl $22
  101e7a:	6a 16                	push   $0x16
  jmp __alltraps
  101e7c:	e9 1d ff ff ff       	jmp    101d9e <__alltraps>

00101e81 <vector23>:
.globl vector23
vector23:
  pushl $0
  101e81:	6a 00                	push   $0x0
  pushl $23
  101e83:	6a 17                	push   $0x17
  jmp __alltraps
  101e85:	e9 14 ff ff ff       	jmp    101d9e <__alltraps>

00101e8a <vector24>:
.globl vector24
vector24:
  pushl $0
  101e8a:	6a 00                	push   $0x0
  pushl $24
  101e8c:	6a 18                	push   $0x18
  jmp __alltraps
  101e8e:	e9 0b ff ff ff       	jmp    101d9e <__alltraps>

00101e93 <vector25>:
.globl vector25
vector25:
  pushl $0
  101e93:	6a 00                	push   $0x0
  pushl $25
  101e95:	6a 19                	push   $0x19
  jmp __alltraps
  101e97:	e9 02 ff ff ff       	jmp    101d9e <__alltraps>

00101e9c <vector26>:
.globl vector26
vector26:
  pushl $0
  101e9c:	6a 00                	push   $0x0
  pushl $26
  101e9e:	6a 1a                	push   $0x1a
  jmp __alltraps
  101ea0:	e9 f9 fe ff ff       	jmp    101d9e <__alltraps>

00101ea5 <vector27>:
.globl vector27
vector27:
  pushl $0
  101ea5:	6a 00                	push   $0x0
  pushl $27
  101ea7:	6a 1b                	push   $0x1b
  jmp __alltraps
  101ea9:	e9 f0 fe ff ff       	jmp    101d9e <__alltraps>

00101eae <vector28>:
.globl vector28
vector28:
  pushl $0
  101eae:	6a 00                	push   $0x0
  pushl $28
  101eb0:	6a 1c                	push   $0x1c
  jmp __alltraps
  101eb2:	e9 e7 fe ff ff       	jmp    101d9e <__alltraps>

00101eb7 <vector29>:
.globl vector29
vector29:
  pushl $0
  101eb7:	6a 00                	push   $0x0
  pushl $29
  101eb9:	6a 1d                	push   $0x1d
  jmp __alltraps
  101ebb:	e9 de fe ff ff       	jmp    101d9e <__alltraps>

00101ec0 <vector30>:
.globl vector30
vector30:
  pushl $0
  101ec0:	6a 00                	push   $0x0
  pushl $30
  101ec2:	6a 1e                	push   $0x1e
  jmp __alltraps
  101ec4:	e9 d5 fe ff ff       	jmp    101d9e <__alltraps>

00101ec9 <vector31>:
.globl vector31
vector31:
  pushl $0
  101ec9:	6a 00                	push   $0x0
  pushl $31
  101ecb:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ecd:	e9 cc fe ff ff       	jmp    101d9e <__alltraps>

00101ed2 <vector32>:
.globl vector32
vector32:
  pushl $0
  101ed2:	6a 00                	push   $0x0
  pushl $32
  101ed4:	6a 20                	push   $0x20
  jmp __alltraps
  101ed6:	e9 c3 fe ff ff       	jmp    101d9e <__alltraps>

00101edb <vector33>:
.globl vector33
vector33:
  pushl $0
  101edb:	6a 00                	push   $0x0
  pushl $33
  101edd:	6a 21                	push   $0x21
  jmp __alltraps
  101edf:	e9 ba fe ff ff       	jmp    101d9e <__alltraps>

00101ee4 <vector34>:
.globl vector34
vector34:
  pushl $0
  101ee4:	6a 00                	push   $0x0
  pushl $34
  101ee6:	6a 22                	push   $0x22
  jmp __alltraps
  101ee8:	e9 b1 fe ff ff       	jmp    101d9e <__alltraps>

00101eed <vector35>:
.globl vector35
vector35:
  pushl $0
  101eed:	6a 00                	push   $0x0
  pushl $35
  101eef:	6a 23                	push   $0x23
  jmp __alltraps
  101ef1:	e9 a8 fe ff ff       	jmp    101d9e <__alltraps>

00101ef6 <vector36>:
.globl vector36
vector36:
  pushl $0
  101ef6:	6a 00                	push   $0x0
  pushl $36
  101ef8:	6a 24                	push   $0x24
  jmp __alltraps
  101efa:	e9 9f fe ff ff       	jmp    101d9e <__alltraps>

00101eff <vector37>:
.globl vector37
vector37:
  pushl $0
  101eff:	6a 00                	push   $0x0
  pushl $37
  101f01:	6a 25                	push   $0x25
  jmp __alltraps
  101f03:	e9 96 fe ff ff       	jmp    101d9e <__alltraps>

00101f08 <vector38>:
.globl vector38
vector38:
  pushl $0
  101f08:	6a 00                	push   $0x0
  pushl $38
  101f0a:	6a 26                	push   $0x26
  jmp __alltraps
  101f0c:	e9 8d fe ff ff       	jmp    101d9e <__alltraps>

00101f11 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f11:	6a 00                	push   $0x0
  pushl $39
  101f13:	6a 27                	push   $0x27
  jmp __alltraps
  101f15:	e9 84 fe ff ff       	jmp    101d9e <__alltraps>

00101f1a <vector40>:
.globl vector40
vector40:
  pushl $0
  101f1a:	6a 00                	push   $0x0
  pushl $40
  101f1c:	6a 28                	push   $0x28
  jmp __alltraps
  101f1e:	e9 7b fe ff ff       	jmp    101d9e <__alltraps>

00101f23 <vector41>:
.globl vector41
vector41:
  pushl $0
  101f23:	6a 00                	push   $0x0
  pushl $41
  101f25:	6a 29                	push   $0x29
  jmp __alltraps
  101f27:	e9 72 fe ff ff       	jmp    101d9e <__alltraps>

00101f2c <vector42>:
.globl vector42
vector42:
  pushl $0
  101f2c:	6a 00                	push   $0x0
  pushl $42
  101f2e:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f30:	e9 69 fe ff ff       	jmp    101d9e <__alltraps>

00101f35 <vector43>:
.globl vector43
vector43:
  pushl $0
  101f35:	6a 00                	push   $0x0
  pushl $43
  101f37:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f39:	e9 60 fe ff ff       	jmp    101d9e <__alltraps>

00101f3e <vector44>:
.globl vector44
vector44:
  pushl $0
  101f3e:	6a 00                	push   $0x0
  pushl $44
  101f40:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f42:	e9 57 fe ff ff       	jmp    101d9e <__alltraps>

00101f47 <vector45>:
.globl vector45
vector45:
  pushl $0
  101f47:	6a 00                	push   $0x0
  pushl $45
  101f49:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f4b:	e9 4e fe ff ff       	jmp    101d9e <__alltraps>

00101f50 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f50:	6a 00                	push   $0x0
  pushl $46
  101f52:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f54:	e9 45 fe ff ff       	jmp    101d9e <__alltraps>

00101f59 <vector47>:
.globl vector47
vector47:
  pushl $0
  101f59:	6a 00                	push   $0x0
  pushl $47
  101f5b:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f5d:	e9 3c fe ff ff       	jmp    101d9e <__alltraps>

00101f62 <vector48>:
.globl vector48
vector48:
  pushl $0
  101f62:	6a 00                	push   $0x0
  pushl $48
  101f64:	6a 30                	push   $0x30
  jmp __alltraps
  101f66:	e9 33 fe ff ff       	jmp    101d9e <__alltraps>

00101f6b <vector49>:
.globl vector49
vector49:
  pushl $0
  101f6b:	6a 00                	push   $0x0
  pushl $49
  101f6d:	6a 31                	push   $0x31
  jmp __alltraps
  101f6f:	e9 2a fe ff ff       	jmp    101d9e <__alltraps>

00101f74 <vector50>:
.globl vector50
vector50:
  pushl $0
  101f74:	6a 00                	push   $0x0
  pushl $50
  101f76:	6a 32                	push   $0x32
  jmp __alltraps
  101f78:	e9 21 fe ff ff       	jmp    101d9e <__alltraps>

00101f7d <vector51>:
.globl vector51
vector51:
  pushl $0
  101f7d:	6a 00                	push   $0x0
  pushl $51
  101f7f:	6a 33                	push   $0x33
  jmp __alltraps
  101f81:	e9 18 fe ff ff       	jmp    101d9e <__alltraps>

00101f86 <vector52>:
.globl vector52
vector52:
  pushl $0
  101f86:	6a 00                	push   $0x0
  pushl $52
  101f88:	6a 34                	push   $0x34
  jmp __alltraps
  101f8a:	e9 0f fe ff ff       	jmp    101d9e <__alltraps>

00101f8f <vector53>:
.globl vector53
vector53:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $53
  101f91:	6a 35                	push   $0x35
  jmp __alltraps
  101f93:	e9 06 fe ff ff       	jmp    101d9e <__alltraps>

00101f98 <vector54>:
.globl vector54
vector54:
  pushl $0
  101f98:	6a 00                	push   $0x0
  pushl $54
  101f9a:	6a 36                	push   $0x36
  jmp __alltraps
  101f9c:	e9 fd fd ff ff       	jmp    101d9e <__alltraps>

00101fa1 <vector55>:
.globl vector55
vector55:
  pushl $0
  101fa1:	6a 00                	push   $0x0
  pushl $55
  101fa3:	6a 37                	push   $0x37
  jmp __alltraps
  101fa5:	e9 f4 fd ff ff       	jmp    101d9e <__alltraps>

00101faa <vector56>:
.globl vector56
vector56:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $56
  101fac:	6a 38                	push   $0x38
  jmp __alltraps
  101fae:	e9 eb fd ff ff       	jmp    101d9e <__alltraps>

00101fb3 <vector57>:
.globl vector57
vector57:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $57
  101fb5:	6a 39                	push   $0x39
  jmp __alltraps
  101fb7:	e9 e2 fd ff ff       	jmp    101d9e <__alltraps>

00101fbc <vector58>:
.globl vector58
vector58:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $58
  101fbe:	6a 3a                	push   $0x3a
  jmp __alltraps
  101fc0:	e9 d9 fd ff ff       	jmp    101d9e <__alltraps>

00101fc5 <vector59>:
.globl vector59
vector59:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $59
  101fc7:	6a 3b                	push   $0x3b
  jmp __alltraps
  101fc9:	e9 d0 fd ff ff       	jmp    101d9e <__alltraps>

00101fce <vector60>:
.globl vector60
vector60:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $60
  101fd0:	6a 3c                	push   $0x3c
  jmp __alltraps
  101fd2:	e9 c7 fd ff ff       	jmp    101d9e <__alltraps>

00101fd7 <vector61>:
.globl vector61
vector61:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $61
  101fd9:	6a 3d                	push   $0x3d
  jmp __alltraps
  101fdb:	e9 be fd ff ff       	jmp    101d9e <__alltraps>

00101fe0 <vector62>:
.globl vector62
vector62:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $62
  101fe2:	6a 3e                	push   $0x3e
  jmp __alltraps
  101fe4:	e9 b5 fd ff ff       	jmp    101d9e <__alltraps>

00101fe9 <vector63>:
.globl vector63
vector63:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $63
  101feb:	6a 3f                	push   $0x3f
  jmp __alltraps
  101fed:	e9 ac fd ff ff       	jmp    101d9e <__alltraps>

00101ff2 <vector64>:
.globl vector64
vector64:
  pushl $0
  101ff2:	6a 00                	push   $0x0
  pushl $64
  101ff4:	6a 40                	push   $0x40
  jmp __alltraps
  101ff6:	e9 a3 fd ff ff       	jmp    101d9e <__alltraps>

00101ffb <vector65>:
.globl vector65
vector65:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $65
  101ffd:	6a 41                	push   $0x41
  jmp __alltraps
  101fff:	e9 9a fd ff ff       	jmp    101d9e <__alltraps>

00102004 <vector66>:
.globl vector66
vector66:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $66
  102006:	6a 42                	push   $0x42
  jmp __alltraps
  102008:	e9 91 fd ff ff       	jmp    101d9e <__alltraps>

0010200d <vector67>:
.globl vector67
vector67:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $67
  10200f:	6a 43                	push   $0x43
  jmp __alltraps
  102011:	e9 88 fd ff ff       	jmp    101d9e <__alltraps>

00102016 <vector68>:
.globl vector68
vector68:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $68
  102018:	6a 44                	push   $0x44
  jmp __alltraps
  10201a:	e9 7f fd ff ff       	jmp    101d9e <__alltraps>

0010201f <vector69>:
.globl vector69
vector69:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $69
  102021:	6a 45                	push   $0x45
  jmp __alltraps
  102023:	e9 76 fd ff ff       	jmp    101d9e <__alltraps>

00102028 <vector70>:
.globl vector70
vector70:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $70
  10202a:	6a 46                	push   $0x46
  jmp __alltraps
  10202c:	e9 6d fd ff ff       	jmp    101d9e <__alltraps>

00102031 <vector71>:
.globl vector71
vector71:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $71
  102033:	6a 47                	push   $0x47
  jmp __alltraps
  102035:	e9 64 fd ff ff       	jmp    101d9e <__alltraps>

0010203a <vector72>:
.globl vector72
vector72:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $72
  10203c:	6a 48                	push   $0x48
  jmp __alltraps
  10203e:	e9 5b fd ff ff       	jmp    101d9e <__alltraps>

00102043 <vector73>:
.globl vector73
vector73:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $73
  102045:	6a 49                	push   $0x49
  jmp __alltraps
  102047:	e9 52 fd ff ff       	jmp    101d9e <__alltraps>

0010204c <vector74>:
.globl vector74
vector74:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $74
  10204e:	6a 4a                	push   $0x4a
  jmp __alltraps
  102050:	e9 49 fd ff ff       	jmp    101d9e <__alltraps>

00102055 <vector75>:
.globl vector75
vector75:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $75
  102057:	6a 4b                	push   $0x4b
  jmp __alltraps
  102059:	e9 40 fd ff ff       	jmp    101d9e <__alltraps>

0010205e <vector76>:
.globl vector76
vector76:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $76
  102060:	6a 4c                	push   $0x4c
  jmp __alltraps
  102062:	e9 37 fd ff ff       	jmp    101d9e <__alltraps>

00102067 <vector77>:
.globl vector77
vector77:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $77
  102069:	6a 4d                	push   $0x4d
  jmp __alltraps
  10206b:	e9 2e fd ff ff       	jmp    101d9e <__alltraps>

00102070 <vector78>:
.globl vector78
vector78:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $78
  102072:	6a 4e                	push   $0x4e
  jmp __alltraps
  102074:	e9 25 fd ff ff       	jmp    101d9e <__alltraps>

00102079 <vector79>:
.globl vector79
vector79:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $79
  10207b:	6a 4f                	push   $0x4f
  jmp __alltraps
  10207d:	e9 1c fd ff ff       	jmp    101d9e <__alltraps>

00102082 <vector80>:
.globl vector80
vector80:
  pushl $0
  102082:	6a 00                	push   $0x0
  pushl $80
  102084:	6a 50                	push   $0x50
  jmp __alltraps
  102086:	e9 13 fd ff ff       	jmp    101d9e <__alltraps>

0010208b <vector81>:
.globl vector81
vector81:
  pushl $0
  10208b:	6a 00                	push   $0x0
  pushl $81
  10208d:	6a 51                	push   $0x51
  jmp __alltraps
  10208f:	e9 0a fd ff ff       	jmp    101d9e <__alltraps>

00102094 <vector82>:
.globl vector82
vector82:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $82
  102096:	6a 52                	push   $0x52
  jmp __alltraps
  102098:	e9 01 fd ff ff       	jmp    101d9e <__alltraps>

0010209d <vector83>:
.globl vector83
vector83:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $83
  10209f:	6a 53                	push   $0x53
  jmp __alltraps
  1020a1:	e9 f8 fc ff ff       	jmp    101d9e <__alltraps>

001020a6 <vector84>:
.globl vector84
vector84:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $84
  1020a8:	6a 54                	push   $0x54
  jmp __alltraps
  1020aa:	e9 ef fc ff ff       	jmp    101d9e <__alltraps>

001020af <vector85>:
.globl vector85
vector85:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $85
  1020b1:	6a 55                	push   $0x55
  jmp __alltraps
  1020b3:	e9 e6 fc ff ff       	jmp    101d9e <__alltraps>

001020b8 <vector86>:
.globl vector86
vector86:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $86
  1020ba:	6a 56                	push   $0x56
  jmp __alltraps
  1020bc:	e9 dd fc ff ff       	jmp    101d9e <__alltraps>

001020c1 <vector87>:
.globl vector87
vector87:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $87
  1020c3:	6a 57                	push   $0x57
  jmp __alltraps
  1020c5:	e9 d4 fc ff ff       	jmp    101d9e <__alltraps>

001020ca <vector88>:
.globl vector88
vector88:
  pushl $0
  1020ca:	6a 00                	push   $0x0
  pushl $88
  1020cc:	6a 58                	push   $0x58
  jmp __alltraps
  1020ce:	e9 cb fc ff ff       	jmp    101d9e <__alltraps>

001020d3 <vector89>:
.globl vector89
vector89:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $89
  1020d5:	6a 59                	push   $0x59
  jmp __alltraps
  1020d7:	e9 c2 fc ff ff       	jmp    101d9e <__alltraps>

001020dc <vector90>:
.globl vector90
vector90:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $90
  1020de:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020e0:	e9 b9 fc ff ff       	jmp    101d9e <__alltraps>

001020e5 <vector91>:
.globl vector91
vector91:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $91
  1020e7:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020e9:	e9 b0 fc ff ff       	jmp    101d9e <__alltraps>

001020ee <vector92>:
.globl vector92
vector92:
  pushl $0
  1020ee:	6a 00                	push   $0x0
  pushl $92
  1020f0:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020f2:	e9 a7 fc ff ff       	jmp    101d9e <__alltraps>

001020f7 <vector93>:
.globl vector93
vector93:
  pushl $0
  1020f7:	6a 00                	push   $0x0
  pushl $93
  1020f9:	6a 5d                	push   $0x5d
  jmp __alltraps
  1020fb:	e9 9e fc ff ff       	jmp    101d9e <__alltraps>

00102100 <vector94>:
.globl vector94
vector94:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $94
  102102:	6a 5e                	push   $0x5e
  jmp __alltraps
  102104:	e9 95 fc ff ff       	jmp    101d9e <__alltraps>

00102109 <vector95>:
.globl vector95
vector95:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $95
  10210b:	6a 5f                	push   $0x5f
  jmp __alltraps
  10210d:	e9 8c fc ff ff       	jmp    101d9e <__alltraps>

00102112 <vector96>:
.globl vector96
vector96:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $96
  102114:	6a 60                	push   $0x60
  jmp __alltraps
  102116:	e9 83 fc ff ff       	jmp    101d9e <__alltraps>

0010211b <vector97>:
.globl vector97
vector97:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $97
  10211d:	6a 61                	push   $0x61
  jmp __alltraps
  10211f:	e9 7a fc ff ff       	jmp    101d9e <__alltraps>

00102124 <vector98>:
.globl vector98
vector98:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $98
  102126:	6a 62                	push   $0x62
  jmp __alltraps
  102128:	e9 71 fc ff ff       	jmp    101d9e <__alltraps>

0010212d <vector99>:
.globl vector99
vector99:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $99
  10212f:	6a 63                	push   $0x63
  jmp __alltraps
  102131:	e9 68 fc ff ff       	jmp    101d9e <__alltraps>

00102136 <vector100>:
.globl vector100
vector100:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $100
  102138:	6a 64                	push   $0x64
  jmp __alltraps
  10213a:	e9 5f fc ff ff       	jmp    101d9e <__alltraps>

0010213f <vector101>:
.globl vector101
vector101:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $101
  102141:	6a 65                	push   $0x65
  jmp __alltraps
  102143:	e9 56 fc ff ff       	jmp    101d9e <__alltraps>

00102148 <vector102>:
.globl vector102
vector102:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $102
  10214a:	6a 66                	push   $0x66
  jmp __alltraps
  10214c:	e9 4d fc ff ff       	jmp    101d9e <__alltraps>

00102151 <vector103>:
.globl vector103
vector103:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $103
  102153:	6a 67                	push   $0x67
  jmp __alltraps
  102155:	e9 44 fc ff ff       	jmp    101d9e <__alltraps>

0010215a <vector104>:
.globl vector104
vector104:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $104
  10215c:	6a 68                	push   $0x68
  jmp __alltraps
  10215e:	e9 3b fc ff ff       	jmp    101d9e <__alltraps>

00102163 <vector105>:
.globl vector105
vector105:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $105
  102165:	6a 69                	push   $0x69
  jmp __alltraps
  102167:	e9 32 fc ff ff       	jmp    101d9e <__alltraps>

0010216c <vector106>:
.globl vector106
vector106:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $106
  10216e:	6a 6a                	push   $0x6a
  jmp __alltraps
  102170:	e9 29 fc ff ff       	jmp    101d9e <__alltraps>

00102175 <vector107>:
.globl vector107
vector107:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $107
  102177:	6a 6b                	push   $0x6b
  jmp __alltraps
  102179:	e9 20 fc ff ff       	jmp    101d9e <__alltraps>

0010217e <vector108>:
.globl vector108
vector108:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $108
  102180:	6a 6c                	push   $0x6c
  jmp __alltraps
  102182:	e9 17 fc ff ff       	jmp    101d9e <__alltraps>

00102187 <vector109>:
.globl vector109
vector109:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $109
  102189:	6a 6d                	push   $0x6d
  jmp __alltraps
  10218b:	e9 0e fc ff ff       	jmp    101d9e <__alltraps>

00102190 <vector110>:
.globl vector110
vector110:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $110
  102192:	6a 6e                	push   $0x6e
  jmp __alltraps
  102194:	e9 05 fc ff ff       	jmp    101d9e <__alltraps>

00102199 <vector111>:
.globl vector111
vector111:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $111
  10219b:	6a 6f                	push   $0x6f
  jmp __alltraps
  10219d:	e9 fc fb ff ff       	jmp    101d9e <__alltraps>

001021a2 <vector112>:
.globl vector112
vector112:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $112
  1021a4:	6a 70                	push   $0x70
  jmp __alltraps
  1021a6:	e9 f3 fb ff ff       	jmp    101d9e <__alltraps>

001021ab <vector113>:
.globl vector113
vector113:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $113
  1021ad:	6a 71                	push   $0x71
  jmp __alltraps
  1021af:	e9 ea fb ff ff       	jmp    101d9e <__alltraps>

001021b4 <vector114>:
.globl vector114
vector114:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $114
  1021b6:	6a 72                	push   $0x72
  jmp __alltraps
  1021b8:	e9 e1 fb ff ff       	jmp    101d9e <__alltraps>

001021bd <vector115>:
.globl vector115
vector115:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $115
  1021bf:	6a 73                	push   $0x73
  jmp __alltraps
  1021c1:	e9 d8 fb ff ff       	jmp    101d9e <__alltraps>

001021c6 <vector116>:
.globl vector116
vector116:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $116
  1021c8:	6a 74                	push   $0x74
  jmp __alltraps
  1021ca:	e9 cf fb ff ff       	jmp    101d9e <__alltraps>

001021cf <vector117>:
.globl vector117
vector117:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $117
  1021d1:	6a 75                	push   $0x75
  jmp __alltraps
  1021d3:	e9 c6 fb ff ff       	jmp    101d9e <__alltraps>

001021d8 <vector118>:
.globl vector118
vector118:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $118
  1021da:	6a 76                	push   $0x76
  jmp __alltraps
  1021dc:	e9 bd fb ff ff       	jmp    101d9e <__alltraps>

001021e1 <vector119>:
.globl vector119
vector119:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $119
  1021e3:	6a 77                	push   $0x77
  jmp __alltraps
  1021e5:	e9 b4 fb ff ff       	jmp    101d9e <__alltraps>

001021ea <vector120>:
.globl vector120
vector120:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $120
  1021ec:	6a 78                	push   $0x78
  jmp __alltraps
  1021ee:	e9 ab fb ff ff       	jmp    101d9e <__alltraps>

001021f3 <vector121>:
.globl vector121
vector121:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $121
  1021f5:	6a 79                	push   $0x79
  jmp __alltraps
  1021f7:	e9 a2 fb ff ff       	jmp    101d9e <__alltraps>

001021fc <vector122>:
.globl vector122
vector122:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $122
  1021fe:	6a 7a                	push   $0x7a
  jmp __alltraps
  102200:	e9 99 fb ff ff       	jmp    101d9e <__alltraps>

00102205 <vector123>:
.globl vector123
vector123:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $123
  102207:	6a 7b                	push   $0x7b
  jmp __alltraps
  102209:	e9 90 fb ff ff       	jmp    101d9e <__alltraps>

0010220e <vector124>:
.globl vector124
vector124:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $124
  102210:	6a 7c                	push   $0x7c
  jmp __alltraps
  102212:	e9 87 fb ff ff       	jmp    101d9e <__alltraps>

00102217 <vector125>:
.globl vector125
vector125:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $125
  102219:	6a 7d                	push   $0x7d
  jmp __alltraps
  10221b:	e9 7e fb ff ff       	jmp    101d9e <__alltraps>

00102220 <vector126>:
.globl vector126
vector126:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $126
  102222:	6a 7e                	push   $0x7e
  jmp __alltraps
  102224:	e9 75 fb ff ff       	jmp    101d9e <__alltraps>

00102229 <vector127>:
.globl vector127
vector127:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $127
  10222b:	6a 7f                	push   $0x7f
  jmp __alltraps
  10222d:	e9 6c fb ff ff       	jmp    101d9e <__alltraps>

00102232 <vector128>:
.globl vector128
vector128:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $128
  102234:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102239:	e9 60 fb ff ff       	jmp    101d9e <__alltraps>

0010223e <vector129>:
.globl vector129
vector129:
  pushl $0
  10223e:	6a 00                	push   $0x0
  pushl $129
  102240:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102245:	e9 54 fb ff ff       	jmp    101d9e <__alltraps>

0010224a <vector130>:
.globl vector130
vector130:
  pushl $0
  10224a:	6a 00                	push   $0x0
  pushl $130
  10224c:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102251:	e9 48 fb ff ff       	jmp    101d9e <__alltraps>

00102256 <vector131>:
.globl vector131
vector131:
  pushl $0
  102256:	6a 00                	push   $0x0
  pushl $131
  102258:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10225d:	e9 3c fb ff ff       	jmp    101d9e <__alltraps>

00102262 <vector132>:
.globl vector132
vector132:
  pushl $0
  102262:	6a 00                	push   $0x0
  pushl $132
  102264:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102269:	e9 30 fb ff ff       	jmp    101d9e <__alltraps>

0010226e <vector133>:
.globl vector133
vector133:
  pushl $0
  10226e:	6a 00                	push   $0x0
  pushl $133
  102270:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102275:	e9 24 fb ff ff       	jmp    101d9e <__alltraps>

0010227a <vector134>:
.globl vector134
vector134:
  pushl $0
  10227a:	6a 00                	push   $0x0
  pushl $134
  10227c:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102281:	e9 18 fb ff ff       	jmp    101d9e <__alltraps>

00102286 <vector135>:
.globl vector135
vector135:
  pushl $0
  102286:	6a 00                	push   $0x0
  pushl $135
  102288:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10228d:	e9 0c fb ff ff       	jmp    101d9e <__alltraps>

00102292 <vector136>:
.globl vector136
vector136:
  pushl $0
  102292:	6a 00                	push   $0x0
  pushl $136
  102294:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102299:	e9 00 fb ff ff       	jmp    101d9e <__alltraps>

0010229e <vector137>:
.globl vector137
vector137:
  pushl $0
  10229e:	6a 00                	push   $0x0
  pushl $137
  1022a0:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1022a5:	e9 f4 fa ff ff       	jmp    101d9e <__alltraps>

001022aa <vector138>:
.globl vector138
vector138:
  pushl $0
  1022aa:	6a 00                	push   $0x0
  pushl $138
  1022ac:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1022b1:	e9 e8 fa ff ff       	jmp    101d9e <__alltraps>

001022b6 <vector139>:
.globl vector139
vector139:
  pushl $0
  1022b6:	6a 00                	push   $0x0
  pushl $139
  1022b8:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1022bd:	e9 dc fa ff ff       	jmp    101d9e <__alltraps>

001022c2 <vector140>:
.globl vector140
vector140:
  pushl $0
  1022c2:	6a 00                	push   $0x0
  pushl $140
  1022c4:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1022c9:	e9 d0 fa ff ff       	jmp    101d9e <__alltraps>

001022ce <vector141>:
.globl vector141
vector141:
  pushl $0
  1022ce:	6a 00                	push   $0x0
  pushl $141
  1022d0:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1022d5:	e9 c4 fa ff ff       	jmp    101d9e <__alltraps>

001022da <vector142>:
.globl vector142
vector142:
  pushl $0
  1022da:	6a 00                	push   $0x0
  pushl $142
  1022dc:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022e1:	e9 b8 fa ff ff       	jmp    101d9e <__alltraps>

001022e6 <vector143>:
.globl vector143
vector143:
  pushl $0
  1022e6:	6a 00                	push   $0x0
  pushl $143
  1022e8:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022ed:	e9 ac fa ff ff       	jmp    101d9e <__alltraps>

001022f2 <vector144>:
.globl vector144
vector144:
  pushl $0
  1022f2:	6a 00                	push   $0x0
  pushl $144
  1022f4:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1022f9:	e9 a0 fa ff ff       	jmp    101d9e <__alltraps>

001022fe <vector145>:
.globl vector145
vector145:
  pushl $0
  1022fe:	6a 00                	push   $0x0
  pushl $145
  102300:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102305:	e9 94 fa ff ff       	jmp    101d9e <__alltraps>

0010230a <vector146>:
.globl vector146
vector146:
  pushl $0
  10230a:	6a 00                	push   $0x0
  pushl $146
  10230c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102311:	e9 88 fa ff ff       	jmp    101d9e <__alltraps>

00102316 <vector147>:
.globl vector147
vector147:
  pushl $0
  102316:	6a 00                	push   $0x0
  pushl $147
  102318:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10231d:	e9 7c fa ff ff       	jmp    101d9e <__alltraps>

00102322 <vector148>:
.globl vector148
vector148:
  pushl $0
  102322:	6a 00                	push   $0x0
  pushl $148
  102324:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102329:	e9 70 fa ff ff       	jmp    101d9e <__alltraps>

0010232e <vector149>:
.globl vector149
vector149:
  pushl $0
  10232e:	6a 00                	push   $0x0
  pushl $149
  102330:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102335:	e9 64 fa ff ff       	jmp    101d9e <__alltraps>

0010233a <vector150>:
.globl vector150
vector150:
  pushl $0
  10233a:	6a 00                	push   $0x0
  pushl $150
  10233c:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102341:	e9 58 fa ff ff       	jmp    101d9e <__alltraps>

00102346 <vector151>:
.globl vector151
vector151:
  pushl $0
  102346:	6a 00                	push   $0x0
  pushl $151
  102348:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10234d:	e9 4c fa ff ff       	jmp    101d9e <__alltraps>

00102352 <vector152>:
.globl vector152
vector152:
  pushl $0
  102352:	6a 00                	push   $0x0
  pushl $152
  102354:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102359:	e9 40 fa ff ff       	jmp    101d9e <__alltraps>

0010235e <vector153>:
.globl vector153
vector153:
  pushl $0
  10235e:	6a 00                	push   $0x0
  pushl $153
  102360:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102365:	e9 34 fa ff ff       	jmp    101d9e <__alltraps>

0010236a <vector154>:
.globl vector154
vector154:
  pushl $0
  10236a:	6a 00                	push   $0x0
  pushl $154
  10236c:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102371:	e9 28 fa ff ff       	jmp    101d9e <__alltraps>

00102376 <vector155>:
.globl vector155
vector155:
  pushl $0
  102376:	6a 00                	push   $0x0
  pushl $155
  102378:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10237d:	e9 1c fa ff ff       	jmp    101d9e <__alltraps>

00102382 <vector156>:
.globl vector156
vector156:
  pushl $0
  102382:	6a 00                	push   $0x0
  pushl $156
  102384:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102389:	e9 10 fa ff ff       	jmp    101d9e <__alltraps>

0010238e <vector157>:
.globl vector157
vector157:
  pushl $0
  10238e:	6a 00                	push   $0x0
  pushl $157
  102390:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102395:	e9 04 fa ff ff       	jmp    101d9e <__alltraps>

0010239a <vector158>:
.globl vector158
vector158:
  pushl $0
  10239a:	6a 00                	push   $0x0
  pushl $158
  10239c:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1023a1:	e9 f8 f9 ff ff       	jmp    101d9e <__alltraps>

001023a6 <vector159>:
.globl vector159
vector159:
  pushl $0
  1023a6:	6a 00                	push   $0x0
  pushl $159
  1023a8:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1023ad:	e9 ec f9 ff ff       	jmp    101d9e <__alltraps>

001023b2 <vector160>:
.globl vector160
vector160:
  pushl $0
  1023b2:	6a 00                	push   $0x0
  pushl $160
  1023b4:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1023b9:	e9 e0 f9 ff ff       	jmp    101d9e <__alltraps>

001023be <vector161>:
.globl vector161
vector161:
  pushl $0
  1023be:	6a 00                	push   $0x0
  pushl $161
  1023c0:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1023c5:	e9 d4 f9 ff ff       	jmp    101d9e <__alltraps>

001023ca <vector162>:
.globl vector162
vector162:
  pushl $0
  1023ca:	6a 00                	push   $0x0
  pushl $162
  1023cc:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1023d1:	e9 c8 f9 ff ff       	jmp    101d9e <__alltraps>

001023d6 <vector163>:
.globl vector163
vector163:
  pushl $0
  1023d6:	6a 00                	push   $0x0
  pushl $163
  1023d8:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023dd:	e9 bc f9 ff ff       	jmp    101d9e <__alltraps>

001023e2 <vector164>:
.globl vector164
vector164:
  pushl $0
  1023e2:	6a 00                	push   $0x0
  pushl $164
  1023e4:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023e9:	e9 b0 f9 ff ff       	jmp    101d9e <__alltraps>

001023ee <vector165>:
.globl vector165
vector165:
  pushl $0
  1023ee:	6a 00                	push   $0x0
  pushl $165
  1023f0:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023f5:	e9 a4 f9 ff ff       	jmp    101d9e <__alltraps>

001023fa <vector166>:
.globl vector166
vector166:
  pushl $0
  1023fa:	6a 00                	push   $0x0
  pushl $166
  1023fc:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102401:	e9 98 f9 ff ff       	jmp    101d9e <__alltraps>

00102406 <vector167>:
.globl vector167
vector167:
  pushl $0
  102406:	6a 00                	push   $0x0
  pushl $167
  102408:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10240d:	e9 8c f9 ff ff       	jmp    101d9e <__alltraps>

00102412 <vector168>:
.globl vector168
vector168:
  pushl $0
  102412:	6a 00                	push   $0x0
  pushl $168
  102414:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102419:	e9 80 f9 ff ff       	jmp    101d9e <__alltraps>

0010241e <vector169>:
.globl vector169
vector169:
  pushl $0
  10241e:	6a 00                	push   $0x0
  pushl $169
  102420:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102425:	e9 74 f9 ff ff       	jmp    101d9e <__alltraps>

0010242a <vector170>:
.globl vector170
vector170:
  pushl $0
  10242a:	6a 00                	push   $0x0
  pushl $170
  10242c:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102431:	e9 68 f9 ff ff       	jmp    101d9e <__alltraps>

00102436 <vector171>:
.globl vector171
vector171:
  pushl $0
  102436:	6a 00                	push   $0x0
  pushl $171
  102438:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10243d:	e9 5c f9 ff ff       	jmp    101d9e <__alltraps>

00102442 <vector172>:
.globl vector172
vector172:
  pushl $0
  102442:	6a 00                	push   $0x0
  pushl $172
  102444:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102449:	e9 50 f9 ff ff       	jmp    101d9e <__alltraps>

0010244e <vector173>:
.globl vector173
vector173:
  pushl $0
  10244e:	6a 00                	push   $0x0
  pushl $173
  102450:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102455:	e9 44 f9 ff ff       	jmp    101d9e <__alltraps>

0010245a <vector174>:
.globl vector174
vector174:
  pushl $0
  10245a:	6a 00                	push   $0x0
  pushl $174
  10245c:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102461:	e9 38 f9 ff ff       	jmp    101d9e <__alltraps>

00102466 <vector175>:
.globl vector175
vector175:
  pushl $0
  102466:	6a 00                	push   $0x0
  pushl $175
  102468:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10246d:	e9 2c f9 ff ff       	jmp    101d9e <__alltraps>

00102472 <vector176>:
.globl vector176
vector176:
  pushl $0
  102472:	6a 00                	push   $0x0
  pushl $176
  102474:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102479:	e9 20 f9 ff ff       	jmp    101d9e <__alltraps>

0010247e <vector177>:
.globl vector177
vector177:
  pushl $0
  10247e:	6a 00                	push   $0x0
  pushl $177
  102480:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102485:	e9 14 f9 ff ff       	jmp    101d9e <__alltraps>

0010248a <vector178>:
.globl vector178
vector178:
  pushl $0
  10248a:	6a 00                	push   $0x0
  pushl $178
  10248c:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102491:	e9 08 f9 ff ff       	jmp    101d9e <__alltraps>

00102496 <vector179>:
.globl vector179
vector179:
  pushl $0
  102496:	6a 00                	push   $0x0
  pushl $179
  102498:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10249d:	e9 fc f8 ff ff       	jmp    101d9e <__alltraps>

001024a2 <vector180>:
.globl vector180
vector180:
  pushl $0
  1024a2:	6a 00                	push   $0x0
  pushl $180
  1024a4:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1024a9:	e9 f0 f8 ff ff       	jmp    101d9e <__alltraps>

001024ae <vector181>:
.globl vector181
vector181:
  pushl $0
  1024ae:	6a 00                	push   $0x0
  pushl $181
  1024b0:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1024b5:	e9 e4 f8 ff ff       	jmp    101d9e <__alltraps>

001024ba <vector182>:
.globl vector182
vector182:
  pushl $0
  1024ba:	6a 00                	push   $0x0
  pushl $182
  1024bc:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1024c1:	e9 d8 f8 ff ff       	jmp    101d9e <__alltraps>

001024c6 <vector183>:
.globl vector183
vector183:
  pushl $0
  1024c6:	6a 00                	push   $0x0
  pushl $183
  1024c8:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1024cd:	e9 cc f8 ff ff       	jmp    101d9e <__alltraps>

001024d2 <vector184>:
.globl vector184
vector184:
  pushl $0
  1024d2:	6a 00                	push   $0x0
  pushl $184
  1024d4:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024d9:	e9 c0 f8 ff ff       	jmp    101d9e <__alltraps>

001024de <vector185>:
.globl vector185
vector185:
  pushl $0
  1024de:	6a 00                	push   $0x0
  pushl $185
  1024e0:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1024e5:	e9 b4 f8 ff ff       	jmp    101d9e <__alltraps>

001024ea <vector186>:
.globl vector186
vector186:
  pushl $0
  1024ea:	6a 00                	push   $0x0
  pushl $186
  1024ec:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024f1:	e9 a8 f8 ff ff       	jmp    101d9e <__alltraps>

001024f6 <vector187>:
.globl vector187
vector187:
  pushl $0
  1024f6:	6a 00                	push   $0x0
  pushl $187
  1024f8:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1024fd:	e9 9c f8 ff ff       	jmp    101d9e <__alltraps>

00102502 <vector188>:
.globl vector188
vector188:
  pushl $0
  102502:	6a 00                	push   $0x0
  pushl $188
  102504:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102509:	e9 90 f8 ff ff       	jmp    101d9e <__alltraps>

0010250e <vector189>:
.globl vector189
vector189:
  pushl $0
  10250e:	6a 00                	push   $0x0
  pushl $189
  102510:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102515:	e9 84 f8 ff ff       	jmp    101d9e <__alltraps>

0010251a <vector190>:
.globl vector190
vector190:
  pushl $0
  10251a:	6a 00                	push   $0x0
  pushl $190
  10251c:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102521:	e9 78 f8 ff ff       	jmp    101d9e <__alltraps>

00102526 <vector191>:
.globl vector191
vector191:
  pushl $0
  102526:	6a 00                	push   $0x0
  pushl $191
  102528:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10252d:	e9 6c f8 ff ff       	jmp    101d9e <__alltraps>

00102532 <vector192>:
.globl vector192
vector192:
  pushl $0
  102532:	6a 00                	push   $0x0
  pushl $192
  102534:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102539:	e9 60 f8 ff ff       	jmp    101d9e <__alltraps>

0010253e <vector193>:
.globl vector193
vector193:
  pushl $0
  10253e:	6a 00                	push   $0x0
  pushl $193
  102540:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102545:	e9 54 f8 ff ff       	jmp    101d9e <__alltraps>

0010254a <vector194>:
.globl vector194
vector194:
  pushl $0
  10254a:	6a 00                	push   $0x0
  pushl $194
  10254c:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102551:	e9 48 f8 ff ff       	jmp    101d9e <__alltraps>

00102556 <vector195>:
.globl vector195
vector195:
  pushl $0
  102556:	6a 00                	push   $0x0
  pushl $195
  102558:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10255d:	e9 3c f8 ff ff       	jmp    101d9e <__alltraps>

00102562 <vector196>:
.globl vector196
vector196:
  pushl $0
  102562:	6a 00                	push   $0x0
  pushl $196
  102564:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102569:	e9 30 f8 ff ff       	jmp    101d9e <__alltraps>

0010256e <vector197>:
.globl vector197
vector197:
  pushl $0
  10256e:	6a 00                	push   $0x0
  pushl $197
  102570:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102575:	e9 24 f8 ff ff       	jmp    101d9e <__alltraps>

0010257a <vector198>:
.globl vector198
vector198:
  pushl $0
  10257a:	6a 00                	push   $0x0
  pushl $198
  10257c:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102581:	e9 18 f8 ff ff       	jmp    101d9e <__alltraps>

00102586 <vector199>:
.globl vector199
vector199:
  pushl $0
  102586:	6a 00                	push   $0x0
  pushl $199
  102588:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10258d:	e9 0c f8 ff ff       	jmp    101d9e <__alltraps>

00102592 <vector200>:
.globl vector200
vector200:
  pushl $0
  102592:	6a 00                	push   $0x0
  pushl $200
  102594:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102599:	e9 00 f8 ff ff       	jmp    101d9e <__alltraps>

0010259e <vector201>:
.globl vector201
vector201:
  pushl $0
  10259e:	6a 00                	push   $0x0
  pushl $201
  1025a0:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1025a5:	e9 f4 f7 ff ff       	jmp    101d9e <__alltraps>

001025aa <vector202>:
.globl vector202
vector202:
  pushl $0
  1025aa:	6a 00                	push   $0x0
  pushl $202
  1025ac:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1025b1:	e9 e8 f7 ff ff       	jmp    101d9e <__alltraps>

001025b6 <vector203>:
.globl vector203
vector203:
  pushl $0
  1025b6:	6a 00                	push   $0x0
  pushl $203
  1025b8:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1025bd:	e9 dc f7 ff ff       	jmp    101d9e <__alltraps>

001025c2 <vector204>:
.globl vector204
vector204:
  pushl $0
  1025c2:	6a 00                	push   $0x0
  pushl $204
  1025c4:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1025c9:	e9 d0 f7 ff ff       	jmp    101d9e <__alltraps>

001025ce <vector205>:
.globl vector205
vector205:
  pushl $0
  1025ce:	6a 00                	push   $0x0
  pushl $205
  1025d0:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1025d5:	e9 c4 f7 ff ff       	jmp    101d9e <__alltraps>

001025da <vector206>:
.globl vector206
vector206:
  pushl $0
  1025da:	6a 00                	push   $0x0
  pushl $206
  1025dc:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025e1:	e9 b8 f7 ff ff       	jmp    101d9e <__alltraps>

001025e6 <vector207>:
.globl vector207
vector207:
  pushl $0
  1025e6:	6a 00                	push   $0x0
  pushl $207
  1025e8:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025ed:	e9 ac f7 ff ff       	jmp    101d9e <__alltraps>

001025f2 <vector208>:
.globl vector208
vector208:
  pushl $0
  1025f2:	6a 00                	push   $0x0
  pushl $208
  1025f4:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1025f9:	e9 a0 f7 ff ff       	jmp    101d9e <__alltraps>

001025fe <vector209>:
.globl vector209
vector209:
  pushl $0
  1025fe:	6a 00                	push   $0x0
  pushl $209
  102600:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102605:	e9 94 f7 ff ff       	jmp    101d9e <__alltraps>

0010260a <vector210>:
.globl vector210
vector210:
  pushl $0
  10260a:	6a 00                	push   $0x0
  pushl $210
  10260c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102611:	e9 88 f7 ff ff       	jmp    101d9e <__alltraps>

00102616 <vector211>:
.globl vector211
vector211:
  pushl $0
  102616:	6a 00                	push   $0x0
  pushl $211
  102618:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10261d:	e9 7c f7 ff ff       	jmp    101d9e <__alltraps>

00102622 <vector212>:
.globl vector212
vector212:
  pushl $0
  102622:	6a 00                	push   $0x0
  pushl $212
  102624:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102629:	e9 70 f7 ff ff       	jmp    101d9e <__alltraps>

0010262e <vector213>:
.globl vector213
vector213:
  pushl $0
  10262e:	6a 00                	push   $0x0
  pushl $213
  102630:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102635:	e9 64 f7 ff ff       	jmp    101d9e <__alltraps>

0010263a <vector214>:
.globl vector214
vector214:
  pushl $0
  10263a:	6a 00                	push   $0x0
  pushl $214
  10263c:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102641:	e9 58 f7 ff ff       	jmp    101d9e <__alltraps>

00102646 <vector215>:
.globl vector215
vector215:
  pushl $0
  102646:	6a 00                	push   $0x0
  pushl $215
  102648:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10264d:	e9 4c f7 ff ff       	jmp    101d9e <__alltraps>

00102652 <vector216>:
.globl vector216
vector216:
  pushl $0
  102652:	6a 00                	push   $0x0
  pushl $216
  102654:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102659:	e9 40 f7 ff ff       	jmp    101d9e <__alltraps>

0010265e <vector217>:
.globl vector217
vector217:
  pushl $0
  10265e:	6a 00                	push   $0x0
  pushl $217
  102660:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102665:	e9 34 f7 ff ff       	jmp    101d9e <__alltraps>

0010266a <vector218>:
.globl vector218
vector218:
  pushl $0
  10266a:	6a 00                	push   $0x0
  pushl $218
  10266c:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102671:	e9 28 f7 ff ff       	jmp    101d9e <__alltraps>

00102676 <vector219>:
.globl vector219
vector219:
  pushl $0
  102676:	6a 00                	push   $0x0
  pushl $219
  102678:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10267d:	e9 1c f7 ff ff       	jmp    101d9e <__alltraps>

00102682 <vector220>:
.globl vector220
vector220:
  pushl $0
  102682:	6a 00                	push   $0x0
  pushl $220
  102684:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102689:	e9 10 f7 ff ff       	jmp    101d9e <__alltraps>

0010268e <vector221>:
.globl vector221
vector221:
  pushl $0
  10268e:	6a 00                	push   $0x0
  pushl $221
  102690:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102695:	e9 04 f7 ff ff       	jmp    101d9e <__alltraps>

0010269a <vector222>:
.globl vector222
vector222:
  pushl $0
  10269a:	6a 00                	push   $0x0
  pushl $222
  10269c:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1026a1:	e9 f8 f6 ff ff       	jmp    101d9e <__alltraps>

001026a6 <vector223>:
.globl vector223
vector223:
  pushl $0
  1026a6:	6a 00                	push   $0x0
  pushl $223
  1026a8:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1026ad:	e9 ec f6 ff ff       	jmp    101d9e <__alltraps>

001026b2 <vector224>:
.globl vector224
vector224:
  pushl $0
  1026b2:	6a 00                	push   $0x0
  pushl $224
  1026b4:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1026b9:	e9 e0 f6 ff ff       	jmp    101d9e <__alltraps>

001026be <vector225>:
.globl vector225
vector225:
  pushl $0
  1026be:	6a 00                	push   $0x0
  pushl $225
  1026c0:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1026c5:	e9 d4 f6 ff ff       	jmp    101d9e <__alltraps>

001026ca <vector226>:
.globl vector226
vector226:
  pushl $0
  1026ca:	6a 00                	push   $0x0
  pushl $226
  1026cc:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1026d1:	e9 c8 f6 ff ff       	jmp    101d9e <__alltraps>

001026d6 <vector227>:
.globl vector227
vector227:
  pushl $0
  1026d6:	6a 00                	push   $0x0
  pushl $227
  1026d8:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026dd:	e9 bc f6 ff ff       	jmp    101d9e <__alltraps>

001026e2 <vector228>:
.globl vector228
vector228:
  pushl $0
  1026e2:	6a 00                	push   $0x0
  pushl $228
  1026e4:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026e9:	e9 b0 f6 ff ff       	jmp    101d9e <__alltraps>

001026ee <vector229>:
.globl vector229
vector229:
  pushl $0
  1026ee:	6a 00                	push   $0x0
  pushl $229
  1026f0:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026f5:	e9 a4 f6 ff ff       	jmp    101d9e <__alltraps>

001026fa <vector230>:
.globl vector230
vector230:
  pushl $0
  1026fa:	6a 00                	push   $0x0
  pushl $230
  1026fc:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102701:	e9 98 f6 ff ff       	jmp    101d9e <__alltraps>

00102706 <vector231>:
.globl vector231
vector231:
  pushl $0
  102706:	6a 00                	push   $0x0
  pushl $231
  102708:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10270d:	e9 8c f6 ff ff       	jmp    101d9e <__alltraps>

00102712 <vector232>:
.globl vector232
vector232:
  pushl $0
  102712:	6a 00                	push   $0x0
  pushl $232
  102714:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102719:	e9 80 f6 ff ff       	jmp    101d9e <__alltraps>

0010271e <vector233>:
.globl vector233
vector233:
  pushl $0
  10271e:	6a 00                	push   $0x0
  pushl $233
  102720:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102725:	e9 74 f6 ff ff       	jmp    101d9e <__alltraps>

0010272a <vector234>:
.globl vector234
vector234:
  pushl $0
  10272a:	6a 00                	push   $0x0
  pushl $234
  10272c:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102731:	e9 68 f6 ff ff       	jmp    101d9e <__alltraps>

00102736 <vector235>:
.globl vector235
vector235:
  pushl $0
  102736:	6a 00                	push   $0x0
  pushl $235
  102738:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10273d:	e9 5c f6 ff ff       	jmp    101d9e <__alltraps>

00102742 <vector236>:
.globl vector236
vector236:
  pushl $0
  102742:	6a 00                	push   $0x0
  pushl $236
  102744:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102749:	e9 50 f6 ff ff       	jmp    101d9e <__alltraps>

0010274e <vector237>:
.globl vector237
vector237:
  pushl $0
  10274e:	6a 00                	push   $0x0
  pushl $237
  102750:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102755:	e9 44 f6 ff ff       	jmp    101d9e <__alltraps>

0010275a <vector238>:
.globl vector238
vector238:
  pushl $0
  10275a:	6a 00                	push   $0x0
  pushl $238
  10275c:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102761:	e9 38 f6 ff ff       	jmp    101d9e <__alltraps>

00102766 <vector239>:
.globl vector239
vector239:
  pushl $0
  102766:	6a 00                	push   $0x0
  pushl $239
  102768:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10276d:	e9 2c f6 ff ff       	jmp    101d9e <__alltraps>

00102772 <vector240>:
.globl vector240
vector240:
  pushl $0
  102772:	6a 00                	push   $0x0
  pushl $240
  102774:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102779:	e9 20 f6 ff ff       	jmp    101d9e <__alltraps>

0010277e <vector241>:
.globl vector241
vector241:
  pushl $0
  10277e:	6a 00                	push   $0x0
  pushl $241
  102780:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102785:	e9 14 f6 ff ff       	jmp    101d9e <__alltraps>

0010278a <vector242>:
.globl vector242
vector242:
  pushl $0
  10278a:	6a 00                	push   $0x0
  pushl $242
  10278c:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102791:	e9 08 f6 ff ff       	jmp    101d9e <__alltraps>

00102796 <vector243>:
.globl vector243
vector243:
  pushl $0
  102796:	6a 00                	push   $0x0
  pushl $243
  102798:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10279d:	e9 fc f5 ff ff       	jmp    101d9e <__alltraps>

001027a2 <vector244>:
.globl vector244
vector244:
  pushl $0
  1027a2:	6a 00                	push   $0x0
  pushl $244
  1027a4:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1027a9:	e9 f0 f5 ff ff       	jmp    101d9e <__alltraps>

001027ae <vector245>:
.globl vector245
vector245:
  pushl $0
  1027ae:	6a 00                	push   $0x0
  pushl $245
  1027b0:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1027b5:	e9 e4 f5 ff ff       	jmp    101d9e <__alltraps>

001027ba <vector246>:
.globl vector246
vector246:
  pushl $0
  1027ba:	6a 00                	push   $0x0
  pushl $246
  1027bc:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1027c1:	e9 d8 f5 ff ff       	jmp    101d9e <__alltraps>

001027c6 <vector247>:
.globl vector247
vector247:
  pushl $0
  1027c6:	6a 00                	push   $0x0
  pushl $247
  1027c8:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1027cd:	e9 cc f5 ff ff       	jmp    101d9e <__alltraps>

001027d2 <vector248>:
.globl vector248
vector248:
  pushl $0
  1027d2:	6a 00                	push   $0x0
  pushl $248
  1027d4:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027d9:	e9 c0 f5 ff ff       	jmp    101d9e <__alltraps>

001027de <vector249>:
.globl vector249
vector249:
  pushl $0
  1027de:	6a 00                	push   $0x0
  pushl $249
  1027e0:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1027e5:	e9 b4 f5 ff ff       	jmp    101d9e <__alltraps>

001027ea <vector250>:
.globl vector250
vector250:
  pushl $0
  1027ea:	6a 00                	push   $0x0
  pushl $250
  1027ec:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027f1:	e9 a8 f5 ff ff       	jmp    101d9e <__alltraps>

001027f6 <vector251>:
.globl vector251
vector251:
  pushl $0
  1027f6:	6a 00                	push   $0x0
  pushl $251
  1027f8:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1027fd:	e9 9c f5 ff ff       	jmp    101d9e <__alltraps>

00102802 <vector252>:
.globl vector252
vector252:
  pushl $0
  102802:	6a 00                	push   $0x0
  pushl $252
  102804:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102809:	e9 90 f5 ff ff       	jmp    101d9e <__alltraps>

0010280e <vector253>:
.globl vector253
vector253:
  pushl $0
  10280e:	6a 00                	push   $0x0
  pushl $253
  102810:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102815:	e9 84 f5 ff ff       	jmp    101d9e <__alltraps>

0010281a <vector254>:
.globl vector254
vector254:
  pushl $0
  10281a:	6a 00                	push   $0x0
  pushl $254
  10281c:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102821:	e9 78 f5 ff ff       	jmp    101d9e <__alltraps>

00102826 <vector255>:
.globl vector255
vector255:
  pushl $0
  102826:	6a 00                	push   $0x0
  pushl $255
  102828:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10282d:	e9 6c f5 ff ff       	jmp    101d9e <__alltraps>

00102832 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102832:	55                   	push   %ebp
  102833:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102835:	8b 45 08             	mov    0x8(%ebp),%eax
  102838:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  10283b:	b8 23 00 00 00       	mov    $0x23,%eax
  102840:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102842:	b8 23 00 00 00       	mov    $0x23,%eax
  102847:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102849:	b8 10 00 00 00       	mov    $0x10,%eax
  10284e:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102850:	b8 10 00 00 00       	mov    $0x10,%eax
  102855:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102857:	b8 10 00 00 00       	mov    $0x10,%eax
  10285c:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  10285e:	ea 65 28 10 00 08 00 	ljmp   $0x8,$0x102865
}
  102865:	5d                   	pop    %ebp
  102866:	c3                   	ret    

00102867 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102867:	55                   	push   %ebp
  102868:	89 e5                	mov    %esp,%ebp
  10286a:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  10286d:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  102872:	05 00 04 00 00       	add    $0x400,%eax
  102877:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  10287c:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102883:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102885:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  10288c:	68 00 
  10288e:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102893:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102899:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10289e:	c1 e8 10             	shr    $0x10,%eax
  1028a1:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1028a6:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028ad:	83 e0 f0             	and    $0xfffffff0,%eax
  1028b0:	83 c8 09             	or     $0x9,%eax
  1028b3:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028b8:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028bf:	83 c8 10             	or     $0x10,%eax
  1028c2:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028c7:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028ce:	83 e0 9f             	and    $0xffffff9f,%eax
  1028d1:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028d6:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028dd:	83 c8 80             	or     $0xffffff80,%eax
  1028e0:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028e5:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028ec:	83 e0 f0             	and    $0xfffffff0,%eax
  1028ef:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028f4:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028fb:	83 e0 ef             	and    $0xffffffef,%eax
  1028fe:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102903:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10290a:	83 e0 df             	and    $0xffffffdf,%eax
  10290d:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102912:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102919:	83 c8 40             	or     $0x40,%eax
  10291c:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102921:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102928:	83 e0 7f             	and    $0x7f,%eax
  10292b:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102930:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102935:	c1 e8 18             	shr    $0x18,%eax
  102938:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  10293d:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102944:	83 e0 ef             	and    $0xffffffef,%eax
  102947:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  10294c:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102953:	e8 da fe ff ff       	call   102832 <lgdt>
  102958:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  10295e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102962:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102965:	c9                   	leave  
  102966:	c3                   	ret    

00102967 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102967:	55                   	push   %ebp
  102968:	89 e5                	mov    %esp,%ebp
    gdt_init();
  10296a:	e8 f8 fe ff ff       	call   102867 <gdt_init>
}
  10296f:	5d                   	pop    %ebp
  102970:	c3                   	ret    

00102971 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102971:	55                   	push   %ebp
  102972:	89 e5                	mov    %esp,%ebp
  102974:	83 ec 58             	sub    $0x58,%esp
  102977:	8b 45 10             	mov    0x10(%ebp),%eax
  10297a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10297d:	8b 45 14             	mov    0x14(%ebp),%eax
  102980:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102983:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102986:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102989:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10298c:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10298f:	8b 45 18             	mov    0x18(%ebp),%eax
  102992:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102995:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102998:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10299b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10299e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1029a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1029a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1029ab:	74 1c                	je     1029c9 <printnum+0x58>
  1029ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029b0:	ba 00 00 00 00       	mov    $0x0,%edx
  1029b5:	f7 75 e4             	divl   -0x1c(%ebp)
  1029b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1029bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029be:	ba 00 00 00 00       	mov    $0x0,%edx
  1029c3:	f7 75 e4             	divl   -0x1c(%ebp)
  1029c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1029c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1029cf:	f7 75 e4             	divl   -0x1c(%ebp)
  1029d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1029d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1029d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029de:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1029e1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1029e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029e7:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1029ea:	8b 45 18             	mov    0x18(%ebp),%eax
  1029ed:	ba 00 00 00 00       	mov    $0x0,%edx
  1029f2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1029f5:	77 56                	ja     102a4d <printnum+0xdc>
  1029f7:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1029fa:	72 05                	jb     102a01 <printnum+0x90>
  1029fc:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1029ff:	77 4c                	ja     102a4d <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102a01:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102a04:	8d 50 ff             	lea    -0x1(%eax),%edx
  102a07:	8b 45 20             	mov    0x20(%ebp),%eax
  102a0a:	89 44 24 18          	mov    %eax,0x18(%esp)
  102a0e:	89 54 24 14          	mov    %edx,0x14(%esp)
  102a12:	8b 45 18             	mov    0x18(%ebp),%eax
  102a15:	89 44 24 10          	mov    %eax,0x10(%esp)
  102a19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102a1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102a1f:	89 44 24 08          	mov    %eax,0x8(%esp)
  102a23:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a31:	89 04 24             	mov    %eax,(%esp)
  102a34:	e8 38 ff ff ff       	call   102971 <printnum>
  102a39:	eb 1c                	jmp    102a57 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a42:	8b 45 20             	mov    0x20(%ebp),%eax
  102a45:	89 04 24             	mov    %eax,(%esp)
  102a48:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4b:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102a4d:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102a51:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102a55:	7f e4                	jg     102a3b <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102a57:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a5a:	05 70 3c 10 00       	add    $0x103c70,%eax
  102a5f:	0f b6 00             	movzbl (%eax),%eax
  102a62:	0f be c0             	movsbl %al,%eax
  102a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a68:	89 54 24 04          	mov    %edx,0x4(%esp)
  102a6c:	89 04 24             	mov    %eax,(%esp)
  102a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a72:	ff d0                	call   *%eax
}
  102a74:	c9                   	leave  
  102a75:	c3                   	ret    

00102a76 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102a76:	55                   	push   %ebp
  102a77:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a79:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a7d:	7e 14                	jle    102a93 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a82:	8b 00                	mov    (%eax),%eax
  102a84:	8d 48 08             	lea    0x8(%eax),%ecx
  102a87:	8b 55 08             	mov    0x8(%ebp),%edx
  102a8a:	89 0a                	mov    %ecx,(%edx)
  102a8c:	8b 50 04             	mov    0x4(%eax),%edx
  102a8f:	8b 00                	mov    (%eax),%eax
  102a91:	eb 30                	jmp    102ac3 <getuint+0x4d>
    }
    else if (lflag) {
  102a93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a97:	74 16                	je     102aaf <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102a99:	8b 45 08             	mov    0x8(%ebp),%eax
  102a9c:	8b 00                	mov    (%eax),%eax
  102a9e:	8d 48 04             	lea    0x4(%eax),%ecx
  102aa1:	8b 55 08             	mov    0x8(%ebp),%edx
  102aa4:	89 0a                	mov    %ecx,(%edx)
  102aa6:	8b 00                	mov    (%eax),%eax
  102aa8:	ba 00 00 00 00       	mov    $0x0,%edx
  102aad:	eb 14                	jmp    102ac3 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab2:	8b 00                	mov    (%eax),%eax
  102ab4:	8d 48 04             	lea    0x4(%eax),%ecx
  102ab7:	8b 55 08             	mov    0x8(%ebp),%edx
  102aba:	89 0a                	mov    %ecx,(%edx)
  102abc:	8b 00                	mov    (%eax),%eax
  102abe:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102ac3:	5d                   	pop    %ebp
  102ac4:	c3                   	ret    

00102ac5 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102ac5:	55                   	push   %ebp
  102ac6:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102ac8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102acc:	7e 14                	jle    102ae2 <getint+0x1d>
        return va_arg(*ap, long long);
  102ace:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad1:	8b 00                	mov    (%eax),%eax
  102ad3:	8d 48 08             	lea    0x8(%eax),%ecx
  102ad6:	8b 55 08             	mov    0x8(%ebp),%edx
  102ad9:	89 0a                	mov    %ecx,(%edx)
  102adb:	8b 50 04             	mov    0x4(%eax),%edx
  102ade:	8b 00                	mov    (%eax),%eax
  102ae0:	eb 28                	jmp    102b0a <getint+0x45>
    }
    else if (lflag) {
  102ae2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102ae6:	74 12                	je     102afa <getint+0x35>
        return va_arg(*ap, long);
  102ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  102aeb:	8b 00                	mov    (%eax),%eax
  102aed:	8d 48 04             	lea    0x4(%eax),%ecx
  102af0:	8b 55 08             	mov    0x8(%ebp),%edx
  102af3:	89 0a                	mov    %ecx,(%edx)
  102af5:	8b 00                	mov    (%eax),%eax
  102af7:	99                   	cltd   
  102af8:	eb 10                	jmp    102b0a <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102afa:	8b 45 08             	mov    0x8(%ebp),%eax
  102afd:	8b 00                	mov    (%eax),%eax
  102aff:	8d 48 04             	lea    0x4(%eax),%ecx
  102b02:	8b 55 08             	mov    0x8(%ebp),%edx
  102b05:	89 0a                	mov    %ecx,(%edx)
  102b07:	8b 00                	mov    (%eax),%eax
  102b09:	99                   	cltd   
    }
}
  102b0a:	5d                   	pop    %ebp
  102b0b:	c3                   	ret    

00102b0c <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102b0c:	55                   	push   %ebp
  102b0d:	89 e5                	mov    %esp,%ebp
  102b0f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102b12:	8d 45 14             	lea    0x14(%ebp),%eax
  102b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b1b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102b1f:	8b 45 10             	mov    0x10(%ebp),%eax
  102b22:	89 44 24 08          	mov    %eax,0x8(%esp)
  102b26:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b29:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b30:	89 04 24             	mov    %eax,(%esp)
  102b33:	e8 02 00 00 00       	call   102b3a <vprintfmt>
    va_end(ap);
}
  102b38:	c9                   	leave  
  102b39:	c3                   	ret    

00102b3a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102b3a:	55                   	push   %ebp
  102b3b:	89 e5                	mov    %esp,%ebp
  102b3d:	56                   	push   %esi
  102b3e:	53                   	push   %ebx
  102b3f:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b42:	eb 18                	jmp    102b5c <vprintfmt+0x22>
            if (ch == '\0') {
  102b44:	85 db                	test   %ebx,%ebx
  102b46:	75 05                	jne    102b4d <vprintfmt+0x13>
                return;
  102b48:	e9 d1 03 00 00       	jmp    102f1e <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b50:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b54:	89 1c 24             	mov    %ebx,(%esp)
  102b57:	8b 45 08             	mov    0x8(%ebp),%eax
  102b5a:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b5c:	8b 45 10             	mov    0x10(%ebp),%eax
  102b5f:	8d 50 01             	lea    0x1(%eax),%edx
  102b62:	89 55 10             	mov    %edx,0x10(%ebp)
  102b65:	0f b6 00             	movzbl (%eax),%eax
  102b68:	0f b6 d8             	movzbl %al,%ebx
  102b6b:	83 fb 25             	cmp    $0x25,%ebx
  102b6e:	75 d4                	jne    102b44 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102b70:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102b74:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102b7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102b81:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102b88:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b8b:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102b8e:	8b 45 10             	mov    0x10(%ebp),%eax
  102b91:	8d 50 01             	lea    0x1(%eax),%edx
  102b94:	89 55 10             	mov    %edx,0x10(%ebp)
  102b97:	0f b6 00             	movzbl (%eax),%eax
  102b9a:	0f b6 d8             	movzbl %al,%ebx
  102b9d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102ba0:	83 f8 55             	cmp    $0x55,%eax
  102ba3:	0f 87 44 03 00 00    	ja     102eed <vprintfmt+0x3b3>
  102ba9:	8b 04 85 94 3c 10 00 	mov    0x103c94(,%eax,4),%eax
  102bb0:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102bb2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102bb6:	eb d6                	jmp    102b8e <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102bb8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102bbc:	eb d0                	jmp    102b8e <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102bbe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102bc5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102bc8:	89 d0                	mov    %edx,%eax
  102bca:	c1 e0 02             	shl    $0x2,%eax
  102bcd:	01 d0                	add    %edx,%eax
  102bcf:	01 c0                	add    %eax,%eax
  102bd1:	01 d8                	add    %ebx,%eax
  102bd3:	83 e8 30             	sub    $0x30,%eax
  102bd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102bd9:	8b 45 10             	mov    0x10(%ebp),%eax
  102bdc:	0f b6 00             	movzbl (%eax),%eax
  102bdf:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102be2:	83 fb 2f             	cmp    $0x2f,%ebx
  102be5:	7e 0b                	jle    102bf2 <vprintfmt+0xb8>
  102be7:	83 fb 39             	cmp    $0x39,%ebx
  102bea:	7f 06                	jg     102bf2 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102bec:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102bf0:	eb d3                	jmp    102bc5 <vprintfmt+0x8b>
            goto process_precision;
  102bf2:	eb 33                	jmp    102c27 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102bf4:	8b 45 14             	mov    0x14(%ebp),%eax
  102bf7:	8d 50 04             	lea    0x4(%eax),%edx
  102bfa:	89 55 14             	mov    %edx,0x14(%ebp)
  102bfd:	8b 00                	mov    (%eax),%eax
  102bff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102c02:	eb 23                	jmp    102c27 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102c04:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c08:	79 0c                	jns    102c16 <vprintfmt+0xdc>
                width = 0;
  102c0a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102c11:	e9 78 ff ff ff       	jmp    102b8e <vprintfmt+0x54>
  102c16:	e9 73 ff ff ff       	jmp    102b8e <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102c1b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102c22:	e9 67 ff ff ff       	jmp    102b8e <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102c27:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c2b:	79 12                	jns    102c3f <vprintfmt+0x105>
                width = precision, precision = -1;
  102c2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c30:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c33:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102c3a:	e9 4f ff ff ff       	jmp    102b8e <vprintfmt+0x54>
  102c3f:	e9 4a ff ff ff       	jmp    102b8e <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102c44:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102c48:	e9 41 ff ff ff       	jmp    102b8e <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102c4d:	8b 45 14             	mov    0x14(%ebp),%eax
  102c50:	8d 50 04             	lea    0x4(%eax),%edx
  102c53:	89 55 14             	mov    %edx,0x14(%ebp)
  102c56:	8b 00                	mov    (%eax),%eax
  102c58:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c5b:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c5f:	89 04 24             	mov    %eax,(%esp)
  102c62:	8b 45 08             	mov    0x8(%ebp),%eax
  102c65:	ff d0                	call   *%eax
            break;
  102c67:	e9 ac 02 00 00       	jmp    102f18 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102c6c:	8b 45 14             	mov    0x14(%ebp),%eax
  102c6f:	8d 50 04             	lea    0x4(%eax),%edx
  102c72:	89 55 14             	mov    %edx,0x14(%ebp)
  102c75:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102c77:	85 db                	test   %ebx,%ebx
  102c79:	79 02                	jns    102c7d <vprintfmt+0x143>
                err = -err;
  102c7b:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102c7d:	83 fb 06             	cmp    $0x6,%ebx
  102c80:	7f 0b                	jg     102c8d <vprintfmt+0x153>
  102c82:	8b 34 9d 54 3c 10 00 	mov    0x103c54(,%ebx,4),%esi
  102c89:	85 f6                	test   %esi,%esi
  102c8b:	75 23                	jne    102cb0 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102c8d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102c91:	c7 44 24 08 81 3c 10 	movl   $0x103c81,0x8(%esp)
  102c98:	00 
  102c99:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca3:	89 04 24             	mov    %eax,(%esp)
  102ca6:	e8 61 fe ff ff       	call   102b0c <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102cab:	e9 68 02 00 00       	jmp    102f18 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102cb0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102cb4:	c7 44 24 08 8a 3c 10 	movl   $0x103c8a,0x8(%esp)
  102cbb:	00 
  102cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc6:	89 04 24             	mov    %eax,(%esp)
  102cc9:	e8 3e fe ff ff       	call   102b0c <printfmt>
            }
            break;
  102cce:	e9 45 02 00 00       	jmp    102f18 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102cd3:	8b 45 14             	mov    0x14(%ebp),%eax
  102cd6:	8d 50 04             	lea    0x4(%eax),%edx
  102cd9:	89 55 14             	mov    %edx,0x14(%ebp)
  102cdc:	8b 30                	mov    (%eax),%esi
  102cde:	85 f6                	test   %esi,%esi
  102ce0:	75 05                	jne    102ce7 <vprintfmt+0x1ad>
                p = "(null)";
  102ce2:	be 8d 3c 10 00       	mov    $0x103c8d,%esi
            }
            if (width > 0 && padc != '-') {
  102ce7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ceb:	7e 3e                	jle    102d2b <vprintfmt+0x1f1>
  102ced:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102cf1:	74 38                	je     102d2b <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102cf3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102cf6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cfd:	89 34 24             	mov    %esi,(%esp)
  102d00:	e8 15 03 00 00       	call   10301a <strnlen>
  102d05:	29 c3                	sub    %eax,%ebx
  102d07:	89 d8                	mov    %ebx,%eax
  102d09:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d0c:	eb 17                	jmp    102d25 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102d0e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102d12:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d15:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d19:	89 04 24             	mov    %eax,(%esp)
  102d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d1f:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102d21:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d25:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d29:	7f e3                	jg     102d0e <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d2b:	eb 38                	jmp    102d65 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102d2d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102d31:	74 1f                	je     102d52 <vprintfmt+0x218>
  102d33:	83 fb 1f             	cmp    $0x1f,%ebx
  102d36:	7e 05                	jle    102d3d <vprintfmt+0x203>
  102d38:	83 fb 7e             	cmp    $0x7e,%ebx
  102d3b:	7e 15                	jle    102d52 <vprintfmt+0x218>
                    putch('?', putdat);
  102d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d40:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d44:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d4e:	ff d0                	call   *%eax
  102d50:	eb 0f                	jmp    102d61 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d55:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d59:	89 1c 24             	mov    %ebx,(%esp)
  102d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5f:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d61:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d65:	89 f0                	mov    %esi,%eax
  102d67:	8d 70 01             	lea    0x1(%eax),%esi
  102d6a:	0f b6 00             	movzbl (%eax),%eax
  102d6d:	0f be d8             	movsbl %al,%ebx
  102d70:	85 db                	test   %ebx,%ebx
  102d72:	74 10                	je     102d84 <vprintfmt+0x24a>
  102d74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d78:	78 b3                	js     102d2d <vprintfmt+0x1f3>
  102d7a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102d7e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d82:	79 a9                	jns    102d2d <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d84:	eb 17                	jmp    102d9d <vprintfmt+0x263>
                putch(' ', putdat);
  102d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d89:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d8d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102d94:	8b 45 08             	mov    0x8(%ebp),%eax
  102d97:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d99:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d9d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102da1:	7f e3                	jg     102d86 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102da3:	e9 70 01 00 00       	jmp    102f18 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102dab:	89 44 24 04          	mov    %eax,0x4(%esp)
  102daf:	8d 45 14             	lea    0x14(%ebp),%eax
  102db2:	89 04 24             	mov    %eax,(%esp)
  102db5:	e8 0b fd ff ff       	call   102ac5 <getint>
  102dba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dbd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102dc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102dc6:	85 d2                	test   %edx,%edx
  102dc8:	79 26                	jns    102df0 <vprintfmt+0x2b6>
                putch('-', putdat);
  102dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dd1:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  102ddb:	ff d0                	call   *%eax
                num = -(long long)num;
  102ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102de0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102de3:	f7 d8                	neg    %eax
  102de5:	83 d2 00             	adc    $0x0,%edx
  102de8:	f7 da                	neg    %edx
  102dea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ded:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102df0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102df7:	e9 a8 00 00 00       	jmp    102ea4 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102dfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102dff:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e03:	8d 45 14             	lea    0x14(%ebp),%eax
  102e06:	89 04 24             	mov    %eax,(%esp)
  102e09:	e8 68 fc ff ff       	call   102a76 <getuint>
  102e0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e11:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102e14:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102e1b:	e9 84 00 00 00       	jmp    102ea4 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102e20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e23:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e27:	8d 45 14             	lea    0x14(%ebp),%eax
  102e2a:	89 04 24             	mov    %eax,(%esp)
  102e2d:	e8 44 fc ff ff       	call   102a76 <getuint>
  102e32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e35:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102e38:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102e3f:	eb 63                	jmp    102ea4 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e44:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e48:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e52:	ff d0                	call   *%eax
            putch('x', putdat);
  102e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e57:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e5b:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102e62:	8b 45 08             	mov    0x8(%ebp),%eax
  102e65:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102e67:	8b 45 14             	mov    0x14(%ebp),%eax
  102e6a:	8d 50 04             	lea    0x4(%eax),%edx
  102e6d:	89 55 14             	mov    %edx,0x14(%ebp)
  102e70:	8b 00                	mov    (%eax),%eax
  102e72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102e7c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102e83:	eb 1f                	jmp    102ea4 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102e85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e88:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e8c:	8d 45 14             	lea    0x14(%ebp),%eax
  102e8f:	89 04 24             	mov    %eax,(%esp)
  102e92:	e8 df fb ff ff       	call   102a76 <getuint>
  102e97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102e9d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102ea4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102eab:	89 54 24 18          	mov    %edx,0x18(%esp)
  102eaf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102eb2:	89 54 24 14          	mov    %edx,0x14(%esp)
  102eb6:	89 44 24 10          	mov    %eax,0x10(%esp)
  102eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ebd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ec0:	89 44 24 08          	mov    %eax,0x8(%esp)
  102ec4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ecb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed2:	89 04 24             	mov    %eax,(%esp)
  102ed5:	e8 97 fa ff ff       	call   102971 <printnum>
            break;
  102eda:	eb 3c                	jmp    102f18 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102edc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102edf:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ee3:	89 1c 24             	mov    %ebx,(%esp)
  102ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee9:	ff d0                	call   *%eax
            break;
  102eeb:	eb 2b                	jmp    102f18 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ef0:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ef4:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102efb:	8b 45 08             	mov    0x8(%ebp),%eax
  102efe:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102f00:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102f04:	eb 04                	jmp    102f0a <vprintfmt+0x3d0>
  102f06:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102f0a:	8b 45 10             	mov    0x10(%ebp),%eax
  102f0d:	83 e8 01             	sub    $0x1,%eax
  102f10:	0f b6 00             	movzbl (%eax),%eax
  102f13:	3c 25                	cmp    $0x25,%al
  102f15:	75 ef                	jne    102f06 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  102f17:	90                   	nop
        }
    }
  102f18:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102f19:	e9 3e fc ff ff       	jmp    102b5c <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  102f1e:	83 c4 40             	add    $0x40,%esp
  102f21:	5b                   	pop    %ebx
  102f22:	5e                   	pop    %esi
  102f23:	5d                   	pop    %ebp
  102f24:	c3                   	ret    

00102f25 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102f25:	55                   	push   %ebp
  102f26:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102f28:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f2b:	8b 40 08             	mov    0x8(%eax),%eax
  102f2e:	8d 50 01             	lea    0x1(%eax),%edx
  102f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f34:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f3a:	8b 10                	mov    (%eax),%edx
  102f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f3f:	8b 40 04             	mov    0x4(%eax),%eax
  102f42:	39 c2                	cmp    %eax,%edx
  102f44:	73 12                	jae    102f58 <sprintputch+0x33>
        *b->buf ++ = ch;
  102f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f49:	8b 00                	mov    (%eax),%eax
  102f4b:	8d 48 01             	lea    0x1(%eax),%ecx
  102f4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f51:	89 0a                	mov    %ecx,(%edx)
  102f53:	8b 55 08             	mov    0x8(%ebp),%edx
  102f56:	88 10                	mov    %dl,(%eax)
    }
}
  102f58:	5d                   	pop    %ebp
  102f59:	c3                   	ret    

00102f5a <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102f5a:	55                   	push   %ebp
  102f5b:	89 e5                	mov    %esp,%ebp
  102f5d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102f60:	8d 45 14             	lea    0x14(%ebp),%eax
  102f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f69:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f6d:	8b 45 10             	mov    0x10(%ebp),%eax
  102f70:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f77:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f7e:	89 04 24             	mov    %eax,(%esp)
  102f81:	e8 08 00 00 00       	call   102f8e <vsnprintf>
  102f86:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f8c:	c9                   	leave  
  102f8d:	c3                   	ret    

00102f8e <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102f8e:	55                   	push   %ebp
  102f8f:	89 e5                	mov    %esp,%ebp
  102f91:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102f94:	8b 45 08             	mov    0x8(%ebp),%eax
  102f97:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  102fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa3:	01 d0                	add    %edx,%eax
  102fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fa8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102faf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102fb3:	74 0a                	je     102fbf <vsnprintf+0x31>
  102fb5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fbb:	39 c2                	cmp    %eax,%edx
  102fbd:	76 07                	jbe    102fc6 <vsnprintf+0x38>
        return -E_INVAL;
  102fbf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102fc4:	eb 2a                	jmp    102ff0 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102fc6:	8b 45 14             	mov    0x14(%ebp),%eax
  102fc9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102fcd:	8b 45 10             	mov    0x10(%ebp),%eax
  102fd0:	89 44 24 08          	mov    %eax,0x8(%esp)
  102fd4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102fd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fdb:	c7 04 24 25 2f 10 00 	movl   $0x102f25,(%esp)
  102fe2:	e8 53 fb ff ff       	call   102b3a <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  102fe7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fea:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102ff0:	c9                   	leave  
  102ff1:	c3                   	ret    

00102ff2 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102ff2:	55                   	push   %ebp
  102ff3:	89 e5                	mov    %esp,%ebp
  102ff5:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102ff8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102fff:	eb 04                	jmp    103005 <strlen+0x13>
        cnt ++;
  103001:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  103005:	8b 45 08             	mov    0x8(%ebp),%eax
  103008:	8d 50 01             	lea    0x1(%eax),%edx
  10300b:	89 55 08             	mov    %edx,0x8(%ebp)
  10300e:	0f b6 00             	movzbl (%eax),%eax
  103011:	84 c0                	test   %al,%al
  103013:	75 ec                	jne    103001 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  103015:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103018:	c9                   	leave  
  103019:	c3                   	ret    

0010301a <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10301a:	55                   	push   %ebp
  10301b:	89 e5                	mov    %esp,%ebp
  10301d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  103020:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103027:	eb 04                	jmp    10302d <strnlen+0x13>
        cnt ++;
  103029:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  10302d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103030:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103033:	73 10                	jae    103045 <strnlen+0x2b>
  103035:	8b 45 08             	mov    0x8(%ebp),%eax
  103038:	8d 50 01             	lea    0x1(%eax),%edx
  10303b:	89 55 08             	mov    %edx,0x8(%ebp)
  10303e:	0f b6 00             	movzbl (%eax),%eax
  103041:	84 c0                	test   %al,%al
  103043:	75 e4                	jne    103029 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  103045:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103048:	c9                   	leave  
  103049:	c3                   	ret    

0010304a <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10304a:	55                   	push   %ebp
  10304b:	89 e5                	mov    %esp,%ebp
  10304d:	57                   	push   %edi
  10304e:	56                   	push   %esi
  10304f:	83 ec 20             	sub    $0x20,%esp
  103052:	8b 45 08             	mov    0x8(%ebp),%eax
  103055:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103058:	8b 45 0c             	mov    0xc(%ebp),%eax
  10305b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10305e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103061:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103064:	89 d1                	mov    %edx,%ecx
  103066:	89 c2                	mov    %eax,%edx
  103068:	89 ce                	mov    %ecx,%esi
  10306a:	89 d7                	mov    %edx,%edi
  10306c:	ac                   	lods   %ds:(%esi),%al
  10306d:	aa                   	stos   %al,%es:(%edi)
  10306e:	84 c0                	test   %al,%al
  103070:	75 fa                	jne    10306c <strcpy+0x22>
  103072:	89 fa                	mov    %edi,%edx
  103074:	89 f1                	mov    %esi,%ecx
  103076:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103079:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10307c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  10307f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  103082:	83 c4 20             	add    $0x20,%esp
  103085:	5e                   	pop    %esi
  103086:	5f                   	pop    %edi
  103087:	5d                   	pop    %ebp
  103088:	c3                   	ret    

00103089 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103089:	55                   	push   %ebp
  10308a:	89 e5                	mov    %esp,%ebp
  10308c:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10308f:	8b 45 08             	mov    0x8(%ebp),%eax
  103092:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  103095:	eb 21                	jmp    1030b8 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  103097:	8b 45 0c             	mov    0xc(%ebp),%eax
  10309a:	0f b6 10             	movzbl (%eax),%edx
  10309d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030a0:	88 10                	mov    %dl,(%eax)
  1030a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030a5:	0f b6 00             	movzbl (%eax),%eax
  1030a8:	84 c0                	test   %al,%al
  1030aa:	74 04                	je     1030b0 <strncpy+0x27>
            src ++;
  1030ac:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  1030b0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1030b4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  1030b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030bc:	75 d9                	jne    103097 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  1030be:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1030c1:	c9                   	leave  
  1030c2:	c3                   	ret    

001030c3 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1030c3:	55                   	push   %ebp
  1030c4:	89 e5                	mov    %esp,%ebp
  1030c6:	57                   	push   %edi
  1030c7:	56                   	push   %esi
  1030c8:	83 ec 20             	sub    $0x20,%esp
  1030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1030d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030dd:	89 d1                	mov    %edx,%ecx
  1030df:	89 c2                	mov    %eax,%edx
  1030e1:	89 ce                	mov    %ecx,%esi
  1030e3:	89 d7                	mov    %edx,%edi
  1030e5:	ac                   	lods   %ds:(%esi),%al
  1030e6:	ae                   	scas   %es:(%edi),%al
  1030e7:	75 08                	jne    1030f1 <strcmp+0x2e>
  1030e9:	84 c0                	test   %al,%al
  1030eb:	75 f8                	jne    1030e5 <strcmp+0x22>
  1030ed:	31 c0                	xor    %eax,%eax
  1030ef:	eb 04                	jmp    1030f5 <strcmp+0x32>
  1030f1:	19 c0                	sbb    %eax,%eax
  1030f3:	0c 01                	or     $0x1,%al
  1030f5:	89 fa                	mov    %edi,%edx
  1030f7:	89 f1                	mov    %esi,%ecx
  1030f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030fc:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1030ff:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  103102:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  103105:	83 c4 20             	add    $0x20,%esp
  103108:	5e                   	pop    %esi
  103109:	5f                   	pop    %edi
  10310a:	5d                   	pop    %ebp
  10310b:	c3                   	ret    

0010310c <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  10310c:	55                   	push   %ebp
  10310d:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10310f:	eb 0c                	jmp    10311d <strncmp+0x11>
        n --, s1 ++, s2 ++;
  103111:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103115:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103119:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10311d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103121:	74 1a                	je     10313d <strncmp+0x31>
  103123:	8b 45 08             	mov    0x8(%ebp),%eax
  103126:	0f b6 00             	movzbl (%eax),%eax
  103129:	84 c0                	test   %al,%al
  10312b:	74 10                	je     10313d <strncmp+0x31>
  10312d:	8b 45 08             	mov    0x8(%ebp),%eax
  103130:	0f b6 10             	movzbl (%eax),%edx
  103133:	8b 45 0c             	mov    0xc(%ebp),%eax
  103136:	0f b6 00             	movzbl (%eax),%eax
  103139:	38 c2                	cmp    %al,%dl
  10313b:	74 d4                	je     103111 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  10313d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103141:	74 18                	je     10315b <strncmp+0x4f>
  103143:	8b 45 08             	mov    0x8(%ebp),%eax
  103146:	0f b6 00             	movzbl (%eax),%eax
  103149:	0f b6 d0             	movzbl %al,%edx
  10314c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10314f:	0f b6 00             	movzbl (%eax),%eax
  103152:	0f b6 c0             	movzbl %al,%eax
  103155:	29 c2                	sub    %eax,%edx
  103157:	89 d0                	mov    %edx,%eax
  103159:	eb 05                	jmp    103160 <strncmp+0x54>
  10315b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103160:	5d                   	pop    %ebp
  103161:	c3                   	ret    

00103162 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103162:	55                   	push   %ebp
  103163:	89 e5                	mov    %esp,%ebp
  103165:	83 ec 04             	sub    $0x4,%esp
  103168:	8b 45 0c             	mov    0xc(%ebp),%eax
  10316b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10316e:	eb 14                	jmp    103184 <strchr+0x22>
        if (*s == c) {
  103170:	8b 45 08             	mov    0x8(%ebp),%eax
  103173:	0f b6 00             	movzbl (%eax),%eax
  103176:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103179:	75 05                	jne    103180 <strchr+0x1e>
            return (char *)s;
  10317b:	8b 45 08             	mov    0x8(%ebp),%eax
  10317e:	eb 13                	jmp    103193 <strchr+0x31>
        }
        s ++;
  103180:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  103184:	8b 45 08             	mov    0x8(%ebp),%eax
  103187:	0f b6 00             	movzbl (%eax),%eax
  10318a:	84 c0                	test   %al,%al
  10318c:	75 e2                	jne    103170 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  10318e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103193:	c9                   	leave  
  103194:	c3                   	ret    

00103195 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  103195:	55                   	push   %ebp
  103196:	89 e5                	mov    %esp,%ebp
  103198:	83 ec 04             	sub    $0x4,%esp
  10319b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10319e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1031a1:	eb 11                	jmp    1031b4 <strfind+0x1f>
        if (*s == c) {
  1031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a6:	0f b6 00             	movzbl (%eax),%eax
  1031a9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1031ac:	75 02                	jne    1031b0 <strfind+0x1b>
            break;
  1031ae:	eb 0e                	jmp    1031be <strfind+0x29>
        }
        s ++;
  1031b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  1031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b7:	0f b6 00             	movzbl (%eax),%eax
  1031ba:	84 c0                	test   %al,%al
  1031bc:	75 e5                	jne    1031a3 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  1031be:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1031c1:	c9                   	leave  
  1031c2:	c3                   	ret    

001031c3 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1031c3:	55                   	push   %ebp
  1031c4:	89 e5                	mov    %esp,%ebp
  1031c6:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1031c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1031d0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1031d7:	eb 04                	jmp    1031dd <strtol+0x1a>
        s ++;
  1031d9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1031dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e0:	0f b6 00             	movzbl (%eax),%eax
  1031e3:	3c 20                	cmp    $0x20,%al
  1031e5:	74 f2                	je     1031d9 <strtol+0x16>
  1031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ea:	0f b6 00             	movzbl (%eax),%eax
  1031ed:	3c 09                	cmp    $0x9,%al
  1031ef:	74 e8                	je     1031d9 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1031f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1031f4:	0f b6 00             	movzbl (%eax),%eax
  1031f7:	3c 2b                	cmp    $0x2b,%al
  1031f9:	75 06                	jne    103201 <strtol+0x3e>
        s ++;
  1031fb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031ff:	eb 15                	jmp    103216 <strtol+0x53>
    }
    else if (*s == '-') {
  103201:	8b 45 08             	mov    0x8(%ebp),%eax
  103204:	0f b6 00             	movzbl (%eax),%eax
  103207:	3c 2d                	cmp    $0x2d,%al
  103209:	75 0b                	jne    103216 <strtol+0x53>
        s ++, neg = 1;
  10320b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10320f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103216:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10321a:	74 06                	je     103222 <strtol+0x5f>
  10321c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  103220:	75 24                	jne    103246 <strtol+0x83>
  103222:	8b 45 08             	mov    0x8(%ebp),%eax
  103225:	0f b6 00             	movzbl (%eax),%eax
  103228:	3c 30                	cmp    $0x30,%al
  10322a:	75 1a                	jne    103246 <strtol+0x83>
  10322c:	8b 45 08             	mov    0x8(%ebp),%eax
  10322f:	83 c0 01             	add    $0x1,%eax
  103232:	0f b6 00             	movzbl (%eax),%eax
  103235:	3c 78                	cmp    $0x78,%al
  103237:	75 0d                	jne    103246 <strtol+0x83>
        s += 2, base = 16;
  103239:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  10323d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  103244:	eb 2a                	jmp    103270 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  103246:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10324a:	75 17                	jne    103263 <strtol+0xa0>
  10324c:	8b 45 08             	mov    0x8(%ebp),%eax
  10324f:	0f b6 00             	movzbl (%eax),%eax
  103252:	3c 30                	cmp    $0x30,%al
  103254:	75 0d                	jne    103263 <strtol+0xa0>
        s ++, base = 8;
  103256:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10325a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103261:	eb 0d                	jmp    103270 <strtol+0xad>
    }
    else if (base == 0) {
  103263:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103267:	75 07                	jne    103270 <strtol+0xad>
        base = 10;
  103269:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103270:	8b 45 08             	mov    0x8(%ebp),%eax
  103273:	0f b6 00             	movzbl (%eax),%eax
  103276:	3c 2f                	cmp    $0x2f,%al
  103278:	7e 1b                	jle    103295 <strtol+0xd2>
  10327a:	8b 45 08             	mov    0x8(%ebp),%eax
  10327d:	0f b6 00             	movzbl (%eax),%eax
  103280:	3c 39                	cmp    $0x39,%al
  103282:	7f 11                	jg     103295 <strtol+0xd2>
            dig = *s - '0';
  103284:	8b 45 08             	mov    0x8(%ebp),%eax
  103287:	0f b6 00             	movzbl (%eax),%eax
  10328a:	0f be c0             	movsbl %al,%eax
  10328d:	83 e8 30             	sub    $0x30,%eax
  103290:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103293:	eb 48                	jmp    1032dd <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  103295:	8b 45 08             	mov    0x8(%ebp),%eax
  103298:	0f b6 00             	movzbl (%eax),%eax
  10329b:	3c 60                	cmp    $0x60,%al
  10329d:	7e 1b                	jle    1032ba <strtol+0xf7>
  10329f:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a2:	0f b6 00             	movzbl (%eax),%eax
  1032a5:	3c 7a                	cmp    $0x7a,%al
  1032a7:	7f 11                	jg     1032ba <strtol+0xf7>
            dig = *s - 'a' + 10;
  1032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ac:	0f b6 00             	movzbl (%eax),%eax
  1032af:	0f be c0             	movsbl %al,%eax
  1032b2:	83 e8 57             	sub    $0x57,%eax
  1032b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1032b8:	eb 23                	jmp    1032dd <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1032ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1032bd:	0f b6 00             	movzbl (%eax),%eax
  1032c0:	3c 40                	cmp    $0x40,%al
  1032c2:	7e 3d                	jle    103301 <strtol+0x13e>
  1032c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c7:	0f b6 00             	movzbl (%eax),%eax
  1032ca:	3c 5a                	cmp    $0x5a,%al
  1032cc:	7f 33                	jg     103301 <strtol+0x13e>
            dig = *s - 'A' + 10;
  1032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d1:	0f b6 00             	movzbl (%eax),%eax
  1032d4:	0f be c0             	movsbl %al,%eax
  1032d7:	83 e8 37             	sub    $0x37,%eax
  1032da:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1032dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032e0:	3b 45 10             	cmp    0x10(%ebp),%eax
  1032e3:	7c 02                	jl     1032e7 <strtol+0x124>
            break;
  1032e5:	eb 1a                	jmp    103301 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  1032e7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032ee:	0f af 45 10          	imul   0x10(%ebp),%eax
  1032f2:	89 c2                	mov    %eax,%edx
  1032f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032f7:	01 d0                	add    %edx,%eax
  1032f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1032fc:	e9 6f ff ff ff       	jmp    103270 <strtol+0xad>

    if (endptr) {
  103301:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103305:	74 08                	je     10330f <strtol+0x14c>
        *endptr = (char *) s;
  103307:	8b 45 0c             	mov    0xc(%ebp),%eax
  10330a:	8b 55 08             	mov    0x8(%ebp),%edx
  10330d:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  10330f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  103313:	74 07                	je     10331c <strtol+0x159>
  103315:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103318:	f7 d8                	neg    %eax
  10331a:	eb 03                	jmp    10331f <strtol+0x15c>
  10331c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10331f:	c9                   	leave  
  103320:	c3                   	ret    

00103321 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  103321:	55                   	push   %ebp
  103322:	89 e5                	mov    %esp,%ebp
  103324:	57                   	push   %edi
  103325:	83 ec 24             	sub    $0x24,%esp
  103328:	8b 45 0c             	mov    0xc(%ebp),%eax
  10332b:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10332e:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  103332:	8b 55 08             	mov    0x8(%ebp),%edx
  103335:	89 55 f8             	mov    %edx,-0x8(%ebp)
  103338:	88 45 f7             	mov    %al,-0x9(%ebp)
  10333b:	8b 45 10             	mov    0x10(%ebp),%eax
  10333e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103341:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  103344:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103348:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10334b:	89 d7                	mov    %edx,%edi
  10334d:	f3 aa                	rep stos %al,%es:(%edi)
  10334f:	89 fa                	mov    %edi,%edx
  103351:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103354:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103357:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10335a:	83 c4 24             	add    $0x24,%esp
  10335d:	5f                   	pop    %edi
  10335e:	5d                   	pop    %ebp
  10335f:	c3                   	ret    

00103360 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103360:	55                   	push   %ebp
  103361:	89 e5                	mov    %esp,%ebp
  103363:	57                   	push   %edi
  103364:	56                   	push   %esi
  103365:	53                   	push   %ebx
  103366:	83 ec 30             	sub    $0x30,%esp
  103369:	8b 45 08             	mov    0x8(%ebp),%eax
  10336c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10336f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103372:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103375:	8b 45 10             	mov    0x10(%ebp),%eax
  103378:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10337b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10337e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103381:	73 42                	jae    1033c5 <memmove+0x65>
  103383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103386:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103389:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10338c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10338f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103392:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103395:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103398:	c1 e8 02             	shr    $0x2,%eax
  10339b:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10339d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1033a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033a3:	89 d7                	mov    %edx,%edi
  1033a5:	89 c6                	mov    %eax,%esi
  1033a7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1033a9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1033ac:	83 e1 03             	and    $0x3,%ecx
  1033af:	74 02                	je     1033b3 <memmove+0x53>
  1033b1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033b3:	89 f0                	mov    %esi,%eax
  1033b5:	89 fa                	mov    %edi,%edx
  1033b7:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1033ba:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1033bd:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  1033c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033c3:	eb 36                	jmp    1033fb <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1033c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1033cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033ce:	01 c2                	add    %eax,%edx
  1033d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033d3:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1033d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033d9:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1033dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033df:	89 c1                	mov    %eax,%ecx
  1033e1:	89 d8                	mov    %ebx,%eax
  1033e3:	89 d6                	mov    %edx,%esi
  1033e5:	89 c7                	mov    %eax,%edi
  1033e7:	fd                   	std    
  1033e8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033ea:	fc                   	cld    
  1033eb:	89 f8                	mov    %edi,%eax
  1033ed:	89 f2                	mov    %esi,%edx
  1033ef:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1033f2:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1033f5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  1033f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1033fb:	83 c4 30             	add    $0x30,%esp
  1033fe:	5b                   	pop    %ebx
  1033ff:	5e                   	pop    %esi
  103400:	5f                   	pop    %edi
  103401:	5d                   	pop    %ebp
  103402:	c3                   	ret    

00103403 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  103403:	55                   	push   %ebp
  103404:	89 e5                	mov    %esp,%ebp
  103406:	57                   	push   %edi
  103407:	56                   	push   %esi
  103408:	83 ec 20             	sub    $0x20,%esp
  10340b:	8b 45 08             	mov    0x8(%ebp),%eax
  10340e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103411:	8b 45 0c             	mov    0xc(%ebp),%eax
  103414:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103417:	8b 45 10             	mov    0x10(%ebp),%eax
  10341a:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10341d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103420:	c1 e8 02             	shr    $0x2,%eax
  103423:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103425:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103428:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10342b:	89 d7                	mov    %edx,%edi
  10342d:	89 c6                	mov    %eax,%esi
  10342f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103431:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103434:	83 e1 03             	and    $0x3,%ecx
  103437:	74 02                	je     10343b <memcpy+0x38>
  103439:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10343b:	89 f0                	mov    %esi,%eax
  10343d:	89 fa                	mov    %edi,%edx
  10343f:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103442:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103445:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103448:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10344b:	83 c4 20             	add    $0x20,%esp
  10344e:	5e                   	pop    %esi
  10344f:	5f                   	pop    %edi
  103450:	5d                   	pop    %ebp
  103451:	c3                   	ret    

00103452 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103452:	55                   	push   %ebp
  103453:	89 e5                	mov    %esp,%ebp
  103455:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103458:	8b 45 08             	mov    0x8(%ebp),%eax
  10345b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10345e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103461:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103464:	eb 30                	jmp    103496 <memcmp+0x44>
        if (*s1 != *s2) {
  103466:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103469:	0f b6 10             	movzbl (%eax),%edx
  10346c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10346f:	0f b6 00             	movzbl (%eax),%eax
  103472:	38 c2                	cmp    %al,%dl
  103474:	74 18                	je     10348e <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103476:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103479:	0f b6 00             	movzbl (%eax),%eax
  10347c:	0f b6 d0             	movzbl %al,%edx
  10347f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103482:	0f b6 00             	movzbl (%eax),%eax
  103485:	0f b6 c0             	movzbl %al,%eax
  103488:	29 c2                	sub    %eax,%edx
  10348a:	89 d0                	mov    %edx,%eax
  10348c:	eb 1a                	jmp    1034a8 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  10348e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103492:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  103496:	8b 45 10             	mov    0x10(%ebp),%eax
  103499:	8d 50 ff             	lea    -0x1(%eax),%edx
  10349c:	89 55 10             	mov    %edx,0x10(%ebp)
  10349f:	85 c0                	test   %eax,%eax
  1034a1:	75 c3                	jne    103466 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1034a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1034a8:	c9                   	leave  
  1034a9:	c3                   	ret    
