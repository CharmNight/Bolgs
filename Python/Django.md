# Django

## 虚拟环境 virtualenv

安装

```
pip install virtualenv
virtualenv testvir
```

安装wrapper

```
pip install virtualenvwrapper-win
```



新建虚拟环境

```
mkvirtualenv testvir2
```



进入虚拟环境

```
workon testvir2（testvir2是虚拟环境的名字）
```



查看所有虚拟环境

```
workon
```



退出虚拟环环境

```
deativate
```



## Django目录结构

progectname:保存django项目的urls(url配置入口),settings(系统配置),wsgi(django启动的清单文件),init文件

templates:放置html文件

manage.py启动文件

————————————以上是pycharm自动生成的文件————————

还需要自己创建一个app文件

Tools-Run manage.py Takes

```
startapp message
```

右键-新建-static 用于存放css js image 文件

右键-新建-log 用于存放日志目录

右键-新建-media 用于存放用户上传文件



## Django配置数据库

在settings中找到DATABADES

```
DATABASES = {
  'default':{
  	'ENGINE':'django.db.backends.mysql',
  	'NAME':"testdjango",#数据库的名字
  	'USER':"root",#数据库名称
  	'PASSWORD':"root",#数据库密码
  	'HOST':"",#数据库的ip地址
	}
}
```

设置Mysql驱动

python2 安装pip install mysql-python

python2 如果有错误 可以参考 blog.csdn.net/u012882134/article/details/51934165

下载后pip安装

python3 安装PyMySQL

安装后再settings中进行导入包

python3中导入

```
import pymysql
pymysql.install_as_MySQLdb()
```

生成数据表

Tools-Run manage.py Takes

没有报错后输入

```
makemigrations

migrate
```



## models

models.ForeignKey外键类型

models.CharField 字符串类型 

​	需要指明 max_length最大长度

​	 设置可以为空  null = True,blank = True

​	设置默认值 default=""

​	如果不指明主键则自动创建一个id主键 自己创建主键  primary_key = True

models.EmalField Emal类型

models.DataTimeField 时间类型

models.IntegerField 整形

models.FileField 上传文件的文件类型

models.IPAddressField IP地址类型

models.ImageField 图片类型



Meta

​	db_table = "user_message" 数据表名称

​	verbose_name = u"用户信息" 设置后台显示的名称

​	verbose_name_plural = verbose_name 设置后台显示名称

​	ordering = "id" 根据id列进行倒序排列

## django 的orm - django models

```
class UserMessage(models.Model):
    name = models.CharField(max_length=20,verbose_name=u"用户名")
    email = models.EmailField(verbose_name=u"邮箱")
    address = models.CharField(max_length=100,verbose_name=u"联系地址")
    message = models.CharField(max_length=500,verbose_name=u"留言信息")

    class Meta:
        verbose_name=u"用户留言信息"
```



在settings 中 添加设置

```
INSTALLED_APPS = [
  ……
  'message',
]
```



如果是python2 在models 中添加编码

python3则不需要



生成数据表

Tools-Run manage.py Takes

```
makemigrations messages
migrate message
```



## 进行增删改查

在views中

objects 是django 内置的管理器



### 查

objects.all()可以拿到数据库中所有的数据

```
from .models import UserMessage
all_message = UserMessage.objects.all() 
for message in all_message:
	print(message.name)
```



objects.filter()可以根据条件判断

```
all_message = UserMessage.objects.filter(name='zhangsan',address='北京')
    for message in all_message:
        print(message.id)
```

all_message = UserMessage.objects.filter(name='zhangsan',address='北京')的意思就是 拿到 name=zhangsan address = 北京的数据

### 增

```
user_message = UserMessage()
    user_message.name = 'lisi'
    user_message.message='helloworld'
    user_message.address='上海'
    user_message.email='2@2.com'
    user_message.save()
```



### 删

```
all_message = UserMessage.objects.filter(name='zhangsan',address='北京')
    # all_message.delete()#删除全部
    for message in all_message:
        message.delete()#删除单条
```





### 数据保存——前后台交互

在html的form表单中添加

```
{% csrf_token %}
```



```
def getform(request):

    if request.method =="POST":#用于判断是否是POST请求
        name = request.POST.get('name','')#get是用于取字典中的值这里的name 是在html页面中表单的name值
        message = request.POST.get('message','')
        address = request.POST.get('address','')
        email = request.POST.get('email','')
        user_message = UserMessage()
        user_message.name = name
        user_message.message=message
        user_message.address=address
        user_message.email=email
        user_message.save()
    return render(request,'form.html')
```

