# random——产生伪随机数

## 模块用途

> random 模块是为各种分布实现伪随机数发生器。

几乎模块中所有函数都依赖于基本函数**random()**,它在半开放范围**[0.0,1.0)**内产生一个统一的随机浮点数。Python使用Mersenne Twister作为核心生成器。它生成53位精度浮点数，周期为2**19937-1.C中的底层实现即快速又线程安全。

```
注：Mersenne Twister是存在的最广泛测试的随机数发生器之一。但是，这是完全确定性的，并不适用于所有目的，并且完全不适合加密的目的
```

**警告：该模块的伪随机生成器不应用于安全目的。为了安全或加密使用**



## _randbelow()的部分源码

```python
BPF = 53        
# 返回一个小于n的随机数（计算随机数的实例）
    def _randbelow(self, n, int=int, maxsize=1<<BPF, type=type,
                   Method=_MethodType, BuiltinMethod=_BuiltinMethodType):

        "Return a random int in the range [0,n).  Raises ValueError if n==0."

        random = self.random			# 将父类的random方法赋值给random
        getrandbits = self.getrandbits	# 将父类的getrandbits方法赋值给getrandbits
        
        # 如果原始的random()内置方法没有被覆盖 或者 提供了一个新的getrandbits() 才可以调用self.getrandbits
        if type(random) is BuiltinMethod or type(getrandbits) is Method:
             # 如果 random 是内置函数 或 getrandbits 是 方法
            
            # k 是 开始位置转换成二进制的长度
            k = n.bit_length()  # don't use (n-1) here because n can be 1
            # 计算 一个随机数
            r = getrandbits(k)          # 0 <= r < 2**k
            while r >= n:
                r = getrandbits(k)
            # 返回一个小于n的随机数
            return r
       
        # 如果复写了random()方法但是没有复写getrandbits()方法 我们只能用自己的random()方法
        if n >= maxsize:
            # 如果n >= maxsize (maxsize = 9007199254740992) 就调用random()方法
            _warn("Underlying random() generator does not supply \n"
                "enough bits to choose from a population range this large.\n"
                "To remove the range limitation, add a getrandbits() method.")
            return int(random() * n) # random() 方法 是 随机[0,1) 的一个数
        rem = maxsize % n
        limit = (maxsize - rem) / maxsize   # int(limit * maxsize) % n == 0
        r = random()	# r < liimit
        while r >= limit:
            r = random()
        return int(r*maxsize) % n  
```

#### 

## 随机整数

### random.randrange(self, start, stop=None, step=1, _int=int)

- start:		起始数值
  - stop=None:结束数值 默认为 None
    - step=1步长 默认为1

#### random.randrange(10)

​	——产生一个[0,10)的随机整数

```python
import random
print(random.randrange(10))

5
```



以下为randrange部分源码

```python
 def randrange(self, start, stop=None, step=1, _int=int):
    istart = _int(start)
        if istart != start:
            raise ValueError("non-integer arg 1 for randrange()")
        # 如果stop是空 即 我们只传了一个参数即 random.randrange(10)
        if stop is None:
            if istart > 0:
                # 返回一个小于 start 的 随机数
                return self._randbelow(istart)
            raise ValueError("empty range for randrange()")
```

random.randrange(10)

如果我们传入的参数是一个大于0的数字，就会通过_randbelow(10)进行运算得到返回值

#### random.randrange(5,20)

​		——产生一个[5,20)的随机整数

```python
import random
print(random.randrange(5, 20))

7
```



以下是randrange部分源码

```python
 def randrange(self, start, stop=None, step=1, _int=int):
        # stop argument supplied.
        istop = _int(stop)
        if istop != stop:
            raise ValueError("non-integer stop for randrange()")
        width = istop - istart # 范围 是一个整数
        if step == 1 and width > 0: # 如果步长等于1 且 范围大于零
            # 返回 一个 start + 小于范围的随机数
            return istart + self._randbelow(width) # _randbelow()方法见上面
        if step == 1:
            # 如果范围 <= 0 则抛出以下异常 具体示例 见 Lrandrange_E1
            raise ValueError("empty range for randrange() (%d,%d, %d)" % (istart, istop, width))
            
```

random.randrange(5，20)

如果我们传入的参数为x, y 且（y - x ）> 0  就会通过x + _randbelow(y - x) 进行运算得到返回值



Lrandrange_E1

```python
import random
print(random.randrange(1,1,1))

Traceback (most recent call last):
  File "D:/random_demo.py", line 20, in <module>
    print(random.randrange(1,1,1))
  File "D:/random_demo.py", line 198, in randrange
    raise ValueError("empty range for randrange() (%d,%d, %d)" % (istart, istop, width))
ValueError: empty range for randrange() (1,1, 0)
```





#### random.randrange(5,-1,-2)

​		——产生(5,-1,-2)的随机数

```python
import random
print(random.randrange(5,-1,-2))

3
```



#### random.randrange(5,20,5)

​		——产生(5,20,5)的随机数

```python
import random
print(random.randrange(5, 20, 5))


10
```



以下是randrange部分源码

```python
 def randrange(self, start, stop=None, step=1, _int=int):
	istep = _int(step)
        if istep != step:
            raise ValueError("non-integer step for randrange()")
        
        # 要么 start < stop and istep > 0
        # 要么 start > stop and istep < 0
        # 其余情况报错
        if istep > 0:
            # width = istop - istart
            n = (width + istep - 1) // istep 
        elif istep < 0:
            n = (width + istep + 1) // istep 
        else:
            raise ValueError("zero step for randrange()")

        if n <= 0:
            raise ValueError("empty range for randrange()")
		# 返回 start + 步长 * 小于n的随机整数
        return istart + istep*self._randbelow(n)
```

如果我们传入的参数为为x, y,  z

-  ( z < 0 )且（y - x ）< 0  就会通过x + z * _randbelow((y - x + 1) // z) 进行运算得到返回值
-  ( z > 0 )且（y - x ）> 0  就会通过x + z * _randbelow((y - x - 1) // z) 进行运算得到返回值
   -  ((y - x + 1) // z) 是计算了 可取的范围（其实就是计算了[x, y)这个范围中有最多可取到多少个z）
   -  根据这个数取一个小于它的随机数然后乘步长 + x 


### random.randint(a，b)

返回一个随机整数*N*使得。别名 。`a <= N <= b``randrange(a, b+1)`

```python
def randint(self, a, b):
    """Return random integer in range [a, b], including both end points.
    """

    return self.randrange(a, b+1)
```

so~ randint() 其实就是调用了 randrange()方法 也就是一个简化版的randrange()



## 序列函数

### random.choice(self, seq)

​		——在一个非空的序列中选择一个元素

```python
import random
print(random.choice([1,2,3]))

1
```



源码如下

```python
def choice(self, seq):
    try:
        # 选择一个随机索引
        i = self._randbelow(len(seq))
    except ValueError:
        # 如果序列为空 则抛出异常
        raise IndexError('Cannot choose from an empty sequence')
    # 通过索引找到随机的元素
    return seq[i]
```

random.choice([1,2,3])

在这个list列表中 根据列表的长度随机算出一个小于列表长度的数作为索引，返回该索引的值



### random.shuffle(self, x, random=None)

将序列x随机混合（将x随机打乱）

```python
import random
l = [12,11,10]
random.shuffle(l)
print(l)


[12, 10, 11]
```



源码如下

```python
def shuffle(self, x, random=None):
        ''' x 列表（可迭代对象）
            random 是一个 计算随机数的方法
        '''
  	# random 为空 即 我们没有手动传入一个计算随机数的方法
    if random is None
    	# 赋予self._randbelow方法 一个别名 randbelow
        randbelow = self._randbelow
       
        # 循环 len 次每次将索引为i的 值 和 索引为 一个小于i的随机整数的值进行替换
        for i in reversed(range(1, len(x))):
            # 通过self._randbelow方法进行计算随机数得到j的值
            j = randbelow(i+1)
            # 交换 索引为i 和索引为j的值
            x[i], x[j] = x[j], x[i]
    		
    # 如果我们手动传入了一个随机数方法
    else:
        _int = int
        # 循环 len 次每次将索引为i的 值 和 索引为 一个小于i的随机整数 的值进行替换
        for i in reversed(range(1, len(x))):
          	# 通过我们手动传入的随机数方法的结果 * (i+1) 得到j的值
            j = _int(random() * (i+1))
            # 交换 索引为i 和索引为j的值
            x[i], x[j] = x[j], x[i]
```

shuffle方法其实是不断进行两两索引位置的值进行交换 达到打乱顺序的

并且它是在原本的列表上进行打乱的，而没有新的列表生成



### random.sample(self, population, k)

​		——返回从总体序列或集合中选择的唯一元素的*k*长度列表。用于无需更换的随机抽样。

```python
import random
l = [1,2,3,4,5]
l2 = random.sample(l,2)
print(l2)


[4, 3]
```



源码如下

```python
	def sample(self, population, k):
    	# 判断population是否是可使用sample的类型（如果是set转成tuple 如果是tuple、list就继续运行 如果是dict直接报错）
		if isinstance(population, _Set):
            population = tuple(population)
        if not isinstance(population, _Sequence):
            raise TypeError("Population must be a sequence or set.  For dicts, use list(d).")
        # self._randbelow 命名一个别名randbelow
        randbelow = self._randbelow
        # 计算population的长度
        n = len(population)
        # 如果k >=n 或者<=0 就报错， k是选择元素的长度
        if not 0 <= k <= n:
            raise ValueError("Sample larger than population or is negative")
        # 设置默认值
        result = [None] * k
        setsize = 21        # 默认为小集合
        # 如果k大于5则认为 是一个大集合 否则是小集合
        if k > 5:
            setsize += 4 ** _ceil(_log(k * 3, 4)) # table size for big sets
        
        # 如果是小集合（An n-length list is smaller than a k-length set）
        if n <= setsize:
            # 将population强转成list
            pool = list(population)
            # 这里！！！ 其实就是为了每次都可以选出列表中的一个数(选出一个之前没有选择过的数) 然后依次赋给result 这个之前设置的默认值为None 的列表
            for i in range(k):         # invariant:  non-selected at [0,n-i)
              	# 随机一个 n-i 的整数当作 下标赋给j
                j = randbelow(n-i)
                # 这下面两句就是在 把选中的数替换成倒置位的数 （因为倒置位的数一直无法取到所以将其替换到前面 ）
                result[i] = pool[j]		# 将值赋给  result列表
                pool[j] = pool[n-i-1]   # move non-selected item into vacancy
        
        # 猜测是因为大集合如果转换成list太过于占空间 所以单独 拿了出来
        else:
          	# 创建了一个set 对象 
            selected = set()
            selected_add = selected.add # 给set对象的add方法 赋值一个别名
            
            for i in range(k):
                j = randbelow(n) # 一个小于n的随机数 并赋给j 当作下标
                
                # 如果j 不在selected中，即 我们没有选择过 下标为j的数，就跳过while循环
                # 如果在selected中，即 我们曾经选择到 下标为j的数， 则重新取随机数 直到，选择一个从来没有使用过的j
                while j in selected:
                    j = randbelow(n)
                    
                selected_add(j)		# 将j添加到集合中
                result[i] = population[j] # 将值赋给  result列表
        return result
```



## 簿记功能

### random.seed(self, a=None, version=2)

​		——seed() 方法改变随机数生成器的种子，可以在调用其他随机模块函数之前调用此函数

**改变随机数生成器的种子seed。如果你不了解其原理，你不必特别去设定seed，Python会帮你选择seed。**

```python
import random
random.seed(0)
print(random.random())
random.seed(0)
print(random.random())
```

```
0.8445167133186481
0.8445167133186481
```



源码如下 

```python
def seed(self, a=None, version=2):
	# a -- 改变随机数生成器的种子seed。如果你不了解其原理，你不必特别去设定seed，Python会帮你选择seed。
    # 默认调用第二个方式 version = 2 
    
    # 是方案1 并且 a是str 或 bytes 
    if version == 1 and isinstance(a, (str, bytes)):
      	# 如果 a 不为None 则 进行运算 否则x 为0
        x = ord(a[0]) << 7 if a else 0
        for c in a:
            x = ((1000003 * x) ^ ord(c)) & 0xFFFFFFFFFFFFFFFF
        x ^= len(a)
        a = -2 if x == -1 else x
	# 是方案2 并且 a是str 或 bytes 或 bytearray
    if version == 2 and isinstance(a, (str, bytes, bytearray)):
        # 如果a是字符串则 转成bytes类型
        if isinstance(a, str):
            a = a.encode()
        # a 进行加密并进行拼接
        a += _sha512(a).digest()
        a = int.from_bytes(a, 'big')
	
    # 调用父类的seed（父类中根据当前时间进行生成）
    super().seed(a)
    self.gauss_next = None
```