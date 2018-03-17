
# BeautifulSoup

方便又灵活的网页解析库，处理高效，支持多种解析器。

利用它不用编写正则表达式即可方便的实现网页信息的提取


```python
html = """
<html><head><title>The Dormouse's story</title><head>
<body>
<p class='title' name='dromouse'><b>The Dormouse's story</b></p>

"""

from bs4 import BeautifulSoup
soup = BeautifulSoup(html, 'lxml')
print(soup.prettify()) # 格式化代码，自动将代码进行补全
print(soup.title.string)
```

    <html>
     <head>
      <title>
       The Dormouse's story
      </title>
     </head>
     <body>
      <p class="title" name="dromouse">
       <b>
        The Dormouse's story
       </b>
      </p>
     </body>
    </html>
    The Dormouse's story
    

### 选择元素
只选择第一个


```python
html = """
<html><head><title>The Dormouse's story</title><head>
<body>
<p class='title' name='dromouse'><b>The Dormouse's story</b></p>

"""

from bs4 import BeautifulSoup
soup = BeautifulSoup(html, 'lxml')
print(soup.title)
print(type(soup.title))
print(soup.head)
print(soup.p)
```

    <title>The Dormouse's story</title>
    <class 'bs4.element.Tag'>
    <head><title>The Dormouse's story</title>
    </head>
    <p class="title" name="dromouse"><b>The Dormouse's story</b></p>
    

### 获取属性
    .attrs['属性名']
    ['属性名']


```python
html = """
<html><head><title>The Dormouse's story</title><head>
<body>
<p class='title' name='dromouse'><b>The Dormouse's story</b></p>

"""
from bs4 import BeautifulSoup
soup = BeautifulSoup(html, 'lxml')
print(soup.p.attrs['name'])
print(soup.p['name'])
```

    dromouse
    dromouse
    

### 获取内容


```python
html = """
<html><head><title>The Dormouse's story</title><head>
<body>
<p class='title' name='dromouse'><b>The Dormouse's story</b></p>

"""

from bs4 import BeautifulSoup
soup = BeautifulSoup(html, 'lxml')
print(soup.p.string)
print(soup.p.text)
```

    The Dormouse's story
    The Dormouse's story
    

### 嵌入选择


```python
html = """
<html><head><title>The Dormouse's story</title><head>
<body>
<p class='title' name='dromouse'><b>The Dormouse's story</b></p>

"""
from bs4 import BeautifulSoup
soup = BeautifulSoup(html, 'lxml')
print(soup.head.title.string)
```

    The Dormouse's story
    

### 子节点和子孙节点

    contents 返回的是一个列表
    children 返回的是一个迭代器
    descendants 返回所有子孙节点


```python
html = """
<html><head><title>The Dormouse's story</title><head>
<body>
<p class='title' name='dromouse'><b>The Dormouse's story</b></p>

"""
from bs4 import BeautifulSoup
soup = BeautifulSoup(html, 'lxml')
print(soup.p.contents)
```

    [<b>The Dormouse's story</b>]
    


```python
html = """
<html><head><title>The Dormouse's story</title><head>
<body>
<p class='title' name='dromouse'><b>The Dormouse's story</b></p>

"""
from bs4 import BeautifulSoup
soup = BeautifulSoup(html, 'lxml')
for i, k in enumerate(soup.p.children):
    print (i, k)
```

    0 <b>The Dormouse's story</b>
    


```python
html = """
<html><head><title>The Dormouse's story</title><head>
<body>
<p class='title' name='dromouse'><b>The Dormouse's story</b></p>

"""
from bs4 import BeautifulSoup
soup = BeautifulSoup(html, 'lxml')
# print(soup.p.descendants)
for i in soup.p.descendants:
    print(i)
```

    <b>The Dormouse's story</b>
    The Dormouse's story
    

### 父节点和祖父节点


```python
html = """
<html><head><title>The Dormouse's story</title><head>
<body>
<p class='title' name='dromouse'><b>The Dormouse's story</b></p>

"""
from bs4 import BeautifulSoup
soup = BeautifulSoup(html, 'lxml')
print(soup.b.parent)
```

    <p class="title" name="dromouse"><b>The Dormouse's story</b></p>
    

### 兄弟节点

## 标准选择器

### find_all(name. attrs, recurslve, text, **kwargs)
可根据标签名、属性、内容查找文档

name


```python
html = """
<div class="panel">
    <div class="panel-heading">
        <h4>Hello</h4>
    </div>
    <div class="panel-body">
        <ul class="list" id="list-1">
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
        <ul class="list list-small" id="list-2">
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
    </div>
</div>
"""

from bs4 import BeautifulSoup
soup = BeautifulSoup(html, 'lxml')
print(soup.find_all('ul'))
print(type(soup.find_all('ul')[0]))
```

    [<ul class="list" id="list-1">
    <li class="element">Foo</li>
    <li class="element">Bar</li>
    <li class="element">Jay</li>
    </ul>, <ul class="list list-small" id="list-2">
    <li class="element">Foo</li>
    <li class="element">Bar</li>
    <li class="element">Jay</li>
    </ul>]
    <class 'bs4.element.Tag'>
    


```python
html = """
<div class="panel">
    <div class="panel-heading">
        <h4>Hello</h4>
    </div>
    <div class="panel-body">
        <ul class="list" id="list-1">
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
        <ul class="list list-small" id="list-2">
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
    </div>
</div>
"""

from bs4 import BeautifulSoup
soup = BeautifulSoup(html, 'lxml')

# 通过上次结果知道 通过find_all('ul')得到的 数据 是<class 'bs4.element.Tag'>
# 所以我们可以继续find_all() 查找
for ul in soup.find_all('ul'):
    print(ul.find_all('li'))
```

    [<li class="element">Foo</li>, <li class="element">Bar</li>, <li class="element">Jay</li>]
    [<li class="element">Foo</li>, <li class="element">Bar</li>, <li class="element">Jay</li>]
    

### attrs

可以通过attrs={}的方式指定 有某个属性的 标签


```python
html = """
<div class="panel">
    <div class="panel-heading">
        <h4>Hello</h4>
    </div>
    <div class="panel-body">
        <ul class="list" id="list-1" name='elements'>
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
        <ul class="list list-small" id="list-2">
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
    </div>
</div>
"""

from bs4 import BeautifulSoup
soup = BeautifulSoup(html, 'lxml')
print(soup.find_all(attrs={'id':'list-1'}))
print(soup.find_all(attrs={'name':'elements'}))
```

    [<ul class="list" id="list-1" name="elements">
    <li class="element">Foo</li>
    <li class="element">Bar</li>
    <li class="element">Jay</li>
    </ul>]
    [<ul class="list" id="list-1" name="elements">
    <li class="element">Foo</li>
    <li class="element">Bar</li>
    <li class="element">Jay</li>
    </ul>]
    


```python
html = """
<div class="panel">
    <div class="panel-heading">
        <h4>Hello</h4>
    </div>
    <div class="panel-body">
        <ul class="list" id="list-1" name='elements'>
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
        <ul class="list list-small" id="list-2">
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
    </div>
</div>
"""

from bs4 import BeautifulSoup
soup = BeautifulSoup(html, 'lxml')
print(soup.find_all(id='list-1'))
print(soup.find_all(class_='element'))
```

    [<ul class="list" id="list-1" name="elements">
    <li class="element">Foo</li>
    <li class="element">Bar</li>
    <li class="element">Jay</li>
    </ul>]
    [<li class="element">Foo</li>, <li class="element">Bar</li>, <li class="element">Jay</li>, <li class="element">Foo</li>, <li class="element">Bar</li>, <li class="element">Jay</li>]
    

### text
返回的是 该内容 而不是含有该内容的标签

所以一般用于校验 数据内容  而不是找标签


```python
html = """
<div class="panel">
    <div class="panel-heading">
        <h4>Hello</h4>
    </div>
    <div class="panel-body">
        <ul class="list" id="list-1" name='elements'>
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
        <ul class="list list-small" id="list-2">
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
    </div>
</div>
"""

from bs4 import BeautifulSoup
soup = BeautifulSoup(html, 'lxml')
print(soup.find_all(text='Foo'))
```

    ['Foo', 'Foo']
    

### find(name, attrs, recursive, text, **kwargs)

find返回单个元素， find_all返回所有元素


```python
html = """
<div class="panel">
    <div class="panel-heading">
        <h4>Hello</h4>
    </div>
    <div class="panel-body">
        <ul class="list" id="list-1" name='elements'>
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
        <ul class="list list-small" id="list-2">
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
    </div>
</div>
"""

from bs4 import BeautifulSoup
soup = BeautifulSoup(html, 'lxml')
print(soup.find('ul'))
print(type(soup.find('ul')))
print(soup.find('page')) # 如果找不到则返回None
```

    <ul class="list" id="list-1" name="elements">
    <li class="element">Foo</li>
    <li class="element">Bar</li>
    <li class="element">Jay</li>
    </ul>
    <class 'bs4.element.Tag'>
    None
    

### find_parents() find_parent()

find_parents()返回所有祖先节点， find_parent()返回之间诶父节点


### find_next_siblings() find_next_sibling()

find_next_siblings() 返回后面所有兄弟节点， find_next_sibling() 返回后面第一个兄弟节点

### find_previous_siblings() find_previous_sibling()

find_previous_siblings() 返回前面的所有兄弟节点，find_previous_sibling()返回前面的第一个兄弟节点

### find_all_next() find_next()

find_all_next()返回节点后所有符合条件的节点， find_next()返回第一个符合条件的节点

### find_all_previous() 和 find_previous()

find_all_previous()返回节点后所有符合条件的节点， find_previous()返回第一个符合条件的节点

## CSS选择器

通过select() 直接传入CSS选择器即可完成选择


```python
html = """
<div class="panel">
    <div class="panel-heading">
        <h4>Hello</h4>
    </div>
    <div class="panel-body">
        <ul class="list" id="list-1" name='elements'>
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
        <ul class="list list-small" id="list-2">
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
    </div>
</div>
"""

from bs4 import BeautifulSoup
soup = BeautifulSoup(html, 'lxml')
print(soup.select('.panel .panel-heading'))
print(soup.select('ul li'))
print(soup.select('#list-2 .element'))
print(type(soup.select('ul')[0]))
```

    [<div class="panel-heading">
    <h4>Hello</h4>
    </div>]
    [<li class="element">Foo</li>, <li class="element">Bar</li>, <li class="element">Jay</li>, <li class="element">Foo</li>, <li class="element">Bar</li>, <li class="element">Jay</li>]
    [<li class="element">Foo</li>, <li class="element">Bar</li>, <li class="element">Jay</li>]
    <class 'bs4.element.Tag'>
    

### 获取属性

    可以直接通过['属性名']。 或者attrs['属性名']得到该属性


```python
html = """
<div class="panel">
    <div class="panel-heading">
        <h4>Hello</h4>
    </div>
    <div class="panel-body">
        <ul class="list" id="list-1" name='elements'>
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
        <ul class="list list-small" id="list-2">
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
    </div>
</div>
"""

from bs4 import BeautifulSoup
soup = BeautifulSoup(html, 'lxml')
for ul in soup.select('ul'):
    print(ul['id'])
    print(ul.attrs['id'])
```

    list-1
    list-1
    list-2
    list-2
    

### 获取内容

可以直接通过.get_text()方法获取内容

string...等方式也可以获取内容


```python
html = """
<div class="panel">
    <div class="panel-heading">
        <h4>Hello</h4>
    </div>
    <div class="panel-body">
        <ul class="list" id="list-1" name='elements'>
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
        <ul class="list list-small" id="list-2">
            <li class="element">Foo</li>
            <li class="element">Bar</li>
            <li class="element">Jay</li>
        </ul>
    </div>
</div>
"""
from bs4 import BeautifulSoup
soup = BeautifulSoup(html, 'lxml')
for ul in soup.select('li'):
    print(ul.get_text())
```

    Foo
    Foo
    Bar
    Bar
    Jay
    Jay
    Foo
    Foo
    Bar
    Bar
    Jay
    Jay
    

### 总结
- 推荐使用lxml解析库， 必要时使用html.parser(系统自带的解析库)
- 标签选择器筛选功能弱，但是速度快
- 建议使用find（）、find_all()查询匹配单个结果或多个结果
- 如果多CSS选择器熟悉建议使用select()
- 记住常用的获取属性和文本值的方法
