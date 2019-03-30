计64	嵇天颖	2016010308

## LAB 3

[TOC]

---

### 练习0：填写已有实验

> 本实验依赖实验1/2。请把你做的实验1/2的代码填入本实验中代码中有“LAB1”,“LAB2”的注释相应部分。

利用`diff/merge`工具实现代码的合并。



### 练习1：给未被映射的地址映射上物理页

#### 【练习1.1】

> 完成`do_pgfault（mm/vmm.c）`函数，给未被映射的地址映射上物理页。设置访问权限 的时候需要参考页面所在 `VMA `的权限，同时需要注意映射物理页时需要操作内存控制 结构所指定的页表，而不是内核的页表。

##### 设计原理分析

（1）某一些虚拟内存的空间是合法的，但尚未给它们分配具体的内存页。如果我们访问这些虚拟内存页的时候，就会发生`page fault`异常。

（2）我们利用`page fault`异常，让操作系统在进行异常处理的时候对这些合法的虚拟内存页分配相应的物理内存页。这样我们从中断返回的时候就能进行正常的内存访问。

（3）`page fault`处理流程：`trap_dispatch`函数会根据`page fault`的中断号，将它交给`pgfault_handler`函数，从而进一步交给`do_pgfault`函数进行处理。

##### 设计思路

（1）检查页表中是否有相应的表项，如果表项为空，则说明没有映射过；

* 使用在`lab2`中实现的函数`get_pte`来获取线性地址所对应的虚拟页的起始地址对应到的页表项。
* 如果查询到的`PTE`不为0，则表示对应的物理页可能在内存中或者在外存中，否则就表示对应的物理页尚未被分配，

（2）为没有映射的虚拟页分配一个物理页，并确认分到的物理页不为空。

* `pgdir_alloc_page`函数实现了内存分配功能，我们用这个函数来获取对应的物理页，并且将其与当前的虚拟页设置上映射关系，我们以此来为未被映射的地址映射上物理页。

##### 代码实现

根据注释的提示，我们在`do_pgfault`中补全下面的代码：

首先获取发生缺页错误的`PTE` ，如果`PTE`为0, 说明虚页不存在, 则使用`pgdir_alloc_page`分配。

~~~c
//(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
    cprintf("get_pte in do_pgfault failed\n");
    return ret;
}
//(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr.
if (*ptep == 0) {
    if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
        cprintf("pgdir_alloc_page in do_pgfault failed\n");
        return ret;
    }
}
~~~

