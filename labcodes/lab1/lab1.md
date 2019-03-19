计64	嵇天颖	2016010308

## Lab 1    

[TOC]



---

### （一）练习一

#### 第一问

> 操作系统镜像文件`ucore.img`是如何一步一步生成的？(需要比较详细地解释`Makefile`中每一条相关命令和命令参数的含义，以及说明命令导致的结果)

##### （1）运行结果分析

* 首先我们执行`make clean`和`make V=`命令，观察`Makefile`执行过程

  * 首先通过`gcc`命令将一系列`.c`文件编译成目标文件`.o`

    > 例如下面将`kern/init/init.c`编译成`obj/kern/init/init.o`

    ~~~makefile
    gcc -Ikern/init/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/init/init.c -o obj/kern/init/init.o
    ~~~

  * 接着用`ld`命令将目标文件链接成为可执行文件

    > 我们可以观察到在整个执行过程中生成了两个可执行文件

    ~~~makefile
    # 生成可执行文件	bin/kernel
    ld -m    elf_i386 -nostdlib -T tools/kernel.ld -o bin/kernel  obj/kern/init/init.o obj/kern/libs/readline.o obj/kern/libs/stdio.o obj/kern/debug/kdebug.o obj/kern/debug/kmonitor.o obj/kern/debug/panic.o obj/kern/driver/clock.o obj/kern/driver/console.o obj/kern/driver/intr.o obj/kern/driver/picirq.o obj/kern/trap/trap.o obj/kern/trap/trapentry.o obj/kern/trap/vectors.o obj/kern/mm/pmm.o  obj/libs/printfmt.o obj/libs/string.o
    # 生成可执行文件	bin/bootblock
    ld -m    elf_i386 -nostdlib -N -e start -Ttext 0x7C00 obj/boot/bootasm.o obj/boot/bootmain.o -o obj/bootblock.o
    ~~~

  * 通过`dd`命令可以将`bootloader`放到虚拟硬盘`ucore.img`中去；

    我们发现一共生成了两个软件，`bootloader`和`kernel`.

    ~~~makefile
    dd if=/dev/zero of=bin/ucore.img count=10000
    10000+0 records in
    10000+0 records out
    5120000 bytes (5.1 MB) copied, 0.0707158 s, 72.4 MB/s
    
    dd if=bin/bootblock of=bin/ucore.img conv=notrunc
    1+0 records in
    1+0 records out
    512 bytes (512 B) copied, 0.0012882 s, 397 kB/s
    
    dd if=bin/kernel of=bin/ucore.img seek=1 conv=notrunc
    146+1 records in
    146+1 records out
    74923 bytes (75 kB) copied, 0.00266134 s, 28.2 MB/s
    ~~~

    

* 汇总来看，我们来观察整个过程，以及需要哪些C文件来最后生成了`bootloader`和`uCore`

  > 将`make V=`的屏幕输出简化为下面部分

  * 首先是构建`bin/kernel`

    ~~~makefile
    # 构建bin/kernel
    + cc kern/init/init.c
    + cc kern/libs/readline.c
    + cc kern/libs/stdio.c
    + cc kern/debug/kdebug.c
    + cc kern/debug/kmonitor.c
    + cc kern/debug/panic.c
    + cc kern/driver/clock.c
    + cc kern/driver/console.c
    + cc kern/driver/intr.c
    + cc kern/driver/picirq.c
    + cc kern/trap/trap.c
    + cc kern/trap/trapentry.S
    + cc kern/trap/vectors.S
    + cc kern/mm/pmm.c
    + cc libs/printfmt.c
    + cc libs/string.c
    + ld bin/kernel
    ~~~

  * 接着构建`sign`工具和`bin/bootblock`

    ~~~makefile
    + cc boot/bootasm.S
    + cc boot/bootmain.c
    + cc tools/sign.c
    + ld bin/bootblock
    'obj/bootblock.out' size: 488 bytes
    build 512 bytes boot sector: 'bin/bootblock' success!
    ~~~

  * 然后将`bootloader`放到虚拟硬盘`ucore.img`中去

    ~~~makefile
    dd if=/dev/zero of=bin/ucore.img count=10000
    10000+0 records in
    10000+0 records out
    5120000 bytes (5.1 MB) copied, 0.0707158 s, 72.4 MB/s
    dd if=bin/bootblock of=bin/ucore.img conv=notrunc
    1+0 records in
    1+0 records out
    512 bytes (512 B) copied, 0.0012882 s, 397 kB/s
    dd if=bin/kernel of=bin/ucore.img seek=1 conv=notrunc
    146+1 records in
    146+1 records out
    74923 bytes (75 kB) copied, 0.00266134 s, 28.2 MB/s
    ~~~

    

* 总结以上运行结果可知：

  **操作系统镜像文件`ucore.img`的生成过程**

  - 编译16个内核文件，构建出内核`bin/kernel`
  - 生成`bin/bootblock`引导程序 
    - 编译`bootasm.S，bootmain.c`，链接生成`obj/bootblock.o` 
    - 编译`sign.c`生成`sign.o`工具
    - 使用`sign.o`工具规范化`bootblock.o`，生成`bin/bootblock`引导扇区

  * 生成`ucore.img`虚拟磁盘 

    * `dd`初始化`ucore.img`为`5120000 bytes`，内容为0的文件

    * `dd`拷贝`bin/bootblock`到`ucore.img`第一个扇区

    * `dd`拷贝`bin/kernel`到`ucore.img`第二个扇区往后的空间

      

##### （2）Makefile分析（代码与参数）

**STEP 1**	编译16个内核文件，构建出内核`bin/kernel`

* 首先要编译16个目标文件（`kernel.ld ,init.o, readline.o ,stdio.o, kdebug.o ,kmonitor.o, panic.o, clock.o ,console.o ,intr.o, picirq.o, trap.o, trapentry.o ,vectors.o ,pmm.o , printfmt.o, string.o`)

  ~~~makefile
  $(call add_files_cc, $(call listf_cc, $(KSRCDIR)), kernel, $(KCFLAGS))
  ~~~

* 构建内核`bin/kernel`的代码如下

  ~~~makefile
  # create kernel target
  kernel = $(call totarget,kernel)
  
  $(kernel): tools/kernel.ld
  
  $(kernel): $(KOBJS)
  	@echo + ld $@
  	$(V)$(LD) $(LDFLAGS) -T tools/kernel.ld -o $@ $(KOBJS)
  	@$(OBJDUMP) -S $@ > $(call asmfile,kernel)
  	@$(OBJDUMP) -t $@ | $(SED) '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(call symfile,kernel)
  
  $(call create_target,kernel)
  ~~~

* 使用的参数和意义

  > `gcc`编译过程中的参数

  ~~~makefile
  -fno-builtin	#不使用C语言的内建函数而使用自己定义的，例如`printf`。
  -Wall			#编译时显示所有的警告，由于检查程序错误。
  -ggdb			#专门为GDB生成更丰富的调试信息
  -gstabs			#以stab格式生成GDB调试信息。
  -m32			#交叉编译选项，生成32位（x86）代码。
  ~~~

  > `ld`链接目标文件生成`kernel`过程中的参数

  ~~~makefile
  -nostdinc   		#不在标准系统目录中搜索头文件，只在-I指定的目录中搜索
  -T [scriptfile] 	#让连接器使用指定的脚本
  ~~~

  

**STEP2** 	生成`bin/bootblock`引导程序 

* 编译`bootasm.S，bootmain.c`，链接生成`obj/bootblock.o` 

  * 生成`bootasm.o`、`bootmain.o`的代码为(实际代码由宏批量生成):

    ~~~makefile
    bootfiles = $(call listf_cc,boot)
    $(foreach f,$(bootfiles),$(call cc_compile,$(f),$(CC),$(CFLAGS) -Os -nostdinc))
    ~~~

    * 生成`bootasm.o`需要`bootasm.S`，实际代码为：

      ~~~makefile
      gcc -Iboot/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc -fno-stack-protector \
      -Ilibs/ -Os -nostdinc -c boot/bootasm.S -o obj/boot/bootasm.o
      ~~~

    * 生成`bootmain.o`需要`bootmain.c`，实际代码为：

      ~~~makefile
      gcc -Iboot/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc -fno-stack-protector \
      -Ilibs/ -Os -nostdinc -c boot/bootmain.c -o obj/boot/bootmain.o
      ~~~

* 编译`sign.c`生成`sign.o`工具

  ~~~makefile
  $(call add_files_host,tools/sign.c,sign,sign)
  $(call create_target_host,sign,sign)
  ~~~

  * 生成`sign.o`的实际命令为：

    ~~~makefile
    gcc -Itools/ -g -Wall -O2 -c tools/sign.c -o obj/sign/tools/sign.o
    gcc -g -Wall -O2 obj/sign/tools/sign.o -o bin/sign
    ~~~

* 使用`sign.o`工具规范化`bootblock.o`，生成`bin/bootblock`引导扇区

  * 生成`bootblock`的`Makefile`代码为：

    ~~~makefile
    $(bootblock): $(call toobj,$(bootfiles)) | $(call totarget,sign)
    	@echo + ld $@
    	$(V)$(LD) $(LDFLAGS) -N -e start -Ttext 0x7C00 $^ -o $(call toobj,bootblock)
    	@$(OBJDUMP) -S $(call objfile,bootblock) > $(call asmfile,bootblock)
    	@$(OBJCOPY) -S -O binary $(call objfile,bootblock) $(call outfile,bootblock)
    	@$(call totarget,sign) $(call outfile,bootblock) $(bootblock)
    ~~~

  * 实际命令为：

    ~~~makefile
    ld -m elf_i386 -nostdlib -N -e start -Ttext 0x7C00 \
    obj/boot/bootasm.o obj/boot/bootmain.o -o obj/bootblock.o
    ~~~

  * 拷贝二进制代码`bootblock.o`到`bootblock.out`，具体代码为：

    ~~~makefile
    objcopy -S -O binary obj/bootblock.o obj/bootblock.out
    ~~~

  * 使用`sign`处理`bootblock.out`，生成`bootblock`，具体代码为:

    ~~~makefile
    bin/sign obj/bootblock.out bin/bootblock
    ~~~

* 使用的参数和意义**(仅列出上文中未涉及的参数)**

  > 编译`bootasm.S，bootmain.c`过程中参数

  ~~~makefile
  -I[dir]					#添加搜索头文件
  -fno-stack-protector	#不生成用于检测缓冲区溢出的代码，检测缓冲区溢出主要给应用程序使用
  -Os 					#为减小代码大小而进行优化
  ~~~

  > 使用`sign.o`工具规范化`bootblock.o`，生成`bin/bootblock`引导扇区过程中参数

  ~~~makefile
  -m[emulation]			#模拟为指定平台上的连接器
  -N 						#设置代码段和数据段均可读可写
  -e[entry] 				#指定入口
  -Ttext 					#指定代码段开始的位置
  -S  					#移除所有符号和重定位信息
  -O[bfdname]  			#指定输出格式
  ~~~



**STEP3** 	生成`ucore.img`虚拟磁盘 

* 生成`ucore.img`的代码为：

  ~~~makefile
  $(UCOREIMG): $(kernel) $(bootblock)
  	$(V)dd if=/dev/zero of=$@ count=10000
  	$(V)dd if=$(bootblock) of=$@ conv=notrunc
  	$(V)dd if=$(kernel) of=$@ seek=1 conv=notrunc
  ~~~

  * `dd`初始化`ucore.img`为`5120000 bytes`，内容为0的文件

    ~~~makefile
    dd if=/dev/zero of=bin/ucore.img count=10000
    ~~~

  * `dd`拷贝`bin/bootblock`到`ucore.img`第一个扇区

    ~~~makefile
    dd if=bin/bootblock of=bin/ucore.img conv=notrunc
    ~~~

  * `dd`拷贝`bin/kernel`到`ucore.img`第二个扇区往后的空间

    ~~~makefile
    dd if=bin/kernel of=bin/ucore.img seek=1 conv=notrunc
    ~~~

* 使用的参数及其意义

  ~~~makefile
  - if			#输入文件。
  - of			#输出文件。
  - count			#拷贝block的个数。
  - seek			#数据拷贝起始block寻址。
  - conv=notrunc 	#当dd到一个比源文件大的目标文件时，不缩小目标文件。
  ~~~

  

---

#### 第二问

> 问题2：一个被系统认为是符合规范的硬盘主引导扇区的特征是什么？

`tools`目录下的`sign.c`文件完成了银盘主引导扇区的特征标记

在`sign.c`中查询到如下代码

~~~c
char buf[512];			//分配给主引导扇区的空间
//...
//...
buf[510] = 0x55;
buf[511] = 0xAA;		//结尾两个字节的内容
~~~

因此，硬盘的主引导扇区大小为512字节，且最后两字节的内容应该为0x55和0xAA，以此作为结束的标志。



---

### （二）练习二

#### 【练习2.1】

> 从CPU加电后执行的第一条指令开始，单步跟踪BIOS的执行

（1）将`tools/gdbinit`的内容修改为：

~~~makefile
target remote :1234
set architecture i8086
~~~

`target remote :1234` 此行是为了与`qemu`进行`TCP/IP`连接

`set architecture i8086` 此行是`CPU`加电时，`BIOS`进入的是`8086`的实模式

（2）在`lab1`目录下执行命令`make debug`

我们发现程序停止在第一条指令处，显示内容为：

~~~makefile
0x0000fff0 in ?? ()
~~~

但我们所设想的`bootloader`第一条指令位置是`0x7c00`，而不是`0xfff0`

原因是：`gdb`只显示当前`PC`的值，而没有考虑`CS`段寄存器中的`Base`内容

因此，我们要查看`CPU`加电后第一条指令，需要对当前`PC`值加上`CS`寄存器的`Base`

（3）在`gdb`中输入如下命令

~~~makefile
(gdb) x /i $cs*16 + $pc
~~~

屏幕输出的结果是：

~~~makefile
0xffff0:     ljmp   $0xf000,$0xe05b
~~~

我们知道通常第一条指令是一条长跳转指令到`BIOS`代码中执行，这里屏幕输出的是`ljmp`是长跳转指令，符合规律。

（4）在`gdb`中输入如下命令`stepi`或者`si`

可以单步跟踪：

~~~makefile
(gdb) si
0x0000e05b in ?? ()
(gdb) stepi
0x0000e062 in ?? ()
~~~



#### 【练习2.2】

> 初始化位置0x7c00设置实地址断点,测试断点正常。

在上一题的基础上在`tools/gdbinit`中加上一行：

~~~makefile
b	*0x7c00
~~~

这句是在实地址`0x7c00`处设置断点，此地址是`bootloader`第一条指令位置即入口地址

在`lab1`目录下执行命令`make debug`，得到屏幕输出结果：

~~~makefile
Breakpoint 1 at 0x7c00
~~~

设置断点成功，我们来测试断点是否正常

在`tools/gdbinit`中加上以下几行：

~~~makefile
continue		#继续执行
x /2i $pc		#显示下面两条指令
set architecture i386	#设置当前调试的CPU是80386
~~~

屏幕中显示出：

~~~makefile
Breakpoint 1, 0x00007c00 in ?? ()
=> 0x7c00:      cli    
   0x7c01:      cld    
The target architecture is assumed to be i386
~~~

断点测试正常



#### 【练习2.3】

> 从0x7c00开始跟踪代码运行,将单步跟踪反汇编得到的代码与bootasm.S和 bootblock.asm进行比较。

（1）修改`lab1/tools/gdbinit`

~~~makefile
file bin/kernel				#加载kernel
set architecture i8086		#进入8086的16位实模式
target remote :1234			#与qemu进行TCP/IP连接
break kern_init				
continue
b *0x7c00
c
x /10i $pc					#输出十条指令
~~~

（2）修改Makefile`中`qemu`

~~~makefile
qemu: $(UCOREIMG) $(V)$(QEMU) -no-reboot -d in_asm -D q.log -parallel stdio -hda $< -serial null 		#增加的参数用来将运行的汇编指令保存在q.log中
~~~

（3）我们运行`make qemu`获得的结果保存在`q.log`中：

摘录`q.log`其中一部分如下：

~~~makefile
----------------
IN: 
0xfffffff0:  ljmp   $0xf000,$0xe05b

----------------
IN: 
0x000fe05b:  cmpl   $0x0,%cs:0x65a4
0x000fe062:  jne    0xfd2b9

----------------
IN: 
0x000fe066:  xor    %ax,%ax
0x000fe068:  mov    %ax,%ss

----------------
IN: 
0x000fe06a:  mov    $0x7000,%esp

----------------
IN: 
0x000fe070:  mov    $0xf3c4f,%edx
0x000fe076:  jmp    0xfd12a

----------------
IN: 
0x000fd12a:  mov    %eax,%ecx
0x000fd12d:  cli    
0x000fd12e:  cld    
0x000fd12f:  mov    $0x8f,%eax
0x000fd135:  out    %al,$0x70
0x000fd137:  in     $0x71,%al
0x000fd139:  in     $0x92,%al
0x000fd13b:  or     $0x2,%al
0x000fd13d:  out    %al,$0x92
0x000fd13f:  lidtw  %cs:0x66c0
0x000fd145:  lgdtw  %cs:0x6680
0x000fd14b:  mov    %cr0,%eax
0x000fd14e:  or     $0x1,%eax
0x000fd152:  mov    %eax,%cr0

----------------
IN: 
0x000fd155:  ljmpl  $0x8,$0xfd15d

----------------
IN: 
0x000fd15d:  mov    $0x10,%eax
0x000fd162:  mov    %eax,%ds

----------------
IN: 
0x000fd164:  mov    %eax,%es

----------------
IN: 
0x000fd166:  mov    %eax,%ss

# ............
~~~

将上述代码与bootasm.S和bootblock.asm比较，发现汇编指令相同。 



#### 【练习2.4】

> 自己找一个bootloader或内核中的代码位置，设置断点并进行测试

（1）修改`tools/gdbinit`为：

~~~makefile
file bin/kernel
set architecture i8086
target remote :1234
break kern_init
continue
break clock_init		#将断点设置在clock_init
c
x /10i	$pc
~~~

（2）命令行输入`make debug`，得到的结果

~~~makefile
Breakpoint 2, clock_init () at libs/x86.h:57
=> 0x100cbf <clock_init+16>:    movzbw -0xb(%di),%ax
   0x100cc3 <clock_init+20>:    movzww -0xa(%di),%dx
   0x100cc7 <clock_init+24>:    out    %al,(%dx)
   0x100cc8 <clock_init+25>:    movl   $0x45c60040,-0xe(%di)
   0x100cd0 <clock_init+33>:    icebp  
   0x100cd1 <clock_init+34>:    pushf  
~~~



---

### （三）练习三

> BIOS将通过读取硬盘主引导扇区到内存，并转跳到对应内存中的位置执行bootloader。请分析bootloader是如何完成从实模式进入保护模式的。

#### （1）整体过程

进入`bootloader`时，`CPU`处于16位的实模式，要使`CPU`进入32位的寻址空间，进入保护模式，`bootloader`要完成以下几个步骤：

* 取消A20机制——为了使得CPU在32位模式下能够寻址全部内存。

* 初始化GDT表——为了帮助CPU确认段机制映射的方法。

* 使能CR0寄存器PE位，跳转到32位地址——为了完成保护模式的转换。



#### （2）代码分析

为了了解具体的执行过程，我们阅读`bootasm.S`中第12行至第56行的内容，以及全局描述符表，下面是对代码的具体分析

（1）从`cs = 0` &&` ip = 0x7c00`进入`bootloader`启动过程，

~~~makefile
# start address should be 0:7c00, in real mode, the beginning address of the running bootloader
.globl start
start:
~~~

启动进入`bootloader`先要对环境进行清理：

`cli` 先关闭了中断使能

`cld` 使方向标志位复位

~~~makefile
.code16                                             # Assemble for 16-bit mode
    cli                                             # Disable interrupts
    cld                                             # String operations increment
~~~

清空段寄存器：

~~~makefile
# Set up the important data segment registers (DS, ES, SS).
    xorw %ax, %ax                                   # Segment number zero
    movw %ax, %ds                                   # -> Data Segment
    movw %ax, %es                                   # -> Extra Segment
    movw %ax, %ss                                   # -> Stack Segment
~~~

（2）开启`A20`, 以便能够通过总线访问更大的内存空间。

​	这里通过使能全部的32条地址线，我们可以访问`4G`的内存空间。代码分为`seta20.1`和`seta20.2`两部分，其中`seta20.1`是往端口`0x64`写数据`0xd1`，告诉`CPU`我要往`8042`芯片的`P2`端口写数据；`seta20.2`是往端口`0x60`写数据`0xdf`，从而将`8042`芯片的`P2`端口设置为1。 两段代码都需要先读`0x64`端口的第2位，确保输入缓冲区为空后再进行后续写操作。

**seta20.1**

首先等待`8042 Input buffer`为空

~~~makefile
seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.1
~~~

然后发送`Write 8042 Output Port(P2)`命令到`8042 Input buffer`

~~~makefile
 movb $0xd1, %al                                 # 0xd1 -> port 0x64
 outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port
~~~

**seta20.2**

首先等待`8042 Input buffer`为空

~~~makefile
seta20.2:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.2
~~~

然后将`8042 Output Port（P2）`得到字节的第2位置1，然后写入`8042 Input buffer`

~~~makefile
movb $0xdf, %al                                 # 0xdf -> port 0x60
outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1
~~~

（3）初始化`gdt`表

`bootasm.S`中的`lgdt gdtdesc`把全局描述符表的大小和起始地址共`8`个字节加载到全局描述符表寄存器`GDTR`中。

~~~makefile
lgdt gdtdesc
~~~

从代码中可以看到全局描述符表的大小为`0x17 + 1 = 0x18`，也就是`24`字节。

~~~makefile
gdtdesc:
    .word 0x17                                      # sizeof(gdt) - 1
    .long gdt                                       # address gdt
~~~

全局描述符表的具体内容如下:

全局描述符表每项大小为`8`字节，因此一共有`3`项，而第一项是空白项，所以全局描述符表中只有两个有效的段描述符，分别对应代码段和数据段。

~~~makefile
// Bootstrap GDT
.p2align 2                                          # force 4 byte alignment
gdt:
    SEG_NULLASM                                     # null seg
    SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)           # code seg for bootloader and kernel
    SEG_ASM(STA_W, 0x0, 0xffffffff)                 # data seg for bootloader and kernel
~~~

其中`SEG_ASM`的定义如下：

~~~makefile
#define SEG_ASM(type,base,lim)                                  \
    .word (((lim) >> 12) & 0xffff), ((base) & 0xffff);          \
    .byte (((base) >> 16) & 0xff), (0x90 | (type)),             \
        (0xC0 | (((lim) >> 28) & 0xf)), (((base) >> 24) & 0xff)
~~~

通过将`CR0`寄存器的`PE`位置`1`开启保护模式：

~~~makefile
movl %cr0, %eax
orl $CR0_PE_ON, %eax
movl %eax, %cr0
~~~

切换至保护模式后，`CS`将作为段选择子被使用，其含义发生了变化
这里通过`ljmp`指令来对`CS`的值进行更新

~~~makefile
# Jump to next instruction, but in 32-bit code segment.
# Switches processor into 32-bit mode.
ljmp $PROT_MODE_CSEG, $protcseg
.code32
protcseg:
#...
~~~

设置段选择子的值，并建立堆栈

```
movw $PROT_MODE_DSEG, %ax
movw %ax, %ds
movw %ax, %es
movw %ax, %fs
movw %ax, %gs
movw %ax, %ss

movl $0x0, %ebp
movl $start, %esp
```

保护模式转换完成，进入`boot`主方法

```
call bootmain
```



#### （3）问题回答

总结上面的代码分析，现在来回答练习三中提出的问题

> 为何开启A20，以及如何开启A20

**为什么我们要开启`A20`**:

从代码注释中我们了解到，一开始时`A20`地址线控制是被屏蔽的（见注释中`address line is tied low`），直到系统软件通过一定的`IO`操作去打开它 。

如果我们要在实模式下要访问高位的内存区，要开启`A20`地址线。

因为如果在保护模式下（也就是使用32位地址线的情况下），如果`A20`恒等于0，那么系统只能访问奇数兆的内存，即只能访问`0-1M`、`2-3M`、`4-5M`，这样无法有效访问所有可用内存。所以在保护模式下，必须要开启`A20`。

```makefile
# Enable A20:
#  For backwards compatibility with the earliest PCs, physical
#  address line 20 is tied low, so that addresses higher than
#  1MB wrap around to zero by default. This code undoes this.
```

**如何开启A20？**

打开`A20 Gate`的具体步骤大致如下：

1. 等待`8042 Input buffer`为空
2. 发送`Write 8042 Output Port （P2）` 命令到`8042 Input buffer`
3. 等待`8042 Input buffer`为空
4. 将`8042 Output Port（P2）` 对应字节的第2位置1，然后写入`8042 Input buffer`

> 如何初始化GDT表

一个简单的GDT表和其描述符已经静态储存在引导区中，载入即可`lgdt gdtdesc`

> 如何使能和进入保护模式

将cr0寄存器的PE位（cr0寄存器的最低位）设置为1，便使能和进入保护模式了。



---

### （四）练习四

> 分析`bootloader`加载`ELF`格式的`OS`的过程
>
> 通过阅读`bootmain.c`，了解`bootloader`如何加载`ELF`文件。通过分析源代码和通过`qemu`来运行并调试`bootloader`&`OS`，理解：
>
> 1. `bootloader`如何读取硬盘扇区的？
> 2. `bootloader`是如何加载ELF格式的OS？

`bootloader`完成进入保护模式的工作后，由于`kernel`是以`ELF`形式存储在硬盘上，所以我们需要`bootloader`能够加载`ELF`格式的`OS`, 主要分为两个步骤：（1）读取硬盘扇区；（2）读取硬盘扇区数据后能够分析出`ELF`格式。

#### 【第一问】

> `bootloader`如何读取硬盘扇区的？

在`bootmain.c`中，用`readsect`函数实现了读取硬盘扇区的功能。

**STEP1**	等待磁盘空闲

~~~c
/* readsect - read a single sector at @secno into @dst */
static void
readsect(void *dst, uint32_t secno) {
    // wait for disk to be ready
    waitdisk();
~~~

`waitdisk`的函数实现只有一行,即不断查询读`0x1F7`寄存器的最高两位，直到最高位为0，并且次高位为1（即磁盘空闲）返回。

~~~c
static void
waitdisk(void) {
    while ((inb(0x1F7) & 0xC0) != 0x40)
        /* do nothing */;
}
~~~

**STEP2**	硬盘空闲后，发出读取扇区的命令

设置读取扇区的数目为1

~~~c
 outb(0x1F2, 1);                         // count = 1
~~~

读取的扇区起始编号共28位，分成4部分依次放在0x1F3~0x1F6寄存器中。

其中调用的`outb`函数是采用内联汇编实现，采用了`IO`寻址方式，可以读取外设数据。

~~~c
static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
}
~~~

在这4个字节线联合构成的32位参数中，29-31位强制设为1，28位(=0)表示访问"Disk 0"，0-27位是28位的偏移量。

~~~c
outb(0x1F3, secno & 0xFF);
outb(0x1F4, (secno >> 8) & 0xFF);
outb(0x1F5, (secno >> 16) & 0xFF);
outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
~~~

读扇区对应的命令字为0x20，放在0x1F7寄存器中；

~~~c
outb(0x1F7, 0x20);                      // cmd 0x20 - read sectors
~~~

**STEP3**	发出命令后，再次等待硬盘空闲

~~~c
// wait for disk to be ready
waitdisk();
~~~

**STEP4** 	硬盘再次空闲后，开始从`0x1F0`寄存器中读数据

调用了`insl`函数，也是采用内联汇编实现，在`libs/x86.h`中

~~~C
static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
            "cld;"
            "repne; insl;"
            : "=D" (addr), "=c" (cnt)
            : "d" (port), "0" (addr), "1" (cnt)
            : "memory", "cc");
}
~~~

`insl`的是以dword即4字节为单位的，因此这里SECTIZE需要除以4.

~~~c
    // read a sector
    insl(0x1F0, dst, SECTSIZE / 4);
}
~~~



#### 【第二问】

> `bootloader`是如何加载`ELF`格式的`OS`？

**STEP1** 	

首先从硬盘中将`bin/kernel`文件的第一页内容加载到内存地址为`0x10000`的位置，目的是读取`kernel`文件的`ELF Header`信息。

~~~c
/* bootmain - the entry of bootloader */
void
bootmain(void) {
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);
~~~

其中调用的的`readseg`函数包装了`readsect`，可以读取`kernel`中任意长度的内容写入虚拟地址中

~~~c
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    uintptr_t end_va = va + count;
    // round down to sector boundary
    va -= offset % SECTSIZE;
    // translate from bytes to sectors; kernel starts at sector 1
    uint32_t secno = (offset / SECTSIZE) + 1;
    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
        readsect((void *)va, secno);
    }
}
~~~

**STEP2**

校验`ELF Header`的`e_magic`字段，以确保这是一个`ELF`文件

~~~c
// is this a valid ELF?
if (ELFHDR->e_magic != ELF_MAGIC) {
goto bad;
}
~~~

**STEP3**

`ELF`头部有描述`ELF`文件应加载到内存什么位置的描述表，先将描述表的头地址存在`ph`.然后按照描述表将`ELF`文件中数据载入内存。

**Program Header**

由于该过程中涉及到程序头表`program header`，我们先分析程序头表的结构体，在`libs/elf.h`中：

程序头表的每个成员分别记录一个`Segment`的信息，以下是加载需要用到的信息：

`uint32_t p_offset`是 段相对文件头的偏移值，由此可知怎么从文件中找到该`Segment`

`uint va` 是 段的第一个字节将被放到内存中的虚拟地址，由此可知要将该`Segment`加载到内存中哪个位置

`uint memsz` 是 段在内存映像中占用的字节数，由此可知要加载多少内容

~~~c
/* program section header */
struct proghdr {
    uint32_t p_type;   // loadable code or data, dynamic linking info,etc.
    uint32_t p_offset; // file offset of segment
    uint32_t p_va;     // virtual address to map segment
    uint32_t p_pa;     // physical address, not used
    uint32_t p_filesz; // size of segment in file
    uint32_t p_memsz;  // size of segment in memory (bigger if contains bss）
    uint32_t p_flags;  // read/write/execute bits
    uint32_t p_align;  // required alignment, invariably hardware page size
};
~~~



（1）读取`ELF Header`的`e_phoff`字段，得到`Program Header`表的起始地址；

**原因：**`ELF Header`里面含有`phoff`字段，用于记录`program header`表在文件中的偏移，由该字段可以找到程序头表的起始地址。

~~~c
struct proghdr *ph, *eph;

// load each program segment (ignores ph flags)
ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
~~~

（2）读取`ELF Header`的`e_phnum`字段，得到`Program Header`表的元素数目。

**原因：**程序头表是一个结构体数组，其元素数目记录在`ELF Header`的`phnum`字段中。

~~~c
eph = ph + ELFHDR->e_phnum;
~~~

（3）遍历`Program Header`表中的每个元素，得到每个`Segment`在文件中的偏移、要加载到内存中的位置（虚拟地址）及`Segment`的长度等信息，并通过磁盘`I/O`进行加载

~~~C
for (; ph < eph; ph ++) {
	readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
}
~~~

**STEP4**

加载完毕，通过`ELF Header`的`e_entry`得到内核的入口地址，并跳转到该地址开始执行内核代码

~~~C
((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();
~~~



#### 【运行调试】

（1）在`bootmain`函数入口处即`0x7d0d`设置断点

修改`tools/gdbinit`为

~~~c
file obj/bootblock.o
target remote :1234
break bootmain
continue
~~~

（2）然后通过`make debug`命令进入`gdb`调试，输入`c`继续执行后，不断用`n`查看下一条指令，直到执行完`readseg`函数，查询`ELF Header`的`e_magic`的值:

~~~makefile
(gdb) x/xw 0x10000
0x10000:        0x464c457f
~~~

发现与`ELF_MAGIC`，因此校验成功

（3）我们观察Program Header即`proghdr`结构体，下面8个字节分别表示了该结构体各元素的值

~~~c
(gdb) x/8xw 0x10034
0x10034:        0x00000001      0x00001000      0x00100000      0x00100000
0x10044:        0x0000d024      0x0000d024      0x00000005      0x00001000
~~~

同时我们查看命令行, 查询结果如下图中所示，与`gdb`调试结果一致。

~~~python
$ readelf -l bin/kernel

Elf file type is EXEC (Executable file)
Entry point 0x100000
There are 3 program headers, starting at offset 52

Program Headers:
  Type   Offset     VirtAddr       PhysAddr     FileSiz    MemSiz  Flg  Align
  LOAD   0x001000 	0x00100000     0x00100000 	0x0d024    0x0d024 R E 0x1000
  LOAD   0x00f000   0x0010e000     0x0010e000 	0x00a16    0x01d20 RW  0x1000
  GNU_STACK  0x000000 0x00000000   0x00000000 	0x00000    0x00000 RWE 0x10

 Section to Segment mapping:
  Segment Sections...
   00     .text .rodata .stab .stabstr
   01     .data .bss
   02
~~~



​                             





---



