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

（1）**原理分析**：

* 为了能够建立正确的地址映射关系，我们的`lab2`在链接阶段生成了`ucore`执行代码的虚地址，然后`bootloader`与`ucore`一起在运行时处理地址映射，最终实现段页式映射关系`virt addr = liner addr = phy addr +0xC0000000`。从`tools/kernel.ld`文件中我们得知`lab2`形成`ucore`的起始虚拟地址是从`0xC0100000`开始。
* 系统采用了二级页表来建立线性地址与物理地址之间的映射关系。`default_pmm_manager`是我们的物理内存管理器，我们用它来实现动态分配和释放内存页的功能，我们也可以用它来获得所需要的空闲物理页。
* 系统执行中地址映射分为三个阶段：
  * 第一个阶段是开启保护模式，创建启动段表：这里虚拟地址、线性地址以及物理地址之间的映射关系与`lab1`的一样。
  * 第二个阶段是创建初始页目录表，开启分页模式：这个阶段更新映射关系的同时将运行中的内核（EIP）从低虚拟地址“迁移”到高虚拟地址，而不造成伤害。
  * 第三个阶段是完善段表和页表：`pmm_init`函数将页目录表项补充完成（扩充到`0~KMEMSIZE`）。然后，更新段映射机制，使用一个新的段表。新段表除了包括内核态的代码段和数据段描述符，还包括用户态的代码段和数据段描述符以及`TSS`段的描述符。

（2）**设计思路**：

首先要查询一级页表，根据线性地址`la`在一级页表`pgdir`中寻找二级页表的起始地址。如果二级页表不存在，那么要根据参数`create`来判断是否分配二级页表的内存空间，若不分配则返回空。

`get_pte`函数是通过`PDT`的基址`pgdir`和线性地址`la`来获取`pte`。`PDX`根据`la`获取其页目录的索引，根据此索引可以得到页目录项`pde`，由于可能对其进行修改，这里采用指向`pde`的指针`pdep`，而`*pdep`中保存的便是`pde`的真实内容。创建了`pde`后，需要返回的值是`pte`的指针，这里先将`pde`中的地址转化为程序可用的虚拟地址。将这个地址转化为`pte`数据类型的指针，然后根据`la`的值索引出对应的`pte`表项。



##### 代码及实现分析

* 如果原本就有二级页表，或者新建立了页表，则只需返回对应项的地址即可

  ~~~c
  if (!(pgdir[PDX(la)] & PTE_P)) {
      //......
  }
  return (pte_t *)KADDR(PDE_ADDR(pgdir[PDX(la)])) + PTX(la);
  ~~~

* 如果发现对应的二级页表不存在，那么我们需要根据参数`create`的值来处理是否创建新的二级页表

  * 如果`create`的参数为0，则`get_pte`返回`NULL`

  * 如果`create`的参数不为0

    * 我们通过`alloc_page`来实现申请一个新的物理页的操作

    ~~~c
    struct Page *page;
    if (!create || (page = alloc_page()) == NULL)
        return NULL;
    ~~~

    * 再在一级页表中添加页目录项执行表示二级页表的新物理页(**代码解释见下面代码的注释**)

      设一个`32bit`线性地址`la`有一个对应的`32bit`物理地址`pa`，如果在以`la`的高`10`位为索引值的页目录项中的存在位`（PTE_P）`为`0`，表示缺少对应的页表空间，则可通过`alloc_page`获得一个空闲物理页给页表，页表起始物理地址是按`4096`字节对齐的，这样填写页目录项的内容为`页目录项内容 = (页表起始物理地址 & ~0x0FFF) | PTE_U | PTE_W | PTE_P`

    ~~~c
    	//set page reference
        set_page_ref(page, 1);
    	//get linear address of page
        uintptr_t pa = page2pa(page);
    	//clear page content using memset
        memset(KADDR(pa), 0, PGSIZE);
    	//set page directory entry's permission
        pgdir[PDX(la)] = (pa & ~0xFFF) | PTE_P | PTE_W | PTE_U;
    }
    ~~~



#### 【练习2.2】

> 请描述页目录项`（Page Directory Entry）`和页表项`（Page Table Entry）`中每个组成部分的含义以及对`ucore`而言的潜在用处。

我们从`mmh.h`中观察`PDE`和`PTE`的内容定义，其中列出了页目录项和页表项的入口标志字段。

因为页的映射是以物理页面为单位进行，所以页面对应的物理地址总是按照`4096`字节对齐的，物理地址低`0-11`位总是零，所以在页目录项和页表项中，低`0-11`位可以用于作为标志字段使用。

~~~c
/* page table/directory entry flags */
#define PTE_P           0x001                   // 当前项是否存在，用于判断缺页
#define PTE_W           0x002                   // 当前项是否可写，标志权限
#define PTE_U           0x004                   // 用户是否可获取，标志权限
#define PTE_PWT         0x008                   // 写直达缓存机制,硬件使用Write Through
#define PTE_PCD         0x010                   // 禁用缓存，硬件使用Cache-Disable
#define PTE_A           0x020                   // 访问标志（Accessed）
#define PTE_D           0x040                   // 页是否被修改，硬件使用（dirty)
#define PTE_PS          0x080                   // 页大小
#define PTE_MBZ         0x180                   // 必须为0的位
#define PTE_AVAIL       0xE00                   // 软件使用的位，可任意设置            
~~~

高`12-31`位是`Page Table 4KB Aligned Address`，也就是对应的页表地址。



#### 【练习2.3】















