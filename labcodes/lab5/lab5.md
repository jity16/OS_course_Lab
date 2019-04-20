计64	嵇天颖	2016010308

## LAB 5

[TOC]

---

### 练习0：填写已有实验

> 本实验依赖实验1/2/3/4。请把你做的实验1/2/3/4的代码填入本实验中代码有“LAB1”,“LAB2”，“LAB3","LAB4"的注释相应部分。注意：为了能够正确执行lab5的测试应用程序，可能需对已完成的实验1/2/3/4的代码进行进一步改进。

#### LAB1 修改

（1）增加功能：为用户态设置中断向量表。

在`idt_init`函数中添加如下代码(`T_SYSCALL`这个`trap`的特权级应当是`DPL_USER`)

~~~c
//let user app to use syscall to get the service of ucore
//so you should setup the syscall interrupt gate in here
SETGATE(idt[T_SYSCALL], 1, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER);
~~~

（2）增加功能：需要更改对于时钟中断的处理。

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

~~~c
tf->tf_cs = USER_CS;
tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
tf->tf_esp = USTACKTOP;
tf->tf_eip = elf->e_entry;
tf->tf_eflags = FL_IF; 
~~~











#### 【练习2.2】

> 请在实验报告中描述当创建一个用户态进程并加载了应用程序后，`CPU`是如何让这个应用程序最终在用户态执行起来的。即这个用户态进程被`ucore`选择占用CPU执行（`RUNNING`态）到具体执行应用程序第一条指令的整个经过。















