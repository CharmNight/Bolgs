# selenium小玩具

selenium是一个自动化的工具，之前写过一次爬虫，感觉挺好玩的。

根据Excel表格中的数据自动填入网页中，需求就是这个。一开始感觉挺简单的，写起来也挺简单的，demo也挺好，就是在用真实数据跑的时候各种BUG···  想法和现实的差距太大了

## 实现思路

需要的数据是从Excel表格中获取的，所以我们需要先从Excel表格中读取数据。

访问目标网页，自动输入帐号密码进行登录，得到需要操作的页面。

依次得到页面中每行的数据，然后根据姓名在Excel中的数据中找，拿到数据填入网页中



最开始思路是使用requests 模拟页面登录 ，然后拿到数据···后来发现 目标页面是用的django框架 scrf 不知道怎么获得。emm出门被击毙，后来想起来刚学的selenium就慢慢有了上面的思路



## 使用类库

**使用的python3.6**

读取Excel 使用的 xlrd

selenium 进行操作

然后就没有然后了，看看代码的实现



##  代码

我会在代码中添加注解和一些方法是干什么的（QAQ说错了的话请指出， 感谢） 很多东西是根据页面得到的，但是 页面无法给出， 这个就当作半个selenium的 练习

```python
from selenium import webdriver
from selenium.common.exceptions import TimeoutException  # 这是一个超时时间的异常
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.select import Select  # 操作下拉框的
from config import (USER,
                    PWD)  # config是一个用户登录的配置， 有帐号、密码
import xlrd


browser = webdriver.Chrome()  # 模拟打开Chrome浏览器
wait = WebDriverWait(browser, 10)    # 等待延时
    
grade_dic = {'A+': '100', 'A': '90', 'B+': '85', 'B': '80', 'B-': '70', 'C+': '60', 'C': '50', 'C-': '40', 'D': '0', 'N/A': '-1'}  # 这是页面中一个下拉框中的数据
err_user_list = []  # 未找到的学生


def log_in(url):
    """登录
        url是目标url
    """
    try:
        browser.get(url)  # 请求的网址

        # 等待延时的操作
        input_name = wait.until(
            EC.presence_of_element_located((By.ID, 'id_username'))  # 等待页面中ID 为　ｉｄ_username 的元素加载完并且拿到该元素。 下同
        )
        input_pwd = wait.until(
            EC.presence_of_element_located((By.ID, 'id_password'))
        )

        input_name.send_keys(USER)  # send_keys input 标签输入内容
        input_pwd.send_keys(PWD)
        btn = wait.until(
            EC.element_to_be_clickable((By.CLASS_NAME, 'btn'))
        )  # 等待该元素可点击后 拿到该元素
        btn.click()  # 模拟btn按钮点击
    except TimeoutException:
        print('请求超时')
        return log_in(url)

def set_change():
    """将批注为None的改成作业未批注"""
    try:
        pz_inputs = wait.until(
            EC.presence_of_all_elements_located((By.CLASS_NAME, 'homework_note'))
        )
        bz_inputs = wait.until(
            EC.presence_of_all_elements_located((By.CLASS_NAME, 'note'))
        )

        for item in pz_inputs:
            if item.text == 'None':
                item.clear()  # 清除输入框的内容
                item.send_keys('作业未批注')
        else:
            pass
    except TimeoutException:
        print('请求超时')
        return set_change()


def read_excel(file_path, sheet_name):
    """读取excel文件
    file_path：  文件路径
    sheet_name: sheet的名称"""
    excel_file = xlrd.open_workbook(file_path)  # 打开一个Excel
    sheet = excel_file.sheet_by_name(sheet_name)  # 根据Sheet名称拿到该sheet
    nrows = sheet.nrows  # 获取shett的行数
    lis = []
    for i in range(nrows):
        lis.append(sheet.row_values(i))  # 依次获取每行数据
    else:
        return lis


def import_excel(excel):
    """导入excel文件
        根据excel中的数据进行修改web页面
    """
    users_pz = wait.until(
        EC.presence_of_all_elements_located((By.CSS_SELECTOR, '#demo-dt-basic tbody .homework_note'))
    )
    users_score = wait.until(
        EC.presence_of_all_elements_located((By.CSS_SELECTOR, '#demo-dt-basic tbody .score'))
    )
    users_name = wait.until(
        EC.presence_of_all_elements_located((By.CSS_SELECTOR, '#demo-dt-basic tbody td:nth-child(3) a'))
    )
    content = zip(users_name, users_score, users_pz)  # 为了防止数据混乱，将其一一对应 进行分组
    # 姓名 成绩 作业批注
    for item in content:
        if change_web(excel, item) is None:
            err_user_list.append(item[0].text)
    else:
        print('未找到人员名单', err_user_list)


def change_web(excel, item):
    """修改操作"""
    for data in excel:
        if item[0].text in data:
            if data[1] and data[2]:
                Select(item[1]).select_by_value(grade_dic.get(data[1], 'N/A'))  # 通过Select 进行操作下拉框
                item[2].clear()
                item[2].send_keys(data[2])
                return True


def restore_default():  # 这个函数 完全是因为 我在做测试的时候 每次都进行修改 修改完还要复原数据太麻烦
    """恢复默认页面：
        所有内容设为None
    """
    users_pz = wait.until(
        EC.presence_of_all_elements_located((By.CSS_SELECTOR, '#demo-dt-basic tbody .homework_note'))
    )
    users_bz = wait.until(
        EC.presence_of_all_elements_located((By.CSS_SELECTOR, '#demo-dt-basic tbody .homework_note'))
    )
    users_score = wait.until(
        EC.presence_of_all_elements_located((By.CSS_SELECTOR, '#demo-dt-basic tbody .score'))
    )
    content = zip(users_score, users_pz, users_bz)
    for item in content:
        Select(item[0]).select_by_value('-1')
        item[1].clear()
        item[1].send_keys('None')
        item[2].clear()
        item[2].send_keys('None')


def run_default(url):
    """执行恢复默认"""
    log_in(url)
    restore_default()


def run_main(url, file_path, sheet_name):
    """执行函数：
        url：目标url
        filt_path: excel文件路径
        sheet_name excel文件中sheet的名字 （这个需要严重注意）
    """
    try:
        log_in(url)
        excel = read_excel(file_path, sheet_name)
        import_excel(excel)
    except TimeoutException:
        return run_main(url, file_path, sheet_name)


if __name__ == '__main__':
    url = input('输入目标url>>>').strip()
    file_path = input('输入文件路径>>>:').strip()
    sheet_name = input('输入sheet的名称>>>:').strip()
    run_main(url, file_path, sheet_name)
    # run_default(url)


```



## 总结

Excel的简单读取

selenium 模拟页面 操作 输入框、按钮、下拉框

好像就没其他的了···