---
title: Leetcode数组合集
date: 2026-11-22
tags:
  - Leetcode
categories:
  - CS
draft: false
---

| 分类 | 题目 |
| --- | --- |
| 数组理论 | [数组理论基础](#数组理论基础) |
| 二分查找 | [704 二分查找](#704二分查找) |
| 双指针 | [27 移除元素](#27移除元素) |
| 双指针/数学  | [189 轮转数组](#189轮转数组)  |
| 数学 | [48 旋转图像](#48旋转图像) |
| 双指针 | [977 有序数组的平方](#977有序数组的平方) |
| 滑动窗口 | [209 长度最小的子数组](#209长度最小的子数组) |
| 模拟 | [54 螺旋矩阵](#54螺旋矩阵) |
| 模拟 | [59 螺旋矩阵2](#59螺旋矩阵2) |
| 前缀和 | [58 区间和](#58区间和) |
| 前缀和 | [44 开发商购买土地](#44开发商购买土地) |
| 前缀积 | [238 除了自身以外数组的乘积](#238除了自身以外数组的乘积) |

## 数组理论基础
### 核心要点
数组是存放**在连续内存空间上的相同类型数据的集合**。数组可以方便地通过下标索引的方式获取下标对应的数据。
### 重要注意事项
1. **数组下标都是从0开始的**
2. **数组内存空间的地址是连续的**
3. 因为数组在内存空间地址连续，所以在删除或增添元素时，**需要移动**其他元素的地址
4. **数组的元素是不能删的，只能覆盖**
![](https://file1.kamacoder.com/i/algo/%E7%AE%97%E6%B3%95%E9%80%9A%E5%85%B3%E6%95%B0%E7%BB%841.png)
### 二维数组内存分布
在C语言中，二维数组是连续分布的。示例代码：
```C
#include <stdio.h>

void test_arr() {
    int array[2][3] = {
        {0, 1, 2},
        {3, 4, 5}
    };
    printf("%p %p %p\n", &array[0][0], &array[0][1], &array[0][2]);
    printf("%p %p %p\n", &array[1][0], &array[1][1], &array[1][2]);
}

int main() {
    test_arr();
    return 0;
}
```
测试地址结果：
```
0x7ffee4065820 0x7ffee4065824 0x7ffee4065828
0x7ffee406582c 0x7ffee4065830 0x7ffee4065834
```
相邻数组元素地址相差4个字节（int型）。
**结论：在C语言中二维数组在地址空间上是连续的。**

## 704二分查找
[704. 二分查找 - 力扣（LeetCode）](https://leetcode.cn/problems/binary-search/description/)

给定一个 `n` 个元素有序的（升序）整型数组 `nums` 和一个目标值 `target`  ，写一个函数搜索 `nums` 中的 `target`，如果 `target` 存在返回**下标**，否则返回 `-1`。

你必须编写一个具有 `O(log n)` 时间复杂度的算法。

示例 1:

输入: `nums` = [-1,0,3,5,9,12], `target` = 9

输出: 4

解释: 9 出现在 `nums` 中并且下标为 4

示例 2:

输入: `nums` = [-1,0,3,5,9,12], `target` = 2

输出: -1

解释: 2 不存在 `nums` 中因此返回 -1

### 思路
这道题目的前提是数组为**有序**数组，同时题目还强调**数组中无重复元素**，因为一旦有重复元素，使用二分查找法返回的元素下标可能不是唯一的，这些都是使用二分法的前提条件，当看到题目描述满足如上条件的时候，可要想一想是不是可以用二分法了。二分，就是按照＞=＜三种情况对于一个有序的数组进行分割，相比一个for循环（O(n)复杂度）更加快速，况且题目要求O(log n)。

写二分法经常写乱，主要是因为**对区间的定义没有想清楚，区间的定义就是不变量**。要在二分查找的过程中，保持不变量，就是在while寻找中每一次边界的处理都要坚持根据区间的定义来操作，这就是**循环不变量**规则。

写二分法，区间的定义一般为两种，左闭右闭即[left, right]，或者左闭右开即[left, right)。

建议固定一种写法。
### 左闭右闭写法
```python
class Solution:
    def search(self, nums: List[int], target: int) -> int:
        left, right = 0, len(nums) - 1  # 定义target在左闭右闭的区间里，[left, right]

        while left <= right:
            middle = left + (right - left) // 2
            
            if nums[middle] > target:
                right = middle - 1  # target在左区间，所以[left, middle - 1]
            elif nums[middle] < target:
                left = middle + 1  # target在右区间，所以[middle + 1, right]
            else:
                return middle  # 数组中找到目标值，直接返回下标
        return -1  # 未找到目标值
```

### 左闭右开写法
```python
class Solution:
    def search(self, nums: List[int], target: int) -> int:
        left, right = 0, len(nums) - 1  # 定义target在左闭右闭的区间里，[left, right]

        while left <= right:
            middle = left + (right - left) // 2
            
            if nums[middle] > target:
                right = middle - 1  # target在左区间，所以[left, middle - 1]
            elif nums[middle] < target:
                left = middle + 1  # target在右区间，所以[middle + 1, right]
            else:
                return middle  # 数组中找到目标值，直接返回下标
        return -1  # 未找到目标值
```

## 27移除元素
[27. 移除元素 - 力扣（LeetCode）](https://leetcode.cn/problems/remove-element/description/)

给你一个数组 nums 和一个值 val，你需要 **原地** 移除所有数值等于 val 的元素，并返回移除后数组的新长度。

不要使用额外的数组空间，你必须仅使用 O(1) 额外空间并**原地**修改输入数组。

元素的顺序可以改变。你不需要考虑数组中超出新长度后面的元素。

示例 1: 给定 nums = [3,2,2,3], val = 3, 函数应该返回新的长度 2, 并且 nums 中的前两个元素均为 2。 你不需要考虑数组中超出新长度后面的元素。

示例 2: 给定 nums = [0,1,2,2,3,0,4,2], val = 2, 函数应该返回新的长度 5, 并且 nums 中的前五个元素为 0, 1, 3, 0, 4。

**你不需要考虑数组中超出新长度后面的元素**。

### 思路
**数组的元素在内存地址中是连续的，不能单独删除数组中的某个元素，只能覆盖。**
### 暴力解法
两层for循环，一个for循环遍历数组元素 ，第二个for循环更新数组。暴力解法的时间复杂度是O(n^2)

删除过程如下：
![](https://file1.kamacoder.com/i/algo/27.%E7%A7%BB%E9%99%A4%E5%85%83%E7%B4%A0-%E6%9A%B4%E5%8A%9B%E8%A7%A3%E6%B3%95.gif)
### 双指针解法
题目只要求返回新长度，并保证数组前 `k` 个元素是结果。**它并不关心数组后面是什么**。

这给了你什么"操作空间"？

双指针法（快慢指针法）： **通过一个快指针和慢指针在一个for循环下完成两个for循环的工作。**

定义快慢指针:
- 快指针：寻找新数组的元素 ，新数组就是不含有目标元素的数组
- 慢指针：指向更新 新数组下标的位置

![](https://file1.kamacoder.com/i/algo/27.%E7%A7%BB%E9%99%A4%E5%85%83%E7%B4%A0-%E5%8F%8C%E6%8C%87%E9%92%88%E6%B3%95.gif)

代码如下：
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

## 189轮转数组
[189. 轮转数组](https://leetcode.cn/problems/rotate-array/description/)

给定一个整数数组 nums，将数组中的元素向右轮转 k 个位置，其中 k 是非负数。

示例 1:

输入: nums = [1,2,3,4,5,6,7], k = 3

输出: [5,6,7,1,2,3,4]

解释:
向右轮转 1 步: [7,1,2,3,4,5,6]
向右轮转 2 步: [6,7,1,2,3,4,5]
向右轮转 3 步: [5,6,7,1,2,3,4]

示例 2:

输入：nums = [-1,-100,3,99], k = 2

输出：[3,99,-1,-100]

解释: 
向右轮转 1 步: [99,-1,-100,3]
向右轮转 2 步: [3,99,-1,-100]

你可以使用空间复杂度为 O(1) 的 原地 算法解决这个问题吗？
### 思路

题目建议用O(1)空间复杂度，那就不能新建数组了，那就是O(n)了。

可以考虑双指针：

想象一个"大动作拆成三次小动作"的技巧：
- 把整个数组完全颠倒——这一步本身就是用双指针做的（首尾对调，向中间靠拢）；
- 再只对前 k 个元素做一次颠倒；
- 再只对剩下的 n-k 个元素做一次颠倒。

### 代码
```python
class Solution:
    def subrotate(self,nums: list[int], left: int,right:int)-> list[int]:
        while left<=right:
            temp = nums[left]
            nums[left] = nums[right]
            nums[right] = temp
            left+=1
            right-=1
        return nums

    def rotate(self, nums: list[int], k: int) -> None:
        """
        Do not return anything, modify nums in-place instead.
        """
        left = 0
        right = len(nums)-1
        k %= len(nums)
        self.subrotate(nums,left,right)
        self.subrotate(nums,0,k-1)
        self.subrotate(nums,k,len(nums)-1)
```

## 48旋转图像
[48. 旋转图像](https://leetcode.cn/problems/rotate-image/description/)

给定一个 n × n 的二维矩阵 matrix 表示一个图像。请你将图像顺时针旋转 90 度。

你必须在 原地 旋转图像，这意味着你需要直接修改输入的二维矩阵。请不要 使用另一个矩阵来旋转图像。

示例 1：
![](https://assets.leetcode.com/uploads/2020/08/28/mat1.jpg)

输入：matrix = [[1,2,3],[4,5,6],[7,8,9]]

输出：[[7,4,1],[8,5,2],[9,6,3]]

示例 2：
![](https://assets.leetcode.com/uploads/2020/08/28/mat2.jpg)
输入：matrix = [[5,1,9,11],[2,4,8,10],[13,3,6,7],[15,14,12,16]]

输出：[[15,13,2,5],[14,3,4,1],[12,6,8,9],[16,7,10,11]]

### 思路

上一题你学会了"反转一段数组"。如果我把整个矩阵的每一行分别反转，或者把矩阵沿着主对角线翻转（第 i 行第 j 列和第 j 行第 i 列交换），矩阵会变成什么样？试试这两个操作，再组合一下？

观察后发现，先沿着主对角线反转，再逐行反转，就得到结果。

### 代码
```python
class Solution:
    def rotate(self, matrix: list[list[int]]) -> None:
        """
        Do not return anything, modify matrix in-place instead.
        """
        # 主对角线反转
        for i in range(0,len(matrix)):
            for j in range(i,len(matrix)):
                temp = matrix[i][j]
                matrix[i][j] = matrix[j][i]
                matrix[j][i]  = temp
        # 逐行反转
        for i in range(0,len(matrix)):
            left = 0
            right = len(matrix)-1
            while left<=right:
                temp = matrix[i][left]
                matrix[i][left] = matrix[i][right] 
                matrix[i][right] = temp
                left+=1
                right-=1
```
## 977有序数组的平方
[977. 有序数组的平方 - 力扣（LeetCode）](https://leetcode.cn/problems/squares-of-a-sorted-array/description/)

给你一个按 非递减顺序 排序的整数数组 `nums`，返回 每个数字的平方 组成的新数组，要求也按 非递减顺序 排序。

示例 1：

输入：nums = [-4,-1,0,3,10]

输出：[0,1,9,16,100]

解释：平方后，数组变为 [16,1,0,9,100]

排序后，数组变为 [0,1,9,16,100]


示例 2：

输入：nums = [-7,-3,2,3,11]

输出：[4,9,9,49,121]

### 思路
最简单的就是暴力，每个数平方之后排个序。

c语言似乎要写比较函数qsort，很浪费时间。

可以观察到，**原数组是有序的（非递减）**，但平方后负数可能变成很大的正数。直接平方再排序是 O(n log n)，而**双指针可以做到 O(n)**。双指针思路（从两端向中间）：
- 数组两端（最大负数或最大正数）的平方值一定是当前最大的
- 用两个指针从两端向中间移动，每次比较平方值，把大的放到结果数组末尾

i指向起始位置，j指向终止位置。

定义一个新数组result，和A数组一样的大小，让k指向result数组终止位置。

如果`A[i] * A[i] < A[j] * A[j]` 那么`result[k--] = A[j] * A[j];` 。

如果`A[i] * A[i] = A[j] * A[j]` 那么`result[k--] = A[i] * A[i];` 。

![](https://file1.kamacoder.com/i/algo/977.%E6%9C%89%E5%BA%8F%E6%95%B0%E7%BB%84%E7%9A%84%E5%B9%B3%E6%96%B9.gif)
### 双指针法
```python
class Solution:
    def sortedSquares(self, nums: List[int]) -> List[int]:
        result = []
        left = 0
        right = len(nums) - 1
        while left<=right:
            if nums[left]**2 > nums[right]**2:
                result.append(nums[left]**2)
                left += 1
            else:
                result.append(nums[right]**2)
                right -= 1
        result.reverse()
        return result # 或者也可以切片翻转return result[::-1]
```

此时的时间复杂度为O(n)，相对于暴力排序的解法O(n + nlog n)还是提升不少的。

## 209长度最小的子数组
[209. 长度最小的子数组 - 力扣（LeetCode）](https://leetcode.cn/problems/minimum-size-subarray-sum/description/)

给定一个含有 n 个正整数的数组和一个正整数 target 。

找出该数组中满足其总和大于等于 target 的长度最小的 子数组 [numsl, numsl+1, ..., numsr-1, numsr] ，并返回其长度 。如果不存在符合条件的子数组，返回 0 。

示例 1：

输入：target = 7, nums = [2,3,1,2,4,3]

输出：2

解释：子数组 [4,3] 是该条件下的长度最小的子数组。

示例 2：

输入：target = 4, nums = [1,4,4]

输出：1

示例 3：

输入：target = 11, nums = [1,1,1,1,1,1,1,1]

输出：0

### 思路
两个for暴力解题，但是可能超时。

可以使用滑动窗口：
滑动窗口，**就是不断的调节子序列的起始位置和终止位置，从而得出我们想要的结果**。

在暴力解法中，是一个for循环滑动窗口的起始位置，一个for循环为滑动窗口的终止位置，用两个for循环 完成了一个不断搜索区间的过程。

那么滑动窗口如何用一个for循环来完成这个操作呢。

首先要思考 如果用一个for循环，那么应该表示 滑动窗口的起始位置，还是终止位置。

如果只用一个for循环来表示 滑动窗口的起始位置，那么如何遍历剩下的终止位置？

此时难免再次陷入 暴力解法的怪圈。

所以 只用一个for循环，那么这个循环的索引，一定是表示 滑动窗口的终止位置。

那么问题来了， 滑动窗口的起始位置如何移动呢？

这里还是以题目中的示例来举例，s=7， 数组是 2，3，1，2，4，3，来看一下查找的过程：
![](https://file1.kamacoder.com/i/algo/209.%E9%95%BF%E5%BA%A6%E6%9C%80%E5%B0%8F%E7%9A%84%E5%AD%90%E6%95%B0%E7%BB%84.gif)

在本题中实现滑动窗口，主要确定如下三点：
- 窗口内是什么？
- 如何移动窗口的起始位置？
- 如何移动窗口的结束位置？

窗口就是 满足其和 ≥ s 的长度最小的 连续 子数组。

窗口的起始位置如何移动：如果当前窗口的值大于等于s了，窗口就要向前移动了（也就是该缩小了）。

窗口的结束位置如何移动：窗口的结束位置就是遍历数组的指针，也就是for循环里的索引。

**滑动窗口的精妙之处在于根据当前子序列和大小的情况，不断调节子序列的起始位置。从而将O(n^2)暴力解法降为O(n)。**

>总而言之就是，先确定右指针必须移动，先用右指针找出一个＞=target的子数组，记录下来，现在：
>1. 移动右指针，无意义；
>2. 移动左指针，看看能否收缩子数组，有意义；
>3. 收缩后仍然＞=target，记下长度，继续收缩；
>4. 收缩到 < target，移动右指针才有意义；
>5. 不用担心会漏掉什么可能，因为略去了一定没戏的可能性。只要每次保存最短数组长度，就ok。
>**左边界右移的时机 = 确定以当前左边界开头的所有子数组都已经"没戏"了**
>**双指针中的右指针一般用于探路或者扩张，左指针一般用于收缩或者确定具体保留值**

### 题解
```python
class Solution:
    def minSubArrayLen(self, target: int, nums: List[int]) -> int:
        right = 0
        left = 0
        sum = 0
        result = len(nums)+1
        for right in range(0,len(nums)):
            sum += nums[right]
            while sum>=target:# 必须用 while 而不能用 if，因为很可能继续缩小它还是大于 target
                result = min(right-left+1,result)
                sum -= nums[left]
                left += 1
        return result if result<=len(nums) else 0
```
## 54螺旋矩阵
[54. 螺旋矩阵](https://leetcode.cn/problems/spiral-matrix/description/)

给你一个 m 行 n 列的矩阵 matrix ，请按照 顺时针螺旋顺序 ，返回矩阵中的所有元素。

示例 1：
![](https://assets.leetcode.com/uploads/2020/11/13/spiral1.jpg)
输入：matrix = [[1,2,3],[4,5,6],[7,8,9]]

输出：[1,2,3,6,9,8,7,4,5]
示例 2：
![](https://assets.leetcode.com/uploads/2020/11/13/spiral.jpg)
输入：matrix = [[1,2,3,4],[5,6,7,8],[9,10,11,12]]

输出：[1,2,3,4,8,12,11,10,9,5,6,7]
### 思路
延边走，不断收缩边界即可。
### 代码
```python
class Solution:
    def spiralOrder(self, matrix: list[list[int]]) -> list[int]:
        result = []
        left, right = 0, len(matrix[0]) - 1   # 列边界
        top, bottom = 0, len(matrix) - 1      # 行边界

        while left <= right and top <= bottom:
            # 1. 从左到右，走顶行
            for i in range(left, right + 1):
                result.append(matrix[top][i])
            top += 1

            # 2. 从上到下，走右列
            for i in range(top, bottom + 1):
                result.append(matrix[i][right])
            right -= 1

            # 3. 从右到左，走底行 —— 只有确实还有剩余的行才走
            if top <= bottom:
                for i in range(right, left - 1, -1):
                    result.append(matrix[bottom][i])
                bottom -= 1

            # 4. 从下到上，走左列 —— 只有确实还有剩余的列才走
            if left <= right:
                for i in range(bottom, top - 1, -1):
                    result.append(matrix[i][left])
                left += 1

        return result
```

## 59螺旋矩阵2
[59. 螺旋矩阵 II ](https://leetcode.cn/problems/spiral-matrix-ii/description/)

给定一个正整数 n，生成一个包含 1 到 n^2 所有元素，且元素按顺时针顺序螺旋排列的正方形矩阵。

示例:

![](https://assets.leetcode.com/uploads/2020/11/13/spiraln.jpg)

输入: 3 输出: [ [ 1, 2, 3 ], [ 8, 9, 4 ], [ 7, 6, 5 ] ]

### 思路
求解本题依然是要坚持循环不变量原则。

模拟顺时针画矩阵的过程:
- 填充上行从左到右
- 填充右列从上到下
- 填充下行从右到左
- 填充左列从下到上

由外向内一圈一圈这么画下去。

这里一圈下来，我们要画每四条边，这四条边怎么画，每画一条边都要坚持一致的左闭右开，或者左开右闭的原则，这样这一圈才能按照统一的规则画下来。

那么我按照左闭右开的原则，来画一圈：

![](https://file1.kamacoder.com/i/algo/20220922102236.png)

这里每一种颜色，代表一条边，我们遍历的长度，可以看出每一个拐角处的处理规则，拐角处让给新的一条边来继续画。

这也是坚持了每条边左闭右开的原则。
### 题解
坚持左闭右开，不断收缩边界，若n为奇数中心赋值。

```python
class Solution(object):
    def generateMatrix(self, n):
        if n <= 0:
            return []
        
        # 初始化 n x n 矩阵
        matrix = [[0]*n for _ in range(n)]

        # 初始化边界和起始值
        top, bottom, left, right = 0, n-1, 0, n-1
        num = 1

        while top <= bottom and left <= right:
            # 从左到右填充上边界
            for i in range(left, right + 1):
                matrix[top][i] = num
                num += 1
            top += 1

            # 从上到下填充右边界
            for i in range(top, bottom + 1):
                matrix[i][right] = num
                num += 1
            right -= 1

            # 从右到左填充下边界

            for i in range(right, left - 1, -1):
                matrix[bottom][i] = num
                num += 1
            bottom -= 1

            # 从下到上填充左边界

            for i in range(bottom, top - 1, -1):
                matrix[i][left] = num
                num += 1
            left += 1

        return matrix
```

## 58区间和
[58. 区间和（第九期模拟笔试）](https://kamacoder.com/problempage.php?pid=1070)

本题是ACM模式的，不是leetcode模式。

题目描述

给定一个整数数组 Array，请计算该数组在每个指定区间内元素的总和。

输入描述：第一行输入为整数数组 Array 的长度 n，接下来 n 行，每行一个整数，表示数组的元素。随后的输入为需要计算总和的区间，直至文件结束。

输出描述：输出每个指定区间内元素的总和。

输入示例：
```text
5
1
2
3
4
5
0 1
1 3
```
输出示例：
```text
3
9
```
### 思路
暴力解法会超时：查询m次，每次查询的范围都是从0 到 n - 1，时间复杂度是 O(n * m)，查询次数非常大的话，这个时间复杂度也是非常大的。

而前缀和可以解决这个问题。

前缀和的思想是**重复利用计算过的子数组之和，从而降低区间查询需要累加计算的次数。**

例如，我们要统计 vec[i] 这个数组上的区间和。

我们先做累加，即 p[i] 表示 下标 0 到 i 的 vec[i] 累加 之和。

如图：
![](https://file1.kamacoder.com/i/algo/20240627110604.png)

如果，我们想统计，在vec数组上 下标 2 到下标 5 之间的累加和，那是不是就用 p[5] - p[1] 就可以了。

**特别注意**： 在使用前缀和求解的时候，要特别**注意求解区间**。

如上图，如果我们要求区间下标 [2, 5] 的区间和，那么应该是 p[5] - p[1]，而不是 p[5] - p[2]。
### 代码实现
```c
#include <stdio.h>
#include <stdlib.h>//使用malloc必须

int main(){
    int num;
    scanf("%d",&num);
  
    int *a = (int*)malloc((num+1)*sizeof(int));
    a[0] = 0;
  
    for(int i = 1;i<=num;i++){
        int mm;
        scanf("%d",&mm);
        a[i] = a[i-1] + mm;
    }
    int m,n;//区间
    while (scanf("%d%d", &m, &n) == 2){//成功读取了 2 个整数时
        printf("%d\n",a[n+1]-a[m]);
    }
    free(a);
    return 0;
}
```
要点：
1. 前缀和数组多开一个空间，下标0设为0
2. 边读入边构建前缀和

python需要import用于输入输出的库：
```python
import sys
input = sys.stdin.read

def main():
    data = input().split()
    index = 0
    n = int(data[index])
    index += 1
    vec = []
    for i in range(n):
        vec.append(int(data[index + i]))
    index += n

    p = [0] * n
    presum = 0
    for i in range(n):
        presum += vec[i]
        p[i] = presum

    results = []
    while index < len(data):
        a = int(data[index])
        b = int(data[index + 1])
        index += 2

        if a == 0:
            sum_value = p[b]
        else:
            sum_value = p[b] - p[a - 1]

        results.append(sum_value)

    for result in results:
        print(result)

if __name__ == "__main__":
    main()
```

## 44开发商购买土地
[44. 开发商购买土地（第五期模拟笔试）](https://kamacoder.com/problempage.php?pid=1044)

在一个城市区域内，被划分成了n * m个连续的区块，每个区块都拥有不同的权值，代表着其土地价值。目前，有两家开发公司，A 公司和 B 公司，希望购买这个城市区域的土地。

现在，需要将这个城市区域的所有区块分配给 A 公司和 B 公司。

然而，由于城市规划的限制，只允许将区域按横向或纵向划分成两个子区域，而且每个子区域都必须包含一个或多个区块。

为了确保公平竞争，你需要找到一种分配方式，使得 A 公司和 B 公司各自的子区域内的土地总价值之差最小。

注意：区块不可再分。

输入描述：
第一行输入两个正整数，代表 n 和 m。

接下来的 n 行，每行输出 m 个正整数。

输出描述：

请输出一个整数，代表两个子区域内土地总价值之间的最小差距。

输入示例：
```text
3 3
1 2 3
2 1 3
1 2 3
```
输出示例：
0

提示：
如果将区域按照如下方式划分：
```text
1 2 | 3
2 1 | 3
1 2 | 3
```
两个子区域内土地总价值之间的最小差距可以达到 0。
### 题解
```c
#include<stdio.h>
#include<stdlib.h>
#include <limits.h>//用于无穷大的表示

int main(){
    int n = 0,m = 0;
    scanf("%d%d",&n,&m);
    int *a = (int*)malloc(sizeof(int)*n);//行前缀和数组
    int *b = (int*)malloc(sizeof(int)*m);//列前缀和数组
  
    //初始化数组
    for(int i = 0;i<n;i++){
        a[i] = 0;
    }
    for(int i = 0;i<m;i++){
        b[i] = 0;
    }
  
    //读取区块权值并计算每行和每列的总权值，也就是单行/单列的总和
    for(int i = 0;i<n;i++){
        for(int j = 0;j<m;j++){
            int temp;
            scanf("%d",&temp);
            a[i] += temp;
            b[j] += temp;
        }
    }
  
    //计算a/b前缀和,原地修改，a/b从原来的单行/单列的总和变成了前缀和的数组
    for(int i = 1;i<n;i++){
        a[i] += a[i-1];
    }
    for(int i = 1;i<m;i++){
        b[i] += b[i-1];
    }
  
    //使用abs()计算绝对值|total-2*a[i]|或|total-2*b[i]|
    /*
    A得到 prefix[i]，B得到 total - prefix[i]
    差距 = |prefix[i] - (total - prefix[i])|
         = |2*prefix[i] - total|
         = |total - 2*prefix[i]|
    */
    int test = INT_MAX;//初始化为无穷大
    int total = a[n-1];
    for(int i = 0;i<(n-1);i++){
        if(test>abs(total-2*a[i])){
            test = abs(total-2*a[i]);
        }
    }
    for(int i = 0;i<(m-1);i++){
        if(test>abs(total-2*b[i])){
            test = abs(total-2*b[i]);
        }
    }
  
    free(a);
    free(b);
    printf("%d\n", test);
    return 0;
}
```

python版：
```python
def main():
    import sys
    input = sys.stdin.read
    data = input().split()

    idx = 0
    n = int(data[idx])
    idx += 1
    m = int(data[idx])
    idx += 1
    sum = 0
    vec = []
    for i in range(n):
        row = []
        for j in range(m):
            num = int(data[idx])
            idx += 1
            row.append(num)
            sum += num
        vec.append(row)

    # 统计横向
    horizontal = [0] * n
    for i in range(n):
        for j in range(m):
            horizontal[i] += vec[i][j]

    # 统计纵向
    vertical = [0] * m
    for j in range(m):
        for i in range(n):
            vertical[j] += vec[i][j]

    result = float('inf')
    horizontalCut = 0
    for i in range(n):
        horizontalCut += horizontal[i]
        result = min(result, abs(sum - 2 * horizontalCut))

    verticalCut = 0
    for j in range(m):
        verticalCut += vertical[j]
        result = min(result, abs(sum - 2 * verticalCut))

    print(result)

if __name__ == "__main__":
    main()
```

## 238除了自身以外数组的乘积
[238. 除了自身以外数组的乘积](https://leetcode.cn/problems/product-of-array-except-self/description/)

给你一个整数数组 nums，返回 数组 answer ，其中 answer[i] 等于 nums 中除了 nums[i] 之外其余各元素的乘积 。

题目数据 保证 数组 nums之中任意元素的全部前缀元素和后缀的乘积都在  32 位 整数范围内。

请 不要使用除法，且在 O(n) 时间复杂度内完成此题。

示例 1:

输入: nums = [1,2,3,4]

输出: [24,12,8,6]

示例 2:

输入: nums = [-1,1,0,-3,3]

输出: [0,0,9,0,0]
### 思路
这题leetcode也给的“前缀和”标签，其实这就是一个思想，我们后续的元素的计算需要复用之前计算结果的意思思想，无论是乘积还是加和。
- 前缀和： pre[i] = nums[0] + ... + nums[i-1]
- 前缀积： pre[i] = nums[0] × ... × nums[i-1]

所以这题可以用这个方法：
- left[i] = i 左边所有元素的乘积（前缀积）
- right[i] = i 右边所有元素的乘积（后缀积）

然后 answer[i] = left[i] × right[i]。如果直白地写，就是先正着扫一遍填 left，再倒着扫一遍填 right，最后逐位相乘。这完全正确，空间是 O(n)，不影响 O(n) 时间的要求。

空间其实还可以缩减到O(1)。因为其实不需要维护一个right数组，只需要维护一个right变量作为累乘器。

### 代码
```python
class Solution:
    def productExceptSelf(self, nums: list[int]) -> list[int]:
        answer = [1]*len(nums)# 初始化为1，方便乘积，answer[0] 左边没东西
        for i in range(1,len(nums)):
            answer[i] = answer[i-1]*nums[i-1]
        # 这时候answer就是前缀积数组了，answer[0]是1，因为它没有前缀。现在开始用right变量改造answer
        right = 1
        for i in range(len(nums)-1,-1,-1):
            # 第一个-1？因为for是左闭右开的，所以实际上遍历到answer[0]；第二个-1就是自后向前的意思
            answer[i]*=right
            right *= nums[i]
        return answer
```