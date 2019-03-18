
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
  100027:	e8 67 30 00 00       	call   103093 <memset>

    cons_init();                // init the console
  10002c:	e8 8b 14 00 00       	call   1014bc <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 20 32 10 00 	movl   $0x103220,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 3c 32 10 00 	movl   $0x10323c,(%esp)
  100046:	e8 c7 02 00 00       	call   100312 <cprintf>

    print_kerninfo();
  10004b:	e8 f6 07 00 00       	call   100846 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 7f 26 00 00       	call   1026d9 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 a0 15 00 00       	call   1015ff <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 f2 16 00 00       	call   101756 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 46 0c 00 00       	call   100caf <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 ff 14 00 00       	call   10156d <intr_enable>
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
  10008d:	e8 3e 0b 00 00       	call   100bd0 <mon_backtrace>
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
  10012b:	c7 04 24 41 32 10 00 	movl   $0x103241,(%esp)
  100132:	e8 db 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 4f 32 10 00 	movl   $0x10324f,(%esp)
  100152:	e8 bb 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 5d 32 10 00 	movl   $0x10325d,(%esp)
  100172:	e8 9b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 6b 32 10 00 	movl   $0x10326b,(%esp)
  100192:	e8 7b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 79 32 10 00 	movl   $0x103279,(%esp)
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
  1001db:	c7 04 24 88 32 10 00 	movl   $0x103288,(%esp)
  1001e2:	e8 2b 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 a8 32 10 00 	movl   $0x1032a8,(%esp)
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
  10021c:	c7 04 24 c7 32 10 00 	movl   $0x1032c7,(%esp)
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
  1002cb:	e8 18 12 00 00       	call   1014e8 <cons_putc>
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
  100308:	e8 9f 25 00 00       	call   1028ac <vprintfmt>
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
  100344:	e8 9f 11 00 00       	call   1014e8 <cons_putc>
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
  1003a0:	e8 6c 11 00 00       	call   101511 <cons_getc>
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
  100512:	c7 00 cc 32 10 00    	movl   $0x1032cc,(%eax)
    info->eip_line = 0;
  100518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100522:	8b 45 0c             	mov    0xc(%ebp),%eax
  100525:	c7 40 08 cc 32 10 00 	movl   $0x1032cc,0x8(%eax)
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
  100549:	c7 45 f4 0c 3b 10 00 	movl   $0x103b0c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100550:	c7 45 f0 54 b0 10 00 	movl   $0x10b054,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100557:	c7 45 ec 55 b0 10 00 	movl   $0x10b055,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055e:	c7 45 e8 23 d0 10 00 	movl   $0x10d023,-0x18(%ebp)

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
  1006bd:	e8 45 28 00 00       	call   102f07 <strfind>
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
  10084c:	c7 04 24 d6 32 10 00 	movl   $0x1032d6,(%esp)
  100853:	e8 ba fa ff ff       	call   100312 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100858:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085f:	00 
  100860:	c7 04 24 ef 32 10 00 	movl   $0x1032ef,(%esp)
  100867:	e8 a6 fa ff ff       	call   100312 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10086c:	c7 44 24 04 1c 32 10 	movl   $0x10321c,0x4(%esp)
  100873:	00 
  100874:	c7 04 24 07 33 10 00 	movl   $0x103307,(%esp)
  10087b:	e8 92 fa ff ff       	call   100312 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100880:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100887:	00 
  100888:	c7 04 24 1f 33 10 00 	movl   $0x10331f,(%esp)
  10088f:	e8 7e fa ff ff       	call   100312 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100894:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  10089b:	00 
  10089c:	c7 04 24 37 33 10 00 	movl   $0x103337,(%esp)
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
  1008ce:	c7 04 24 50 33 10 00 	movl   $0x103350,(%esp)
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
  100902:	c7 04 24 7a 33 10 00 	movl   $0x10337a,(%esp)
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
  100971:	c7 04 24 96 33 10 00 	movl   $0x103396,(%esp)
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
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  100993:	5d                   	pop    %ebp
  100994:	c3                   	ret    

00100995 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100995:	55                   	push   %ebp
  100996:	89 e5                	mov    %esp,%ebp
  100998:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  10099b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  1009a2:	eb 0c                	jmp    1009b0 <parse+0x1b>
            *buf ++ = '\0';
  1009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1009a7:	8d 50 01             	lea    0x1(%eax),%edx
  1009aa:	89 55 08             	mov    %edx,0x8(%ebp)
  1009ad:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  1009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1009b3:	0f b6 00             	movzbl (%eax),%eax
  1009b6:	84 c0                	test   %al,%al
  1009b8:	74 1d                	je     1009d7 <parse+0x42>
  1009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1009bd:	0f b6 00             	movzbl (%eax),%eax
  1009c0:	0f be c0             	movsbl %al,%eax
  1009c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009c7:	c7 04 24 28 34 10 00 	movl   $0x103428,(%esp)
  1009ce:	e8 01 25 00 00       	call   102ed4 <strchr>
  1009d3:	85 c0                	test   %eax,%eax
  1009d5:	75 cd                	jne    1009a4 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  1009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1009da:	0f b6 00             	movzbl (%eax),%eax
  1009dd:	84 c0                	test   %al,%al
  1009df:	75 02                	jne    1009e3 <parse+0x4e>
            break;
  1009e1:	eb 67                	jmp    100a4a <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  1009e3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  1009e7:	75 14                	jne    1009fd <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  1009e9:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  1009f0:	00 
  1009f1:	c7 04 24 2d 34 10 00 	movl   $0x10342d,(%esp)
  1009f8:	e8 15 f9 ff ff       	call   100312 <cprintf>
        }
        argv[argc ++] = buf;
  1009fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a00:	8d 50 01             	lea    0x1(%eax),%edx
  100a03:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100a06:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a10:	01 c2                	add    %eax,%edx
  100a12:	8b 45 08             	mov    0x8(%ebp),%eax
  100a15:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a17:	eb 04                	jmp    100a1d <parse+0x88>
            buf ++;
  100a19:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  100a20:	0f b6 00             	movzbl (%eax),%eax
  100a23:	84 c0                	test   %al,%al
  100a25:	74 1d                	je     100a44 <parse+0xaf>
  100a27:	8b 45 08             	mov    0x8(%ebp),%eax
  100a2a:	0f b6 00             	movzbl (%eax),%eax
  100a2d:	0f be c0             	movsbl %al,%eax
  100a30:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a34:	c7 04 24 28 34 10 00 	movl   $0x103428,(%esp)
  100a3b:	e8 94 24 00 00       	call   102ed4 <strchr>
  100a40:	85 c0                	test   %eax,%eax
  100a42:	74 d5                	je     100a19 <parse+0x84>
            buf ++;
        }
    }
  100a44:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a45:	e9 66 ff ff ff       	jmp    1009b0 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100a4d:	c9                   	leave  
  100a4e:	c3                   	ret    

00100a4f <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100a4f:	55                   	push   %ebp
  100a50:	89 e5                	mov    %esp,%ebp
  100a52:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100a55:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100a58:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  100a5f:	89 04 24             	mov    %eax,(%esp)
  100a62:	e8 2e ff ff ff       	call   100995 <parse>
  100a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100a6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100a6e:	75 0a                	jne    100a7a <runcmd+0x2b>
        return 0;
  100a70:	b8 00 00 00 00       	mov    $0x0,%eax
  100a75:	e9 85 00 00 00       	jmp    100aff <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100a7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a81:	eb 5c                	jmp    100adf <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100a83:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100a86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100a89:	89 d0                	mov    %edx,%eax
  100a8b:	01 c0                	add    %eax,%eax
  100a8d:	01 d0                	add    %edx,%eax
  100a8f:	c1 e0 02             	shl    $0x2,%eax
  100a92:	05 00 e0 10 00       	add    $0x10e000,%eax
  100a97:	8b 00                	mov    (%eax),%eax
  100a99:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100a9d:	89 04 24             	mov    %eax,(%esp)
  100aa0:	e8 90 23 00 00       	call   102e35 <strcmp>
  100aa5:	85 c0                	test   %eax,%eax
  100aa7:	75 32                	jne    100adb <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100aac:	89 d0                	mov    %edx,%eax
  100aae:	01 c0                	add    %eax,%eax
  100ab0:	01 d0                	add    %edx,%eax
  100ab2:	c1 e0 02             	shl    $0x2,%eax
  100ab5:	05 00 e0 10 00       	add    $0x10e000,%eax
  100aba:	8b 40 08             	mov    0x8(%eax),%eax
  100abd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100ac0:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
  100ac6:	89 54 24 08          	mov    %edx,0x8(%esp)
  100aca:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100acd:	83 c2 04             	add    $0x4,%edx
  100ad0:	89 54 24 04          	mov    %edx,0x4(%esp)
  100ad4:	89 0c 24             	mov    %ecx,(%esp)
  100ad7:	ff d0                	call   *%eax
  100ad9:	eb 24                	jmp    100aff <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100adb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae2:	83 f8 02             	cmp    $0x2,%eax
  100ae5:	76 9c                	jbe    100a83 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100ae7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100aea:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aee:	c7 04 24 4b 34 10 00 	movl   $0x10344b,(%esp)
  100af5:	e8 18 f8 ff ff       	call   100312 <cprintf>
    return 0;
  100afa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100aff:	c9                   	leave  
  100b00:	c3                   	ret    

00100b01 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100b01:	55                   	push   %ebp
  100b02:	89 e5                	mov    %esp,%ebp
  100b04:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100b07:	c7 04 24 64 34 10 00 	movl   $0x103464,(%esp)
  100b0e:	e8 ff f7 ff ff       	call   100312 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100b13:	c7 04 24 8c 34 10 00 	movl   $0x10348c,(%esp)
  100b1a:	e8 f3 f7 ff ff       	call   100312 <cprintf>

    if (tf != NULL) {
  100b1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100b23:	74 0b                	je     100b30 <kmonitor+0x2f>
        print_trapframe(tf);
  100b25:	8b 45 08             	mov    0x8(%ebp),%eax
  100b28:	89 04 24             	mov    %eax,(%esp)
  100b2b:	e8 72 0c 00 00       	call   1017a2 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100b30:	c7 04 24 b1 34 10 00 	movl   $0x1034b1,(%esp)
  100b37:	e8 cd f6 ff ff       	call   100209 <readline>
  100b3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100b3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b43:	74 18                	je     100b5d <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100b45:	8b 45 08             	mov    0x8(%ebp),%eax
  100b48:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b4f:	89 04 24             	mov    %eax,(%esp)
  100b52:	e8 f8 fe ff ff       	call   100a4f <runcmd>
  100b57:	85 c0                	test   %eax,%eax
  100b59:	79 02                	jns    100b5d <kmonitor+0x5c>
                break;
  100b5b:	eb 02                	jmp    100b5f <kmonitor+0x5e>
            }
        }
    }
  100b5d:	eb d1                	jmp    100b30 <kmonitor+0x2f>
}
  100b5f:	c9                   	leave  
  100b60:	c3                   	ret    

00100b61 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100b61:	55                   	push   %ebp
  100b62:	89 e5                	mov    %esp,%ebp
  100b64:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b6e:	eb 3f                	jmp    100baf <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100b70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b73:	89 d0                	mov    %edx,%eax
  100b75:	01 c0                	add    %eax,%eax
  100b77:	01 d0                	add    %edx,%eax
  100b79:	c1 e0 02             	shl    $0x2,%eax
  100b7c:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b81:	8b 48 04             	mov    0x4(%eax),%ecx
  100b84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b87:	89 d0                	mov    %edx,%eax
  100b89:	01 c0                	add    %eax,%eax
  100b8b:	01 d0                	add    %edx,%eax
  100b8d:	c1 e0 02             	shl    $0x2,%eax
  100b90:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b95:	8b 00                	mov    (%eax),%eax
  100b97:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100b9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b9f:	c7 04 24 b5 34 10 00 	movl   $0x1034b5,(%esp)
  100ba6:	e8 67 f7 ff ff       	call   100312 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bb2:	83 f8 02             	cmp    $0x2,%eax
  100bb5:	76 b9                	jbe    100b70 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100bb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bbc:	c9                   	leave  
  100bbd:	c3                   	ret    

00100bbe <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100bbe:	55                   	push   %ebp
  100bbf:	89 e5                	mov    %esp,%ebp
  100bc1:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100bc4:	e8 7d fc ff ff       	call   100846 <print_kerninfo>
    return 0;
  100bc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bce:	c9                   	leave  
  100bcf:	c3                   	ret    

00100bd0 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100bd0:	55                   	push   %ebp
  100bd1:	89 e5                	mov    %esp,%ebp
  100bd3:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100bd6:	e8 b5 fd ff ff       	call   100990 <print_stackframe>
    return 0;
  100bdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100be0:	c9                   	leave  
  100be1:	c3                   	ret    

00100be2 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100be2:	55                   	push   %ebp
  100be3:	89 e5                	mov    %esp,%ebp
  100be5:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100be8:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100bed:	85 c0                	test   %eax,%eax
  100bef:	74 02                	je     100bf3 <__panic+0x11>
        goto panic_dead;
  100bf1:	eb 59                	jmp    100c4c <__panic+0x6a>
    }
    is_panic = 1;
  100bf3:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100bfa:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100bfd:	8d 45 14             	lea    0x14(%ebp),%eax
  100c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c06:	89 44 24 08          	mov    %eax,0x8(%esp)
  100c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  100c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c11:	c7 04 24 be 34 10 00 	movl   $0x1034be,(%esp)
  100c18:	e8 f5 f6 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c20:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c24:	8b 45 10             	mov    0x10(%ebp),%eax
  100c27:	89 04 24             	mov    %eax,(%esp)
  100c2a:	e8 b0 f6 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100c2f:	c7 04 24 da 34 10 00 	movl   $0x1034da,(%esp)
  100c36:	e8 d7 f6 ff ff       	call   100312 <cprintf>
    
    cprintf("stack trackback:\n");
  100c3b:	c7 04 24 dc 34 10 00 	movl   $0x1034dc,(%esp)
  100c42:	e8 cb f6 ff ff       	call   100312 <cprintf>
    print_stackframe();
  100c47:	e8 44 fd ff ff       	call   100990 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  100c4c:	e8 22 09 00 00       	call   101573 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100c51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100c58:	e8 a4 fe ff ff       	call   100b01 <kmonitor>
    }
  100c5d:	eb f2                	jmp    100c51 <__panic+0x6f>

00100c5f <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100c5f:	55                   	push   %ebp
  100c60:	89 e5                	mov    %esp,%ebp
  100c62:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100c65:	8d 45 14             	lea    0x14(%ebp),%eax
  100c68:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100c72:	8b 45 08             	mov    0x8(%ebp),%eax
  100c75:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c79:	c7 04 24 ee 34 10 00 	movl   $0x1034ee,(%esp)
  100c80:	e8 8d f6 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c8c:	8b 45 10             	mov    0x10(%ebp),%eax
  100c8f:	89 04 24             	mov    %eax,(%esp)
  100c92:	e8 48 f6 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100c97:	c7 04 24 da 34 10 00 	movl   $0x1034da,(%esp)
  100c9e:	e8 6f f6 ff ff       	call   100312 <cprintf>
    va_end(ap);
}
  100ca3:	c9                   	leave  
  100ca4:	c3                   	ret    

00100ca5 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100ca5:	55                   	push   %ebp
  100ca6:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100ca8:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100cad:	5d                   	pop    %ebp
  100cae:	c3                   	ret    

00100caf <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100caf:	55                   	push   %ebp
  100cb0:	89 e5                	mov    %esp,%ebp
  100cb2:	83 ec 28             	sub    $0x28,%esp
  100cb5:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100cbb:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100cbf:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100cc3:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100cc7:	ee                   	out    %al,(%dx)
  100cc8:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100cce:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100cd2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100cd6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100cda:	ee                   	out    %al,(%dx)
  100cdb:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100ce1:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100ce5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ce9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ced:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100cee:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100cf5:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100cf8:	c7 04 24 0c 35 10 00 	movl   $0x10350c,(%esp)
  100cff:	e8 0e f6 ff ff       	call   100312 <cprintf>
    pic_enable(IRQ_TIMER);
  100d04:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d0b:	e8 c1 08 00 00       	call   1015d1 <pic_enable>
}
  100d10:	c9                   	leave  
  100d11:	c3                   	ret    

00100d12 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100d12:	55                   	push   %ebp
  100d13:	89 e5                	mov    %esp,%ebp
  100d15:	83 ec 10             	sub    $0x10,%esp
  100d18:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100d1e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100d22:	89 c2                	mov    %eax,%edx
  100d24:	ec                   	in     (%dx),%al
  100d25:	88 45 fd             	mov    %al,-0x3(%ebp)
  100d28:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100d2e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100d32:	89 c2                	mov    %eax,%edx
  100d34:	ec                   	in     (%dx),%al
  100d35:	88 45 f9             	mov    %al,-0x7(%ebp)
  100d38:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100d3e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100d42:	89 c2                	mov    %eax,%edx
  100d44:	ec                   	in     (%dx),%al
  100d45:	88 45 f5             	mov    %al,-0xb(%ebp)
  100d48:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100d4e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100d52:	89 c2                	mov    %eax,%edx
  100d54:	ec                   	in     (%dx),%al
  100d55:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100d58:	c9                   	leave  
  100d59:	c3                   	ret    

00100d5a <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100d5a:	55                   	push   %ebp
  100d5b:	89 e5                	mov    %esp,%ebp
  100d5d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100d60:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100d67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d6a:	0f b7 00             	movzwl (%eax),%eax
  100d6d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100d71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d74:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100d79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d7c:	0f b7 00             	movzwl (%eax),%eax
  100d7f:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100d83:	74 12                	je     100d97 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100d85:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100d8c:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100d93:	b4 03 
  100d95:	eb 13                	jmp    100daa <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100d97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d9a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100d9e:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100da1:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100da8:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100daa:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100db1:	0f b7 c0             	movzwl %ax,%eax
  100db4:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100db8:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dbc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dc0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dc4:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100dc5:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100dcc:	83 c0 01             	add    $0x1,%eax
  100dcf:	0f b7 c0             	movzwl %ax,%eax
  100dd2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dd6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100dda:	89 c2                	mov    %eax,%edx
  100ddc:	ec                   	in     (%dx),%al
  100ddd:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100de0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100de4:	0f b6 c0             	movzbl %al,%eax
  100de7:	c1 e0 08             	shl    $0x8,%eax
  100dea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ded:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100df4:	0f b7 c0             	movzwl %ax,%eax
  100df7:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100dfb:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dff:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e03:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e07:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100e08:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e0f:	83 c0 01             	add    $0x1,%eax
  100e12:	0f b7 c0             	movzwl %ax,%eax
  100e15:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e19:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100e1d:	89 c2                	mov    %eax,%edx
  100e1f:	ec                   	in     (%dx),%al
  100e20:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100e23:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e27:	0f b6 c0             	movzbl %al,%eax
  100e2a:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e30:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100e38:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100e3e:	c9                   	leave  
  100e3f:	c3                   	ret    

00100e40 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100e40:	55                   	push   %ebp
  100e41:	89 e5                	mov    %esp,%ebp
  100e43:	83 ec 48             	sub    $0x48,%esp
  100e46:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100e4c:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e50:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e54:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e58:	ee                   	out    %al,(%dx)
  100e59:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100e5f:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100e63:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e67:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e6b:	ee                   	out    %al,(%dx)
  100e6c:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100e72:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100e76:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e7a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e7e:	ee                   	out    %al,(%dx)
  100e7f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100e85:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100e89:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e8d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e91:	ee                   	out    %al,(%dx)
  100e92:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100e98:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100e9c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ea0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ea4:	ee                   	out    %al,(%dx)
  100ea5:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100eab:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100eaf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100eb3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100eb7:	ee                   	out    %al,(%dx)
  100eb8:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100ebe:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100ec2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100ec6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100eca:	ee                   	out    %al,(%dx)
  100ecb:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ed1:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100ed5:	89 c2                	mov    %eax,%edx
  100ed7:	ec                   	in     (%dx),%al
  100ed8:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100edb:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100edf:	3c ff                	cmp    $0xff,%al
  100ee1:	0f 95 c0             	setne  %al
  100ee4:	0f b6 c0             	movzbl %al,%eax
  100ee7:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100eec:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ef2:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100ef6:	89 c2                	mov    %eax,%edx
  100ef8:	ec                   	in     (%dx),%al
  100ef9:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100efc:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100f02:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100f06:	89 c2                	mov    %eax,%edx
  100f08:	ec                   	in     (%dx),%al
  100f09:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100f0c:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100f11:	85 c0                	test   %eax,%eax
  100f13:	74 0c                	je     100f21 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100f15:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100f1c:	e8 b0 06 00 00       	call   1015d1 <pic_enable>
    }
}
  100f21:	c9                   	leave  
  100f22:	c3                   	ret    

00100f23 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100f23:	55                   	push   %ebp
  100f24:	89 e5                	mov    %esp,%ebp
  100f26:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100f30:	eb 09                	jmp    100f3b <lpt_putc_sub+0x18>
        delay();
  100f32:	e8 db fd ff ff       	call   100d12 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f37:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100f3b:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100f41:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100f45:	89 c2                	mov    %eax,%edx
  100f47:	ec                   	in     (%dx),%al
  100f48:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100f4b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100f4f:	84 c0                	test   %al,%al
  100f51:	78 09                	js     100f5c <lpt_putc_sub+0x39>
  100f53:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100f5a:	7e d6                	jle    100f32 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  100f5f:	0f b6 c0             	movzbl %al,%eax
  100f62:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  100f68:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f6b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f6f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f73:	ee                   	out    %al,(%dx)
  100f74:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  100f7a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  100f7e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f82:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f86:	ee                   	out    %al,(%dx)
  100f87:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  100f8d:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  100f91:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f95:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f99:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  100f9a:	c9                   	leave  
  100f9b:	c3                   	ret    

00100f9c <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  100f9c:	55                   	push   %ebp
  100f9d:	89 e5                	mov    %esp,%ebp
  100f9f:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  100fa2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  100fa6:	74 0d                	je     100fb5 <lpt_putc+0x19>
        lpt_putc_sub(c);
  100fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  100fab:	89 04 24             	mov    %eax,(%esp)
  100fae:	e8 70 ff ff ff       	call   100f23 <lpt_putc_sub>
  100fb3:	eb 24                	jmp    100fd9 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  100fb5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  100fbc:	e8 62 ff ff ff       	call   100f23 <lpt_putc_sub>
        lpt_putc_sub(' ');
  100fc1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  100fc8:	e8 56 ff ff ff       	call   100f23 <lpt_putc_sub>
        lpt_putc_sub('\b');
  100fcd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  100fd4:	e8 4a ff ff ff       	call   100f23 <lpt_putc_sub>
    }
}
  100fd9:	c9                   	leave  
  100fda:	c3                   	ret    

00100fdb <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  100fdb:	55                   	push   %ebp
  100fdc:	89 e5                	mov    %esp,%ebp
  100fde:	53                   	push   %ebx
  100fdf:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  100fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  100fe5:	b0 00                	mov    $0x0,%al
  100fe7:	85 c0                	test   %eax,%eax
  100fe9:	75 07                	jne    100ff2 <cga_putc+0x17>
        c |= 0x0700;
  100feb:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  100ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ff5:	0f b6 c0             	movzbl %al,%eax
  100ff8:	83 f8 0a             	cmp    $0xa,%eax
  100ffb:	74 4c                	je     101049 <cga_putc+0x6e>
  100ffd:	83 f8 0d             	cmp    $0xd,%eax
  101000:	74 57                	je     101059 <cga_putc+0x7e>
  101002:	83 f8 08             	cmp    $0x8,%eax
  101005:	0f 85 88 00 00 00    	jne    101093 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  10100b:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101012:	66 85 c0             	test   %ax,%ax
  101015:	74 30                	je     101047 <cga_putc+0x6c>
            crt_pos --;
  101017:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10101e:	83 e8 01             	sub    $0x1,%eax
  101021:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101027:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10102c:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  101033:	0f b7 d2             	movzwl %dx,%edx
  101036:	01 d2                	add    %edx,%edx
  101038:	01 c2                	add    %eax,%edx
  10103a:	8b 45 08             	mov    0x8(%ebp),%eax
  10103d:	b0 00                	mov    $0x0,%al
  10103f:	83 c8 20             	or     $0x20,%eax
  101042:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101045:	eb 72                	jmp    1010b9 <cga_putc+0xde>
  101047:	eb 70                	jmp    1010b9 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101049:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101050:	83 c0 50             	add    $0x50,%eax
  101053:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101059:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101060:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101067:	0f b7 c1             	movzwl %cx,%eax
  10106a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101070:	c1 e8 10             	shr    $0x10,%eax
  101073:	89 c2                	mov    %eax,%edx
  101075:	66 c1 ea 06          	shr    $0x6,%dx
  101079:	89 d0                	mov    %edx,%eax
  10107b:	c1 e0 02             	shl    $0x2,%eax
  10107e:	01 d0                	add    %edx,%eax
  101080:	c1 e0 04             	shl    $0x4,%eax
  101083:	29 c1                	sub    %eax,%ecx
  101085:	89 ca                	mov    %ecx,%edx
  101087:	89 d8                	mov    %ebx,%eax
  101089:	29 d0                	sub    %edx,%eax
  10108b:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101091:	eb 26                	jmp    1010b9 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101093:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101099:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010a0:	8d 50 01             	lea    0x1(%eax),%edx
  1010a3:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  1010aa:	0f b7 c0             	movzwl %ax,%eax
  1010ad:	01 c0                	add    %eax,%eax
  1010af:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b5:	66 89 02             	mov    %ax,(%edx)
        break;
  1010b8:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1010b9:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010c0:	66 3d cf 07          	cmp    $0x7cf,%ax
  1010c4:	76 5b                	jbe    101121 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1010c6:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010cb:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1010d1:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010d6:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1010dd:	00 
  1010de:	89 54 24 04          	mov    %edx,0x4(%esp)
  1010e2:	89 04 24             	mov    %eax,(%esp)
  1010e5:	e8 e8 1f 00 00       	call   1030d2 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1010ea:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1010f1:	eb 15                	jmp    101108 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1010f3:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1010fb:	01 d2                	add    %edx,%edx
  1010fd:	01 d0                	add    %edx,%eax
  1010ff:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101104:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101108:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10110f:	7e e2                	jle    1010f3 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101111:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101118:	83 e8 50             	sub    $0x50,%eax
  10111b:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101121:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101128:	0f b7 c0             	movzwl %ax,%eax
  10112b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10112f:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101133:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101137:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10113b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10113c:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101143:	66 c1 e8 08          	shr    $0x8,%ax
  101147:	0f b6 c0             	movzbl %al,%eax
  10114a:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101151:	83 c2 01             	add    $0x1,%edx
  101154:	0f b7 d2             	movzwl %dx,%edx
  101157:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10115b:	88 45 ed             	mov    %al,-0x13(%ebp)
  10115e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101162:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101166:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101167:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  10116e:	0f b7 c0             	movzwl %ax,%eax
  101171:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101175:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101179:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10117d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101181:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101182:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101189:	0f b6 c0             	movzbl %al,%eax
  10118c:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101193:	83 c2 01             	add    $0x1,%edx
  101196:	0f b7 d2             	movzwl %dx,%edx
  101199:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  10119d:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1011a0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1011a4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1011a8:	ee                   	out    %al,(%dx)
}
  1011a9:	83 c4 34             	add    $0x34,%esp
  1011ac:	5b                   	pop    %ebx
  1011ad:	5d                   	pop    %ebp
  1011ae:	c3                   	ret    

001011af <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1011af:	55                   	push   %ebp
  1011b0:	89 e5                	mov    %esp,%ebp
  1011b2:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1011b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1011bc:	eb 09                	jmp    1011c7 <serial_putc_sub+0x18>
        delay();
  1011be:	e8 4f fb ff ff       	call   100d12 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1011c3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1011c7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1011cd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1011d1:	89 c2                	mov    %eax,%edx
  1011d3:	ec                   	in     (%dx),%al
  1011d4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1011d7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1011db:	0f b6 c0             	movzbl %al,%eax
  1011de:	83 e0 20             	and    $0x20,%eax
  1011e1:	85 c0                	test   %eax,%eax
  1011e3:	75 09                	jne    1011ee <serial_putc_sub+0x3f>
  1011e5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1011ec:	7e d0                	jle    1011be <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1011f1:	0f b6 c0             	movzbl %al,%eax
  1011f4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1011fa:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1011fd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101201:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101205:	ee                   	out    %al,(%dx)
}
  101206:	c9                   	leave  
  101207:	c3                   	ret    

00101208 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101208:	55                   	push   %ebp
  101209:	89 e5                	mov    %esp,%ebp
  10120b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10120e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101212:	74 0d                	je     101221 <serial_putc+0x19>
        serial_putc_sub(c);
  101214:	8b 45 08             	mov    0x8(%ebp),%eax
  101217:	89 04 24             	mov    %eax,(%esp)
  10121a:	e8 90 ff ff ff       	call   1011af <serial_putc_sub>
  10121f:	eb 24                	jmp    101245 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101221:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101228:	e8 82 ff ff ff       	call   1011af <serial_putc_sub>
        serial_putc_sub(' ');
  10122d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101234:	e8 76 ff ff ff       	call   1011af <serial_putc_sub>
        serial_putc_sub('\b');
  101239:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101240:	e8 6a ff ff ff       	call   1011af <serial_putc_sub>
    }
}
  101245:	c9                   	leave  
  101246:	c3                   	ret    

00101247 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101247:	55                   	push   %ebp
  101248:	89 e5                	mov    %esp,%ebp
  10124a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10124d:	eb 33                	jmp    101282 <cons_intr+0x3b>
        if (c != 0) {
  10124f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101253:	74 2d                	je     101282 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101255:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10125a:	8d 50 01             	lea    0x1(%eax),%edx
  10125d:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101263:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101266:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10126c:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101271:	3d 00 02 00 00       	cmp    $0x200,%eax
  101276:	75 0a                	jne    101282 <cons_intr+0x3b>
                cons.wpos = 0;
  101278:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10127f:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101282:	8b 45 08             	mov    0x8(%ebp),%eax
  101285:	ff d0                	call   *%eax
  101287:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10128a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10128e:	75 bf                	jne    10124f <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101290:	c9                   	leave  
  101291:	c3                   	ret    

00101292 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101292:	55                   	push   %ebp
  101293:	89 e5                	mov    %esp,%ebp
  101295:	83 ec 10             	sub    $0x10,%esp
  101298:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10129e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012a2:	89 c2                	mov    %eax,%edx
  1012a4:	ec                   	in     (%dx),%al
  1012a5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012a8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1012ac:	0f b6 c0             	movzbl %al,%eax
  1012af:	83 e0 01             	and    $0x1,%eax
  1012b2:	85 c0                	test   %eax,%eax
  1012b4:	75 07                	jne    1012bd <serial_proc_data+0x2b>
        return -1;
  1012b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1012bb:	eb 2a                	jmp    1012e7 <serial_proc_data+0x55>
  1012bd:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012c3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1012c7:	89 c2                	mov    %eax,%edx
  1012c9:	ec                   	in     (%dx),%al
  1012ca:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1012cd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1012d1:	0f b6 c0             	movzbl %al,%eax
  1012d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1012d7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1012db:	75 07                	jne    1012e4 <serial_proc_data+0x52>
        c = '\b';
  1012dd:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1012e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1012e7:	c9                   	leave  
  1012e8:	c3                   	ret    

001012e9 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1012e9:	55                   	push   %ebp
  1012ea:	89 e5                	mov    %esp,%ebp
  1012ec:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1012ef:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1012f4:	85 c0                	test   %eax,%eax
  1012f6:	74 0c                	je     101304 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1012f8:	c7 04 24 92 12 10 00 	movl   $0x101292,(%esp)
  1012ff:	e8 43 ff ff ff       	call   101247 <cons_intr>
    }
}
  101304:	c9                   	leave  
  101305:	c3                   	ret    

00101306 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101306:	55                   	push   %ebp
  101307:	89 e5                	mov    %esp,%ebp
  101309:	83 ec 38             	sub    $0x38,%esp
  10130c:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101312:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101316:	89 c2                	mov    %eax,%edx
  101318:	ec                   	in     (%dx),%al
  101319:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10131c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101320:	0f b6 c0             	movzbl %al,%eax
  101323:	83 e0 01             	and    $0x1,%eax
  101326:	85 c0                	test   %eax,%eax
  101328:	75 0a                	jne    101334 <kbd_proc_data+0x2e>
        return -1;
  10132a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10132f:	e9 59 01 00 00       	jmp    10148d <kbd_proc_data+0x187>
  101334:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10133a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10133e:	89 c2                	mov    %eax,%edx
  101340:	ec                   	in     (%dx),%al
  101341:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101344:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101348:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10134b:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10134f:	75 17                	jne    101368 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101351:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101356:	83 c8 40             	or     $0x40,%eax
  101359:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  10135e:	b8 00 00 00 00       	mov    $0x0,%eax
  101363:	e9 25 01 00 00       	jmp    10148d <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101368:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10136c:	84 c0                	test   %al,%al
  10136e:	79 47                	jns    1013b7 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101370:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101375:	83 e0 40             	and    $0x40,%eax
  101378:	85 c0                	test   %eax,%eax
  10137a:	75 09                	jne    101385 <kbd_proc_data+0x7f>
  10137c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101380:	83 e0 7f             	and    $0x7f,%eax
  101383:	eb 04                	jmp    101389 <kbd_proc_data+0x83>
  101385:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101389:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10138c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101390:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101397:	83 c8 40             	or     $0x40,%eax
  10139a:	0f b6 c0             	movzbl %al,%eax
  10139d:	f7 d0                	not    %eax
  10139f:	89 c2                	mov    %eax,%edx
  1013a1:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013a6:	21 d0                	and    %edx,%eax
  1013a8:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1013ad:	b8 00 00 00 00       	mov    $0x0,%eax
  1013b2:	e9 d6 00 00 00       	jmp    10148d <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1013b7:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013bc:	83 e0 40             	and    $0x40,%eax
  1013bf:	85 c0                	test   %eax,%eax
  1013c1:	74 11                	je     1013d4 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1013c3:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1013c7:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013cc:	83 e0 bf             	and    $0xffffffbf,%eax
  1013cf:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  1013d4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013d8:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  1013df:	0f b6 d0             	movzbl %al,%edx
  1013e2:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013e7:	09 d0                	or     %edx,%eax
  1013e9:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1013ee:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013f2:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1013f9:	0f b6 d0             	movzbl %al,%edx
  1013fc:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101401:	31 d0                	xor    %edx,%eax
  101403:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  101408:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10140d:	83 e0 03             	and    $0x3,%eax
  101410:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  101417:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10141b:	01 d0                	add    %edx,%eax
  10141d:	0f b6 00             	movzbl (%eax),%eax
  101420:	0f b6 c0             	movzbl %al,%eax
  101423:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101426:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10142b:	83 e0 08             	and    $0x8,%eax
  10142e:	85 c0                	test   %eax,%eax
  101430:	74 22                	je     101454 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101432:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101436:	7e 0c                	jle    101444 <kbd_proc_data+0x13e>
  101438:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10143c:	7f 06                	jg     101444 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  10143e:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101442:	eb 10                	jmp    101454 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101444:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101448:	7e 0a                	jle    101454 <kbd_proc_data+0x14e>
  10144a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10144e:	7f 04                	jg     101454 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101450:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101454:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101459:	f7 d0                	not    %eax
  10145b:	83 e0 06             	and    $0x6,%eax
  10145e:	85 c0                	test   %eax,%eax
  101460:	75 28                	jne    10148a <kbd_proc_data+0x184>
  101462:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101469:	75 1f                	jne    10148a <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10146b:	c7 04 24 27 35 10 00 	movl   $0x103527,(%esp)
  101472:	e8 9b ee ff ff       	call   100312 <cprintf>
  101477:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10147d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101481:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101485:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101489:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10148a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10148d:	c9                   	leave  
  10148e:	c3                   	ret    

0010148f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10148f:	55                   	push   %ebp
  101490:	89 e5                	mov    %esp,%ebp
  101492:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101495:	c7 04 24 06 13 10 00 	movl   $0x101306,(%esp)
  10149c:	e8 a6 fd ff ff       	call   101247 <cons_intr>
}
  1014a1:	c9                   	leave  
  1014a2:	c3                   	ret    

001014a3 <kbd_init>:

static void
kbd_init(void) {
  1014a3:	55                   	push   %ebp
  1014a4:	89 e5                	mov    %esp,%ebp
  1014a6:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1014a9:	e8 e1 ff ff ff       	call   10148f <kbd_intr>
    pic_enable(IRQ_KBD);
  1014ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1014b5:	e8 17 01 00 00       	call   1015d1 <pic_enable>
}
  1014ba:	c9                   	leave  
  1014bb:	c3                   	ret    

001014bc <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1014bc:	55                   	push   %ebp
  1014bd:	89 e5                	mov    %esp,%ebp
  1014bf:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1014c2:	e8 93 f8 ff ff       	call   100d5a <cga_init>
    serial_init();
  1014c7:	e8 74 f9 ff ff       	call   100e40 <serial_init>
    kbd_init();
  1014cc:	e8 d2 ff ff ff       	call   1014a3 <kbd_init>
    if (!serial_exists) {
  1014d1:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1014d6:	85 c0                	test   %eax,%eax
  1014d8:	75 0c                	jne    1014e6 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1014da:	c7 04 24 33 35 10 00 	movl   $0x103533,(%esp)
  1014e1:	e8 2c ee ff ff       	call   100312 <cprintf>
    }
}
  1014e6:	c9                   	leave  
  1014e7:	c3                   	ret    

001014e8 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1014e8:	55                   	push   %ebp
  1014e9:	89 e5                	mov    %esp,%ebp
  1014eb:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1014f1:	89 04 24             	mov    %eax,(%esp)
  1014f4:	e8 a3 fa ff ff       	call   100f9c <lpt_putc>
    cga_putc(c);
  1014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1014fc:	89 04 24             	mov    %eax,(%esp)
  1014ff:	e8 d7 fa ff ff       	call   100fdb <cga_putc>
    serial_putc(c);
  101504:	8b 45 08             	mov    0x8(%ebp),%eax
  101507:	89 04 24             	mov    %eax,(%esp)
  10150a:	e8 f9 fc ff ff       	call   101208 <serial_putc>
}
  10150f:	c9                   	leave  
  101510:	c3                   	ret    

00101511 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101511:	55                   	push   %ebp
  101512:	89 e5                	mov    %esp,%ebp
  101514:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  101517:	e8 cd fd ff ff       	call   1012e9 <serial_intr>
    kbd_intr();
  10151c:	e8 6e ff ff ff       	call   10148f <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  101521:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  101527:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10152c:	39 c2                	cmp    %eax,%edx
  10152e:	74 36                	je     101566 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  101530:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101535:	8d 50 01             	lea    0x1(%eax),%edx
  101538:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  10153e:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  101545:	0f b6 c0             	movzbl %al,%eax
  101548:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  10154b:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101550:	3d 00 02 00 00       	cmp    $0x200,%eax
  101555:	75 0a                	jne    101561 <cons_getc+0x50>
            cons.rpos = 0;
  101557:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  10155e:	00 00 00 
        }
        return c;
  101561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101564:	eb 05                	jmp    10156b <cons_getc+0x5a>
    }
    return 0;
  101566:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10156b:	c9                   	leave  
  10156c:	c3                   	ret    

0010156d <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10156d:	55                   	push   %ebp
  10156e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101570:	fb                   	sti    
    sti();
}
  101571:	5d                   	pop    %ebp
  101572:	c3                   	ret    

00101573 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101573:	55                   	push   %ebp
  101574:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101576:	fa                   	cli    
    cli();
}
  101577:	5d                   	pop    %ebp
  101578:	c3                   	ret    

00101579 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101579:	55                   	push   %ebp
  10157a:	89 e5                	mov    %esp,%ebp
  10157c:	83 ec 14             	sub    $0x14,%esp
  10157f:	8b 45 08             	mov    0x8(%ebp),%eax
  101582:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101586:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10158a:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101590:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101595:	85 c0                	test   %eax,%eax
  101597:	74 36                	je     1015cf <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101599:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10159d:	0f b6 c0             	movzbl %al,%eax
  1015a0:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1015a6:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1015a9:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1015ad:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1015b1:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1015b2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1015b6:	66 c1 e8 08          	shr    $0x8,%ax
  1015ba:	0f b6 c0             	movzbl %al,%eax
  1015bd:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1015c3:	88 45 f9             	mov    %al,-0x7(%ebp)
  1015c6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1015ca:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1015ce:	ee                   	out    %al,(%dx)
    }
}
  1015cf:	c9                   	leave  
  1015d0:	c3                   	ret    

001015d1 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1015d1:	55                   	push   %ebp
  1015d2:	89 e5                	mov    %esp,%ebp
  1015d4:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1015da:	ba 01 00 00 00       	mov    $0x1,%edx
  1015df:	89 c1                	mov    %eax,%ecx
  1015e1:	d3 e2                	shl    %cl,%edx
  1015e3:	89 d0                	mov    %edx,%eax
  1015e5:	f7 d0                	not    %eax
  1015e7:	89 c2                	mov    %eax,%edx
  1015e9:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1015f0:	21 d0                	and    %edx,%eax
  1015f2:	0f b7 c0             	movzwl %ax,%eax
  1015f5:	89 04 24             	mov    %eax,(%esp)
  1015f8:	e8 7c ff ff ff       	call   101579 <pic_setmask>
}
  1015fd:	c9                   	leave  
  1015fe:	c3                   	ret    

001015ff <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1015ff:	55                   	push   %ebp
  101600:	89 e5                	mov    %esp,%ebp
  101602:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101605:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  10160c:	00 00 00 
  10160f:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101615:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101619:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10161d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101621:	ee                   	out    %al,(%dx)
  101622:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101628:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  10162c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101630:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101634:	ee                   	out    %al,(%dx)
  101635:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10163b:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  10163f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101643:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101647:	ee                   	out    %al,(%dx)
  101648:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10164e:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101652:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101656:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10165a:	ee                   	out    %al,(%dx)
  10165b:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101661:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101665:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101669:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10166d:	ee                   	out    %al,(%dx)
  10166e:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101674:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101678:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10167c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101680:	ee                   	out    %al,(%dx)
  101681:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101687:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  10168b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10168f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101693:	ee                   	out    %al,(%dx)
  101694:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  10169a:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  10169e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1016a2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1016a6:	ee                   	out    %al,(%dx)
  1016a7:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1016ad:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1016b1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1016b5:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1016b9:	ee                   	out    %al,(%dx)
  1016ba:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1016c0:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  1016c4:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1016c8:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1016cc:	ee                   	out    %al,(%dx)
  1016cd:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  1016d3:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  1016d7:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1016db:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1016df:	ee                   	out    %al,(%dx)
  1016e0:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1016e6:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  1016ea:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1016ee:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1016f2:	ee                   	out    %al,(%dx)
  1016f3:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1016f9:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1016fd:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101701:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101705:	ee                   	out    %al,(%dx)
  101706:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  10170c:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101710:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101714:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101718:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101719:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101720:	66 83 f8 ff          	cmp    $0xffff,%ax
  101724:	74 12                	je     101738 <pic_init+0x139>
        pic_setmask(irq_mask);
  101726:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  10172d:	0f b7 c0             	movzwl %ax,%eax
  101730:	89 04 24             	mov    %eax,(%esp)
  101733:	e8 41 fe ff ff       	call   101579 <pic_setmask>
    }
}
  101738:	c9                   	leave  
  101739:	c3                   	ret    

0010173a <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10173a:	55                   	push   %ebp
  10173b:	89 e5                	mov    %esp,%ebp
  10173d:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101740:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101747:	00 
  101748:	c7 04 24 60 35 10 00 	movl   $0x103560,(%esp)
  10174f:	e8 be eb ff ff       	call   100312 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101754:	c9                   	leave  
  101755:	c3                   	ret    

00101756 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101756:	55                   	push   %ebp
  101757:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  101759:	5d                   	pop    %ebp
  10175a:	c3                   	ret    

0010175b <trapname>:

static const char *
trapname(int trapno) {
  10175b:	55                   	push   %ebp
  10175c:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  10175e:	8b 45 08             	mov    0x8(%ebp),%eax
  101761:	83 f8 13             	cmp    $0x13,%eax
  101764:	77 0c                	ja     101772 <trapname+0x17>
        return excnames[trapno];
  101766:	8b 45 08             	mov    0x8(%ebp),%eax
  101769:	8b 04 85 c0 38 10 00 	mov    0x1038c0(,%eax,4),%eax
  101770:	eb 18                	jmp    10178a <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101772:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101776:	7e 0d                	jle    101785 <trapname+0x2a>
  101778:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  10177c:	7f 07                	jg     101785 <trapname+0x2a>
        return "Hardware Interrupt";
  10177e:	b8 6a 35 10 00       	mov    $0x10356a,%eax
  101783:	eb 05                	jmp    10178a <trapname+0x2f>
    }
    return "(unknown trap)";
  101785:	b8 7d 35 10 00       	mov    $0x10357d,%eax
}
  10178a:	5d                   	pop    %ebp
  10178b:	c3                   	ret    

0010178c <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  10178c:	55                   	push   %ebp
  10178d:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  10178f:	8b 45 08             	mov    0x8(%ebp),%eax
  101792:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101796:	66 83 f8 08          	cmp    $0x8,%ax
  10179a:	0f 94 c0             	sete   %al
  10179d:	0f b6 c0             	movzbl %al,%eax
}
  1017a0:	5d                   	pop    %ebp
  1017a1:	c3                   	ret    

001017a2 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1017a2:	55                   	push   %ebp
  1017a3:	89 e5                	mov    %esp,%ebp
  1017a5:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1017ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  1017af:	c7 04 24 be 35 10 00 	movl   $0x1035be,(%esp)
  1017b6:	e8 57 eb ff ff       	call   100312 <cprintf>
    print_regs(&tf->tf_regs);
  1017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1017be:	89 04 24             	mov    %eax,(%esp)
  1017c1:	e8 a1 01 00 00       	call   101967 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1017c9:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1017cd:	0f b7 c0             	movzwl %ax,%eax
  1017d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1017d4:	c7 04 24 cf 35 10 00 	movl   $0x1035cf,(%esp)
  1017db:	e8 32 eb ff ff       	call   100312 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1017e3:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1017e7:	0f b7 c0             	movzwl %ax,%eax
  1017ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  1017ee:	c7 04 24 e2 35 10 00 	movl   $0x1035e2,(%esp)
  1017f5:	e8 18 eb ff ff       	call   100312 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  1017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1017fd:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101801:	0f b7 c0             	movzwl %ax,%eax
  101804:	89 44 24 04          	mov    %eax,0x4(%esp)
  101808:	c7 04 24 f5 35 10 00 	movl   $0x1035f5,(%esp)
  10180f:	e8 fe ea ff ff       	call   100312 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101814:	8b 45 08             	mov    0x8(%ebp),%eax
  101817:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  10181b:	0f b7 c0             	movzwl %ax,%eax
  10181e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101822:	c7 04 24 08 36 10 00 	movl   $0x103608,(%esp)
  101829:	e8 e4 ea ff ff       	call   100312 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  10182e:	8b 45 08             	mov    0x8(%ebp),%eax
  101831:	8b 40 30             	mov    0x30(%eax),%eax
  101834:	89 04 24             	mov    %eax,(%esp)
  101837:	e8 1f ff ff ff       	call   10175b <trapname>
  10183c:	8b 55 08             	mov    0x8(%ebp),%edx
  10183f:	8b 52 30             	mov    0x30(%edx),%edx
  101842:	89 44 24 08          	mov    %eax,0x8(%esp)
  101846:	89 54 24 04          	mov    %edx,0x4(%esp)
  10184a:	c7 04 24 1b 36 10 00 	movl   $0x10361b,(%esp)
  101851:	e8 bc ea ff ff       	call   100312 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101856:	8b 45 08             	mov    0x8(%ebp),%eax
  101859:	8b 40 34             	mov    0x34(%eax),%eax
  10185c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101860:	c7 04 24 2d 36 10 00 	movl   $0x10362d,(%esp)
  101867:	e8 a6 ea ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  10186c:	8b 45 08             	mov    0x8(%ebp),%eax
  10186f:	8b 40 38             	mov    0x38(%eax),%eax
  101872:	89 44 24 04          	mov    %eax,0x4(%esp)
  101876:	c7 04 24 3c 36 10 00 	movl   $0x10363c,(%esp)
  10187d:	e8 90 ea ff ff       	call   100312 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101882:	8b 45 08             	mov    0x8(%ebp),%eax
  101885:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101889:	0f b7 c0             	movzwl %ax,%eax
  10188c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101890:	c7 04 24 4b 36 10 00 	movl   $0x10364b,(%esp)
  101897:	e8 76 ea ff ff       	call   100312 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  10189c:	8b 45 08             	mov    0x8(%ebp),%eax
  10189f:	8b 40 40             	mov    0x40(%eax),%eax
  1018a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018a6:	c7 04 24 5e 36 10 00 	movl   $0x10365e,(%esp)
  1018ad:	e8 60 ea ff ff       	call   100312 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  1018b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1018b9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  1018c0:	eb 3e                	jmp    101900 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  1018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1018c5:	8b 50 40             	mov    0x40(%eax),%edx
  1018c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1018cb:	21 d0                	and    %edx,%eax
  1018cd:	85 c0                	test   %eax,%eax
  1018cf:	74 28                	je     1018f9 <print_trapframe+0x157>
  1018d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1018d4:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  1018db:	85 c0                	test   %eax,%eax
  1018dd:	74 1a                	je     1018f9 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  1018df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1018e2:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  1018e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018ed:	c7 04 24 6d 36 10 00 	movl   $0x10366d,(%esp)
  1018f4:	e8 19 ea ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  1018f9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1018fd:	d1 65 f0             	shll   -0x10(%ebp)
  101900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101903:	83 f8 17             	cmp    $0x17,%eax
  101906:	76 ba                	jbe    1018c2 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101908:	8b 45 08             	mov    0x8(%ebp),%eax
  10190b:	8b 40 40             	mov    0x40(%eax),%eax
  10190e:	25 00 30 00 00       	and    $0x3000,%eax
  101913:	c1 e8 0c             	shr    $0xc,%eax
  101916:	89 44 24 04          	mov    %eax,0x4(%esp)
  10191a:	c7 04 24 71 36 10 00 	movl   $0x103671,(%esp)
  101921:	e8 ec e9 ff ff       	call   100312 <cprintf>

    if (!trap_in_kernel(tf)) {
  101926:	8b 45 08             	mov    0x8(%ebp),%eax
  101929:	89 04 24             	mov    %eax,(%esp)
  10192c:	e8 5b fe ff ff       	call   10178c <trap_in_kernel>
  101931:	85 c0                	test   %eax,%eax
  101933:	75 30                	jne    101965 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101935:	8b 45 08             	mov    0x8(%ebp),%eax
  101938:	8b 40 44             	mov    0x44(%eax),%eax
  10193b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10193f:	c7 04 24 7a 36 10 00 	movl   $0x10367a,(%esp)
  101946:	e8 c7 e9 ff ff       	call   100312 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  10194b:	8b 45 08             	mov    0x8(%ebp),%eax
  10194e:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101952:	0f b7 c0             	movzwl %ax,%eax
  101955:	89 44 24 04          	mov    %eax,0x4(%esp)
  101959:	c7 04 24 89 36 10 00 	movl   $0x103689,(%esp)
  101960:	e8 ad e9 ff ff       	call   100312 <cprintf>
    }
}
  101965:	c9                   	leave  
  101966:	c3                   	ret    

00101967 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101967:	55                   	push   %ebp
  101968:	89 e5                	mov    %esp,%ebp
  10196a:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  10196d:	8b 45 08             	mov    0x8(%ebp),%eax
  101970:	8b 00                	mov    (%eax),%eax
  101972:	89 44 24 04          	mov    %eax,0x4(%esp)
  101976:	c7 04 24 9c 36 10 00 	movl   $0x10369c,(%esp)
  10197d:	e8 90 e9 ff ff       	call   100312 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101982:	8b 45 08             	mov    0x8(%ebp),%eax
  101985:	8b 40 04             	mov    0x4(%eax),%eax
  101988:	89 44 24 04          	mov    %eax,0x4(%esp)
  10198c:	c7 04 24 ab 36 10 00 	movl   $0x1036ab,(%esp)
  101993:	e8 7a e9 ff ff       	call   100312 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101998:	8b 45 08             	mov    0x8(%ebp),%eax
  10199b:	8b 40 08             	mov    0x8(%eax),%eax
  10199e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019a2:	c7 04 24 ba 36 10 00 	movl   $0x1036ba,(%esp)
  1019a9:	e8 64 e9 ff ff       	call   100312 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  1019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b1:	8b 40 0c             	mov    0xc(%eax),%eax
  1019b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019b8:	c7 04 24 c9 36 10 00 	movl   $0x1036c9,(%esp)
  1019bf:	e8 4e e9 ff ff       	call   100312 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  1019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c7:	8b 40 10             	mov    0x10(%eax),%eax
  1019ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019ce:	c7 04 24 d8 36 10 00 	movl   $0x1036d8,(%esp)
  1019d5:	e8 38 e9 ff ff       	call   100312 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  1019da:	8b 45 08             	mov    0x8(%ebp),%eax
  1019dd:	8b 40 14             	mov    0x14(%eax),%eax
  1019e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019e4:	c7 04 24 e7 36 10 00 	movl   $0x1036e7,(%esp)
  1019eb:	e8 22 e9 ff ff       	call   100312 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  1019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f3:	8b 40 18             	mov    0x18(%eax),%eax
  1019f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019fa:	c7 04 24 f6 36 10 00 	movl   $0x1036f6,(%esp)
  101a01:	e8 0c e9 ff ff       	call   100312 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101a06:	8b 45 08             	mov    0x8(%ebp),%eax
  101a09:	8b 40 1c             	mov    0x1c(%eax),%eax
  101a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a10:	c7 04 24 05 37 10 00 	movl   $0x103705,(%esp)
  101a17:	e8 f6 e8 ff ff       	call   100312 <cprintf>
}
  101a1c:	c9                   	leave  
  101a1d:	c3                   	ret    

00101a1e <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101a1e:	55                   	push   %ebp
  101a1f:	89 e5                	mov    %esp,%ebp
  101a21:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101a24:	8b 45 08             	mov    0x8(%ebp),%eax
  101a27:	8b 40 30             	mov    0x30(%eax),%eax
  101a2a:	83 f8 2f             	cmp    $0x2f,%eax
  101a2d:	77 1e                	ja     101a4d <trap_dispatch+0x2f>
  101a2f:	83 f8 2e             	cmp    $0x2e,%eax
  101a32:	0f 83 bf 00 00 00    	jae    101af7 <trap_dispatch+0xd9>
  101a38:	83 f8 21             	cmp    $0x21,%eax
  101a3b:	74 40                	je     101a7d <trap_dispatch+0x5f>
  101a3d:	83 f8 24             	cmp    $0x24,%eax
  101a40:	74 15                	je     101a57 <trap_dispatch+0x39>
  101a42:	83 f8 20             	cmp    $0x20,%eax
  101a45:	0f 84 af 00 00 00    	je     101afa <trap_dispatch+0xdc>
  101a4b:	eb 72                	jmp    101abf <trap_dispatch+0xa1>
  101a4d:	83 e8 78             	sub    $0x78,%eax
  101a50:	83 f8 01             	cmp    $0x1,%eax
  101a53:	77 6a                	ja     101abf <trap_dispatch+0xa1>
  101a55:	eb 4c                	jmp    101aa3 <trap_dispatch+0x85>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101a57:	e8 b5 fa ff ff       	call   101511 <cons_getc>
  101a5c:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101a5f:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101a63:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101a67:	89 54 24 08          	mov    %edx,0x8(%esp)
  101a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a6f:	c7 04 24 14 37 10 00 	movl   $0x103714,(%esp)
  101a76:	e8 97 e8 ff ff       	call   100312 <cprintf>
        break;
  101a7b:	eb 7e                	jmp    101afb <trap_dispatch+0xdd>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101a7d:	e8 8f fa ff ff       	call   101511 <cons_getc>
  101a82:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101a85:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101a89:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101a8d:	89 54 24 08          	mov    %edx,0x8(%esp)
  101a91:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a95:	c7 04 24 26 37 10 00 	movl   $0x103726,(%esp)
  101a9c:	e8 71 e8 ff ff       	call   100312 <cprintf>
        break;
  101aa1:	eb 58                	jmp    101afb <trap_dispatch+0xdd>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101aa3:	c7 44 24 08 35 37 10 	movl   $0x103735,0x8(%esp)
  101aaa:	00 
  101aab:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  101ab2:	00 
  101ab3:	c7 04 24 45 37 10 00 	movl   $0x103745,(%esp)
  101aba:	e8 23 f1 ff ff       	call   100be2 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101abf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ac6:	0f b7 c0             	movzwl %ax,%eax
  101ac9:	83 e0 03             	and    $0x3,%eax
  101acc:	85 c0                	test   %eax,%eax
  101ace:	75 2b                	jne    101afb <trap_dispatch+0xdd>
            print_trapframe(tf);
  101ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad3:	89 04 24             	mov    %eax,(%esp)
  101ad6:	e8 c7 fc ff ff       	call   1017a2 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101adb:	c7 44 24 08 56 37 10 	movl   $0x103756,0x8(%esp)
  101ae2:	00 
  101ae3:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  101aea:	00 
  101aeb:	c7 04 24 45 37 10 00 	movl   $0x103745,(%esp)
  101af2:	e8 eb f0 ff ff       	call   100be2 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101af7:	90                   	nop
  101af8:	eb 01                	jmp    101afb <trap_dispatch+0xdd>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
  101afa:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101afb:	c9                   	leave  
  101afc:	c3                   	ret    

00101afd <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101afd:	55                   	push   %ebp
  101afe:	89 e5                	mov    %esp,%ebp
  101b00:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101b03:	8b 45 08             	mov    0x8(%ebp),%eax
  101b06:	89 04 24             	mov    %eax,(%esp)
  101b09:	e8 10 ff ff ff       	call   101a1e <trap_dispatch>
}
  101b0e:	c9                   	leave  
  101b0f:	c3                   	ret    

00101b10 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101b10:	1e                   	push   %ds
    pushl %es
  101b11:	06                   	push   %es
    pushl %fs
  101b12:	0f a0                	push   %fs
    pushl %gs
  101b14:	0f a8                	push   %gs
    pushal
  101b16:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101b17:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101b1c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101b1e:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101b20:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101b21:	e8 d7 ff ff ff       	call   101afd <trap>

    # pop the pushed stack pointer
    popl %esp
  101b26:	5c                   	pop    %esp

00101b27 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101b27:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101b28:	0f a9                	pop    %gs
    popl %fs
  101b2a:	0f a1                	pop    %fs
    popl %es
  101b2c:	07                   	pop    %es
    popl %ds
  101b2d:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101b2e:	83 c4 08             	add    $0x8,%esp
    iret
  101b31:	cf                   	iret   

00101b32 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101b32:	6a 00                	push   $0x0
  pushl $0
  101b34:	6a 00                	push   $0x0
  jmp __alltraps
  101b36:	e9 d5 ff ff ff       	jmp    101b10 <__alltraps>

00101b3b <vector1>:
.globl vector1
vector1:
  pushl $0
  101b3b:	6a 00                	push   $0x0
  pushl $1
  101b3d:	6a 01                	push   $0x1
  jmp __alltraps
  101b3f:	e9 cc ff ff ff       	jmp    101b10 <__alltraps>

00101b44 <vector2>:
.globl vector2
vector2:
  pushl $0
  101b44:	6a 00                	push   $0x0
  pushl $2
  101b46:	6a 02                	push   $0x2
  jmp __alltraps
  101b48:	e9 c3 ff ff ff       	jmp    101b10 <__alltraps>

00101b4d <vector3>:
.globl vector3
vector3:
  pushl $0
  101b4d:	6a 00                	push   $0x0
  pushl $3
  101b4f:	6a 03                	push   $0x3
  jmp __alltraps
  101b51:	e9 ba ff ff ff       	jmp    101b10 <__alltraps>

00101b56 <vector4>:
.globl vector4
vector4:
  pushl $0
  101b56:	6a 00                	push   $0x0
  pushl $4
  101b58:	6a 04                	push   $0x4
  jmp __alltraps
  101b5a:	e9 b1 ff ff ff       	jmp    101b10 <__alltraps>

00101b5f <vector5>:
.globl vector5
vector5:
  pushl $0
  101b5f:	6a 00                	push   $0x0
  pushl $5
  101b61:	6a 05                	push   $0x5
  jmp __alltraps
  101b63:	e9 a8 ff ff ff       	jmp    101b10 <__alltraps>

00101b68 <vector6>:
.globl vector6
vector6:
  pushl $0
  101b68:	6a 00                	push   $0x0
  pushl $6
  101b6a:	6a 06                	push   $0x6
  jmp __alltraps
  101b6c:	e9 9f ff ff ff       	jmp    101b10 <__alltraps>

00101b71 <vector7>:
.globl vector7
vector7:
  pushl $0
  101b71:	6a 00                	push   $0x0
  pushl $7
  101b73:	6a 07                	push   $0x7
  jmp __alltraps
  101b75:	e9 96 ff ff ff       	jmp    101b10 <__alltraps>

00101b7a <vector8>:
.globl vector8
vector8:
  pushl $8
  101b7a:	6a 08                	push   $0x8
  jmp __alltraps
  101b7c:	e9 8f ff ff ff       	jmp    101b10 <__alltraps>

00101b81 <vector9>:
.globl vector9
vector9:
  pushl $0
  101b81:	6a 00                	push   $0x0
  pushl $9
  101b83:	6a 09                	push   $0x9
  jmp __alltraps
  101b85:	e9 86 ff ff ff       	jmp    101b10 <__alltraps>

00101b8a <vector10>:
.globl vector10
vector10:
  pushl $10
  101b8a:	6a 0a                	push   $0xa
  jmp __alltraps
  101b8c:	e9 7f ff ff ff       	jmp    101b10 <__alltraps>

00101b91 <vector11>:
.globl vector11
vector11:
  pushl $11
  101b91:	6a 0b                	push   $0xb
  jmp __alltraps
  101b93:	e9 78 ff ff ff       	jmp    101b10 <__alltraps>

00101b98 <vector12>:
.globl vector12
vector12:
  pushl $12
  101b98:	6a 0c                	push   $0xc
  jmp __alltraps
  101b9a:	e9 71 ff ff ff       	jmp    101b10 <__alltraps>

00101b9f <vector13>:
.globl vector13
vector13:
  pushl $13
  101b9f:	6a 0d                	push   $0xd
  jmp __alltraps
  101ba1:	e9 6a ff ff ff       	jmp    101b10 <__alltraps>

00101ba6 <vector14>:
.globl vector14
vector14:
  pushl $14
  101ba6:	6a 0e                	push   $0xe
  jmp __alltraps
  101ba8:	e9 63 ff ff ff       	jmp    101b10 <__alltraps>

00101bad <vector15>:
.globl vector15
vector15:
  pushl $0
  101bad:	6a 00                	push   $0x0
  pushl $15
  101baf:	6a 0f                	push   $0xf
  jmp __alltraps
  101bb1:	e9 5a ff ff ff       	jmp    101b10 <__alltraps>

00101bb6 <vector16>:
.globl vector16
vector16:
  pushl $0
  101bb6:	6a 00                	push   $0x0
  pushl $16
  101bb8:	6a 10                	push   $0x10
  jmp __alltraps
  101bba:	e9 51 ff ff ff       	jmp    101b10 <__alltraps>

00101bbf <vector17>:
.globl vector17
vector17:
  pushl $17
  101bbf:	6a 11                	push   $0x11
  jmp __alltraps
  101bc1:	e9 4a ff ff ff       	jmp    101b10 <__alltraps>

00101bc6 <vector18>:
.globl vector18
vector18:
  pushl $0
  101bc6:	6a 00                	push   $0x0
  pushl $18
  101bc8:	6a 12                	push   $0x12
  jmp __alltraps
  101bca:	e9 41 ff ff ff       	jmp    101b10 <__alltraps>

00101bcf <vector19>:
.globl vector19
vector19:
  pushl $0
  101bcf:	6a 00                	push   $0x0
  pushl $19
  101bd1:	6a 13                	push   $0x13
  jmp __alltraps
  101bd3:	e9 38 ff ff ff       	jmp    101b10 <__alltraps>

00101bd8 <vector20>:
.globl vector20
vector20:
  pushl $0
  101bd8:	6a 00                	push   $0x0
  pushl $20
  101bda:	6a 14                	push   $0x14
  jmp __alltraps
  101bdc:	e9 2f ff ff ff       	jmp    101b10 <__alltraps>

00101be1 <vector21>:
.globl vector21
vector21:
  pushl $0
  101be1:	6a 00                	push   $0x0
  pushl $21
  101be3:	6a 15                	push   $0x15
  jmp __alltraps
  101be5:	e9 26 ff ff ff       	jmp    101b10 <__alltraps>

00101bea <vector22>:
.globl vector22
vector22:
  pushl $0
  101bea:	6a 00                	push   $0x0
  pushl $22
  101bec:	6a 16                	push   $0x16
  jmp __alltraps
  101bee:	e9 1d ff ff ff       	jmp    101b10 <__alltraps>

00101bf3 <vector23>:
.globl vector23
vector23:
  pushl $0
  101bf3:	6a 00                	push   $0x0
  pushl $23
  101bf5:	6a 17                	push   $0x17
  jmp __alltraps
  101bf7:	e9 14 ff ff ff       	jmp    101b10 <__alltraps>

00101bfc <vector24>:
.globl vector24
vector24:
  pushl $0
  101bfc:	6a 00                	push   $0x0
  pushl $24
  101bfe:	6a 18                	push   $0x18
  jmp __alltraps
  101c00:	e9 0b ff ff ff       	jmp    101b10 <__alltraps>

00101c05 <vector25>:
.globl vector25
vector25:
  pushl $0
  101c05:	6a 00                	push   $0x0
  pushl $25
  101c07:	6a 19                	push   $0x19
  jmp __alltraps
  101c09:	e9 02 ff ff ff       	jmp    101b10 <__alltraps>

00101c0e <vector26>:
.globl vector26
vector26:
  pushl $0
  101c0e:	6a 00                	push   $0x0
  pushl $26
  101c10:	6a 1a                	push   $0x1a
  jmp __alltraps
  101c12:	e9 f9 fe ff ff       	jmp    101b10 <__alltraps>

00101c17 <vector27>:
.globl vector27
vector27:
  pushl $0
  101c17:	6a 00                	push   $0x0
  pushl $27
  101c19:	6a 1b                	push   $0x1b
  jmp __alltraps
  101c1b:	e9 f0 fe ff ff       	jmp    101b10 <__alltraps>

00101c20 <vector28>:
.globl vector28
vector28:
  pushl $0
  101c20:	6a 00                	push   $0x0
  pushl $28
  101c22:	6a 1c                	push   $0x1c
  jmp __alltraps
  101c24:	e9 e7 fe ff ff       	jmp    101b10 <__alltraps>

00101c29 <vector29>:
.globl vector29
vector29:
  pushl $0
  101c29:	6a 00                	push   $0x0
  pushl $29
  101c2b:	6a 1d                	push   $0x1d
  jmp __alltraps
  101c2d:	e9 de fe ff ff       	jmp    101b10 <__alltraps>

00101c32 <vector30>:
.globl vector30
vector30:
  pushl $0
  101c32:	6a 00                	push   $0x0
  pushl $30
  101c34:	6a 1e                	push   $0x1e
  jmp __alltraps
  101c36:	e9 d5 fe ff ff       	jmp    101b10 <__alltraps>

00101c3b <vector31>:
.globl vector31
vector31:
  pushl $0
  101c3b:	6a 00                	push   $0x0
  pushl $31
  101c3d:	6a 1f                	push   $0x1f
  jmp __alltraps
  101c3f:	e9 cc fe ff ff       	jmp    101b10 <__alltraps>

00101c44 <vector32>:
.globl vector32
vector32:
  pushl $0
  101c44:	6a 00                	push   $0x0
  pushl $32
  101c46:	6a 20                	push   $0x20
  jmp __alltraps
  101c48:	e9 c3 fe ff ff       	jmp    101b10 <__alltraps>

00101c4d <vector33>:
.globl vector33
vector33:
  pushl $0
  101c4d:	6a 00                	push   $0x0
  pushl $33
  101c4f:	6a 21                	push   $0x21
  jmp __alltraps
  101c51:	e9 ba fe ff ff       	jmp    101b10 <__alltraps>

00101c56 <vector34>:
.globl vector34
vector34:
  pushl $0
  101c56:	6a 00                	push   $0x0
  pushl $34
  101c58:	6a 22                	push   $0x22
  jmp __alltraps
  101c5a:	e9 b1 fe ff ff       	jmp    101b10 <__alltraps>

00101c5f <vector35>:
.globl vector35
vector35:
  pushl $0
  101c5f:	6a 00                	push   $0x0
  pushl $35
  101c61:	6a 23                	push   $0x23
  jmp __alltraps
  101c63:	e9 a8 fe ff ff       	jmp    101b10 <__alltraps>

00101c68 <vector36>:
.globl vector36
vector36:
  pushl $0
  101c68:	6a 00                	push   $0x0
  pushl $36
  101c6a:	6a 24                	push   $0x24
  jmp __alltraps
  101c6c:	e9 9f fe ff ff       	jmp    101b10 <__alltraps>

00101c71 <vector37>:
.globl vector37
vector37:
  pushl $0
  101c71:	6a 00                	push   $0x0
  pushl $37
  101c73:	6a 25                	push   $0x25
  jmp __alltraps
  101c75:	e9 96 fe ff ff       	jmp    101b10 <__alltraps>

00101c7a <vector38>:
.globl vector38
vector38:
  pushl $0
  101c7a:	6a 00                	push   $0x0
  pushl $38
  101c7c:	6a 26                	push   $0x26
  jmp __alltraps
  101c7e:	e9 8d fe ff ff       	jmp    101b10 <__alltraps>

00101c83 <vector39>:
.globl vector39
vector39:
  pushl $0
  101c83:	6a 00                	push   $0x0
  pushl $39
  101c85:	6a 27                	push   $0x27
  jmp __alltraps
  101c87:	e9 84 fe ff ff       	jmp    101b10 <__alltraps>

00101c8c <vector40>:
.globl vector40
vector40:
  pushl $0
  101c8c:	6a 00                	push   $0x0
  pushl $40
  101c8e:	6a 28                	push   $0x28
  jmp __alltraps
  101c90:	e9 7b fe ff ff       	jmp    101b10 <__alltraps>

00101c95 <vector41>:
.globl vector41
vector41:
  pushl $0
  101c95:	6a 00                	push   $0x0
  pushl $41
  101c97:	6a 29                	push   $0x29
  jmp __alltraps
  101c99:	e9 72 fe ff ff       	jmp    101b10 <__alltraps>

00101c9e <vector42>:
.globl vector42
vector42:
  pushl $0
  101c9e:	6a 00                	push   $0x0
  pushl $42
  101ca0:	6a 2a                	push   $0x2a
  jmp __alltraps
  101ca2:	e9 69 fe ff ff       	jmp    101b10 <__alltraps>

00101ca7 <vector43>:
.globl vector43
vector43:
  pushl $0
  101ca7:	6a 00                	push   $0x0
  pushl $43
  101ca9:	6a 2b                	push   $0x2b
  jmp __alltraps
  101cab:	e9 60 fe ff ff       	jmp    101b10 <__alltraps>

00101cb0 <vector44>:
.globl vector44
vector44:
  pushl $0
  101cb0:	6a 00                	push   $0x0
  pushl $44
  101cb2:	6a 2c                	push   $0x2c
  jmp __alltraps
  101cb4:	e9 57 fe ff ff       	jmp    101b10 <__alltraps>

00101cb9 <vector45>:
.globl vector45
vector45:
  pushl $0
  101cb9:	6a 00                	push   $0x0
  pushl $45
  101cbb:	6a 2d                	push   $0x2d
  jmp __alltraps
  101cbd:	e9 4e fe ff ff       	jmp    101b10 <__alltraps>

00101cc2 <vector46>:
.globl vector46
vector46:
  pushl $0
  101cc2:	6a 00                	push   $0x0
  pushl $46
  101cc4:	6a 2e                	push   $0x2e
  jmp __alltraps
  101cc6:	e9 45 fe ff ff       	jmp    101b10 <__alltraps>

00101ccb <vector47>:
.globl vector47
vector47:
  pushl $0
  101ccb:	6a 00                	push   $0x0
  pushl $47
  101ccd:	6a 2f                	push   $0x2f
  jmp __alltraps
  101ccf:	e9 3c fe ff ff       	jmp    101b10 <__alltraps>

00101cd4 <vector48>:
.globl vector48
vector48:
  pushl $0
  101cd4:	6a 00                	push   $0x0
  pushl $48
  101cd6:	6a 30                	push   $0x30
  jmp __alltraps
  101cd8:	e9 33 fe ff ff       	jmp    101b10 <__alltraps>

00101cdd <vector49>:
.globl vector49
vector49:
  pushl $0
  101cdd:	6a 00                	push   $0x0
  pushl $49
  101cdf:	6a 31                	push   $0x31
  jmp __alltraps
  101ce1:	e9 2a fe ff ff       	jmp    101b10 <__alltraps>

00101ce6 <vector50>:
.globl vector50
vector50:
  pushl $0
  101ce6:	6a 00                	push   $0x0
  pushl $50
  101ce8:	6a 32                	push   $0x32
  jmp __alltraps
  101cea:	e9 21 fe ff ff       	jmp    101b10 <__alltraps>

00101cef <vector51>:
.globl vector51
vector51:
  pushl $0
  101cef:	6a 00                	push   $0x0
  pushl $51
  101cf1:	6a 33                	push   $0x33
  jmp __alltraps
  101cf3:	e9 18 fe ff ff       	jmp    101b10 <__alltraps>

00101cf8 <vector52>:
.globl vector52
vector52:
  pushl $0
  101cf8:	6a 00                	push   $0x0
  pushl $52
  101cfa:	6a 34                	push   $0x34
  jmp __alltraps
  101cfc:	e9 0f fe ff ff       	jmp    101b10 <__alltraps>

00101d01 <vector53>:
.globl vector53
vector53:
  pushl $0
  101d01:	6a 00                	push   $0x0
  pushl $53
  101d03:	6a 35                	push   $0x35
  jmp __alltraps
  101d05:	e9 06 fe ff ff       	jmp    101b10 <__alltraps>

00101d0a <vector54>:
.globl vector54
vector54:
  pushl $0
  101d0a:	6a 00                	push   $0x0
  pushl $54
  101d0c:	6a 36                	push   $0x36
  jmp __alltraps
  101d0e:	e9 fd fd ff ff       	jmp    101b10 <__alltraps>

00101d13 <vector55>:
.globl vector55
vector55:
  pushl $0
  101d13:	6a 00                	push   $0x0
  pushl $55
  101d15:	6a 37                	push   $0x37
  jmp __alltraps
  101d17:	e9 f4 fd ff ff       	jmp    101b10 <__alltraps>

00101d1c <vector56>:
.globl vector56
vector56:
  pushl $0
  101d1c:	6a 00                	push   $0x0
  pushl $56
  101d1e:	6a 38                	push   $0x38
  jmp __alltraps
  101d20:	e9 eb fd ff ff       	jmp    101b10 <__alltraps>

00101d25 <vector57>:
.globl vector57
vector57:
  pushl $0
  101d25:	6a 00                	push   $0x0
  pushl $57
  101d27:	6a 39                	push   $0x39
  jmp __alltraps
  101d29:	e9 e2 fd ff ff       	jmp    101b10 <__alltraps>

00101d2e <vector58>:
.globl vector58
vector58:
  pushl $0
  101d2e:	6a 00                	push   $0x0
  pushl $58
  101d30:	6a 3a                	push   $0x3a
  jmp __alltraps
  101d32:	e9 d9 fd ff ff       	jmp    101b10 <__alltraps>

00101d37 <vector59>:
.globl vector59
vector59:
  pushl $0
  101d37:	6a 00                	push   $0x0
  pushl $59
  101d39:	6a 3b                	push   $0x3b
  jmp __alltraps
  101d3b:	e9 d0 fd ff ff       	jmp    101b10 <__alltraps>

00101d40 <vector60>:
.globl vector60
vector60:
  pushl $0
  101d40:	6a 00                	push   $0x0
  pushl $60
  101d42:	6a 3c                	push   $0x3c
  jmp __alltraps
  101d44:	e9 c7 fd ff ff       	jmp    101b10 <__alltraps>

00101d49 <vector61>:
.globl vector61
vector61:
  pushl $0
  101d49:	6a 00                	push   $0x0
  pushl $61
  101d4b:	6a 3d                	push   $0x3d
  jmp __alltraps
  101d4d:	e9 be fd ff ff       	jmp    101b10 <__alltraps>

00101d52 <vector62>:
.globl vector62
vector62:
  pushl $0
  101d52:	6a 00                	push   $0x0
  pushl $62
  101d54:	6a 3e                	push   $0x3e
  jmp __alltraps
  101d56:	e9 b5 fd ff ff       	jmp    101b10 <__alltraps>

00101d5b <vector63>:
.globl vector63
vector63:
  pushl $0
  101d5b:	6a 00                	push   $0x0
  pushl $63
  101d5d:	6a 3f                	push   $0x3f
  jmp __alltraps
  101d5f:	e9 ac fd ff ff       	jmp    101b10 <__alltraps>

00101d64 <vector64>:
.globl vector64
vector64:
  pushl $0
  101d64:	6a 00                	push   $0x0
  pushl $64
  101d66:	6a 40                	push   $0x40
  jmp __alltraps
  101d68:	e9 a3 fd ff ff       	jmp    101b10 <__alltraps>

00101d6d <vector65>:
.globl vector65
vector65:
  pushl $0
  101d6d:	6a 00                	push   $0x0
  pushl $65
  101d6f:	6a 41                	push   $0x41
  jmp __alltraps
  101d71:	e9 9a fd ff ff       	jmp    101b10 <__alltraps>

00101d76 <vector66>:
.globl vector66
vector66:
  pushl $0
  101d76:	6a 00                	push   $0x0
  pushl $66
  101d78:	6a 42                	push   $0x42
  jmp __alltraps
  101d7a:	e9 91 fd ff ff       	jmp    101b10 <__alltraps>

00101d7f <vector67>:
.globl vector67
vector67:
  pushl $0
  101d7f:	6a 00                	push   $0x0
  pushl $67
  101d81:	6a 43                	push   $0x43
  jmp __alltraps
  101d83:	e9 88 fd ff ff       	jmp    101b10 <__alltraps>

00101d88 <vector68>:
.globl vector68
vector68:
  pushl $0
  101d88:	6a 00                	push   $0x0
  pushl $68
  101d8a:	6a 44                	push   $0x44
  jmp __alltraps
  101d8c:	e9 7f fd ff ff       	jmp    101b10 <__alltraps>

00101d91 <vector69>:
.globl vector69
vector69:
  pushl $0
  101d91:	6a 00                	push   $0x0
  pushl $69
  101d93:	6a 45                	push   $0x45
  jmp __alltraps
  101d95:	e9 76 fd ff ff       	jmp    101b10 <__alltraps>

00101d9a <vector70>:
.globl vector70
vector70:
  pushl $0
  101d9a:	6a 00                	push   $0x0
  pushl $70
  101d9c:	6a 46                	push   $0x46
  jmp __alltraps
  101d9e:	e9 6d fd ff ff       	jmp    101b10 <__alltraps>

00101da3 <vector71>:
.globl vector71
vector71:
  pushl $0
  101da3:	6a 00                	push   $0x0
  pushl $71
  101da5:	6a 47                	push   $0x47
  jmp __alltraps
  101da7:	e9 64 fd ff ff       	jmp    101b10 <__alltraps>

00101dac <vector72>:
.globl vector72
vector72:
  pushl $0
  101dac:	6a 00                	push   $0x0
  pushl $72
  101dae:	6a 48                	push   $0x48
  jmp __alltraps
  101db0:	e9 5b fd ff ff       	jmp    101b10 <__alltraps>

00101db5 <vector73>:
.globl vector73
vector73:
  pushl $0
  101db5:	6a 00                	push   $0x0
  pushl $73
  101db7:	6a 49                	push   $0x49
  jmp __alltraps
  101db9:	e9 52 fd ff ff       	jmp    101b10 <__alltraps>

00101dbe <vector74>:
.globl vector74
vector74:
  pushl $0
  101dbe:	6a 00                	push   $0x0
  pushl $74
  101dc0:	6a 4a                	push   $0x4a
  jmp __alltraps
  101dc2:	e9 49 fd ff ff       	jmp    101b10 <__alltraps>

00101dc7 <vector75>:
.globl vector75
vector75:
  pushl $0
  101dc7:	6a 00                	push   $0x0
  pushl $75
  101dc9:	6a 4b                	push   $0x4b
  jmp __alltraps
  101dcb:	e9 40 fd ff ff       	jmp    101b10 <__alltraps>

00101dd0 <vector76>:
.globl vector76
vector76:
  pushl $0
  101dd0:	6a 00                	push   $0x0
  pushl $76
  101dd2:	6a 4c                	push   $0x4c
  jmp __alltraps
  101dd4:	e9 37 fd ff ff       	jmp    101b10 <__alltraps>

00101dd9 <vector77>:
.globl vector77
vector77:
  pushl $0
  101dd9:	6a 00                	push   $0x0
  pushl $77
  101ddb:	6a 4d                	push   $0x4d
  jmp __alltraps
  101ddd:	e9 2e fd ff ff       	jmp    101b10 <__alltraps>

00101de2 <vector78>:
.globl vector78
vector78:
  pushl $0
  101de2:	6a 00                	push   $0x0
  pushl $78
  101de4:	6a 4e                	push   $0x4e
  jmp __alltraps
  101de6:	e9 25 fd ff ff       	jmp    101b10 <__alltraps>

00101deb <vector79>:
.globl vector79
vector79:
  pushl $0
  101deb:	6a 00                	push   $0x0
  pushl $79
  101ded:	6a 4f                	push   $0x4f
  jmp __alltraps
  101def:	e9 1c fd ff ff       	jmp    101b10 <__alltraps>

00101df4 <vector80>:
.globl vector80
vector80:
  pushl $0
  101df4:	6a 00                	push   $0x0
  pushl $80
  101df6:	6a 50                	push   $0x50
  jmp __alltraps
  101df8:	e9 13 fd ff ff       	jmp    101b10 <__alltraps>

00101dfd <vector81>:
.globl vector81
vector81:
  pushl $0
  101dfd:	6a 00                	push   $0x0
  pushl $81
  101dff:	6a 51                	push   $0x51
  jmp __alltraps
  101e01:	e9 0a fd ff ff       	jmp    101b10 <__alltraps>

00101e06 <vector82>:
.globl vector82
vector82:
  pushl $0
  101e06:	6a 00                	push   $0x0
  pushl $82
  101e08:	6a 52                	push   $0x52
  jmp __alltraps
  101e0a:	e9 01 fd ff ff       	jmp    101b10 <__alltraps>

00101e0f <vector83>:
.globl vector83
vector83:
  pushl $0
  101e0f:	6a 00                	push   $0x0
  pushl $83
  101e11:	6a 53                	push   $0x53
  jmp __alltraps
  101e13:	e9 f8 fc ff ff       	jmp    101b10 <__alltraps>

00101e18 <vector84>:
.globl vector84
vector84:
  pushl $0
  101e18:	6a 00                	push   $0x0
  pushl $84
  101e1a:	6a 54                	push   $0x54
  jmp __alltraps
  101e1c:	e9 ef fc ff ff       	jmp    101b10 <__alltraps>

00101e21 <vector85>:
.globl vector85
vector85:
  pushl $0
  101e21:	6a 00                	push   $0x0
  pushl $85
  101e23:	6a 55                	push   $0x55
  jmp __alltraps
  101e25:	e9 e6 fc ff ff       	jmp    101b10 <__alltraps>

00101e2a <vector86>:
.globl vector86
vector86:
  pushl $0
  101e2a:	6a 00                	push   $0x0
  pushl $86
  101e2c:	6a 56                	push   $0x56
  jmp __alltraps
  101e2e:	e9 dd fc ff ff       	jmp    101b10 <__alltraps>

00101e33 <vector87>:
.globl vector87
vector87:
  pushl $0
  101e33:	6a 00                	push   $0x0
  pushl $87
  101e35:	6a 57                	push   $0x57
  jmp __alltraps
  101e37:	e9 d4 fc ff ff       	jmp    101b10 <__alltraps>

00101e3c <vector88>:
.globl vector88
vector88:
  pushl $0
  101e3c:	6a 00                	push   $0x0
  pushl $88
  101e3e:	6a 58                	push   $0x58
  jmp __alltraps
  101e40:	e9 cb fc ff ff       	jmp    101b10 <__alltraps>

00101e45 <vector89>:
.globl vector89
vector89:
  pushl $0
  101e45:	6a 00                	push   $0x0
  pushl $89
  101e47:	6a 59                	push   $0x59
  jmp __alltraps
  101e49:	e9 c2 fc ff ff       	jmp    101b10 <__alltraps>

00101e4e <vector90>:
.globl vector90
vector90:
  pushl $0
  101e4e:	6a 00                	push   $0x0
  pushl $90
  101e50:	6a 5a                	push   $0x5a
  jmp __alltraps
  101e52:	e9 b9 fc ff ff       	jmp    101b10 <__alltraps>

00101e57 <vector91>:
.globl vector91
vector91:
  pushl $0
  101e57:	6a 00                	push   $0x0
  pushl $91
  101e59:	6a 5b                	push   $0x5b
  jmp __alltraps
  101e5b:	e9 b0 fc ff ff       	jmp    101b10 <__alltraps>

00101e60 <vector92>:
.globl vector92
vector92:
  pushl $0
  101e60:	6a 00                	push   $0x0
  pushl $92
  101e62:	6a 5c                	push   $0x5c
  jmp __alltraps
  101e64:	e9 a7 fc ff ff       	jmp    101b10 <__alltraps>

00101e69 <vector93>:
.globl vector93
vector93:
  pushl $0
  101e69:	6a 00                	push   $0x0
  pushl $93
  101e6b:	6a 5d                	push   $0x5d
  jmp __alltraps
  101e6d:	e9 9e fc ff ff       	jmp    101b10 <__alltraps>

00101e72 <vector94>:
.globl vector94
vector94:
  pushl $0
  101e72:	6a 00                	push   $0x0
  pushl $94
  101e74:	6a 5e                	push   $0x5e
  jmp __alltraps
  101e76:	e9 95 fc ff ff       	jmp    101b10 <__alltraps>

00101e7b <vector95>:
.globl vector95
vector95:
  pushl $0
  101e7b:	6a 00                	push   $0x0
  pushl $95
  101e7d:	6a 5f                	push   $0x5f
  jmp __alltraps
  101e7f:	e9 8c fc ff ff       	jmp    101b10 <__alltraps>

00101e84 <vector96>:
.globl vector96
vector96:
  pushl $0
  101e84:	6a 00                	push   $0x0
  pushl $96
  101e86:	6a 60                	push   $0x60
  jmp __alltraps
  101e88:	e9 83 fc ff ff       	jmp    101b10 <__alltraps>

00101e8d <vector97>:
.globl vector97
vector97:
  pushl $0
  101e8d:	6a 00                	push   $0x0
  pushl $97
  101e8f:	6a 61                	push   $0x61
  jmp __alltraps
  101e91:	e9 7a fc ff ff       	jmp    101b10 <__alltraps>

00101e96 <vector98>:
.globl vector98
vector98:
  pushl $0
  101e96:	6a 00                	push   $0x0
  pushl $98
  101e98:	6a 62                	push   $0x62
  jmp __alltraps
  101e9a:	e9 71 fc ff ff       	jmp    101b10 <__alltraps>

00101e9f <vector99>:
.globl vector99
vector99:
  pushl $0
  101e9f:	6a 00                	push   $0x0
  pushl $99
  101ea1:	6a 63                	push   $0x63
  jmp __alltraps
  101ea3:	e9 68 fc ff ff       	jmp    101b10 <__alltraps>

00101ea8 <vector100>:
.globl vector100
vector100:
  pushl $0
  101ea8:	6a 00                	push   $0x0
  pushl $100
  101eaa:	6a 64                	push   $0x64
  jmp __alltraps
  101eac:	e9 5f fc ff ff       	jmp    101b10 <__alltraps>

00101eb1 <vector101>:
.globl vector101
vector101:
  pushl $0
  101eb1:	6a 00                	push   $0x0
  pushl $101
  101eb3:	6a 65                	push   $0x65
  jmp __alltraps
  101eb5:	e9 56 fc ff ff       	jmp    101b10 <__alltraps>

00101eba <vector102>:
.globl vector102
vector102:
  pushl $0
  101eba:	6a 00                	push   $0x0
  pushl $102
  101ebc:	6a 66                	push   $0x66
  jmp __alltraps
  101ebe:	e9 4d fc ff ff       	jmp    101b10 <__alltraps>

00101ec3 <vector103>:
.globl vector103
vector103:
  pushl $0
  101ec3:	6a 00                	push   $0x0
  pushl $103
  101ec5:	6a 67                	push   $0x67
  jmp __alltraps
  101ec7:	e9 44 fc ff ff       	jmp    101b10 <__alltraps>

00101ecc <vector104>:
.globl vector104
vector104:
  pushl $0
  101ecc:	6a 00                	push   $0x0
  pushl $104
  101ece:	6a 68                	push   $0x68
  jmp __alltraps
  101ed0:	e9 3b fc ff ff       	jmp    101b10 <__alltraps>

00101ed5 <vector105>:
.globl vector105
vector105:
  pushl $0
  101ed5:	6a 00                	push   $0x0
  pushl $105
  101ed7:	6a 69                	push   $0x69
  jmp __alltraps
  101ed9:	e9 32 fc ff ff       	jmp    101b10 <__alltraps>

00101ede <vector106>:
.globl vector106
vector106:
  pushl $0
  101ede:	6a 00                	push   $0x0
  pushl $106
  101ee0:	6a 6a                	push   $0x6a
  jmp __alltraps
  101ee2:	e9 29 fc ff ff       	jmp    101b10 <__alltraps>

00101ee7 <vector107>:
.globl vector107
vector107:
  pushl $0
  101ee7:	6a 00                	push   $0x0
  pushl $107
  101ee9:	6a 6b                	push   $0x6b
  jmp __alltraps
  101eeb:	e9 20 fc ff ff       	jmp    101b10 <__alltraps>

00101ef0 <vector108>:
.globl vector108
vector108:
  pushl $0
  101ef0:	6a 00                	push   $0x0
  pushl $108
  101ef2:	6a 6c                	push   $0x6c
  jmp __alltraps
  101ef4:	e9 17 fc ff ff       	jmp    101b10 <__alltraps>

00101ef9 <vector109>:
.globl vector109
vector109:
  pushl $0
  101ef9:	6a 00                	push   $0x0
  pushl $109
  101efb:	6a 6d                	push   $0x6d
  jmp __alltraps
  101efd:	e9 0e fc ff ff       	jmp    101b10 <__alltraps>

00101f02 <vector110>:
.globl vector110
vector110:
  pushl $0
  101f02:	6a 00                	push   $0x0
  pushl $110
  101f04:	6a 6e                	push   $0x6e
  jmp __alltraps
  101f06:	e9 05 fc ff ff       	jmp    101b10 <__alltraps>

00101f0b <vector111>:
.globl vector111
vector111:
  pushl $0
  101f0b:	6a 00                	push   $0x0
  pushl $111
  101f0d:	6a 6f                	push   $0x6f
  jmp __alltraps
  101f0f:	e9 fc fb ff ff       	jmp    101b10 <__alltraps>

00101f14 <vector112>:
.globl vector112
vector112:
  pushl $0
  101f14:	6a 00                	push   $0x0
  pushl $112
  101f16:	6a 70                	push   $0x70
  jmp __alltraps
  101f18:	e9 f3 fb ff ff       	jmp    101b10 <__alltraps>

00101f1d <vector113>:
.globl vector113
vector113:
  pushl $0
  101f1d:	6a 00                	push   $0x0
  pushl $113
  101f1f:	6a 71                	push   $0x71
  jmp __alltraps
  101f21:	e9 ea fb ff ff       	jmp    101b10 <__alltraps>

00101f26 <vector114>:
.globl vector114
vector114:
  pushl $0
  101f26:	6a 00                	push   $0x0
  pushl $114
  101f28:	6a 72                	push   $0x72
  jmp __alltraps
  101f2a:	e9 e1 fb ff ff       	jmp    101b10 <__alltraps>

00101f2f <vector115>:
.globl vector115
vector115:
  pushl $0
  101f2f:	6a 00                	push   $0x0
  pushl $115
  101f31:	6a 73                	push   $0x73
  jmp __alltraps
  101f33:	e9 d8 fb ff ff       	jmp    101b10 <__alltraps>

00101f38 <vector116>:
.globl vector116
vector116:
  pushl $0
  101f38:	6a 00                	push   $0x0
  pushl $116
  101f3a:	6a 74                	push   $0x74
  jmp __alltraps
  101f3c:	e9 cf fb ff ff       	jmp    101b10 <__alltraps>

00101f41 <vector117>:
.globl vector117
vector117:
  pushl $0
  101f41:	6a 00                	push   $0x0
  pushl $117
  101f43:	6a 75                	push   $0x75
  jmp __alltraps
  101f45:	e9 c6 fb ff ff       	jmp    101b10 <__alltraps>

00101f4a <vector118>:
.globl vector118
vector118:
  pushl $0
  101f4a:	6a 00                	push   $0x0
  pushl $118
  101f4c:	6a 76                	push   $0x76
  jmp __alltraps
  101f4e:	e9 bd fb ff ff       	jmp    101b10 <__alltraps>

00101f53 <vector119>:
.globl vector119
vector119:
  pushl $0
  101f53:	6a 00                	push   $0x0
  pushl $119
  101f55:	6a 77                	push   $0x77
  jmp __alltraps
  101f57:	e9 b4 fb ff ff       	jmp    101b10 <__alltraps>

00101f5c <vector120>:
.globl vector120
vector120:
  pushl $0
  101f5c:	6a 00                	push   $0x0
  pushl $120
  101f5e:	6a 78                	push   $0x78
  jmp __alltraps
  101f60:	e9 ab fb ff ff       	jmp    101b10 <__alltraps>

00101f65 <vector121>:
.globl vector121
vector121:
  pushl $0
  101f65:	6a 00                	push   $0x0
  pushl $121
  101f67:	6a 79                	push   $0x79
  jmp __alltraps
  101f69:	e9 a2 fb ff ff       	jmp    101b10 <__alltraps>

00101f6e <vector122>:
.globl vector122
vector122:
  pushl $0
  101f6e:	6a 00                	push   $0x0
  pushl $122
  101f70:	6a 7a                	push   $0x7a
  jmp __alltraps
  101f72:	e9 99 fb ff ff       	jmp    101b10 <__alltraps>

00101f77 <vector123>:
.globl vector123
vector123:
  pushl $0
  101f77:	6a 00                	push   $0x0
  pushl $123
  101f79:	6a 7b                	push   $0x7b
  jmp __alltraps
  101f7b:	e9 90 fb ff ff       	jmp    101b10 <__alltraps>

00101f80 <vector124>:
.globl vector124
vector124:
  pushl $0
  101f80:	6a 00                	push   $0x0
  pushl $124
  101f82:	6a 7c                	push   $0x7c
  jmp __alltraps
  101f84:	e9 87 fb ff ff       	jmp    101b10 <__alltraps>

00101f89 <vector125>:
.globl vector125
vector125:
  pushl $0
  101f89:	6a 00                	push   $0x0
  pushl $125
  101f8b:	6a 7d                	push   $0x7d
  jmp __alltraps
  101f8d:	e9 7e fb ff ff       	jmp    101b10 <__alltraps>

00101f92 <vector126>:
.globl vector126
vector126:
  pushl $0
  101f92:	6a 00                	push   $0x0
  pushl $126
  101f94:	6a 7e                	push   $0x7e
  jmp __alltraps
  101f96:	e9 75 fb ff ff       	jmp    101b10 <__alltraps>

00101f9b <vector127>:
.globl vector127
vector127:
  pushl $0
  101f9b:	6a 00                	push   $0x0
  pushl $127
  101f9d:	6a 7f                	push   $0x7f
  jmp __alltraps
  101f9f:	e9 6c fb ff ff       	jmp    101b10 <__alltraps>

00101fa4 <vector128>:
.globl vector128
vector128:
  pushl $0
  101fa4:	6a 00                	push   $0x0
  pushl $128
  101fa6:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  101fab:	e9 60 fb ff ff       	jmp    101b10 <__alltraps>

00101fb0 <vector129>:
.globl vector129
vector129:
  pushl $0
  101fb0:	6a 00                	push   $0x0
  pushl $129
  101fb2:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  101fb7:	e9 54 fb ff ff       	jmp    101b10 <__alltraps>

00101fbc <vector130>:
.globl vector130
vector130:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $130
  101fbe:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  101fc3:	e9 48 fb ff ff       	jmp    101b10 <__alltraps>

00101fc8 <vector131>:
.globl vector131
vector131:
  pushl $0
  101fc8:	6a 00                	push   $0x0
  pushl $131
  101fca:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  101fcf:	e9 3c fb ff ff       	jmp    101b10 <__alltraps>

00101fd4 <vector132>:
.globl vector132
vector132:
  pushl $0
  101fd4:	6a 00                	push   $0x0
  pushl $132
  101fd6:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  101fdb:	e9 30 fb ff ff       	jmp    101b10 <__alltraps>

00101fe0 <vector133>:
.globl vector133
vector133:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $133
  101fe2:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  101fe7:	e9 24 fb ff ff       	jmp    101b10 <__alltraps>

00101fec <vector134>:
.globl vector134
vector134:
  pushl $0
  101fec:	6a 00                	push   $0x0
  pushl $134
  101fee:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  101ff3:	e9 18 fb ff ff       	jmp    101b10 <__alltraps>

00101ff8 <vector135>:
.globl vector135
vector135:
  pushl $0
  101ff8:	6a 00                	push   $0x0
  pushl $135
  101ffa:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  101fff:	e9 0c fb ff ff       	jmp    101b10 <__alltraps>

00102004 <vector136>:
.globl vector136
vector136:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $136
  102006:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10200b:	e9 00 fb ff ff       	jmp    101b10 <__alltraps>

00102010 <vector137>:
.globl vector137
vector137:
  pushl $0
  102010:	6a 00                	push   $0x0
  pushl $137
  102012:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102017:	e9 f4 fa ff ff       	jmp    101b10 <__alltraps>

0010201c <vector138>:
.globl vector138
vector138:
  pushl $0
  10201c:	6a 00                	push   $0x0
  pushl $138
  10201e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102023:	e9 e8 fa ff ff       	jmp    101b10 <__alltraps>

00102028 <vector139>:
.globl vector139
vector139:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $139
  10202a:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10202f:	e9 dc fa ff ff       	jmp    101b10 <__alltraps>

00102034 <vector140>:
.globl vector140
vector140:
  pushl $0
  102034:	6a 00                	push   $0x0
  pushl $140
  102036:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10203b:	e9 d0 fa ff ff       	jmp    101b10 <__alltraps>

00102040 <vector141>:
.globl vector141
vector141:
  pushl $0
  102040:	6a 00                	push   $0x0
  pushl $141
  102042:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102047:	e9 c4 fa ff ff       	jmp    101b10 <__alltraps>

0010204c <vector142>:
.globl vector142
vector142:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $142
  10204e:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102053:	e9 b8 fa ff ff       	jmp    101b10 <__alltraps>

00102058 <vector143>:
.globl vector143
vector143:
  pushl $0
  102058:	6a 00                	push   $0x0
  pushl $143
  10205a:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10205f:	e9 ac fa ff ff       	jmp    101b10 <__alltraps>

00102064 <vector144>:
.globl vector144
vector144:
  pushl $0
  102064:	6a 00                	push   $0x0
  pushl $144
  102066:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10206b:	e9 a0 fa ff ff       	jmp    101b10 <__alltraps>

00102070 <vector145>:
.globl vector145
vector145:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $145
  102072:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102077:	e9 94 fa ff ff       	jmp    101b10 <__alltraps>

0010207c <vector146>:
.globl vector146
vector146:
  pushl $0
  10207c:	6a 00                	push   $0x0
  pushl $146
  10207e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102083:	e9 88 fa ff ff       	jmp    101b10 <__alltraps>

00102088 <vector147>:
.globl vector147
vector147:
  pushl $0
  102088:	6a 00                	push   $0x0
  pushl $147
  10208a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10208f:	e9 7c fa ff ff       	jmp    101b10 <__alltraps>

00102094 <vector148>:
.globl vector148
vector148:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $148
  102096:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10209b:	e9 70 fa ff ff       	jmp    101b10 <__alltraps>

001020a0 <vector149>:
.globl vector149
vector149:
  pushl $0
  1020a0:	6a 00                	push   $0x0
  pushl $149
  1020a2:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1020a7:	e9 64 fa ff ff       	jmp    101b10 <__alltraps>

001020ac <vector150>:
.globl vector150
vector150:
  pushl $0
  1020ac:	6a 00                	push   $0x0
  pushl $150
  1020ae:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1020b3:	e9 58 fa ff ff       	jmp    101b10 <__alltraps>

001020b8 <vector151>:
.globl vector151
vector151:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $151
  1020ba:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1020bf:	e9 4c fa ff ff       	jmp    101b10 <__alltraps>

001020c4 <vector152>:
.globl vector152
vector152:
  pushl $0
  1020c4:	6a 00                	push   $0x0
  pushl $152
  1020c6:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1020cb:	e9 40 fa ff ff       	jmp    101b10 <__alltraps>

001020d0 <vector153>:
.globl vector153
vector153:
  pushl $0
  1020d0:	6a 00                	push   $0x0
  pushl $153
  1020d2:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1020d7:	e9 34 fa ff ff       	jmp    101b10 <__alltraps>

001020dc <vector154>:
.globl vector154
vector154:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $154
  1020de:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1020e3:	e9 28 fa ff ff       	jmp    101b10 <__alltraps>

001020e8 <vector155>:
.globl vector155
vector155:
  pushl $0
  1020e8:	6a 00                	push   $0x0
  pushl $155
  1020ea:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1020ef:	e9 1c fa ff ff       	jmp    101b10 <__alltraps>

001020f4 <vector156>:
.globl vector156
vector156:
  pushl $0
  1020f4:	6a 00                	push   $0x0
  pushl $156
  1020f6:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1020fb:	e9 10 fa ff ff       	jmp    101b10 <__alltraps>

00102100 <vector157>:
.globl vector157
vector157:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $157
  102102:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102107:	e9 04 fa ff ff       	jmp    101b10 <__alltraps>

0010210c <vector158>:
.globl vector158
vector158:
  pushl $0
  10210c:	6a 00                	push   $0x0
  pushl $158
  10210e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102113:	e9 f8 f9 ff ff       	jmp    101b10 <__alltraps>

00102118 <vector159>:
.globl vector159
vector159:
  pushl $0
  102118:	6a 00                	push   $0x0
  pushl $159
  10211a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10211f:	e9 ec f9 ff ff       	jmp    101b10 <__alltraps>

00102124 <vector160>:
.globl vector160
vector160:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $160
  102126:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10212b:	e9 e0 f9 ff ff       	jmp    101b10 <__alltraps>

00102130 <vector161>:
.globl vector161
vector161:
  pushl $0
  102130:	6a 00                	push   $0x0
  pushl $161
  102132:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102137:	e9 d4 f9 ff ff       	jmp    101b10 <__alltraps>

0010213c <vector162>:
.globl vector162
vector162:
  pushl $0
  10213c:	6a 00                	push   $0x0
  pushl $162
  10213e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102143:	e9 c8 f9 ff ff       	jmp    101b10 <__alltraps>

00102148 <vector163>:
.globl vector163
vector163:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $163
  10214a:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10214f:	e9 bc f9 ff ff       	jmp    101b10 <__alltraps>

00102154 <vector164>:
.globl vector164
vector164:
  pushl $0
  102154:	6a 00                	push   $0x0
  pushl $164
  102156:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10215b:	e9 b0 f9 ff ff       	jmp    101b10 <__alltraps>

00102160 <vector165>:
.globl vector165
vector165:
  pushl $0
  102160:	6a 00                	push   $0x0
  pushl $165
  102162:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102167:	e9 a4 f9 ff ff       	jmp    101b10 <__alltraps>

0010216c <vector166>:
.globl vector166
vector166:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $166
  10216e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102173:	e9 98 f9 ff ff       	jmp    101b10 <__alltraps>

00102178 <vector167>:
.globl vector167
vector167:
  pushl $0
  102178:	6a 00                	push   $0x0
  pushl $167
  10217a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10217f:	e9 8c f9 ff ff       	jmp    101b10 <__alltraps>

00102184 <vector168>:
.globl vector168
vector168:
  pushl $0
  102184:	6a 00                	push   $0x0
  pushl $168
  102186:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10218b:	e9 80 f9 ff ff       	jmp    101b10 <__alltraps>

00102190 <vector169>:
.globl vector169
vector169:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $169
  102192:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102197:	e9 74 f9 ff ff       	jmp    101b10 <__alltraps>

0010219c <vector170>:
.globl vector170
vector170:
  pushl $0
  10219c:	6a 00                	push   $0x0
  pushl $170
  10219e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1021a3:	e9 68 f9 ff ff       	jmp    101b10 <__alltraps>

001021a8 <vector171>:
.globl vector171
vector171:
  pushl $0
  1021a8:	6a 00                	push   $0x0
  pushl $171
  1021aa:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1021af:	e9 5c f9 ff ff       	jmp    101b10 <__alltraps>

001021b4 <vector172>:
.globl vector172
vector172:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $172
  1021b6:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1021bb:	e9 50 f9 ff ff       	jmp    101b10 <__alltraps>

001021c0 <vector173>:
.globl vector173
vector173:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $173
  1021c2:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1021c7:	e9 44 f9 ff ff       	jmp    101b10 <__alltraps>

001021cc <vector174>:
.globl vector174
vector174:
  pushl $0
  1021cc:	6a 00                	push   $0x0
  pushl $174
  1021ce:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1021d3:	e9 38 f9 ff ff       	jmp    101b10 <__alltraps>

001021d8 <vector175>:
.globl vector175
vector175:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $175
  1021da:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1021df:	e9 2c f9 ff ff       	jmp    101b10 <__alltraps>

001021e4 <vector176>:
.globl vector176
vector176:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $176
  1021e6:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1021eb:	e9 20 f9 ff ff       	jmp    101b10 <__alltraps>

001021f0 <vector177>:
.globl vector177
vector177:
  pushl $0
  1021f0:	6a 00                	push   $0x0
  pushl $177
  1021f2:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1021f7:	e9 14 f9 ff ff       	jmp    101b10 <__alltraps>

001021fc <vector178>:
.globl vector178
vector178:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $178
  1021fe:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102203:	e9 08 f9 ff ff       	jmp    101b10 <__alltraps>

00102208 <vector179>:
.globl vector179
vector179:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $179
  10220a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10220f:	e9 fc f8 ff ff       	jmp    101b10 <__alltraps>

00102214 <vector180>:
.globl vector180
vector180:
  pushl $0
  102214:	6a 00                	push   $0x0
  pushl $180
  102216:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10221b:	e9 f0 f8 ff ff       	jmp    101b10 <__alltraps>

00102220 <vector181>:
.globl vector181
vector181:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $181
  102222:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102227:	e9 e4 f8 ff ff       	jmp    101b10 <__alltraps>

0010222c <vector182>:
.globl vector182
vector182:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $182
  10222e:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102233:	e9 d8 f8 ff ff       	jmp    101b10 <__alltraps>

00102238 <vector183>:
.globl vector183
vector183:
  pushl $0
  102238:	6a 00                	push   $0x0
  pushl $183
  10223a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10223f:	e9 cc f8 ff ff       	jmp    101b10 <__alltraps>

00102244 <vector184>:
.globl vector184
vector184:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $184
  102246:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10224b:	e9 c0 f8 ff ff       	jmp    101b10 <__alltraps>

00102250 <vector185>:
.globl vector185
vector185:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $185
  102252:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102257:	e9 b4 f8 ff ff       	jmp    101b10 <__alltraps>

0010225c <vector186>:
.globl vector186
vector186:
  pushl $0
  10225c:	6a 00                	push   $0x0
  pushl $186
  10225e:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102263:	e9 a8 f8 ff ff       	jmp    101b10 <__alltraps>

00102268 <vector187>:
.globl vector187
vector187:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $187
  10226a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10226f:	e9 9c f8 ff ff       	jmp    101b10 <__alltraps>

00102274 <vector188>:
.globl vector188
vector188:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $188
  102276:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10227b:	e9 90 f8 ff ff       	jmp    101b10 <__alltraps>

00102280 <vector189>:
.globl vector189
vector189:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $189
  102282:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102287:	e9 84 f8 ff ff       	jmp    101b10 <__alltraps>

0010228c <vector190>:
.globl vector190
vector190:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $190
  10228e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102293:	e9 78 f8 ff ff       	jmp    101b10 <__alltraps>

00102298 <vector191>:
.globl vector191
vector191:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $191
  10229a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10229f:	e9 6c f8 ff ff       	jmp    101b10 <__alltraps>

001022a4 <vector192>:
.globl vector192
vector192:
  pushl $0
  1022a4:	6a 00                	push   $0x0
  pushl $192
  1022a6:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1022ab:	e9 60 f8 ff ff       	jmp    101b10 <__alltraps>

001022b0 <vector193>:
.globl vector193
vector193:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $193
  1022b2:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1022b7:	e9 54 f8 ff ff       	jmp    101b10 <__alltraps>

001022bc <vector194>:
.globl vector194
vector194:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $194
  1022be:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1022c3:	e9 48 f8 ff ff       	jmp    101b10 <__alltraps>

001022c8 <vector195>:
.globl vector195
vector195:
  pushl $0
  1022c8:	6a 00                	push   $0x0
  pushl $195
  1022ca:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1022cf:	e9 3c f8 ff ff       	jmp    101b10 <__alltraps>

001022d4 <vector196>:
.globl vector196
vector196:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $196
  1022d6:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1022db:	e9 30 f8 ff ff       	jmp    101b10 <__alltraps>

001022e0 <vector197>:
.globl vector197
vector197:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $197
  1022e2:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1022e7:	e9 24 f8 ff ff       	jmp    101b10 <__alltraps>

001022ec <vector198>:
.globl vector198
vector198:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $198
  1022ee:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1022f3:	e9 18 f8 ff ff       	jmp    101b10 <__alltraps>

001022f8 <vector199>:
.globl vector199
vector199:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $199
  1022fa:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1022ff:	e9 0c f8 ff ff       	jmp    101b10 <__alltraps>

00102304 <vector200>:
.globl vector200
vector200:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $200
  102306:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10230b:	e9 00 f8 ff ff       	jmp    101b10 <__alltraps>

00102310 <vector201>:
.globl vector201
vector201:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $201
  102312:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102317:	e9 f4 f7 ff ff       	jmp    101b10 <__alltraps>

0010231c <vector202>:
.globl vector202
vector202:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $202
  10231e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102323:	e9 e8 f7 ff ff       	jmp    101b10 <__alltraps>

00102328 <vector203>:
.globl vector203
vector203:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $203
  10232a:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10232f:	e9 dc f7 ff ff       	jmp    101b10 <__alltraps>

00102334 <vector204>:
.globl vector204
vector204:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $204
  102336:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10233b:	e9 d0 f7 ff ff       	jmp    101b10 <__alltraps>

00102340 <vector205>:
.globl vector205
vector205:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $205
  102342:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102347:	e9 c4 f7 ff ff       	jmp    101b10 <__alltraps>

0010234c <vector206>:
.globl vector206
vector206:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $206
  10234e:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102353:	e9 b8 f7 ff ff       	jmp    101b10 <__alltraps>

00102358 <vector207>:
.globl vector207
vector207:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $207
  10235a:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10235f:	e9 ac f7 ff ff       	jmp    101b10 <__alltraps>

00102364 <vector208>:
.globl vector208
vector208:
  pushl $0
  102364:	6a 00                	push   $0x0
  pushl $208
  102366:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10236b:	e9 a0 f7 ff ff       	jmp    101b10 <__alltraps>

00102370 <vector209>:
.globl vector209
vector209:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $209
  102372:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102377:	e9 94 f7 ff ff       	jmp    101b10 <__alltraps>

0010237c <vector210>:
.globl vector210
vector210:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $210
  10237e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102383:	e9 88 f7 ff ff       	jmp    101b10 <__alltraps>

00102388 <vector211>:
.globl vector211
vector211:
  pushl $0
  102388:	6a 00                	push   $0x0
  pushl $211
  10238a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10238f:	e9 7c f7 ff ff       	jmp    101b10 <__alltraps>

00102394 <vector212>:
.globl vector212
vector212:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $212
  102396:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10239b:	e9 70 f7 ff ff       	jmp    101b10 <__alltraps>

001023a0 <vector213>:
.globl vector213
vector213:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $213
  1023a2:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1023a7:	e9 64 f7 ff ff       	jmp    101b10 <__alltraps>

001023ac <vector214>:
.globl vector214
vector214:
  pushl $0
  1023ac:	6a 00                	push   $0x0
  pushl $214
  1023ae:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1023b3:	e9 58 f7 ff ff       	jmp    101b10 <__alltraps>

001023b8 <vector215>:
.globl vector215
vector215:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $215
  1023ba:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1023bf:	e9 4c f7 ff ff       	jmp    101b10 <__alltraps>

001023c4 <vector216>:
.globl vector216
vector216:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $216
  1023c6:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1023cb:	e9 40 f7 ff ff       	jmp    101b10 <__alltraps>

001023d0 <vector217>:
.globl vector217
vector217:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $217
  1023d2:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1023d7:	e9 34 f7 ff ff       	jmp    101b10 <__alltraps>

001023dc <vector218>:
.globl vector218
vector218:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $218
  1023de:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1023e3:	e9 28 f7 ff ff       	jmp    101b10 <__alltraps>

001023e8 <vector219>:
.globl vector219
vector219:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $219
  1023ea:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1023ef:	e9 1c f7 ff ff       	jmp    101b10 <__alltraps>

001023f4 <vector220>:
.globl vector220
vector220:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $220
  1023f6:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1023fb:	e9 10 f7 ff ff       	jmp    101b10 <__alltraps>

00102400 <vector221>:
.globl vector221
vector221:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $221
  102402:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102407:	e9 04 f7 ff ff       	jmp    101b10 <__alltraps>

0010240c <vector222>:
.globl vector222
vector222:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $222
  10240e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102413:	e9 f8 f6 ff ff       	jmp    101b10 <__alltraps>

00102418 <vector223>:
.globl vector223
vector223:
  pushl $0
  102418:	6a 00                	push   $0x0
  pushl $223
  10241a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10241f:	e9 ec f6 ff ff       	jmp    101b10 <__alltraps>

00102424 <vector224>:
.globl vector224
vector224:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $224
  102426:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10242b:	e9 e0 f6 ff ff       	jmp    101b10 <__alltraps>

00102430 <vector225>:
.globl vector225
vector225:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $225
  102432:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102437:	e9 d4 f6 ff ff       	jmp    101b10 <__alltraps>

0010243c <vector226>:
.globl vector226
vector226:
  pushl $0
  10243c:	6a 00                	push   $0x0
  pushl $226
  10243e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102443:	e9 c8 f6 ff ff       	jmp    101b10 <__alltraps>

00102448 <vector227>:
.globl vector227
vector227:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $227
  10244a:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10244f:	e9 bc f6 ff ff       	jmp    101b10 <__alltraps>

00102454 <vector228>:
.globl vector228
vector228:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $228
  102456:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10245b:	e9 b0 f6 ff ff       	jmp    101b10 <__alltraps>

00102460 <vector229>:
.globl vector229
vector229:
  pushl $0
  102460:	6a 00                	push   $0x0
  pushl $229
  102462:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102467:	e9 a4 f6 ff ff       	jmp    101b10 <__alltraps>

0010246c <vector230>:
.globl vector230
vector230:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $230
  10246e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102473:	e9 98 f6 ff ff       	jmp    101b10 <__alltraps>

00102478 <vector231>:
.globl vector231
vector231:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $231
  10247a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10247f:	e9 8c f6 ff ff       	jmp    101b10 <__alltraps>

00102484 <vector232>:
.globl vector232
vector232:
  pushl $0
  102484:	6a 00                	push   $0x0
  pushl $232
  102486:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10248b:	e9 80 f6 ff ff       	jmp    101b10 <__alltraps>

00102490 <vector233>:
.globl vector233
vector233:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $233
  102492:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102497:	e9 74 f6 ff ff       	jmp    101b10 <__alltraps>

0010249c <vector234>:
.globl vector234
vector234:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $234
  10249e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1024a3:	e9 68 f6 ff ff       	jmp    101b10 <__alltraps>

001024a8 <vector235>:
.globl vector235
vector235:
  pushl $0
  1024a8:	6a 00                	push   $0x0
  pushl $235
  1024aa:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1024af:	e9 5c f6 ff ff       	jmp    101b10 <__alltraps>

001024b4 <vector236>:
.globl vector236
vector236:
  pushl $0
  1024b4:	6a 00                	push   $0x0
  pushl $236
  1024b6:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1024bb:	e9 50 f6 ff ff       	jmp    101b10 <__alltraps>

001024c0 <vector237>:
.globl vector237
vector237:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $237
  1024c2:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1024c7:	e9 44 f6 ff ff       	jmp    101b10 <__alltraps>

001024cc <vector238>:
.globl vector238
vector238:
  pushl $0
  1024cc:	6a 00                	push   $0x0
  pushl $238
  1024ce:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1024d3:	e9 38 f6 ff ff       	jmp    101b10 <__alltraps>

001024d8 <vector239>:
.globl vector239
vector239:
  pushl $0
  1024d8:	6a 00                	push   $0x0
  pushl $239
  1024da:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1024df:	e9 2c f6 ff ff       	jmp    101b10 <__alltraps>

001024e4 <vector240>:
.globl vector240
vector240:
  pushl $0
  1024e4:	6a 00                	push   $0x0
  pushl $240
  1024e6:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1024eb:	e9 20 f6 ff ff       	jmp    101b10 <__alltraps>

001024f0 <vector241>:
.globl vector241
vector241:
  pushl $0
  1024f0:	6a 00                	push   $0x0
  pushl $241
  1024f2:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1024f7:	e9 14 f6 ff ff       	jmp    101b10 <__alltraps>

001024fc <vector242>:
.globl vector242
vector242:
  pushl $0
  1024fc:	6a 00                	push   $0x0
  pushl $242
  1024fe:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102503:	e9 08 f6 ff ff       	jmp    101b10 <__alltraps>

00102508 <vector243>:
.globl vector243
vector243:
  pushl $0
  102508:	6a 00                	push   $0x0
  pushl $243
  10250a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10250f:	e9 fc f5 ff ff       	jmp    101b10 <__alltraps>

00102514 <vector244>:
.globl vector244
vector244:
  pushl $0
  102514:	6a 00                	push   $0x0
  pushl $244
  102516:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10251b:	e9 f0 f5 ff ff       	jmp    101b10 <__alltraps>

00102520 <vector245>:
.globl vector245
vector245:
  pushl $0
  102520:	6a 00                	push   $0x0
  pushl $245
  102522:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102527:	e9 e4 f5 ff ff       	jmp    101b10 <__alltraps>

0010252c <vector246>:
.globl vector246
vector246:
  pushl $0
  10252c:	6a 00                	push   $0x0
  pushl $246
  10252e:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102533:	e9 d8 f5 ff ff       	jmp    101b10 <__alltraps>

00102538 <vector247>:
.globl vector247
vector247:
  pushl $0
  102538:	6a 00                	push   $0x0
  pushl $247
  10253a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10253f:	e9 cc f5 ff ff       	jmp    101b10 <__alltraps>

00102544 <vector248>:
.globl vector248
vector248:
  pushl $0
  102544:	6a 00                	push   $0x0
  pushl $248
  102546:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10254b:	e9 c0 f5 ff ff       	jmp    101b10 <__alltraps>

00102550 <vector249>:
.globl vector249
vector249:
  pushl $0
  102550:	6a 00                	push   $0x0
  pushl $249
  102552:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102557:	e9 b4 f5 ff ff       	jmp    101b10 <__alltraps>

0010255c <vector250>:
.globl vector250
vector250:
  pushl $0
  10255c:	6a 00                	push   $0x0
  pushl $250
  10255e:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102563:	e9 a8 f5 ff ff       	jmp    101b10 <__alltraps>

00102568 <vector251>:
.globl vector251
vector251:
  pushl $0
  102568:	6a 00                	push   $0x0
  pushl $251
  10256a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10256f:	e9 9c f5 ff ff       	jmp    101b10 <__alltraps>

00102574 <vector252>:
.globl vector252
vector252:
  pushl $0
  102574:	6a 00                	push   $0x0
  pushl $252
  102576:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10257b:	e9 90 f5 ff ff       	jmp    101b10 <__alltraps>

00102580 <vector253>:
.globl vector253
vector253:
  pushl $0
  102580:	6a 00                	push   $0x0
  pushl $253
  102582:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102587:	e9 84 f5 ff ff       	jmp    101b10 <__alltraps>

0010258c <vector254>:
.globl vector254
vector254:
  pushl $0
  10258c:	6a 00                	push   $0x0
  pushl $254
  10258e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102593:	e9 78 f5 ff ff       	jmp    101b10 <__alltraps>

00102598 <vector255>:
.globl vector255
vector255:
  pushl $0
  102598:	6a 00                	push   $0x0
  pushl $255
  10259a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10259f:	e9 6c f5 ff ff       	jmp    101b10 <__alltraps>

001025a4 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1025a4:	55                   	push   %ebp
  1025a5:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1025a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1025aa:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1025ad:	b8 23 00 00 00       	mov    $0x23,%eax
  1025b2:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1025b4:	b8 23 00 00 00       	mov    $0x23,%eax
  1025b9:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1025bb:	b8 10 00 00 00       	mov    $0x10,%eax
  1025c0:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1025c2:	b8 10 00 00 00       	mov    $0x10,%eax
  1025c7:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1025c9:	b8 10 00 00 00       	mov    $0x10,%eax
  1025ce:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1025d0:	ea d7 25 10 00 08 00 	ljmp   $0x8,$0x1025d7
}
  1025d7:	5d                   	pop    %ebp
  1025d8:	c3                   	ret    

001025d9 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1025d9:	55                   	push   %ebp
  1025da:	89 e5                	mov    %esp,%ebp
  1025dc:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1025df:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  1025e4:	05 00 04 00 00       	add    $0x400,%eax
  1025e9:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  1025ee:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1025f5:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1025f7:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1025fe:	68 00 
  102600:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102605:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  10260b:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102610:	c1 e8 10             	shr    $0x10,%eax
  102613:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  102618:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10261f:	83 e0 f0             	and    $0xfffffff0,%eax
  102622:	83 c8 09             	or     $0x9,%eax
  102625:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10262a:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102631:	83 c8 10             	or     $0x10,%eax
  102634:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102639:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102640:	83 e0 9f             	and    $0xffffff9f,%eax
  102643:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102648:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10264f:	83 c8 80             	or     $0xffffff80,%eax
  102652:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102657:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10265e:	83 e0 f0             	and    $0xfffffff0,%eax
  102661:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102666:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10266d:	83 e0 ef             	and    $0xffffffef,%eax
  102670:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102675:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10267c:	83 e0 df             	and    $0xffffffdf,%eax
  10267f:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102684:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10268b:	83 c8 40             	or     $0x40,%eax
  10268e:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102693:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10269a:	83 e0 7f             	and    $0x7f,%eax
  10269d:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1026a2:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1026a7:	c1 e8 18             	shr    $0x18,%eax
  1026aa:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  1026af:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026b6:	83 e0 ef             	and    $0xffffffef,%eax
  1026b9:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  1026be:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  1026c5:	e8 da fe ff ff       	call   1025a4 <lgdt>
  1026ca:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  1026d0:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1026d4:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  1026d7:	c9                   	leave  
  1026d8:	c3                   	ret    

001026d9 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  1026d9:	55                   	push   %ebp
  1026da:	89 e5                	mov    %esp,%ebp
    gdt_init();
  1026dc:	e8 f8 fe ff ff       	call   1025d9 <gdt_init>
}
  1026e1:	5d                   	pop    %ebp
  1026e2:	c3                   	ret    

001026e3 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1026e3:	55                   	push   %ebp
  1026e4:	89 e5                	mov    %esp,%ebp
  1026e6:	83 ec 58             	sub    $0x58,%esp
  1026e9:	8b 45 10             	mov    0x10(%ebp),%eax
  1026ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1026ef:	8b 45 14             	mov    0x14(%ebp),%eax
  1026f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1026f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1026f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1026fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1026fe:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102701:	8b 45 18             	mov    0x18(%ebp),%eax
  102704:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102707:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10270a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10270d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102710:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102716:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102719:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10271d:	74 1c                	je     10273b <printnum+0x58>
  10271f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102722:	ba 00 00 00 00       	mov    $0x0,%edx
  102727:	f7 75 e4             	divl   -0x1c(%ebp)
  10272a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10272d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102730:	ba 00 00 00 00       	mov    $0x0,%edx
  102735:	f7 75 e4             	divl   -0x1c(%ebp)
  102738:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10273b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10273e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102741:	f7 75 e4             	divl   -0x1c(%ebp)
  102744:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102747:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10274a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10274d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102750:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102753:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102756:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102759:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10275c:	8b 45 18             	mov    0x18(%ebp),%eax
  10275f:	ba 00 00 00 00       	mov    $0x0,%edx
  102764:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102767:	77 56                	ja     1027bf <printnum+0xdc>
  102769:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10276c:	72 05                	jb     102773 <printnum+0x90>
  10276e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102771:	77 4c                	ja     1027bf <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102773:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102776:	8d 50 ff             	lea    -0x1(%eax),%edx
  102779:	8b 45 20             	mov    0x20(%ebp),%eax
  10277c:	89 44 24 18          	mov    %eax,0x18(%esp)
  102780:	89 54 24 14          	mov    %edx,0x14(%esp)
  102784:	8b 45 18             	mov    0x18(%ebp),%eax
  102787:	89 44 24 10          	mov    %eax,0x10(%esp)
  10278b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10278e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102791:	89 44 24 08          	mov    %eax,0x8(%esp)
  102795:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102799:	8b 45 0c             	mov    0xc(%ebp),%eax
  10279c:	89 44 24 04          	mov    %eax,0x4(%esp)
  1027a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1027a3:	89 04 24             	mov    %eax,(%esp)
  1027a6:	e8 38 ff ff ff       	call   1026e3 <printnum>
  1027ab:	eb 1c                	jmp    1027c9 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1027ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1027b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1027b4:	8b 45 20             	mov    0x20(%ebp),%eax
  1027b7:	89 04 24             	mov    %eax,(%esp)
  1027ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1027bd:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1027bf:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1027c3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1027c7:	7f e4                	jg     1027ad <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1027c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1027cc:	05 90 39 10 00       	add    $0x103990,%eax
  1027d1:	0f b6 00             	movzbl (%eax),%eax
  1027d4:	0f be c0             	movsbl %al,%eax
  1027d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1027da:	89 54 24 04          	mov    %edx,0x4(%esp)
  1027de:	89 04 24             	mov    %eax,(%esp)
  1027e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1027e4:	ff d0                	call   *%eax
}
  1027e6:	c9                   	leave  
  1027e7:	c3                   	ret    

001027e8 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1027e8:	55                   	push   %ebp
  1027e9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1027eb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1027ef:	7e 14                	jle    102805 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1027f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1027f4:	8b 00                	mov    (%eax),%eax
  1027f6:	8d 48 08             	lea    0x8(%eax),%ecx
  1027f9:	8b 55 08             	mov    0x8(%ebp),%edx
  1027fc:	89 0a                	mov    %ecx,(%edx)
  1027fe:	8b 50 04             	mov    0x4(%eax),%edx
  102801:	8b 00                	mov    (%eax),%eax
  102803:	eb 30                	jmp    102835 <getuint+0x4d>
    }
    else if (lflag) {
  102805:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102809:	74 16                	je     102821 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10280b:	8b 45 08             	mov    0x8(%ebp),%eax
  10280e:	8b 00                	mov    (%eax),%eax
  102810:	8d 48 04             	lea    0x4(%eax),%ecx
  102813:	8b 55 08             	mov    0x8(%ebp),%edx
  102816:	89 0a                	mov    %ecx,(%edx)
  102818:	8b 00                	mov    (%eax),%eax
  10281a:	ba 00 00 00 00       	mov    $0x0,%edx
  10281f:	eb 14                	jmp    102835 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102821:	8b 45 08             	mov    0x8(%ebp),%eax
  102824:	8b 00                	mov    (%eax),%eax
  102826:	8d 48 04             	lea    0x4(%eax),%ecx
  102829:	8b 55 08             	mov    0x8(%ebp),%edx
  10282c:	89 0a                	mov    %ecx,(%edx)
  10282e:	8b 00                	mov    (%eax),%eax
  102830:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102835:	5d                   	pop    %ebp
  102836:	c3                   	ret    

00102837 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102837:	55                   	push   %ebp
  102838:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10283a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10283e:	7e 14                	jle    102854 <getint+0x1d>
        return va_arg(*ap, long long);
  102840:	8b 45 08             	mov    0x8(%ebp),%eax
  102843:	8b 00                	mov    (%eax),%eax
  102845:	8d 48 08             	lea    0x8(%eax),%ecx
  102848:	8b 55 08             	mov    0x8(%ebp),%edx
  10284b:	89 0a                	mov    %ecx,(%edx)
  10284d:	8b 50 04             	mov    0x4(%eax),%edx
  102850:	8b 00                	mov    (%eax),%eax
  102852:	eb 28                	jmp    10287c <getint+0x45>
    }
    else if (lflag) {
  102854:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102858:	74 12                	je     10286c <getint+0x35>
        return va_arg(*ap, long);
  10285a:	8b 45 08             	mov    0x8(%ebp),%eax
  10285d:	8b 00                	mov    (%eax),%eax
  10285f:	8d 48 04             	lea    0x4(%eax),%ecx
  102862:	8b 55 08             	mov    0x8(%ebp),%edx
  102865:	89 0a                	mov    %ecx,(%edx)
  102867:	8b 00                	mov    (%eax),%eax
  102869:	99                   	cltd   
  10286a:	eb 10                	jmp    10287c <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  10286c:	8b 45 08             	mov    0x8(%ebp),%eax
  10286f:	8b 00                	mov    (%eax),%eax
  102871:	8d 48 04             	lea    0x4(%eax),%ecx
  102874:	8b 55 08             	mov    0x8(%ebp),%edx
  102877:	89 0a                	mov    %ecx,(%edx)
  102879:	8b 00                	mov    (%eax),%eax
  10287b:	99                   	cltd   
    }
}
  10287c:	5d                   	pop    %ebp
  10287d:	c3                   	ret    

0010287e <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10287e:	55                   	push   %ebp
  10287f:	89 e5                	mov    %esp,%ebp
  102881:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102884:	8d 45 14             	lea    0x14(%ebp),%eax
  102887:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  10288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10288d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102891:	8b 45 10             	mov    0x10(%ebp),%eax
  102894:	89 44 24 08          	mov    %eax,0x8(%esp)
  102898:	8b 45 0c             	mov    0xc(%ebp),%eax
  10289b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10289f:	8b 45 08             	mov    0x8(%ebp),%eax
  1028a2:	89 04 24             	mov    %eax,(%esp)
  1028a5:	e8 02 00 00 00       	call   1028ac <vprintfmt>
    va_end(ap);
}
  1028aa:	c9                   	leave  
  1028ab:	c3                   	ret    

001028ac <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1028ac:	55                   	push   %ebp
  1028ad:	89 e5                	mov    %esp,%ebp
  1028af:	56                   	push   %esi
  1028b0:	53                   	push   %ebx
  1028b1:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1028b4:	eb 18                	jmp    1028ce <vprintfmt+0x22>
            if (ch == '\0') {
  1028b6:	85 db                	test   %ebx,%ebx
  1028b8:	75 05                	jne    1028bf <vprintfmt+0x13>
                return;
  1028ba:	e9 d1 03 00 00       	jmp    102c90 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  1028bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1028c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1028c6:	89 1c 24             	mov    %ebx,(%esp)
  1028c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1028cc:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1028ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1028d1:	8d 50 01             	lea    0x1(%eax),%edx
  1028d4:	89 55 10             	mov    %edx,0x10(%ebp)
  1028d7:	0f b6 00             	movzbl (%eax),%eax
  1028da:	0f b6 d8             	movzbl %al,%ebx
  1028dd:	83 fb 25             	cmp    $0x25,%ebx
  1028e0:	75 d4                	jne    1028b6 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  1028e2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1028e6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1028ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1028f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1028f3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1028fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1028fd:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102900:	8b 45 10             	mov    0x10(%ebp),%eax
  102903:	8d 50 01             	lea    0x1(%eax),%edx
  102906:	89 55 10             	mov    %edx,0x10(%ebp)
  102909:	0f b6 00             	movzbl (%eax),%eax
  10290c:	0f b6 d8             	movzbl %al,%ebx
  10290f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102912:	83 f8 55             	cmp    $0x55,%eax
  102915:	0f 87 44 03 00 00    	ja     102c5f <vprintfmt+0x3b3>
  10291b:	8b 04 85 b4 39 10 00 	mov    0x1039b4(,%eax,4),%eax
  102922:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102924:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102928:	eb d6                	jmp    102900 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10292a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10292e:	eb d0                	jmp    102900 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102930:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102937:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10293a:	89 d0                	mov    %edx,%eax
  10293c:	c1 e0 02             	shl    $0x2,%eax
  10293f:	01 d0                	add    %edx,%eax
  102941:	01 c0                	add    %eax,%eax
  102943:	01 d8                	add    %ebx,%eax
  102945:	83 e8 30             	sub    $0x30,%eax
  102948:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10294b:	8b 45 10             	mov    0x10(%ebp),%eax
  10294e:	0f b6 00             	movzbl (%eax),%eax
  102951:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102954:	83 fb 2f             	cmp    $0x2f,%ebx
  102957:	7e 0b                	jle    102964 <vprintfmt+0xb8>
  102959:	83 fb 39             	cmp    $0x39,%ebx
  10295c:	7f 06                	jg     102964 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10295e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102962:	eb d3                	jmp    102937 <vprintfmt+0x8b>
            goto process_precision;
  102964:	eb 33                	jmp    102999 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102966:	8b 45 14             	mov    0x14(%ebp),%eax
  102969:	8d 50 04             	lea    0x4(%eax),%edx
  10296c:	89 55 14             	mov    %edx,0x14(%ebp)
  10296f:	8b 00                	mov    (%eax),%eax
  102971:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102974:	eb 23                	jmp    102999 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102976:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10297a:	79 0c                	jns    102988 <vprintfmt+0xdc>
                width = 0;
  10297c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102983:	e9 78 ff ff ff       	jmp    102900 <vprintfmt+0x54>
  102988:	e9 73 ff ff ff       	jmp    102900 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  10298d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102994:	e9 67 ff ff ff       	jmp    102900 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102999:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10299d:	79 12                	jns    1029b1 <vprintfmt+0x105>
                width = precision, precision = -1;
  10299f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1029a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1029a5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1029ac:	e9 4f ff ff ff       	jmp    102900 <vprintfmt+0x54>
  1029b1:	e9 4a ff ff ff       	jmp    102900 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1029b6:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1029ba:	e9 41 ff ff ff       	jmp    102900 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1029bf:	8b 45 14             	mov    0x14(%ebp),%eax
  1029c2:	8d 50 04             	lea    0x4(%eax),%edx
  1029c5:	89 55 14             	mov    %edx,0x14(%ebp)
  1029c8:	8b 00                	mov    (%eax),%eax
  1029ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029cd:	89 54 24 04          	mov    %edx,0x4(%esp)
  1029d1:	89 04 24             	mov    %eax,(%esp)
  1029d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d7:	ff d0                	call   *%eax
            break;
  1029d9:	e9 ac 02 00 00       	jmp    102c8a <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1029de:	8b 45 14             	mov    0x14(%ebp),%eax
  1029e1:	8d 50 04             	lea    0x4(%eax),%edx
  1029e4:	89 55 14             	mov    %edx,0x14(%ebp)
  1029e7:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1029e9:	85 db                	test   %ebx,%ebx
  1029eb:	79 02                	jns    1029ef <vprintfmt+0x143>
                err = -err;
  1029ed:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1029ef:	83 fb 06             	cmp    $0x6,%ebx
  1029f2:	7f 0b                	jg     1029ff <vprintfmt+0x153>
  1029f4:	8b 34 9d 74 39 10 00 	mov    0x103974(,%ebx,4),%esi
  1029fb:	85 f6                	test   %esi,%esi
  1029fd:	75 23                	jne    102a22 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  1029ff:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102a03:	c7 44 24 08 a1 39 10 	movl   $0x1039a1,0x8(%esp)
  102a0a:	00 
  102a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a12:	8b 45 08             	mov    0x8(%ebp),%eax
  102a15:	89 04 24             	mov    %eax,(%esp)
  102a18:	e8 61 fe ff ff       	call   10287e <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102a1d:	e9 68 02 00 00       	jmp    102c8a <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102a22:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102a26:	c7 44 24 08 aa 39 10 	movl   $0x1039aa,0x8(%esp)
  102a2d:	00 
  102a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a31:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a35:	8b 45 08             	mov    0x8(%ebp),%eax
  102a38:	89 04 24             	mov    %eax,(%esp)
  102a3b:	e8 3e fe ff ff       	call   10287e <printfmt>
            }
            break;
  102a40:	e9 45 02 00 00       	jmp    102c8a <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102a45:	8b 45 14             	mov    0x14(%ebp),%eax
  102a48:	8d 50 04             	lea    0x4(%eax),%edx
  102a4b:	89 55 14             	mov    %edx,0x14(%ebp)
  102a4e:	8b 30                	mov    (%eax),%esi
  102a50:	85 f6                	test   %esi,%esi
  102a52:	75 05                	jne    102a59 <vprintfmt+0x1ad>
                p = "(null)";
  102a54:	be ad 39 10 00       	mov    $0x1039ad,%esi
            }
            if (width > 0 && padc != '-') {
  102a59:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102a5d:	7e 3e                	jle    102a9d <vprintfmt+0x1f1>
  102a5f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102a63:	74 38                	je     102a9d <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102a65:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102a68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a6f:	89 34 24             	mov    %esi,(%esp)
  102a72:	e8 15 03 00 00       	call   102d8c <strnlen>
  102a77:	29 c3                	sub    %eax,%ebx
  102a79:	89 d8                	mov    %ebx,%eax
  102a7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102a7e:	eb 17                	jmp    102a97 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102a80:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102a84:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a87:	89 54 24 04          	mov    %edx,0x4(%esp)
  102a8b:	89 04 24             	mov    %eax,(%esp)
  102a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a91:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102a93:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102a97:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102a9b:	7f e3                	jg     102a80 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102a9d:	eb 38                	jmp    102ad7 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102a9f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102aa3:	74 1f                	je     102ac4 <vprintfmt+0x218>
  102aa5:	83 fb 1f             	cmp    $0x1f,%ebx
  102aa8:	7e 05                	jle    102aaf <vprintfmt+0x203>
  102aaa:	83 fb 7e             	cmp    $0x7e,%ebx
  102aad:	7e 15                	jle    102ac4 <vprintfmt+0x218>
                    putch('?', putdat);
  102aaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ab6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102abd:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac0:	ff d0                	call   *%eax
  102ac2:	eb 0f                	jmp    102ad3 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ac7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102acb:	89 1c 24             	mov    %ebx,(%esp)
  102ace:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad1:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102ad3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102ad7:	89 f0                	mov    %esi,%eax
  102ad9:	8d 70 01             	lea    0x1(%eax),%esi
  102adc:	0f b6 00             	movzbl (%eax),%eax
  102adf:	0f be d8             	movsbl %al,%ebx
  102ae2:	85 db                	test   %ebx,%ebx
  102ae4:	74 10                	je     102af6 <vprintfmt+0x24a>
  102ae6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102aea:	78 b3                	js     102a9f <vprintfmt+0x1f3>
  102aec:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102af0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102af4:	79 a9                	jns    102a9f <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102af6:	eb 17                	jmp    102b0f <vprintfmt+0x263>
                putch(' ', putdat);
  102af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102afb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102aff:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102b06:	8b 45 08             	mov    0x8(%ebp),%eax
  102b09:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102b0b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102b0f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102b13:	7f e3                	jg     102af8 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102b15:	e9 70 01 00 00       	jmp    102c8a <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102b1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b21:	8d 45 14             	lea    0x14(%ebp),%eax
  102b24:	89 04 24             	mov    %eax,(%esp)
  102b27:	e8 0b fd ff ff       	call   102837 <getint>
  102b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b2f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b38:	85 d2                	test   %edx,%edx
  102b3a:	79 26                	jns    102b62 <vprintfmt+0x2b6>
                putch('-', putdat);
  102b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b43:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  102b4d:	ff d0                	call   *%eax
                num = -(long long)num;
  102b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b55:	f7 d8                	neg    %eax
  102b57:	83 d2 00             	adc    $0x0,%edx
  102b5a:	f7 da                	neg    %edx
  102b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b5f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102b62:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102b69:	e9 a8 00 00 00       	jmp    102c16 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102b6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b71:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b75:	8d 45 14             	lea    0x14(%ebp),%eax
  102b78:	89 04 24             	mov    %eax,(%esp)
  102b7b:	e8 68 fc ff ff       	call   1027e8 <getuint>
  102b80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b83:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102b86:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102b8d:	e9 84 00 00 00       	jmp    102c16 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102b92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b95:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b99:	8d 45 14             	lea    0x14(%ebp),%eax
  102b9c:	89 04 24             	mov    %eax,(%esp)
  102b9f:	e8 44 fc ff ff       	call   1027e8 <getuint>
  102ba4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ba7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102baa:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102bb1:	eb 63                	jmp    102c16 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bba:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc4:	ff d0                	call   *%eax
            putch('x', putdat);
  102bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bcd:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd7:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102bd9:	8b 45 14             	mov    0x14(%ebp),%eax
  102bdc:	8d 50 04             	lea    0x4(%eax),%edx
  102bdf:	89 55 14             	mov    %edx,0x14(%ebp)
  102be2:	8b 00                	mov    (%eax),%eax
  102be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102be7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102bee:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102bf5:	eb 1f                	jmp    102c16 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102bf7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bfe:	8d 45 14             	lea    0x14(%ebp),%eax
  102c01:	89 04 24             	mov    %eax,(%esp)
  102c04:	e8 df fb ff ff       	call   1027e8 <getuint>
  102c09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102c0f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102c16:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102c1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c1d:	89 54 24 18          	mov    %edx,0x18(%esp)
  102c21:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102c24:	89 54 24 14          	mov    %edx,0x14(%esp)
  102c28:	89 44 24 10          	mov    %eax,0x10(%esp)
  102c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102c32:	89 44 24 08          	mov    %eax,0x8(%esp)
  102c36:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c41:	8b 45 08             	mov    0x8(%ebp),%eax
  102c44:	89 04 24             	mov    %eax,(%esp)
  102c47:	e8 97 fa ff ff       	call   1026e3 <printnum>
            break;
  102c4c:	eb 3c                	jmp    102c8a <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c51:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c55:	89 1c 24             	mov    %ebx,(%esp)
  102c58:	8b 45 08             	mov    0x8(%ebp),%eax
  102c5b:	ff d0                	call   *%eax
            break;
  102c5d:	eb 2b                	jmp    102c8a <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c62:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c66:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c70:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102c72:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102c76:	eb 04                	jmp    102c7c <vprintfmt+0x3d0>
  102c78:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102c7c:	8b 45 10             	mov    0x10(%ebp),%eax
  102c7f:	83 e8 01             	sub    $0x1,%eax
  102c82:	0f b6 00             	movzbl (%eax),%eax
  102c85:	3c 25                	cmp    $0x25,%al
  102c87:	75 ef                	jne    102c78 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  102c89:	90                   	nop
        }
    }
  102c8a:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c8b:	e9 3e fc ff ff       	jmp    1028ce <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  102c90:	83 c4 40             	add    $0x40,%esp
  102c93:	5b                   	pop    %ebx
  102c94:	5e                   	pop    %esi
  102c95:	5d                   	pop    %ebp
  102c96:	c3                   	ret    

00102c97 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102c97:	55                   	push   %ebp
  102c98:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c9d:	8b 40 08             	mov    0x8(%eax),%eax
  102ca0:	8d 50 01             	lea    0x1(%eax),%edx
  102ca3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ca6:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cac:	8b 10                	mov    (%eax),%edx
  102cae:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cb1:	8b 40 04             	mov    0x4(%eax),%eax
  102cb4:	39 c2                	cmp    %eax,%edx
  102cb6:	73 12                	jae    102cca <sprintputch+0x33>
        *b->buf ++ = ch;
  102cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cbb:	8b 00                	mov    (%eax),%eax
  102cbd:	8d 48 01             	lea    0x1(%eax),%ecx
  102cc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cc3:	89 0a                	mov    %ecx,(%edx)
  102cc5:	8b 55 08             	mov    0x8(%ebp),%edx
  102cc8:	88 10                	mov    %dl,(%eax)
    }
}
  102cca:	5d                   	pop    %ebp
  102ccb:	c3                   	ret    

00102ccc <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102ccc:	55                   	push   %ebp
  102ccd:	89 e5                	mov    %esp,%ebp
  102ccf:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102cd2:	8d 45 14             	lea    0x14(%ebp),%eax
  102cd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cdb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102cdf:	8b 45 10             	mov    0x10(%ebp),%eax
  102ce2:	89 44 24 08          	mov    %eax,0x8(%esp)
  102ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ced:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf0:	89 04 24             	mov    %eax,(%esp)
  102cf3:	e8 08 00 00 00       	call   102d00 <vsnprintf>
  102cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102cfe:	c9                   	leave  
  102cff:	c3                   	ret    

00102d00 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102d00:	55                   	push   %ebp
  102d01:	89 e5                	mov    %esp,%ebp
  102d03:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102d06:	8b 45 08             	mov    0x8(%ebp),%eax
  102d09:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d0f:	8d 50 ff             	lea    -0x1(%eax),%edx
  102d12:	8b 45 08             	mov    0x8(%ebp),%eax
  102d15:	01 d0                	add    %edx,%eax
  102d17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102d21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102d25:	74 0a                	je     102d31 <vsnprintf+0x31>
  102d27:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d2d:	39 c2                	cmp    %eax,%edx
  102d2f:	76 07                	jbe    102d38 <vsnprintf+0x38>
        return -E_INVAL;
  102d31:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102d36:	eb 2a                	jmp    102d62 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102d38:	8b 45 14             	mov    0x14(%ebp),%eax
  102d3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  102d42:	89 44 24 08          	mov    %eax,0x8(%esp)
  102d46:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102d49:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d4d:	c7 04 24 97 2c 10 00 	movl   $0x102c97,(%esp)
  102d54:	e8 53 fb ff ff       	call   1028ac <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  102d59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d5c:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102d62:	c9                   	leave  
  102d63:	c3                   	ret    

00102d64 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102d64:	55                   	push   %ebp
  102d65:	89 e5                	mov    %esp,%ebp
  102d67:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102d6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102d71:	eb 04                	jmp    102d77 <strlen+0x13>
        cnt ++;
  102d73:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102d77:	8b 45 08             	mov    0x8(%ebp),%eax
  102d7a:	8d 50 01             	lea    0x1(%eax),%edx
  102d7d:	89 55 08             	mov    %edx,0x8(%ebp)
  102d80:	0f b6 00             	movzbl (%eax),%eax
  102d83:	84 c0                	test   %al,%al
  102d85:	75 ec                	jne    102d73 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102d87:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102d8a:	c9                   	leave  
  102d8b:	c3                   	ret    

00102d8c <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102d8c:	55                   	push   %ebp
  102d8d:	89 e5                	mov    %esp,%ebp
  102d8f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102d92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102d99:	eb 04                	jmp    102d9f <strnlen+0x13>
        cnt ++;
  102d9b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102d9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102da2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102da5:	73 10                	jae    102db7 <strnlen+0x2b>
  102da7:	8b 45 08             	mov    0x8(%ebp),%eax
  102daa:	8d 50 01             	lea    0x1(%eax),%edx
  102dad:	89 55 08             	mov    %edx,0x8(%ebp)
  102db0:	0f b6 00             	movzbl (%eax),%eax
  102db3:	84 c0                	test   %al,%al
  102db5:	75 e4                	jne    102d9b <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102db7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102dba:	c9                   	leave  
  102dbb:	c3                   	ret    

00102dbc <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102dbc:	55                   	push   %ebp
  102dbd:	89 e5                	mov    %esp,%ebp
  102dbf:	57                   	push   %edi
  102dc0:	56                   	push   %esi
  102dc1:	83 ec 20             	sub    $0x20,%esp
  102dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102dd0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dd6:	89 d1                	mov    %edx,%ecx
  102dd8:	89 c2                	mov    %eax,%edx
  102dda:	89 ce                	mov    %ecx,%esi
  102ddc:	89 d7                	mov    %edx,%edi
  102dde:	ac                   	lods   %ds:(%esi),%al
  102ddf:	aa                   	stos   %al,%es:(%edi)
  102de0:	84 c0                	test   %al,%al
  102de2:	75 fa                	jne    102dde <strcpy+0x22>
  102de4:	89 fa                	mov    %edi,%edx
  102de6:	89 f1                	mov    %esi,%ecx
  102de8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102deb:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102dee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102df4:	83 c4 20             	add    $0x20,%esp
  102df7:	5e                   	pop    %esi
  102df8:	5f                   	pop    %edi
  102df9:	5d                   	pop    %ebp
  102dfa:	c3                   	ret    

00102dfb <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102dfb:	55                   	push   %ebp
  102dfc:	89 e5                	mov    %esp,%ebp
  102dfe:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102e01:	8b 45 08             	mov    0x8(%ebp),%eax
  102e04:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102e07:	eb 21                	jmp    102e2a <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e0c:	0f b6 10             	movzbl (%eax),%edx
  102e0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e12:	88 10                	mov    %dl,(%eax)
  102e14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e17:	0f b6 00             	movzbl (%eax),%eax
  102e1a:	84 c0                	test   %al,%al
  102e1c:	74 04                	je     102e22 <strncpy+0x27>
            src ++;
  102e1e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102e22:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102e26:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  102e2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e2e:	75 d9                	jne    102e09 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  102e30:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102e33:	c9                   	leave  
  102e34:	c3                   	ret    

00102e35 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102e35:	55                   	push   %ebp
  102e36:	89 e5                	mov    %esp,%ebp
  102e38:	57                   	push   %edi
  102e39:	56                   	push   %esi
  102e3a:	83 ec 20             	sub    $0x20,%esp
  102e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e46:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  102e49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e4f:	89 d1                	mov    %edx,%ecx
  102e51:	89 c2                	mov    %eax,%edx
  102e53:	89 ce                	mov    %ecx,%esi
  102e55:	89 d7                	mov    %edx,%edi
  102e57:	ac                   	lods   %ds:(%esi),%al
  102e58:	ae                   	scas   %es:(%edi),%al
  102e59:	75 08                	jne    102e63 <strcmp+0x2e>
  102e5b:	84 c0                	test   %al,%al
  102e5d:	75 f8                	jne    102e57 <strcmp+0x22>
  102e5f:	31 c0                	xor    %eax,%eax
  102e61:	eb 04                	jmp    102e67 <strcmp+0x32>
  102e63:	19 c0                	sbb    %eax,%eax
  102e65:	0c 01                	or     $0x1,%al
  102e67:	89 fa                	mov    %edi,%edx
  102e69:	89 f1                	mov    %esi,%ecx
  102e6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e6e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102e71:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  102e74:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102e77:	83 c4 20             	add    $0x20,%esp
  102e7a:	5e                   	pop    %esi
  102e7b:	5f                   	pop    %edi
  102e7c:	5d                   	pop    %ebp
  102e7d:	c3                   	ret    

00102e7e <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102e7e:	55                   	push   %ebp
  102e7f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102e81:	eb 0c                	jmp    102e8f <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102e83:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102e87:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102e8b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102e8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e93:	74 1a                	je     102eaf <strncmp+0x31>
  102e95:	8b 45 08             	mov    0x8(%ebp),%eax
  102e98:	0f b6 00             	movzbl (%eax),%eax
  102e9b:	84 c0                	test   %al,%al
  102e9d:	74 10                	je     102eaf <strncmp+0x31>
  102e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea2:	0f b6 10             	movzbl (%eax),%edx
  102ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ea8:	0f b6 00             	movzbl (%eax),%eax
  102eab:	38 c2                	cmp    %al,%dl
  102ead:	74 d4                	je     102e83 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102eaf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102eb3:	74 18                	je     102ecd <strncmp+0x4f>
  102eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb8:	0f b6 00             	movzbl (%eax),%eax
  102ebb:	0f b6 d0             	movzbl %al,%edx
  102ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ec1:	0f b6 00             	movzbl (%eax),%eax
  102ec4:	0f b6 c0             	movzbl %al,%eax
  102ec7:	29 c2                	sub    %eax,%edx
  102ec9:	89 d0                	mov    %edx,%eax
  102ecb:	eb 05                	jmp    102ed2 <strncmp+0x54>
  102ecd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102ed2:	5d                   	pop    %ebp
  102ed3:	c3                   	ret    

00102ed4 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102ed4:	55                   	push   %ebp
  102ed5:	89 e5                	mov    %esp,%ebp
  102ed7:	83 ec 04             	sub    $0x4,%esp
  102eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  102edd:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102ee0:	eb 14                	jmp    102ef6 <strchr+0x22>
        if (*s == c) {
  102ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee5:	0f b6 00             	movzbl (%eax),%eax
  102ee8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102eeb:	75 05                	jne    102ef2 <strchr+0x1e>
            return (char *)s;
  102eed:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef0:	eb 13                	jmp    102f05 <strchr+0x31>
        }
        s ++;
  102ef2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  102ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef9:	0f b6 00             	movzbl (%eax),%eax
  102efc:	84 c0                	test   %al,%al
  102efe:	75 e2                	jne    102ee2 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  102f00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102f05:	c9                   	leave  
  102f06:	c3                   	ret    

00102f07 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102f07:	55                   	push   %ebp
  102f08:	89 e5                	mov    %esp,%ebp
  102f0a:	83 ec 04             	sub    $0x4,%esp
  102f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f10:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102f13:	eb 11                	jmp    102f26 <strfind+0x1f>
        if (*s == c) {
  102f15:	8b 45 08             	mov    0x8(%ebp),%eax
  102f18:	0f b6 00             	movzbl (%eax),%eax
  102f1b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102f1e:	75 02                	jne    102f22 <strfind+0x1b>
            break;
  102f20:	eb 0e                	jmp    102f30 <strfind+0x29>
        }
        s ++;
  102f22:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  102f26:	8b 45 08             	mov    0x8(%ebp),%eax
  102f29:	0f b6 00             	movzbl (%eax),%eax
  102f2c:	84 c0                	test   %al,%al
  102f2e:	75 e5                	jne    102f15 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  102f30:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102f33:	c9                   	leave  
  102f34:	c3                   	ret    

00102f35 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102f35:	55                   	push   %ebp
  102f36:	89 e5                	mov    %esp,%ebp
  102f38:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102f3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102f42:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102f49:	eb 04                	jmp    102f4f <strtol+0x1a>
        s ++;
  102f4b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  102f52:	0f b6 00             	movzbl (%eax),%eax
  102f55:	3c 20                	cmp    $0x20,%al
  102f57:	74 f2                	je     102f4b <strtol+0x16>
  102f59:	8b 45 08             	mov    0x8(%ebp),%eax
  102f5c:	0f b6 00             	movzbl (%eax),%eax
  102f5f:	3c 09                	cmp    $0x9,%al
  102f61:	74 e8                	je     102f4b <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  102f63:	8b 45 08             	mov    0x8(%ebp),%eax
  102f66:	0f b6 00             	movzbl (%eax),%eax
  102f69:	3c 2b                	cmp    $0x2b,%al
  102f6b:	75 06                	jne    102f73 <strtol+0x3e>
        s ++;
  102f6d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102f71:	eb 15                	jmp    102f88 <strtol+0x53>
    }
    else if (*s == '-') {
  102f73:	8b 45 08             	mov    0x8(%ebp),%eax
  102f76:	0f b6 00             	movzbl (%eax),%eax
  102f79:	3c 2d                	cmp    $0x2d,%al
  102f7b:	75 0b                	jne    102f88 <strtol+0x53>
        s ++, neg = 1;
  102f7d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102f81:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102f88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f8c:	74 06                	je     102f94 <strtol+0x5f>
  102f8e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102f92:	75 24                	jne    102fb8 <strtol+0x83>
  102f94:	8b 45 08             	mov    0x8(%ebp),%eax
  102f97:	0f b6 00             	movzbl (%eax),%eax
  102f9a:	3c 30                	cmp    $0x30,%al
  102f9c:	75 1a                	jne    102fb8 <strtol+0x83>
  102f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa1:	83 c0 01             	add    $0x1,%eax
  102fa4:	0f b6 00             	movzbl (%eax),%eax
  102fa7:	3c 78                	cmp    $0x78,%al
  102fa9:	75 0d                	jne    102fb8 <strtol+0x83>
        s += 2, base = 16;
  102fab:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102faf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102fb6:	eb 2a                	jmp    102fe2 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102fb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102fbc:	75 17                	jne    102fd5 <strtol+0xa0>
  102fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  102fc1:	0f b6 00             	movzbl (%eax),%eax
  102fc4:	3c 30                	cmp    $0x30,%al
  102fc6:	75 0d                	jne    102fd5 <strtol+0xa0>
        s ++, base = 8;
  102fc8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102fcc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102fd3:	eb 0d                	jmp    102fe2 <strtol+0xad>
    }
    else if (base == 0) {
  102fd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102fd9:	75 07                	jne    102fe2 <strtol+0xad>
        base = 10;
  102fdb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe5:	0f b6 00             	movzbl (%eax),%eax
  102fe8:	3c 2f                	cmp    $0x2f,%al
  102fea:	7e 1b                	jle    103007 <strtol+0xd2>
  102fec:	8b 45 08             	mov    0x8(%ebp),%eax
  102fef:	0f b6 00             	movzbl (%eax),%eax
  102ff2:	3c 39                	cmp    $0x39,%al
  102ff4:	7f 11                	jg     103007 <strtol+0xd2>
            dig = *s - '0';
  102ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff9:	0f b6 00             	movzbl (%eax),%eax
  102ffc:	0f be c0             	movsbl %al,%eax
  102fff:	83 e8 30             	sub    $0x30,%eax
  103002:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103005:	eb 48                	jmp    10304f <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  103007:	8b 45 08             	mov    0x8(%ebp),%eax
  10300a:	0f b6 00             	movzbl (%eax),%eax
  10300d:	3c 60                	cmp    $0x60,%al
  10300f:	7e 1b                	jle    10302c <strtol+0xf7>
  103011:	8b 45 08             	mov    0x8(%ebp),%eax
  103014:	0f b6 00             	movzbl (%eax),%eax
  103017:	3c 7a                	cmp    $0x7a,%al
  103019:	7f 11                	jg     10302c <strtol+0xf7>
            dig = *s - 'a' + 10;
  10301b:	8b 45 08             	mov    0x8(%ebp),%eax
  10301e:	0f b6 00             	movzbl (%eax),%eax
  103021:	0f be c0             	movsbl %al,%eax
  103024:	83 e8 57             	sub    $0x57,%eax
  103027:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10302a:	eb 23                	jmp    10304f <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10302c:	8b 45 08             	mov    0x8(%ebp),%eax
  10302f:	0f b6 00             	movzbl (%eax),%eax
  103032:	3c 40                	cmp    $0x40,%al
  103034:	7e 3d                	jle    103073 <strtol+0x13e>
  103036:	8b 45 08             	mov    0x8(%ebp),%eax
  103039:	0f b6 00             	movzbl (%eax),%eax
  10303c:	3c 5a                	cmp    $0x5a,%al
  10303e:	7f 33                	jg     103073 <strtol+0x13e>
            dig = *s - 'A' + 10;
  103040:	8b 45 08             	mov    0x8(%ebp),%eax
  103043:	0f b6 00             	movzbl (%eax),%eax
  103046:	0f be c0             	movsbl %al,%eax
  103049:	83 e8 37             	sub    $0x37,%eax
  10304c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  10304f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103052:	3b 45 10             	cmp    0x10(%ebp),%eax
  103055:	7c 02                	jl     103059 <strtol+0x124>
            break;
  103057:	eb 1a                	jmp    103073 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  103059:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10305d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103060:	0f af 45 10          	imul   0x10(%ebp),%eax
  103064:	89 c2                	mov    %eax,%edx
  103066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103069:	01 d0                	add    %edx,%eax
  10306b:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  10306e:	e9 6f ff ff ff       	jmp    102fe2 <strtol+0xad>

    if (endptr) {
  103073:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103077:	74 08                	je     103081 <strtol+0x14c>
        *endptr = (char *) s;
  103079:	8b 45 0c             	mov    0xc(%ebp),%eax
  10307c:	8b 55 08             	mov    0x8(%ebp),%edx
  10307f:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  103081:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  103085:	74 07                	je     10308e <strtol+0x159>
  103087:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10308a:	f7 d8                	neg    %eax
  10308c:	eb 03                	jmp    103091 <strtol+0x15c>
  10308e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  103091:	c9                   	leave  
  103092:	c3                   	ret    

00103093 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  103093:	55                   	push   %ebp
  103094:	89 e5                	mov    %esp,%ebp
  103096:	57                   	push   %edi
  103097:	83 ec 24             	sub    $0x24,%esp
  10309a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10309d:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1030a0:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1030a4:	8b 55 08             	mov    0x8(%ebp),%edx
  1030a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1030aa:	88 45 f7             	mov    %al,-0x9(%ebp)
  1030ad:	8b 45 10             	mov    0x10(%ebp),%eax
  1030b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1030b3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1030b6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1030ba:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1030bd:	89 d7                	mov    %edx,%edi
  1030bf:	f3 aa                	rep stos %al,%es:(%edi)
  1030c1:	89 fa                	mov    %edi,%edx
  1030c3:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1030c6:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  1030c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1030cc:	83 c4 24             	add    $0x24,%esp
  1030cf:	5f                   	pop    %edi
  1030d0:	5d                   	pop    %ebp
  1030d1:	c3                   	ret    

001030d2 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1030d2:	55                   	push   %ebp
  1030d3:	89 e5                	mov    %esp,%ebp
  1030d5:	57                   	push   %edi
  1030d6:	56                   	push   %esi
  1030d7:	53                   	push   %ebx
  1030d8:	83 ec 30             	sub    $0x30,%esp
  1030db:	8b 45 08             	mov    0x8(%ebp),%eax
  1030de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030e7:	8b 45 10             	mov    0x10(%ebp),%eax
  1030ea:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1030ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030f0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1030f3:	73 42                	jae    103137 <memmove+0x65>
  1030f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1030fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103101:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103104:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103107:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10310a:	c1 e8 02             	shr    $0x2,%eax
  10310d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10310f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103112:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103115:	89 d7                	mov    %edx,%edi
  103117:	89 c6                	mov    %eax,%esi
  103119:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10311b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10311e:	83 e1 03             	and    $0x3,%ecx
  103121:	74 02                	je     103125 <memmove+0x53>
  103123:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103125:	89 f0                	mov    %esi,%eax
  103127:	89 fa                	mov    %edi,%edx
  103129:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10312c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10312f:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103132:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103135:	eb 36                	jmp    10316d <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  103137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10313a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10313d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103140:	01 c2                	add    %eax,%edx
  103142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103145:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10314b:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  10314e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103151:	89 c1                	mov    %eax,%ecx
  103153:	89 d8                	mov    %ebx,%eax
  103155:	89 d6                	mov    %edx,%esi
  103157:	89 c7                	mov    %eax,%edi
  103159:	fd                   	std    
  10315a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10315c:	fc                   	cld    
  10315d:	89 f8                	mov    %edi,%eax
  10315f:	89 f2                	mov    %esi,%edx
  103161:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103164:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103167:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  10316a:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10316d:	83 c4 30             	add    $0x30,%esp
  103170:	5b                   	pop    %ebx
  103171:	5e                   	pop    %esi
  103172:	5f                   	pop    %edi
  103173:	5d                   	pop    %ebp
  103174:	c3                   	ret    

00103175 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  103175:	55                   	push   %ebp
  103176:	89 e5                	mov    %esp,%ebp
  103178:	57                   	push   %edi
  103179:	56                   	push   %esi
  10317a:	83 ec 20             	sub    $0x20,%esp
  10317d:	8b 45 08             	mov    0x8(%ebp),%eax
  103180:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103183:	8b 45 0c             	mov    0xc(%ebp),%eax
  103186:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103189:	8b 45 10             	mov    0x10(%ebp),%eax
  10318c:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10318f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103192:	c1 e8 02             	shr    $0x2,%eax
  103195:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103197:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10319a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10319d:	89 d7                	mov    %edx,%edi
  10319f:	89 c6                	mov    %eax,%esi
  1031a1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1031a3:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1031a6:	83 e1 03             	and    $0x3,%ecx
  1031a9:	74 02                	je     1031ad <memcpy+0x38>
  1031ab:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1031ad:	89 f0                	mov    %esi,%eax
  1031af:	89 fa                	mov    %edi,%edx
  1031b1:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1031b4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1031b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  1031ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1031bd:	83 c4 20             	add    $0x20,%esp
  1031c0:	5e                   	pop    %esi
  1031c1:	5f                   	pop    %edi
  1031c2:	5d                   	pop    %ebp
  1031c3:	c3                   	ret    

001031c4 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1031c4:	55                   	push   %ebp
  1031c5:	89 e5                	mov    %esp,%ebp
  1031c7:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1031ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1031cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1031d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031d3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1031d6:	eb 30                	jmp    103208 <memcmp+0x44>
        if (*s1 != *s2) {
  1031d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031db:	0f b6 10             	movzbl (%eax),%edx
  1031de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1031e1:	0f b6 00             	movzbl (%eax),%eax
  1031e4:	38 c2                	cmp    %al,%dl
  1031e6:	74 18                	je     103200 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1031e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031eb:	0f b6 00             	movzbl (%eax),%eax
  1031ee:	0f b6 d0             	movzbl %al,%edx
  1031f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1031f4:	0f b6 00             	movzbl (%eax),%eax
  1031f7:	0f b6 c0             	movzbl %al,%eax
  1031fa:	29 c2                	sub    %eax,%edx
  1031fc:	89 d0                	mov    %edx,%eax
  1031fe:	eb 1a                	jmp    10321a <memcmp+0x56>
        }
        s1 ++, s2 ++;
  103200:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103204:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  103208:	8b 45 10             	mov    0x10(%ebp),%eax
  10320b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10320e:	89 55 10             	mov    %edx,0x10(%ebp)
  103211:	85 c0                	test   %eax,%eax
  103213:	75 c3                	jne    1031d8 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  103215:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10321a:	c9                   	leave  
  10321b:	c3                   	ret    
