# ctypes

###### 			声明——以下代码均在python3.6下测试执行的

## 初识

### msvcrt.printf只打印一个字符

python3.x中

```python
import ctypes
msvcrt = ctypes.cdll.msvcrt
message_string = 'Hello world!\n'
msvcrt.printf('Testing:%s',%message_string)
```

```
T
```

嗯哼哼？ 和预想的结果不一样哇 在python2中 会输出所有字符，但在python3中

```
处理字符串过程中若遇到'\0'一般认为是结尾，python3 改为默认宽字符处理字符，比如，一般情况下'a'是一个字节存储0x61，而宽字节用两个字节表示为0x0061，若存储时倒叙 则为0x6100，printf函数默认单字节处理，所以只打印一个字符遇到'\0'后认为结束。
5楼用wprintf是可以的，一次处理两个字节不会遇到'\0',直到结束。
```

#### 解决方案

##### 一、使用wprintf

```python
import ctypes
msvrt = ctypes.cdll.msvcrt
message_string = 'Hello world!\n'
msvrt.wprintf('Testing:%s',%message_string)
```

##### 二、转换编码

```python
import ctypes
msvrt = ctypes.cdll.msvcrt
message_string = b'Hello world!\n'
msvrt.printf(b'Testing:%s',%message_string)
```



### 使用c中的一些数据类型

```python
import ctypes
i = ctypes.c_char('9'.encode())
print(i)
print(i.value)

i = ctypes.c_int(9)
print(i)

i = ctypes.c_char_p('Hello 你好'.encode())
print(type(i))
print(i)
print(i.value.decode())
```

```
c_char(b'9')
b'9'
c_long(9)
<class 'ctypes.c_char_p'>
c_char_p(78699344)	# 如果对这坨数字有疑问 看 注解1
Hello 你好
```

#### 先说下和python2中的区别：

```
在Python 2.7中，string默认的是byte-strings，而在 Python 3.x中默认的是unicode。因此在3.x中将string传入到调用的DLL之前先使用 .encode('ascii') 将其变成 byte string类型
至于为什么我上面写的encode()没有指定编码，因为 python3中默认不写为utf-8 为了使用中文选择的utf-8, 只要转成python中的bytes类型，什么编码都可以 
注：python3中的bytes类型就是指 byte string类型
```

#### 注解1

```python
s = 'Hello 你好'.encode()
i = ctypes.c_char_p(s)
print(i)
```

```
c_char_p(85711856) # 对应的指针的内存地址
```



### 结构和联合

结构和联合是C语言中非常重要的**数据结构** ，被大量应用于 WIN32 的 API 和 Linux 的 libc 中，一个结构便两个就是一组简单的集合（所有变量都占用空间），这些结构内的变量在类型上没有限制，可以通过点加变量名的方式来访问。



#### 区别

```
1. 结构和联合都是由多个不同的数据类型成员组成, 但在任何同一时刻, 联合转只存放了一个被选中的成员, 而结构的所有成员都存在。 
2. 对于联合的不同成员赋值, 将会对其它成员重写, 原来成员的值就不存在了, 而对于结构的不同成员赋值是互不影响的。 
```



#### 使用ctypes创建一个兼容C语言的结构

##### c语言

```c
struct beer_recipe
{
    int amt_barley;
    int amt_water;
};
```

##### python

```python
import ctypes
class beer_recipe(ctypes.Structure):
    _fields_ = [
        ('amt_barley', ctypes.c_int),
        ('amt_water', ctypes.c_int),
    ]
beer_recipe.amt_barley = 10
print(beer_recipe.amt_barley)	
```

###### 输出结果：

```
10
```





#### 使用ctypes创建一个兼容C语言的联合

##### c语言

```c
union{
    long    barley_long;
    int     barley_int;
    char    barley_char[8];
}barley_amount;
```

##### python

```python
import ctypes
class barley_amount(ctypes.Union):
    _fields_=[
        ('barley_long', ctypes.c_long),
        ('barley_int', ctypes.c_int),
        ('barley_char', ctypes.c_char*8),
    ]

value = input('Enter the amount of barley to put into the beer vat:')
my_barley = barley_amount(int(value))
print('Barley amount as a long:{}'.format(my_barley.barley_long))
print('Barley amount as a long:{}'.format(my_barley.barley_int))
print('Barley amount as a long:{}'.format(
```

###### 输出结果：

```
输入66

Enter the amount of barley to put into the beer vat:66
Barley amount as a long:66
Barley amount as a long:66
Barley amount as a long:b'B'
```

###### 注

```
给联合赋一个值就能得到三种不同的表现方式。最后一个barley_char 输出的结果是B，
因为66刚好是B的ASCII码。
barley_char成员同时也是个数组，一个八个字符大小的数组。在ctypes中申请一个数组，
只要简单的将变量类型乘以想要申请的数量就可以
```



