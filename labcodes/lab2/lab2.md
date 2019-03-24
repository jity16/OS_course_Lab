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
      return page;
  }
  ~~~

  

















