
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
  100027:	e8 21 31 00 00       	call   10314d <memset>

    cons_init();                // init the console
  10002c:	e8 45 15 00 00       	call   101576 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 e0 32 10 00 	movl   $0x1032e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 fc 32 10 00 	movl   $0x1032fc,(%esp)
  100046:	e8 c7 02 00 00       	call   100312 <cprintf>

    print_kerninfo();
  10004b:	e8 f6 07 00 00       	call   100846 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 39 27 00 00       	call   102793 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 5a 16 00 00       	call   1016b9 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 ac 17 00 00       	call   101810 <idt_init>

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
  10012b:	c7 04 24 01 33 10 00 	movl   $0x103301,(%esp)
  100132:	e8 db 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 0f 33 10 00 	movl   $0x10330f,(%esp)
  100152:	e8 bb 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 1d 33 10 00 	movl   $0x10331d,(%esp)
  100172:	e8 9b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 2b 33 10 00 	movl   $0x10332b,(%esp)
  100192:	e8 7b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 39 33 10 00 	movl   $0x103339,(%esp)
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
  1001db:	c7 04 24 48 33 10 00 	movl   $0x103348,(%esp)
  1001e2:	e8 2b 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 68 33 10 00 	movl   $0x103368,(%esp)
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
  10021c:	c7 04 24 87 33 10 00 	movl   $0x103387,(%esp)
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
  100308:	e8 59 26 00 00       	call   102966 <vprintfmt>
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
  100512:	c7 00 8c 33 10 00    	movl   $0x10338c,(%eax)
    info->eip_line = 0;
  100518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100522:	8b 45 0c             	mov    0xc(%ebp),%eax
  100525:	c7 40 08 8c 33 10 00 	movl   $0x10338c,0x8(%eax)
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
  100549:	c7 45 f4 ec 3b 10 00 	movl   $0x103bec,-0xc(%ebp)
    stab_end = __STAB_END__;
  100550:	c7 45 f0 a8 b2 10 00 	movl   $0x10b2a8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100557:	c7 45 ec a9 b2 10 00 	movl   $0x10b2a9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055e:	c7 45 e8 94 d2 10 00 	movl   $0x10d294,-0x18(%ebp)

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
  1006bd:	e8 ff 28 00 00       	call   102fc1 <strfind>
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
  10084c:	c7 04 24 96 33 10 00 	movl   $0x103396,(%esp)
  100853:	e8 ba fa ff ff       	call   100312 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100858:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085f:	00 
  100860:	c7 04 24 af 33 10 00 	movl   $0x1033af,(%esp)
  100867:	e8 a6 fa ff ff       	call   100312 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10086c:	c7 44 24 04 d6 32 10 	movl   $0x1032d6,0x4(%esp)
  100873:	00 
  100874:	c7 04 24 c7 33 10 00 	movl   $0x1033c7,(%esp)
  10087b:	e8 92 fa ff ff       	call   100312 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100880:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100887:	00 
  100888:	c7 04 24 df 33 10 00 	movl   $0x1033df,(%esp)
  10088f:	e8 7e fa ff ff       	call   100312 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100894:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  10089b:	00 
  10089c:	c7 04 24 f7 33 10 00 	movl   $0x1033f7,(%esp)
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
  1008ce:	c7 04 24 10 34 10 00 	movl   $0x103410,(%esp)
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
  100902:	c7 04 24 3a 34 10 00 	movl   $0x10343a,(%esp)
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
  100971:	c7 04 24 56 34 10 00 	movl   $0x103456,(%esp)
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
  1009c3:	c7 04 24 68 34 10 00 	movl   $0x103468,(%esp)
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
  1009f6:	c7 04 24 84 34 10 00 	movl   $0x103484,(%esp)
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
  100a0c:	c7 04 24 8c 34 10 00 	movl   $0x10348c,(%esp)
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
  100a81:	c7 04 24 10 35 10 00 	movl   $0x103510,(%esp)
  100a88:	e8 01 25 00 00       	call   102f8e <strchr>
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
  100aab:	c7 04 24 15 35 10 00 	movl   $0x103515,(%esp)
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
  100aee:	c7 04 24 10 35 10 00 	movl   $0x103510,(%esp)
  100af5:	e8 94 24 00 00       	call   102f8e <strchr>
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
  100b5a:	e8 90 23 00 00       	call   102eef <strcmp>
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
  100ba8:	c7 04 24 33 35 10 00 	movl   $0x103533,(%esp)
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
  100bc1:	c7 04 24 4c 35 10 00 	movl   $0x10354c,(%esp)
  100bc8:	e8 45 f7 ff ff       	call   100312 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bcd:	c7 04 24 74 35 10 00 	movl   $0x103574,(%esp)
  100bd4:	e8 39 f7 ff ff       	call   100312 <cprintf>

    if (tf != NULL) {
  100bd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bdd:	74 0b                	je     100bea <kmonitor+0x2f>
        print_trapframe(tf);
  100bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  100be2:	89 04 24             	mov    %eax,(%esp)
  100be5:	e8 72 0c 00 00       	call   10185c <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bea:	c7 04 24 99 35 10 00 	movl   $0x103599,(%esp)
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
  100c59:	c7 04 24 9d 35 10 00 	movl   $0x10359d,(%esp)
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
  100ccb:	c7 04 24 a6 35 10 00 	movl   $0x1035a6,(%esp)
  100cd2:	e8 3b f6 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cda:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cde:	8b 45 10             	mov    0x10(%ebp),%eax
  100ce1:	89 04 24             	mov    %eax,(%esp)
  100ce4:	e8 f6 f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100ce9:	c7 04 24 c2 35 10 00 	movl   $0x1035c2,(%esp)
  100cf0:	e8 1d f6 ff ff       	call   100312 <cprintf>
    
    cprintf("stack trackback:\n");
  100cf5:	c7 04 24 c4 35 10 00 	movl   $0x1035c4,(%esp)
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
  100d33:	c7 04 24 d6 35 10 00 	movl   $0x1035d6,(%esp)
  100d3a:	e8 d3 f5 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d42:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d46:	8b 45 10             	mov    0x10(%ebp),%eax
  100d49:	89 04 24             	mov    %eax,(%esp)
  100d4c:	e8 8e f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100d51:	c7 04 24 c2 35 10 00 	movl   $0x1035c2,(%esp)
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
  100db2:	c7 04 24 f4 35 10 00 	movl   $0x1035f4,(%esp)
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
  10119f:	e8 e8 1f 00 00       	call   10318c <memmove>
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
  101525:	c7 04 24 0f 36 10 00 	movl   $0x10360f,(%esp)
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
  101594:	c7 04 24 1b 36 10 00 	movl   $0x10361b,(%esp)
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
  101802:	c7 04 24 40 36 10 00 	movl   $0x103640,(%esp)
  101809:	e8 04 eb ff ff       	call   100312 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10180e:	c9                   	leave  
  10180f:	c3                   	ret    

00101810 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101810:	55                   	push   %ebp
  101811:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  101813:	5d                   	pop    %ebp
  101814:	c3                   	ret    

00101815 <trapname>:

static const char *
trapname(int trapno) {
  101815:	55                   	push   %ebp
  101816:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101818:	8b 45 08             	mov    0x8(%ebp),%eax
  10181b:	83 f8 13             	cmp    $0x13,%eax
  10181e:	77 0c                	ja     10182c <trapname+0x17>
        return excnames[trapno];
  101820:	8b 45 08             	mov    0x8(%ebp),%eax
  101823:	8b 04 85 a0 39 10 00 	mov    0x1039a0(,%eax,4),%eax
  10182a:	eb 18                	jmp    101844 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  10182c:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101830:	7e 0d                	jle    10183f <trapname+0x2a>
  101832:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101836:	7f 07                	jg     10183f <trapname+0x2a>
        return "Hardware Interrupt";
  101838:	b8 4a 36 10 00       	mov    $0x10364a,%eax
  10183d:	eb 05                	jmp    101844 <trapname+0x2f>
    }
    return "(unknown trap)";
  10183f:	b8 5d 36 10 00       	mov    $0x10365d,%eax
}
  101844:	5d                   	pop    %ebp
  101845:	c3                   	ret    

00101846 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101846:	55                   	push   %ebp
  101847:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101849:	8b 45 08             	mov    0x8(%ebp),%eax
  10184c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101850:	66 83 f8 08          	cmp    $0x8,%ax
  101854:	0f 94 c0             	sete   %al
  101857:	0f b6 c0             	movzbl %al,%eax
}
  10185a:	5d                   	pop    %ebp
  10185b:	c3                   	ret    

0010185c <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  10185c:	55                   	push   %ebp
  10185d:	89 e5                	mov    %esp,%ebp
  10185f:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101862:	8b 45 08             	mov    0x8(%ebp),%eax
  101865:	89 44 24 04          	mov    %eax,0x4(%esp)
  101869:	c7 04 24 9e 36 10 00 	movl   $0x10369e,(%esp)
  101870:	e8 9d ea ff ff       	call   100312 <cprintf>
    print_regs(&tf->tf_regs);
  101875:	8b 45 08             	mov    0x8(%ebp),%eax
  101878:	89 04 24             	mov    %eax,(%esp)
  10187b:	e8 a1 01 00 00       	call   101a21 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101880:	8b 45 08             	mov    0x8(%ebp),%eax
  101883:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101887:	0f b7 c0             	movzwl %ax,%eax
  10188a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10188e:	c7 04 24 af 36 10 00 	movl   $0x1036af,(%esp)
  101895:	e8 78 ea ff ff       	call   100312 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  10189a:	8b 45 08             	mov    0x8(%ebp),%eax
  10189d:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1018a1:	0f b7 c0             	movzwl %ax,%eax
  1018a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018a8:	c7 04 24 c2 36 10 00 	movl   $0x1036c2,(%esp)
  1018af:	e8 5e ea ff ff       	call   100312 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  1018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1018b7:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  1018bb:	0f b7 c0             	movzwl %ax,%eax
  1018be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018c2:	c7 04 24 d5 36 10 00 	movl   $0x1036d5,(%esp)
  1018c9:	e8 44 ea ff ff       	call   100312 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  1018ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1018d1:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  1018d5:	0f b7 c0             	movzwl %ax,%eax
  1018d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018dc:	c7 04 24 e8 36 10 00 	movl   $0x1036e8,(%esp)
  1018e3:	e8 2a ea ff ff       	call   100312 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  1018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1018eb:	8b 40 30             	mov    0x30(%eax),%eax
  1018ee:	89 04 24             	mov    %eax,(%esp)
  1018f1:	e8 1f ff ff ff       	call   101815 <trapname>
  1018f6:	8b 55 08             	mov    0x8(%ebp),%edx
  1018f9:	8b 52 30             	mov    0x30(%edx),%edx
  1018fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  101900:	89 54 24 04          	mov    %edx,0x4(%esp)
  101904:	c7 04 24 fb 36 10 00 	movl   $0x1036fb,(%esp)
  10190b:	e8 02 ea ff ff       	call   100312 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101910:	8b 45 08             	mov    0x8(%ebp),%eax
  101913:	8b 40 34             	mov    0x34(%eax),%eax
  101916:	89 44 24 04          	mov    %eax,0x4(%esp)
  10191a:	c7 04 24 0d 37 10 00 	movl   $0x10370d,(%esp)
  101921:	e8 ec e9 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101926:	8b 45 08             	mov    0x8(%ebp),%eax
  101929:	8b 40 38             	mov    0x38(%eax),%eax
  10192c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101930:	c7 04 24 1c 37 10 00 	movl   $0x10371c,(%esp)
  101937:	e8 d6 e9 ff ff       	call   100312 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  10193c:	8b 45 08             	mov    0x8(%ebp),%eax
  10193f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101943:	0f b7 c0             	movzwl %ax,%eax
  101946:	89 44 24 04          	mov    %eax,0x4(%esp)
  10194a:	c7 04 24 2b 37 10 00 	movl   $0x10372b,(%esp)
  101951:	e8 bc e9 ff ff       	call   100312 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101956:	8b 45 08             	mov    0x8(%ebp),%eax
  101959:	8b 40 40             	mov    0x40(%eax),%eax
  10195c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101960:	c7 04 24 3e 37 10 00 	movl   $0x10373e,(%esp)
  101967:	e8 a6 e9 ff ff       	call   100312 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  10196c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101973:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  10197a:	eb 3e                	jmp    1019ba <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  10197c:	8b 45 08             	mov    0x8(%ebp),%eax
  10197f:	8b 50 40             	mov    0x40(%eax),%edx
  101982:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101985:	21 d0                	and    %edx,%eax
  101987:	85 c0                	test   %eax,%eax
  101989:	74 28                	je     1019b3 <print_trapframe+0x157>
  10198b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10198e:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101995:	85 c0                	test   %eax,%eax
  101997:	74 1a                	je     1019b3 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10199c:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  1019a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019a7:	c7 04 24 4d 37 10 00 	movl   $0x10374d,(%esp)
  1019ae:	e8 5f e9 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  1019b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1019b7:	d1 65 f0             	shll   -0x10(%ebp)
  1019ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019bd:	83 f8 17             	cmp    $0x17,%eax
  1019c0:	76 ba                	jbe    10197c <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  1019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c5:	8b 40 40             	mov    0x40(%eax),%eax
  1019c8:	25 00 30 00 00       	and    $0x3000,%eax
  1019cd:	c1 e8 0c             	shr    $0xc,%eax
  1019d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019d4:	c7 04 24 51 37 10 00 	movl   $0x103751,(%esp)
  1019db:	e8 32 e9 ff ff       	call   100312 <cprintf>

    if (!trap_in_kernel(tf)) {
  1019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e3:	89 04 24             	mov    %eax,(%esp)
  1019e6:	e8 5b fe ff ff       	call   101846 <trap_in_kernel>
  1019eb:	85 c0                	test   %eax,%eax
  1019ed:	75 30                	jne    101a1f <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  1019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f2:	8b 40 44             	mov    0x44(%eax),%eax
  1019f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019f9:	c7 04 24 5a 37 10 00 	movl   $0x10375a,(%esp)
  101a00:	e8 0d e9 ff ff       	call   100312 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101a05:	8b 45 08             	mov    0x8(%ebp),%eax
  101a08:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101a0c:	0f b7 c0             	movzwl %ax,%eax
  101a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a13:	c7 04 24 69 37 10 00 	movl   $0x103769,(%esp)
  101a1a:	e8 f3 e8 ff ff       	call   100312 <cprintf>
    }
}
  101a1f:	c9                   	leave  
  101a20:	c3                   	ret    

00101a21 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101a21:	55                   	push   %ebp
  101a22:	89 e5                	mov    %esp,%ebp
  101a24:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101a27:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2a:	8b 00                	mov    (%eax),%eax
  101a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a30:	c7 04 24 7c 37 10 00 	movl   $0x10377c,(%esp)
  101a37:	e8 d6 e8 ff ff       	call   100312 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3f:	8b 40 04             	mov    0x4(%eax),%eax
  101a42:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a46:	c7 04 24 8b 37 10 00 	movl   $0x10378b,(%esp)
  101a4d:	e8 c0 e8 ff ff       	call   100312 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101a52:	8b 45 08             	mov    0x8(%ebp),%eax
  101a55:	8b 40 08             	mov    0x8(%eax),%eax
  101a58:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a5c:	c7 04 24 9a 37 10 00 	movl   $0x10379a,(%esp)
  101a63:	e8 aa e8 ff ff       	call   100312 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101a68:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6b:	8b 40 0c             	mov    0xc(%eax),%eax
  101a6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a72:	c7 04 24 a9 37 10 00 	movl   $0x1037a9,(%esp)
  101a79:	e8 94 e8 ff ff       	call   100312 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a81:	8b 40 10             	mov    0x10(%eax),%eax
  101a84:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a88:	c7 04 24 b8 37 10 00 	movl   $0x1037b8,(%esp)
  101a8f:	e8 7e e8 ff ff       	call   100312 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101a94:	8b 45 08             	mov    0x8(%ebp),%eax
  101a97:	8b 40 14             	mov    0x14(%eax),%eax
  101a9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a9e:	c7 04 24 c7 37 10 00 	movl   $0x1037c7,(%esp)
  101aa5:	e8 68 e8 ff ff       	call   100312 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  101aad:	8b 40 18             	mov    0x18(%eax),%eax
  101ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab4:	c7 04 24 d6 37 10 00 	movl   $0x1037d6,(%esp)
  101abb:	e8 52 e8 ff ff       	call   100312 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac3:	8b 40 1c             	mov    0x1c(%eax),%eax
  101ac6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aca:	c7 04 24 e5 37 10 00 	movl   $0x1037e5,(%esp)
  101ad1:	e8 3c e8 ff ff       	call   100312 <cprintf>
}
  101ad6:	c9                   	leave  
  101ad7:	c3                   	ret    

00101ad8 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101ad8:	55                   	push   %ebp
  101ad9:	89 e5                	mov    %esp,%ebp
  101adb:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101ade:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae1:	8b 40 30             	mov    0x30(%eax),%eax
  101ae4:	83 f8 2f             	cmp    $0x2f,%eax
  101ae7:	77 1e                	ja     101b07 <trap_dispatch+0x2f>
  101ae9:	83 f8 2e             	cmp    $0x2e,%eax
  101aec:	0f 83 bf 00 00 00    	jae    101bb1 <trap_dispatch+0xd9>
  101af2:	83 f8 21             	cmp    $0x21,%eax
  101af5:	74 40                	je     101b37 <trap_dispatch+0x5f>
  101af7:	83 f8 24             	cmp    $0x24,%eax
  101afa:	74 15                	je     101b11 <trap_dispatch+0x39>
  101afc:	83 f8 20             	cmp    $0x20,%eax
  101aff:	0f 84 af 00 00 00    	je     101bb4 <trap_dispatch+0xdc>
  101b05:	eb 72                	jmp    101b79 <trap_dispatch+0xa1>
  101b07:	83 e8 78             	sub    $0x78,%eax
  101b0a:	83 f8 01             	cmp    $0x1,%eax
  101b0d:	77 6a                	ja     101b79 <trap_dispatch+0xa1>
  101b0f:	eb 4c                	jmp    101b5d <trap_dispatch+0x85>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101b11:	e8 b5 fa ff ff       	call   1015cb <cons_getc>
  101b16:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101b19:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101b1d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101b21:	89 54 24 08          	mov    %edx,0x8(%esp)
  101b25:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b29:	c7 04 24 f4 37 10 00 	movl   $0x1037f4,(%esp)
  101b30:	e8 dd e7 ff ff       	call   100312 <cprintf>
        break;
  101b35:	eb 7e                	jmp    101bb5 <trap_dispatch+0xdd>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101b37:	e8 8f fa ff ff       	call   1015cb <cons_getc>
  101b3c:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101b3f:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101b43:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101b47:	89 54 24 08          	mov    %edx,0x8(%esp)
  101b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b4f:	c7 04 24 06 38 10 00 	movl   $0x103806,(%esp)
  101b56:	e8 b7 e7 ff ff       	call   100312 <cprintf>
        break;
  101b5b:	eb 58                	jmp    101bb5 <trap_dispatch+0xdd>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101b5d:	c7 44 24 08 15 38 10 	movl   $0x103815,0x8(%esp)
  101b64:	00 
  101b65:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  101b6c:	00 
  101b6d:	c7 04 24 25 38 10 00 	movl   $0x103825,(%esp)
  101b74:	e8 23 f1 ff ff       	call   100c9c <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101b79:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b80:	0f b7 c0             	movzwl %ax,%eax
  101b83:	83 e0 03             	and    $0x3,%eax
  101b86:	85 c0                	test   %eax,%eax
  101b88:	75 2b                	jne    101bb5 <trap_dispatch+0xdd>
            print_trapframe(tf);
  101b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8d:	89 04 24             	mov    %eax,(%esp)
  101b90:	e8 c7 fc ff ff       	call   10185c <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101b95:	c7 44 24 08 36 38 10 	movl   $0x103836,0x8(%esp)
  101b9c:	00 
  101b9d:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  101ba4:	00 
  101ba5:	c7 04 24 25 38 10 00 	movl   $0x103825,(%esp)
  101bac:	e8 eb f0 ff ff       	call   100c9c <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101bb1:	90                   	nop
  101bb2:	eb 01                	jmp    101bb5 <trap_dispatch+0xdd>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
  101bb4:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101bb5:	c9                   	leave  
  101bb6:	c3                   	ret    

00101bb7 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101bb7:	55                   	push   %ebp
  101bb8:	89 e5                	mov    %esp,%ebp
  101bba:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc0:	89 04 24             	mov    %eax,(%esp)
  101bc3:	e8 10 ff ff ff       	call   101ad8 <trap_dispatch>
}
  101bc8:	c9                   	leave  
  101bc9:	c3                   	ret    

00101bca <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101bca:	1e                   	push   %ds
    pushl %es
  101bcb:	06                   	push   %es
    pushl %fs
  101bcc:	0f a0                	push   %fs
    pushl %gs
  101bce:	0f a8                	push   %gs
    pushal
  101bd0:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101bd1:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101bd6:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101bd8:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101bda:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101bdb:	e8 d7 ff ff ff       	call   101bb7 <trap>

    # pop the pushed stack pointer
    popl %esp
  101be0:	5c                   	pop    %esp

00101be1 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101be1:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101be2:	0f a9                	pop    %gs
    popl %fs
  101be4:	0f a1                	pop    %fs
    popl %es
  101be6:	07                   	pop    %es
    popl %ds
  101be7:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101be8:	83 c4 08             	add    $0x8,%esp
    iret
  101beb:	cf                   	iret   

00101bec <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101bec:	6a 00                	push   $0x0
  pushl $0
  101bee:	6a 00                	push   $0x0
  jmp __alltraps
  101bf0:	e9 d5 ff ff ff       	jmp    101bca <__alltraps>

00101bf5 <vector1>:
.globl vector1
vector1:
  pushl $0
  101bf5:	6a 00                	push   $0x0
  pushl $1
  101bf7:	6a 01                	push   $0x1
  jmp __alltraps
  101bf9:	e9 cc ff ff ff       	jmp    101bca <__alltraps>

00101bfe <vector2>:
.globl vector2
vector2:
  pushl $0
  101bfe:	6a 00                	push   $0x0
  pushl $2
  101c00:	6a 02                	push   $0x2
  jmp __alltraps
  101c02:	e9 c3 ff ff ff       	jmp    101bca <__alltraps>

00101c07 <vector3>:
.globl vector3
vector3:
  pushl $0
  101c07:	6a 00                	push   $0x0
  pushl $3
  101c09:	6a 03                	push   $0x3
  jmp __alltraps
  101c0b:	e9 ba ff ff ff       	jmp    101bca <__alltraps>

00101c10 <vector4>:
.globl vector4
vector4:
  pushl $0
  101c10:	6a 00                	push   $0x0
  pushl $4
  101c12:	6a 04                	push   $0x4
  jmp __alltraps
  101c14:	e9 b1 ff ff ff       	jmp    101bca <__alltraps>

00101c19 <vector5>:
.globl vector5
vector5:
  pushl $0
  101c19:	6a 00                	push   $0x0
  pushl $5
  101c1b:	6a 05                	push   $0x5
  jmp __alltraps
  101c1d:	e9 a8 ff ff ff       	jmp    101bca <__alltraps>

00101c22 <vector6>:
.globl vector6
vector6:
  pushl $0
  101c22:	6a 00                	push   $0x0
  pushl $6
  101c24:	6a 06                	push   $0x6
  jmp __alltraps
  101c26:	e9 9f ff ff ff       	jmp    101bca <__alltraps>

00101c2b <vector7>:
.globl vector7
vector7:
  pushl $0
  101c2b:	6a 00                	push   $0x0
  pushl $7
  101c2d:	6a 07                	push   $0x7
  jmp __alltraps
  101c2f:	e9 96 ff ff ff       	jmp    101bca <__alltraps>

00101c34 <vector8>:
.globl vector8
vector8:
  pushl $8
  101c34:	6a 08                	push   $0x8
  jmp __alltraps
  101c36:	e9 8f ff ff ff       	jmp    101bca <__alltraps>

00101c3b <vector9>:
.globl vector9
vector9:
  pushl $0
  101c3b:	6a 00                	push   $0x0
  pushl $9
  101c3d:	6a 09                	push   $0x9
  jmp __alltraps
  101c3f:	e9 86 ff ff ff       	jmp    101bca <__alltraps>

00101c44 <vector10>:
.globl vector10
vector10:
  pushl $10
  101c44:	6a 0a                	push   $0xa
  jmp __alltraps
  101c46:	e9 7f ff ff ff       	jmp    101bca <__alltraps>

00101c4b <vector11>:
.globl vector11
vector11:
  pushl $11
  101c4b:	6a 0b                	push   $0xb
  jmp __alltraps
  101c4d:	e9 78 ff ff ff       	jmp    101bca <__alltraps>

00101c52 <vector12>:
.globl vector12
vector12:
  pushl $12
  101c52:	6a 0c                	push   $0xc
  jmp __alltraps
  101c54:	e9 71 ff ff ff       	jmp    101bca <__alltraps>

00101c59 <vector13>:
.globl vector13
vector13:
  pushl $13
  101c59:	6a 0d                	push   $0xd
  jmp __alltraps
  101c5b:	e9 6a ff ff ff       	jmp    101bca <__alltraps>

00101c60 <vector14>:
.globl vector14
vector14:
  pushl $14
  101c60:	6a 0e                	push   $0xe
  jmp __alltraps
  101c62:	e9 63 ff ff ff       	jmp    101bca <__alltraps>

00101c67 <vector15>:
.globl vector15
vector15:
  pushl $0
  101c67:	6a 00                	push   $0x0
  pushl $15
  101c69:	6a 0f                	push   $0xf
  jmp __alltraps
  101c6b:	e9 5a ff ff ff       	jmp    101bca <__alltraps>

00101c70 <vector16>:
.globl vector16
vector16:
  pushl $0
  101c70:	6a 00                	push   $0x0
  pushl $16
  101c72:	6a 10                	push   $0x10
  jmp __alltraps
  101c74:	e9 51 ff ff ff       	jmp    101bca <__alltraps>

00101c79 <vector17>:
.globl vector17
vector17:
  pushl $17
  101c79:	6a 11                	push   $0x11
  jmp __alltraps
  101c7b:	e9 4a ff ff ff       	jmp    101bca <__alltraps>

00101c80 <vector18>:
.globl vector18
vector18:
  pushl $0
  101c80:	6a 00                	push   $0x0
  pushl $18
  101c82:	6a 12                	push   $0x12
  jmp __alltraps
  101c84:	e9 41 ff ff ff       	jmp    101bca <__alltraps>

00101c89 <vector19>:
.globl vector19
vector19:
  pushl $0
  101c89:	6a 00                	push   $0x0
  pushl $19
  101c8b:	6a 13                	push   $0x13
  jmp __alltraps
  101c8d:	e9 38 ff ff ff       	jmp    101bca <__alltraps>

00101c92 <vector20>:
.globl vector20
vector20:
  pushl $0
  101c92:	6a 00                	push   $0x0
  pushl $20
  101c94:	6a 14                	push   $0x14
  jmp __alltraps
  101c96:	e9 2f ff ff ff       	jmp    101bca <__alltraps>

00101c9b <vector21>:
.globl vector21
vector21:
  pushl $0
  101c9b:	6a 00                	push   $0x0
  pushl $21
  101c9d:	6a 15                	push   $0x15
  jmp __alltraps
  101c9f:	e9 26 ff ff ff       	jmp    101bca <__alltraps>

00101ca4 <vector22>:
.globl vector22
vector22:
  pushl $0
  101ca4:	6a 00                	push   $0x0
  pushl $22
  101ca6:	6a 16                	push   $0x16
  jmp __alltraps
  101ca8:	e9 1d ff ff ff       	jmp    101bca <__alltraps>

00101cad <vector23>:
.globl vector23
vector23:
  pushl $0
  101cad:	6a 00                	push   $0x0
  pushl $23
  101caf:	6a 17                	push   $0x17
  jmp __alltraps
  101cb1:	e9 14 ff ff ff       	jmp    101bca <__alltraps>

00101cb6 <vector24>:
.globl vector24
vector24:
  pushl $0
  101cb6:	6a 00                	push   $0x0
  pushl $24
  101cb8:	6a 18                	push   $0x18
  jmp __alltraps
  101cba:	e9 0b ff ff ff       	jmp    101bca <__alltraps>

00101cbf <vector25>:
.globl vector25
vector25:
  pushl $0
  101cbf:	6a 00                	push   $0x0
  pushl $25
  101cc1:	6a 19                	push   $0x19
  jmp __alltraps
  101cc3:	e9 02 ff ff ff       	jmp    101bca <__alltraps>

00101cc8 <vector26>:
.globl vector26
vector26:
  pushl $0
  101cc8:	6a 00                	push   $0x0
  pushl $26
  101cca:	6a 1a                	push   $0x1a
  jmp __alltraps
  101ccc:	e9 f9 fe ff ff       	jmp    101bca <__alltraps>

00101cd1 <vector27>:
.globl vector27
vector27:
  pushl $0
  101cd1:	6a 00                	push   $0x0
  pushl $27
  101cd3:	6a 1b                	push   $0x1b
  jmp __alltraps
  101cd5:	e9 f0 fe ff ff       	jmp    101bca <__alltraps>

00101cda <vector28>:
.globl vector28
vector28:
  pushl $0
  101cda:	6a 00                	push   $0x0
  pushl $28
  101cdc:	6a 1c                	push   $0x1c
  jmp __alltraps
  101cde:	e9 e7 fe ff ff       	jmp    101bca <__alltraps>

00101ce3 <vector29>:
.globl vector29
vector29:
  pushl $0
  101ce3:	6a 00                	push   $0x0
  pushl $29
  101ce5:	6a 1d                	push   $0x1d
  jmp __alltraps
  101ce7:	e9 de fe ff ff       	jmp    101bca <__alltraps>

00101cec <vector30>:
.globl vector30
vector30:
  pushl $0
  101cec:	6a 00                	push   $0x0
  pushl $30
  101cee:	6a 1e                	push   $0x1e
  jmp __alltraps
  101cf0:	e9 d5 fe ff ff       	jmp    101bca <__alltraps>

00101cf5 <vector31>:
.globl vector31
vector31:
  pushl $0
  101cf5:	6a 00                	push   $0x0
  pushl $31
  101cf7:	6a 1f                	push   $0x1f
  jmp __alltraps
  101cf9:	e9 cc fe ff ff       	jmp    101bca <__alltraps>

00101cfe <vector32>:
.globl vector32
vector32:
  pushl $0
  101cfe:	6a 00                	push   $0x0
  pushl $32
  101d00:	6a 20                	push   $0x20
  jmp __alltraps
  101d02:	e9 c3 fe ff ff       	jmp    101bca <__alltraps>

00101d07 <vector33>:
.globl vector33
vector33:
  pushl $0
  101d07:	6a 00                	push   $0x0
  pushl $33
  101d09:	6a 21                	push   $0x21
  jmp __alltraps
  101d0b:	e9 ba fe ff ff       	jmp    101bca <__alltraps>

00101d10 <vector34>:
.globl vector34
vector34:
  pushl $0
  101d10:	6a 00                	push   $0x0
  pushl $34
  101d12:	6a 22                	push   $0x22
  jmp __alltraps
  101d14:	e9 b1 fe ff ff       	jmp    101bca <__alltraps>

00101d19 <vector35>:
.globl vector35
vector35:
  pushl $0
  101d19:	6a 00                	push   $0x0
  pushl $35
  101d1b:	6a 23                	push   $0x23
  jmp __alltraps
  101d1d:	e9 a8 fe ff ff       	jmp    101bca <__alltraps>

00101d22 <vector36>:
.globl vector36
vector36:
  pushl $0
  101d22:	6a 00                	push   $0x0
  pushl $36
  101d24:	6a 24                	push   $0x24
  jmp __alltraps
  101d26:	e9 9f fe ff ff       	jmp    101bca <__alltraps>

00101d2b <vector37>:
.globl vector37
vector37:
  pushl $0
  101d2b:	6a 00                	push   $0x0
  pushl $37
  101d2d:	6a 25                	push   $0x25
  jmp __alltraps
  101d2f:	e9 96 fe ff ff       	jmp    101bca <__alltraps>

00101d34 <vector38>:
.globl vector38
vector38:
  pushl $0
  101d34:	6a 00                	push   $0x0
  pushl $38
  101d36:	6a 26                	push   $0x26
  jmp __alltraps
  101d38:	e9 8d fe ff ff       	jmp    101bca <__alltraps>

00101d3d <vector39>:
.globl vector39
vector39:
  pushl $0
  101d3d:	6a 00                	push   $0x0
  pushl $39
  101d3f:	6a 27                	push   $0x27
  jmp __alltraps
  101d41:	e9 84 fe ff ff       	jmp    101bca <__alltraps>

00101d46 <vector40>:
.globl vector40
vector40:
  pushl $0
  101d46:	6a 00                	push   $0x0
  pushl $40
  101d48:	6a 28                	push   $0x28
  jmp __alltraps
  101d4a:	e9 7b fe ff ff       	jmp    101bca <__alltraps>

00101d4f <vector41>:
.globl vector41
vector41:
  pushl $0
  101d4f:	6a 00                	push   $0x0
  pushl $41
  101d51:	6a 29                	push   $0x29
  jmp __alltraps
  101d53:	e9 72 fe ff ff       	jmp    101bca <__alltraps>

00101d58 <vector42>:
.globl vector42
vector42:
  pushl $0
  101d58:	6a 00                	push   $0x0
  pushl $42
  101d5a:	6a 2a                	push   $0x2a
  jmp __alltraps
  101d5c:	e9 69 fe ff ff       	jmp    101bca <__alltraps>

00101d61 <vector43>:
.globl vector43
vector43:
  pushl $0
  101d61:	6a 00                	push   $0x0
  pushl $43
  101d63:	6a 2b                	push   $0x2b
  jmp __alltraps
  101d65:	e9 60 fe ff ff       	jmp    101bca <__alltraps>

00101d6a <vector44>:
.globl vector44
vector44:
  pushl $0
  101d6a:	6a 00                	push   $0x0
  pushl $44
  101d6c:	6a 2c                	push   $0x2c
  jmp __alltraps
  101d6e:	e9 57 fe ff ff       	jmp    101bca <__alltraps>

00101d73 <vector45>:
.globl vector45
vector45:
  pushl $0
  101d73:	6a 00                	push   $0x0
  pushl $45
  101d75:	6a 2d                	push   $0x2d
  jmp __alltraps
  101d77:	e9 4e fe ff ff       	jmp    101bca <__alltraps>

00101d7c <vector46>:
.globl vector46
vector46:
  pushl $0
  101d7c:	6a 00                	push   $0x0
  pushl $46
  101d7e:	6a 2e                	push   $0x2e
  jmp __alltraps
  101d80:	e9 45 fe ff ff       	jmp    101bca <__alltraps>

00101d85 <vector47>:
.globl vector47
vector47:
  pushl $0
  101d85:	6a 00                	push   $0x0
  pushl $47
  101d87:	6a 2f                	push   $0x2f
  jmp __alltraps
  101d89:	e9 3c fe ff ff       	jmp    101bca <__alltraps>

00101d8e <vector48>:
.globl vector48
vector48:
  pushl $0
  101d8e:	6a 00                	push   $0x0
  pushl $48
  101d90:	6a 30                	push   $0x30
  jmp __alltraps
  101d92:	e9 33 fe ff ff       	jmp    101bca <__alltraps>

00101d97 <vector49>:
.globl vector49
vector49:
  pushl $0
  101d97:	6a 00                	push   $0x0
  pushl $49
  101d99:	6a 31                	push   $0x31
  jmp __alltraps
  101d9b:	e9 2a fe ff ff       	jmp    101bca <__alltraps>

00101da0 <vector50>:
.globl vector50
vector50:
  pushl $0
  101da0:	6a 00                	push   $0x0
  pushl $50
  101da2:	6a 32                	push   $0x32
  jmp __alltraps
  101da4:	e9 21 fe ff ff       	jmp    101bca <__alltraps>

00101da9 <vector51>:
.globl vector51
vector51:
  pushl $0
  101da9:	6a 00                	push   $0x0
  pushl $51
  101dab:	6a 33                	push   $0x33
  jmp __alltraps
  101dad:	e9 18 fe ff ff       	jmp    101bca <__alltraps>

00101db2 <vector52>:
.globl vector52
vector52:
  pushl $0
  101db2:	6a 00                	push   $0x0
  pushl $52
  101db4:	6a 34                	push   $0x34
  jmp __alltraps
  101db6:	e9 0f fe ff ff       	jmp    101bca <__alltraps>

00101dbb <vector53>:
.globl vector53
vector53:
  pushl $0
  101dbb:	6a 00                	push   $0x0
  pushl $53
  101dbd:	6a 35                	push   $0x35
  jmp __alltraps
  101dbf:	e9 06 fe ff ff       	jmp    101bca <__alltraps>

00101dc4 <vector54>:
.globl vector54
vector54:
  pushl $0
  101dc4:	6a 00                	push   $0x0
  pushl $54
  101dc6:	6a 36                	push   $0x36
  jmp __alltraps
  101dc8:	e9 fd fd ff ff       	jmp    101bca <__alltraps>

00101dcd <vector55>:
.globl vector55
vector55:
  pushl $0
  101dcd:	6a 00                	push   $0x0
  pushl $55
  101dcf:	6a 37                	push   $0x37
  jmp __alltraps
  101dd1:	e9 f4 fd ff ff       	jmp    101bca <__alltraps>

00101dd6 <vector56>:
.globl vector56
vector56:
  pushl $0
  101dd6:	6a 00                	push   $0x0
  pushl $56
  101dd8:	6a 38                	push   $0x38
  jmp __alltraps
  101dda:	e9 eb fd ff ff       	jmp    101bca <__alltraps>

00101ddf <vector57>:
.globl vector57
vector57:
  pushl $0
  101ddf:	6a 00                	push   $0x0
  pushl $57
  101de1:	6a 39                	push   $0x39
  jmp __alltraps
  101de3:	e9 e2 fd ff ff       	jmp    101bca <__alltraps>

00101de8 <vector58>:
.globl vector58
vector58:
  pushl $0
  101de8:	6a 00                	push   $0x0
  pushl $58
  101dea:	6a 3a                	push   $0x3a
  jmp __alltraps
  101dec:	e9 d9 fd ff ff       	jmp    101bca <__alltraps>

00101df1 <vector59>:
.globl vector59
vector59:
  pushl $0
  101df1:	6a 00                	push   $0x0
  pushl $59
  101df3:	6a 3b                	push   $0x3b
  jmp __alltraps
  101df5:	e9 d0 fd ff ff       	jmp    101bca <__alltraps>

00101dfa <vector60>:
.globl vector60
vector60:
  pushl $0
  101dfa:	6a 00                	push   $0x0
  pushl $60
  101dfc:	6a 3c                	push   $0x3c
  jmp __alltraps
  101dfe:	e9 c7 fd ff ff       	jmp    101bca <__alltraps>

00101e03 <vector61>:
.globl vector61
vector61:
  pushl $0
  101e03:	6a 00                	push   $0x0
  pushl $61
  101e05:	6a 3d                	push   $0x3d
  jmp __alltraps
  101e07:	e9 be fd ff ff       	jmp    101bca <__alltraps>

00101e0c <vector62>:
.globl vector62
vector62:
  pushl $0
  101e0c:	6a 00                	push   $0x0
  pushl $62
  101e0e:	6a 3e                	push   $0x3e
  jmp __alltraps
  101e10:	e9 b5 fd ff ff       	jmp    101bca <__alltraps>

00101e15 <vector63>:
.globl vector63
vector63:
  pushl $0
  101e15:	6a 00                	push   $0x0
  pushl $63
  101e17:	6a 3f                	push   $0x3f
  jmp __alltraps
  101e19:	e9 ac fd ff ff       	jmp    101bca <__alltraps>

00101e1e <vector64>:
.globl vector64
vector64:
  pushl $0
  101e1e:	6a 00                	push   $0x0
  pushl $64
  101e20:	6a 40                	push   $0x40
  jmp __alltraps
  101e22:	e9 a3 fd ff ff       	jmp    101bca <__alltraps>

00101e27 <vector65>:
.globl vector65
vector65:
  pushl $0
  101e27:	6a 00                	push   $0x0
  pushl $65
  101e29:	6a 41                	push   $0x41
  jmp __alltraps
  101e2b:	e9 9a fd ff ff       	jmp    101bca <__alltraps>

00101e30 <vector66>:
.globl vector66
vector66:
  pushl $0
  101e30:	6a 00                	push   $0x0
  pushl $66
  101e32:	6a 42                	push   $0x42
  jmp __alltraps
  101e34:	e9 91 fd ff ff       	jmp    101bca <__alltraps>

00101e39 <vector67>:
.globl vector67
vector67:
  pushl $0
  101e39:	6a 00                	push   $0x0
  pushl $67
  101e3b:	6a 43                	push   $0x43
  jmp __alltraps
  101e3d:	e9 88 fd ff ff       	jmp    101bca <__alltraps>

00101e42 <vector68>:
.globl vector68
vector68:
  pushl $0
  101e42:	6a 00                	push   $0x0
  pushl $68
  101e44:	6a 44                	push   $0x44
  jmp __alltraps
  101e46:	e9 7f fd ff ff       	jmp    101bca <__alltraps>

00101e4b <vector69>:
.globl vector69
vector69:
  pushl $0
  101e4b:	6a 00                	push   $0x0
  pushl $69
  101e4d:	6a 45                	push   $0x45
  jmp __alltraps
  101e4f:	e9 76 fd ff ff       	jmp    101bca <__alltraps>

00101e54 <vector70>:
.globl vector70
vector70:
  pushl $0
  101e54:	6a 00                	push   $0x0
  pushl $70
  101e56:	6a 46                	push   $0x46
  jmp __alltraps
  101e58:	e9 6d fd ff ff       	jmp    101bca <__alltraps>

00101e5d <vector71>:
.globl vector71
vector71:
  pushl $0
  101e5d:	6a 00                	push   $0x0
  pushl $71
  101e5f:	6a 47                	push   $0x47
  jmp __alltraps
  101e61:	e9 64 fd ff ff       	jmp    101bca <__alltraps>

00101e66 <vector72>:
.globl vector72
vector72:
  pushl $0
  101e66:	6a 00                	push   $0x0
  pushl $72
  101e68:	6a 48                	push   $0x48
  jmp __alltraps
  101e6a:	e9 5b fd ff ff       	jmp    101bca <__alltraps>

00101e6f <vector73>:
.globl vector73
vector73:
  pushl $0
  101e6f:	6a 00                	push   $0x0
  pushl $73
  101e71:	6a 49                	push   $0x49
  jmp __alltraps
  101e73:	e9 52 fd ff ff       	jmp    101bca <__alltraps>

00101e78 <vector74>:
.globl vector74
vector74:
  pushl $0
  101e78:	6a 00                	push   $0x0
  pushl $74
  101e7a:	6a 4a                	push   $0x4a
  jmp __alltraps
  101e7c:	e9 49 fd ff ff       	jmp    101bca <__alltraps>

00101e81 <vector75>:
.globl vector75
vector75:
  pushl $0
  101e81:	6a 00                	push   $0x0
  pushl $75
  101e83:	6a 4b                	push   $0x4b
  jmp __alltraps
  101e85:	e9 40 fd ff ff       	jmp    101bca <__alltraps>

00101e8a <vector76>:
.globl vector76
vector76:
  pushl $0
  101e8a:	6a 00                	push   $0x0
  pushl $76
  101e8c:	6a 4c                	push   $0x4c
  jmp __alltraps
  101e8e:	e9 37 fd ff ff       	jmp    101bca <__alltraps>

00101e93 <vector77>:
.globl vector77
vector77:
  pushl $0
  101e93:	6a 00                	push   $0x0
  pushl $77
  101e95:	6a 4d                	push   $0x4d
  jmp __alltraps
  101e97:	e9 2e fd ff ff       	jmp    101bca <__alltraps>

00101e9c <vector78>:
.globl vector78
vector78:
  pushl $0
  101e9c:	6a 00                	push   $0x0
  pushl $78
  101e9e:	6a 4e                	push   $0x4e
  jmp __alltraps
  101ea0:	e9 25 fd ff ff       	jmp    101bca <__alltraps>

00101ea5 <vector79>:
.globl vector79
vector79:
  pushl $0
  101ea5:	6a 00                	push   $0x0
  pushl $79
  101ea7:	6a 4f                	push   $0x4f
  jmp __alltraps
  101ea9:	e9 1c fd ff ff       	jmp    101bca <__alltraps>

00101eae <vector80>:
.globl vector80
vector80:
  pushl $0
  101eae:	6a 00                	push   $0x0
  pushl $80
  101eb0:	6a 50                	push   $0x50
  jmp __alltraps
  101eb2:	e9 13 fd ff ff       	jmp    101bca <__alltraps>

00101eb7 <vector81>:
.globl vector81
vector81:
  pushl $0
  101eb7:	6a 00                	push   $0x0
  pushl $81
  101eb9:	6a 51                	push   $0x51
  jmp __alltraps
  101ebb:	e9 0a fd ff ff       	jmp    101bca <__alltraps>

00101ec0 <vector82>:
.globl vector82
vector82:
  pushl $0
  101ec0:	6a 00                	push   $0x0
  pushl $82
  101ec2:	6a 52                	push   $0x52
  jmp __alltraps
  101ec4:	e9 01 fd ff ff       	jmp    101bca <__alltraps>

00101ec9 <vector83>:
.globl vector83
vector83:
  pushl $0
  101ec9:	6a 00                	push   $0x0
  pushl $83
  101ecb:	6a 53                	push   $0x53
  jmp __alltraps
  101ecd:	e9 f8 fc ff ff       	jmp    101bca <__alltraps>

00101ed2 <vector84>:
.globl vector84
vector84:
  pushl $0
  101ed2:	6a 00                	push   $0x0
  pushl $84
  101ed4:	6a 54                	push   $0x54
  jmp __alltraps
  101ed6:	e9 ef fc ff ff       	jmp    101bca <__alltraps>

00101edb <vector85>:
.globl vector85
vector85:
  pushl $0
  101edb:	6a 00                	push   $0x0
  pushl $85
  101edd:	6a 55                	push   $0x55
  jmp __alltraps
  101edf:	e9 e6 fc ff ff       	jmp    101bca <__alltraps>

00101ee4 <vector86>:
.globl vector86
vector86:
  pushl $0
  101ee4:	6a 00                	push   $0x0
  pushl $86
  101ee6:	6a 56                	push   $0x56
  jmp __alltraps
  101ee8:	e9 dd fc ff ff       	jmp    101bca <__alltraps>

00101eed <vector87>:
.globl vector87
vector87:
  pushl $0
  101eed:	6a 00                	push   $0x0
  pushl $87
  101eef:	6a 57                	push   $0x57
  jmp __alltraps
  101ef1:	e9 d4 fc ff ff       	jmp    101bca <__alltraps>

00101ef6 <vector88>:
.globl vector88
vector88:
  pushl $0
  101ef6:	6a 00                	push   $0x0
  pushl $88
  101ef8:	6a 58                	push   $0x58
  jmp __alltraps
  101efa:	e9 cb fc ff ff       	jmp    101bca <__alltraps>

00101eff <vector89>:
.globl vector89
vector89:
  pushl $0
  101eff:	6a 00                	push   $0x0
  pushl $89
  101f01:	6a 59                	push   $0x59
  jmp __alltraps
  101f03:	e9 c2 fc ff ff       	jmp    101bca <__alltraps>

00101f08 <vector90>:
.globl vector90
vector90:
  pushl $0
  101f08:	6a 00                	push   $0x0
  pushl $90
  101f0a:	6a 5a                	push   $0x5a
  jmp __alltraps
  101f0c:	e9 b9 fc ff ff       	jmp    101bca <__alltraps>

00101f11 <vector91>:
.globl vector91
vector91:
  pushl $0
  101f11:	6a 00                	push   $0x0
  pushl $91
  101f13:	6a 5b                	push   $0x5b
  jmp __alltraps
  101f15:	e9 b0 fc ff ff       	jmp    101bca <__alltraps>

00101f1a <vector92>:
.globl vector92
vector92:
  pushl $0
  101f1a:	6a 00                	push   $0x0
  pushl $92
  101f1c:	6a 5c                	push   $0x5c
  jmp __alltraps
  101f1e:	e9 a7 fc ff ff       	jmp    101bca <__alltraps>

00101f23 <vector93>:
.globl vector93
vector93:
  pushl $0
  101f23:	6a 00                	push   $0x0
  pushl $93
  101f25:	6a 5d                	push   $0x5d
  jmp __alltraps
  101f27:	e9 9e fc ff ff       	jmp    101bca <__alltraps>

00101f2c <vector94>:
.globl vector94
vector94:
  pushl $0
  101f2c:	6a 00                	push   $0x0
  pushl $94
  101f2e:	6a 5e                	push   $0x5e
  jmp __alltraps
  101f30:	e9 95 fc ff ff       	jmp    101bca <__alltraps>

00101f35 <vector95>:
.globl vector95
vector95:
  pushl $0
  101f35:	6a 00                	push   $0x0
  pushl $95
  101f37:	6a 5f                	push   $0x5f
  jmp __alltraps
  101f39:	e9 8c fc ff ff       	jmp    101bca <__alltraps>

00101f3e <vector96>:
.globl vector96
vector96:
  pushl $0
  101f3e:	6a 00                	push   $0x0
  pushl $96
  101f40:	6a 60                	push   $0x60
  jmp __alltraps
  101f42:	e9 83 fc ff ff       	jmp    101bca <__alltraps>

00101f47 <vector97>:
.globl vector97
vector97:
  pushl $0
  101f47:	6a 00                	push   $0x0
  pushl $97
  101f49:	6a 61                	push   $0x61
  jmp __alltraps
  101f4b:	e9 7a fc ff ff       	jmp    101bca <__alltraps>

00101f50 <vector98>:
.globl vector98
vector98:
  pushl $0
  101f50:	6a 00                	push   $0x0
  pushl $98
  101f52:	6a 62                	push   $0x62
  jmp __alltraps
  101f54:	e9 71 fc ff ff       	jmp    101bca <__alltraps>

00101f59 <vector99>:
.globl vector99
vector99:
  pushl $0
  101f59:	6a 00                	push   $0x0
  pushl $99
  101f5b:	6a 63                	push   $0x63
  jmp __alltraps
  101f5d:	e9 68 fc ff ff       	jmp    101bca <__alltraps>

00101f62 <vector100>:
.globl vector100
vector100:
  pushl $0
  101f62:	6a 00                	push   $0x0
  pushl $100
  101f64:	6a 64                	push   $0x64
  jmp __alltraps
  101f66:	e9 5f fc ff ff       	jmp    101bca <__alltraps>

00101f6b <vector101>:
.globl vector101
vector101:
  pushl $0
  101f6b:	6a 00                	push   $0x0
  pushl $101
  101f6d:	6a 65                	push   $0x65
  jmp __alltraps
  101f6f:	e9 56 fc ff ff       	jmp    101bca <__alltraps>

00101f74 <vector102>:
.globl vector102
vector102:
  pushl $0
  101f74:	6a 00                	push   $0x0
  pushl $102
  101f76:	6a 66                	push   $0x66
  jmp __alltraps
  101f78:	e9 4d fc ff ff       	jmp    101bca <__alltraps>

00101f7d <vector103>:
.globl vector103
vector103:
  pushl $0
  101f7d:	6a 00                	push   $0x0
  pushl $103
  101f7f:	6a 67                	push   $0x67
  jmp __alltraps
  101f81:	e9 44 fc ff ff       	jmp    101bca <__alltraps>

00101f86 <vector104>:
.globl vector104
vector104:
  pushl $0
  101f86:	6a 00                	push   $0x0
  pushl $104
  101f88:	6a 68                	push   $0x68
  jmp __alltraps
  101f8a:	e9 3b fc ff ff       	jmp    101bca <__alltraps>

00101f8f <vector105>:
.globl vector105
vector105:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $105
  101f91:	6a 69                	push   $0x69
  jmp __alltraps
  101f93:	e9 32 fc ff ff       	jmp    101bca <__alltraps>

00101f98 <vector106>:
.globl vector106
vector106:
  pushl $0
  101f98:	6a 00                	push   $0x0
  pushl $106
  101f9a:	6a 6a                	push   $0x6a
  jmp __alltraps
  101f9c:	e9 29 fc ff ff       	jmp    101bca <__alltraps>

00101fa1 <vector107>:
.globl vector107
vector107:
  pushl $0
  101fa1:	6a 00                	push   $0x0
  pushl $107
  101fa3:	6a 6b                	push   $0x6b
  jmp __alltraps
  101fa5:	e9 20 fc ff ff       	jmp    101bca <__alltraps>

00101faa <vector108>:
.globl vector108
vector108:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $108
  101fac:	6a 6c                	push   $0x6c
  jmp __alltraps
  101fae:	e9 17 fc ff ff       	jmp    101bca <__alltraps>

00101fb3 <vector109>:
.globl vector109
vector109:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $109
  101fb5:	6a 6d                	push   $0x6d
  jmp __alltraps
  101fb7:	e9 0e fc ff ff       	jmp    101bca <__alltraps>

00101fbc <vector110>:
.globl vector110
vector110:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $110
  101fbe:	6a 6e                	push   $0x6e
  jmp __alltraps
  101fc0:	e9 05 fc ff ff       	jmp    101bca <__alltraps>

00101fc5 <vector111>:
.globl vector111
vector111:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $111
  101fc7:	6a 6f                	push   $0x6f
  jmp __alltraps
  101fc9:	e9 fc fb ff ff       	jmp    101bca <__alltraps>

00101fce <vector112>:
.globl vector112
vector112:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $112
  101fd0:	6a 70                	push   $0x70
  jmp __alltraps
  101fd2:	e9 f3 fb ff ff       	jmp    101bca <__alltraps>

00101fd7 <vector113>:
.globl vector113
vector113:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $113
  101fd9:	6a 71                	push   $0x71
  jmp __alltraps
  101fdb:	e9 ea fb ff ff       	jmp    101bca <__alltraps>

00101fe0 <vector114>:
.globl vector114
vector114:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $114
  101fe2:	6a 72                	push   $0x72
  jmp __alltraps
  101fe4:	e9 e1 fb ff ff       	jmp    101bca <__alltraps>

00101fe9 <vector115>:
.globl vector115
vector115:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $115
  101feb:	6a 73                	push   $0x73
  jmp __alltraps
  101fed:	e9 d8 fb ff ff       	jmp    101bca <__alltraps>

00101ff2 <vector116>:
.globl vector116
vector116:
  pushl $0
  101ff2:	6a 00                	push   $0x0
  pushl $116
  101ff4:	6a 74                	push   $0x74
  jmp __alltraps
  101ff6:	e9 cf fb ff ff       	jmp    101bca <__alltraps>

00101ffb <vector117>:
.globl vector117
vector117:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $117
  101ffd:	6a 75                	push   $0x75
  jmp __alltraps
  101fff:	e9 c6 fb ff ff       	jmp    101bca <__alltraps>

00102004 <vector118>:
.globl vector118
vector118:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $118
  102006:	6a 76                	push   $0x76
  jmp __alltraps
  102008:	e9 bd fb ff ff       	jmp    101bca <__alltraps>

0010200d <vector119>:
.globl vector119
vector119:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $119
  10200f:	6a 77                	push   $0x77
  jmp __alltraps
  102011:	e9 b4 fb ff ff       	jmp    101bca <__alltraps>

00102016 <vector120>:
.globl vector120
vector120:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $120
  102018:	6a 78                	push   $0x78
  jmp __alltraps
  10201a:	e9 ab fb ff ff       	jmp    101bca <__alltraps>

0010201f <vector121>:
.globl vector121
vector121:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $121
  102021:	6a 79                	push   $0x79
  jmp __alltraps
  102023:	e9 a2 fb ff ff       	jmp    101bca <__alltraps>

00102028 <vector122>:
.globl vector122
vector122:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $122
  10202a:	6a 7a                	push   $0x7a
  jmp __alltraps
  10202c:	e9 99 fb ff ff       	jmp    101bca <__alltraps>

00102031 <vector123>:
.globl vector123
vector123:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $123
  102033:	6a 7b                	push   $0x7b
  jmp __alltraps
  102035:	e9 90 fb ff ff       	jmp    101bca <__alltraps>

0010203a <vector124>:
.globl vector124
vector124:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $124
  10203c:	6a 7c                	push   $0x7c
  jmp __alltraps
  10203e:	e9 87 fb ff ff       	jmp    101bca <__alltraps>

00102043 <vector125>:
.globl vector125
vector125:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $125
  102045:	6a 7d                	push   $0x7d
  jmp __alltraps
  102047:	e9 7e fb ff ff       	jmp    101bca <__alltraps>

0010204c <vector126>:
.globl vector126
vector126:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $126
  10204e:	6a 7e                	push   $0x7e
  jmp __alltraps
  102050:	e9 75 fb ff ff       	jmp    101bca <__alltraps>

00102055 <vector127>:
.globl vector127
vector127:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $127
  102057:	6a 7f                	push   $0x7f
  jmp __alltraps
  102059:	e9 6c fb ff ff       	jmp    101bca <__alltraps>

0010205e <vector128>:
.globl vector128
vector128:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $128
  102060:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102065:	e9 60 fb ff ff       	jmp    101bca <__alltraps>

0010206a <vector129>:
.globl vector129
vector129:
  pushl $0
  10206a:	6a 00                	push   $0x0
  pushl $129
  10206c:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102071:	e9 54 fb ff ff       	jmp    101bca <__alltraps>

00102076 <vector130>:
.globl vector130
vector130:
  pushl $0
  102076:	6a 00                	push   $0x0
  pushl $130
  102078:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10207d:	e9 48 fb ff ff       	jmp    101bca <__alltraps>

00102082 <vector131>:
.globl vector131
vector131:
  pushl $0
  102082:	6a 00                	push   $0x0
  pushl $131
  102084:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102089:	e9 3c fb ff ff       	jmp    101bca <__alltraps>

0010208e <vector132>:
.globl vector132
vector132:
  pushl $0
  10208e:	6a 00                	push   $0x0
  pushl $132
  102090:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102095:	e9 30 fb ff ff       	jmp    101bca <__alltraps>

0010209a <vector133>:
.globl vector133
vector133:
  pushl $0
  10209a:	6a 00                	push   $0x0
  pushl $133
  10209c:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1020a1:	e9 24 fb ff ff       	jmp    101bca <__alltraps>

001020a6 <vector134>:
.globl vector134
vector134:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $134
  1020a8:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1020ad:	e9 18 fb ff ff       	jmp    101bca <__alltraps>

001020b2 <vector135>:
.globl vector135
vector135:
  pushl $0
  1020b2:	6a 00                	push   $0x0
  pushl $135
  1020b4:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1020b9:	e9 0c fb ff ff       	jmp    101bca <__alltraps>

001020be <vector136>:
.globl vector136
vector136:
  pushl $0
  1020be:	6a 00                	push   $0x0
  pushl $136
  1020c0:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1020c5:	e9 00 fb ff ff       	jmp    101bca <__alltraps>

001020ca <vector137>:
.globl vector137
vector137:
  pushl $0
  1020ca:	6a 00                	push   $0x0
  pushl $137
  1020cc:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1020d1:	e9 f4 fa ff ff       	jmp    101bca <__alltraps>

001020d6 <vector138>:
.globl vector138
vector138:
  pushl $0
  1020d6:	6a 00                	push   $0x0
  pushl $138
  1020d8:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1020dd:	e9 e8 fa ff ff       	jmp    101bca <__alltraps>

001020e2 <vector139>:
.globl vector139
vector139:
  pushl $0
  1020e2:	6a 00                	push   $0x0
  pushl $139
  1020e4:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1020e9:	e9 dc fa ff ff       	jmp    101bca <__alltraps>

001020ee <vector140>:
.globl vector140
vector140:
  pushl $0
  1020ee:	6a 00                	push   $0x0
  pushl $140
  1020f0:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1020f5:	e9 d0 fa ff ff       	jmp    101bca <__alltraps>

001020fa <vector141>:
.globl vector141
vector141:
  pushl $0
  1020fa:	6a 00                	push   $0x0
  pushl $141
  1020fc:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102101:	e9 c4 fa ff ff       	jmp    101bca <__alltraps>

00102106 <vector142>:
.globl vector142
vector142:
  pushl $0
  102106:	6a 00                	push   $0x0
  pushl $142
  102108:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10210d:	e9 b8 fa ff ff       	jmp    101bca <__alltraps>

00102112 <vector143>:
.globl vector143
vector143:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $143
  102114:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102119:	e9 ac fa ff ff       	jmp    101bca <__alltraps>

0010211e <vector144>:
.globl vector144
vector144:
  pushl $0
  10211e:	6a 00                	push   $0x0
  pushl $144
  102120:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102125:	e9 a0 fa ff ff       	jmp    101bca <__alltraps>

0010212a <vector145>:
.globl vector145
vector145:
  pushl $0
  10212a:	6a 00                	push   $0x0
  pushl $145
  10212c:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102131:	e9 94 fa ff ff       	jmp    101bca <__alltraps>

00102136 <vector146>:
.globl vector146
vector146:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $146
  102138:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10213d:	e9 88 fa ff ff       	jmp    101bca <__alltraps>

00102142 <vector147>:
.globl vector147
vector147:
  pushl $0
  102142:	6a 00                	push   $0x0
  pushl $147
  102144:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102149:	e9 7c fa ff ff       	jmp    101bca <__alltraps>

0010214e <vector148>:
.globl vector148
vector148:
  pushl $0
  10214e:	6a 00                	push   $0x0
  pushl $148
  102150:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102155:	e9 70 fa ff ff       	jmp    101bca <__alltraps>

0010215a <vector149>:
.globl vector149
vector149:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $149
  10215c:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102161:	e9 64 fa ff ff       	jmp    101bca <__alltraps>

00102166 <vector150>:
.globl vector150
vector150:
  pushl $0
  102166:	6a 00                	push   $0x0
  pushl $150
  102168:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10216d:	e9 58 fa ff ff       	jmp    101bca <__alltraps>

00102172 <vector151>:
.globl vector151
vector151:
  pushl $0
  102172:	6a 00                	push   $0x0
  pushl $151
  102174:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102179:	e9 4c fa ff ff       	jmp    101bca <__alltraps>

0010217e <vector152>:
.globl vector152
vector152:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $152
  102180:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102185:	e9 40 fa ff ff       	jmp    101bca <__alltraps>

0010218a <vector153>:
.globl vector153
vector153:
  pushl $0
  10218a:	6a 00                	push   $0x0
  pushl $153
  10218c:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102191:	e9 34 fa ff ff       	jmp    101bca <__alltraps>

00102196 <vector154>:
.globl vector154
vector154:
  pushl $0
  102196:	6a 00                	push   $0x0
  pushl $154
  102198:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10219d:	e9 28 fa ff ff       	jmp    101bca <__alltraps>

001021a2 <vector155>:
.globl vector155
vector155:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $155
  1021a4:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1021a9:	e9 1c fa ff ff       	jmp    101bca <__alltraps>

001021ae <vector156>:
.globl vector156
vector156:
  pushl $0
  1021ae:	6a 00                	push   $0x0
  pushl $156
  1021b0:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1021b5:	e9 10 fa ff ff       	jmp    101bca <__alltraps>

001021ba <vector157>:
.globl vector157
vector157:
  pushl $0
  1021ba:	6a 00                	push   $0x0
  pushl $157
  1021bc:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1021c1:	e9 04 fa ff ff       	jmp    101bca <__alltraps>

001021c6 <vector158>:
.globl vector158
vector158:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $158
  1021c8:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1021cd:	e9 f8 f9 ff ff       	jmp    101bca <__alltraps>

001021d2 <vector159>:
.globl vector159
vector159:
  pushl $0
  1021d2:	6a 00                	push   $0x0
  pushl $159
  1021d4:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1021d9:	e9 ec f9 ff ff       	jmp    101bca <__alltraps>

001021de <vector160>:
.globl vector160
vector160:
  pushl $0
  1021de:	6a 00                	push   $0x0
  pushl $160
  1021e0:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1021e5:	e9 e0 f9 ff ff       	jmp    101bca <__alltraps>

001021ea <vector161>:
.globl vector161
vector161:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $161
  1021ec:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1021f1:	e9 d4 f9 ff ff       	jmp    101bca <__alltraps>

001021f6 <vector162>:
.globl vector162
vector162:
  pushl $0
  1021f6:	6a 00                	push   $0x0
  pushl $162
  1021f8:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1021fd:	e9 c8 f9 ff ff       	jmp    101bca <__alltraps>

00102202 <vector163>:
.globl vector163
vector163:
  pushl $0
  102202:	6a 00                	push   $0x0
  pushl $163
  102204:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102209:	e9 bc f9 ff ff       	jmp    101bca <__alltraps>

0010220e <vector164>:
.globl vector164
vector164:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $164
  102210:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102215:	e9 b0 f9 ff ff       	jmp    101bca <__alltraps>

0010221a <vector165>:
.globl vector165
vector165:
  pushl $0
  10221a:	6a 00                	push   $0x0
  pushl $165
  10221c:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102221:	e9 a4 f9 ff ff       	jmp    101bca <__alltraps>

00102226 <vector166>:
.globl vector166
vector166:
  pushl $0
  102226:	6a 00                	push   $0x0
  pushl $166
  102228:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10222d:	e9 98 f9 ff ff       	jmp    101bca <__alltraps>

00102232 <vector167>:
.globl vector167
vector167:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $167
  102234:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102239:	e9 8c f9 ff ff       	jmp    101bca <__alltraps>

0010223e <vector168>:
.globl vector168
vector168:
  pushl $0
  10223e:	6a 00                	push   $0x0
  pushl $168
  102240:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102245:	e9 80 f9 ff ff       	jmp    101bca <__alltraps>

0010224a <vector169>:
.globl vector169
vector169:
  pushl $0
  10224a:	6a 00                	push   $0x0
  pushl $169
  10224c:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102251:	e9 74 f9 ff ff       	jmp    101bca <__alltraps>

00102256 <vector170>:
.globl vector170
vector170:
  pushl $0
  102256:	6a 00                	push   $0x0
  pushl $170
  102258:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10225d:	e9 68 f9 ff ff       	jmp    101bca <__alltraps>

00102262 <vector171>:
.globl vector171
vector171:
  pushl $0
  102262:	6a 00                	push   $0x0
  pushl $171
  102264:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102269:	e9 5c f9 ff ff       	jmp    101bca <__alltraps>

0010226e <vector172>:
.globl vector172
vector172:
  pushl $0
  10226e:	6a 00                	push   $0x0
  pushl $172
  102270:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102275:	e9 50 f9 ff ff       	jmp    101bca <__alltraps>

0010227a <vector173>:
.globl vector173
vector173:
  pushl $0
  10227a:	6a 00                	push   $0x0
  pushl $173
  10227c:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102281:	e9 44 f9 ff ff       	jmp    101bca <__alltraps>

00102286 <vector174>:
.globl vector174
vector174:
  pushl $0
  102286:	6a 00                	push   $0x0
  pushl $174
  102288:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10228d:	e9 38 f9 ff ff       	jmp    101bca <__alltraps>

00102292 <vector175>:
.globl vector175
vector175:
  pushl $0
  102292:	6a 00                	push   $0x0
  pushl $175
  102294:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102299:	e9 2c f9 ff ff       	jmp    101bca <__alltraps>

0010229e <vector176>:
.globl vector176
vector176:
  pushl $0
  10229e:	6a 00                	push   $0x0
  pushl $176
  1022a0:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1022a5:	e9 20 f9 ff ff       	jmp    101bca <__alltraps>

001022aa <vector177>:
.globl vector177
vector177:
  pushl $0
  1022aa:	6a 00                	push   $0x0
  pushl $177
  1022ac:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1022b1:	e9 14 f9 ff ff       	jmp    101bca <__alltraps>

001022b6 <vector178>:
.globl vector178
vector178:
  pushl $0
  1022b6:	6a 00                	push   $0x0
  pushl $178
  1022b8:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1022bd:	e9 08 f9 ff ff       	jmp    101bca <__alltraps>

001022c2 <vector179>:
.globl vector179
vector179:
  pushl $0
  1022c2:	6a 00                	push   $0x0
  pushl $179
  1022c4:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1022c9:	e9 fc f8 ff ff       	jmp    101bca <__alltraps>

001022ce <vector180>:
.globl vector180
vector180:
  pushl $0
  1022ce:	6a 00                	push   $0x0
  pushl $180
  1022d0:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1022d5:	e9 f0 f8 ff ff       	jmp    101bca <__alltraps>

001022da <vector181>:
.globl vector181
vector181:
  pushl $0
  1022da:	6a 00                	push   $0x0
  pushl $181
  1022dc:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1022e1:	e9 e4 f8 ff ff       	jmp    101bca <__alltraps>

001022e6 <vector182>:
.globl vector182
vector182:
  pushl $0
  1022e6:	6a 00                	push   $0x0
  pushl $182
  1022e8:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1022ed:	e9 d8 f8 ff ff       	jmp    101bca <__alltraps>

001022f2 <vector183>:
.globl vector183
vector183:
  pushl $0
  1022f2:	6a 00                	push   $0x0
  pushl $183
  1022f4:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1022f9:	e9 cc f8 ff ff       	jmp    101bca <__alltraps>

001022fe <vector184>:
.globl vector184
vector184:
  pushl $0
  1022fe:	6a 00                	push   $0x0
  pushl $184
  102300:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102305:	e9 c0 f8 ff ff       	jmp    101bca <__alltraps>

0010230a <vector185>:
.globl vector185
vector185:
  pushl $0
  10230a:	6a 00                	push   $0x0
  pushl $185
  10230c:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102311:	e9 b4 f8 ff ff       	jmp    101bca <__alltraps>

00102316 <vector186>:
.globl vector186
vector186:
  pushl $0
  102316:	6a 00                	push   $0x0
  pushl $186
  102318:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10231d:	e9 a8 f8 ff ff       	jmp    101bca <__alltraps>

00102322 <vector187>:
.globl vector187
vector187:
  pushl $0
  102322:	6a 00                	push   $0x0
  pushl $187
  102324:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102329:	e9 9c f8 ff ff       	jmp    101bca <__alltraps>

0010232e <vector188>:
.globl vector188
vector188:
  pushl $0
  10232e:	6a 00                	push   $0x0
  pushl $188
  102330:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102335:	e9 90 f8 ff ff       	jmp    101bca <__alltraps>

0010233a <vector189>:
.globl vector189
vector189:
  pushl $0
  10233a:	6a 00                	push   $0x0
  pushl $189
  10233c:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102341:	e9 84 f8 ff ff       	jmp    101bca <__alltraps>

00102346 <vector190>:
.globl vector190
vector190:
  pushl $0
  102346:	6a 00                	push   $0x0
  pushl $190
  102348:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10234d:	e9 78 f8 ff ff       	jmp    101bca <__alltraps>

00102352 <vector191>:
.globl vector191
vector191:
  pushl $0
  102352:	6a 00                	push   $0x0
  pushl $191
  102354:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102359:	e9 6c f8 ff ff       	jmp    101bca <__alltraps>

0010235e <vector192>:
.globl vector192
vector192:
  pushl $0
  10235e:	6a 00                	push   $0x0
  pushl $192
  102360:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102365:	e9 60 f8 ff ff       	jmp    101bca <__alltraps>

0010236a <vector193>:
.globl vector193
vector193:
  pushl $0
  10236a:	6a 00                	push   $0x0
  pushl $193
  10236c:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102371:	e9 54 f8 ff ff       	jmp    101bca <__alltraps>

00102376 <vector194>:
.globl vector194
vector194:
  pushl $0
  102376:	6a 00                	push   $0x0
  pushl $194
  102378:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10237d:	e9 48 f8 ff ff       	jmp    101bca <__alltraps>

00102382 <vector195>:
.globl vector195
vector195:
  pushl $0
  102382:	6a 00                	push   $0x0
  pushl $195
  102384:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102389:	e9 3c f8 ff ff       	jmp    101bca <__alltraps>

0010238e <vector196>:
.globl vector196
vector196:
  pushl $0
  10238e:	6a 00                	push   $0x0
  pushl $196
  102390:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102395:	e9 30 f8 ff ff       	jmp    101bca <__alltraps>

0010239a <vector197>:
.globl vector197
vector197:
  pushl $0
  10239a:	6a 00                	push   $0x0
  pushl $197
  10239c:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1023a1:	e9 24 f8 ff ff       	jmp    101bca <__alltraps>

001023a6 <vector198>:
.globl vector198
vector198:
  pushl $0
  1023a6:	6a 00                	push   $0x0
  pushl $198
  1023a8:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1023ad:	e9 18 f8 ff ff       	jmp    101bca <__alltraps>

001023b2 <vector199>:
.globl vector199
vector199:
  pushl $0
  1023b2:	6a 00                	push   $0x0
  pushl $199
  1023b4:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1023b9:	e9 0c f8 ff ff       	jmp    101bca <__alltraps>

001023be <vector200>:
.globl vector200
vector200:
  pushl $0
  1023be:	6a 00                	push   $0x0
  pushl $200
  1023c0:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1023c5:	e9 00 f8 ff ff       	jmp    101bca <__alltraps>

001023ca <vector201>:
.globl vector201
vector201:
  pushl $0
  1023ca:	6a 00                	push   $0x0
  pushl $201
  1023cc:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1023d1:	e9 f4 f7 ff ff       	jmp    101bca <__alltraps>

001023d6 <vector202>:
.globl vector202
vector202:
  pushl $0
  1023d6:	6a 00                	push   $0x0
  pushl $202
  1023d8:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1023dd:	e9 e8 f7 ff ff       	jmp    101bca <__alltraps>

001023e2 <vector203>:
.globl vector203
vector203:
  pushl $0
  1023e2:	6a 00                	push   $0x0
  pushl $203
  1023e4:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1023e9:	e9 dc f7 ff ff       	jmp    101bca <__alltraps>

001023ee <vector204>:
.globl vector204
vector204:
  pushl $0
  1023ee:	6a 00                	push   $0x0
  pushl $204
  1023f0:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1023f5:	e9 d0 f7 ff ff       	jmp    101bca <__alltraps>

001023fa <vector205>:
.globl vector205
vector205:
  pushl $0
  1023fa:	6a 00                	push   $0x0
  pushl $205
  1023fc:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102401:	e9 c4 f7 ff ff       	jmp    101bca <__alltraps>

00102406 <vector206>:
.globl vector206
vector206:
  pushl $0
  102406:	6a 00                	push   $0x0
  pushl $206
  102408:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10240d:	e9 b8 f7 ff ff       	jmp    101bca <__alltraps>

00102412 <vector207>:
.globl vector207
vector207:
  pushl $0
  102412:	6a 00                	push   $0x0
  pushl $207
  102414:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102419:	e9 ac f7 ff ff       	jmp    101bca <__alltraps>

0010241e <vector208>:
.globl vector208
vector208:
  pushl $0
  10241e:	6a 00                	push   $0x0
  pushl $208
  102420:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102425:	e9 a0 f7 ff ff       	jmp    101bca <__alltraps>

0010242a <vector209>:
.globl vector209
vector209:
  pushl $0
  10242a:	6a 00                	push   $0x0
  pushl $209
  10242c:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102431:	e9 94 f7 ff ff       	jmp    101bca <__alltraps>

00102436 <vector210>:
.globl vector210
vector210:
  pushl $0
  102436:	6a 00                	push   $0x0
  pushl $210
  102438:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10243d:	e9 88 f7 ff ff       	jmp    101bca <__alltraps>

00102442 <vector211>:
.globl vector211
vector211:
  pushl $0
  102442:	6a 00                	push   $0x0
  pushl $211
  102444:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102449:	e9 7c f7 ff ff       	jmp    101bca <__alltraps>

0010244e <vector212>:
.globl vector212
vector212:
  pushl $0
  10244e:	6a 00                	push   $0x0
  pushl $212
  102450:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102455:	e9 70 f7 ff ff       	jmp    101bca <__alltraps>

0010245a <vector213>:
.globl vector213
vector213:
  pushl $0
  10245a:	6a 00                	push   $0x0
  pushl $213
  10245c:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102461:	e9 64 f7 ff ff       	jmp    101bca <__alltraps>

00102466 <vector214>:
.globl vector214
vector214:
  pushl $0
  102466:	6a 00                	push   $0x0
  pushl $214
  102468:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10246d:	e9 58 f7 ff ff       	jmp    101bca <__alltraps>

00102472 <vector215>:
.globl vector215
vector215:
  pushl $0
  102472:	6a 00                	push   $0x0
  pushl $215
  102474:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102479:	e9 4c f7 ff ff       	jmp    101bca <__alltraps>

0010247e <vector216>:
.globl vector216
vector216:
  pushl $0
  10247e:	6a 00                	push   $0x0
  pushl $216
  102480:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102485:	e9 40 f7 ff ff       	jmp    101bca <__alltraps>

0010248a <vector217>:
.globl vector217
vector217:
  pushl $0
  10248a:	6a 00                	push   $0x0
  pushl $217
  10248c:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102491:	e9 34 f7 ff ff       	jmp    101bca <__alltraps>

00102496 <vector218>:
.globl vector218
vector218:
  pushl $0
  102496:	6a 00                	push   $0x0
  pushl $218
  102498:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10249d:	e9 28 f7 ff ff       	jmp    101bca <__alltraps>

001024a2 <vector219>:
.globl vector219
vector219:
  pushl $0
  1024a2:	6a 00                	push   $0x0
  pushl $219
  1024a4:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1024a9:	e9 1c f7 ff ff       	jmp    101bca <__alltraps>

001024ae <vector220>:
.globl vector220
vector220:
  pushl $0
  1024ae:	6a 00                	push   $0x0
  pushl $220
  1024b0:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1024b5:	e9 10 f7 ff ff       	jmp    101bca <__alltraps>

001024ba <vector221>:
.globl vector221
vector221:
  pushl $0
  1024ba:	6a 00                	push   $0x0
  pushl $221
  1024bc:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1024c1:	e9 04 f7 ff ff       	jmp    101bca <__alltraps>

001024c6 <vector222>:
.globl vector222
vector222:
  pushl $0
  1024c6:	6a 00                	push   $0x0
  pushl $222
  1024c8:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1024cd:	e9 f8 f6 ff ff       	jmp    101bca <__alltraps>

001024d2 <vector223>:
.globl vector223
vector223:
  pushl $0
  1024d2:	6a 00                	push   $0x0
  pushl $223
  1024d4:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1024d9:	e9 ec f6 ff ff       	jmp    101bca <__alltraps>

001024de <vector224>:
.globl vector224
vector224:
  pushl $0
  1024de:	6a 00                	push   $0x0
  pushl $224
  1024e0:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1024e5:	e9 e0 f6 ff ff       	jmp    101bca <__alltraps>

001024ea <vector225>:
.globl vector225
vector225:
  pushl $0
  1024ea:	6a 00                	push   $0x0
  pushl $225
  1024ec:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1024f1:	e9 d4 f6 ff ff       	jmp    101bca <__alltraps>

001024f6 <vector226>:
.globl vector226
vector226:
  pushl $0
  1024f6:	6a 00                	push   $0x0
  pushl $226
  1024f8:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1024fd:	e9 c8 f6 ff ff       	jmp    101bca <__alltraps>

00102502 <vector227>:
.globl vector227
vector227:
  pushl $0
  102502:	6a 00                	push   $0x0
  pushl $227
  102504:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102509:	e9 bc f6 ff ff       	jmp    101bca <__alltraps>

0010250e <vector228>:
.globl vector228
vector228:
  pushl $0
  10250e:	6a 00                	push   $0x0
  pushl $228
  102510:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102515:	e9 b0 f6 ff ff       	jmp    101bca <__alltraps>

0010251a <vector229>:
.globl vector229
vector229:
  pushl $0
  10251a:	6a 00                	push   $0x0
  pushl $229
  10251c:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102521:	e9 a4 f6 ff ff       	jmp    101bca <__alltraps>

00102526 <vector230>:
.globl vector230
vector230:
  pushl $0
  102526:	6a 00                	push   $0x0
  pushl $230
  102528:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10252d:	e9 98 f6 ff ff       	jmp    101bca <__alltraps>

00102532 <vector231>:
.globl vector231
vector231:
  pushl $0
  102532:	6a 00                	push   $0x0
  pushl $231
  102534:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102539:	e9 8c f6 ff ff       	jmp    101bca <__alltraps>

0010253e <vector232>:
.globl vector232
vector232:
  pushl $0
  10253e:	6a 00                	push   $0x0
  pushl $232
  102540:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102545:	e9 80 f6 ff ff       	jmp    101bca <__alltraps>

0010254a <vector233>:
.globl vector233
vector233:
  pushl $0
  10254a:	6a 00                	push   $0x0
  pushl $233
  10254c:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102551:	e9 74 f6 ff ff       	jmp    101bca <__alltraps>

00102556 <vector234>:
.globl vector234
vector234:
  pushl $0
  102556:	6a 00                	push   $0x0
  pushl $234
  102558:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10255d:	e9 68 f6 ff ff       	jmp    101bca <__alltraps>

00102562 <vector235>:
.globl vector235
vector235:
  pushl $0
  102562:	6a 00                	push   $0x0
  pushl $235
  102564:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102569:	e9 5c f6 ff ff       	jmp    101bca <__alltraps>

0010256e <vector236>:
.globl vector236
vector236:
  pushl $0
  10256e:	6a 00                	push   $0x0
  pushl $236
  102570:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102575:	e9 50 f6 ff ff       	jmp    101bca <__alltraps>

0010257a <vector237>:
.globl vector237
vector237:
  pushl $0
  10257a:	6a 00                	push   $0x0
  pushl $237
  10257c:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102581:	e9 44 f6 ff ff       	jmp    101bca <__alltraps>

00102586 <vector238>:
.globl vector238
vector238:
  pushl $0
  102586:	6a 00                	push   $0x0
  pushl $238
  102588:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10258d:	e9 38 f6 ff ff       	jmp    101bca <__alltraps>

00102592 <vector239>:
.globl vector239
vector239:
  pushl $0
  102592:	6a 00                	push   $0x0
  pushl $239
  102594:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102599:	e9 2c f6 ff ff       	jmp    101bca <__alltraps>

0010259e <vector240>:
.globl vector240
vector240:
  pushl $0
  10259e:	6a 00                	push   $0x0
  pushl $240
  1025a0:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1025a5:	e9 20 f6 ff ff       	jmp    101bca <__alltraps>

001025aa <vector241>:
.globl vector241
vector241:
  pushl $0
  1025aa:	6a 00                	push   $0x0
  pushl $241
  1025ac:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1025b1:	e9 14 f6 ff ff       	jmp    101bca <__alltraps>

001025b6 <vector242>:
.globl vector242
vector242:
  pushl $0
  1025b6:	6a 00                	push   $0x0
  pushl $242
  1025b8:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1025bd:	e9 08 f6 ff ff       	jmp    101bca <__alltraps>

001025c2 <vector243>:
.globl vector243
vector243:
  pushl $0
  1025c2:	6a 00                	push   $0x0
  pushl $243
  1025c4:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1025c9:	e9 fc f5 ff ff       	jmp    101bca <__alltraps>

001025ce <vector244>:
.globl vector244
vector244:
  pushl $0
  1025ce:	6a 00                	push   $0x0
  pushl $244
  1025d0:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1025d5:	e9 f0 f5 ff ff       	jmp    101bca <__alltraps>

001025da <vector245>:
.globl vector245
vector245:
  pushl $0
  1025da:	6a 00                	push   $0x0
  pushl $245
  1025dc:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1025e1:	e9 e4 f5 ff ff       	jmp    101bca <__alltraps>

001025e6 <vector246>:
.globl vector246
vector246:
  pushl $0
  1025e6:	6a 00                	push   $0x0
  pushl $246
  1025e8:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1025ed:	e9 d8 f5 ff ff       	jmp    101bca <__alltraps>

001025f2 <vector247>:
.globl vector247
vector247:
  pushl $0
  1025f2:	6a 00                	push   $0x0
  pushl $247
  1025f4:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1025f9:	e9 cc f5 ff ff       	jmp    101bca <__alltraps>

001025fe <vector248>:
.globl vector248
vector248:
  pushl $0
  1025fe:	6a 00                	push   $0x0
  pushl $248
  102600:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102605:	e9 c0 f5 ff ff       	jmp    101bca <__alltraps>

0010260a <vector249>:
.globl vector249
vector249:
  pushl $0
  10260a:	6a 00                	push   $0x0
  pushl $249
  10260c:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102611:	e9 b4 f5 ff ff       	jmp    101bca <__alltraps>

00102616 <vector250>:
.globl vector250
vector250:
  pushl $0
  102616:	6a 00                	push   $0x0
  pushl $250
  102618:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10261d:	e9 a8 f5 ff ff       	jmp    101bca <__alltraps>

00102622 <vector251>:
.globl vector251
vector251:
  pushl $0
  102622:	6a 00                	push   $0x0
  pushl $251
  102624:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102629:	e9 9c f5 ff ff       	jmp    101bca <__alltraps>

0010262e <vector252>:
.globl vector252
vector252:
  pushl $0
  10262e:	6a 00                	push   $0x0
  pushl $252
  102630:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102635:	e9 90 f5 ff ff       	jmp    101bca <__alltraps>

0010263a <vector253>:
.globl vector253
vector253:
  pushl $0
  10263a:	6a 00                	push   $0x0
  pushl $253
  10263c:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102641:	e9 84 f5 ff ff       	jmp    101bca <__alltraps>

00102646 <vector254>:
.globl vector254
vector254:
  pushl $0
  102646:	6a 00                	push   $0x0
  pushl $254
  102648:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10264d:	e9 78 f5 ff ff       	jmp    101bca <__alltraps>

00102652 <vector255>:
.globl vector255
vector255:
  pushl $0
  102652:	6a 00                	push   $0x0
  pushl $255
  102654:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102659:	e9 6c f5 ff ff       	jmp    101bca <__alltraps>

0010265e <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10265e:	55                   	push   %ebp
  10265f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102661:	8b 45 08             	mov    0x8(%ebp),%eax
  102664:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102667:	b8 23 00 00 00       	mov    $0x23,%eax
  10266c:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10266e:	b8 23 00 00 00       	mov    $0x23,%eax
  102673:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102675:	b8 10 00 00 00       	mov    $0x10,%eax
  10267a:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10267c:	b8 10 00 00 00       	mov    $0x10,%eax
  102681:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102683:	b8 10 00 00 00       	mov    $0x10,%eax
  102688:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  10268a:	ea 91 26 10 00 08 00 	ljmp   $0x8,$0x102691
}
  102691:	5d                   	pop    %ebp
  102692:	c3                   	ret    

00102693 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102693:	55                   	push   %ebp
  102694:	89 e5                	mov    %esp,%ebp
  102696:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102699:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  10269e:	05 00 04 00 00       	add    $0x400,%eax
  1026a3:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  1026a8:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1026af:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1026b1:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1026b8:	68 00 
  1026ba:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1026bf:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1026c5:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1026ca:	c1 e8 10             	shr    $0x10,%eax
  1026cd:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1026d2:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026d9:	83 e0 f0             	and    $0xfffffff0,%eax
  1026dc:	83 c8 09             	or     $0x9,%eax
  1026df:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1026e4:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026eb:	83 c8 10             	or     $0x10,%eax
  1026ee:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1026f3:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026fa:	83 e0 9f             	and    $0xffffff9f,%eax
  1026fd:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102702:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102709:	83 c8 80             	or     $0xffffff80,%eax
  10270c:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102711:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102718:	83 e0 f0             	and    $0xfffffff0,%eax
  10271b:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102720:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102727:	83 e0 ef             	and    $0xffffffef,%eax
  10272a:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10272f:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102736:	83 e0 df             	and    $0xffffffdf,%eax
  102739:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10273e:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102745:	83 c8 40             	or     $0x40,%eax
  102748:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10274d:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102754:	83 e0 7f             	and    $0x7f,%eax
  102757:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10275c:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102761:	c1 e8 18             	shr    $0x18,%eax
  102764:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102769:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102770:	83 e0 ef             	and    $0xffffffef,%eax
  102773:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102778:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  10277f:	e8 da fe ff ff       	call   10265e <lgdt>
  102784:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  10278a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  10278e:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102791:	c9                   	leave  
  102792:	c3                   	ret    

00102793 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102793:	55                   	push   %ebp
  102794:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102796:	e8 f8 fe ff ff       	call   102693 <gdt_init>
}
  10279b:	5d                   	pop    %ebp
  10279c:	c3                   	ret    

0010279d <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10279d:	55                   	push   %ebp
  10279e:	89 e5                	mov    %esp,%ebp
  1027a0:	83 ec 58             	sub    $0x58,%esp
  1027a3:	8b 45 10             	mov    0x10(%ebp),%eax
  1027a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1027a9:	8b 45 14             	mov    0x14(%ebp),%eax
  1027ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1027af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1027b2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1027b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1027b8:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1027bb:	8b 45 18             	mov    0x18(%ebp),%eax
  1027be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1027c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1027c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1027c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1027ca:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1027cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1027d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1027d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1027d7:	74 1c                	je     1027f5 <printnum+0x58>
  1027d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1027dc:	ba 00 00 00 00       	mov    $0x0,%edx
  1027e1:	f7 75 e4             	divl   -0x1c(%ebp)
  1027e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1027e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1027ea:	ba 00 00 00 00       	mov    $0x0,%edx
  1027ef:	f7 75 e4             	divl   -0x1c(%ebp)
  1027f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1027f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1027f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1027fb:	f7 75 e4             	divl   -0x1c(%ebp)
  1027fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102801:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102804:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102807:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10280a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10280d:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102810:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102813:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102816:	8b 45 18             	mov    0x18(%ebp),%eax
  102819:	ba 00 00 00 00       	mov    $0x0,%edx
  10281e:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102821:	77 56                	ja     102879 <printnum+0xdc>
  102823:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102826:	72 05                	jb     10282d <printnum+0x90>
  102828:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  10282b:	77 4c                	ja     102879 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  10282d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102830:	8d 50 ff             	lea    -0x1(%eax),%edx
  102833:	8b 45 20             	mov    0x20(%ebp),%eax
  102836:	89 44 24 18          	mov    %eax,0x18(%esp)
  10283a:	89 54 24 14          	mov    %edx,0x14(%esp)
  10283e:	8b 45 18             	mov    0x18(%ebp),%eax
  102841:	89 44 24 10          	mov    %eax,0x10(%esp)
  102845:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102848:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10284b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10284f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102853:	8b 45 0c             	mov    0xc(%ebp),%eax
  102856:	89 44 24 04          	mov    %eax,0x4(%esp)
  10285a:	8b 45 08             	mov    0x8(%ebp),%eax
  10285d:	89 04 24             	mov    %eax,(%esp)
  102860:	e8 38 ff ff ff       	call   10279d <printnum>
  102865:	eb 1c                	jmp    102883 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102867:	8b 45 0c             	mov    0xc(%ebp),%eax
  10286a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10286e:	8b 45 20             	mov    0x20(%ebp),%eax
  102871:	89 04 24             	mov    %eax,(%esp)
  102874:	8b 45 08             	mov    0x8(%ebp),%eax
  102877:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102879:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10287d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102881:	7f e4                	jg     102867 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102883:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102886:	05 70 3a 10 00       	add    $0x103a70,%eax
  10288b:	0f b6 00             	movzbl (%eax),%eax
  10288e:	0f be c0             	movsbl %al,%eax
  102891:	8b 55 0c             	mov    0xc(%ebp),%edx
  102894:	89 54 24 04          	mov    %edx,0x4(%esp)
  102898:	89 04 24             	mov    %eax,(%esp)
  10289b:	8b 45 08             	mov    0x8(%ebp),%eax
  10289e:	ff d0                	call   *%eax
}
  1028a0:	c9                   	leave  
  1028a1:	c3                   	ret    

001028a2 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1028a2:	55                   	push   %ebp
  1028a3:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1028a5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1028a9:	7e 14                	jle    1028bf <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1028ae:	8b 00                	mov    (%eax),%eax
  1028b0:	8d 48 08             	lea    0x8(%eax),%ecx
  1028b3:	8b 55 08             	mov    0x8(%ebp),%edx
  1028b6:	89 0a                	mov    %ecx,(%edx)
  1028b8:	8b 50 04             	mov    0x4(%eax),%edx
  1028bb:	8b 00                	mov    (%eax),%eax
  1028bd:	eb 30                	jmp    1028ef <getuint+0x4d>
    }
    else if (lflag) {
  1028bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1028c3:	74 16                	je     1028db <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1028c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1028c8:	8b 00                	mov    (%eax),%eax
  1028ca:	8d 48 04             	lea    0x4(%eax),%ecx
  1028cd:	8b 55 08             	mov    0x8(%ebp),%edx
  1028d0:	89 0a                	mov    %ecx,(%edx)
  1028d2:	8b 00                	mov    (%eax),%eax
  1028d4:	ba 00 00 00 00       	mov    $0x0,%edx
  1028d9:	eb 14                	jmp    1028ef <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1028db:	8b 45 08             	mov    0x8(%ebp),%eax
  1028de:	8b 00                	mov    (%eax),%eax
  1028e0:	8d 48 04             	lea    0x4(%eax),%ecx
  1028e3:	8b 55 08             	mov    0x8(%ebp),%edx
  1028e6:	89 0a                	mov    %ecx,(%edx)
  1028e8:	8b 00                	mov    (%eax),%eax
  1028ea:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1028ef:	5d                   	pop    %ebp
  1028f0:	c3                   	ret    

001028f1 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1028f1:	55                   	push   %ebp
  1028f2:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1028f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1028f8:	7e 14                	jle    10290e <getint+0x1d>
        return va_arg(*ap, long long);
  1028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1028fd:	8b 00                	mov    (%eax),%eax
  1028ff:	8d 48 08             	lea    0x8(%eax),%ecx
  102902:	8b 55 08             	mov    0x8(%ebp),%edx
  102905:	89 0a                	mov    %ecx,(%edx)
  102907:	8b 50 04             	mov    0x4(%eax),%edx
  10290a:	8b 00                	mov    (%eax),%eax
  10290c:	eb 28                	jmp    102936 <getint+0x45>
    }
    else if (lflag) {
  10290e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102912:	74 12                	je     102926 <getint+0x35>
        return va_arg(*ap, long);
  102914:	8b 45 08             	mov    0x8(%ebp),%eax
  102917:	8b 00                	mov    (%eax),%eax
  102919:	8d 48 04             	lea    0x4(%eax),%ecx
  10291c:	8b 55 08             	mov    0x8(%ebp),%edx
  10291f:	89 0a                	mov    %ecx,(%edx)
  102921:	8b 00                	mov    (%eax),%eax
  102923:	99                   	cltd   
  102924:	eb 10                	jmp    102936 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102926:	8b 45 08             	mov    0x8(%ebp),%eax
  102929:	8b 00                	mov    (%eax),%eax
  10292b:	8d 48 04             	lea    0x4(%eax),%ecx
  10292e:	8b 55 08             	mov    0x8(%ebp),%edx
  102931:	89 0a                	mov    %ecx,(%edx)
  102933:	8b 00                	mov    (%eax),%eax
  102935:	99                   	cltd   
    }
}
  102936:	5d                   	pop    %ebp
  102937:	c3                   	ret    

00102938 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102938:	55                   	push   %ebp
  102939:	89 e5                	mov    %esp,%ebp
  10293b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10293e:	8d 45 14             	lea    0x14(%ebp),%eax
  102941:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102947:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10294b:	8b 45 10             	mov    0x10(%ebp),%eax
  10294e:	89 44 24 08          	mov    %eax,0x8(%esp)
  102952:	8b 45 0c             	mov    0xc(%ebp),%eax
  102955:	89 44 24 04          	mov    %eax,0x4(%esp)
  102959:	8b 45 08             	mov    0x8(%ebp),%eax
  10295c:	89 04 24             	mov    %eax,(%esp)
  10295f:	e8 02 00 00 00       	call   102966 <vprintfmt>
    va_end(ap);
}
  102964:	c9                   	leave  
  102965:	c3                   	ret    

00102966 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102966:	55                   	push   %ebp
  102967:	89 e5                	mov    %esp,%ebp
  102969:	56                   	push   %esi
  10296a:	53                   	push   %ebx
  10296b:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10296e:	eb 18                	jmp    102988 <vprintfmt+0x22>
            if (ch == '\0') {
  102970:	85 db                	test   %ebx,%ebx
  102972:	75 05                	jne    102979 <vprintfmt+0x13>
                return;
  102974:	e9 d1 03 00 00       	jmp    102d4a <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102979:	8b 45 0c             	mov    0xc(%ebp),%eax
  10297c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102980:	89 1c 24             	mov    %ebx,(%esp)
  102983:	8b 45 08             	mov    0x8(%ebp),%eax
  102986:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102988:	8b 45 10             	mov    0x10(%ebp),%eax
  10298b:	8d 50 01             	lea    0x1(%eax),%edx
  10298e:	89 55 10             	mov    %edx,0x10(%ebp)
  102991:	0f b6 00             	movzbl (%eax),%eax
  102994:	0f b6 d8             	movzbl %al,%ebx
  102997:	83 fb 25             	cmp    $0x25,%ebx
  10299a:	75 d4                	jne    102970 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  10299c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1029a0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1029a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1029aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1029ad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1029b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029b7:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1029ba:	8b 45 10             	mov    0x10(%ebp),%eax
  1029bd:	8d 50 01             	lea    0x1(%eax),%edx
  1029c0:	89 55 10             	mov    %edx,0x10(%ebp)
  1029c3:	0f b6 00             	movzbl (%eax),%eax
  1029c6:	0f b6 d8             	movzbl %al,%ebx
  1029c9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1029cc:	83 f8 55             	cmp    $0x55,%eax
  1029cf:	0f 87 44 03 00 00    	ja     102d19 <vprintfmt+0x3b3>
  1029d5:	8b 04 85 94 3a 10 00 	mov    0x103a94(,%eax,4),%eax
  1029dc:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1029de:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1029e2:	eb d6                	jmp    1029ba <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1029e4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1029e8:	eb d0                	jmp    1029ba <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1029ea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1029f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1029f4:	89 d0                	mov    %edx,%eax
  1029f6:	c1 e0 02             	shl    $0x2,%eax
  1029f9:	01 d0                	add    %edx,%eax
  1029fb:	01 c0                	add    %eax,%eax
  1029fd:	01 d8                	add    %ebx,%eax
  1029ff:	83 e8 30             	sub    $0x30,%eax
  102a02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102a05:	8b 45 10             	mov    0x10(%ebp),%eax
  102a08:	0f b6 00             	movzbl (%eax),%eax
  102a0b:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102a0e:	83 fb 2f             	cmp    $0x2f,%ebx
  102a11:	7e 0b                	jle    102a1e <vprintfmt+0xb8>
  102a13:	83 fb 39             	cmp    $0x39,%ebx
  102a16:	7f 06                	jg     102a1e <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102a18:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102a1c:	eb d3                	jmp    1029f1 <vprintfmt+0x8b>
            goto process_precision;
  102a1e:	eb 33                	jmp    102a53 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102a20:	8b 45 14             	mov    0x14(%ebp),%eax
  102a23:	8d 50 04             	lea    0x4(%eax),%edx
  102a26:	89 55 14             	mov    %edx,0x14(%ebp)
  102a29:	8b 00                	mov    (%eax),%eax
  102a2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102a2e:	eb 23                	jmp    102a53 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102a30:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102a34:	79 0c                	jns    102a42 <vprintfmt+0xdc>
                width = 0;
  102a36:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102a3d:	e9 78 ff ff ff       	jmp    1029ba <vprintfmt+0x54>
  102a42:	e9 73 ff ff ff       	jmp    1029ba <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102a47:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102a4e:	e9 67 ff ff ff       	jmp    1029ba <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102a53:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102a57:	79 12                	jns    102a6b <vprintfmt+0x105>
                width = precision, precision = -1;
  102a59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102a5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102a5f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102a66:	e9 4f ff ff ff       	jmp    1029ba <vprintfmt+0x54>
  102a6b:	e9 4a ff ff ff       	jmp    1029ba <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102a70:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102a74:	e9 41 ff ff ff       	jmp    1029ba <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102a79:	8b 45 14             	mov    0x14(%ebp),%eax
  102a7c:	8d 50 04             	lea    0x4(%eax),%edx
  102a7f:	89 55 14             	mov    %edx,0x14(%ebp)
  102a82:	8b 00                	mov    (%eax),%eax
  102a84:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a87:	89 54 24 04          	mov    %edx,0x4(%esp)
  102a8b:	89 04 24             	mov    %eax,(%esp)
  102a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a91:	ff d0                	call   *%eax
            break;
  102a93:	e9 ac 02 00 00       	jmp    102d44 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102a98:	8b 45 14             	mov    0x14(%ebp),%eax
  102a9b:	8d 50 04             	lea    0x4(%eax),%edx
  102a9e:	89 55 14             	mov    %edx,0x14(%ebp)
  102aa1:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102aa3:	85 db                	test   %ebx,%ebx
  102aa5:	79 02                	jns    102aa9 <vprintfmt+0x143>
                err = -err;
  102aa7:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102aa9:	83 fb 06             	cmp    $0x6,%ebx
  102aac:	7f 0b                	jg     102ab9 <vprintfmt+0x153>
  102aae:	8b 34 9d 54 3a 10 00 	mov    0x103a54(,%ebx,4),%esi
  102ab5:	85 f6                	test   %esi,%esi
  102ab7:	75 23                	jne    102adc <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102ab9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102abd:	c7 44 24 08 81 3a 10 	movl   $0x103a81,0x8(%esp)
  102ac4:	00 
  102ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ac8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102acc:	8b 45 08             	mov    0x8(%ebp),%eax
  102acf:	89 04 24             	mov    %eax,(%esp)
  102ad2:	e8 61 fe ff ff       	call   102938 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102ad7:	e9 68 02 00 00       	jmp    102d44 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102adc:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102ae0:	c7 44 24 08 8a 3a 10 	movl   $0x103a8a,0x8(%esp)
  102ae7:	00 
  102ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102aef:	8b 45 08             	mov    0x8(%ebp),%eax
  102af2:	89 04 24             	mov    %eax,(%esp)
  102af5:	e8 3e fe ff ff       	call   102938 <printfmt>
            }
            break;
  102afa:	e9 45 02 00 00       	jmp    102d44 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102aff:	8b 45 14             	mov    0x14(%ebp),%eax
  102b02:	8d 50 04             	lea    0x4(%eax),%edx
  102b05:	89 55 14             	mov    %edx,0x14(%ebp)
  102b08:	8b 30                	mov    (%eax),%esi
  102b0a:	85 f6                	test   %esi,%esi
  102b0c:	75 05                	jne    102b13 <vprintfmt+0x1ad>
                p = "(null)";
  102b0e:	be 8d 3a 10 00       	mov    $0x103a8d,%esi
            }
            if (width > 0 && padc != '-') {
  102b13:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102b17:	7e 3e                	jle    102b57 <vprintfmt+0x1f1>
  102b19:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102b1d:	74 38                	je     102b57 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102b1f:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b25:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b29:	89 34 24             	mov    %esi,(%esp)
  102b2c:	e8 15 03 00 00       	call   102e46 <strnlen>
  102b31:	29 c3                	sub    %eax,%ebx
  102b33:	89 d8                	mov    %ebx,%eax
  102b35:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b38:	eb 17                	jmp    102b51 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102b3a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b41:	89 54 24 04          	mov    %edx,0x4(%esp)
  102b45:	89 04 24             	mov    %eax,(%esp)
  102b48:	8b 45 08             	mov    0x8(%ebp),%eax
  102b4b:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102b4d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102b51:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102b55:	7f e3                	jg     102b3a <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102b57:	eb 38                	jmp    102b91 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102b59:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102b5d:	74 1f                	je     102b7e <vprintfmt+0x218>
  102b5f:	83 fb 1f             	cmp    $0x1f,%ebx
  102b62:	7e 05                	jle    102b69 <vprintfmt+0x203>
  102b64:	83 fb 7e             	cmp    $0x7e,%ebx
  102b67:	7e 15                	jle    102b7e <vprintfmt+0x218>
                    putch('?', putdat);
  102b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b70:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102b77:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7a:	ff d0                	call   *%eax
  102b7c:	eb 0f                	jmp    102b8d <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b81:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b85:	89 1c 24             	mov    %ebx,(%esp)
  102b88:	8b 45 08             	mov    0x8(%ebp),%eax
  102b8b:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102b8d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102b91:	89 f0                	mov    %esi,%eax
  102b93:	8d 70 01             	lea    0x1(%eax),%esi
  102b96:	0f b6 00             	movzbl (%eax),%eax
  102b99:	0f be d8             	movsbl %al,%ebx
  102b9c:	85 db                	test   %ebx,%ebx
  102b9e:	74 10                	je     102bb0 <vprintfmt+0x24a>
  102ba0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102ba4:	78 b3                	js     102b59 <vprintfmt+0x1f3>
  102ba6:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102baa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102bae:	79 a9                	jns    102b59 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102bb0:	eb 17                	jmp    102bc9 <vprintfmt+0x263>
                putch(' ', putdat);
  102bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bb5:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bb9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc3:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102bc5:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102bc9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102bcd:	7f e3                	jg     102bb2 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102bcf:	e9 70 01 00 00       	jmp    102d44 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102bd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bdb:	8d 45 14             	lea    0x14(%ebp),%eax
  102bde:	89 04 24             	mov    %eax,(%esp)
  102be1:	e8 0b fd ff ff       	call   1028f1 <getint>
  102be6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102be9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102bf2:	85 d2                	test   %edx,%edx
  102bf4:	79 26                	jns    102c1c <vprintfmt+0x2b6>
                putch('-', putdat);
  102bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bfd:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102c04:	8b 45 08             	mov    0x8(%ebp),%eax
  102c07:	ff d0                	call   *%eax
                num = -(long long)num;
  102c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102c0f:	f7 d8                	neg    %eax
  102c11:	83 d2 00             	adc    $0x0,%edx
  102c14:	f7 da                	neg    %edx
  102c16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c19:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102c1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102c23:	e9 a8 00 00 00       	jmp    102cd0 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102c28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c2f:	8d 45 14             	lea    0x14(%ebp),%eax
  102c32:	89 04 24             	mov    %eax,(%esp)
  102c35:	e8 68 fc ff ff       	call   1028a2 <getuint>
  102c3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102c40:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102c47:	e9 84 00 00 00       	jmp    102cd0 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102c4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c53:	8d 45 14             	lea    0x14(%ebp),%eax
  102c56:	89 04 24             	mov    %eax,(%esp)
  102c59:	e8 44 fc ff ff       	call   1028a2 <getuint>
  102c5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c61:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102c64:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102c6b:	eb 63                	jmp    102cd0 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c70:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c74:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c7e:	ff d0                	call   *%eax
            putch('x', putdat);
  102c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c83:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c87:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c91:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102c93:	8b 45 14             	mov    0x14(%ebp),%eax
  102c96:	8d 50 04             	lea    0x4(%eax),%edx
  102c99:	89 55 14             	mov    %edx,0x14(%ebp)
  102c9c:	8b 00                	mov    (%eax),%eax
  102c9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ca1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102ca8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102caf:	eb 1f                	jmp    102cd0 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102cb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cb8:	8d 45 14             	lea    0x14(%ebp),%eax
  102cbb:	89 04 24             	mov    %eax,(%esp)
  102cbe:	e8 df fb ff ff       	call   1028a2 <getuint>
  102cc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102cc9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102cd0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102cd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102cd7:	89 54 24 18          	mov    %edx,0x18(%esp)
  102cdb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102cde:	89 54 24 14          	mov    %edx,0x14(%esp)
  102ce2:	89 44 24 10          	mov    %eax,0x10(%esp)
  102ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ce9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102cec:	89 44 24 08          	mov    %eax,0x8(%esp)
  102cf0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102cf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  102cfe:	89 04 24             	mov    %eax,(%esp)
  102d01:	e8 97 fa ff ff       	call   10279d <printnum>
            break;
  102d06:	eb 3c                	jmp    102d44 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d0f:	89 1c 24             	mov    %ebx,(%esp)
  102d12:	8b 45 08             	mov    0x8(%ebp),%eax
  102d15:	ff d0                	call   *%eax
            break;
  102d17:	eb 2b                	jmp    102d44 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d20:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102d27:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2a:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102d2c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102d30:	eb 04                	jmp    102d36 <vprintfmt+0x3d0>
  102d32:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102d36:	8b 45 10             	mov    0x10(%ebp),%eax
  102d39:	83 e8 01             	sub    $0x1,%eax
  102d3c:	0f b6 00             	movzbl (%eax),%eax
  102d3f:	3c 25                	cmp    $0x25,%al
  102d41:	75 ef                	jne    102d32 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  102d43:	90                   	nop
        }
    }
  102d44:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102d45:	e9 3e fc ff ff       	jmp    102988 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  102d4a:	83 c4 40             	add    $0x40,%esp
  102d4d:	5b                   	pop    %ebx
  102d4e:	5e                   	pop    %esi
  102d4f:	5d                   	pop    %ebp
  102d50:	c3                   	ret    

00102d51 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102d51:	55                   	push   %ebp
  102d52:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d57:	8b 40 08             	mov    0x8(%eax),%eax
  102d5a:	8d 50 01             	lea    0x1(%eax),%edx
  102d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d60:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d66:	8b 10                	mov    (%eax),%edx
  102d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d6b:	8b 40 04             	mov    0x4(%eax),%eax
  102d6e:	39 c2                	cmp    %eax,%edx
  102d70:	73 12                	jae    102d84 <sprintputch+0x33>
        *b->buf ++ = ch;
  102d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d75:	8b 00                	mov    (%eax),%eax
  102d77:	8d 48 01             	lea    0x1(%eax),%ecx
  102d7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d7d:	89 0a                	mov    %ecx,(%edx)
  102d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  102d82:	88 10                	mov    %dl,(%eax)
    }
}
  102d84:	5d                   	pop    %ebp
  102d85:	c3                   	ret    

00102d86 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102d86:	55                   	push   %ebp
  102d87:	89 e5                	mov    %esp,%ebp
  102d89:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102d8c:	8d 45 14             	lea    0x14(%ebp),%eax
  102d8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d95:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102d99:	8b 45 10             	mov    0x10(%ebp),%eax
  102d9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  102da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102da3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102da7:	8b 45 08             	mov    0x8(%ebp),%eax
  102daa:	89 04 24             	mov    %eax,(%esp)
  102dad:	e8 08 00 00 00       	call   102dba <vsnprintf>
  102db2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102db8:	c9                   	leave  
  102db9:	c3                   	ret    

00102dba <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102dba:	55                   	push   %ebp
  102dbb:	89 e5                	mov    %esp,%ebp
  102dbd:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dc9:	8d 50 ff             	lea    -0x1(%eax),%edx
  102dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  102dcf:	01 d0                	add    %edx,%eax
  102dd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dd4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102ddb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102ddf:	74 0a                	je     102deb <vsnprintf+0x31>
  102de1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102de7:	39 c2                	cmp    %eax,%edx
  102de9:	76 07                	jbe    102df2 <vsnprintf+0x38>
        return -E_INVAL;
  102deb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102df0:	eb 2a                	jmp    102e1c <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102df2:	8b 45 14             	mov    0x14(%ebp),%eax
  102df5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102df9:	8b 45 10             	mov    0x10(%ebp),%eax
  102dfc:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e00:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102e03:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e07:	c7 04 24 51 2d 10 00 	movl   $0x102d51,(%esp)
  102e0e:	e8 53 fb ff ff       	call   102966 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  102e13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e16:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102e1c:	c9                   	leave  
  102e1d:	c3                   	ret    

00102e1e <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102e1e:	55                   	push   %ebp
  102e1f:	89 e5                	mov    %esp,%ebp
  102e21:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102e24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102e2b:	eb 04                	jmp    102e31 <strlen+0x13>
        cnt ++;
  102e2d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102e31:	8b 45 08             	mov    0x8(%ebp),%eax
  102e34:	8d 50 01             	lea    0x1(%eax),%edx
  102e37:	89 55 08             	mov    %edx,0x8(%ebp)
  102e3a:	0f b6 00             	movzbl (%eax),%eax
  102e3d:	84 c0                	test   %al,%al
  102e3f:	75 ec                	jne    102e2d <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102e41:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102e44:	c9                   	leave  
  102e45:	c3                   	ret    

00102e46 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102e46:	55                   	push   %ebp
  102e47:	89 e5                	mov    %esp,%ebp
  102e49:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102e4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102e53:	eb 04                	jmp    102e59 <strnlen+0x13>
        cnt ++;
  102e55:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102e59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e5c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102e5f:	73 10                	jae    102e71 <strnlen+0x2b>
  102e61:	8b 45 08             	mov    0x8(%ebp),%eax
  102e64:	8d 50 01             	lea    0x1(%eax),%edx
  102e67:	89 55 08             	mov    %edx,0x8(%ebp)
  102e6a:	0f b6 00             	movzbl (%eax),%eax
  102e6d:	84 c0                	test   %al,%al
  102e6f:	75 e4                	jne    102e55 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102e71:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102e74:	c9                   	leave  
  102e75:	c3                   	ret    

00102e76 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102e76:	55                   	push   %ebp
  102e77:	89 e5                	mov    %esp,%ebp
  102e79:	57                   	push   %edi
  102e7a:	56                   	push   %esi
  102e7b:	83 ec 20             	sub    $0x20,%esp
  102e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e87:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102e8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e90:	89 d1                	mov    %edx,%ecx
  102e92:	89 c2                	mov    %eax,%edx
  102e94:	89 ce                	mov    %ecx,%esi
  102e96:	89 d7                	mov    %edx,%edi
  102e98:	ac                   	lods   %ds:(%esi),%al
  102e99:	aa                   	stos   %al,%es:(%edi)
  102e9a:	84 c0                	test   %al,%al
  102e9c:	75 fa                	jne    102e98 <strcpy+0x22>
  102e9e:	89 fa                	mov    %edi,%edx
  102ea0:	89 f1                	mov    %esi,%ecx
  102ea2:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102ea5:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102ea8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102eae:	83 c4 20             	add    $0x20,%esp
  102eb1:	5e                   	pop    %esi
  102eb2:	5f                   	pop    %edi
  102eb3:	5d                   	pop    %ebp
  102eb4:	c3                   	ret    

00102eb5 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102eb5:	55                   	push   %ebp
  102eb6:	89 e5                	mov    %esp,%ebp
  102eb8:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  102ebe:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102ec1:	eb 21                	jmp    102ee4 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ec6:	0f b6 10             	movzbl (%eax),%edx
  102ec9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ecc:	88 10                	mov    %dl,(%eax)
  102ece:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ed1:	0f b6 00             	movzbl (%eax),%eax
  102ed4:	84 c0                	test   %al,%al
  102ed6:	74 04                	je     102edc <strncpy+0x27>
            src ++;
  102ed8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102edc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102ee0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  102ee4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ee8:	75 d9                	jne    102ec3 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  102eea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102eed:	c9                   	leave  
  102eee:	c3                   	ret    

00102eef <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102eef:	55                   	push   %ebp
  102ef0:	89 e5                	mov    %esp,%ebp
  102ef2:	57                   	push   %edi
  102ef3:	56                   	push   %esi
  102ef4:	83 ec 20             	sub    $0x20,%esp
  102ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  102efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f00:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  102f03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f09:	89 d1                	mov    %edx,%ecx
  102f0b:	89 c2                	mov    %eax,%edx
  102f0d:	89 ce                	mov    %ecx,%esi
  102f0f:	89 d7                	mov    %edx,%edi
  102f11:	ac                   	lods   %ds:(%esi),%al
  102f12:	ae                   	scas   %es:(%edi),%al
  102f13:	75 08                	jne    102f1d <strcmp+0x2e>
  102f15:	84 c0                	test   %al,%al
  102f17:	75 f8                	jne    102f11 <strcmp+0x22>
  102f19:	31 c0                	xor    %eax,%eax
  102f1b:	eb 04                	jmp    102f21 <strcmp+0x32>
  102f1d:	19 c0                	sbb    %eax,%eax
  102f1f:	0c 01                	or     $0x1,%al
  102f21:	89 fa                	mov    %edi,%edx
  102f23:	89 f1                	mov    %esi,%ecx
  102f25:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f28:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102f2b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  102f2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102f31:	83 c4 20             	add    $0x20,%esp
  102f34:	5e                   	pop    %esi
  102f35:	5f                   	pop    %edi
  102f36:	5d                   	pop    %ebp
  102f37:	c3                   	ret    

00102f38 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102f38:	55                   	push   %ebp
  102f39:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102f3b:	eb 0c                	jmp    102f49 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102f3d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102f41:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102f45:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102f49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f4d:	74 1a                	je     102f69 <strncmp+0x31>
  102f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  102f52:	0f b6 00             	movzbl (%eax),%eax
  102f55:	84 c0                	test   %al,%al
  102f57:	74 10                	je     102f69 <strncmp+0x31>
  102f59:	8b 45 08             	mov    0x8(%ebp),%eax
  102f5c:	0f b6 10             	movzbl (%eax),%edx
  102f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f62:	0f b6 00             	movzbl (%eax),%eax
  102f65:	38 c2                	cmp    %al,%dl
  102f67:	74 d4                	je     102f3d <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102f69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f6d:	74 18                	je     102f87 <strncmp+0x4f>
  102f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  102f72:	0f b6 00             	movzbl (%eax),%eax
  102f75:	0f b6 d0             	movzbl %al,%edx
  102f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f7b:	0f b6 00             	movzbl (%eax),%eax
  102f7e:	0f b6 c0             	movzbl %al,%eax
  102f81:	29 c2                	sub    %eax,%edx
  102f83:	89 d0                	mov    %edx,%eax
  102f85:	eb 05                	jmp    102f8c <strncmp+0x54>
  102f87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102f8c:	5d                   	pop    %ebp
  102f8d:	c3                   	ret    

00102f8e <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102f8e:	55                   	push   %ebp
  102f8f:	89 e5                	mov    %esp,%ebp
  102f91:	83 ec 04             	sub    $0x4,%esp
  102f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f97:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102f9a:	eb 14                	jmp    102fb0 <strchr+0x22>
        if (*s == c) {
  102f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f9f:	0f b6 00             	movzbl (%eax),%eax
  102fa2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102fa5:	75 05                	jne    102fac <strchr+0x1e>
            return (char *)s;
  102fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  102faa:	eb 13                	jmp    102fbf <strchr+0x31>
        }
        s ++;
  102fac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  102fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb3:	0f b6 00             	movzbl (%eax),%eax
  102fb6:	84 c0                	test   %al,%al
  102fb8:	75 e2                	jne    102f9c <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  102fba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102fbf:	c9                   	leave  
  102fc0:	c3                   	ret    

00102fc1 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102fc1:	55                   	push   %ebp
  102fc2:	89 e5                	mov    %esp,%ebp
  102fc4:	83 ec 04             	sub    $0x4,%esp
  102fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fca:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102fcd:	eb 11                	jmp    102fe0 <strfind+0x1f>
        if (*s == c) {
  102fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  102fd2:	0f b6 00             	movzbl (%eax),%eax
  102fd5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102fd8:	75 02                	jne    102fdc <strfind+0x1b>
            break;
  102fda:	eb 0e                	jmp    102fea <strfind+0x29>
        }
        s ++;
  102fdc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  102fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe3:	0f b6 00             	movzbl (%eax),%eax
  102fe6:	84 c0                	test   %al,%al
  102fe8:	75 e5                	jne    102fcf <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  102fea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102fed:	c9                   	leave  
  102fee:	c3                   	ret    

00102fef <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102fef:	55                   	push   %ebp
  102ff0:	89 e5                	mov    %esp,%ebp
  102ff2:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102ff5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102ffc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103003:	eb 04                	jmp    103009 <strtol+0x1a>
        s ++;
  103005:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103009:	8b 45 08             	mov    0x8(%ebp),%eax
  10300c:	0f b6 00             	movzbl (%eax),%eax
  10300f:	3c 20                	cmp    $0x20,%al
  103011:	74 f2                	je     103005 <strtol+0x16>
  103013:	8b 45 08             	mov    0x8(%ebp),%eax
  103016:	0f b6 00             	movzbl (%eax),%eax
  103019:	3c 09                	cmp    $0x9,%al
  10301b:	74 e8                	je     103005 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  10301d:	8b 45 08             	mov    0x8(%ebp),%eax
  103020:	0f b6 00             	movzbl (%eax),%eax
  103023:	3c 2b                	cmp    $0x2b,%al
  103025:	75 06                	jne    10302d <strtol+0x3e>
        s ++;
  103027:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10302b:	eb 15                	jmp    103042 <strtol+0x53>
    }
    else if (*s == '-') {
  10302d:	8b 45 08             	mov    0x8(%ebp),%eax
  103030:	0f b6 00             	movzbl (%eax),%eax
  103033:	3c 2d                	cmp    $0x2d,%al
  103035:	75 0b                	jne    103042 <strtol+0x53>
        s ++, neg = 1;
  103037:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10303b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103042:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103046:	74 06                	je     10304e <strtol+0x5f>
  103048:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  10304c:	75 24                	jne    103072 <strtol+0x83>
  10304e:	8b 45 08             	mov    0x8(%ebp),%eax
  103051:	0f b6 00             	movzbl (%eax),%eax
  103054:	3c 30                	cmp    $0x30,%al
  103056:	75 1a                	jne    103072 <strtol+0x83>
  103058:	8b 45 08             	mov    0x8(%ebp),%eax
  10305b:	83 c0 01             	add    $0x1,%eax
  10305e:	0f b6 00             	movzbl (%eax),%eax
  103061:	3c 78                	cmp    $0x78,%al
  103063:	75 0d                	jne    103072 <strtol+0x83>
        s += 2, base = 16;
  103065:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103069:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  103070:	eb 2a                	jmp    10309c <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  103072:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103076:	75 17                	jne    10308f <strtol+0xa0>
  103078:	8b 45 08             	mov    0x8(%ebp),%eax
  10307b:	0f b6 00             	movzbl (%eax),%eax
  10307e:	3c 30                	cmp    $0x30,%al
  103080:	75 0d                	jne    10308f <strtol+0xa0>
        s ++, base = 8;
  103082:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103086:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  10308d:	eb 0d                	jmp    10309c <strtol+0xad>
    }
    else if (base == 0) {
  10308f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103093:	75 07                	jne    10309c <strtol+0xad>
        base = 10;
  103095:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10309c:	8b 45 08             	mov    0x8(%ebp),%eax
  10309f:	0f b6 00             	movzbl (%eax),%eax
  1030a2:	3c 2f                	cmp    $0x2f,%al
  1030a4:	7e 1b                	jle    1030c1 <strtol+0xd2>
  1030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1030a9:	0f b6 00             	movzbl (%eax),%eax
  1030ac:	3c 39                	cmp    $0x39,%al
  1030ae:	7f 11                	jg     1030c1 <strtol+0xd2>
            dig = *s - '0';
  1030b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b3:	0f b6 00             	movzbl (%eax),%eax
  1030b6:	0f be c0             	movsbl %al,%eax
  1030b9:	83 e8 30             	sub    $0x30,%eax
  1030bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030bf:	eb 48                	jmp    103109 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c4:	0f b6 00             	movzbl (%eax),%eax
  1030c7:	3c 60                	cmp    $0x60,%al
  1030c9:	7e 1b                	jle    1030e6 <strtol+0xf7>
  1030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ce:	0f b6 00             	movzbl (%eax),%eax
  1030d1:	3c 7a                	cmp    $0x7a,%al
  1030d3:	7f 11                	jg     1030e6 <strtol+0xf7>
            dig = *s - 'a' + 10;
  1030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1030d8:	0f b6 00             	movzbl (%eax),%eax
  1030db:	0f be c0             	movsbl %al,%eax
  1030de:	83 e8 57             	sub    $0x57,%eax
  1030e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030e4:	eb 23                	jmp    103109 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1030e9:	0f b6 00             	movzbl (%eax),%eax
  1030ec:	3c 40                	cmp    $0x40,%al
  1030ee:	7e 3d                	jle    10312d <strtol+0x13e>
  1030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f3:	0f b6 00             	movzbl (%eax),%eax
  1030f6:	3c 5a                	cmp    $0x5a,%al
  1030f8:	7f 33                	jg     10312d <strtol+0x13e>
            dig = *s - 'A' + 10;
  1030fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1030fd:	0f b6 00             	movzbl (%eax),%eax
  103100:	0f be c0             	movsbl %al,%eax
  103103:	83 e8 37             	sub    $0x37,%eax
  103106:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  103109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10310c:	3b 45 10             	cmp    0x10(%ebp),%eax
  10310f:	7c 02                	jl     103113 <strtol+0x124>
            break;
  103111:	eb 1a                	jmp    10312d <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  103113:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10311a:	0f af 45 10          	imul   0x10(%ebp),%eax
  10311e:	89 c2                	mov    %eax,%edx
  103120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103123:	01 d0                	add    %edx,%eax
  103125:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  103128:	e9 6f ff ff ff       	jmp    10309c <strtol+0xad>

    if (endptr) {
  10312d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103131:	74 08                	je     10313b <strtol+0x14c>
        *endptr = (char *) s;
  103133:	8b 45 0c             	mov    0xc(%ebp),%eax
  103136:	8b 55 08             	mov    0x8(%ebp),%edx
  103139:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  10313b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10313f:	74 07                	je     103148 <strtol+0x159>
  103141:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103144:	f7 d8                	neg    %eax
  103146:	eb 03                	jmp    10314b <strtol+0x15c>
  103148:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10314b:	c9                   	leave  
  10314c:	c3                   	ret    

0010314d <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  10314d:	55                   	push   %ebp
  10314e:	89 e5                	mov    %esp,%ebp
  103150:	57                   	push   %edi
  103151:	83 ec 24             	sub    $0x24,%esp
  103154:	8b 45 0c             	mov    0xc(%ebp),%eax
  103157:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10315a:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  10315e:	8b 55 08             	mov    0x8(%ebp),%edx
  103161:	89 55 f8             	mov    %edx,-0x8(%ebp)
  103164:	88 45 f7             	mov    %al,-0x9(%ebp)
  103167:	8b 45 10             	mov    0x10(%ebp),%eax
  10316a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10316d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  103170:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103174:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103177:	89 d7                	mov    %edx,%edi
  103179:	f3 aa                	rep stos %al,%es:(%edi)
  10317b:	89 fa                	mov    %edi,%edx
  10317d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103180:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103183:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103186:	83 c4 24             	add    $0x24,%esp
  103189:	5f                   	pop    %edi
  10318a:	5d                   	pop    %ebp
  10318b:	c3                   	ret    

0010318c <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  10318c:	55                   	push   %ebp
  10318d:	89 e5                	mov    %esp,%ebp
  10318f:	57                   	push   %edi
  103190:	56                   	push   %esi
  103191:	53                   	push   %ebx
  103192:	83 ec 30             	sub    $0x30,%esp
  103195:	8b 45 08             	mov    0x8(%ebp),%eax
  103198:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10319b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10319e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031a1:	8b 45 10             	mov    0x10(%ebp),%eax
  1031a4:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1031a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1031ad:	73 42                	jae    1031f1 <memmove+0x65>
  1031af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1031b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1031bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031be:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1031c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1031c4:	c1 e8 02             	shr    $0x2,%eax
  1031c7:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1031c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1031cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031cf:	89 d7                	mov    %edx,%edi
  1031d1:	89 c6                	mov    %eax,%esi
  1031d3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1031d5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1031d8:	83 e1 03             	and    $0x3,%ecx
  1031db:	74 02                	je     1031df <memmove+0x53>
  1031dd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1031df:	89 f0                	mov    %esi,%eax
  1031e1:	89 fa                	mov    %edi,%edx
  1031e3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1031e6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1031e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  1031ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031ef:	eb 36                	jmp    103227 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1031f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  1031f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031fa:	01 c2                	add    %eax,%edx
  1031fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031ff:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103205:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  103208:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10320b:	89 c1                	mov    %eax,%ecx
  10320d:	89 d8                	mov    %ebx,%eax
  10320f:	89 d6                	mov    %edx,%esi
  103211:	89 c7                	mov    %eax,%edi
  103213:	fd                   	std    
  103214:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103216:	fc                   	cld    
  103217:	89 f8                	mov    %edi,%eax
  103219:	89 f2                	mov    %esi,%edx
  10321b:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  10321e:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103221:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  103224:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  103227:	83 c4 30             	add    $0x30,%esp
  10322a:	5b                   	pop    %ebx
  10322b:	5e                   	pop    %esi
  10322c:	5f                   	pop    %edi
  10322d:	5d                   	pop    %ebp
  10322e:	c3                   	ret    

0010322f <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10322f:	55                   	push   %ebp
  103230:	89 e5                	mov    %esp,%ebp
  103232:	57                   	push   %edi
  103233:	56                   	push   %esi
  103234:	83 ec 20             	sub    $0x20,%esp
  103237:	8b 45 08             	mov    0x8(%ebp),%eax
  10323a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10323d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103240:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103243:	8b 45 10             	mov    0x10(%ebp),%eax
  103246:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103249:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10324c:	c1 e8 02             	shr    $0x2,%eax
  10324f:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103251:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103257:	89 d7                	mov    %edx,%edi
  103259:	89 c6                	mov    %eax,%esi
  10325b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10325d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103260:	83 e1 03             	and    $0x3,%ecx
  103263:	74 02                	je     103267 <memcpy+0x38>
  103265:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103267:	89 f0                	mov    %esi,%eax
  103269:	89 fa                	mov    %edi,%edx
  10326b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10326e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103271:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103274:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103277:	83 c4 20             	add    $0x20,%esp
  10327a:	5e                   	pop    %esi
  10327b:	5f                   	pop    %edi
  10327c:	5d                   	pop    %ebp
  10327d:	c3                   	ret    

0010327e <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10327e:	55                   	push   %ebp
  10327f:	89 e5                	mov    %esp,%ebp
  103281:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103284:	8b 45 08             	mov    0x8(%ebp),%eax
  103287:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10328a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10328d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103290:	eb 30                	jmp    1032c2 <memcmp+0x44>
        if (*s1 != *s2) {
  103292:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103295:	0f b6 10             	movzbl (%eax),%edx
  103298:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10329b:	0f b6 00             	movzbl (%eax),%eax
  10329e:	38 c2                	cmp    %al,%dl
  1032a0:	74 18                	je     1032ba <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1032a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1032a5:	0f b6 00             	movzbl (%eax),%eax
  1032a8:	0f b6 d0             	movzbl %al,%edx
  1032ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032ae:	0f b6 00             	movzbl (%eax),%eax
  1032b1:	0f b6 c0             	movzbl %al,%eax
  1032b4:	29 c2                	sub    %eax,%edx
  1032b6:	89 d0                	mov    %edx,%eax
  1032b8:	eb 1a                	jmp    1032d4 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  1032ba:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1032be:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  1032c2:	8b 45 10             	mov    0x10(%ebp),%eax
  1032c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  1032c8:	89 55 10             	mov    %edx,0x10(%ebp)
  1032cb:	85 c0                	test   %eax,%eax
  1032cd:	75 c3                	jne    103292 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1032cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1032d4:	c9                   	leave  
  1032d5:	c3                   	ret    
