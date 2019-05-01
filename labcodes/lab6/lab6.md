计64	嵇天颖	2016010308

## LAB 6

[TOC]

------

### 练习0：填写已有实验

> 本实验依赖实验`1/2/3/4/5`。请把你做的实验`2/3/4/5`的代码填入本实验中代码中有`“LAB1”/“LAB2”/“LAB3”/“LAB4”“LAB5”`的注释相应部分。并确保编译通过。注意：为了能够正确执行`lab6`的测试应用程序，可能需对已完成的实验`1/2/3/4/5`的代码进行进一步改进。

#### 修改`proc.c`

为了实现调度器算法，在`LAB6`中`proc_struct`中添加了与进程调度相关的几个字段：

~~~c
struct run_queue *rq;              // 运行队列
list_entry_t run_link;             // 该进程的调度链表结构，该结构内部的连接组成了运行队列列表
int time_slice;                    // 该进程剩余的时间片，只对当前进程有效
skew_heap_entry_t lab6_run_pool;   // 该进程在优先队列中的节点
uint32_t lab6_stride;              // 该进程的调度优先级
uint32_t lab6_priority;       	   // 该进程的调度步进值
~~~

因此我们需要在```alloc_proc```中对这几个新的字段进行初始化：

~~~c
proc->rq = NULL;
list_init(&(proc->run_link));
proc->time_slice = 0;
proc->lab6_run_pool.left=proc->lab6_run_pool.right=proc->lab6_run_pool.parent=NULL;
proc->lab6_stride = 0;
proc->lab6_priority = 0;
~~~



#### 修改`trap.c`

在每个时钟中断的时候需要给调度器通知，以更新各种相关的数据。

因此我们在```trap_dispatch```函数中的`case IRQ_OFFSET + IRQ_TIMER:`分支中添加下面一句：

~~~c
ticks++;
        if (ticks % TICK_NUM == 0) {
        }
        sched_class_proc_tick(current);
~~~

---



### 练习1：使用 Round Robin 调度算法

> 完成练习0后，建议大家比较一下（可用`kdiff3`等文件比较软件）个人完成的`lab5`和练习0完成后的刚修改的`lab6`之间的区别，分析了解`lab6`采用`RR`调度算法后的执行过程。执行`make grade`，大部分测试用例应该通过。但执行`priority.c`应该过不去。



> 请理解并分析`sched_class`中各个函数指针的用法，并结合`Round Robin `调度算法描`ucore`的调度执行过程



> 请在实验报告中简要说明如何设计实现”多级反馈队列调度算法“，给出概要设计，鼓励给出详细设计







### 练习2：实现 Stride Scheduling 调度算法



~~~c
#define BIG_STRIDE   0x7FFFFFFF /* you should give a value, and is ??? */
~~~



~~~c
static void
stride_init(struct run_queue *rq) {
     /* LAB6: 2016010308 
      * (1) init the ready process list: rq->run_list
      * (2) init the run pool: rq->lab6_run_pool
      * (3) set number of process: rq->proc_num to 0       
      */
    list_init(&(rq->run_list));
    rq->lab6_run_pool = NULL;
    rq->proc_num = 0;
}
~~~





~~~c
static void
stride_enqueue(struct run_queue *rq, struct proc_struct *proc) {
     /* LAB6: 2016010308 
      * (1) insert the proc into rq correctly
      * NOTICE: you can use skew_heap or list. Important functions
      *         skew_heap_insert: insert a entry into skew_heap
      *         list_add_before: insert  a entry into the last of list   
      * (2) recalculate proc->time_slice
      * (3) set proc->rq pointer to rq
      * (4) increase rq->proc_num
      */
     rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &(proc->lab6_run_pool),
               proc_stride_comp_f);
     // Clamp time_slice to be valid value
     if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
         proc->time_slice = rq->max_time_slice;
     }
     proc->rq = rq;
     rq->proc_num += 1;
}
~~~



~~~c
static void
stride_dequeue(struct run_queue *rq, struct proc_struct *proc) {
     /* LAB6: 2016010308 
      * (1) remove the proc from rq correctly
      * NOTICE: you can use skew_heap or list. Important functions
      *         skew_heap_remove: remove a entry from skew_heap
      *         list_del_init: remove a entry from the  list
      */
      rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &(proc->lab6_run_pool),
               proc_stride_comp_f);
      rq->proc_num -= 1;
}
~~~



~~~c
static struct proc_struct *
stride_pick_next(struct run_queue *rq) {
     /* LAB6: 2016010308 
      * (1) get a  proc_struct pointer p  with the minimum value of stride
             (1.1) If using skew_heap, we can use le2proc get the p from rq->lab6_run_poll
             (1.2) If using list, we have to search list to find the p with minimum stride value
      * (2) update p;s stride value: p->lab6_stride
      * (3) return p
      */
  	 if (rq->lab6_run_pool == NULL) return NULL;
     struct proc_struct* min_proc = le2proc(rq->lab6_run_pool, lab6_run_pool);
     if (min_proc->lab6_priority == 0) {
          min_proc->lab6_stride += BIG_STRIDE;
     } else if (min_proc->lab6_priority > BIG_STRIDE) {
          min_proc->lab6_stride += 1;
     } else {
          min_proc->lab6_stride += BIG_STRIDE / min_proc->lab6_priority;
     }
     return min_proc;
}
~~~



~~~c
static void
stride_proc_tick(struct run_queue *rq, struct proc_struct *proc) {
     /* LAB6: 2016010308 */
    if(proc->time_slice > 0) proc->time_slice --;
    if(proc->time_slice == 0) proc->need_resched = 1;
}
~~~

