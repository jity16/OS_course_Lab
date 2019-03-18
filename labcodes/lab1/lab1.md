> 计64	嵇天颖	2016010308

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

#### （二）练习二

##### 【练习2.1】

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



##### 【练习2.2】

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



##### 【练习2.3】

> 从0x7c00开始跟踪代码运行,将单步跟踪反汇编得到的代码与bootasm.S和 bootblock.asm进行比较。

