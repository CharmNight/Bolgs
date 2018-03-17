
# Urllib库

## 什么是Urllib库
Python 内置的HTTP请求库
1. urllib.request    请求模块
2. urllib.error     异常处理模块
3. urllib.parse     url解析模块
4. urllib.robotparser robots.txt 解析模块

## Python3 与 Python2的区别
### python2
```python
    import urllib2
    response = urllib2.urlopen('http://www.baidu.com')
```

### python3
```python
    import urllib.request
    response = urllib.request.urlopen('http://www.baidu.com')
```

## urlopen
`urlopen.request.urlopen(url,data=None,[timeout]*,cafile=None,capath=None,cadefault=False,context=None)`

url:请求的url

data： post请求时携带的内容

timeout： 如果超过设置时间认为请求超时


```python
import urllib.request
response = urllib.request.urlopen('http://www.baidu.com')
print(response.read().decode('utf8'))
```



```python
# post请求
from urllib import(parse,
                  request)
data = bytes(urllib.parse.urlencode({'word': 'hello'}), encoding = 'utf8')
response = urllib.request.urlopen('http://httpbin.org/post', data = data)
print(response.read())
```

    b'{\n  "args": {}, \n  "data": "", \n  "files": {}, \n  "form": {\n    "word": "hello"\n  }, \n  "headers": {\n    "Accept-Encoding": "identity", \n    "Connection": "close", \n    "Content-Length": "10", \n    "Content-Type": "application/x-www-form-urlencoded", \n    "Host": "httpbin.org", \n    "User-Agent": "Python-urllib/3.6"\n  }, \n  "json": null, \n  "origin": "223.72.76.48", \n  "url": "http://httpbin.org/post"\n}\n'
​    


```python
# 请求超时
import urllib.request

response = urllib.request.urlopen('http://httpbin.org/get', timeout = 1)
print(response.read())
```

    b'{\n  "args": {}, \n  "headers": {\n    "Accept-Encoding": "identity", \n    "Connection": "close", \n    "Host": "httpbin.org", \n    "User-Agent": "Python-urllib/3.6"\n  }, \n  "origin": "223.72.76.48", \n  "url": "http://httpbin.org/get"\n}\n'
​    


```python
# 请求超时
import urllib.request
import urllib.error
import socket

try:
    response = urllib.request.urlopen('http://httpbin.org/get', timeout = 0.1)
except urllib.error.URLError as e:
    if isinstance(e.reason, socket.timeout):
        print('TIME OUT')
```

    TIME OUT
​    

## 响应

### 响应类型


```python
import urllib.request

response = urllib.request.urlopen('https://www.python.org')
print(type(response))
```

    <class 'http.client.HTTPResponse'>
​    

### 状态码、响应头


```python
import urllib.request

response = urllib.request.urlopen('https://www.python.org')
print(response.status)
print(response.getheaders())
print(response.getheader('Server'))
```

    200
    [('Server', 'nginx'), ('Content-Type', 'text/html; charset=utf-8'), ('X-Frame-Options', 'SAMEORIGIN'), ('x-xss-protection', '1; mode=block'), ('X-Clacks-Overhead', 'GNU Terry Pratchett'), ('Via', '1.1 varnish'), ('Fastly-Debug-Digest', 'a63ab819df3b185a89db37a59e39f0dd85cf8ee71f54bbb42fae41670ae56fd2'), ('Content-Length', '48844'), ('Accept-Ranges', 'bytes'), ('Date', 'Mon, 12 Mar 2018 11:18:08 GMT'), ('Via', '1.1 varnish'), ('Age', '2632'), ('Connection', 'close'), ('X-Served-By', 'cache-iad2129-IAD, cache-lax8633-LAX'), ('X-Cache', 'HIT, HIT'), ('X-Cache-Hits', '3, 28'), ('X-Timer', 'S1520853489.539351,VS0,VE0'), ('Vary', 'Cookie'), ('Strict-Transport-Security', 'max-age=63072000; includeSubDomains')]
    nginx


### 响应体


```python
import urllib.request

response = urllib.request.urlopen('https://www.python.org')
print(response.read().decode('utf8'))
```


​    

## request


```python
from urllib import(request,
                  parse)

url = 'http://httpbin.org/post'
headers = {
    'User-Agent':'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36',
    'Host':'httpbin.org'
}
dict = {
    'name':'CharmNight'
}
data = bytes(parse.urlencode(dict), encoding = 'utf8')
req = request.Request(url = url, data = data, headers = headers, method = 'POST')
response = request.urlopen(req)
print(response.read().decode('utf-8'))
```

    {
      "args": {}, 
      "data": "", 
      "files": {}, 
      "form": {
        "name": "CharmNight"
      }, 
      "headers": {
        "Accept-Encoding": "identity", 
        "Connection": "close", 
        "Content-Length": "15", 
        "Content-Type": "application/x-www-form-urlencoded", 
        "Host": "httpbin.org", 
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36"
      }, 
      "json": null, 
      "origin": "223.72.76.48", 
      "url": "http://httpbin.org/post"
    }

​    


```python
# 另一种实现添加响应头信息的方式 add_header
url = 'http://httpbin.org/post'
dict = {
    'name': 'CharmNight'
}
data = bytes(parse.urlencode(dict), encoding='utf8')
req = request.Request(url = url, data = data, method = 'POST')
req.add_header('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36')
response = request.urlopen(req)
print(response.read().decode('utf-8'))
```

    {
      "args": {}, 
      "data": "", 
      "files": {}, 
      "form": {
        "name": "CharmNight"
      }, 
      "headers": {
        "Accept-Encoding": "identity", 
        "Connection": "close", 
        "Content-Length": "15", 
        "Content-Type": "application/x-www-form-urlencoded", 
        "Host": "httpbin.org", 
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36"
      }, 
      "json": null, 
      "origin": "223.72.76.48", 
      "url": "http://httpbin.org/post"
    }

​    

## Handler

### 代理


```python
import urllib.request

proxy_handler = urllib.request.ProxyHandler({
    'http':'http://127.0.0.1:9743',
    'https':'https://127.0.0.1:9743'
})
opener = urllib.request.build_opener(proxy_handler)
response = opener.open('http://www.baidu.com')
print(response.read())
```




### coikie
爬虫用用于维护登录状态


```python
import http.cookiejar, urllib.request

cookle = http.cookiejar.CookieJar()
handler = urllib.request.HTTPCookieProcessor(cookle)
opener = urllib.request.build_opener(handler)
response = opener.open('http://www.baidu.com')
for item in cookle:
    print(item.name + '=' + item.value)
```

    BAIDUID=DED8158A8024CE166F42512DFB4DED7E:FG=1
    BIDUPSID=DED8158A8024CE166F42512DFB4DED7E
    H_PS_PSSID=1428_21079_22159
    PSTM=1520855940
    BDSVRTM=0
    BD_HOME=0

