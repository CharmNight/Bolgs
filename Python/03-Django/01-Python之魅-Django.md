# django 

## 表单验证



## model(数据库操作)

#### 1    django默认支持sqlite，mysql, oracle,postgresql数据库。

​    ** <1> sqlite**

​            django默认使用sqlite的数据库，默认自带sqlite的数据库驱动 , 引擎名称：django.db.backends.sqlite3

​     **<2> mysql**

​            引擎名称：django.db.backends.mysql

#### 2    mysql驱动程序

-    MySQLdb(mysql python)
-    mysqlclient
-    MySQL
-    PyMySQL(纯python的mysql驱动程序)

#### 3     在django的项目中会默认使用sqlite数据库，在settings里有如下设置：

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}
```

```python
DATABASES = {

    'default': {

        'ENGINE': 'django.db.backends.mysql', 

        'NAME': 'books',    #你的数据库名称

        'USER': 'root',   #你的数据库用户名

        'PASSWORD': '', #你的数据库密码

        'HOST': '', #你的数据库主机，留空默认为localhost

        'PORT': '3306', #你的数据库端口

    }
```



### orm（对象关系映射）

orm 就是说 python中的模型（类） 映射 到原生的sql语句

#### .query 方法查询orm对应的sql语句

```
 print(models.Purte.objects.filter(book__title__startswith='d').values('name').query)
```



#### 单表

##### 增

###### save方法

```python
#save方式添加
user_message = UserInfo()
    user_message.username = 'lisi'
    user_message.age=18
    user_message.user_type=1
    user_message.save()
```



###### create方法

```python

#字典方式添加
dic = {'username':'mosson','age':18,'user_type_id':1}
models.UserInfo.objects.create(**dic)

#先获取组的对象
usertype = models.UserType.objects.fiter(id=2)
#添加的时候直接添加对象就可以
models.UserInfo.objects.create(username='seven',age=18,user_type=usertype)
 
#写成一行也行
models.UserInfo.objects.create(username='lile',age=18,user_type=models.UserType.objects.filter(id=1))
```



##### 删

```python
models.UserInfo.object.filter(id=1).delete()
```

##### 改

###### update

```python
models.UserInfo.objects.filter(id__gt=0).update(username='admin')
```

###### save

```python
user = models.UserInfo.objects.get(id=2)
    user.username='root3'
    user.save()

    user = models.UserInfo.objects.filter(id=1)[0]
    user.username='root2'
    user.save()
```

###### 注意

update 是QuerySet对象的方法

##### 查

```python
models.UserInfo.objects.all() #返回一个QuerySet集合对象
models.UserInfo.objects.filter()#返回一个QuerySet集合对象
models.UserInfo.objects.get()#返回一个行对象
user = models.UserInfo.objects.filter(id=1).values('username') #等同于‘select username form UserInfo’返回<QuerySet [{'user': 'admin'}]>

user = models.UserInfo.objects.all().order_by('id')#根据id排序
models.UserInfo.objects.all().order_by('-id')#根据id逆向排序

user = models.UserInfo.objects.values('username').distinct()# 去重
```

#### 一对一（oneToOne）

就是在一对多的基础上 将多的那一个设置唯一：author=True



#### 一对多（Foreignkey） 

 Object Relational Mapping(关系对象映射)

```python
class UserType(models.Model):
	caption = models.CharField(max_length=32)

class UserInfo(models.Model):
	username = models.CharField(max_length=32)
	age = models.IntegerField()
	user_type = models.Foreignkey('UserType')#外键
```

正向查找：ForeignKey在UserInfo表中，如果从UserInfo表开始想其他表查询，这个就是正向查找，反之就是反向查找

##### 增

###### create

```
#方式一
models.UserInfo.objects.create(username='lisi',age=18,user_type_id=1)
#方式二
models.UserInfo.objects.create(username='lisi',age=18,user_type=obj)
```



#### 多对多（ManyToMany）



##### 系统生产成第三张表

```python
class Book(models.Model):
    title = models.CharField(max_length=64)
    price = models.IntegerField()
    color = models.CharField(max_length=64)
    page_nub = models.IntegerField()
    author = models.ManyToManyField('Author')

    def __str__(self):
        return self.title


class Author(models.Model):
    name = models.CharField(max_length=64)

    def __str__(self):
        return self.name
```



##### 绑定add

###### 正向查找

```python
    author1 = models.Author.objects.get(id=1)
    author2 = models.Author.objects.get(id=2)
    books = models.Book.objects.get(id=1)
    books.author.add(author1,author2)
```

###### 反向查找

```python
author = models.Author.objects.get(id=1)
books = models.Book.objects.get(id__gt=1)
author.book_set。add(*books)
```



##### 移除remove

```python
	author1 = models.Author.objects.get(id=1)
    author2 = models.Author.objects.get(id=2)
    books = models.Book.objects.get(id=1)
   
    books.author.remove(author1,author2)
```





##### 自定义第三张表

```python
class Book(models.Model):
    title = models.CharField(max_length=64)
    price = models.IntegerField()
    color = models.CharField(max_length=64)
    page_nub = models.IntegerField()
    # author = models.ManyToManyField('Author')

    def __str__(self):
        return self.title


class Author(models.Model):
    name = models.CharField(max_length=64)

    def __str__(self):
        return self.name

class Boot2Author(models.Model):
    book = models.ForeignKey(to='Book')
    author = models.ForeignKey(to='Author')

    class Meta:
        unique_together=['book','author']
```



###### 增

```
  	author1 = models.Author.objects.get(id=1)
    books = models.Book.objects.get(id=1)
    models.Boot2Author.objects.create(book=books,author=author1)
```

###### 删——级联删除

```
models.Book.objects.filter(id=1).delete()
这时Book表中id等于1的行被删掉并且，Book2Author表中含有Book_id = 1的行也会被删掉
```



#### 了不起的双下划线

##### 单表查询

```
id__gt 大于1
models.Book.objects.filter(id__gt=1):

id__lt 小于3
models.Book.objects.filter(id__lt=3):

id__in id在[1,2,3]中的行查询到   在某个范围
models.Book.objects.filter(id__in=[1,2,3]):

__contatins 包含某些字段
models.Book.objects.filter(title__contains='c'):

__icontatins 不区分大小写
models.Book.objects.filter(title__icontains='c'):

__startswith 以什么开头
models.Book.objects.filter(title__startswith='d')


```

##### 关联查询

```
models.Purte.objects.filter(book__title__startswith='d').values('name')

自定义表的多对多关联查询
models.Author.objects.filter(id__gt=1).values('boot2author__book__title')
```

#### 聚合查询和分组查询

##### aggregate(*args,**kwagrs)

通过对QuerySet进行计算，返回一个聚合值的字典。aggregate()中每一个参数都指定一个包含在字典中返回值。即在查询集合上生成聚合

```
from django.db.models import Avg,Min,Sum,Max
a = models.Book.objects.all().aggregate(Avg('price')) #求平均值
print(a)
b = models.Book.objects.all().aggregate(Min('price')) #求最小值
print(b)
c = models.Book.objects.all().aggregate(Sum('price')) #求和
print(c)
d = models.Book.objects.all().aggregate(Max('price')) #求最大值
print(d)
```

##### annotate

可以通过计算查询结果中的每一个对象所关联的对象集合，从而得出总计值（也可以是平均值或总和），即为查询集的每一项生成聚合

```
a = models.Book.objects.values('puter__name').annotate(Sum('price'))
#根据puter表中的name字段分组 并计算price的和
print(a)
```

#### F查询和Q查询

##### F查询

```
from django.db.models import F
#将Book表中的price列的值加 10
models.Book.objects.all().update(price=F("price")+10)
```



##### Q查询

```
#在Book表中查询id=2 或 title='C'的数据
models.Book.objects.filter(Q(id=2) | Q(title='C'))

#在Book表中查询id大于2 并且 color='as'的数据
models.Book.objects.filter(Q(id__gt=2)&(Q(color='as')))

#同时也支持嵌套使用
models.Book.objects.filter(Q(id__gt=2)&(Q(color='as') | Q(title='C')))

#~代表非
models.Book.objects.filter( ~Q(color='as'))
```

## admin

```
python manage.py createsuperuser
```

#### 汉化

```
settings 设置
LANGUAGE_CODE = 'zh-Hans'
TIME_ZONE = 'Asia/Shanghai'
```

#### models.py

```
verbose_name='' #在admin页面显示的列名
editable=False 该数据不可更改

```

#### admin.py

```
list_display('title','price')#在admin页面显示的的列
search_fields=('title',) # 添加一个搜索框 根据'title'进行搜索
list_fields('title',) #添加一个过滤器 ，根据'title'进行过滤

```

#### 使用

```

```



## views

### render

​	locals()将所有的值都传递到前端，前端可以直接通过变量名调用

### HttpResponse



### redirect

重定向

## url

```python
url(r'^index/', views.indexinfo),		#基础
url(r'^index/$', views.indexinfo),		#以index/结尾的url
url(r'^index\d+',views.indexinfo),	#含有正则的url。
url(r'^index(\d+)',views.indexinfo),	#含有正则的url。对应函数应添加参数

有名url
url(r'^index(?P<id>\d+)',views.indexinfo),	#含有正则的url。对应函数应添加参数名为id

url(r'^index', views.indexinfo,{'id':'123'}), #对应函数应添加参数名为id并且值为123

url(r'^index', views.indexinfo,name='ide'), #name设置的是url路径的别名
```



## 

## 模板

### 模板语言

#### 什么是模板语言？

​	html+逻辑控制语句

#### Template和Context

在终端：python manage.py shell 进入django 环境

```
>>> from django.template import Context,Template
>>> t = Template('My name is {{name}}')
>>> c= Context({'name':'kkk'})
>>> t.render(c)
'My name is kkk'

```

简而言之就是{{ 变量 }} 嵌套在html中 变量可以直接从后端获取

#### 深度变量的查找-->   万能的句点号.

```python
最好是用几个例子来说明一下。
# 首先，句点可用于访问列表索引，例如：

>>> from django.template import Template, Context
>>> t = Template('Item 2 is {{ items.2 }}.')
>>> c = Context({'items': ['apples', 'bananas', 'carrots']})
>>> t.render(c)
'Item 2 is carrots.'

#假设你要向模板传递一个 Python 字典。 要通过字典键访问该字典的值，可使用一个句点：
>>> from django.template import Template, Context
>>> person = {'name': 'Sally', 'age': '43'}
>>> t = Template('{{ person.name }} is {{ person.age }} years old.')
>>> c = Context({'person': person})
>>> t.render(c)
'Sally is 43 years old.'

#同样，也可以通过句点来访问对象的属性。 比方说， Python 的 datetime.date 对象有
#year 、 month 和 day 几个属性，你同样可以在模板中使用句点来访问这些属性：

>>> from django.template import Template, Context
>>> import datetime
>>> d = datetime.date(1993, 5, 2)
>>> d.year
1993
>>> d.month
5
>>> d.day
2
>>> t = Template('The month is {{ date.month }} and the year is {{ date.year }}.')
>>> c = Context({'date': d})
>>> t.render(c)
'The month is 5 and the year is 1993.'

# 这个例子使用了一个自定义的类，演示了通过实例变量加一点(dots)来访问它的属性，这个方法适
# 用于任意的对象。
>>> from django.template import Template, Context
>>> class Person(object):
...     def __init__(self, first_name, last_name):
...         self.first_name, self.last_name = first_name, last_name
>>> t = Template('Hello, {{ person.first_name }} {{ person.last_name }}.')
>>> c = Context({'person': Person('John', 'Smith')})
>>> t.render(c)
'Hello, John Smith.'

# 点语法也可以用来引用对象的方法。 例如，每个 Python 字符串都有 upper() 和 isdigit()
# 方法，你在模板中可以使用同样的句点语法来调用它们：
>>> from django.template import Template, Context
>>> t = Template('{{ var }} -- {{ var.upper }} -- {{ var.isdigit }}')
>>> t.render(Context({'var': 'hello'}))
'hello -- HELLO -- False'
>>> t.render(Context({'var': '123'}))
'123 -- 123 -- True'

# 注意这里调用方法时并* 没有* 使用圆括号 而且也无法给该方法传递参数；你只能调用不需参数的
# 方法。
```



####  if

if只能判断true 或 false 的值 不能进行复杂判断

```
{% if 1 %}

{% elif False %}

{% endif %}
```



#### for

```
{% for i in obj%}
	#这里拿到的是值不是索引
{% endfor %}
```

```
    li=[1,2,3]
    {% for foo in li %}
        {{ forloop.counter }}
    {% endfor %}
    <hr>
    {% for foo in li %}
        {{ forloop.counter0 }}
    {% endfor %}
    <hr>
    {% for foo in li %}
        {{ forloop.revcounter }}
    {% endfor %}
    
    -----------------------------------------------
    1 2 3
	0 1 2
	3 2 1	
```

### filter & simple_tag

#### filter 过滤器

```
str='helloWord'
{{ str | upper }} 大写
<hr>
{{ str | lower }}  小写
<hr>
{{ str | first | upper }} 第一个字符大写
<hr>	
{{ str | capfirst }}	首字母大写

-----------------------------------------
HELLOWORD
helloword
H
HelloWord
```



add:给变量加上相应的值

addslashes:给变量中的引号前加上斜线

copfirst：首字母大写

cut：从字符串中移除指定的字符

date：格式化日期字符串

defoult：如果值是False就替换成设置的默认值，否则用本来的值



```
add=5
{{obj|add:5}}

value2='hel l o wor ld'
{{value2|cut:' '}}

value3=datetime.datetime.now()
{{value3|date:'y-m-d'}}

value=[]
{{ value|default:'空的' }}
-----------------------------------
11
hellowrod
2017-10-18
空的
```

```
s1 = "<a href='#'>OK</a>"
{% autoescape off %}
    {{ s1 }}
{% endautoescape %}
直接将标签进行渲染

{{s1|safe}}
作用同上
```



#### 自定义filter



- 在app下创建一个目录叫（templatetags）

- 在文件夹下创建任意名称py文件

  ```python
  aaa.py

  from django import template
  from django.utils.safestring import mark_safe

  register = template.Library()

  @register.filter
  def add_nub(a1, a2):
      return a1 + a2
  ```


- 在settings文件中注册app

- 在引用html**顶部**添加{% load py文件名%}

- 使用{{参数1|函数名:参数2}}

  ```html
  demo.html

  {% load aaa %}
  <!DOCTYPE html>
  <html lang="en">
  <head>
      <meta charset="UTF-8">
      <title>Title</title>
  </head>
  <body>
      {{ 'asd'|add_str:'zxc' }}
  </body>
  </html>
  ```



#### 自定义simple_tag 

- 在app下创建一个目录叫（templatetags）

- 在文件夹下创建任意名称py文件

  ```python
  aaa.py

  from django import template
  from django.utils.safestring import mark_safe

  register = template.Library()

  @register.simple_tag
  def add_nub(a1, a2):
      return a1 + a2
  ```



- 在settings文件中注册app

- 在引用html**顶部**添加{% load py文件名%}

- 使用{% 函数名 参数1 参数2 ……%}

  ```html
  demo.html

  {% load aaa %}
  <!DOCTYPE html>
  <html lang="en">
  <head>
      <meta charset="UTF-8">
      <title>Title</title>
  </head>
  <body>
      {% add_nub 1 2 %}
  </body>
  </html>

  ```



#### filter 与 simple_tag 的比较：

- filter参数最多只能有2个，并且参数传递有明确要求 {{参数一|add_str:参数二 }} 不可以加空格

  （filter如果想加入多个参数，可以传递一个列表然后再内部进行处理）

- simple_tag参数可以有无数个

- filter 可以直接作为if 判断的条件

- simple_tag不可以嵌套在if中


#### filter 和 if 语句在模板语言中的应用

##### filter_demo.html

```html
{% load my_tag %}

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
    <form action="/bloge/filter_demo/" method="post">
        {% csrf_token %}
        <input type="text" name="n1">
        <input type="text" name="n2">
        <input type="submit" value="ok">
    </form>

{% if n1 and n2 %}
    {% if n1|add_num:n2 > 100 %}
        <p>{{ n1 }}+{{ n2 }} = {{ n1|add_num:n2 }} 大于100</p>
    {% elif n1|add_num:n2 == 100 %}
        <p>{{ n1 }}+{{ n2 }} = {{ n1|add_num:n2 }}等于100</p>
    {% else%}
        <p>{{ n1 }}+{{ n2 }} = {{ n1|add_num:n2 }}小于100</p>
    {% endif %}
{% endif %}

</body>
</html>
```

##### my_tag.py

```
from django import template


register = template.Library()

@register.filter
def add_num(nub1, nub2):
    return int(nub1) + int(nub2)
```

##### view

```
def filter_demo(request):
    if request.method == 'POST':
        n1 = request.POST.get('n1',None)
        n2 = request.POST.get('n2',None)
        print(n1,n2)
        return render(request, 'filter_demo.html', locals())
    elif request.method == 'GET':
        return render(request, 'filter_demo.html')
```

### 模板的继承

#### base.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <style type="text/css">
        .page-header{
            height:50px;
            background-color: rebeccapurple;
        }
        .page-body .menu{
            height:500px;
            background-color: antiquewhite;
            float: left;
            width:20%;
        }
        .page-body .menu a{
            display: inline-block;
            width: 100%;
            float: left;
        }
        .page-body .content{
            height:500px;
            background-color: #92d1f4;
            float: left;
            width: 80%;
        }
        .page-footer{
            height:30px;
            background-color: #666666;
            clear: both;
        }
    </style>
</head>
<body>
    <div>
        <div class="page-header">

        </div>
        <div class="page-body">
            <div class="menu">
                <a href="/bloge/ordered/">订单</a>
                <a href="/bloge/shopping_car/">购物车</a>
            </div>
                <div class="content">
                    {% block content %}
                    What Happtend
                    {% endblock %}
                </div>
        </div>
        <div class="page-footer"></div>
    </div>
</body>
</html>
```

#### ordered.html

```html

{% extends 'base.html' %}


{% block content %}
    {{ block.super }}
    <div>
        订单
    </div>
{% endblock %}

```

#### shopping_car.html

```html
{% extends 'base.html'%}

{% block content %}
        购物车
{% endblock %}
```



#### 敲黑板

- 如果在模板中使用{% extends %},必须保证其为模板中的第一个模板标记。否则，模板继承将不起作用。
- 一般来说，基础模板中的{% block %}标签越多越好。记住，字模板不必定衣父模板中所有的代码块，因此你可以用合理的缺省对一些代码块进行填充，然后只对子模板所需的代码块进行（重）定义。俗话说，钩子越多越好
- 如果发觉自己在多个模板之间拷贝代码，你应该考虑将该代码段放置到父模板的某个{% block %}中。
- 如果你需要访问父模板中的块的内容，使用{{ block.super}}这个标签，这一个模板变量将会表现出父模板中的内容。如果只想在上级代码块基础上添加内容，而不是全部重载，该变量就显得非常有用了。
- 不允许在同一个模板中定义多个同名的{% block %}，存在这样的限制是因为block标签的工作方式是双向的。也就是说，block标签不仅挖了一个要填的坑，也定义了在父模板中这个坑所填充的内容。如果模板中出现了两个相同名称的{% block %}标签，父模板将无从得知要使用哪个块的内容

## 自定义翻页

### 封装

```python
utils -py

from django.utils.safestring import mark_safe
class Page(object):

    def __init__(self,current_tage, data_count, per_page_count=10, page_num=7):
        '''
        :param current_tage:    当前页面
        :param data_count:      数据总数
        :param per_page_count:  每页显示条目数
        :param page_num:        a标签显示数目
        '''
        self.current_tage = current_tage
        self.data_count = data_count
        self.per_page_count = per_page_count
        self.page_num = page_num

    def start(self):
        return (self.current_tage - 1) * self.per_page_count

    def end(self):
        return self.current_tage * self.per_page_count

    def total_count(self,base_href):

        count, y = divmod(self.data_count, self.per_page_count)  # divmod是求余 count是商 y是余数
        str_list = []
        if y:
            count += 1

        if count < self.per_page_count:
            start_index = 1
            end_index = count + 1
        else:
            if self.current_tage <= int((self.per_page_count - 1) / 2):
                start_index = 1
                end_index = self.per_page_count + 1
            elif (self.current_tage + int((self.per_page_count - 1) / 2)) > count:
                start_index = self.current_tage - (self.per_page_count - (count - self.current_tage + 1))
                end_index = count + 1
            else:
                start_index = self.current_tage - int((self.per_page_count - 1) / 2)
                end_index = self.current_tage + int((self.per_page_count) / 2)
        # 构建a标签进行跳转
        if self.current_tage != 1:
            a_prve = '<a class = "page" href="%s?p=%s">上一页</a>' % (base_href, self.current_tage - 1)
            str_list.append(a_prve)
        for i in range(start_index, end_index):
            if i == self.current_tage:
                str_show = '<a class = "page active" href="%s?p=%s">%s</a>' % (base_href, i, i)
            else:
                str_show = '<a class = "page" href="%s?p=%s">%s</a>' % (base_href, i, i)
            str_list.append(str_show)
        if self.current_tage != count:
            a_next = '<a class = "page" href="%s?p=%s">下一页</a>' % (base_href, self.current_tage + 1)
            str_list.append(a_next)
        page_str = ''.join(str_list)
        page_str = mark_safe(page_str)
        return page_str
```

### 调用

```python
   # 模拟数据
    LI = []
    for i in range(1000):
        LI.append(i)

    from utils import pagination #导入 
    
     # 获取url中的页数，并构建每页显示10条数据
    page_index = 11
    page_item_count = 10

   
    current_page = request.GET.get('p', 1)
    current_page = int(current_page)
    p = pagination.Page(current_page, len(LI))

    show_tag = LI[p.start():p.end()]

    page_str = p.total_count('/cmdb/demo1/')

    return render(request, 'demo1.html',{'li':show_tag, 'a_list':page_str})
```

## 



## session and cookie





## 中间件

### csrf

 用于生成csrf_token的标签，用于防治跨站攻击验证。注意如果你在view的index里用的是render_to_response方法，不会生效

在form中

```html
{% csrf_token%}
```

在ajax中

```javascript
$.ajax(
{
  url:'/login/',
  type:'"'POST',
  headers:{'X-CSRFtoken':$.cookie('csrftoken')},	//传递csrf字符串
  data:{'username':root, 'pwd':123},
  succsess:function(data){
  ````
	}
})


方法二：在本页面中所有ajax执行之前进行设置
$.ajaxSetup({
  beforeSend:function(xhr,settings){
  	xhr.setRequestHeader('X-CSRFtoken', $.cookie('csrftoken')),
}
})
```



## 请求的生命周期



## 信号



## 缓存



## Form组件



## ModelForm



## Json



## ajax

Asynchronous JavaScript And XML（ 异步Javascript 和XML）

### 基础理论

#### 特点

- 局部刷新页面
- 异步交互

#### 优点

- Ajax使用Javascript技术向服务器发送异步请求
- Ajax无需刷新整个页面
- 因为服务器内容不再是整个页面，而是页面中的局部，所以Ajax性能高

#### 缺点

- Ajax并不适用与所有场景，很多时候还是要使用同步交互
- Ajax虽然提高了用户体验，但是无形中向服务器发送的请求次数增多，导致服务器压力增大
- 因为Ajax是在浏览器中使用Javascript技术完成的，所以还需要处理浏览器兼容性问题



#### 操作步骤

- 创建核心对象
- 使用核心对象打开与服务器的连接
- 发送请求
- 注册监听，监听服务器响应

### 原生ajax

#### XMLHTTPRequest

- open(请求方式，URL，是否异步)
- send(请求体)
- onreadystatechange指定监听函数，他会在xmlHttp对象状态发生变化时被调用
- readyState当前xmlHttp对象的状态，其中4状态表示服务器响应结束
- status服务器响应的状态码，只有当服务器响应结束后才有
- responseTest获取服务器的响应体



1. var = xmlhttp = XMLHttprequest()
2. xmlhttp.open('')
3. xmlhttp.send('name=axel') #请求体的内容  如果是GET请求：xmlhttp.send(null)
4. 监听 xmlhttp(if == 4){xmlhttp.responetext}

#### 练习

##### GET请求

urls.py

```python
    url(r'^index/', views.index),
    url(r'^ajax_receive/', views.ajax_receive),
```

views.py

```python
def index(request):

    return render(request,'ajax_index.html')


def ajax_receive(request):

    return HttpResponse('----OK')
```

html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
    <button onclick="func1()" name="ajax">ajax</button>
<script>
    function createXMLHttpRequest() {
        var xmlHttp;
        // 适用于大多数浏览器，以及IE7和IE更高版本
        try{
            xmlHttp = new XMLHttpRequest();
        } catch (e) {
            // 适用于IE6
            try {
                xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
            } catch (e) {
                // 适用于IE5.5，以及IE更早版本
                try{
                    xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
                } catch (e){}
            }
        }
        return xmlHttp;
    }
    function func1() {
        var xmlHttp = createXMLHttpRequest();
        xmlHttp.open('GET','/demo/ajax_receive/',true);
        xmlHttp.send(null);
        xmlHttp.onreadystatechange=function(){
{#            alert(xmlHttp.status)#}
{#            alert(xmlHttp.readyState)#}
            if (xmlHttp.readyState == 4 && xmlHttp.status == 200){
                var data = xmlHttp.responseText;
                alert(data)
            }
        };
    }
</script>
</body>
</html>
```

##### POST请求
urls.py

```python
    url(r'^index/', views.index),
    url(r'^ajax_receive/', views.ajax_receive),
```

views.py

```python
def index(request):

    return render(request,'ajax_index.html')


def ajax_receive(request):

    return HttpResponse('----OK')
```

html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
    <button onclick="func1()" name="ajax">ajax</button>

<script>
    function createXMLHttpRequest() {
        var xmlHttp;
        // 适用于大多数浏览器，以及IE7和IE更高版本
        try{
            xmlHttp = new XMLHttpRequest();
        } catch (e) {
            // 适用于IE6
            try {
                xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
            } catch (e) {
                // 适用于IE5.5，以及IE更早版本
                try{
                    xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
                } catch (e){}
            }
        }
        return xmlHttp;
    }


    function func1() {
        var xmlHttp = createXMLHttpRequest();
        xmlHttp.open('POST','/demo/ajax_receive/',true);
        xmlHttp.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
        xmlHttp.send('name=lisi');
        xmlHttp.onreadystatechange=function(){
            if (xmlHttp.readyState == 4 && xmlHttp.status == 200){
                var data = xmlHttp.responseText;
                alert(data)
            }
        };
    }
</script>
</body>
</html>
```

##### 模拟注册中使用ajax

urls.py

```python
    url(r'^index/', views.index),
    url(r'^ajax_receive/', views.ajax_receive),
```

views.py

```python
def index(request):

    return render(request,'ajax_index.html')


def ajax_receive(request):

  if request.method == 'POST':
    # print(request.POST)
    user = request.POST.get('users')
    print(user)
    if user == 'root':
      return HttpResponse('1')
    else:
      print(request.POST)
      return HttpResponse('0')
    return render(request,'ajax_index.html')
```

html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
    <button onclick="func1()" name="ajax">ajax</button>
    <form>
        <p>用户名<input type="text" name="user" onblur="func2(this)"><span id="error1"></span></p>
        <p>密码<input type="text" name="pwd" ><span></span></p>
        <p><input type="submit" value="提交"></p>
    </form>

<script>
    function createXMLHttpRequest() {
        var xmlHttp;
        // 适用于大多数浏览器，以及IE7和IE更高版本
        try{
            xmlHttp = new XMLHttpRequest();
        } catch (e) {
            // 适用于IE6
            try {
                xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
            } catch (e) {
                // 适用于IE5.5，以及IE更早版本
                try{
                    xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
                } catch (e){}
            }
        }
        return xmlHttp;
    }

    function func2(self) {
        var user = self.value;
        var xmlhttp = createXMLHttpRequest();
        xmlhttp.open('POST','/demo/ajax_receive/',true);
        xmlhttp.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
        xmlhttp.send('users='+ user);
        xmlhttp.onreadystatechange=function () {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200){
                var data = xmlhttp.responseText;
                alert(data)
                if (data == 1){
                    document.getElementById('error1').innerText=''
                }else {
                    document.getElementById('error1').innerText=('该用户名存在')

                }
            }

        }
    }

</script>
</body>
</html>
```



### jquery中的ajax

#### $.get()

```
$.get(url, [data], [callback], [type])  
//url路径 data数据 callback：回调函数 type: text|html|json|script   
**含有[]是可填可不填**
```

html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<button onclick="func1()">ajax提交</button>

<script type="text/javascript" src="/static/jq/jquery-3.2.1.min.js"></script>
<script>
    function func1() {
        Test()
    }

    function Test() {
        $.get('/demo/ajax_jq/',{name:'asd'})
    }
</script>
</body>
</html>
```

views.py

```python
def ajax_jq(request):
    print(request.GET)
    return render(request,'ajax_jq.html')
```

#### $.post()

```
$.post(url, [data], [callback], [type]) 
//url路径 data数据 callback：回调函数 type: text|html|json|script
**含有[]是可填可不填**
```

#### $.ajax()

### 伪ajax（iframe）

## 

## 同源策略



## JsonP



## 文件上传



## xss攻击防护