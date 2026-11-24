---
title: Leetcode链表合集
date: 2026-11-24
tags:
  - Leetcode
categories:
  - CS
draft: false
---

| 题型分类 | 题目 |
| --- | --- |
| 理论基础 | [链表理论基础](#链表理论基础) |
| 虚拟头节点 | [203 移除链表元素](#203移除链表元素) |
| 链表设计 | [707 设计链表](#707设计链表) |
| 双指针 | [206 反转链表](#206反转链表) |
| 虚拟头节点 | [24 两两交换链表中的节点](#24两两交换链表中的节点) |
| 双指针 | [19 删除链表的倒数第n个节点](#19删除链表的倒数第n个节点) |
| 双指针 | [160 链表相交](#160链表相交) |
| 快慢指针/数学 | [142 环形链表2](#142环形链表2) |

## 链表理论基础

链表是一种通过指针串联在一起的线性结构，每一个节点由两部分组成，一个是数据域一个是指针域（存放指向下一个节点的指针），最后一个节点的指针域指向null（空指针的意思）。
链表的入口节点称为链表的头结点也就是head。
![](https://file1.kamacoder.com/i/algo/20200806194529815.png)
### 链表的类型
#### 单链表
上面就是单链表
#### 双链表
单链表中的指针域只能指向节点的下一个节点。
双链表：每一个节点有两个指针域，一个指向下一个节点，一个指向上一个节点。
双链表 既可以向前查询也可以向后查询。
![](https://file1.kamacoder.com/i/algo/20200806194559317.png)
#### 循环链表
顾名思义，就是链表首尾相连。
循环链表可以用来解决约瑟夫环问题。
![](https://file1.kamacoder.com/i/algo/20200806194629603.png)
### 链表的存储方式
数组是在内存中是连续分布的，但是链表在内存中可以不是连续分布的。

链表是通过指针域的指针链接在内存中各个节点。
所以链表中的节点在内存中不是连续分布的 ，而是散乱分布在内存中的某地址上，分配机制取决于操作系统的内存管理。
![](https://file1.kamacoder.com/i/algo/20200806194613920.png)
### 链表的定义
C，结构体定义：
```c
typedef struct ListNode {
    int val;
    struct ListNode *next;
} ListNode;//这是对应typedef取得别名，如果没写这个就需要struct ListNode *next，写了就可以ListNode *next
```
Python，类定义：
```python
class ListNode:
     def __init__(self, val=0, next=None):# None 就是 C语言的NULL
         self.val = val
         self.next = next
```
### 链表的基本操作
#### 删除节点
如图：
![](https://file1.kamacoder.com/i/algo/20200806195114541-20230310121459257.png)
只要将C节点的next指针指向E节点就可以了。
#### 添加节点
![](https://file1.kamacoder.com/i/algo/20200806195134331-20230310121503147.png)
可以看出链表的增添和删除都是O(1)操作，也不会影响到其他节点。

但是要注意，要是删除第五个节点，需要从头节点查找到第四个节点通过next指针进行删除操作，查找的时间复杂度是O(n)。
### 与数组对比

|        | 插入删除的时间复杂度 | 查询的时间复杂度 | 使用场景             |
| ------ | ---------- | -------- | ---------------- |
| **数组** | O(n)       | O(1)     | 数据量固定、频繁查询，较少增删  |
| **链表** | O(1)       | O(n)     | 数据量不固定，频繁增删，较少查询 |

## 203移除链表元素

[203.移除链表元素](https://leetcode.cn/problems/remove-linked-list-elements/description/)

题意：删除链表中等于给定值 val 的所有节点。

示例 1： 输入：head = [1,2,6,3,4,5,6], val = 6 输出：[1,2,3,4,5]

示例 2： 输入：head = [], val = 1 输出：[]

示例 3： 输入：head = [7,7,7,7], val = 7 输出：[]
### 思路
这里以链表 1 4 2 4 来举例，移除元素4。
![](https://file1.kamacoder.com/i/algo/20210316095351161.png)
如果使用C，C++编程语言的话，不要忘了还要从内存中删除这两个移除的节点,最终剩下1 2：
![](https://file1.kamacoder.com/i/algo/20210316095418280.png)
这种情况下的移除操作，就是让节点next指针直接指向下下一个节点就可以了，

那么因为单链表的特殊性，只能指向下一个节点，刚刚删除的是链表的中第二个，和第四个节点，那么如果删除的是头结点又该怎么办呢？

这里就涉及如下链表操作的两种方式：
- **直接使用原来的链表来进行删除操作。**
- **设置一个虚拟头结点在进行删除操作。**

第一种操作：直接使用原来的链表来进行移除。

移除头结点和移除其他节点的操作是不一样的，因为链表的其他节点都是通过前一个节点来移除当前节点，而头结点没有前一个节点。

所以头结点如何移除呢，其实只要**将头结点向后移动一位**就可以，这样就从链表中移除了一个头结点。
![](https://file1.kamacoder.com/i/algo/20210316095512470.png)
依然别忘将原头结点从内存中删掉.
![](https://file1.kamacoder.com/i/algo/20210316095543775.png)
这样移除了一个头结点。在单链表中移除头结点 和 移除其他节点的操作方式是不一样，其实在写代码的时候也会发现，需要单独写一段逻辑来处理移除头结点的情况。

第二种操作：

其实**可以设置一个虚拟头结点**，这样原链表的所有节点就都可以按照统一的方式进行移除了。
![](https://file1.kamacoder.com/i/algo/20210316095619221.png)
这里来给链表添加一个虚拟头结点为新的头结点，此时要移除这个旧头结点元素1。

这样是不是就可以使用和移除链表其他节点的方式统一了呢？

来看一下，如何移除元素1 呢，还是熟悉的方式，然后从内存中删除元素1。

最后呢在题目中，return 头结点的时候，别忘了 `return dummyNode->next;`， **这才是新的头结点**
### Python实现
使用虚拟头节点：
```python
class Solution:
    def removeElements(self, head: Optional[ListNode], val: int) -> Optional[ListNode]:# 中这个 optional 是一个表示可选。既可以是 List node 数据类型，也可以是 none的意思，不用手动import ，leetcode内置。这是一个类型注解，也可以不用写，但是指定输入输出格式会比较易懂
        dummy = ListNode(next = head)
        current = dummy
        while current.next:
            if current.next.val == val:
                current.next = current.next.next
            else:
                current = current.next
        return dummy.next
```
### C实现
**方法一：直接使用原来的链表来进行移除节点操作：**
```c
struct ListNode* removeElements(struct ListNode* head, int val) {
    struct ListNode* temp;
    
    // 处理头节点是要删除的值的情况
    while (head && head->val == val) {//当头结点存在并且头结点的值等于val时
        temp = head;
        head = head->next;
        free(temp);//将新的头结点设置为head->next并删除原来的头结点
    }
    
    struct ListNode* current = head;
    
    // 处理非头节点
    while (current && current->next) {
        if (current->next->val == val) {  // ✅ 比较值，不是指针，容易漏->val
            temp = current->next;          // ✅ 保存要删除的节点
            current->next = current->next->next;
            free(temp);                    // ✅ 释放内存
            // 注意：这里不移动 current，继续检查新的 next
        } else {
            current = current->next;       // 只有不删除时才移动
        }
    }
    
    return head;  // ✅ 返回头节点(head始终指向链表的头结点，current会不断向后以最终达到NULL，不可以return current)
}
```
**方法二：设置一个虚拟头结点在进行移除节点操作：**
```c
struct ListNode* removeElements(struct ListNode* head, int val) {//使用虚拟头节点
    struct ListNode dummy;
    dummy.next = head;
    struct ListNode* current = &dummy;//指针需要指向地址，所以要有&
    while(current->next){//current->next==NULL就结束
        if(current->next->val==val){
            struct ListNode* temp = current->next;
            current->next = current->next->next;
            free(temp);//free函数输入是一个指针，所以前面是ListNode *temp
        }else{
            current = current->next;
        }
    }
    return dummy.next;
}
```
> 方法一大部分用的是结构体指针，如`struct ListNode* temp`，方法二大部分用的是结构体本身，如`struct ListNode dummy;`,他们调用的方式有所不同!!!

| 写法            | 含义             | 适用场景                      |
| ------------- | -------------- | ------------------------- |
| `dummy.next`  | 结构体**变量**的成员访问 | `struct ListNode dummy;`  |
| `dummy->next` | 结构体**指针**的成员访问 | `struct ListNode *dummy;` |
```text
dummy 是变量（房子本身）    &dummy 是地址（门牌号）
┌─────────┐                 ┌─────────┐
│ val: ?  │                 │ val: ?  │
│ next: ──┼──→ head         │ next: ──┼──→ head
└─────────┘                 └─────────┘
     ↑                            ↑
   dummy                        &dummy
  (用 . )                      (用 ->)
```

## 707设计链表
[707. 设计链表](https://leetcode.cn/problems/design-linked-list/description/)

> 这道题其实就是头插法、尾插法、删除、增加节点等考研计算机都常见的操作，但是由于`MyLinkedList`这个类导致容易望而却步，其实代码逻辑不难，如果实在写不出来，直接看答案

你可以选择使用单链表或者双链表，设计并实现自己的链表。

单链表中的节点应该具备两个属性：`val` 和 `next` 。`val` 是当前节点的值，`next` 是指向下一个节点的指针/引用。

如果是双向链表，则还需要属性 `prev` 以指示链表中的上一个节点。假设链表中的所有节点下标从 **0** 开始。

实现 `MyLinkedList` 类：

- `MyLinkedList()` 初始化 `MyLinkedList` 对象。
- `int get(int index)` 获取链表中下标为 `index` 的节点的值。如果下标无效，则返回 `-1` 。
- `void addAtHead(int val)` 将一个值为 `val` 的节点插入到链表中第一个元素之前。在插入完成后，新节点会成为链表的第一个节点。
- `void addAtTail(int val)` 将一个值为 `val` 的节点追加到链表中作为链表的最后一个元素。
- `void addAtIndex(int index, int val)` 将一个值为 `val` 的节点插入到链表中下标为 `index` 的节点之前。如果 `index` 等于链表的长度，那么该节点会被追加到链表的末尾。如果 `index` 比长度更大，该节点将 **不会插入** 到链表中。
- `void deleteAtIndex(int index)` 如果下标有效，则删除链表中下标为 `index` 的节点。

### 思路
这道题目设计链表的五个接口，覆盖了链表的常见操作：

- 获取链表第index个节点的数值
- 在链表的最前面插入一个节点
- 在链表的最后面插入一个节点
- 在链表第index个节点前面插入一个节点
- 删除链表的第index个节点

这里涉及对链表的一些增删操作，还是设置一个虚拟头节点。
### 题解
```c
typedef struct Node {
	int val;
	struct Node* next;
} Node;


typedef struct {
	int size;
	Node* data;
} MyLinkedList;


MyLinkedList* myLinkedListCreate() {
	//1. 分配链表管理器的空间
	MyLinkedList* obj = (MyLinkedList*)malloc(sizeof(MyLinkedList));
	//2. 创建虚拟头节点
    Node* head = (Node*)malloc(sizeof(Node));
    //3. 初始化虚拟头节点的next指针
	head->next = (void*)0;//空指针的意思，也可以写成NULL
	//4. 将虚拟头节点连接到链表管理器
	obj->data = head;
	//5. 初始化链表大小
    obj->size = 0;
    
	return obj;
}

//获取链表中第 index 个节点的值。如果索引无效，则返回-1。
int myLinkedListGet(MyLinkedList* obj, int index) {
	if (index < 0 || index >= obj->size) return -1;

	Node* cur = obj->data;//这其实就是虚拟头节点
	while (index-- >= 0) {//题目说了链表节点从下标0开始
        cur = cur->next;
    }

	return cur->val;
}

//在链表的第一个元素之前添加一个值为 val 的节点。插入后，新节点将成为链表的第一个节点。其实就是头插法
void myLinkedListAddAtHead(MyLinkedList* obj, int val) {
	Node* node = (Node*)malloc(sizeof(Node));
	node->val = val;

	node->next = obj->data->next;//新插入节点指向虚拟头节点的下一个节点，即第一个节点
	obj->data->next = node;
	obj->size++;
}

//将值为 val 的节点追加到链表的最后一个元素
void myLinkedListAddAtTail(MyLinkedList* obj, int val) {
	Node* cur = obj->data;
	while (cur->next != ((void*)0)) {
        cur = cur->next;
    }

	Node* tail = (Node*)malloc(sizeof(Node));
	tail->val = val;
	tail->next = (void*)0;
	cur->next = tail;
	obj->size++;
}

//在链表中的第 index 个节点之前添加值为 val  的节点。如果 index 等于链表的长度，则该节点将附加到链表的末尾。如果 index 大于链表长度，则不会插入节点。如果index小于0，则在头部插入节点
void myLinkedListAddAtIndex(MyLinkedList* obj, int index, int val) {
	if (index > obj->size) return;

	Node* cur = obj->data;
	while (index-- > 0) { 
        cur = cur->next;
    }

	Node* node = (Node*)malloc(sizeof(Node));
	node->val = val;
	node->next = cur->next;
	cur->next = node;
	obj->size++;
}

//如果索引 index 有效，则删除链表中的第 index 个节点
void myLinkedListDeleteAtIndex(MyLinkedList* obj, int index) {
	if (index < 0 || index >= obj->size) return;

	Node* cur = obj->data;
	while (index-- > 0) {
        cur = cur->next;
    }

	Node* temp = cur->next;
	cur->next = temp->next;
	free(temp);
	obj->size--;
}

//释放内存函数
void myLinkedListFree(MyLinkedList* obj) {
	Node* tmp = obj->data;
	while (tmp != NULL) {
		Node* n = tmp;
		tmp = tmp->next;
		free(n);
	}
	free(obj);
}

/**
 * Your MyLinkedList struct will be instantiated and called as such:
 * MyLinkedList* obj = myLinkedListCreate();
 * int param_1 = myLinkedListGet(obj, index);
 
 * myLinkedListAddAtHead(obj, val);
 
 * myLinkedListAddAtTail(obj, val);
 
 * myLinkedListAddAtIndex(obj, index, val);
 
 * myLinkedListDeleteAtIndex(obj, index);
 
 * myLinkedListFree(obj);
*/
```
C代码解释:
Q：创建后的链表状态：
A：
```text
外部视角:
MyLinkedList* obj ──→ [size: 0]
                       [data: ──→ 指向下面的节点]

内部结构:
虚拟头节点 ──→ [val: 任意值] → NULL
              [next: NULL]    
                ↑
              (实际链表为空，无其他节点)
```

Python:
```python
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next
        
class MyLinkedList:
    def __init__(self):
        self.dummy_head = ListNode()
        self.size = 0

    def get(self, index: int) -> int:
        if index < 0 or index >= self.size:
            return -1
        
        current = self.dummy_head.next
        for i in range(index):
            current = current.next
            
        return current.val

    def addAtHead(self, val: int) -> None:
        self.dummy_head.next = ListNode(val, self.dummy_head.next)
        self.size += 1

    def addAtTail(self, val: int) -> None:
        current = self.dummy_head
        while current.next:
            current = current.next
        current.next = ListNode(val)
        self.size += 1

    def addAtIndex(self, index: int, val: int) -> None:
        if index < 0 or index > self.size:
            return
        
        current = self.dummy_head
        for i in range(index):
            current = current.next
        current.next = ListNode(val, current.next)
        self.size += 1

    def deleteAtIndex(self, index: int) -> None:
        if index < 0 or index >= self.size:
            return
        
        current = self.dummy_head
        for i in range(index):
            current = current.next
        current.next = current.next.next
        self.size -= 1


# Your MyLinkedList object will be instantiated and called as such:
# obj = MyLinkedList()
# param_1 = obj.get(index)
# obj.addAtHead(val)
# obj.addAtTail(val)
# obj.addAtIndex(index,val)
# obj.deleteAtIndex(index)
```

## 206反转链表
[206. 反转链表](https://leetcode.cn/problems/reverse-linked-list/description/)

给你单链表的头节点 `head`，请你反转链表，并返回反转后的链表。

**示例 1：**

![](https://assets.leetcode.com/uploads/2021/02/19/rev1ex1.jpg)
- 输入：head = [1,2,3,4,5]
- 输出：[5,4,3,2,1]

**示例 2：**
- 输入：head = [1,2]
- 输出：[2,1]

**示例 3：**
- 输入：head = []
- 输出：[]

**进阶：** 链表可以选用迭代或递归方式完成反转。你能否用两种方法解决这道题？
### 思路
如果再定义一个新的链表，实现链表元素的反转，其实这是对内存空间的浪费。

其实只需要改变链表的next指针的指向，直接将链表反转 ，而不用重新定义一个新的链表。

之前链表的头节点是元素1， 反转之后头结点就是元素5 ，这里并没有添加或者删除节点，仅仅是改变next指针的方向。
![](https://file1.kamacoder.com/i/algo/206.%E7%BF%BB%E8%BD%AC%E9%93%BE%E8%A1%A8.gif)
首先定义一个cur指针，指向头结点，再定义一个pre指针，初始化为null。

然后就要开始反转了，首先要把 cur->next 节点用tmp指针保存一下，也就是保存一下这个节点。

为什么要保存一下这个节点呢，因为接下来要**改变 cur->next 的指向**了，将cur->next 指向pre ，此时已经反转了第一个节点了。

接下来，就是循环走如下代码逻辑了，继续移动pre和cur指针。

最后，cur 指针已经指向了null，循环结束，链表也反转完毕了。 此时我们return pre指针就可以了，pre指针就指向了新的头结点。
### 题解
C:
```c
struct ListNode* reverseList(struct ListNode* head) {
    struct ListNode *cur, *pre,*temp;
    cur = head;//当前指针
    pre = NULL;// 前一个节点（新链表的尾）
  
    while(cur){
        temp = cur->next;// 1. 保存下一个节点
        cur->next = pre;// 2. 反转当前指针
        pre = cur;// 3. pre前移
        cur = temp;// 4. cur前移
    }
  
    return pre;
}
```
Python:
```python
class Solution:
    def reverseList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        pre = None
        cur = head
  
        while cur:
            temp = cur.next
            cur.next = pre
            pre = cur
            cur = temp
        return pre
```

## 24两两交换链表中的节点
[24. 两两交换链表中的节点](https://leetcode.cn/problems/swap-nodes-in-pairs/description/)

给定一个链表，两两交换其中相邻的节点，并返回交换后链表的头节点。你必须在不修改节点内部值的情况下完成本题（即，只能进行节点交换）。

**示例 1：**
![](https://assets.leetcode.com/uploads/2020/10/03/swap_ex1.jpg)
- 输入：head = [1,2,3,4]
- 输出：[2,1,4,3]

**示例 2：**
- 输入：head = []
- 输出：[]

**示例 3：**
- 输入：head = [1]
- 输出：[1]

**示例 4：**
- 输入：head = [1,2,3]
- 输出：[2,1,3]

### 思路
首先建议，对链表有增删等改动的操作，都加一个虚拟头节点dummy。

这道题正常的画图模拟过程即可：

初始时，cur指向虚拟头结点，然后进行如下三步：
![](https://file1.kamacoder.com/i/algo/24.%E4%B8%A4%E4%B8%A4%E4%BA%A4%E6%8D%A2%E9%93%BE%E8%A1%A8%E4%B8%AD%E7%9A%84%E8%8A%82%E7%82%B91.png)
操作之后，链表如下：
![](https://file1.kamacoder.com/i/algo/24.%E4%B8%A4%E4%B8%A4%E4%BA%A4%E6%8D%A2%E9%93%BE%E8%A1%A8%E4%B8%AD%E7%9A%84%E8%8A%82%E7%82%B92.png)

### 题解
```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */
struct ListNode* swapPairs(struct ListNode* head) {
    typedef struct ListNode ListNode;//上面的定义没有typedef，这里要创建别名
    ListNode *dummy = (ListNode*)malloc(sizeof(ListNode));
    dummy->next = head;
  
    ListNode * right = head;
    ListNode * left = dummy;
  
    while(right && left && right->next){//当存在2个以上的节点时进入while，一个节点或者空链表直接return 虚拟头节点的next
        left->next = right->next;
        right->next = left->next->next;
        left->next->next=right;
        left=right;
        right = right ->next;
    }
  
    return dummy->next;//不能用head，因为head可能被后置
}
```

```python
class Solution:
    def swapPairs(self, head: Optional[ListNode]) -> Optional[ListNode]:
        dummy = ListNode(next = head)
        left = dummy
        right = head
        while right and right.next:
            left.next = right.next
            right.next = right.next.next
            left.next.next = right
            left = right
            right = right.next
        return dummy.next
```

## 19删除链表的倒数第n个节点

[19. 删除链表的倒数第N个节点](https://leetcode.cn/problems/remove-nth-node-from-end-of-list/description/)

给你一个链表，删除链表的倒数第 n 个结点，并且返回链表的头结点。
**示例 1：**
- 输入：head = [1,2,3,4,5], n = 2
- 输出：[1,2,3,5]

**示例 2：**
- 输入：head = [1], n = 1
- 输出：[]

**示例 3：**
- 输入：head = [1,2], n = 1
- 输出：[1]

**进阶：** 你能尝试使用一趟扫描实现吗？

### 思路
双指针的经典应用，如果要删除倒数第n个节点，让fast移动n步，然后让fast和slow同时移动，直到fast指向链表末尾。删掉slow所指向的节点就可以了。

另外最好加一个虚拟头节点dummy方便处理。
1. 定义fast指针和slow指针，初始值为虚拟头结点
2. fast首先走n步
3. 然后fast和slow同时移动，直到fast指向末尾
4. 删除slow指向的下一个节点
### 题解
C:
```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */
struct ListNode* removeNthFromEnd(struct ListNode* head, int n) {
    struct ListNode * dummy = (struct ListNode*)malloc(sizeof(struct ListNode));
    dummy->next = head;
  
    struct ListNode* fast = head;
    struct ListNode* slow = dummy;
  
    for(int i = 0;i<n;i++){//可以画图看看fast要先行几步，这里先行n步
        fast=fast->next;
    }
  
    while(fast){
        fast=fast->next;
        slow=slow->next;
    }//同步后移
  
  //删除操作
    struct ListNode* temp = slow->next;
    slow->next=slow->next->next;
    free(temp);
  
    return dummy->next;
}
```
**遇到的问题**
野指针：`struct ListNode *dummy;`,干脆就统一用栈上分配一个实在的结构体，针对于考研和力扣的题，基本上都是写函数，连 free 都不用。

| 方式           | 代码                                                          | 是否需要 malloc | 适用场景         |
| ------------ | ----------------------------------------------------------- | ----------- | ------------ |
| **栈上分配**（推荐） | `struct ListNode dummy;`                                    | ❌ 不需要       | 临时辅助节点，函数内使用 |
| **堆上分配**     | `struct ListNode *dummy = malloc(sizeof(struct ListNode));` | ✅ 需要        | 需要跨函数传递或动态管理 |


Python:
```python
class Solution:
    def removeNthFromEnd(self, head: Optional[ListNode], n: int) -> Optional[ListNode]:
        dummy = ListNode(next = head)
        if dummy.next == None:
            print("链表为空")
            return False
        left,right = dummy,dummy
        while n > 0:
            right = right.next
            n -= 1
        while right.next:
            left = left.next
            right = right.next
        left.next = left.next.next
        return dummy.next
```

## 160链表相交
[160. 链表相交](https://leetcode.cn/problems/intersection-of-two-linked-lists/description/)

给你两个单链表的头节点 `headA` 和 `headB`，请你找出并返回两个单链表**相交的起始节点**。如果两个链表不存在相交节点，返回 null。

例如，下面的两个链表在节点 c1 开始相交：
![](https://assets.leetcode.cn/aliyun-lc-upload/uploads/2018/12/14/160_statement.png)
在评测系统中，**相交的定义是基于节点地址而非节点值**。如果两个链表在某个节点相交，则该节点在两个链表中必须是同一个节点（即**内存地址相同**）。

**示例 1：**
![](https://assets.leetcode.com/uploads/2021/03/05/160_example_1_1.png)
- 输入：intersectVal = 8, listA = [4,1,8,4,5], listB = [5,6,1,8,4,5], skipA = 2, skipB = 3
- 输出：Intersected at '8'

**示例 2：**
![](https://assets.leetcode.com/uploads/2021/03/05/160_example_2.png)
- 输入：intersectVal = 2, listA = [1,9,1,2,4], listB = [3,2,4], skipA = 3, skipB = 1
- 输出：Intersected at '2'

**示例 3：**
![](https://assets.leetcode.cn/aliyun-lc-upload/uploads/2018/12/14/160_example_3.png)
- 输入：intersectVal = 0, listA = [2,6,4], listB = [1,5], skipA = 3, skipB = 2
- 输出：null

**进阶：** 你能设计一个时间复杂度为 O(n)、仅用 O(1) 内存的解决方案吗？

### 思路
简单来说，就是求两个链表交点节点的**指针**。题目已经说了，相交的定义是指针相等。

先让curA指向链表A的头结点，curB指向链表B的头结点
![](https://file1.kamacoder.com/i/algo/%E9%9D%A2%E8%AF%95%E9%A2%9802.07.%E9%93%BE%E8%A1%A8%E7%9B%B8%E4%BA%A4_1.png)
求出两个链表的长度，并求出两个链表长度的差值，然后让curA移动到，和curB 末尾对齐的位置，从此之后才可能找到相交的地方
![](https://file1.kamacoder.com/i/algo/%E9%9D%A2%E8%AF%95%E9%A2%9802.07.%E9%93%BE%E8%A1%A8%E7%9B%B8%E4%BA%A4_2.png)
此时我们就可以比较curA和curB是否相同，如果不相同，同时向后移动curA和curB，如果遇到curA == curB，则找到交点。
否则循环退出返回空指针。
### 题解
```c
struct ListNode *getIntersectionNode(struct ListNode *headA, struct ListNode *headB) {
    //初始化
    int lengthA = 0,lengthB=0;
    struct ListNode * curA = headA, *curB = headB;
  
    //获取链表长度
    while(curA){
        lengthA++;
        curA = curA->next;
    }
    while(curB){
        lengthB++;
        curB = curB->next;
    }
  
    //求链表长度差值，更长的需要缩短，并且二者的末端对齐
    int gap = (lengthA>=lengthB)?(lengthA-lengthB):(lengthB-lengthA);//简便的三目运算求长度差
    curA = headA;
    curB = headB;//都回退到头节点等待移动cur指针
    if(lengthA>=lengthB){
        while(gap--){
            curA=curA->next;
        }
    }else{
        while(gap--){
            curB=curB->next;
        }
    }
  
    //现在末端对齐且长链“缩短”，开始同步后退
    while(curA){
        if(curA==curB){
            return curA;
        }
        curA=curA->next;
        curB=curB->next;
    }
  
    return NULL;
}
```

Python:

Python 里根本不用"获取地址"，直接用 is（或 ==）比较两个变量即可，效果和你 C 里的 pA == pB 完全一样。Python 的变量本身就是对象的引用（相当于"自动解引用的指针"）。
```python
class Solution:
    def getIntersectionNode(self, headA: ListNode, headB: ListNode) -> Optional[ListNode]:
        curA, curB = headA, headB
        lenA = lenB = 0
        while curA:
            lenA += 1
            curA = curA.next
        while curB:
            lenB += 1
            curB = curB.next

        # 长链表先走 gap 步，对齐
        if lenA > lenB:
            for _ in range(lenA - lenB):
                headA = headA.next
        else:
            for _ in range(lenB - lenA):
                headB = headB.next

        while headA and headB:
            if headA is headB:
                return headA
            headA = headA.next
            headB = headB.next
        return None
```

## 142环形链表2

[142. 环形链表II](https://leetcode.cn/problems/linked-list-cycle-ii/description/)

给定一个链表的头节点 `head`，返回链表开始入环的第一个节点。如果链表无环，则返回 `null`。

如果链表中有某个节点，可以通过连续跟踪 `next` 指针再次到达，则链表中存在环。为了表示给定链表中的环，评测系统内部使用整数 `pos` 来表示链表尾连接到链表中的位置（索引从 0 开始）。如果 `pos` 是 -1，则在该链表中没有环。注意：`pos` 不作为参数进行传递，仅仅是为了标识链表的实际情况。

不允许修改链表。

**示例 1：**
![](https://assets.leetcode.com/uploads/2018/12/07/circularlinkedlist.png)
- 输入：head = [3,2,0,-4], pos = 1
- 输出：返回索引为 1 的链表节点
- 解释：链表中有一个环，其尾部连接到第二个节点。

**示例 2：**
- 输入：head = [1,2], pos = 0
- 输出：返回索引为 0 的链表节点
- 解释：链表中有一个环，其尾部连接到第一个节点。

**示例 3：**
- 输入：head = [1], pos = -1
- 输出：返回 null
- 解释：链表中没有环。

**进阶：** 你能用 O(1)（即，常量）内存解决此问题吗？

### 思路
pos不是一个参数，只是告诉你在有环的情况下你应该返回哪个节点。有没有环、以及需要返回哪个节点需要自己探索
这道题目，不仅考察对链表的操作，而且还需要一些数学推导。

主要考察两知识点：
- 判断链表是否环
- 如果有环，如何找到这个环的入口

#### 判断链表是否环
可以使用快慢指针法，分别定义 fast 和 slow 指针，从头结点出发，fast指针每次移动两个节点，slow指针每次移动一个节点，如果 fast 和 slow指针在途中相遇 ，说明这个链表有环。

**fast指针一定先进入环中，如果fast指针和slow指针相遇的话，一定是在环中相遇，这是毋庸置疑的。** 可以自己任意画几个环试试，他们终将相遇。
![](https://file1.kamacoder.com/i/algo/141.%E7%8E%AF%E5%BD%A2%E9%93%BE%E8%A1%A8.gif)
#### 如何找到这个环的入口
这就需要数学推导了。

假设从头结点到环形入口节点 的节点数为x。 环形入口节点到 fast指针与slow指针相遇节点 节点数为y。 从相遇节点 再到环形入口节点节点数为 z。
![](https://file1.kamacoder.com/i/algo/20220925103433.png)
那么相遇时： slow指针走过的节点数为: `x + y`， fast指针走过的节点数：`x + y + n (y + z)`，n为fast指针在环内走了n圈才遇到slow指针， （y+z）为 一圈内节点的个数A。

因为fast指针是一步走两个节点，slow指针一步走一个节点， 所以 fast指针走过的节点数 = slow指针走过的节点数 * 2：
`(x + y) * 2 = x + y + n (y + z)`

两边消掉一个（x+y）: `x + y = n (y + z)`

因为要找环形的入口，那么要求的是x，因为x表示 头结点到 环形入口节点的的距离。

所以要求x ，将x单独放在左面：`x = n (y + z) - y` ,

再从n(y+z)中提出一个 （y+z）来，整理公式之后为如下公式：`x = (n - 1) (y + z) + z` 注意这里n一定是大于等于1的，因为 fast指针至少要多走一圈才能相遇slow指针。

这个公式说明什么呢？

先拿n为1的情况来举例，意味着fast指针在环形里转了一圈之后，就遇到了 slow指针了。

当 n为1的时候，公式就化解为 `x = z`，

这就意味着，**从头结点出发一个指针，从相遇节点 也出发一个指针，这两个指针每次只走一个节点， 那么当这两个指针相遇的时候就是 环形入口的节点**。

也就是在相遇节点处，定义一个指针index1，在头结点处定一个指针index2。

让index1和index2同时移动，每次移动一个节点， 那么他们相遇的地方就是 环形入口的节点。

n如果大于1是什么情况呢，就是fast指针在环形转n圈之后才遇到 slow指针。

其实这种情况和n为1的时候 效果是一样的，一样可以通过这个方法找到 环形的入口节点，只不过，index1 指针在环里 多转了(n-1)圈，然后再遇到index2，相遇点依然是环形的入口节点。
### 题解
C：
```c
struct ListNode *detectCycle(struct ListNode *head) {
    struct ListNode *fast = head, *slow = head;
    while (fast && fast->next) {
        // 这里判断两个指针是否相等，所以移位操作放在前面
        slow = slow->next;
        fast = fast->next->next;
        if (slow == fast) { // 相交，开始找环形入口：分别从头部和从交点出发，找到相遇的点就是环形入口
            struct ListNode *f = fast, *h = head;
            while (f != h) f = f->next, h = h->next;
            return h;
        }
    }
    return NULL;
}
```

Python：
```python
class Solution:
    def detectCycle(self, head: ListNode) -> ListNode:
        slow = head
        fast = head
        
        while fast and fast.next:
            slow = slow.next
            fast = fast.next.next
            
            # If there is a cycle, the slow and fast pointers will eventually meet
            if slow == fast:
                # Move one of the pointers back to the start of the list
                slow = head
                while slow != fast:
                    slow = slow.next
                    fast = fast.next
                return slow
        # If there is no cycle, return None
        return None
```
