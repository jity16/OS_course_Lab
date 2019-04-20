计64	嵇天颖	2016010308

## LAB 4

[TOC]

---

### 练习0：填写已有实验

> 本实验依赖实验1/2/3。请把你做的实验1/2/3的代码填入本实验中代码中有“LAB1”,“LAB2”，“LAB3"的注释相应部分。

利用`diff/merge`工具实现代码的合并。

---



### 练习1：分配并初始化一个进程控制块

#### 【练习1.1】

> `alloc_proc`函数（位于`kern/process/proc.c`中）负责分配并返回一个新的`struct proc_struct`结构，用于存储新建立的内核线程的管理信息。`ucore`需要对这个结构进行最基本的初始化，你需要完成这个初始化过程。

##### 进程控制块数据结构分析

进程管理信息用`struct proc_struct`表示，在`kern/process/proc.h`中表示如下：

~~~c
struct proc_struct {
    enum proc_state state;                      // Process state
    int pid;                                    // Process ID
    int runs;                                   // the running times of Proces
    uintptr_t kstack;                           // Process kernel stack
    volatile bool need_resched;                 // bool value: need to be rescheduled to release CPU?
    struct proc_struct *parent;                 // the parent process
    struct mm_struct *mm;                       // Process's memory management field
    struct context context;                     // Switch here to run process
    struct trapframe *tf;                       // Trap frame for current interrupt
    uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
    uint32_t flags;                             // Process flag
    char name[PROC_NAME_LEN + 1];               // Process name
    list_entry_t list_link;                     // Process link list 
    list_entry_t hash_link;                     // Process hash list
};
~~~

我们对进程控制块中的成员变量作解释：

* `state`:进程所处的状态
* `mm`:内存管理的信息，包括内存映射列表，页表指针等
* `parent`:用户进程的父进程（创建它的进程）
* `context`:进程的上下文，用于进程切换
* `tf`:中断帧的指针，总是指向内核栈的某个位置
* `cr3`:保存页表的物理地址，目的就是进程切换的时候方便直接使用`lcr3`实现页表切换
* `kstack`:每个线程都有一个内核栈，并且位于内核地址空间的不同位置



##### 代码实现和原理分析

我们利用`uCore`通过给当前执行的上下文分配一个一个进程控制块以及对它进行相应的初始化，从而创建第0个内核线程`idleproc`。我们创建第0个内核线程的时候，首先调用了`alloc_proc`函数来通过`kmalloc`函数来获得`proc_struct`结构的一块内存块，作为第0个进程控制块。

**（1）实现方法：**把`proc`初始化（把`porc_struct`中各个成员变量清零，有一些变量要设置特殊值）

**（2）原理分析**：

我们来分析一下有特殊值和一些比较重要的成员变量的初始化

* `proc_state`表示了进程所处的状态，我们观察`proc.h`中定义的进程生命周期内的状态：

  ~~~c
  // process's state in his life cycle
  enum proc_state {
      PROC_UNINIT = 0,  // uninitialized
      PROC_SLEEPING,    // sleeping
      PROC_RUNNABLE,    // runnable(maybe running)
      PROC_ZOMBIE,      // almost dead, and wait parent proc to reclaim his resource
  };
  ~~~

  我们发现定义了`uninitialized`,`sleepling`,`runnable`,`zombie`四个状态，我们初始化时需要`PROC_UNINIT`状态

  ~~~c
  proc->state = PROC_UNINIT;
  ~~~

* 设置进程的`pid`为`-1`，表示进程的`process id`尚未办好

  ~~~c
   proc->pid = -1;
  ~~~

* `mm`数据结构是用来实现用户控件的虚存管理的，但是内核线程没有用户空间，它执行的只是内核中的一小段代码，所以它没有`mm`数据结构，也就是`NULL`

  ~~~c
  proc->mm = NULL;
  ~~~

* 在所有进程中，只有一个进程没有父进程，就是内核创建的第一个内核进程`idleproc`

  ~~~ c
  proc->parent = NULL;
  ~~~

* 当某个进程是一个普通用户态进程的时候，`PCB`中的`cr3`就是`mm`中页表的物理地址；而当它是内核线程的时候，`cr3`等于`boot_cr3`。而`boot_cr3`指向了`uCore`启动时建立好的内核虚拟空间的页目录表首地址

  ~~~c
  proc->cr3 = boot_cr3;
  ~~~

**（3）完整代码**

~~~c
proc->state = PROC_UNINIT;
proc->pid = -1;
proc->runs = 0;
proc->kstack = 0;
proc->need_resched = 0;
proc->parent = NULL;
proc->mm = NULL;
memset(&(proc->context), 0, sizeof(struct context));
proc->tf = NULL;
proc->cr3 = boot_cr3;
proc->flags = 0;
memset(proc->name, 0, PROC_NAME_LEN);
~~~



> 请说明`proc_struct`中`struct context context`和`struct trapframe *tf`成员变量含义和在本实验中的作用是啥？

**（1）context含义和作用**:

进程的上下文，用于进程切换。在 `uCore`中，所有的进程在内核中也是相对独立的（例如独立的内核堆栈以及上下文等等）。使用 `context `保存寄存器的目的就在于在内核态中能够进行上下文之间的切换。实际利用`context`进行上下文切换的函数是在`kern/process/switch.S`中定义`switch_to`。

下面的注释解释了各寄存器的作用：

~~~c
struct context {
    uint32_t eip;	//指令寄存器
    uint32_t esp;	//堆栈指针寄存器
    uint32_t ebx;	//基址寄存器
    uint32_t ecx;	//计数器
    uint32_t edx;	//数据寄存器
    uint32_t esi;	//源地址指针寄存器
    uint32_t edi;	//目的地址指针寄存器
    uint32_t ebp;	//基址指针寄存器
};
~~~

我们发现在进程切换的时候保存了`eip,esp,ebx,ecx,edx,esi,edi,ebp`八个寄存器的值。我们发现它并没有对eax进行保存。我们注意到在进行切换的时候调用了`switch_to`这函数，也就是说这个函数里面才是线程之间切换的切换点，而在这个函数里面，由于`eax`是一个`caller-save`寄存器，并且在函数里`eax`的数值一直都可以在栈上找到对应，因此并不需对`%eax`进行保存。

**（2）trapframe含义和作用**

`tf`：中断帧的指针，总是指向内核栈的某个位置：当进程从用户空间跳到内核空间时，中断帧记录了进程在被中断前的状态。当内核需要跳回用户空间时，需要调整中断帧以恢复让进程继续执行的各寄存器值。除此之外，`uCore`内核允许嵌套中断。因此为了保证嵌套中断发生时`tf `总是能够指向当前`trapframe`，`uCore `在内核栈上维护了` tf `的链。

我们在进程切换的过程中，切换入口函数会将模拟一个中断返回，并将当前的`esp`定位在这个`trapframe`上，这样在处理完中断弹出后就可以直接从这个`trapframe`中恢复出进程真正的`esp`和`eip`，从而进程真正的程序运行；

进程切换的时候，一定会发生中断，进入内核态，故需要保存中断产生的栈帧的信息。`trapframe`结构体就是用来保存这些信息的，储存各段寄存器，以及发生中断时被硬件压栈的若干寄存器（`err，eip，cs，eflags，esp，ss`），表示当前中断产生的栈帧。