
# PyQuery
强大又灵活的网页解析库。如果你觉得正则写起来太麻烦，如果你觉得BeautifulSoup语法太难记，如果你熟悉jQuery的语法，那么PyQuery就是你的绝佳选择。

## 初始化

### 字符串初始化


```python
html = """
<div>
    <ul>
        <li class="item-0">first item</li>
        <li class="item-1"><a href="link2.html">second item</a></li>
        <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
        <li class="item-1 active"><a href="link4.html">fourth item</a></li>
        <li class="item-0"><a href="link4.html">fifth item</a></li>
    </ul>
</div>
"""

from pyquery import PyQuery as pq
doc = pq(html)
print(doc('li'))
```

    <li class="item-0">first item</li>
            <li class="item-1"><a href="link2.html">second item</a></li>
            <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
            <li class="item-1 active"><a href="link4.html">fourth item</a></li>
            <li class="item-0"><a href="link4.html">fifth item</a></li>
        
    

### URL 初始化


```python
from pyquery import PyQuery as pq
doc = pq(url='http://www.baidu.com')
print(doc('head'))
print(type(doc('head')))
```

    <head><meta http-equiv="content-type" content="text/html;charset=utf-8"/><meta http-equiv="X-UA-Compatible" content="IE=Edge"/><meta content="always" name="referrer"/><link rel="stylesheet" type="text/css" href="http://s1.bdstatic.com/r/www/cache/bdorz/baidu.min.css"/><title>ç¾åº¦ä¸ä¸ï¼ä½ å°±ç¥é</title></head> 
    <class 'pyquery.pyquery.PyQuery'>
    

### 文件初始化


```python
from pyquery import PyQuery as pq
doc = pa(filename='xxx')
print(doc('li'))
```

## 基本CSS选择器

    如果是类 .
    如果是id #
    如果是标签 就什么也不加
    说白了 和CSS 选择器用法一样 也可以使用后代选择器...
   


```python
html = """
<div id='container'>
    <ul class='list'>
        <li class="item-0">first item</li>
        <li class="item-1"><a href="link2.html">second item</a></li>
        <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
        <li class="item-1 active"><a href="link4.html">fourth item</a></li>
        <li class="item-0"><a href="link4.html">fifth item</a></li>
    </ul>
</div>
"""

from pyquery import PyQuery as pq
doc = pq(html)
print(doc('#container .list li'))
```

    <li class="item-0">first item</li>
            <li class="item-1"><a href="link2.html">second item</a></li>
            <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
            <li class="item-1 active"><a href="link4.html">fourth item</a></li>
            <li class="item-0"><a href="link4.html">fifth item</a></li>
        
    

## 查找元素

### 子元素


```python
html = """
<div id='container'>
    <ul class='list'>
        <li class="item-0">first item</li>
        <li class="item-1"><a href="link2.html">second item</a></li>
        <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
        <li class="item-1 active"><a href="link4.html">fourth item</a></li>
        <li class="item-0"><a href="link4.html">fifth item</a></li>
    </ul>
</div>
"""

from pyquery import PyQuery as pq
doc = pq(html)
items = doc('.list')
print(type(items))
print(items)
lis = items.find('li')
print(type(lis))
print(lis)
```

    <class 'pyquery.pyquery.PyQuery'>
    <ul class="list">
            <li class="item-0">first item</li>
            <li class="item-1"><a href="link2.html">second item</a></li>
            <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
            <li class="item-1 active"><a href="link4.html">fourth item</a></li>
            <li class="item-0"><a href="link4.html">fifth item</a></li>
        </ul>
    
    <class 'pyquery.pyquery.PyQuery'>
    <li class="item-0">first item</li>
            <li class="item-1"><a href="link2.html">second item</a></li>
            <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
            <li class="item-1 active"><a href="link4.html">fourth item</a></li>
            <li class="item-0"><a href="link4.html">fifth item</a></li>
        
    


```python
lis = items.children()
print(type(lis))
print(lis)
```

    <class 'pyquery.pyquery.PyQuery'>
    <li class="item-0">first item</li>
            <li class="item-1"><a href="link2.html">second item</a></li>
            <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
            <li class="item-1 active"><a href="link4.html">fourth item</a></li>
            <li class="item-0"><a href="link4.html">fifth item</a></li>
        
    


```python
lis = items.children('.active')
print(lis)
```

    <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
            <li class="item-1 active"><a href="link4.html">fourth item</a></li>
            
    

### 父元素


```python
html = """
<div id='container'>
    <ul class='list'>
        <li class="item-0">first item</li>
        <li class="item-1"><a href="link2.html">second item</a></li>
        <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
        <li class="item-1 active"><a href="link4.html">fourth item</a></li>
        <li class="item-0"><a href="link4.html">fifth item</a></li>
    </ul>
</div>
"""

from pyquery import PyQuery as pq
doc = pq(html)
items = doc('.list')
container = items.parent()
print(type(container))
print(container)
```

    <class 'pyquery.pyquery.PyQuery'>
    <div id="container">
        <ul class="list">
            <li class="item-0">first item</li>
            <li class="item-1"><a href="link2.html">second item</a></li>
            <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
            <li class="item-1 active"><a href="link4.html">fourth item</a></li>
            <li class="item-0"><a href="link4.html">fifth item</a></li>
        </ul>
    </div>
    


```python
# 查找所有的祖先元素

html = """
<div class='wrap'>
    <div id='container'>
        <ul class='list'>
            <li class="item-0">first item</li>
            <li class="item-1"><a href="link2.html">second item</a></li>
            <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
            <li class="item-1 active"><a href="link4.html">fourth item</a></li>
            <li class="item-0"><a href="link4.html">fifth item</a></li>
        </ul>
    </div>
</div>
"""
from pyquery import PyQuery as pq
doc = pq(html)
items = doc('.list')
parents = items.parents()
print(type(parents))
print(parents)

```

    <class 'pyquery.pyquery.PyQuery'>
    <div class="wrap">
        <div id="container">
            <ul class="list">
                <li class="item-0">first item</li>
                <li class="item-1"><a href="link2.html">second item</a></li>
                <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
                <li class="item-1 active"><a href="link4.html">fourth item</a></li>
                <li class="item-0"><a href="link4.html">fifth item</a></li>
            </ul>
        </div>
    </div><div id="container">
            <ul class="list">
                <li class="item-0">first item</li>
                <li class="item-1"><a href="link2.html">second item</a></li>
                <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
                <li class="item-1 active"><a href="link4.html">fourth item</a></li>
                <li class="item-0"><a href="link4.html">fifth item</a></li>
            </ul>
        </div>
    
    


```python
parent = items.parents('.wrap')
print(parent)
```

    <div class="wrap">
        <div id="container">
            <ul class="list">
                <li class="item-0">first item</li>
                <li class="item-1"><a href="link2.html">second item</a></li>
                <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
                <li class="item-1 active"><a href="link4.html">fourth item</a></li>
                <li class="item-0"><a href="link4.html">fifth item</a></li>
            </ul>
        </div>
    </div>
    

### 兄弟元素


```python
html = """
<div class='wrap'>
    <div id='container'>
        <ul class='list'>
            <li class="item-0">first item</li>
            <li class="item-1"><a href="link2.html">second item</a></li>
            <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
            <li class="item-1 active"><a href="link4.html">fourth item</a></li>
            <li class="item-0"><a href="link4.html">fifth item</a></li>
        </ul>
    </div>
</div>
"""
from pyquery import PyQuery as pq
doc = pq(html)
li = doc('.list .item-0.active')
print(li.siblings())
```

    <li class="item-1"><a href="link2.html">second item</a></li>
                <li class="item-0">first item</li>
                <li class="item-1 active"><a href="link4.html">fourth item</a></li>
                <li class="item-0"><a href="link4.html">fifth item</a></li>
            
    


```python
print(li.siblings('.active'))
```

    <li class="item-1 active"><a href="link4.html">fourth item</a></li>
                
    

## 遍历

### 单个元素


```python
html = """
<div class='wrap'>
    <div id='container'>
        <ul class='list'>
            <li class="item-0">first item</li>
            <li class="item-1"><a href="link2.html">second item</a></li>
            <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
            <li class="item-1 active"><a href="link4.html">fourth item</a></li>
            <li class="item-0"><a href="link4.html">fifth item</a></li>
        </ul>
    </div>
</div>
"""

from pyquery import PyQuery as pq
doc = pq(html)
li = doc('.item-0.active')
print(li)
```

    <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
                
    


```python
html = """
<div class='wrap'>
    <div id='container'>
        <ul class='list'>
            <li class="item-0">first item</li>
            <li class="item-1"><a href="link2.html">second item</a></li>
            <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
            <li class="item-1 active"><a href="link4.html">fourth item</a></li>
            <li class="item-0"><a href="link4.html">fifth item</a></li>
        </ul>
    </div>
</div>
"""
from pyquery import PyQuery as pq
doc = pq(html)
lis = doc('li').items()
print(lis)
print(type(lis))
for li in lis:
    print(li.find('a'))
```

    <generator object PyQuery.items at 0x000001A759D9EBF8>
    <class 'generator'>
    
    <a href="link2.html">second item</a>
    <a href="link3.html"><span class="bold">third item</span></a>
    <a href="link4.html">fourth item</a>
    <a href="link4.html">fifth item</a>
    

## 获取信息

### 获取属性

通过attr('属性名') 或 attr.属性名


```python
html = """
<div class='wrap'>
    <div id='container'>
        <ul class='list'>
            <li class="item-0">first item</li>
            <li class="item-1"><a href="link2.html">second item</a></li>
            <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
            <li class="item-1 active"><a href="link4.html">fourth item</a></li>
            <li class="item-0"><a href="link4.html">fifth item</a></li>
        </ul>
    </div>
</div>
"""

from pyquery import PyQuery as pq
doc = pq(html)
a = doc('.item-0.active a')
print(a)
print(a.attr('href'))
print(a.attr.href)
```

    <a href="link3.html"><span class="bold">third item</span></a>
    link3.html
    link3.html
    

### 获取文本

通过 .text()方法获取文本内容


```python
html = """
<div class='wrap'>
    <div id='container'>
        <ul class='list'>
            <li class="item-0">first item</li>
            <li class="item-1"><a href="link2.html">second item</a></li>
            <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
            <li class="item-1 active"><a href="link4.html">fourth item</a></li>
            <li class="item-0"><a href="link4.html">fifth item</a></li>
        </ul>
    </div>
</div>
"""

from pyquery import PyQuery as pq
doc = pq(html)
a = doc('.item-0.active a')
print(a)
print(a.text())
```

    <a href="link3.html"><span class="bold">third item</span></a>
    third item
    

### 获取HTML

通过.html()方式获取HTML代码


```python
html = """
<div class='wrap'>
    <div id='container'>
        <ul class='list'>
            <li class="item-0">first item</li>
            <li class="item-1"><a href="link2.html">second item</a></li>
            <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
            <li class="item-1 active"><a href="link4.html">fourth item</a></li>
            <li class="item-0"><a href="link4.html">fifth item</a></li>
        </ul>
    </div>
</div>
"""

from pyquery import PyQuery as pq
doc = pq(html)
a = doc('.item-0.active')
print(a)
print(a.html())
```

    <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
                
    <a href="link3.html"><span class="bold">third item</span></a>
    

## DOM操作

### addClass、 removeClass


```python
html = """
<div class='wrap'>
    <div id='container'>
        <ul class='list'>
            <li class="item-0">first item</li>
            <li class="item-1"><a href="link2.html">second item</a></li>
            <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
            <li class="item-1 active"><a href="link4.html">fourth item</a></li>
            <li class="item-0"><a href="link4.html">fifth item</a></li>
        </ul>
    </div>
</div>
"""
from pyquery import PyQuery as pq
doc = pq(html)
li = doc('.item-0.active')
print(li)
li.removeClass('active')
print(li)
li.addClass('acitve')
print(li)
```

    <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
                
    <li class="item-0"><a href="link3.html"><span class="bold">third item</span></a></li>
                
    <li class="item-0 acitve"><a href="link3.html"><span class="bold">third item</span></a></li>
                
    

### attr 、css


```python
html = """
<div class='wrap'>
    <div id='container'>
        <ul class='list'>
            <li class="item-0">first item</li>
            <li class="item-1"><a href="link2.html">second item</a></li>
            <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
            <li class="item-1 active"><a href="link4.html">fourth item</a></li>
            <li class="item-0"><a href="link4.html">fifth item</a></li>
        </ul>
    </div>
</div>
"""

from pyquery import PyQuery as pq
doc = pq(html)
li = doc('.item-0.active')
print(li)
li.attr('name','link')
print(li)
li.css('font-size', '14px')
print(li)
```

    <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
                
    <li class="item-0 active" name="link"><a href="link3.html"><span class="bold">third item</span></a></li>
                
    <li class="item-0 active" name="link" style="font-size: 14px"><a href="link3.html"><span class="bold">third item</span></a></li>
                
    

### remove


```python
html = """
<div class="wrap">
    Hello,World
    <p>This is a paragrap</p>
</div>
"""

from pyquery import PyQuery as pq
doc = pq(html)
wrap = doc('.wrap')
print(wrap.text())
wrap.find('p').remove()
print(wrap.text())
```

    Hello,World
    This is a paragrap
    Hello,World
    

### 伪类选择器


```python
html = """
<div class='wrap'>
    <div id='container'>
        <ul class='list'>
            <li class="item-0">first item</li>
            <li class="item-1"><a href="link2.html">second item</a></li>
            <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
            <li class="item-1 active"><a href="link4.html">fourth item</a></li>
            <li class="item-0"><a href="link4.html">fifth item</a></li>
        </ul>
    </div>
</div>
"""

from pyquery import PyQuery as pq
doc = pq(html)
li = doc('li:first-child')
print(li)
li = doc('li:last-child')
print(li)
li = doc('li:nth-child(2)')
print(li)
li = doc('li:gt(2)')
print(li)
li = doc('li:nth-child(2n)')
print(li)
li = doc('li:contains(second)')
print(li)
```

    <li class="item-0">first item</li>
                
    <li class="item-0"><a href="link4.html">fifth item</a></li>
            
    <li class="item-1"><a href="link2.html">second item</a></li>
                
    <li class="item-1 active"><a href="link4.html">fourth item</a></li>
                <li class="item-0"><a href="link4.html">fifth item</a></li>
            
    <li class="item-1"><a href="link2.html">second item</a></li>
                <li class="item-1 active"><a href="link4.html">fourth item</a></li>
                
    <li class="item-1"><a href="link2.html">second item</a></li>
                
    
