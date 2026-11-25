---
title: Leetcode双指针合集
date: 2026-11-27
tags:
  - Leetcode
categories:
  - CS
draft: false
---

| 题型分类 | 题目 |
| --- | --- |
| 快慢指针 | [27 移除元素](#27移除元素) |
| 双指针 | [344 反转字符串](#344反转字符串) |
| 双指针 | [替换数字](#替换数字) |
| 双指针 | [151 翻转字符串里的单词](#151翻转字符串里的单词) |
| 双指针 | [206 反转链表](#206反转链表) |
| 双指针 | [19 删除链表的倒数第n个节点](#19删除链表的倒数第n个节点) |
| 双指针 | [160 链表相交](#160链表相交) |
| 快慢指针 | [142 环形链表2](#142环形链表2) |
| 排序/双指针 | [15 三数之和](#15三数之和) |
| 排序/双指针 | [18 四数之和](#18四数之和) |

## 27移除元素

[27.移除元素](https://leetcode.cn/problems/remove-element/)

给你一个数组 nums 和一个值 val，你需要 **原地** 移除所有数值等于 val 的元素，并返回移除后数组的新长度。

不要使用额外的数组空间，你必须仅使用 O(1) 额外空间并**原地**修改输入数组。

元素的顺序可以改变。你不需要考虑数组中超出新长度后面的元素。

示例 1: 给定 nums = [3,2,2,3], val = 3, 函数应该返回新的长度 2, 并且 nums 中的前两个元素均为 2。 你不需要考虑数组中超出新长度后面的元素。

示例 2: 给定 nums = [0,1,2,2,3,0,4,2], val = 2, 函数应该返回新的长度 5, 并且 nums 中的前五个元素为 0, 1, 3, 0, 4。

**你不需要考虑数组中超出新长度后面的元素**。

### 思路
**数组的元素在内存地址中是连续的，不能单独删除数组中的某个元素，只能覆盖。**
### 暴力解法
两层for循环，一个for循环遍历数组元素 ，第二个for循环更新数组。暴力解法的时间复杂度是$O(n^2)$

删除过程如下：

![](https://file1.kamacoder.com/i/algo/27.%E7%A7%BB%E9%99%A4%E5%85%83%E7%B4%A0-%E6%9A%B4%E5%8A%9B%E8%A7%A3%E6%B3%95.gif)

```c
int removeElement(int* nums, int numsSize, int val) {//暴力解法
    int length = numsSize;
    for(int i = 0;i<length;i++){
        if(nums[i] == val){
            for(int j = i;j < length - 1;j++){
                nums[j] = nums[j+1];
            }
        length--;
        i--;//因为当前位置的元素被后面的替换，所以要再检查一遍
        }
    }
    return length;
}
```
### 双指针解法
题目只要求返回新长度，并保证数组前 `k` 个元素是结果。**它并不关心数组后面是什么**。

这给了你什么"操作空间"？

双指针法（快慢指针法）： **通过一个快指针和慢指针在一个for循环下完成两个for循环的工作。**

定义快慢指针:
- 快指针：寻找新数组的元素 ，新数组就是不含有目标元素的数组
- 慢指针：指向更新 新数组下标的位置

![](https://file1.kamacoder.com/i/algo/27.%E7%A7%BB%E9%99%A4%E5%85%83%E7%B4%A0-%E5%8F%8C%E6%8C%87%E9%92%88%E6%B3%95.gif)

代码如下：
```c
int removeElement(int* nums, int numsSize, int val) {
    int slow = 0;
    for(int fast = 0;fast<numsSize;fast++){
        if(nums[fast]!=val){
            nums[slow]=nums[fast];
            slow++;
        }
    }
    return slow;
}
```

```python
class Solution:
    def removeElement(self, nums: List[int], val: int) -> int:
        left = 0
        right = 0
        while right<len(nums):
            if nums[right]==val:
                right += 1
            else:
                nums[left] = nums[right]
                left +=1
                right+=1
        return left
```
快指针负责探路，慢指针负责指向需要修改的地方；如果没有遇到目标值，快慢指针同时向前移动；如果遇到目标值，慢指针不动(等待快指针指向一个非目标值时被赋值)，快指针继续移动。

## 344反转字符串

[344.反转字符串](https://leetcode.cn/problems/reverse-string/)

编写一个函数，其作用是**原地**反转输入字符串。

**示例：**
```
输入：s = ["h","e","l","l","o"]
输出：["o","l","l","e","h"]

输入：s = ["H","a","n","n","a","h"]
输出：["h","a","n","n","a","H"]
```
### 思路
- 使用**双指针**从字符串两端向中间移动
- 每次循环交换两个指针指向的字符
- left < right 时继续，left >= right 时停止
- 这是反转问题的**基础模板**
### 题解
```c
void reverseString(char* s, int sSize) {
    int left = 0;
    int right = sSize - 1;
    while(left<right){
        char temp = s[right];//用一个中间变量交换
        s[right] = s[left];
        s[left] = temp;
        left++;
        right--;
    }
}
```

```python
class Solution:
    def reverseString(self, s: List[str]) -> None:
        """
        Do not return anything, modify s in-place instead.
        """
        left = 0
        right = len(s)-1
        while left<right :
            temp = s[right]
            s[right] = s[left]
            s[left] = temp
            left +=1
            right -=1
```

## 替换数字

这是卡码网的一道题：[替换数字](https://kamacoder.com/problempage.php?pid=1064)。需要控制输入输出。
给定一个字符串 s，它包含**小写字母和数字字符**，请编写一个函数，将字符串中的字母字符保持不变，而将每个数字字符替换为number。

例如，对于输入字符串 "a1b2c3"，函数应该将其转换为 "anumberbnumbercnumber"。
对于输入字符串 "a5b"，函数应该将其转换为 "anumberb"

输入：一个字符串 s,s 仅包含小写字母和数字字符。
输出：打印一个新的字符串，其中每个数字字符都被替换为了number

样例输入：a1b2c3
样例输出：anumberbnumbercnumber

数据范围：  1 <= s.length < 10000
### 思路
- 这是一道**模拟题**，考察字符串操作
- 不能直接修改（因为数字变长），需要**先统计，再扩容，最后从后向前填入**
- 使用**双指针**从后向前填充
- 核心思想：**从后往前填充，避免数据覆盖**
![](https://file1.kamacoder.com/i/algo/20231030173058.png)
为什么要从后往前遍历？因为我们把输入字符串s放在了输出字符串str的前面，如果从前面开始向后覆盖的话，会把一些字母覆盖掉，比如输入 `a1b`，如果从前往后写，`str[0] = 'a'` ✓；发现 `str[1] = '1'`，要展开成 `number`（6个字符）；需要把 `str[1]到str[6]` 都占用；但 `str[2] = 'b'` 还没处理，就被覆盖了！

### 题解
先补充一下字符和数组的区别，在C语言中，字符可以认为是一个字符数组，数组是字符最常见的存储方式。把一个字符串存入一个数组时，也把结束符 '\0'存入数组，并以此作为该字符串是否结束的标志。

```c
#include<stdio.h>
#include <stdlib.h>

int main(){
    char s[10000];
    scanf("%s",s);
  
    //计算数字的数量以及需要扩充多大的数组
    int i = 0;
    int numcount = 0;//数字数量
    int strcount = 0;//输入字符串长度
    while(s[i]!='\0'){
        if(s[i]>='0'&&s[i]<='9'){
            numcount++,strcount++;
        }else{
            strcount++;
        }
        i++;
    }
    int len = numcount*5+strcount;//最终的长度,number是6个字母但是需要去掉strcount重复的部分
    char *str = (char*)malloc(sizeof(char)*(len+1));
    for(i = 0;i<strcount;i++){
        str[i] = s[i];//把输入的s字符串搬到str
    }
  
    int left = strcount - 1;
    int right = len - 1;
  
    while(left>=0){
        if(str[left]>='0'&&str[left]<='9'){
            str[right--] = 'r';//等价于先赋值str[right]，再自减
            str[right--] = 'e';
            str[right--] = 'b';
            str[right--] = 'm';
            str[right--] = 'u';
            str[right--] = 'n';
        }else{
            //原先就是字母
            str[right--] = str[left];
        }
        left--;
    }
  
    str[len] = '\0';
    printf("%s",str);
    free(str);
    return 0;
}
```

Python:
```python
def replace_digits(s: str) -> str:
    res = []
    for ch in s:
        if '0'<= ch <= '9':
            res.append('number')
        else:
            res.append(ch)
    return ''.join(res)
  
# ============= 关键在这下面（ACM模式的输入输出） =============
if __name__ == "__main__":
    s = input()          # 从控制台读取一行字符串（比如 "a1b2c3"）
    result = replace_digits(s)
    print(result)        # 必须打印出来，平台才能检测到
```

## 151翻转字符串里的单词

[151.翻转字符串里的单词](https://leetcode.cn/problems/reverse-words-in-a-string/description/)
给定一个字符串，逐个翻转字符串中的每个单词。

示例 1：  
输入: "the sky is blue"  
输出: "blue is sky the"

示例 2：  
输入: "  hello world!  "  
输出: "world! hello"  
解释: 输入字符串可以在前面或者后面包含多余的空格，但是反转后的字符不能包括。

示例 3：  
输入: "a good     example"  
输出: "example good a"  
解释: 如果两个单词间有多余的空格，将反转后单词间的空格减少到只含一个。
### 思路
想一下，我们将整个字符串都反转过来，那么单词的顺序指定是倒序了，只不过单词本身也倒序了，那么再把单词反转一下，单词不就正过来了。

所以解题思路如下：
- 移除多余空格(包括字符串前面的、中间的、后面的)
- 将整个字符串反转
- 将每个单词反转
### 题解

```c
// 翻转字符串中指定范围的字符
void reverse(char* s, int start, int end){
    while(start<end){
        char temp = s[start];
        s[start] = s[end];
        s[end] = temp;
        start++;
        end--;
    }
}
  
//删除空格,快慢指针法
void deleteExtraSpace(char *s) {
    int slow = 0, fast = 0, len = strlen(s);
    int firstWord = 1;  // 标记是否是第一个单词
    while(fast < len){
        if(s[fast] != ' '){
            // 非空格：如果是第一个单词，直接复制
            // 如果不是第一个单词，先加个空格再复制
            if (!firstWord) {
                s[slow++] = ' ';
            }
            firstWord = 0;
            // 复制整个单词
            while (fast < len && s[fast] != ' ') {
                s[slow++] = s[fast++];
            }
        } else {
            fast++;  // 跳过空格
        }
    }
    s[slow] = '\0';
}

char* reverseWords(char* s) {
    deleteExtraSpace(s);
  
    //翻转整个字符串
    reverse(s,0,strlen(s)-1);
  
    //针对单词进行再翻转
    int slow = 0; // 指向每个单词的开头位置的指针
    for (int i = 0; i <= strlen(s); i++) { // 遍历整个字符串
        if (s[i] ==' ' || s[i] == '\0') { // 如果当前字符是空格或空字符，说明一个单词结束了
            reverse(s, slow, i-1); // 翻转单词
            slow = i + 1; // 将 slow 指针指向下一个单词的开头位置
        }
    }
    return s; // 返回处理后的字符串
}
```

## 206反转链表

https://leetcode.cn/problems/reverse-linked-list/description/

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

[160. 链表相交](https://leetcode.cn/problems/intersection-of-two-linked-lists/)

给你两个单链表的头节点 `headA` 和 `headB`，请你找出并返回两个单链表**相交的起始节点**。如果两个链表不存在相交节点，返回 null。

例如，下面的两个链表在节点 c1 开始相交：
![](https://assets.leetcode.cn/aliyun-lc-upload/uploads/2018/12/14/160_statement.png)
在评测系统中，**相交的定义是基于节点地址而非节点值**。如果两个链表在某个节点相交，则该节点在两个链表中必须是同一个节点（即**内存地址相同**）。
**示例 1：**
- 输入：intersectVal = 8, listA = [4,1,8,4,5], listB = [5,6,1,8,4,5], skipA = 2, skipB = 3
- 输出：Intersected at '8'
**示例 2：**
- 输入：intersectVal = 2, listA = [1,9,1,2,4], listB = [3,2,4], skipA = 3, skipB = 1
- 输出：Intersected at '2'
**示例 3：**
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
C:
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

## 15三数之和

https://leetcode.cn/problems/3sum/description/

给你一个整数数组 `nums` ，判断是否存在三元组 `[nums[i], nums[j], nums[k]]` 满足 `i != j`、`i != k` 且 `j != k` ，同时还满足 `nums[i] + nums[j] + nums[k] == 0` 。请你返回所有和为 `0` 且不重复的三元组。

注意：答案中不可以包含重复的三元组。
示例 1：
输入：nums = [-1,0,1,2,-1,-4]
输出：[ [-1,-1,2],[-1,0,1] ]

解释：

nums[0] + nums[1] + nums[2] = (-1) + 0 + 1 = 0 。

nums[1] + nums[2] + nums[4] = 0 + 1 + (-1) = 0 。

nums[0] + nums[3] + nums[4] = (-1) + 2 + (-1) = 0 。

不同的三元组是 [-1,0,1] 和 [-1,-1,2] 。

注意，输出的顺序和三元组的顺序并不重要。

示例 2：

输入：nums = [0,1,1]

输出：[]

解释：唯一可能的三元组和不为 0 。

示例 3：

输入：nums = [0,0,0]

输出：[ [0,0,0] ]

解释：唯一可能的三元组和为 0 。

备注：3 <= nums.length <= 3000
### 思路
这题推荐用双指针法。

双指针（理论上有三个指针）思路如下：
![](https://file1.kamacoder.com/i/algo/15.%E4%B8%89%E6%95%B0%E4%B9%8B%E5%92%8C.gif)
首先将数组排序，然后有一层for循环，i从下标0的地方开始，同时定一个下标left 定义在i+1的位置上，定义下标right 在数组结尾的位置上。

依然还是在数组中找到 abc 使得a + b +c =0，我们这里相当于 a = nums[i]，b = nums[left]，c = nums[right]。

接下来如何移动left 和right呢， 如果nums[i] + nums[left] + nums[right] > 0 就说明 此时三数之和大了，因为数组是排序后了，所以right下标就应该向左移动，这样才能让三数之和小一些。

如果 nums[i] + nums[left] + nums[right] < 0 说明 此时 三数之和小了，left 就向右移动，才能让三数之和大一些，直到left与right相遇为止。

上面讲完了探索的策略，现在讨论一下要如何返回结果：
可以看到题目中有一个输出：[ [-1,-1,2],[-1,0,1] ]，也有一个[ [0,0,0] ]，显然结果是需要malloc的，并且是一个动态的二维数组，大小是n(行) × 3（列），每个小数组的大小都是3，因为是三元组嘛。
### 题解
```c
/**
 * Return an array of arrays of size *returnSize.
 * The sizes of the arrays are returned as *returnColumnSizes array.
 * Note: Both returned array and *columnSizes array must be malloced, assume caller calls free().
 */
 //qsort辅助cmp函数
int cmp(const void* ptr1, const void* ptr2) {
    return *((int*)ptr1) > *((int*)ptr2);
}

int** threeSum(int* nums, int numsSize, int* returnSize, int** returnColumnSizes) {
    //开辟ans数组空间
    int **ans = (int**)malloc(sizeof(int*) * 18000);
    int ansTop = 0;
    //若传入nums数组大小小于3，则需要返回数组大小为0
    if(numsSize < 3) {
        *returnSize = 0;
        return 0;
    }
    //对nums数组进行排序
    qsort(nums, numsSize, sizeof(int), cmp);
    
    int i;
    //用for循环遍历数组，结束条件为i < numsSize - 2(要预留左右指针的位置)
    for(i = 0; i < numsSize - 2; i++) {
        //若当前i指向元素>0，则代表left和right以及i的和大于0。直接break
        if(nums[i] > 0)
            break;
        //去重：i > 0 && nums[i] == nums[i-1]，如果当前数和前一个数一样，就跳过
        if(i > 0 && nums[i] == nums[i-1])
            continue;
        //定义左指针和右指针
        int left = i + 1;
        int right = numsSize - 1;
        //当右指针比左指针大时进行循环
        while(right > left) {
            //求出三数之和
            int sum = nums[right] + nums[left] + nums[i];
            //若和小于0，则左指针+1（因为左指针右边的数比当前所指元素大）
            if(sum < 0)
                left++;
            //若和大于0，则将右指针-1
            else if(sum > 0)
                right--;
            //若和等于0
            else {
                //开辟一个大小为3的数组空间，存入nums[i], nums[left]和nums[right]
                int* arr = (int*)malloc(sizeof(int) * 3);
                arr[0] = nums[i];
                arr[1] = nums[left];
                arr[2] = nums[right];
                //将开辟数组存入ans中
                ans[ansTop++] = arr;
                //去重
                while(right > left && nums[right] == nums[right - 1])
                    right--;
                while(left < right && nums[left] == nums[left + 1])
                    left++;
                //更新左右指针
                left++;
                right--;
            }
        }
    }
  
    //设定返回的数组大小
    *returnSize = ansTop;//解引用一次，可以赋值int类型的数字给它
    *returnColumnSizes = (int*)malloc(sizeof(int) * ansTop);//解引用一次，可以赋值int*类型的指针
    for(int z = 0; z < ansTop; z++) {
        (*returnColumnSizes)[z] = 3;
    }
    return ans;
}
```

Python解法如下：
```python
class Solution:
    def threeSum(self, nums: list[int]) -> list[list[int]]:
        nums.sort()
        res = []
        for i in range(len(nums)):
            if nums[i] > 0:
                break
            if i > 0 and nums[i] == nums[i-1]:
                continue
            left, right = i + 1, len(nums) - 1
            while left < right:
                s = nums[i] + nums[left] + nums[right]
                if s < 0:
                    left += 1
                elif s > 0:
                    right -= 1
                else:
                    res.append([nums[i], nums[left], nums[right]])
                    left += 1
                    right -= 1
                    while left < right and nums[left] == nums[left - 1]:
                        left += 1
                    while left < right and nums[right] == nums[right + 1]:
                        right -= 1
        return res
```

## 18四数之和

https://leetcode.cn/problems/4sum/description/

给你一个由 `n` 个整数组成的数组 `nums` ，和一个目标值 `target` 。请你找出并返回满足下述全部条件且**不重复**的四元组 `[nums[a], nums[b], nums[c], nums[d]]` （若两个四元组元素一一对应，则认为两个四元组重复）：
- `0 <= a, b, c, d < n`
- `a`、`b`、`c` 和 `d` **互不相同**
- `nums[a] + nums[b] + nums[c] + nums[d] == target`
你可以按 **任意顺序** 返回答案 。

示例 1：

输入：nums = [1,0,-1,0,-2,2], target = 0

输出：[-2,-1,1,2],[-2,0,0,2],[-1,0,0,1]

示例 2：

输入：nums = [2,2,2,2,2], target = 8

输出：[ [2,2,2,2] ]
### 思路
和[15.三数之和](https://programmercarl.com/0015.%E4%B8%89%E6%95%B0%E4%B9%8B%E5%92%8C.html)是一个思路，都是使用双指针法, 基本解法就是在[15.三数之和](https://programmercarl.com/0015.%E4%B8%89%E6%95%B0%E4%B9%8B%E5%92%8C.html)的基础上再套一层for循环。

不同点：三数之和 可以通过 `nums[i] > 0` 就返回了，因为 0 已经是确定的数了，四数之和这道题目 target是任意值。比如：数组是`[-4, -3, -2, -1]`，`target`是`-10`，不能因为`-4 > -10`而跳过。但是我们依旧可以去做剪枝，逻辑变成`nums[k] > target && (nums[k] >=0 || target >= 0)`就可以了。

四数之和的双指针解法是两层for循环nums[k] + nums[i]为确定值，依然是循环内有left和right下标作为双指针，找出nums[k] + nums[i] + nums[left] + nums[right] == target的情况，三数之和的时间复杂度是O(n^2)，四数之和的时间复杂度是O(n^3) 。
### 题解
```c
/* qsort */
static int cmp(const void* arg1, const void* arg2) {
    int a = *(int *)arg1;
    int b = *(int *)arg2;
    return (a > b);
}

int** fourSum(int* nums, int numsSize, int target, int* returnSize, int** returnColumnSizes) {

    /* 对nums数组进行排序 */
    qsort(nums, numsSize, sizeof(int), cmp);

    int **res = (int **)malloc(sizeof(int *) * 40000);
    int index = 0;

    /* k */
    for (int k = 0; k < numsSize - 3; k++) { /* 第一级 */

        /* k剪枝 */
        if ((nums[k] > target) && (nums[k] >= 0)) {
            break;
        }
        /* k去重 */
        if ((k > 0) && (nums[k] == nums[k - 1])) {
            continue;
        }

        /* i */
        for (int i = k + 1; i < numsSize - 2; i++) { /* 第二级 */

            /* i剪枝 */
            if ((nums[k] + nums[i] > target) && (nums[i] >= 0)) {
                break;
            }
            /* i去重 */
            if ((i > (k + 1)) && (nums[i] == nums[i - 1])) {
                continue;
            }

            /* left and right */
            int left = i + 1;
            int right = numsSize - 1;

            while (left < right) {

                /* 防止大数溢出 */
                long long val = (long long)nums[k] + nums[i] + nums[left] + nums[right];
                if (val > target) {
                    right--;
                } else if (val < target) {
                    left++;
                } else {
                    int *res_tmp = (int *)malloc(sizeof(int) * 4);
                    res_tmp[0] = nums[k];
                    res_tmp[1] = nums[i];
                    res_tmp[2] = nums[left];
                    res_tmp[3] = nums[right];
                    res[index++] = res_tmp;
                    
                    /* right去重 */
                    while ((right > left) && (nums[right] == nums[right - 1])) {
                        right--;
                    }
                    /* left去重 */
                    while ((left < right) && (nums[left] == nums[left + 1])) {
                        left++;
                    }

                    /* 更新right与left */
                    left++, right--;
                }
            }
        }
    }

    /* 返回值处理 */
    *returnSize = index;

    int *column = (int *)malloc(sizeof(int) * index);
    for (int i = 0; i < index; i++) {
        column[i] = 4;
    }
    *returnColumnSizes = column;
    return res;
}
```
