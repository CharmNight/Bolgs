# bisect

​		——这是一个python的针对**有序** 数组的插入和排序操作的一个模块

首先看看bisect这个模块中都有什么方法吧

```python
import bisect
[print(i) for i in dir(bisect)if i.find('__') == -1]

bisect
bisect_left
bisect_right
insort
insort_left
insort_right
```

bisect 就是调用的bisect_right

insort 就是调用 的insort_right

---



## bisect

​		—— 其实bisect 就是在调用 bisect_right

```python
import bisect

li = [1, 23, 45, 12, 23, 42, 54, 123, 14, 52, 3]
li.sort()
print(li)
print(bisect.bisect(li, 3))
```

```
[1, 3, 12, 14, 23, 23, 42, 45, 52, 54, 123]
2
```



不信你看源码

```python
bisect = bisect_right   # backward compatibility
```

一句话就可以解释



## bisect_left(a, x, lo=0, hi=None)

​		——其目的在于查找该数值将会插入的位置并返回，而不会插入。如果x存在在a中则返回x左边的位置

```python
import bisect

li = [1, 23, 45, 12, 23, 42, 54, 123, 14, 52, 3]
li.sort()
print(li)
print(bisect.bisect_left(li, 3))
```

```
[1, 3, 12, 14, 23, 23, 42, 45, 52, 54, 123]
1
```



源码如下

```python
def bisect_left(a, x, lo=0, hi=None):
	# a 原列表
    # x 插入的元素
    # lo 起始位置 默认值为0
    # hi 结束位置 默认值为len(a)    
    
    # 如果起始位置小于0 则报错
    if lo < 0:
        raise ValueError('lo must be non-negative')
    # 如果没有 结束位置 则 默认为 列表的长度
    if hi is None:
        hi = len(a)
    # 二分法
    while lo < hi:
        mid = (lo+hi)//2
        if a[mid] < x: lo = mid+1
        else: hi = mid
    # 仅返回位置
    return lo
```



## bisect_right(a, x, lo=0, hi=None)

​		——其目的在于查找该数值将会插入的位置并返回，而不会插入。如果x存在在a中则返回x右边的位置

```python
import bisect

li = [1, 23, 45, 12, 23, 42, 54, 123, 14, 52, 3]
li.sort()
print(li)
print(bisect.bisect_right(li, 3))
```

```
[1, 3, 12, 14, 23, 23, 42, 45, 52, 54, 123]
2
```



源码如下

```python
def bisect_right(a, x, lo=0, hi=None):
   	# a 原列表
    # x 插入的元素
    # lo 起始位置 默认值为0
    # hi 结束位置 默认值为len(a)   
    
    # 如果起始位置小于0 则报错
    if lo < 0:
        raise ValueError('lo must be non-negative')
    # 如果没有 结束位置 则 默认为 列表的长度
    if hi is None:
        hi = len(a)
    # 二分法
    while lo < hi:
        mid = (lo+hi)//2
        if x < a[mid]: hi = mid
        else: lo = mid+1
    # 仅返回位置
    return lo
```

## 



## insort

​		—— 在列表a中插入元素x，并在排序后保持排序。如果x已经在a中，把它插入右x的右边。

```python
import bisect

li = [1, 23, 45, 12, 23, 42, 54, 123, 14, 52, 3]
li.sort()
print(li)
bisect.insort(li, 3.0)
print(li)
```

```
[1, 3, 12, 14, 23, 23, 42, 45, 52, 54, 123]
[1, 3, 3.0, 12, 14, 23, 23, 42, 45, 52, 54, 123]
```



​		—— 其实insort 就是在调用 insort_right

不信你看源码

```python
insort = insort_right   # backward compatibility
```

一句话就可以解释



## insort_left(a, x, lo=0, hi=None)

​		—— 在列表a中插入元素x，并在排序后保持排序。如果x已经在a中，把它插入右x的左边。

```python
import bisect

li = [1, 23, 45, 12, 23, 42, 54, 123, 14, 52, 3]
li.sort()
print(li)
bisect.insort_left(li, 3.0)
print(li)
```

```
[1, 3, 12, 14, 23, 23, 42, 45, 52, 54, 123]
[1, 3.0, 3, 12, 14, 23, 23, 42, 45, 52, 54, 123]
```



源码如下

```python
def insort_left(a, x, lo=0, hi=None):
    # a 原列表
    # x 插入的元素
    # lo 起始位置 默认值为0
    # hi 结束位置 默认值为len(a)
    
	# 如果起始位置小于0 则报错
    if lo < 0:
        raise ValueError('lo must be non-negative')
    # 如果没有 结束位置 则 默认为 列表的长度
    if hi is None:
        hi = len(a)
    # 二分查找
    while lo < hi:
        mid = (lo+hi)//2
        if a[mid] < x: lo = mid+1
        else: hi = mid
    # 插入
    a.insert(lo, x)
```



## insort_right(a, x, lo=0, hi=None)

​		—— 在列表a中插入元素x，并在排序后保持排序。如果x已经在a中，把它插入右x的右边。

```python
import bisect

li = [1, 23, 45, 12, 23, 42, 54, 123, 14, 52, 3]
li.sort()
print(li)
bisect.insort_right(li, 3.0)
print(li)
```

````
[1, 3, 12, 14, 23, 23, 42, 45, 52, 54, 123]
[1, 3.0, 3, 12, 14, 23, 23, 42, 45, 52, 54, 123]
````

源码如下

```python
def insort_right(a, x, lo=0, hi=None):
	# a 原列表
    # x 插入的元素
    # lo 起始位置 默认值为0
    # hi 结束位置 默认值为len(a)
    
    # 如果起始位置小于0 则报错
    if lo < 0:
        raise ValueError('lo must be non-negative')
    # 如果没有 结束位置 则 默认为 列表的长度
    if hi is None:
        hi = len(a)
    # 二分法查找 
    while lo < hi:
        mid = (lo+hi)//2
        if x < a[mid]: hi = mid
        else: lo = mid+1
    # 插入
    a.insert(lo, x)
```

