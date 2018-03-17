# Requests库

Requests库是基于urllib库的基础上创建出来的，相对更加方便。

## 安装Requests库

```
    pip install requests

```

## 引入实例


```python
import requests

response = requests.get('https://www.baidu.com/')

print(type(response))
print(response.status_code)
print(type(response.text))
# print(response.text)
print(response.cookies)
```


## 各种请求方式


```python
import requests

requests.post('http://httpbin.org/post')
requests.put('http://httpbin.org/put')
requests.delete('http://httpbin.org/delete')
requests.head('http://httpbin.org/get')
requests.options('http://httpbin.org/get')
```
```
<Response [200]>
```

## 请求

### 基本GET请求

#### 基本写法


```python
import requests

response = requests.get('http://httpbin.org/get')

print(response.text)
```


#### 带参数的GET请求


```python
import requests
response = requests.get('http://httpbin.org/get?name=CharmNight&age=20')
print(response.text)
```


```python
import requests
data = {
    'name': 'CharmNight',
    'age': 20
}
response = requests.get('http://httpbin.org/get', params=data)
print(response.text)
```


### 解析json


```python
import requests
response = requests.get('http://httpbin.org/get')
print(type(response.text))
print(response.json())
print(type(response.json()))
```


### 获取二进制数据

（下载图片、音频等文件）

content获取的是二进制内容 也就是说 如果是图片之类的 requests.get()后直接获取content就可以 open文件写入了


```python
import requests

response = requests.get('https://github.com/favicon.ico')
print(type(response.text), type(response.content))

# print(response.text)
# print(response.content)
```


```python
import requests

response = requests.get('https://github.com/favicon.ico')
with open(r'E:/favicon.ico', 'wb') as f:
    f.write(response.content)
    f.close()
print('ok')
```

```
ok

```

### 添加headers

**这个挺重要的：**

```
例如我们爬去知乎：如果没有添加任何headers时，直接返回500服务器错误
写爬虫时，要经常使用headers

```

User-Agent: 用户代理—一般是操作系统及版本、CPU、浏览器及版本、浏览器渲染引擎……

Cookie： 维护用户的登录状态


```python
import requests
response = requests.get('https://www.zhihu.com/explore')
print(response.text)
```


```python
import requests
headers = {
    'User-Agent':'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36',
}
response = requests.get('https://www.zhihu.com/explore', headers=headers)

print(response.text)
```


## 基本的POST请求


```python
import requests
data = {'name':'CharmNight',
       'age':20}
response = requests.post('http://httpbin.org/post', data=data)
print(response.text)
```

### 添加headers 的post请求

```python
import requests

data = {'name':'CharmNight',
       'age':20}

headers = {
    'User-Agent':'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36'
}

response = requests.post('http://httpbin.org/post',data=data, headers=headers)

print(response.json())
```



## 响应

### reponse属性



```python
import requests

response = requests.get('http://www.jianshu.com')
print(type(response.status_code), response.status_code)
print(type(response.headers), response.headers)
print(type(response.cookies), response.cookies)
print(type(response.url), response.url)
print(type(response.history), response.history)
```


## 状态码判断

```python
import requests
response = requests.get('http://www.jianshu.com')
exit()if not response.status_code == requests.codes.ok else print('Requests Successfully')
```

```
100:('continue')
101:('switching_protocols')

```

## 高级操作

### 文件上传


```python
import requests
files = {'file': open(r'E:/favicon.ico', 'rb')}
response = requests.post('http://httpbin.org/post', files=files)
print(response.text)
```

### 获取Cookie


```python
import requests
response = requests.get('https://www.baidu.com')

print(response.cookies)
for key, value in response.cookies.items():
    print(f'{key} = {value}')
```


### 会话维持

#### 模拟登录


```python
import requests

requests.get('http://httpbin.org/cookies/set/number/12345')
response = requests.get('http://httpbin.org/cookies')
print(response.text)

# 这里的结果为空， 原因是因为 我们发起了两次毫无关系的请求。相当于开启了两个浏览器来请求这个网址
```


```python
import requests

s = requests.Session()
s.get('http://httpbin.org/cookies/set/number/12345')
response = s.get('http://httpbin.org/cookies')

print(response.text)
```


### 证书验证




如果我们访问一个https 的页面但是它的证书是错误的 我们就会异常错误
通过verify 属性可以跳过证书验证


```python
import requests

response = requests.get('https://www.12306.cn')

print(response.status_code)
```


```python
import requests

# 这两句是为了消除 没有证书验证的警告信息

# from requests.packages import urllib3
# urllib3.disable_warnings()

response = requests.get('https://www.12306.cn', verify=False)
print(response.status_code)
```

```
200

```



### 如果有证书 则 可以 通过cert方法手动指定一个证书


```python
import requests

response = requests.get('https://www.12306.cn', cert=('/path/server.crt', '/path/key'))

print(response.status_code)
```



### 代理设置

```python
import requests

proxies = {
    'http':'本地代理'
}

response = requests.get('http://www.baidu.com', proxies=proxies)
print(response.status_code)
```

### 超时设置


```python
import requests
from requests.exceptions import ReadTimeout

try:

    response = requests.get('https://taobao.com', timeout = 1)
    print(response.status_code)

except ReadTimeout:
    print('time out')


```
200


### 认证设置


```python
  import requests
  from requests.auth import HTTPBasicAuth
  r = requests.get('', auto=HTTPBasicAuth('username', 'password'))
```



```python
import requests
r = requests.get('', auto=('username', 'password'))
```