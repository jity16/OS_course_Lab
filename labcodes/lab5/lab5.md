计64	嵇天颖	2016010308

## LAB 5

[TOC]

---

### 练习0：填写已有实验

> 本实验依赖实验1/2/3/4。请把你做的实验1/2/3/4的代码填入本实验中代码有“LAB1”,“LAB2”，“LAB3","LAB4"的注释相应部分。注意：为了能够正确执行lab5的测试应用程序，可能需对已完成的实验1/2/3/4的代码进行进一步改进。

#### LAB1 修改

（1）**增加功能**：为用户态设置中断向量表。

**原理**：在执行加载中断描述符表`lidt`指令前，专门设置了一个特殊的中断描述符`idt[T_SYSCALL]`，它的特权级设置为`DPL_USER`，中断向量处理地址在`_vectors[T_SYSCALL]`处。这样建立好这个中断描述符后，一旦用户进程执行`INT T_SYSCALL`后，由于此中断允许用户态进程产生（注意它的特权级设置为`DPL_USER`），所以`CPU`就会从用户态切换到内核态，保存相关寄存器，并跳转到`_vectors[T_SYSCALL]`处开始执行，

**代码**：在`idt_init`函数中添加如下代码(`T_SYSCALL`这个`trap`的特权级应当是`DPL_USER`)

~~~c
//let user app to use syscall to get the service of ucore
//so you should setup the syscall interrupt gate in here
SETGATE(idt[T_SYSCALL], 1, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER);
~~~



（2）**增加功能**：需要更改对于时钟中断的处理。

在`trap_dispatch`函数中添加代码：当到时间片结束时需要将当前进程的`need_resched`设置为`1`，表示需要被切换的进程。

~~~c
/* you should upate you lab1 code (just add ONE or TWO lines of code):
         *    Every TICK_NUM cycle, you should set current process's current->need_resched = 1 */
ticks++;
if (ticks % TICK_NUM == 0) {
    //print_ticks();
    assert(current != NULL);
    current->need_resched = 1;
}
~~~



#### LAB4 修改

（1）函数`alloc_proc`增加对四个新增字段的初始化

在`lab5`中`PCB`增加了`wait_state, *cptr, *yptr, *optr`字段，需要在`alloc_proc`中实现它们的初始化

~~~c
proc->wait_state = 0;
proc->cptr = proc->optr = proc->yptr = NULL;
~~~

（2）更新`do_fork()`函数，调用`set_links()`函数取代原来的加入链表操作。

* 为了确保当前进程正在等待，增加如下断言

~~~c
assert(current->wait_state == 0); 
~~~

* 将原来简单的计数改成来执行`set_links`函数

~~~c
//list_add(&proc_list, &(proc->list_link));
//nr_process ++;
set_links(proc);
~~~





---



### 练习1: 加载应用程序并执行

#### 【练习1.1】

> `do_execv`函数调用`load_icode`（位于`kern/process/proc.c`中）来加载并解析一个处于内存中的ELF执行文件格式的应用程序，建立相应的用户内存空间来放置应用程序的代码段、数据段等，且要设置好`proc_struct`结构中的成员变量`trapframe`中的内容，确保在执行此进程后，能够从应用程序设定的起始执行地址开始执行。需设置正确的`trapframe`内容。
>
> 请在实验报告中简要说明你的设计实现过程。

**原理分析**

我们需要设置新创建用户进程的`trapframe`中的内容，以便该进程在从内核态中返回后，能够正确地在用户态执行。为了在`trap`返回时能够从内核态进入用户态，代码段寄存器`CS`必须要设置为`USER_CS`，`USER_CS`中对应设置的`DPL`为`3`（表示用户态）。这样在执行`iret`指令时，会发现当前特权级(0)小于将要`pop`出的`CS`的特权级(3)，说明要发生特权级的转换，因此会再`pop`出`SS`和`esp`。

然后就是将`DS，ES，SS`等都设置为`USER_DS`，将`esp`设置为`USTACKTOP`（即用户地址空间的栈顶），`eip`设置为加载的程序的入口地址。

**具体实现**

我们可以从注释中知道需要进行如下设置：

* `tf_cs`设置为用户态代码段的段选择子
* `tf_ds、tf_es、tf_ss`均设置为用户态数据段的段选择子
* `tf_esp`设置为用户栈的栈顶
* `tf_eip`设置为`ELF`文件的入口`e_entry`
* `tf_eflags`使能中断位

~~~c
tf->tf_cs = USER_CS;
tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
tf->tf_esp = USTACKTOP;
tf->tf_eip = elf->e_entry;
tf->tf_eflags = FL_IF; 
~~~



#### 【练习1.2】

> 请在实验报告中描述当创建一个用户态进程并加载了应用程序后，`CPU`是如何让这个应用程序最终在用户态执行起来的。即这个用户态进程被`ucore`选择占用CPU执行（`RUNNING`态）到具体执行应用程序第一条指令的整个经过。

在确定了用户进程的执行代码和数据，以及用户进程的虚拟空间布局后，我们可以来创建用户进程。

加载应用程序的函数`do_execve`是由`syscall.c`中的函数`sys_exec`调用的，`sys_exec`实际上是一个系统调用。

（1）`uCore`通过`do_execve`函数来完成用户进程的创建工作:

- 首先为加载新的执行码做好用户态内存空间清空准备。
- 接下来的一步是加载应用程序执行码到当前进程的新创建的用户态虚拟空间中。

这里我们会涉及到读`ELF`格式的文件，申请内存空间，建立用户态虚存空间，加载应用程序执行码等。`load_icode`函数完成了整个复杂的工作。`do_execve`函数调用`load_icode`函数后会设置当前进程的`trapframe`。



（2）`load_icode`函数的主要工作就是给用户进程建立一个能够让用户进程正常运行的用户环境。

* 调用`mm_create`函数来申请进程的内存管理数据结构`mm`所需内存空间，并对`mm`进行初始化；
* 调用`setup_pgdir`来申请一个页目录表所需的一个页大小的内存空间，将`ucore`内核虚空间映射的内核页表的内容拷贝到此新目录表中，让`mm->pgdir`指向此页目录表
* 根据应用程序执行码的起始位置来解析此ELF格式的执行程序,表明用户进程的合法用户态虚拟地址空间
* 调用根据执行程序各个段的大小分配物理内存空间，并根据执行程序各个段的起始位置确定虚拟地址，并在页表中建立好物理地址和虚拟地址的映射关系，然后把执行程序各个段的内容拷贝到相应的内核虚拟地址中
* 需要给用户进程设置用户栈，明确用户栈的位置在用户虚空间的顶端，并分配一定数量的物理内存且建立好栈的虚地址<-->物理地址映射关系
* 更新用户进程的虚拟内存空间
* 先清空进程的中断帧，再重新设置进程的中断帧



（3）在`do_execve`函数退出后，顺次返回到`syscall`函数，`trap_dispatch`函数，`trap`函数，最后退回到`trapentry.S`中的`__alltraps`中的`"call trap"`的下一条指令。调用`trap``函数之后，传入的参数trapframe`的内容已经被修改了，也就是说此时栈中的内容就是在`load_icode`函数中设置的`trapframe`。



（4）用户进程的用户环境已经搭建完毕。此时`initproc`将按产生系统调用的函数调用路径原路返回，执行中断返回指令`iret`（位于`trapentry.S`的最后一句）后，将切换到用户进程的第一条语句位置（根据`tf_eip`的值）开始执行。`iret`指令执行时，会依次`pop eip，CS，EFLAGS`，然后判断`CS`中的特权级标识。由于我们之前设置的`CS`为`USER_CS`，那么`CPU`会知道我们需要从内核态返回用户态，因此还会`pop`出`SS`和`esp`。由于`SS`和`esp`指向的是用户态地址空间，另外`trapframe`中的`eip`还被设置为了加载的程序的`entry`地址，因此在`iret`返回之后，就会在用户态开始运行被加载的程序。



---

### 练习2: 父进程复制自己的内存空间给子进程

#### 【练习2.1】

> 创建子进程的函数`do_fork`在执行中将拷贝当前进程（即父进程）的用户内存地址空间中的合法内容到新进程中（子进程），完成内存资源的复制。具体是通过`copy_range`函数（位于`kern/mm/pmm.c`中）实现的，请补充`copy_range`的实现，确保能够正确执行。





#### 【练习2.2】

> 请在实验报告中简要说明如何设计实现`”Copy on Write 机制“`，给出概要设计，鼓励给出详细设计。







