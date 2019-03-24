计 64	嵇天颖	2016010308

## LAB 2

[TOC]



---

### （〇）填写已有实验

> 本实验依赖实验1。请把你做的实验1的代码填入本实验中代码中有`“LAB1”`的注释相应部分。提示：可采用`diff`和`patch`工具进行半自动的合并`（merge）`，也可用一些图形化的比较`/merge`工具来手动合并，比如`meld`，`eclipse`中的`diff/merge`工具，`understand`中的`diff/merge`工具等。

利用了`diffmerge`图形化比较工具实现了代码的合并。

### （一）实现 first-fit 连续物理内存分配算法

#### 【练习1.1】

> 在实现`first fit`内存分配算法的回收函数时，要考虑地址连续的空闲块之间的合并操作。提示:在建立空闲页块链表时，需要按照空闲页块起始地址来排序，形成一个有序的链表。可能会修改`default_pmm.c`中的`default_init，default_init_memmap，default_alloc_pages， default_free_pages`等相关函数。请仔细查看和理解`default_pmm.c`中的注释。



复用原接口

~~~C
//initialize the `free_list` and set `nr_free` to 0.
static void default_init(void) {
    list_init(&free_list);
    nr_free = 0;
}
~~~

~~~c
//initialize a free block
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
    list_add(&free_list, &(base->page_link));
}
~~~





