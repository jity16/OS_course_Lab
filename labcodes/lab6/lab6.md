计64	嵇天颖	2016010308

## LAB 6

[TOC]

------

### 练习0：填写已有实验

> 本实验依赖实验`1/2/3/4/5`。请把你做的实验`2/3/4/5`的代码填入本实验中代码中有`“LAB1”/“LAB2”/“LAB3”/“LAB4”“LAB5”`的注释相应部分。并确保编译通过。注意：为了能够正确执行`lab6`的测试应用程序，可能需对已完成的实验`1/2/3/4/5`的代码进行进一步改进。

~~~c
struct run_queue *rq;              // running queue contains Process
list_entry_t run_link;             // the entry linked in run queue
int time_slice;                    // time slice for occupying the CPU
skew_heap_entry_t lab6_run_pool;   // FOR LAB6 ONLY: the entry in the run pool
uint32_t lab6_stride;              // FOR LAB6 ONLY: the current stride of the process
uint32_t lab6_priority;       	   // FOR LAB6 ONLY: the priority of process, set by 									   lab6_set_priority(uint32_t)
~~~





~~~c
proc->rq = NULL;
list_init(&(proc->run_link));
proc->time_slice = 0;
proc->lab6_run_pool.left=proc->lab6_run_pool.right=proc->lab6_run_pool.parent=NULL;
proc->lab6_stride = 0;
proc->lab6_priority = 0;
~~~



~~~c
ticks++;
        if (ticks % TICK_NUM == 0) {
            //print_ticks();
            // assert(current != NULL);
            // current->need_resched = 1;
        }
        /* LAB5 2016010308 */
        /* you should upate you lab1 code (just add ONE or TWO lines of code):
         *    Every TICK_NUM cycle, you should set current process's current->need_resched = 1
         */
        /* LAB6 2016010308 */
        /* you should upate you lab5 code
         * IMPORTANT FUNCTIONS:
	     * sched_class_proc_tick
         */
        sched_class_proc_tick(current);
~~~







### 练习1：使用 Round Robin 调度算法（不需要编码）

> 完成练习0后，建议大家比较一下（可用`kdiff3`等文件比较软件）个人完成的`lab5`和练习0完成后的刚修改的`lab6`之间的区别，分析了解`lab6`采用`RR`调度算法后的执行过程。执行`make grade`，大部分测试用例应该通过。但执行`priority.c`应该过不去。



> 请理解并分析`sched_class`中各个函数指针的用法，并结合`Round Robin `调度算法描`ucore`的调度执行过程



> 请在实验报告中简要说明如何设计实现”多级反馈队列调度算法“，给出概要设计，鼓励给出详细设计

