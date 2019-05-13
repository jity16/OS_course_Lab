计64	嵇天颖	2016010308

## LAB 7

[TOC]

---

### 练习0：填写已有实验

> 本实验依赖实验`1/2/3/4/5/6`。请把你做的实验`1/2/3/4/5/6`的代码填入本实验中代码中有`“LAB1”/“LAB2”/“LAB3”/“LAB4”/“LAB5”/“LAB6”`的注释相应部分。并确保编译通过。注意：为了能够正确执行lab7的测试应用程序，可能需对已完成的实验`1/2/3/4/5/6`的代码进行进一步改进。

#### 修改`trap.c`

在`trap_dispatch`函数中修改之前对时钟中断的处理，使得`ucore`能够利用定时器提供的功能完成调度和睡眠唤醒等操作因此我们需要在`trap_dispatch`函数中`IRQ_OFFSET + IRQ_TIMER`分支中添加：

```
run_timer_list();
```

与此同时，`lab6`中添加的

```
sched_class_proc_tick(current);
```

已经被添加到`run_timer_list`函数中，故删去。



---

### 练习1: 理解内核级信号量的实现和基于内核级信号量的哲学家就餐问题

> 完成练习0后，建议大家比较一下（可用meld等文件diff比较软件）个人完成的lab6和练习0完成后的刚修改的lab7之间的区别，分析了解lab7采用信号量的执行过程。执行`make grade`，大部分测试用例应该通过。

#### 【练习1.1】

> 请在实验报告中给出内核级信号量的设计描述，并说明其大致执行流程。

`Lab7`在`sem.c`和`sem.h`实现了信号量。

信号量是一种同步互斥机制的实现，普遍存在于现在的各种操作系统内核里。相对于`spinlock`的应用对象，信号量的应用对象是在临界区中运行的时间较长的进程。等待信号量的进程需要睡眠来减少占用 CPU 的开销。

##### 基本实现原理

```c
struct semaphore {
int count;
queueType queue;
};
void semWait(semaphore s)
{
s.count--;
if (s.count < 0) {
/* place this process in s.queue */;
/* block this process */;
}
}
void semSignal(semaphore s)
{
s.count++;
if (s.count<= 0) {
/* remove a process P from s.queue */;
/* place process P on ready list */;
}
}
```

基于上诉信号量实现可以认为:

- 当多个`(>1)`进程可以进行互斥或同步合作时，一个进程会由于无法满足信号量设置的某条件而在某一位置停止，直到它接收到一个特定的信号（表明条件满足了）。
- 为了发信号，需要使用一个称作信号量的特殊变量:
  - 为通过信号量`s`传送信号，信号量的`V`操作采用进程可执行原语`semSignal(s)`；
  - 为通过信号量`s`接收信号，信号量的`P`操作采用进程可执行原语`semWait(s)`；
  - 如果相应的信号仍然没有发送，则进程被阻塞或睡眠，直到发送完为止。

`ucore`中信号量参照上述原理描述，建立在开关中断机制和`wait_queue`的基础上进行了具体实现。



##### 数据结构

`semaphore_t`是最基本的记录型信号量（`record semaphore`)结构，包含了用于计数的整数值`value`，和一个进程等待队列`wait_queue`，一个等待的进程会挂在此等待队列上。

```c
typedef struct {
    int value;		//信号量的当前值
    wait_queue_t wait_queue;	//信号量对应的等待队列
} semaphore_t;
```



##### 功能函数

在`ucore`中最重要的信号量操作是`P`操作函数`down(semaphore_t *sem)`和`V`操作函数 `up(semaphore_t *sem)`。

但这两个函数的具体实现是`_down(semaphore_t *sem, uint32_t wait_state) `函数和`_up(semaphore_t *sem, uint32_t wait_state)`函数，

~~~c
void sem_init(semaphore_t *sem, int value);		//初始化函数
void up(semaphore_t *sem);						//V操作函数
void down(semaphore_t *sem);					//P操作函数
bool try_down(semaphore_t *sem);
~~~



##### 函数分析

信号量的实现主要关注`up`和`down`两个函数。在`sem.c`中实现的这两个函数分别调用`_up`和`_down`来实现具体的功能。传入的`WT_KSEM`作为设置的`wait_state`，表示等待的是内核信号量。以下分别对`_down`和`_up`两个函数进行分析。

**__down函数**

为了保证操作的原子性而不被打断，`up`和`down`操作都需要在进入函数之后关闭中断，在退出函数之前再次打开中断。

`down`操作需要先检查`value`的值是否大于零：

* 若`value`的值大于0，表示还有资源可用，故将`value`的值减1，直接返回即可。

  ~~~c
  // 如果资源还有剩余，则信号量值减一，可以正常访问资源
      if (sem->value > 0) {
          sem->value --;
          local_intr_restore(intr_flag);
          return 0;
      }
  ~~~

* 若不大于零，就说明该信号量对应的资源已经分配完了，故需要进行等待。

  ```c
  // 资源没有剩余，需要将当前进程加入信号量的等待队列，
  wait_t __wait, *wait = &__wait;
  wait_current_set(&(sem->wait_queue), wait, wait_state);
  local_intr_restore(intr_flag);
  ```

  这里表示对该进程新建一个wait变量，然后将其加入该信号量的等待队列中。

  之后调用schedule函数，调度其他处于就绪态的进程执行。

  ~~~c
  //并重新调度
  schedule();
  ~~~

  该进程从等待状态被唤醒，重新开始执行时，再从信号量的等待队列里面将其删除。

  ~~~c
  // 阻塞完毕，该进程被重新唤醒调度，说明现在可以使用该资源了。
  // assert(sem->value == 0); // !IMPORTANT
  local_intr_save(intr_flag);
  wait_current_del(&(sem->wait_queue), wait);
  local_intr_restore(intr_flag);
  
  if (wait->wakeup_flags != wait_state) {
      return wait->wakeup_flags;
  }
  ~~~



**__up函数**

与`_down`一样，需要在进入时关闭中断，在退出时打开中断。执行`_up`函数的时候需要从该信号量的等待队列里面取出一个进程唤醒。

* 如果信号量对应的`wait queue`中没有进程在等待，直接把信号量的`value`加一，然后开中断返回

* 如果有进程在等待且进程等待的原因是`semophore`设置的，则调用`wakeup_wait`函数将`waitqueue`中等待的第一个`wait`删除，且把此`wait`关联的进程唤醒，最后开中断返回。

  ~~~c
  void up(semaphore_t *sem, uint32_t wait_state) {
      bool intr_flag;
      // 在进行up操作（即V操作）的时候，需要由操作系统保证其原子性
      local_intr_save(intr_flag);
      {
          wait_t *wait;
          // 当没有进程希望占用该资源的时候，资源释放
          if ((wait = wait_queue_first(&(sem->wait_queue))) == NULL) {
              sem->value ++;
          }
          else {
              // 有进程希望占用此资源，现在这个资源被释放了一份，所以应该唤醒下一个希望占用该资源的进程
              assert(wait->proc->wait_state == wait_state);
              wakeup_wait(&(sem->wait_queue), wait, wait_state, 1);
          }
      }
      local_intr_restore(intr_flag);
  }
  ~~~



##### 大致执行流程

所有哲学家共享临界区信号量`mutex`，这个信号量用于保证哲学家线程在操作`state_sema`数组时不产生冲突，因此在`take_forks`和`put_forks`函数里都需要加锁。另外，使用`s`信号量数组表示每个哲学家是否正在占用他盘子左面和右面的两个叉子的资源正在进餐，当尝试开始进餐的时候，哲学家会试图取得两个叉子：如果不能取得，则使用`s`信号量进入阻塞状态。而只有当其他的哲学家进餐完毕之后，才会去检查周围的哲学家是否能够进餐，如果可以进餐，则解除`s`信号量引起的阻塞。

这种同步互斥的方式与原理课上所讲解的3种实现方式均不一样，但是同样具有正确性。但`ucore`中信号量的实现和原理课中的实现是不同的。在原理课信号量的实现中，`value`可以小于`0`，小于`0`多少就表示有多少个进程在等待。而在`ucore`的实现中，`value`不能小于`0`。

所以，如果执行`_down`的时候`value`已经为`0`，就不减少`value`的值，而是直接加入等待队列中。进而在`_up`中也需要进行修改，只有当等待队列为空的时候才增加`value`的值。



#### 【练习1.2】

> 请在实验报告中给出给用户态进程/线程提供信号量机制的设计方案，并比较说明给内核级提供信号量机制的异同。

由于操作系统需要保持`PV`操作的原子性，必须使用特权指令禁用中断。由于CLI和STI指令是特权指令，故在用户态中不能关闭中断来保证若干条操作的原子性。

由于用户进程的切换是由操作系统控制的，如果某用户进程在执行`_up`和`_down`操作的过程中被操作系统打断，改为由其他进程执行，就有可能出现错误。因此，关键是如何在用户态保证`_up`和`_down`操作的原子性。

**软件方法**：我们可以用纯软件的方法，保证这种原子性。原理课中所讲的`Peterson`算法和`Dekker`算法就是用来解决这一问题的。

**自旋锁**：我们可以借助`CPU`提供的原子指令实现自旋锁。设置一个位变量用来标识一个锁，然后通过`CPU`提供的原子指令，保证获取这个锁的进程才能进入临界区进行信号量的相关操作。

**区别**：用户态和内核态实现信号量的区别主要在于控制临界区访问的方法的不同。



---

### 练习2: 完成内核级条件变量和基于内核级条件变量的哲学家就餐问题（需要编码）

> 首先掌握管程机制，然后基于信号量实现完成条件变量实现，然后用管程机制实现哲学家就餐问题的解决方案（基于条件变量）。



> 请在实验报告中给出内核级条件变量的设计描述，并说明其大致执行流程。

~~~c
void 
cond_signal (condvar_t *cvp) {
   //LAB7 EXERCISE1: 2016010308
   cprintf("cond_signal begin: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
  /*
   *      cond_signal(cv) {
   *          if(cv.count>0) {
   *             mt.next_count ++;
   *             signal(cv.sem);
   *             wait(mt.next);
   *             mt.next_count--;
   *          }
   *       }
   */
   monitor_t* mtp = cvp->owner;
   if (cvp-> count > 0){
        mtp->next_count ++;
        up(&(cvp->sem));
        down(&(mtp->next));
        mtp->next_count --;
   }
   cprintf("cond_signal end: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
}
~~~





~~~c
void
cond_wait (condvar_t *cvp) {
    //LAB7 EXERCISE1: 2016010308
    cprintf("cond_wait begin:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
   /*
    *         cv.count ++;
    *         if(mt.next_count>0)
    *            signal(mt.next)
    *         else
    *            signal(mt.mutex);
    *         wait(cv.sem);
    *         cv.count --;
    */
    cvp->count ++;
    monitor_t* mtp = cvp->owner;
    if(mtp->next_count > 0){
       up(&(mtp->next));
    }else{
       up(&(mtp->mutex));
    }
    down(&(cvp->sem));
    cvp->count --;
    cprintf("cond_wait end:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
}
~~~



~~~c
void phi_take_forks_condvar(int i) {
     down(&(mtp->mutex));
//--------into routine in monitor--------------
     // LAB7 EXERCISE1: 2016010308
     // I am hungry
     state_condvar[i] = HUNGRY;
     // try to get fork
     phi_test_condvar(i);
     while (state_condvar[i] != EATING) {
       cond_wait(&(mtp->cv[i]));
     }
~~~



~~~c
void phi_put_forks_condvar(int i) {
     down(&(mtp->mutex));

//--------into routine in monitor--------------
     // LAB7 EXERCISE1: 2016010308
     // I ate over
     state_condvar[i]=THINKING;
     // test left and right neighbors
     phi_test_condvar(LEFT);
     phi_test_condvar(RIGHT);
~~~



> 请在实验报告中给出给用户态进程/线程提供条件变量机制的设计方案，并比较说明给内核级提供条件变量机制的异同。



> 请在实验报告中回答：能否不用基于信号量机制来完成条件变量？如果不能，请给出理由，如果能，请给出设计说明和具体实现。