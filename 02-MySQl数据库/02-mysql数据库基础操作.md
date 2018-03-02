# MySQL数据库——基础操作

## 命名规范

```
可以由字母、数字、下划线、＠、＃、＄
区分大小写
唯一性
不能使用关键字如: CREATE SELECT
不能单独使用数字
最长128位
```

MySQL 的语法不区分大小写

# 数据库操作

## 创建数据库

### 语法

```mysql
#语法： CREATE DATABASES db_name CHARSET utf8
```

```mysql
# 创建一个名字为db_name 的数据库，并制定当前的编码集为utf8
CREATE DATABASE db_name CHARSET uft8;
```

## 查看数据库

### 查询当前用户下所有数据库

```mysql
# 查询当前用户下所有数据库
SHOW DATABASES;
```

### 查看创建数据库的信息

```mysql
# 查看创建数据库的信息
SHOW CREATE DATABASE db_name;
```

### 查询当前操作所在的数据库名称

```mysql
# 查询当前操作所在的数据库名称
SELECT DATABASE();
```

## 选择数据库

```mysql
# 选择db_name 数据库
USE db_name
```

## 删除数据库

```mysql
# 删除db_name 数据库
DROP DATABASE db_name
```



# 数据表操作

## 创建表

### 语法

```mysql
# 语法
CREATE TABLE 表名(
  字段名1 类型[(宽度) 约束条件],
  字段名2 类型[(宽度) 约束条件],
  字段名3 类型[(宽度) 约束条件]
)ENGINE=innodb DEFAULT CHARSET utf8;
```

```mysql
CREATE TABLE student(
	id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  	name varchar(250) NOT NULL,
  	age int NOT NULL,
  	sex ENUM('男','女') NOT NULL DEFAULT '男',
  	salary DOUBLE(10,2) NOT NULL
)ENGINE=INNODB DEFAULT CHARSET uft8;

# ps: not null :表示此列不能为空
#      auto_increment :表示自增长,默认每次增长+1
# 注意:自增长只能添加在主键或者唯一索引字段上
  
# primary key :表示主键(唯一且不为空)
# engine =innodb :表示指定当前表的存储引擎
# default charset utf8 :设置表的默认编码集
```

#### 主键

主键，一种特殊的唯一索引，不允许有空值，如果主键使用单个列，则它的值必须唯一，如果是多列，则其组合必须唯一。

```mysql
CREATE TABLE tb1(
	nid NOT NULL PRIMARY KEY,
  	num NULL
)
# 或
CREATE TABLE tb1(
	nid NOT NULL,
  	num NULL,
  	PRIMARY KEY(nid,num)
)
```

#### 自增

自增，如果为某列设置自增列，插入数据时无需设置此列，默认将自增（表中只能有一个自增列

```mysql
CREATE TABLE tb1(
	nid NOT NULL AUTO_INCREMENT PRIMARY KEY,
  	num NULL
)
# 或
CREATE TABLE tb1(
	nid NOT NULL PRIMARY KEY,
  	num NULL,
  	INDEX(nid)
)
```


#####注意：
1. 对于自增列，必须是索引（含主键）。
2. 对于自增可以设置步长和起始值

```mysql
show session variables like 'auto_inc%';
set session auto_increment_increment=2;
set session auto_increment_offset=10;

show global  variables like 'auto_inc%';
set global auto_increment_increment=2;
set global auto_increment_offset=10; 
```

## 查询表数据

### 查询表数据

```mysql
# 语法
SELECT 字段 (多个以“，”间隔) FROM 表名；
```

```mysql
SELECT name,sex FROM student
# 或
SELECT * FROM student
```

### 查询表结构

```mysql
# 语法
desc 表名
```

```mysql
desc student
```

### 查看创建表信息

```mysql
# 语法
show create table 表名
```

```mysql
show create table student
```

## 修改表结构

### 添加表字段 alter..add

```mysql
# 语法
alter table 表名 add 字段名 类型 约束
```

```mysql
alter table student add age int not null default 0 after name;
# ps after name 表示在name字段后添加字段 age.
```

### 修改表结构 alter

#### 修改表字段

##### 方式一：

```mysql
# 语法
alter table 表名 modify 字段 约束
```

```mysql
alter table student modify age int null default 10
```
##### 方式二：

```mysql
# 语法
alter table 表名 change 旧字段 新字段 约束
```
```mysql
alter table student change age age int not null default 0
```
###### 区别：

```
change 可以改变字段 名字和属性
modify 可以改变字段 属性
```



#### 删除表字段drop

```mysql
# 语法
alter table 表名 drop 字段名;
```
```mysql
alter table student drop age;
```
#### 更新表名称rename

```mysql
# 语法
rename table 旧表名 to 新表名
```


#### 更新主键alter

##### 添加主键

```mysql
# 语法
alter table 表名 add primary key(字段 "多个以‘，’间隔")
```
```mysql
alter table student add primary key (nid)
```
###### 注意

```
ps:如果主键为自增长,以上方式则不被允许执行,请先去掉主键自增长属性,然后再移除主键
```

##### 删除主键

```mysql
# 语法
alter table 表名 drop primary key;
```

```mysql
alter table student drop primary key;
```
#### 外键更新

##### 添加外键

```mysql
# 语法
alter table 从表 add constraint fk_test foreign key 从表（字段） references 主表（字段）
```
##### 移除外键

```mysql
# 语法
alter table 表 drop foreign key 外键名称;
```
###### 注意：

```
ps：如果外键设置后想修改，那么只能是先删除，在添加
```

#### 默认值更新

##### 修改默认值

```mysql
# 语法
alter table 表 alter 字段 set default 100;
```
##### 删除默认值

```mysql
# 语法
alter table 表 alter 字段 drop default;
```
### 删除表

#### 删除表drop

```mysql
# 语法
drop table 表名;
```
#### 清空表truncate

```mysql
# 语法
truncate table 表名;
```
### 复制表

#### 只复制表结构和表中数据

```mysql
# 语法
create table tb2 select * from tb1;
ps: 主键自增/索引/触发器/外键 不会被复制
```
#### 只复制表结构

```mysql
# 语法
create table tb2 like tb1;
ps: 数据\触发器\外键 不会被复制
```
# 数据操作

## 插入数据 instert

### 方式一

```mysql
# 语法一：
# 按字段进行插入
insert into 表（字段1，字段2...）values （值1，值2...）
```
```mysql
insert into student(name,age,sex,salary) value ('Pig','12','男',2500)
```
### 方式二

```mysql
# 语法二：
# 按字段顺序插入
insert into 表 values (值1，值2...)
```
```mysql
insert into student values (2,'App','12','男',250)
```
### 方式三

```mysql
# 语法三：
# 插入多条数据
insert into 表 values(值1，值2...),(值1，值2...),(值1，值2...);
```
```mysql
insert into student values (3,'App2','12','男',250),
						   (4,'App3','13','男',250),
						   (5,'App4','42','男',2520)
```
### 方式四

```mysql
# 语法四：
# 插入查询结果
insert into 表(字段1，字段2...) select 字段1,字段2 ... from 表;
```
```mysql
insert into student(name,age,sex,salary) 
	select name,age,sex,salary from tb2
```



## 更新数据 update

### 方式一

```mysql
# 语法一
# 更新正表数据
update 表名 set 字段1=‘值1’，字段2=‘值2’...;
```
```mysql
update student set name='admin'
```
### 方式二

```mysql
# 语法二
# 更新符合条件的数据
update 表名 set 字段1=‘值1’，字段2=‘值2’ where 字段3=‘值3’
```
```mysql
update student set age=18 where id=3
```


## 删除数据delete

### 方式一

```mysql
# 语法一：
# 整张表删除
delete from 表;
```
```mysql
delete from student;
```
### 方式二

```mysql
# 语法二
# 产出符合条件的数据
delete from 表 where 字段=‘值’
```
```mysql
delete from student where id=1
```


### truncate和delete的区别？[面试题]

```
1、TRUNCATE 在各种表上无论是大的还是小的都非常快。而DELETE 操作会被表中数据量的大小影响其执行效率.
2、TRUNCATE是一个DDL语言而DELETE是DML语句，向其他所有的DDL语言一样，他将被隐式提交，不能对TRUNCATE使用ROLLBACK命令。
3、TRUNCATE不能触发触发器，DELETE会触发触发器。
4、当表被清空后表和表的索引和自增主键将重新设置成初始大小，而delete则不能。
```



## 查询

### 单表查询



```mysql
# 准备数据库
-- 创建表
DROP TABLE IF EXISTS `person`;
CREATE TABLE `person` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `age` tinyint(4) DEFAULT '0',
  `sex` enum('男','女') NOT NULL DEFAULT '男',
  `salary` decimal(10,2) NOT NULL DEFAULT '250.00',
  `hire_date` date NOT NULL,
  `dept_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- 创建数据

-- 教学部
INSERT INTO `person` VALUES ('1', 'CharmNight', '18', '男', '53000.00', '2010-06-21', '1');
INSERT INTO `person` VALUES ('2', 'Github', '23', '男', '8000.00', '2011-02-21', '1');
INSERT INTO `person` VALUES ('3', 'LL', '30', '男', '6500.00', '2015-06-21', '1');
INSERT INTO `person` VALUES ('4', 'AB', '18', '女', '6680.00', '2014-06-21', '1');

-- 销售部
INSERT INTO `person` VALUES ('5', '歪歪', '20', '女', '3000.00', '2015-02-21', '2');
INSERT INTO `person` VALUES ('6', '星星', '20', '女', '2000.00', '2018-01-30', '2');
INSERT INTO `person` VALUES ('7', '格格', '20', '女', '2000.00', '2018-02-27', '2');
INSERT INTO `person` VALUES ('8', '周周', '20', '女', '2000.00', '2015-06-21', '2');

-- 市场部
INSERT INTO `person` VALUES ('9', '月月', '21', '女', '4000.00', '2014-07-21', '3');
INSERT INTO `person` VALUES ('10', '安琪', '22', '女', '4000.00', '2015-07-15', '3');

-- 人事部
INSERT INTO `person` VALUES ('11', '周明月', '17', '女', '5000.00', '2014-06-21', '4');
-- 鼓励部
INSERT INTO `person` VALUES ('12', '苍老师', '33', '女', '1000000.00', '2018-02-21', null);
```





#### 简单查询

```mysql
# 语法
select [distinct]*(所有)|字段名...字段名 from 表名
```
##### 查询所有字段信息

```mysql
select * from person
```
##### 查询指定字段信息

```mysql
select id,name,age,sex,salary from person;
```
##### 别名查询

```mysql
select name,age as '年龄',salary as '工资' from person;
```
##### 列运算

```mysql
select (5/2);
select name, salary+100 from person;
```
##### 剔除重复查询

```mysql
select distinct age from person;
```
#### 条件查询

使用where 关键字，对简单查询的结果集进行过滤

1. 比较运算符：>、<、=、<=、>=、<>(!=)
2. null关键字： is null, not null
3. 逻辑运算符： 与 and 或or


```mysql
# 语法
select [distinct] *(所有)|字段名...字段名 from 表名 [where 条件过滤]
```
##### 比较运算符

```mysql
select * from person where age=23;
select * from person where age<>23;
select * from person where dept_id is null;
select * from person where dept_id is not null;
```
##### 逻辑运算符

```mysql
select * from person where age=23 and salary=2000;
select * from person where age=23 or salary>2000;
```
#### 区间查询

关键字between..and.. 表示在..到..区间的内容

##### between

```mysql
# 语法
select [distinct] *(所有)|字段名...字段名 from 表名 where 字段名 between 起始区间 and 结束区间
```
```mysql
select * from person where salary between 2000 and 10000;
```
###### 注意

```
between ...and 前后包含所有指定的值
例子等价于 
select * from person where salary>=2000 and salary<=10000;
```

#### 集合查询

关键字：in, not null

##### in

```mysql
# 语法 使用in 集合（多个字段） 查询
select [distinct] *(所有)|字段名...字段名 from 表名 where 字段名 in(集合)
```
```mysql
select * from person where age in (23,32,18);
# 等价于
select * from person where age=23 or age=32 or age=18;
```
##### not in

```mysql
# 语法 not in 集合 排除指定值查询
select [distinct] *(所有)|字段名...字段名 from 表名 where 字段名 not in(集合)
```
```mysql
select * from person where age not in(23,32,18)
```
#### 模糊查询

关键字like,not like

​	%:任意多个字符

​	_:只能是单个字符

```mysql
# 语法
select [distinct] *(所有)|字段名...字段名 from 表名 where 字段名 like '条件';
```
```mysql
# 查询姓名以‘张’字开头
select * from person where name like '张%';
# 查询姓名以‘张’字结尾
select * from person where name like '%张';
#查询姓名中含有‘张’字的
select * from person where name like '%张%';
# 查询姓名是 4个字符的人
select * from person where name like '____';
# 查询姓名的第二个字符是h的人
select * from person where name like '_h%';

# 排除名字带n的人
select * from person where name not like '%n%';
```
#### 排序查询

关键字 order by

```mysql
# 语法
select 字段|* from 表名 [where 条件过滤] [order by 字段[ASC][DESC]]
# 升序：ASC 默认为升序
# 降序：DESC 
# ORDER BY 需要写在select语句的末尾
```
```mysql
# 按照人员的工资正序排序： ASC可省略不写
select * from person order by salary ASC;
select * from person order by salary;

# 工资大于5000的人，按工资倒叙排序
select * from person where salary>5000 order by salary DESC;
```
##### 按照中文排序
```mysql
select * from person order by CONVER(name USING gbk);
```
###### 注意
UTF8 默认校对集是utf8_general_ci 它不是按照中文来的。你需要强制让MySQL按照中文来排序

#### 聚合函数

**聚合函数**: 对列进行操作,返回的结果是一个单一的值,除了 COUNT 以外，都会忽略空值

**COUNT**：统计指定列不为NULL的记录行数；
**SUM**：计算指定列的数值和，如果指定列类型不是数值类型，那么计算结果为0；
**MAX**：计算指定列的最大值，如果指定列是字符串类型，那么使用字符串排序运算；
**MIN**：计算指定列的最小值，如果指定列是字符串类型，那么使用字符串排序运算；
**AVG**：计算指定列的平均值，如果指定列类型不是数值类型，那么计算结果为0；

```mysql
# 语法
select 聚合函数（字段） from 表名;
```
```mysql
select max(age),min(age),avg(age) from person;
```
#### 分组查询

**分组的含义:** **将一些具有相同特征的数据 进行归类.比如:性别,部门,岗位等等**

```mysql
# 语法
select 杯分组的字段 from 表名 group by 分组字段 [having 条件字段]
# 分组查询可以与 聚合函数 组合使用
```

```mysql
# 查询每个部门的平均薪资
select avg(salary),dept from person group by dept;

# 查询每个部门的平均薪资，并且看看这个部门的员工
select avg(salary),dept ,GROUP_CONCAT(name) from person group by dept;

# 查询平均薪资 大于10000的部门，且看这个部门的员工
select avg(salary),dept,GROUP_CONCAT(name) from person group by dept having avg(salary)>10000
```
#####where 和 having 的区别
**执行优先级从高到低： where > group by > having**
1. where 发生在分组group by之前，因而Where中可以有任意字段，但是绝对不能使用聚合函数。
2. Having发生在分组group by之后，因而Having中可以使用分组的字段，无法直接取到其他字段,可以使用聚合函数

#### 分页查询

limit

优点： 限制查询数据条数，提高查询效率

```mysql
# 语法
select 字段名|* from 表名 limit (起始条数),(查询多少条);
```
```mysql
#查询前5条数据
select * from person limit 5;
 
#查询第5条到第10条数据
select * from person limit 5,5;
 
#查询第10条到第15条数据
select * from person limit 10,5;
```


#### SQL 语句关键字的执行顺序

```mysql
select name, max(salary)
   
from person  
   
where name is not null  
   
group by name  
   
having max(salary) > 5000
   
order by max(salary)
 
limit 0,5
```

```
在上面的示例中 SQL 语句的执行顺序如下:

　　 (1). 首先执行 FROM 子句, 从 person 表 组装数据源的数据

　　 (2). 执行 WHERE 子句, 筛选 person 表中 name 不为 NULL 的数据

　　 (3). 执行 GROUP BY 子句, 把 person 表按 "name" 列进行分组

　　 (4). 计算 max() 聚集函数, 按 "工资" 求出工资中最大的一些数值

　　 (5). 执行 HAVING 子句, 筛选工资大于 5000的人员.

　　 (7). 执行 ORDER BY 子句, 把最后的结果按 "Max 工资" 进行排序.

　　 (8). 最后执行 LIMIT 子句, . 进行分页查询

执行顺序: FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY ->limit　　
```



### 多表查询

所需库表

```mysql
#创建部门
CREATE TABLE IF NOT EXISTS dept (
    did int not null auto_increment PRIMARY KEY,
    dname VARCHAR(50) not null COMMENT '部门名称'
)ENGINE=INNODB DEFAULT charset utf8;


#添加部门数据
INSERT INTO `dept` VALUES ('1', '教学部');
INSERT INTO `dept` VALUES ('2', '销售部');
INSERT INTO `dept` VALUES ('3', '市场部');
INSERT INTO `dept` VALUES ('4', '人事部');
INSERT INTO `dept` VALUES ('5', '鼓励部');

-- 创建人员
DROP TABLE IF EXISTS `person`;
CREATE TABLE `person` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `age` tinyint(4) DEFAULT '0',
  `sex` enum('男','女') NOT NULL DEFAULT '男',
  `salary` decimal(10,2) NOT NULL DEFAULT '250.00',
  `hire_date` date NOT NULL,
  `dept_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- 添加人员数据

-- 教学部
INSERT INTO `person` VALUES ('1', 'CharmNight', '18', '男', '53000.00', '2010-06-21', '1');
INSERT INTO `person` VALUES ('2', 'Github', '23', '男', '8000.00', '2011-02-21', '1');
INSERT INTO `person` VALUES ('3', 'LL', '30', '男', '6500.00', '2015-06-21', '1');
INSERT INTO `person` VALUES ('4', 'AB', '18', '女', '6680.00', '2014-06-21', '1');

-- 销售部
INSERT INTO `person` VALUES ('5', '歪歪', '20', '女', '3000.00', '2015-02-21', '2');
INSERT INTO `person` VALUES ('6', '星星', '20', '女', '2000.00', '2018-01-30', '2');
INSERT INTO `person` VALUES ('7', '格格', '20', '女', '2000.00', '2018-02-27', '2');
INSERT INTO `person` VALUES ('8', '周周', '20', '女', '2000.00', '2015-06-21', '2');

-- 市场部
INSERT INTO `person` VALUES ('9', '月月', '21', '女', '4000.00', '2014-07-21', '3');
INSERT INTO `person` VALUES ('10', '安琪', '22', '女', '4000.00', '2015-07-15', '3');

-- 人事部
INSERT INTO `person` VALUES ('11', '周明月', '17', '女', '5000.00', '2014-06-21', '4');

-- 鼓励部
INSERT INTO `person` VALUES ('12', '苍老师', '33', '女', '1000000.00', '2018-02-21', null);
```



#### 多表联合查询

```mysql
# 语法
select 字段..字段|* from 表1,表2...[where 条件]
```
如果不写条件会出现**笛卡尔乘积**

```mysql
# 产生笛卡尔乘积
select * from person,dept
```
笛卡尔乘积公式：笛卡尔乘积=A表中的数据条数 * B表中的数据条数



```mysql
# 查询人员和部门的所有信息
select * from person,dept where person.dept_id=dept.did
```
##### 注意

多表查询时，一定要找到两个表中相互关联的字段，并且作为条件使用

#### 多表连接查询

```mysql
# 语法
select 字段列名
	from 表1 INNER|LEFT|RIGHT JOIN 表2
ON 表1.字段=表2.字段;
```
##### 内连接查询（只显示符合条件的数据）

```mysql
# 语法
SELECT 字段名
	FROM 表1 INNER JOIN 表2
ON 表1.字段=表2.字段;
```
```mysql
# 查询人员和部门所有信息
select * from person inner join dept on person.dept_id=dept.did;
```
效果：内连接查询与多表联合查询的效果是一样的

##### 左外连接查询（左表中的数据优先全部显示）

```mysql
# 语法
SELECT 字段名
	FROM 表1 LEFT JOIN 表2
ON 表1.字段=表2.字段;
```
```mysql
# 查询人员和部门所有信息
select * from person left join dept on person.dept_id=dept.did;
```
效果：人员表中的数据全部显示，而部门表中的数据符合条件才会显示，不符合条件的会以null填充

##### 右外连接查询（右表中的数据优先全部显示）

```mysql
# 语法
SELECT 字段名
	FROM 表1 RIGHT JOIN 表2
ON 表1.字段=表2.字段;
```

```mysql
# 查询人员和部门所有信息
select * from person right join dept on person.dept_id=dept.did;
```

效果：与左外连接查询正好相反

##### 全连接（显示左右表中全部的信息）

全连接查询：是在内连接的基础上增加 左右两边没有显示的数据
注意: mysql并不支持全连接 full JOIN 关键字
注意: 但是mysql 提供了 UNION 关键字.使用 UNION 可以间接实现 full JOIN 功能

```mysql
# 语法
SELECT 字段名
	FROM 表1 RIGHT JOIN 表2
ON 表1.字段=表2.字段;
UNION
SELECT 字段名
	FROM 表1 RIGHT JOIN 表2
ON 表1.字段=表2.字段;
```
```mysql
#查询人员和部门的所有数据
 
SELECT * FROM person LEFT JOIN dept ON person.dept_id = dept.did
UNION
SELECT * FROM person RIGHT JOIN dept ON person.dept_id = dept.did;
```

#### 复杂条件多表查询

##### 例1

 查询出 教学部 年龄大于20岁,并且工资小于40000的员工,按工资倒序排列.(要求:分别使用多表联合查询和内连接查询)

```mysql
#1.多表联合查询方式:
select * from 
	person,dept 
where 
  person.dept_id=dept.did 
  and person.age>20 
  and person.salary<40000
order by person.salary DESC;
#2.内连接查询方式:
select * from
	person inner join dept
on
	person.dept_id=dept.did
	and person.age>20
	and person.salary<40000
order by person.salary DESC
```



##### 例2 

查询每个部门中最高工资和最低工资是多少,显示部门名称

```mysql
select MAX(salary),MIN(salary),dept.dname from person,dept
where
	person.dept_id=dept.did
group by person.dept_id
```



#### 子语句查询

```
子查询(嵌套查询): 查多次, 多个select

注意: 第一次的查询结果可以作为第二次的查询的 条件 或者 表名 使用.

子查询中可以包含：IN、NOT IN、ANY、ALL、EXISTS 和 NOT EXISTS等关键字. 还可以包含比较运算符：= 、 !=、> 、<等.
```

##### 作为表名

```mysql
# 语法
select * from (select * from 表1) as 别名 [where 条件];
```

```
ps:大家需要注意的是: 一条语句中可以有多个这样的子查询,在执行时,最里层括号(sql语句) 具有优先执行权.
注意: as 后面的表名称不能加引号('')
```

##### 作为条件

```mysql
# 语法
select * from 表1 where 条件=(select * from 表2);
```
###### 求最大工资那个人的姓名和薪水

```mysql
# 1.求最大工资
select max(salary) from person;
# 2.求最大工资那个人叫什么
select name,salary from person where salary=53000;

# 合并
select name,salary from person where salary=(select max(salary) from person);
```

###### 求工资高于所有人员平均工资的人员

```mysql
# 1.求平均工资
select avg(salary) from person;

# 2.工资大于平均工资的 人的姓名、工资
select name,salary from person where salary > 21298.625;

# 合并
select name,salary from person where salary >(select avg(salary) from person);
```

##### Demo

1. 查询平均年龄在20岁以上的部门名
2. 查询教学部 下的员工信息
3. 查询大于所有人平均工资的人员的姓名与年龄

```mysql
# 1.查询平均年龄在20岁以上的部门名
SELECT * from dept where dept.did in (
    select dept_id from person GROUP BY dept_id HAVING avg(person.age) > 20
);

# 2.查询教学部 下的员工信息
select * from person where dept_id = (select did from dept where dname ='教学部');

# 3.查询大于所有人平均工资的人员的姓名与年龄
select * from person where salary > (select avg(salary) from person);
```

#### 关键字

##### any关键字

```
假设any内部的查询语句返回的结果个数是三个，如:result1,result2,result3,那么，

select ...from ... where a > any(...);
->
select ...from ... where a > result1 or a > result2 or a > result3;
```

##### all关键字

```
ALL关键字与any关键字类似，只不过上面的or改成and。即:

select ...from ... where a > all(...);
->
select ...from ... where a > result1 and a > result2 and a > result3;
```

##### some关键字

```
some关键字和any关键字是一样的功能。所以:

select ...from ... where a > some(...);
->
select ...from ... where a > result1 or a > result2 or a > result3;
```

##### exists关键字

```
EXISTS 和 NOT EXISTS 子查询语法如下：

　　SELECT ... FROM table WHERE  EXISTS (subquery)
该语法可以理解为：主查询(外部查询)会根据子查询验证结果（TRUE 或 FALSE）来决定主查询是否得以执行。

mysql> SELECT * FROM person
    -> WHERE EXISTS
    -> (SELECT * FROM dept WHERE did=5);
Empty set (0.00 sec)
此处内层循环并没有查询到满足条件的结果，因此返回false，外层查询不执行。

NOT EXISTS刚好与之相反
```

```
mysql> SELECT * FROM person 
    -> WHERE NOT EXISTS 
    -> (SELECT * FROM dept WHERE did=5);
```

```
当然，EXISTS关键字可以与其他的查询条件一起使用，条件表达式与EXISTS关键字之间用AND或者OR来连接，如下：

mysql> SELECT * FROM person 
    -> WHERE AGE >23 AND NOT EXISTS 
    -> (SELECT * FROM dept WHERE did=5);

```

###### 提示：

•EXISTS (subquery) 只返回 TRUE 或 FALSE，因此子查询中的 SELECT * 也可以是 SELECT 1 或其他，官方说法是实际执行时会忽略 SELECT 清单，因此没有区别。



#### 其他查询

##### 临时表查询

###### 需求：

查询高于本部门平均工资的人员

###### 解析思路: 

1. 先查询本部门人员平均工资是多少.
2. 再使用人员的工资与部门的平均工资进行比较

```mysql
#1.先查询部门人员的平均工资
SELECT dept_id,AVG(salary)as sal from person GROUP BY dept_id;
 
#2.再用人员的工资与部门的平均工资进行比较
SELECT * FROM person as p1,
    (SELECT dept_id,AVG(salary)as '平均工资' from person GROUP BY dept_id) as p2
where p1.dept_id = p2.dept_id AND p1.salary >p2.`平均工资`;
```

###### ps

```
在当前语句中,我们可以把上一次的查询结果当前做一张表来使用.因为p2表不是真是存在的,所以:我们称之为 临时表　　
临时表:不局限于自身表,任何的查询结果集都可以认为是一个临时表.
```



##### 判断查询 IF关键字

###### 需求1

根据工资高低,将人员划分为两个级别,分别为 高端人群和低端人群。显示效果:姓名,年龄,性别,工资,级别

```mysql
# 语法
select
	if (条件，当条件成功时，当条件不成功时) as 别名
from 表
```



```mysql
select person.*,
	IF (person.salary>10000,'高端人群','低端人群') as 级别
from person
```

###### 需求2

根据工资高低,统计每个部门人员收入情况,划分为 富人,小资,平民,吊丝 四个级别, 要求统计四个级别分别有多少人

```mysql
# 语法1
select
	case when state = '1' then '成功'
	case when state = '2' then '失败'
	else '其他' end
from 表

# 语法2
select case age
		when 23 then '23岁'
		when 27 then '27岁'
		when 30 then '30岁'
	else '其他' end
from 表
	
```

```mysql
SELECT dname '部门',
	sum(case WHEN salary >50000 THEN 1 ELSE 0 end) as '富人',
	sum(case WHEN salary between 29000 and 50000 THEN 1 ELSE 0 end) as '小资',
	sum(case WHEN salary between 10000 and 29000 THEN 1 ELSE 0 end) as '平民',
	sum(case WHEN salary <10000 THEN 1 ELSE 0 end) as '吊丝'
FROM person,dept where person.dept_id = dept.did GROUP BY dept_id
```

