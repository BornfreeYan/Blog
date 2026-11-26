---
title: Leetcode字符串合集
date: 2026-11-26
tags:
  - Leetcode
categories:
  - CS
draft: false
---

| 题型分类 | 题目 |
| --- | --- |
| 双指针 | [344 反转字符串](#344反转字符串) |
| 双指针 | [541 反转字符串2](#541反转字符串2) |
| 双指针 | [替换数字](#替换数字) |
| 双指针 | [151 翻转字符串里的单词](#151翻转字符串里的单词) |
| 模拟 | [右旋转字符串](#右旋转字符串) |
| KMP | [28 实现strstr](#28实现strstr) |

> 难点还是KMP吧，之后再看看并删除本行。
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
C:
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

Python:
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

## 541反转字符串2

[541.反转字符串II](https://leetcode.cn/problems/reverse-string-ii/description/)

给定一个字符串 `s` 和一个整数 `k`，每计数至 `2k` 个字符，就反转这 `2k` 字符中的前 `k` 个字符。
- 若剩余字符少于 `k` 个，则反转剩余全部字符
- 若剩余字符在 `k` 到 `2k` 之间，则反转前 `k` 个字符

**示例：**
```
输入：s = "abcdefg", k = 2
输出："bacdfeg"

输入：s = "abcd", k = 2
输出："bacd"
```
### 思路
这道题目其实就是模拟，实现题目中规定的反转规则就可以了：
- 核心思路：每 `2k` 个字符为一组，**分批反转前 k 个字符**
- 使用**双指针**在每组内进行反转
- 循环变量 `i` 每次递增 `2k`
- 注意处理边界：剩余字符可能不足 `k` 个
### 题解
C：
```c
char* reverseStr(char* s, int k) {
    int len = strlen(s);//获取字符串长度
  
    for(int i = 0;i<len;i += (2*k)){
        if(i+k>len){
            k = len - i;
        }
        if(i+k<len){
            k = k;
        }
        int left = i;
        int right = i+k-1;
        while(left<right){
            char temp = s[right];
            s[right] = s[left];
            s[left] = temp;
            right--;
            left++;
        }
    }
    return s;
}
```

Python：
```python
class Solution:
    def reverseStr(self, s: str, k: int) -> str:
        # 转换为列表好原地操作
        chars = list(s)
        n = len(chars)
        for i  in range(0,n,2*k):
            chars[i:i+k] = reversed(chars[i:i+k]) # 调用一个reversed函数
        return ''.join(chars) # 用join拼接列表为字符串，引号里面为空的话，就是直接拼接。你也可以在引号里面加上任何符号
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
- 以上是C语言思路，Python因为可以append，**不需要**从后往前填充
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

Python:由于 Python 的字符串不可变，所以要先转换为数组，然后再用 join 转换为字符串输出。
```python
def replace_digits(s: str) -> str:
    res = []
    for ch in s:
        if '0'<= ch <= '9':
            res.append('number')
        else:
            res.append(ch)
    return ''.join(res)
  
# ============= ACM模式的输入输出 =============
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

```python
class Solution:
    def reverse(self, chars: list, i: int, j: int) -> None:
        while i < j:
            chars[i], chars[j] = chars[j], chars[i]   # 元组交换，无需 temp
            i += 1
            j -= 1

    def clean(self, chars: list) -> int:
        """原地删除多余空格，返回有效长度"""
        slow = fast = 0
        n = len(chars)
        while fast < n:
            if chars[fast] == ' ':
                fast += 1
                continue
            if slow > 0:              # 不是第一个单词，先补一个分隔空格
                chars[slow] = ' '
                slow += 1
            while fast < n and chars[fast] != ' ':   # 拷贝整个单词
                chars[slow] = chars[fast]
                slow += 1
                fast += 1
        return slow                   # slow 即有效长度

    def reverseWords(self, s: str) -> str:
        chars = list(s)
        n = self.clean(chars)              # 原地清洗
        self.reverse(chars, 0, n - 1)      # 整体反转
        start = 0
        for i in range(n + 1):             # 故意多走一格
            if i == n or chars[i] == ' ':  # 空格或"虚拟结尾"都意味着单词结束
                self.reverse(chars, start, i - 1)
                start = i + 1
        return ''.join(chars[:n])
```

## 右旋转字符串

[右旋转字符串](https://kamacoder.com/problempage.php?pid=1065)

字符串的右旋转操作是把字符串尾部的若干个字符转移到字符串的前面。给定一个字符串 s 和一个正整数 k，请编写一个函数，将字符串中的后面 k 个字符移到字符串的前面，实现字符串的右旋转操作。

例如，对于输入字符串 "abcdefg" 和整数 2，函数应该将其转换为 "fgabcde"。

输入：输入共包含两行，第一行为一个正整数 k，代表右旋转的位数。第二行为字符串 s，代表需要旋转的字符串。

输出：输出共一行，为进行了右旋转操作后的字符串。

样例输入：
```
2
abcdefg 
```
样例输出：
```
fgabcde
```
### 思路
其实还是和上题一样的思路，整个字符串倒序，然后分块倒序：
![](https://file1.kamacoder.com/i/algo/20231106172058.png)

### 题解
```c
#include <stdio.h>
#include <string.h>
  
void reverse(char *s, int left, int right){
    while(left <= right)
    {
        char c = s[left];
        s[left] = s[right];
        s[right] = c;
        left++;
        right--;
    }
}
  
void rightRotate(char *s, int k){
    int len = strlen(s);
    reverse(s, 0, len - 1);       // 整体反转
    reverse(s, 0, k - 1);   // 反转前k位
    reverse(s, k, len - 1); // 反转后部分
}
int main(){
    int k;
    scanf("%d",&k);
  
    char s[10000];
    scanf("%s", s);
  
    rightRotate(s, k);
    printf("%s\n", s);
  
    return 0;
}
```

## 28实现strstr

[实现 strStr()](https://leetcode.cn/problems/find-the-index-of-the-first-occurrence-in-a-string/)

给你两个字符串 `haystack` 和 `needle`，返回 `needle` 在 `haystack` 中**首次出现的位置**，若不存在则返回 `-1`

**说明：**
- 当 `needle` 是空字符串时，返回 `0`
- 题目要求不使用语言内置的 `find` / `indexOf` 等函数

**示例：**
```
输入：haystack = "sadbutsad", needle = "sad"
输出：0
解释："sad" 在 "sadbutsad" 中首次出现的位置是 0

输入：haystack = "leetcode", needle = "leeto"
输出：-1
```
### 思路
- 暴力解法：双层循环，时间复杂度 O(m×n)
- **KMP算法**：时间复杂度 O(m+n)，重点掌握
- KMP 核心思想：**当匹配失败时，利用已匹配信息，不回退主串指针**，关键点是不回退！！！
### 暴力解法(Brute-Force)
```c
int strStr(char* haystack, char* needle) {//暴力解法
    int hlen = strlen(haystack);
    int nlen = strlen(needle);
  
    if (nlen == 0) return 0;  // 空串匹配
    for(int i = 0; i <= hlen - nlen; i++){
        int j = 0;
        while(j<nlen&&haystack[i + j] == needle[j]){
            j++;
        }
        if(j==nlen){
            return i;
        }
    }
    return -1;
}
```
---
>  暴力解法每一次都要回溯一下，有不必要的消耗，因此引入KMP算法：
### KMP算法详解
KMP主要应用在字符串匹配上。

KMP的主要思想是**当出现字符串不匹配时，可以知道一部分之前已经匹配的文本内容，可以利用这些信息避免从头再去做匹配了。**

所以如何记录已经匹配的文本内容，是KMP的重点，也是next数组肩负的重任。
#### 前缀表（next数组）
KMP 的关键是计算 **前缀表**，也叫 `next` 数组。
以主串`aabaabaaf`,子串`aabaaf`为例
**前缀**：包含首字符但不包含尾字符的连续子串，例如a/aa/aab/aaba/aabaa
**后缀**：包含尾字符但不包含首字符的连续子串，例如f/af/aaf/baaf/abaaf
**前缀表含义**：当匹配失败时，子串可以跳过匹配的字符个数，本质是寻找子串中**相同前后缀的最长的长度**
![](https://file1.kamacoder.com/i/algo/KMP%E7%B2%BE%E8%AE%B21.gif)
可以看出，文本串中第六个字符**b** 和 模式串的第六个字符**f**，不匹配了。如果暴力匹配，发现不匹配，此时就要从头匹配了。

但如果使用前缀表，就不会从头匹配，而是从上次已经匹配的内容开始匹配，找到了模式串中第三个字符b继续开始匹配。

此时就要问了**前缀表是如何记录的呢？**

首先要知道前缀表的任务是当前位置匹配失败，找到之前已经匹配上的位置，再重新匹配，此也意味着在某个字符失配时，前缀表会告诉你下一步匹配中，模式串应该跳到哪个位置。

那么什么是前缀表：**记录下标i之前（包括i）的字符串中，有多大长度的相同前缀后缀**
#### 最长相同前后缀/前缀表的计算
对于上面的例子，有以下的最长相同前后缀表格：

| 下标i之前（包括i）的串 | 下标i | 最大相同前后缀长度                          | 备注                   |
| ------------ | --- | ---------------------------------- | -------------------- |
| a            | 0   | 0                                  | 单字母没有                |
| aa           | 1   | 1                                  | 前缀a，后缀a              |
| aab          | 2   | 0                                  | 前缀为a/aa，后缀为b/ab，没有相同 |
| aaba         | 3   | 1                                  | 前缀为a，后缀为a            |
| aabaa        | 4   | <font color="#ff0000">2（最长）</font> | aa和aa                |
| aabaaf       | 5   | 0                                  | 不存在                  |
#### 为什么要用前缀表？
刚刚匹配的过程在下标5的地方遇到不匹配，模式串是指向f，如图：
![](https://file1.kamacoder.com/i/algo/KMP%E7%B2%BE%E8%AE%B21.png)
然后就找到了下标2，也就是b：
![](https://file1.kamacoder.com/i/algo/KMP%E7%B2%BE%E8%AE%B22.png)
**下标5之前这部分的字符串（也就是字符串aabaa）的最长相等的前缀 和 后缀字符串是 子字符串aa ，因为找到了最长相等的前缀和后缀，匹配失败的位置是后缀子串的后面，那么我们找到与其相同的前缀的后面重新匹配就可以了。**
#### KMP 匹配过程
![](https://file1.kamacoder.com/i/algo/KMP%E7%B2%BE%E8%AE%B22.gif)

找到的不匹配的位置， 那么此时我们要看它的前一个字符的前缀表的数值是多少。

为什么要前一个字符的前缀表的数值呢，因为要找前面字符串的最长相同的前缀和后缀。

所以要看前一位的 前缀表的数值。

前一个字符的前缀表的数值是2， 所以把下标移动到下标2的位置继续比配。
#### 前缀表与next数组关系
next数组就可以是前缀表本身，但是很多实现都是把前缀表统一减一（右移一位，初始位置为-1）、或者全体减1 之后作为next数组。这和KMP算法本身没啥关系，就是具体实现的方式不同。

为了初学的方便理解就不再对前缀表过多操作，就用其本身作为next数组。
### KMP题解（以前缀表本身为next数组）
#### 前缀表（next数组）计算逻辑详解
**核心思想**：用已经计算好的next信息来加速计算当前位的next值
**以`needle = "aabaaf"`为例，手动计算前缀表：**

| 下标i | 0 | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|---|
| 字符 | a | a | b | a | a | f |
| next[i] | 0 | ? | ? | ? | ? | ? |
**手动计算过程：**
- `i=0`：单个字符，无前后缀，next[0]=0
- `i=1`（字符'a'）：前缀"a"，后缀"a"，相同长度1 → next[1]=1
- `i=2`（字符'b'）：前缀"a"/"aa"，后缀"b"/"ab"，无相同 → next[2]=0
- `i=3`（字符'a'）：前缀"a"，后缀"a"，相同长度1 → next[3]=1
- `i=4`（字符'a'）：前缀"a"/"aa"/"aab"，后缀"a"/"aa"/"baa"，最长相同是"aa" → next[4]=2
- `i=5`（字符'f'）：前缀"a"/"aa"/...，后缀"f"/"af"/...，无相同 → next[5]=0

**代码如何实现这个逻辑：**
```
j的双重含义：
1. 已匹配前后缀的长度
2. 指向前缀的下一个位置

当s[i] == s[j]时：长度+1，j++
当s[i] != s[j]时：j回退到next[j-1]（利用已知的匹配信息）
```

```c
int *getNext(char *s,int len){
    int *next = (int*)malloc(sizeof(int)*len);
  
    next[0] = 0;
    int j= 0;//j指向前缀末尾位置
    for(int i = 1;i<len;i++){//i指向后缀末尾位置
        while (j > 0 && s[i] != s[j]) {//前后缀不相同
            j = next[j - 1];
        }
        if (s[i] == s[j]) {//前后缀相同
            j++;
        }
        next[i] = j;
    }
    return next;
}
  
int strStr(char* haystack, char* needle) {//KMP
    int hlen = strlen(haystack);
    int nlen = strlen(needle);
    if (nlen == 0) return 0;    // 空串匹配，返回0
    int *next = getNext(needle,nlen);
  
    int j = 0;
    for(int i = 0;i<hlen;i++){
        while (j > 0 && haystack[i] != needle[j]) {
            j = next[j - 1];//回退
        }
        if (haystack[i] == needle[j]) {
            j++;
        }
        if(j == nlen){
            free(next);
            return i - nlen + 1;
        }
    }
    return -1;
}
```
**代码逻辑要点：**

| 要点 | 说明 |
| --- | --- |
| next数组含义 | `next[i]` = 以下标i结尾的子串的**最长相同前后缀长度** |
| j的双重角色 | 构建next时指向前缀末尾；匹配时指向已匹配位置 |
| 回退条件 | `while (j > 0 && s[i] != s[j]) j = next[j - 1]` |
| 易错点 | 回退到`next[j-1]`而非`next[j]` |
### KMP vs 暴力

| 对比项   | 暴力法    | KMP     |
| ----- | ------ | ------- |
| 时间复杂度 | O(m×n) | O(m+n)  |
| 空间复杂度 | O(1)   | O(n)    |
| 主串指针  | 会回退    | 不回退     |
| 核心思想  | 无      | 利用已匹配信息 |
