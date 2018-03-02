# Python 类中的双下方法

从常用的开始：快被自己蠢哭了

## 一、

### ______init__

实例化对象时调用

```python
class Foo:
    def __init__(self,name):
        self.name = name
	
f = Foo('CharmNight') # 这时候就调用__init__方法
```



### ______new__

创建类对象时调用

__ new __ ()方法始终都是 类的静态方法，即使没有被加上静态方法装饰器

```python
class Foo:
    def __new__(cls,*args,**kwargs):
        return super().__new__(cls)
   	def __init__(self):
        pass
    
f = Foo()
```

```
__new__() 方法创建对象，在__init__()方法之前被调用，返回一个self对象，并将该对象传给__init__()的第一个参数。一般不需要复写__new__()方法，如果有需求：例如 单例模式可以通过重写__new__方法	或者在类创建时进行一些修改
```

#### 单例模式

当然单例模式不止这一种写法，有很多方法都可以实现单例

```python
# 通过__new__()方法实现单例模式

class Foo:
    _instance = None
    def __new__(cls, *args, **kwargs):
        if not hasattr(Foo,'_instance'):
            cls._instance = super().__new__(cls)
        return cls._instance
```



### ______call__

Python中的函数是一级对象。这意味着Python中的函数的引用可以作为输入传递到其他的函数/方法中，并在其中被执行。 
而Python中类的实例（对象）可以被当做函数对待。也就是说，我们可以将它们作为输入传递到其他的函数/方法中并调用他们，正如我们调用一个正常的函数那样。而类中`__call()__`函数的意义正在于此。为了将一个类实例当做函数调用，我们需要在类中实现`__call()__`方法。也就是我们要在类中实现如下方法：`def __call__(self, [args...])`。这个方法接受一定数量的变量作为输入。 

`__call()__`的作用是使实例能够像函数一样被调用，同时不影响实例本身的生命周期（`__call()__`不影响一个实例的构造和析构）。但是`__call()__`可以用来改变实例的内部成员的值

说人话就是__ call __方法就是 让对象加括号 执行call里的内容

```python
class Foo:
    def __init__(self, name):
        self.name = name

    def __call__(self, *args, **kwargs):
        self.name = self.name.upper()

f = Foo('Charm_Night')
f()
print(f.name)
```

```
CHARM_NIGHT
```



## 二、

### ______getattr__

拦截点号运算。当对未定义的属性名称和实例进行点号运算时，就会用属性名作为字符串调用这个方法。如果继承树可以找到该属性，则不调用此方法

```python
class Foo():
    def __init__(self, item):
        self.item = item

    def __getattr__(self, item):
        print('Run getattr')
        return item

f = Foo([1,2,3])
print(f.name)
```

```
Run getattr
name
```

哈？说没看懂什么时候调用？ 简单说就是当调用该属性却没有找到时，就会执行__getattr _ _方法

```
如果属性查找（attribute lookup）在实例以及对应的类中（通过__dict__)失败， 那么会调用到类的__getattr__函数, 如果没有定义这个函数，那么抛出AttributeError异常。由此可见，__getattr__一定是作用于属性查找的最后一步，兜底
```

#### 例子

_ _ getattr _ _ 使得实现adapter wrapper模式非常容易，我们都知道“组合优于继承”，_ _ getattr __实现的adapter就是以组合的形式。

```python
class adaptee(object):
    def foo(self):
        print( 'foo in adaptee')
    def bar(self):
        print ('bar in adaptee')

class adapter(object):
    def __init__(self):
        self.adaptee = adaptee()

    def foo(self):
        print('foo in adapter')
        self.adaptee.foo()

    def __getattr__(self, name):
        print('run')
        return getattr(self.adaptee, name)

if __name__ == '__main__':
    a = adapter()
    a.foo()
    a.bar()
```

```
foo in adapter
foo in adaptee
bar in adaptee
```



### ______getattribute__

__ getattribute__是访问属性的方法，我们可以通过方法重写来扩展方法的功能。

对于python来说，属性或者函数都可以被理解成一个属性，且可以通过__ getattribute__获取。

当获取属性时，直接return object.__ getattribute__(self,item) 或者使用 super(). _ _ getattribute _ _(item) 



#### 例子

```python
class Foo:
    def __init__(self):
        self.name = 'Night'

    def __getattribute__(self, item):
        print('Run getattribute')
        if item is 'func':
            return super().__getattribute__('func')
        elif item is 'name':
            return super().__getattribute__('name')
        else:
            return super().__getattribute__('demo')

    def demo(self):
        print('Run demo')

    def func(self):
        print('Run func')

f = Foo()
print(f.name)
f.func()
f.a()
```

```
Run getattribute
Night
Run getattribute
Run func
Run getattribute
Run demo
```



### getattr和aetattribute区别



```
首先我们应该已经知道了 __getattr__ 和 __getattribute__ 这两个方法都是 截取属性的内置方法。我们来看下这两个方法的区别
```

#### 定义的区别

```
__getattr__ 是当找不到这个属性时调用该方法
__getattribute__ 是当查询属性时就调用该方法
```

#### 调用时的区别

```
如果类中同时实现了__getattr__ 和 __getattribute__ 方法 会调用__getattribute__ 方法
当然 如果 __getattribute__ 方法没有找到(抛出异常AttributeError) 会继续调用__getattr__方法
```

```python
class Foo:
    def __getattr__(self, item):
        print('getattr is running')
        if item is 'func':
            return getattr(self, item)
        else:
            return getattr(self, 'demo')

    def __getattribute__(self, item):
        print('getattribute is running')
        if item is 'func':
            return super().__getattribute__(item)
        else:
            return super().__getattribute__('demo')

    def func(self):
        print('func')
        
    def demo(self):
        print('demo')
        
f = Foo()
f.func2()
```

```
getattribute is running
func
```



### ______setattr__

会拦截所有属性的的赋值语句.如果定义了这个方法，self.arrt = value 就会变成self.__ setattr__("attr", value)

```python
class Foo:
    def __setattr__(self, key, value):
        print(key, value)
        self.__dict__[key] = value

f = Foo()
f.name = 'Night'
print(f.name)
```

```
name Night
Night
```

#### 错误使用方法

不可使用self.attr = value,因为他会再次调用self.__ setattr__("attr", value),则会形成无穷递归循环，最后导致堆栈溢出异常

```python
class Foo:
    def __setattr__(self, key, value):
        print(key, value)
        self.name = value
```



#### 属性私有化

```python
class PrivateExc(Exception):
    '''这里自定义了一个异常'''
    def __init__(self, key):
        err = '{} is private, Not change'.format(key)
        super().__init__(err)

class Privacy:
    def __setattr__(self, key, value):
        if key in self.privates:
            raise PrivateExc(key)
        else:
            self.__dict__[key] = value

class Foo(Privacy):
    privates = ['name']
    def __init__(self, age):
        self.__dict__['name'] = 'Night'
        self.age = age

f = Foo(18)
print(f.age)
print(f.name)
f.name = 'Charm'	# 报错
print(f.name)
```



### ______delattr__

删除属性时调用该方法

```python
class Foo:
    def __delattr__(self, item):
        print('run delete')

f = Foo()
f.name = 'Charm'
del f.name
```



## 三、

### ______eq__

使用==进行判断，是否相等

```python
class Foo:
    
    def __eq__(self, other):
        print('eq is run')
        if self is other:
            return True
        return False
    
f1 = Foo()
f2 = Foo()
print(f1 == f2)
```

```
eq is run
False
```



### 比较大小的4个方法

```
__ge__		大于等于
__gt__		大于
__le__		小于等于
__lt__		小于
```



```python
class Foo:
    def __init__(self, age):
        self.age = age

    def __ge__(self, other):
        '''大于等于'''
        print('ge is run')
        if self.age.__ge__(other.age):
            return True
        return False

    def __gt__(self, other):
        '''大于'''
        print('gt is run')
        if self.age.__gt__(other.age):
            return True
        return False

    def __lt__(self, other):
        '''小于'''
        print('lt is run')
        if self.age.__lt__(other.age):
            return True
        return False

    def __le__(self, other):
        '''小于等于'''
        print('le is run')
        if self.age.__le__(other.age):
            return True
        return False

f1 = Foo(12)
f2 = Foo(13)
print(f1 <= f2)
print(f1 < f2)
print(f1 > f2)
print(f1 >= f2)
```

```
le is run
True
lt is run
True
gt is run
False
ge is run
False
```



### ______hash__

如果调用hash()时会自行调用该对象的______hash__()方法

```python
class Foo:
    def __init__(self, sex):
        self.name = 'CharmNight'
        self.age = 18
        self.sex = sex

    def __hash__(self):
        return hash(self.name)

f = Foo('N')
f2 = Foo('M')
print(hash(f))
print(hash(f2))
```

```
-278629965
-278629965
```



### 例子

100个Student对象，如果他们的姓名和性别相同，则认为是同一个人

```python
class Student:

    def __init__(self, name, age, sex):
        self.name = name
        self.age = age
        self.sex = sex

    def __eq__(self, other):
        if self.name is other.name and self.sex is other.sex:
            return True
        return False

    def __hash__(self):
        return hash(self.name+self.sex)

set_ = set()
for i in range(100):
    stu = Student('CharmNight',i, 'N')
    set_.add(stu)

print(set_)
```

```
{<__main__.Student object at 0x02D6AC90>}
```



解释下

```
首先：set 是根据 hash值进行判断是否相同，即 拿到hash值 在通过==进行判断是否是同一个对象

根据set的这个特性：
	重写了 __eq__ 和 __hash__ 两个方法
```





## 四、

### ______getitem__

返回键对应的值

```python
class Foo:
    def __init__(self, item):
        self.item = item

    def __getitem__(self, item):
        print('getitem is run', item)
        return self.item[item]


f1=Foo(['Charm', 'Night', '2018', '加油'])
print(f1[0])
```

```
getitem is run 0
Charm
```



### ______setitem__

给键设置对应的值

```python
class Foo:
    def __init__(self, item):
        self.item = item

    def __setitem__(self, key, value):
      	print('setitem is run')
        self.item[key] = value

    def __repr__(self):
        return '{}'.format(self.item)

f = Foo(['Night', 'so', 'cool'])
f[0] = 'Charm'
print(f)
```

```
setitem is run
['Charm', 'so', 'cool']
```



### ______delitem__

删除给定键对应的元素

```python
class Foo:
    def __init__(self, item):
        self.item = item

    def __delitem__(self, key):
        print('delitem is run')
        del self.item[key]

f = Foo(['CharmNight', 'GG'])
del f[1]
print(f.item)
```

```
delitem is run
['CharmNight']
```



### ______len__

返回元素的数量

```python
class Foo:
    def __init__(self, item):
        self.item = item

    def __len__(self):
        print('len is run')
        return len(self.item)

f = Foo([1,2,3,4])
print(len(f))
```

```
len is run
4
```



### 上述4个方法的小结

```
使用__getitem__ __setitem__ __delitem__ __len__ 及 自定义异常 简单模拟了一个不可删除的 列表类
```



```python
class DelError(Exception):
    def __init__(self):
        err = '{} undelete'.format(self)
        super().__init__(err)

class Foo:
    def __init__(self, item):
        if isinstance(item, list):
            self.item = item
        else:
            raise TypeError

    def __len__(self):
        return len(self.item)

    def __setitem__(self, key, value):
        self.item[key] = value

    def __getitem__(self, item):
        start = 0
        end = len(self.item)
        if isinstance(item, int):
            if start <= item < end:
                return self.item[item]
            raise KeyError
        elif isinstance(item, slice):
            slice_start = 0 if item.start is None else item.start
            slice_stop = len(self.item) if item.stop is None else item.stop
            slice_step = item.step

            if slice_step is None:
                if slice_start <= slice_stop:
                    return self.item[slice_start:slice_stop]
                raise KeyError
            elif slice_step > 0:
                if slice_stop <= slice_stop:
                    return self.item[slice_start:slice_stop:slice_step]
                raise KeyError
            else:
                slice_start = len(self.item) if item.start is None else item.stop
                slice_stop = 0 if item.stop is None else item.start
                if slice_start >= slice_stop:
                    return self.item[slice_start:slice_stop:slice_step]
                raise KeyError

    def __delitem__(self, key):
        raise DelError

f = Foo([1,2,3,4,5,6])
print(f[::-2])
del f[2]
```



## 五、

### ______str__

改变对象的字符串显示

```
返回值必须是字符串,否则抛出异常
```

```python
class Foo:
    def __init__(self, name):
        self.name = name

    def __str__(self):
        return 'obj name is ' + self.name

f = Foo('CharmNight')
print(f)
print('%s'%f)
print('%r'%f)
```

```
obj name is CharmNight
obj name is CharmNight
<__main__.Foo object at 0x02D19AB0>
```



### ______repr__

改变对象的字符串显示

```
返回值必须是字符串,否则抛出异常
如果__str__没有被定义,那么就会使用__repr__来代替输出
```

```python
class Foo:
    def __init__(self, name):
        self.name = name

    def __repr__(self):
        return 'obj name is ' + self.name

f = Foo('CharmNight')
print(f)
print('%s'%f)
print('%r'%f)
```

```
obj name is CharmNight
obj name is CharmNight
obj name is CharmNight
```



### ______format__

自定制格式化字符串

```python
class Foo:
    def __init__(self):
        self.name = 'CharmNight'

    def __format__(self, format_spec):
        return ' '.join([self.name, format_spec])

f = Foo()
print(format(f,'No.1'))
```

```
CharmNight No.1
```



## 六、

###  ______doc__

- 该属性无法被继承
- 类的描述信息

```python
class Foo:
    '''Foo 是 一个类 233'''
    pass

f = Foo()
print(f.__doc__)
```

```
Foo 是 一个类 233
```

### ______module__

表示当前操作的对象在那个模块

```python
class Foo:
    '''Foo 是 一个类 233'''
    pass

f = Foo()
print(f.__module__)
```

```
__main__	# 代表当前模块
```



### ______class__ 

表示当前操作的对象的类是什么

```python
class Foo:
    '''Foo 是 一个类 233'''
    pass

f = Foo()
print(f.__class__)
```

```
<class '__main__.Foo'>	# 模块.类名
```



## 七、

描述符是什么:描述符本质就是一个新式类,在这个新式类中,至少实现了______get______(),______set________(),________delete______()中的一个,这也被称为描述符协议
______get__():调用一个属性时,触发
______set__():为一个属性赋值时,触发
______delete__():采用del删除属性时,触发

### ______get__

```python
class Foo:
    def __init__(self):
        self.name = 'Night'

    def __get__(self, instance, owner):
        print(instance, owner)
        return instance

class Foo2:
    f = Foo()
f2 = Foo2()
print(f2.f)
print(Foo2.f)
```

```
<__main__.Foo2 object at 0x0319AB90> <class '__main__.Foo2'>
<__main__.Foo2 object at 0x0319AB90>
None <class '__main__.Foo2'>
None

```



### ______set__



###______delete__



### ______del__

析构方法，当对象在内存中被释放时，自动触发执行。

注：如果产生的对象仅仅只是python程序级别的（用户级），那么无需定义 _ _ del _ _ ,如果产生的对象的同时还会向操作系统发起系统调用，即一个对象有用户级与内核级两种资源，比如（打开一个文件，创建一个数据库链接），则必须在清除对象的同时回收系统资源，这就用到了_ _del__

```python
class Foo:

    def __del__(self):
        print('执行我啦')

f1=Foo()
del f1
print('------->')

#输出结果
执行我啦
------->
```

#### 注意

即使你没有执行del 方法调用回收，解释器也会在脚本执行结束后调用系统的del方法进行回收

```python
class Foo:

    def __del__(self):
        print('执行我啦')

f1=Foo()
print('------->')

#输出结果
------->
执行我啦
```



#### 经典场景

创建数据库类，用该类实例化出数据库链接对象，对象本身是存放于用户空间内存中，而链接则是由操作系统管理的，存放于内核空间内存中

当程序结束时，python只会回收自己的内存空间，即用户态内存，而操作系统的资源则没有被回收，这就需要我们定制_ _del__，在对象被删除前向操作系统发起关闭数据库链接的系统调用，回收资源

## 八、

### ______enter______  和  ________exit____

自定义支持上下文管理协议的类。自定义的上下文管理器要实现上下文管理协议所需要的 ______enter______() 和 ______exit______() 两个方法：

- context_manager.______enter______() ：进入上下文管理器的运行时上下文，在语句体执行前调用。with 语句将该方法的返回值赋值给 as 子句中的 target，如果指定了 as 子句的话
- context_manager.______exit______(exc_type, exc_value, exc_traceback)：退出与上下文管理器相关的运行时上下文，返回一个布尔值表示是否对发生的异常进行处理。参数表示引起退出操作的异常，如果退出时没有发生异常，则3个参数都为None。如果发生异常，返回 True 表示不处理异常，否则会在退出该方法后重新抛出异常以由 with 语句之外的代码逻辑进行处理。如果该方法内部产生异常，则会取代由 statement-body 中语句产生的异常。要处理异常时，不要显示重新抛出异常，即不能重新抛出通过参数传递进来的异常，只需要将返回值设置为 False 就可以了。之后，上下文管理代码会检测是否 ______exit__() 失败来处理异常

```python
class Foo:
    def __init__(self, name):
        self.name = name

    def __enter__(self):
        print('出现with语句,对象的__enter__被触发,有返回值则赋值给as声明的变量')
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        print('with中代码块执行完毕时执行我啊')
        print('exc_type',exc_type)	# 异常类型
        print('exc_val',exc_val)	# 异常值
        print('exc_tb',exc_tb)		# 追溯信息
        return True					# 返回值为True,那么异常会被清空，就好像啥都没发生一样，with后的语句正常执行
      
with Foo('CharmNight') as f:
    print('run')
    raise AttributeError('asd')
print('over')
```

```
出现with语句,对象的__enter__被触发,有返回值则赋值给as声明的变量
run
with中代码块执行完毕时执行我啊
exc_type <class 'AttributeError'>
exc_val asd
exc_tb <traceback object at 0x034176C0>
over
```



#### 例子

简单模拟下with Open的语法

```python
class Open:
    def __init__(self, file, mode='r', encoding=None):
        self.file = file
        self.mode = mode
        self.encoding = encoding

    def __enter__(self):
        self.f = open(self.file, mode=self.mode, encoding=self.encoding)
        return self.f

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.f.close()
        return True

with Open('asd', 'w', encoding='utf-8') as f:
    f.write('Hello')
```



## 九、

### ______slots__

______slots______的作用是阻止在实例化类时为实例分配dict，默认情况下每个类都会有一个dict,通过______dict______访问，这个dict维护了这个实例的所有属性

#### 作用：

- 减少内存使用
- 限制对实例添加新的属性

#### 缺点：

- 不可被继承
- 不可动弹添加新属性

#### 例子

```python
class Foo:
    __slots__ = ('name', 'age')

    def __init__(self, name, age):
        self.name = name
        self.age = age

f = Foo('CharmNight', 18)
print(f.name)
print(f.age)

f.sex = 'N'	# 报错
```

```
Traceback (most recent call last):
CharmNight
  File "D:/demo.py", line 12, in <module>
18
    f.sex = 'N'
AttributeError: 'Foo' object has no attribute 'sex'
```



#### 如何减少内存的使用

```
为何使用__slots__:字典会占用大量内存,如果你有一个属性很少的类,但是有很多实例,为了节省内存可以使用__slots__取代实例的__dict__当你定义__slots__后,__slots__就会为实例使用一种更加紧凑的内部表示。实例通过一个很小的固定大小的数组来构建,而不是为每个实例定义一个字典,这跟元组或列表很类似。在__slots__中列出的属性名在内部被映射到这个数组的指定小标上。使用__slots__一个不好的地方就是我们不能再给实例添加新的属性了,只能使用在__slots__中定义的那些属性名。
```

```python
class Foo:
    __slots__ = ('name', 'age')

    def __init__(self, name, age):
        self.name = name
        self.age = age

f = Foo('CharmNight', 18)
print(f.__slots__)
print(f.__dict__)
```

```
('name', 'age')
Traceback (most recent call last):
  File "D:/demo.py", line 10, in <module>
    print(f.__dict__)
AttributeError: 'Foo' object has no attribute '__dict__'
```



## 十、

### ______next__ 和 ______iter__

```python
class Foo:
    def __init__(self):
        self.nub = 0

    def __next__(self):
        print('next is run')
        self.nub += 1
        return self.nub

    def __iter__(self):
        print('iter is run')
        return self
f = Foo()
for i in f:
    print(i)
```



## 十一、

### ______add__ 

加法运算就是调用的__ add __

```python
class Foo:
    def __init__(self, nub):
        self.nub = nub

    def __add__(self, other):
        return self.nub + other.nub

f1 = Foo(1)
f2 = Foo(10)
a = f1 + f2
print(a)
```

```
11
```



### ______iadd__

就地加调用的__ iadd __

```python
class Foo:
    def __init__(self, nub):
        self.nub = nub

    def __iadd__(self, other):
        return self.nub + other.nub

f1 = Foo(1)
f2 = Foo(10)
f1 += f2
print(f1)
```

```
11
```



### ______radd__

被加（当左操作数不支持相应的操作时被调用）

```python
class Foo:
    def __init__(self, nub):
        self.nub = nub

    def __radd__(self, other):
        print('radd is run')
        return self.nub + other

f1 = Foo(1)
s = 10 + f1
print(s)
```

```
11
```



当然还有其他的 …… 小白太low 还没有接触到

