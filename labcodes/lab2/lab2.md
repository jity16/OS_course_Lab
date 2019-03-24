计 64	嵇天颖	2016010308

## LAB 2

[TOC]



---

### （〇）填写已有实验

> 本实验依赖实验1。请把你做的实验1的代码填入本实验中代码中有`“LAB1”`的注释相应部分。提示：可采用`diff`和`patch`工具进行半自动的合并`（merge）`，也可用一些图形化的比较`/merge`工具来手动合并，比如`meld`，`eclipse`中的`diff/merge`工具，`understand`中的`diff/merge`工具等。
>
> 请在实验报告中简要说明你的设计实现过程。

利用了`diffmerge`图形化比较工具实现了代码的合并。



### （一）实现 first-fit 连续物理内存分配算法

#### 【练习1.1】

> 在实现`first fit`内存分配算法的回收函数时，要考虑地址连续的空闲块之间的合并操作。提示:在建立空闲页块链表时，需要按照空闲页块起始地址来排序，形成一个有序的链表。可能会修改`default_pmm.c`中的`default_init，default_init_memmap，default_alloc_pages， default_free_pages`等相关函数。请仔细查看和理解`default_pmm.c`中的注释。

##### 设计思路和原理分析

`first_fit`算法相比于`bad_fit`和`best_fit`实现更为简单，效果也很好。我们知道在`UNIX`系统的最初版本中，就是使用`first_fit`算法为进程分配内存空间，但它是用数组的数据结构（而非链表）来实现，我们的`ucore`是用的双向链表实现的。当然它也有缺陷，`first_fit`算法会使得内存的低地址部分出现很多小的空闲分区，而每次分配查找时，都要经过这些分区。

（1）**`first_fit`分配算法原理**：空闲分区以地址递增的次序链接。分配内存时顺序查找，找到大小能满足要求的第一个空闲分区。

（2）**数据结构分析**：`first_fit`分配算法需要维护一个查找有序（地址按从小到大排列）空闲块（以页为最小单位的连续地址空间的数据结构，`ucore`中选择了双向链表。

根据注释的提示，我们需要了解`libs/list.h`中定义的通用双向链表的结构和`memlayout.h`中定义的`free_area_t`的数据结构。

**分析`lib/list.h`**

我们不妨来观察`ucore`中提供的通用双向链表结构，因为在实现`first_fit`算法中我们需要使用它提供的一系列操作的服务。

首先是结构体的定义，提供了前向和后向两个指针。

~~~c
struct list_entry {
    struct list_entry *prev, *next;
};
typedef struct list_entry list_entry_t;
~~~

接着定义了对双向链表的操作，如初始化，插入，删除，跳到下一个或上一个元素，判断链表是否为空之类。

我们下面会使用到的有： `list_init`, `list_add`(`list_add_after`), `list_add_before`, `list_del`, `list_next`, `list_prev`

~~~c
static inline void list_init(list_entry_t *elm) __attribute__((always_inline));
static inline void list_add(list_entry_t *listelm, list_entry_t *elm) __attribute__((always_inline));
static inline void list_add_before(list_entry_t *listelm, list_entry_t *elm) __attribute__((always_inline));
static inline void list_add_after(list_entry_t *listelm, list_entry_t *elm) __attribute__((always_inline));
static inline void list_del(list_entry_t *listelm) __attribute__((always_inline));
static inline list_entry_t *list_next(list_entry_t *listelm) __attribute__((always_inline));
static inline list_entry_t *list_prev(list_entry_t *listelm) __attribute__((always_inline));
~~~



**分析`kern/mm/memlayout.h`中`free_area_t`结构体**

我们可以利用`free_area_t`来进行对空闲块的管理

~~~c
/* free_area_t - maintains a doubly linked list to record free (unused) pages */
typedef struct {
    list_entry_t free_list;         // the list header
    unsigned int nr_free;           // # of free pages in this free list
} free_area_t;
~~~



##### 代码与过程分析

> 首先我们分析四个函数中不需要重写的部分函数

**（1）`default_init`函数**

我们直接利用`lab 2`中提供好的`default_init`函数来初始化空闲块。

 `free_list` 是用来记录空闲块的双向链表（创建一个空链表）。

 `nr_free`记录了空闲块的总数量（置为0）。

~~~c
static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
}
~~~

**(2) `default_init_memmap`函数**

`default_init_memmap`根据现有的内存情况来构建空闲块列表的初始状态。

代码之间的调用关系如下：

~~~c
kern_init --> pmm_init --> page_init --> init_memmap --> pmm_manager --> init_memmap
~~~

我们知道这个函数是根据每个物理页帧的情况来建立空闲链表，并且空闲块是一个按地址高低排序的链表。

链表头是`free_area.free_list`，链表项是`Page`数据结构`base_page_link`。

~~~c
static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    nr_free += n;
    list_add_before(&free_list, &(base->page_link));
}
~~~



> 在`kern/mm/default_pmm.c`中，主要改动了`default_alloc_pages`和`default_free_pages`两个函数。

**（1）`default_alloc_pages`函数**

首先考虑边界情况以保证代码的鲁棒性。检查要分配的n个页有没有超出空闲空间范围：

~~~c
static struct Page *
default_alloc_pages(size_t n) {
    assert(n > 0);
    if (n > nr_free) {
        return NULL;
    }
~~~

接着我们寻找第一个长度大于等于n的块

~~~c
struct Page *page = NULL;
list_entry_t *le = &free_list;
//(1)find the first block no shorter than n
while ((le = list_next(le)) != &free_list) {
    struct Page *p = le2page(le, page_link);
    if (p->property >= n) {
        page = p;
        break;
    }
}
~~~

* 如果可以找到长度大于等于`n`的块，则那么将该内存块中的对于分配的项，设置标志表明它们已经被使用，在空闲页列表里删除当前页。如果当前空闲块的页数大于`n`，那么分配`n`个页后剩下的第一个页为新的块的形状，它的`property`比原来的小`n`。（**见下面注释**）

  ~~~c
     if (page != NULL) {
          if (page->property > n) {				//如果当前的优先级大于n
              struct Page *p = page + n;
              p->property = page->property - n;	//重新计算优先级
              SetPageProperty(p); 				//重新设置优先级
              list_add_after(&(page->page_link), &(p->page_link));
      }
          list_del(&(page->page_link)); 			//删除当前页
          nr_free -= n;							//更新空闲块数量
          ClearPageProperty(page);
      }
  ~~~

返回找到的`page`

~~~c
    return page;
}
~~~



**（2）`default_free_pages`函数**

**思路**

`default_free_pages`函数是`default_alloc_pages`函数的逆过程.。

将需要释放的空间标记为空之后，需要找到空闲表中合适的位置。由于空闲表中的记录都是按照物理页地址排序的，所以如果插入位置的前驱或者后继刚好和释放后的空间邻接，那么需要将新的空间与前后邻接的空间合并形成更大的空间。

对前方和后方可能出现的连续空闲块进行合并时就需要从头开始搜索`free_list`链表，找到和释放空间可以拼接的前一块和后一块，此时需要注意依然要保持顺序性。

`property`位当该`Page`处于`free_list`中时有效，代表了该`block`中闲置页的个数（包括当前页），而`flags`中的`property`位则被主要用作判断页是否已经被占用。

**代码**

断言`n>0`方便快速检查

~~~c
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
~~~

首先检查每个块中的各个`page property`是否合法

~~~ c
for (; p != base + n; p ++) {
    assert(!PageReserved(p) && !PageProperty(p));
    p->flags = 0;
    set_page_ref(p, 0);
}
~~~

然后设置好释放空间的长度和`page property`

~~~c
base->property = n;
SetPageProperty(base);
~~~

找到插入链表的位置（链表已按照地址从大到小排序）

~~~c
list_entry_t *le = list_next(&free_list);
list_entry_t *prev = &free_list;   
while (le != &free_list) {
    p = le2page(le, page_link);
    if (base < p) {
        break;
    }
    prev = le;
    le = list_next(le);
}
~~~

检查是否可以和链表的前一项中的空间合并

~~~c
p = le2page(prev, page_link);
if (prev != &free_list && p + p -> property == base) {
    p -> property += base -> property;
    ClearPageProperty(base);
} else {
    list_add_after(prev, &(base -> page_link));
    p = base;
}
~~~

检查是否可以和链表的后一项中的空间合并

~~~c
    struct Page *nextp = le2page(le, page_link);
    if (le != &free_list && p + p -> property == nextp) {
        p -> property += nextp -> property;
        ClearPageProperty(nextp);
        list_del(le);
    }
    nr_free += n;
}
~~~



#### 【练习1.2】

> 你的first fit算法是否有进一步的改进空间？

**（1）优化有序链表插入**

我们发现链表查找和有序链表插入是有&Omicron;(n)的复杂度。

在特殊情况下我们可以优化有序链表插入。比如在下面的情况中，对于一个刚刚被释放的内存，加入它的邻接空间都是空闲的，我们是无须对它进行链表插入操作的，而是直接合并到邻接空间中，这样的话复杂度是&Omicron;(1)。

如果要实现这种优化的话，我们要同时在第一个页面和最后一个页面都保存空闲块的信息，这样一来，新的空闲块只需要检查邻接的两个页面就能判断邻接空间块的状态。

**（2）优化链表查找**

我们发现链表查找也是有&Omicron;(n)的复杂度。

如果在每一块连续内存的头指针中，增加一个保存指向这段连续内存的末页的指针变量，则在分配内存查找满足条件的内存块时，遇到空间不够的内存块可以直接跳跃到其末页再继续查找，而不需要依次遍历这段内存块的内部。同样的道理，释放内存后，被释放的内存块在向前合并时，如果在每一块连续内存的末页保存其块大小，同样可以直接完成合并而不需要依次遍历。

**（3）换数据结构**

可以用各种树状结构来代替双向链表实现操作。查找的时候比如进行二分查找，可以优化到&Omicron;(logn)





---

### （二）实现寻找虚拟地址对应的页表项

#### 【练习2.1】

> 通过设置页表和对应的页表项，可建立虚拟内存地址和物理内存地址的对应关系。其中的get_pte函数是设置页表项环节中的一个重要步骤。此函数找到一个虚地址对应的二级页表项的内核虚地址，如果此二级页表项不存在，则分配一个包含此项的二级页表。本练习需要补全get_pte函数 in kern/mm/pmm.c，实现其功能。请仔细查看和理解get_pte函数中的注释。

##### 设计思路与原理分析















