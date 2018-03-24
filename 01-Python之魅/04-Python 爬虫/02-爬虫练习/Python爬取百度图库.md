# Python爬取百度图库





## 页面分析

通过Chrome 的开发者模式，我们可以很发现 百度图库是通过ajax 加载图片的。 每一次都会发送一个请求：`https://image.baidu.com/search/acjson?tn=resultjson_com&ipn=rj&ct=201326592&is=&fp=result&queryWord=%E6%BC%86%E9%BB%91%E7%9A%84%E5%AD%90%E5%BC%B9%E5%A3%81%E7%BA%B8&cl=2&lm=-1&ie=utf-8&oe=utf-8&adpicid=&st=-1&z=&ic=0&word=%E6%BC%86%E9%BB%91%E7%9A%84%E5%AD%90%E5%BC%B9%E5%A3%81%E7%BA%B8&s=&se=&tab=&width=&height=&face=0&istype=2&qc=&nc=1&fr=&pn=30&rn=30&gsm=1e&1521558249171=` 以我搜索的内容为例 这坨很长的url 就是我们需要的 内容。里面以json格式保存的图片数据



那么这坨url是如何构建的呢？

多次对比url 可以发现 有几个参数是改变的`&pn=` `&1521558249171`  queryWord 和word 都是指搜索内容

其他的参数都是固定的QAQ  也就是我们在弄懂 pn 和 一串神奇的数字 是什么就成功了一半了

pn ： 当前页数 * 30

神奇数字： 当前时间的时间戳取到小数点后3位

gsm：pn 的 16位显示



## 代码编写

我是使用的python3.6版本

先简单说下写代码的思路：

- 先进行拼接url--> 就是含有图片数据的json
- 根据url进行请求 拿到html
- 拿到结果进行取具体数据
- 将数据写入本地

为了提高速度： 使用ThreadPoolExecutor 维护了 10个线程

emmm  然后。。。没有然后了

## 代码

```python
from urllib.parse import urlencode
import time
import random
import requests
import simplejson as json
from concurrent.futures import ThreadPoolExecutor as Pool
```

```python
class Crawler:
    """
    爬虫类
    """

    def __init__(self, BATH_DIR=r'E:\Demo\baidu_img', thread=10, height=None, width=None):
        """初始化入口URL
            可设置BATH_DIR 图片存储路径 默认测试路径
            thread 线程池维护的线程数量 默认是10个
            height 图片高度
            width 图片宽度
        """
        self.user_agent = ['Mozilla/5.0(Windows;U;WindowsNT6.1;en-us)\
                            AppleWebKit/534.50(KHTML,likeGecko)Version/5.1Safari/534.50',
                           'Mozilla/5.0(Macintosh;U;IntelMacOSX10_6_8;en-us)\
                            AppleWebKit/534.50(KHTML,likeGecko)Version/5.1Safari/534.50',
                           ]
        self.headers = {
            'User-Agent': self.user_agent[0] if random.randrange(0, 10) % 2 == 0 else self.user_agent[1],
        }
        self.base_url = 'https://image.baidu.com/search/acjson?'
        self.end_page = None
        self.world = None
        self.err_list = []
        self.BATH_DIR = BATH_DIR
        self.theadings = thread
        self.height = height
        self.width = width

    def get_json_url(self, page=1):
        """获取json的数据包的URL"""
        s_time = time.time()
        s_time = ''.join('{:.3f}'.format(s_time).split('.'))
        pn = page * 30
        gsm = hex(pn)
        data = {
            'tn': 'resultjson_com',
            'ipn': 'rj',
            'ct': '201326592',
            'is': '',
            'fp': 'result',
            'queryWord': self.world,
            'cl': '2',
            'lm': '-1',
            'ie': 'utf-8',
            'oe': 'utf-8',
            'adpicid':'',
            'st': '-1',
            'z': '',
            'ic': '0',
            'word': self.world,
            's': '',
            'se': '',
            'tab': '',
            'width': '',
            'height': '',
            'face': '0',
            'istype': '2',
            'qc': '',
            'nc': '1',
            'fr': '',
            'pn': pn,
            'rn': '30',
            'gsm': gsm,
            'e': '',
            s_time: '',
        }
        url = self.base_url + urlencode(data)
        return url

    def get_json(self, page=1):
        """请求json获取包含图片的包"""
        url = self.get_json_url(page)
        time.sleep(1)
        response = requests.get(url, headers=self.headers)
        if response.status_code == 200:
            try:
                data = json.loads(response.content.decode('utf-8'))
            except json.JSONDecodeError:
                time.sleep(0.5)
                res = str(response.content.decode()).replace('\\', "")
                data = json.loads(res)
            return data

    def read_json(self, page=1):
        """读取json的内容提取需要的数据"""
        data = self.get_json(page)
        if self.end_page is None:
            print(data)
            self.end_page = data['listNum'] // 30 + 1
        for i in (data['data']):
            try:
                if self.headers is None or self.width is None:
                    yield i['thumbURL']
                else:
                    if i['height'] == self.height and i['width'] == self.width:
                        yield i['thumbURL']
            except KeyError:
                if i is None:
                    print('当前页面获取完毕')

    def down_img(self, page=1):
        """下载图片"""
        for url_id, url in enumerate(self.read_json(page)):
            with open(f'{self.BATH_DIR}\{page}_{url_id}.jpg', 'wb') as f:
                try:
                    content = requests.get(url).content
                except requests.HTTPSConnectionPool:
                    self.err_list.append({f'{page}{url_id}':url})
                f.write(content)
                f.close()
            print(f'成功下载第{url_id}个图片{url}')
        else:
            return page+1

    def run(self):
        if not self.world:
            self.world = input('所需要爬去的关键字\n>>>').strip()
        self.down_img()
        pool = Pool(max_workers=self.theadings)
        results = pool.map(self.down_img, range(2, self.end_page))
        for i in results:
            print(i)
```



