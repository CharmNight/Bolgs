MySQL全家桶

## 视图

视图：是一个虚拟的表，其内容由查询定义。同真实表一样，视图包含一系列带有名称的列和行的数据

**视图是虚拟表，本身不存储数据，而是按照指定的方式进行查询**

### 视图的特点

1. 视图的列可以来自不同的表，是表的抽象和逻辑意义上建立的新关系。
2. 视图是由基本表（实表）产生的表（虚表）
3. 视图的建立和删除不影响基本表
4. 对视图内容的更新（添加、删除和修改）直接影响基本表
5. 当视图来自多个基本表时，不允许添加和删除数据

### 视图的优点

1. 视图可以简化用户操作
2. 视图使用户能以多个角度看待同一数据
3. 视图对重构数据库提供了一定程度的逻辑独立性
4. 视图能够对机密数据提供安全保护
5. 适当使用视图可以更清晰的表达查询



### 视图相关的SQL语句

| 操作指令      | 代码                                       |
| --------- | ---------------------------------------- |
| 创建视图      | `CREATE VIEW 视图名(列1，列2...) AS SELECT (列1，列2...) FROM ...;` |
| 使用视图      | `当成表使用就好`                                |
| 修改视图(1)   | `CREATE OR REPLACE VIEW 视图名 AS SELECT [...] FROM [...];` |
| 修改视图(2)   | `ALTER VIEW 视图名 AS SELECT [...] FROM [...];` |
| 查看数据库已有视图 | `>SHOW TABLES [like...];`（可以使用模糊查找）      |
| 查看视图详情    | `DESC 视图名`或者`SHOW FIELDS FROM 视图名`       |
| 视图条件限制    | `[WITH CHECK OPTION]`                    |



### 创建视图

#### 创建视图 create view

```mysql
# 语法
CREATE VIEW 视图名（列1，列2...） as sql查询语句
```

查询person表中 所有内容 作为p_1的视图

```mysql
create view v_1 as select * from person
```



#### 修改视图 

##### create or replace

```mysql
# 语法
ALTER OR REPLACE [ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
VIEW view_name [(column_list)]
AS select_statement
[WITH [CASCADED | LOCAL] CHECK OPTION]
```



```mysql
create or replace view v_1 as select id,name,age,salary from person
```

##### alter

```mysql
# 语法
ALTER [ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
VIEW view_name [(column_list)]
AS select_statement
[WITH [CASCADED | LOCAL] CHECK OPTION]
```



```mysql
alter view v_1 as select id,name,age,salary from person
```

##### 注意：

create or replace view 和 create view 的区别

```
create or replace view的意思就是若数据库中已经存在这个名字的视图的话，就替代它，若没有则创建视图；
create则不进行判断，若数据库中已经存在的话，则报错，说对象已存在；
```



#### 使用视图

```mysql
# 语法
select *|列明 from 视图名称;
```

查询p_1视图中所有信息

```mysql
select * from v_1
```



#### 查看视图 



##### 查看数据库中有哪些视图 show tables 

```mysql
SHOW TABLES;
```

通过`show tables;`反馈得到所有的表和视图。同样的，我们可以通过模糊检索的方式专门查看视图，这个时候，视图的命令统一采用v_视图名的优势就体现出来了。



##### 查看视图详情 

###### desc 视图名

```mysql
# 语法
desc 视图名
```

```mysql
desc v_1
```



###### show fields from 视图名

```mysql
# 语法
show fields from 视图名
```

```mysql
show fields from v_1
```



#### 修改视图的数据

###### 单表数据

```mysql
insert into v_1 values('14','Charm','18','男','2333.00','2010-06-21', '1')
```



###### 跨表数据

跨表插入数据系统反馈报错，提示不能修改超过一个表的数据。

**因此，可以通过视图插入数据，但是只能基于一个基础表进行插入，不能跨表更新数据**



#### WITH CHECK OPTION 

如果在创建视图的时候制定了“WITH CHECK OPTION”，那么更新数据时不能插入或更新不符合视图限制条件的记录。

with   check   option可以这么解释：通过视图进行的修改，必须也能通过该视图看到修改后的结果。比如你insert，那么加的这条记录在刷新视图后必须可以看到；如果修改，修改完的结果也必须能通过该视图看到；如果删除，当然只能删除视图里有显示的记录。  

##### 小结

1. 对于update,有with check option，要保证update后，数据要被视图查询出来 
2. 对于delete,有无with check option都一样 
3. 对于insert,有with check option，要保证insert后，数据要被视图查询出来 
4. 对于没有where 子句的视图，使用with check option是多余的



#### 删除视图

```MYSQL
# 语法
drop view 视图名
```



```mysql
drop view p_1
```

### 注意

1. 视图不是表，不直接存储数据，是一张虚拟的表； 
2. 一般情况下，在创建有条件限制的视图时，加上“WITH CHECK OPTION”命令。




## 触发器

触发器是与表有关的数据库对象，在满足定义条件时触发，并执行触发器中定义的语句集合。触发器的这种特性可以协助应用在数据库端确保数据的完整性。

简而言之：触发器——监视某种情况，并触发某种操作。



### 触发器创建语法四要素：

1. 监视地点(table)
2. 监视事件(insert/update/delete)
3. 触发时间(after/before)
4. 触发事件(insert/update/delete)



### 创建触发器



#### 语法及解释

```mysql
# 语法
DELIMITER //
create trigger 触发器名  after/before  触发事件（insert/update/delete）
     on 表名 for each row #这句话是固定的
 begin
     #需要执行的sql语句
     # 其中，BEGIN与END之间的执行语句列表参数表示需要执行的多个语句，不同语句用分号隔开
 end //
 DELIMITER ;
# 注意1:after/before: 只能选一个 ,after 表示 后置触发, before 表示前置触发
# 注意2:insert/update/delete:只能选一个
```

|            |                          |
| ---------- | ------------------------ |
| 触发器类型      | 激活触发器的语句                 |
| INSERT型触发器 | INSERT,LOAD DATA,REPLACE |
| UPDATE型触发器 | UPDATE                   |
| DELETE型触发器 | DELETE,REPLACE           |

一些语句解释：

- LOAD DATA:语句用于将一个文件装入到一个数据表中，相当与一系列的 INSERT 操作。
- REPLACE: 语句一般来说和 INSERT 语句很像，只是在表中有 primary key 或 unique 索引时，如果插入的数据和原来 primary key 或 unique 索引一致时，会先删除原来的数据，然后增加一条新数据，也就是说，一条 REPLACE 语句有时候等价于一条

##### 小技巧:

```
一般情况下，mysql默认是以 ; 作为结束执行语句，与触发器中需要的分行起冲突

为解决此问题可用DELIMITER，如：DELIMITER //，可以将结束符号变成//

当触发器创建完成后，可以用DELIMITER ;来将结束符号变成;
```

​	

#### 准备数据

```mysql
#商品表
create table goods(
  id int primary key auto_increment,	# 商品id
  name varchar(20),						# 商品名称
  num int								# 商品数量
);

#订单表
create table order_table(
    oid int primary key auto_increment,	# 订单id
    gid int,							# 订单中商品id 
    much int							# 订单数量
);

# 插入3条准备数据
insert into goods(name,num) values('商品1',10),('商品2',10),('商品3',10);
```



#### 创建触发器



##### 创建INSERT型触发器

当用户提交一个订单后，我们应修改商品的数量

```mysql
delimiter //
create trigger t_1 after insert on order_table
for each ROW
BEGIN
	update goods set num = num - new.much where id = new.gid;
END//
delimiter ;
```

对于insert而言，新插入的行用new来表示，行中的每一列的值用new.列名来表示。



##### 创建UPDATE型触发器

当用户修改一个订单的数量时，应修改商品的数量

```mysql
delimiter //
create trigger t_2 after update on order_table
for each ROW
BEGIN
	update goods set num = num + old.much - new.much where id=old.gid;
END//
delimiter ;
```



##### 创建DELETE型触发器

当用户撤销一个订单的时候, 应修改商品数量

```mysql
delimiter //
create trigger t_3 after delete on order_table
for each row
begin
	update goods set num = num+old.much where id=old.gid; 
end //
delimiter ;
```

用old来表示旧表中的值，old.列名可以引用原(旧)表中的值。

##### 小结

用old来表示旧表中的值，old.列名可以引用原(旧)表中的值。



#### 使用触发器

触发器无法由用户直接调用，而知由于对表的【增/删/改】操作被动引发的



#### 删除触发器

```mysql
# 语法
drop trigger 触发器名
```

```mysql
drop trigger t_1;
drop trigger t_2;
drop trigger t_3;
```



## 存储过程

MySQL数据库在5.0版本后开始支持存储过程

**存储过程**：类似于函数(方法),简单的说存储过程是为了完成某个数据库中的特定功能而编写的语句集合，该语句集包括SQL语句（对数据的增删改查）、条件语句和循环语句等。



### 存储过程的优点

1. 用于替代程序写的SQL语句，实现程序与sql解耦
2. 存储过程增强了SQL语言灵活性
3. 基于网络传输，传别名数据量小，而直接传sql数据量大
4. 存储过程只在创造时进行编译，以后每次执行存储过程都不需再重新编译。



### 存储过程的缺点

- 程序员扩展不方便
- 不便于系统后期维护



### 存储过程相关的操作

#### 查看现有的存储过程

```mysql
show procedure status;
```

#### 删除存储过程

```mysql
# 语法
drop procedure 存储过程名称
```

```mysql
drop procedure p1;
```

#### 调用存储过程

```mysql
# 语法
call 存储过程名称([参数入/出类型 参数名 数据类型]);
```



### 创建存储过程

#### 语法

```mysql
DELIMITER // 声明语句结束符，用于区分; 
CEATE PROCEDURE demo_in_parameter(IN p_in int) 声明存储过程 
BEGIN …. END 存储过程开始和结束符号 
SET @p_in=1 变量赋值 
DECLARE l_int int unsigned default 4000000; 变量定义
```



#### 创建无参的存储过程



```mysql
delimiter //
create procedure p1()
BEGIN
	select * from person;
END//
delimiter ;
```

##### 调用

```mysql
# 在mysql中调用
call p1()

# 在python中基于pymysql调用
cursor.callproc('p1') 
print(cursor.fetchall())
```



#### 创建有参的存储过程

##### 参数问题

```mysql
对于存储过程，可以接收参数，其参数有三类：

#in          仅用于传入参数用
#out        仅用于返回值用
#inout     既可以传入又可以当作返回值

# 乱入！！！
# into 关键字 可以 将前面字段的查询结果 执行 给 into 后面的变量
# declare 关键字 可以定义变量
```

##### in:传入参数

```mysql
delimiter //
create procedure p1(in i_id int)
begin
	select * from person where id=i_id;
end//
delimiter ;
```

###### 调用

```mysql
call p1(5)
```



##### out:返回参数

```mysql
delimiter//
create procedure p1(in i_id int, out counts int)
begin
	select count(name) into counts from person where id>i_id;
end//
delimiter;
```

###### 调用

```mysql
set @counts=0
call p1(10,@counts)
select @counts
```



##### inout:传入返回

```mysql
delimiter//
create procedure p1(inout i_id int)
begin
	declare nub int default 0;
	select count(id) into nub from person where id=i_id;
	if nub!=0 then
		set i_id=1
	else
		set i_id=0;
	end if;
end//
delimiter;
```

###### 调用

```mysql
set @count=5;
call p1(@count);
select @count;
```



##### 其他练习

###### if练习

如果输入x>5则返回id大于5的数据的数量，否则返回id小于x的数量

```mysql
delimiter \\
create procedure p1(in x int, out y int)
begin
	if x>=5 then
		select count(id) into y from person where id>x;
    else
    	select count(id) into y from person where id<x;
   	end if;
end\\
delimiter;


set @y=0;
call(10,@y);
select @y;
```



###### while 练习

```mysql
delimiter\\
create procedure p1(inout x int)
begin
	declare sum int default 0;
	declare i int default 0;
	while i <= x do
		set sum = sum+i;
		set i = i+1;
	set x = sum
end\\
delimiter;

set @nub=100
call(@nub)
select @nub
```



###### repeat练习

repeat 也是循环 不过需要注意几点：

repeat..until...end repeat

- until 后面写条件 （条件成立时结束循环）
- until 后面不能加 ;

```mysql
delimiter\\
create procedure p1(inout x int)
begin
	declare sum int default 0;
	declare i int default 0;
	repeat
		set sum = sum+i;
		set i = i+1;
		until i > x
	end repeat;
	set x = sum;
end\\
delimiter;

set @nub=100
call p1(@nub)
select @nub
```



###### loop练习

LOOP……END LOOP

loop也是循环

注意：

- 定义一个入口
- 定义一个结束循环的判断

```mysql
delimiter\\
create procedure p1(inout x int)
begin
	declare sum int default 0;
	declare i int default 0;
	loop_lable:loop
		set sum = sum+i;
		set i = i+1;
		if i > x then
			leave loop_lable;
		end if;
	end loop;
	set x = sum;
end\\
delimiter;

set @count=100;
call p1(@count);
select @count;
```





### 程序与数据库结合的三种方式

#### 方式一

```
MySQL	：存储过程
程序	   ：调用存储过程
```

#### 方式二

```
MySQL	：
程序	   ：纯SQL语句
```

#### 方式三

```
MySQL	：
程序	   ：类和对象，即ORM（本质还是纯SQL语句）
```



## 函数

### 内置函数

Mysql提供了许多内置函数

#### 一、数学函数

```mysql
ROUND(x,y)			# 返回参数x的四舍五入的有y位小数的值
    
RAND()				# 返回０到１内的随机值,可以通过提供一个参数(种子)使RAND()随机数生成器生成一个指定的值。
```

#### 二、聚合函数(常用于GROUP BY从句的SELECT查询中)

```mysql
AVG(col)				# 返回指定列的平均值
COUNT(col)				# 返回指定列中非NULL值的个数
MIN(col)				# 返回指定列的最小值
MAX(col)				# 返回指定列的最大值
SUM(col)				# 返回指定列的所有值之和
GROUP_CONCAT(col) 		# 返回由属于一组的列值连接组合而成的结果    
```

#### 三、字符串函数

```mysql
CHAR_LENGTH(str)
    # 返回值为字符串str 的长度，长度的单位为字符。一个多字节字符算作一个单字符。
CONCAT(str1,str2,...)
    # 字符串拼接 如有任何一个参数为NULL ，则返回值为 NULL。
CONCAT_WS(separator,str1,str2,...)
    # 字符串拼接（自定义连接符） CONCAT_WS()不会忽略任何空字符串。 (然而会忽略所有的 NULL）。

FORMAT(X,D)
    # 将数字X 的格式写为'#,###,###.##',以四舍五入的方式保留小数点后 D 位， 并将结果以字符串的形式返回。若  D 为 0, 则返回结果不带有小数点，或不含小数部分。
    例如：
        SELECT FORMAT(12332.1,4); 结果为： '12,332.1000'

INSERT(str,pos,len,newstr)
    # 在str的指定位置插入字符串
    #    pos：要替换位置其实位置
    #    len：替换的长度
    #    newstr：新字符串
    例如:
        SELECT INSERT('abcd',1,2,'tt'); 结果为: 'ttcd'
        SELECT INSERT('abcd',1,4,'tt'); 结果为: 'tt'
    特别的：
        如果pos超过原字符串长度，则返回原字符串
        如果len超过原字符串长度，则由新字符串完全替换

INSTR(str,substr)
    # 返回字符串 str 中子字符串的第一个出现位置。

LEFT(str,len)
    # 返回字符串str 从开始的len位置的子序列字符。
    例如:
        SELECT INSTR('abc','c'); 结果为： 3
        SELECT INSTR('abc','d'); 结果为： 0
        
LOWER(str)		# 变小写

UPPER(str)		# 变大写
   
REVERSE(str)
    # 返回字符串 str ，顺序和字符顺序相反。
    例如:
        SELECT REVERSE('1234567') 结果为：7654321
        
SUBSTRING(str,pos) , SUBSTRING(str FROM pos) SUBSTRING(str,pos,len) , SUBSTRING(str FROM pos FOR len)
    # 不带有len 参数的格式从字符串str返回一个子字符串，起始于位置 pos。带有len参数的格式从字符串str返回一个长度同len字符相同的子字符串，起始于位置 pos。 使用 FROM的格式为标准 SQL 语法。也可能对pos使用一个负值。假若这样，则子字符串的位置起始于字符串结尾的pos 字符，而不是字符串的开头位置。在以下格式的函数中可以对pos 使用一个负值。

    mysql> SELECT SUBSTRING('Quadratically',5); -- 从第5位开始截取
        -> 'ratically'

    mysql> SELECT SUBSTRING('foobarbar' FROM 4); -- 从第4位开始截取
        -> 'barbar'

    mysql> SELECT SUBSTRING('Quadratically',5,6); -- 从第5位开始截取,截取6个长度
        -> 'ratica'

    mysql> SELECT SUBSTRING('Sakila', -3);    -- 从倒数第3位开始截取
        -> 'ila'

    mysql> SELECT SUBSTRING('Sakila', -5, 3); -- 从倒数第5位开始截取,截取3个长度
        -> 'aki'
```

#### 四、日期和时间函数

```mysql
CURDATE()或CURRENT_DATE()		# 返回当前的日期
CURTIME()或CURRENT_TIME()		# 返回当前的时间
DAYOFWEEK(date)					 # 返回date所代表的一星期中的第几天(1~7)
DAYOFMONTH(date)  				 # 返回date是一个月的第几天(1~31)
DAYOFYEAR(date)   				 # 返回date是一年的第几天(1~366)
DAYNAME(date)   				 # 返回date的星期名，如：SELECT DAYNAME(CURRENT_DATE);
FROM_UNIXTIME(ts,fmt)  			 # 根据指定的fmt格式，格式化UNIX时间戳ts
HOUR(time)   					 # 返回time的小时值(0~23)
MINUTE(time)   					 # 返回time的分钟值(0~59)
MONTH(date)   					 # 返回date的月份值(1~12)
MONTHNAME(date)   				 # 返回date的月份名，如：SELECT MONTHNAME(CURRENT_DATE);
NOW()    					     # 返回当前的日期和时间
QUARTER(date)   				 # 返回date在一年中的季度(1~4)，如SELECT QUARTER(CURRENT_DATE);
WEEK(date)   					 # 返回日期date为一年中第几周(0~53)
YEAR(date)   					 # 返回日期date的年份(1000~9999)

重点:
DATE_FORMAT(date,format) 根据format字符串格式化date值

   mysql> SELECT DATE_FORMAT('2009-10-04 22:23:00', '%W %M %Y');
    -> 'Sunday October 2009'
   mysql> SELECT DATE_FORMAT('2007-10-04 22:23:00', '%H:%i:%s');
    -> '22:23:00'
   mysql> SELECT DATE_FORMAT('1900-10-04 22:23:00',
    ->                 '%D %y %a %d %m %b %j');
    -> '4th 00 Thu 04 10 Oct 277'
   mysql> SELECT DATE_FORMAT('1997-10-04 22:23:00',
    ->                 '%H %k %I %r %T %S %w');
    -> '22 22 10 10:23:00 PM 22:23:00 00 6'
   mysql> SELECT DATE_FORMAT('1999-01-01', '%X %V');
    -> '1998 52'
   mysql> SELECT DATE_FORMAT('2006-06-00', '%d');
    -> '00'
```

#### 五、加密函数

```mysql
MD5()    
    计算字符串str的MD5校验，这个加密过程是不可逆转的
    例如:
        SELECT MD5('1234') # 结果为：81dc9bdb52d04dc20036dbd8313ed055
PASSWORD(str)   
    返回字符串str的加密版本，这个加密过程是不可逆转的
    例如:
        SELECT PASSWORD('1234') # 结果为:*A4B6157319038724E3560894F7F932C8886EBFCF
```

#### 六、控制流函数            

```mysql
CASE WHEN[test1] THEN [result1]...ELSE [default] END
    如果testN是真，则返回resultN，否则返回default
CASE [test] WHEN[val1] THEN [result]...ELSE [default]END  
    如果test和valN相等，则返回resultN，否则返回default

IF(test,t,f)   
    如果test是真，返回t；否则返回f

IFNULL(arg1,arg2) 
    如果arg1不是空，返回arg1，否则返回arg2
    例如:
        SELECT IFNULL('bbb','abc'); 结果为: bbb
        SELECT IFNULL(null,'abc');  结果为: abc

NULLIF(arg1,arg2) 
    如果arg1=arg2返回NULL；否则返回arg1
    例如:
        SELECT NULLIF('bbb','bbb');结果为： null
        SELECT NULLIF('aaa','bbb');结果为： aaa
```



### 自定义函数

#### 定义函数

```mysql
# 语法
delimiter//
create function 函数名([参数名 参数类型])	# 定义函数
returns 返回值类型 # 设置返回值类型
begin
	# 函数逻辑
end//
delimiter;
```

##### 注意

- 函数中不要写sql语句（否则会报错），函数仅仅只是一个功能，是一个在sql中被应用的功能
- 若要想在begin...end...中写sql，请用存储过程

```mysql
delimiter//
create function func(i1 int, i2 int)
returns int
begin
	declare sum int default 0;
	set sum = i1+i2;
	return sum;
end//
delimiter;
```

默默的补一个练习

输入一个数，如果[0,60]返回D,[60,80]返回C,[80,90]返回B,[90,100]返回A

```mysql
delimiter//
create function func(nub int)
returns char(1)
begin
	if nub >= 90 then
		return 'A';
	elseif nub >= 80 then
		return 'B';
	elseif nub >=60 then
		return 'C';
	else
		return 'D';
	end if;
end//
delimiter;
```



#### 调用函数

```mysql
select func(5,3);

```

或

写在查询语句中

```mysql
select func1(1,3),id from person
```



#### 删除函数

```mysql
# 语法
drop function 函数名;
```

```mysql
drop function func;
```



## 函数和存储过程的区别

| 函数                                 | 存储过程                       |
| ---------------------------------- | -------------------------- |
| 一般用于计算数据                           | 完成特定的任务                    |
| 声明为FUNCTION                        | 声明为PROCEDURE               |
| 需要描述返回值类型，且PL/SQL中至少有一个有效的RETURN语句 | 无返回值类型，可通过OUT/INOUT参数返回多个值 |
| 不能独立运行，必须作为表达式的一部分                 | 可作为一个独立的PL/SQL语句运行         |
| 在DML和DQL中可调用函数                     | 在DML和DQL 中不可调用存储过程         |

DML	数据操作语句

DQL	数据查询语句



## 事物

### 什么是事物

一组SQL语句执行，要么全部成功，要么全不成功

### 事物的特性

**ACID** 原子性（Atom）、一致性（Consistent）、隔离性（Isolate）、持久性（Durable）

- 原子性：
  - 对于其数据修改，要么全都执行，要么全都不执行。
- 一致性：
  - 数据库原来有什么样的约束，事务执行之后还需要存在这样的约束，所有规则都必须应用于事务的修改，以保持所有数据的完整性。
- 隔离性：
  - 一个事务不能知道另外一个事务的执行情况（中间状态）
- 持久性：
  - 即使出现致命的系统故障也将一直保持。

### 注意事项

- 在mysql中只有使用innodb数据库引擎的数据库或表才支持事物
- 事物处理可以用于维护数据库的完整性，保证成批的sql语句要么全部执行，要么全不执行
- 事物用来管理 insert、update、delete语句

### 事物控制语句

- BEGIN或 START TRANSACTION 显式开启一个事物
- COMMIT也可以使用COMMIT WORK 二者是等价的。COMMIT 会提交事物，并使已对数据库进行的所有修改成为永久性的
- ROLLBACK 也可以使用ROLLBACK WORK二者是等价的。回滚会结束用户的事务，并撤销正在进行的所有未提交的修改
- SAVEPOINT 保存点,可以把一个事物分割成几部分.在执行ROLLBACK 时 可以指定在什么位置上进行回滚操作

注意： SET AUTOCOMMIT=0 禁止自动提交 和 SET AUTOCOMMIT=1开启自动提交



### 使用事物

#### 准备数据

```mysql
create table account(
    id int(50) not null auto_increment primary key,
    name VARCHAR(50) not null,
    money DOUBLE(8,2) not NULL
);

insert into account (name,money) values('鲁班',250),('后羿',5000);
```

#### 使用事物

##### 使用事物进行提交

```mysql
start TRANSACTION;
update account set money = money+500 where id=1;
update account set money = money-500 where id=2;
commit;

select * from account;
```

##### 使用事物进行回滚

```mysql
start transaction;
update account set money = money+500 where id=1;
update account set money = money-500 where id=2;
rollback;
```

##### 使用保存点

```mysql
START TRANSACTION ;
insert into account (name,money) values('李元芳',1000);
SAVEPOINT s1; -- 设置保存点
insert into account (name,money) values('张桂枝',1500);
ROLLBACK to s1; -- 事物回滚到保存点<br>COMMIT; --提交事物
```



### 注意

- 函数中不能写事物
- 存储过程中可以使用事物

#### 存储过程中使用事物

```mysql
create procedure p1(out flag char(1))
begin
	declare m int default 0;
	start TRANSACTION;
	update account set money = money-500 where id=1;
	update account set money = money+500 where id=2;
	select money into m from account where id=1;
	if  m > 0 then
		commit;
		set flag = 'T';
	else
		rollback;
		set flag = 'F';
	end if;
end;


set @flag='F';
call p1(@flag);
select @flag;
select * from account;
```



## 数据库锁

### 锁的概念

当并发事务同时访问一个资源时，有可能导致数据不一致，因此需要一种机制来将数据访问顺序化，以保证数据库数据的一致性。

### InnoDB行锁实现方式

innoDB的行级锁分为两种类型：共享锁（乐观所）和排他锁（悲观锁）



#### 排他锁（悲观锁）

每次去拿数据的时候都认为别人会修改，所以每次在拿数据的时候都会上锁，这样别人想拿这个数据就会block(阻塞)直到它拿到锁。传统的关系型数据库里边就用到了很多这种锁机制.

##### 注意：

要使用悲观锁，我们必须关闭mysql数据库的自动提交属性.因为MySQL默认使用autocommit模式，也就是说，当你执行一个更新操作后，MySQL会立刻将结果进行提交。关闭自动提交命令为：set autocommit=0;

##### 使用锁

```mysql
# 加锁
for update
```



模拟多人同时操作一条数据

```mysql
-- 0.开始事务
start transaction;
 
-- 1.查询账户余额
set @m = 0; -- 账户余额
select money into @m from account where id = 1 for update;
select @m;
 
-- 2.修改账户余额
update account set money = @m -100 where id = 1;
 
select * FROM account where id = 1;
-- 3. 提交事务
commit;
```

在另外的查询页面执行:

```mysql
-- 0.开始事务
start transaction;
 
-- 1.查询账户余额
set @m = 0; -- 账户余额
select money into @m from account where id = 1 for update;
select @m;
 
-- 2.修改账户余额
update account set money = @m +100 where id = 1;
 
select * FROM account where id = 1;
-- 3. 提交事务
commit;	
```

会发现当前查询会进入到等待状态,不会显示出数据,当上面的sql执行完毕提交事物后,当前sql才会显示结果.

注意1:在使用悲观锁时,如果表中没有指定主键,则会进行锁表操作.

注意2: 悲观锁的确保了数据的安全性，在数据被操作的时候锁定数据不被访问，但是这样会带来很大的性能问题。因此悲观锁在实际开发中使用是相对比较少的。　　

#### 共享锁

每次去拿数据的时候都认为别人不会修改，所以不会上锁，但是在更新的时候会判断一下在此期间别人有没有去更新这个数据，可以使用版本号等机制。　

##### 使用乐观锁的两种方式:

###### 方式一

　　1.使用数据版本（Version）记录机制实现，这是乐观锁最常用的一种实现 方式。何谓数据版本？即为数据增加一个版本标识，一般是通过为数据库表增加一个数字类型的 “version” 字段来实现。当读取数据时，将version字段的值一同读出，数据每更新一次，对此version值加一。当我们提交更新的时候，判断数据库表对应记录 的当前版本信息与第一次取出来的version值进行比对，如果数据库表当前版本号与第一次取出来的version值相等，则予以更新，否则认为是过期数 据。

```mysql
-- 1.查询账户余额
set @m = 0; -- 账户余额
select money into @m from account where id = 1 ;
select @m;
-- 2.查询版本号
set @version = 0; -- 版本号
select version into @version from account where id = 1 ;
select @version;
 
-- 3.修改账户余额
update account set money = @m -100,version=version+1 where id = 1 and version = @version;
 
select * FROM account where id = 1;
```

###### 方式二

​	2.乐观锁定的第二种实现方式和第一种差不多，同样是在需要乐观锁控制的table中增加一个字段，名称无所谓，字段类型使用时间戳 （datatime）, 和上面的version类似，也是在更新提交的时候检查当前数据库中数据的时间戳和自己更新前取到的时间戳进行对比，如果一致则OK，否则就是版本冲突。

#### **悲观锁与乐观锁的优缺点:**

两种锁各有其有点缺点,不能单纯的讲哪个更好.

- 乐观锁适用于写入比较少的情况下，即冲突真的很少发生的时候，这样可以省去了锁的开销，加大了系统的整个吞吐量。
- 但如果经常产生冲突，上层应用会不断的进行重试操作，这样反倒是降低了性能，所以这种情况下用悲观锁就比较合适.



InnoDB的锁定模式实际上可以分为四种：共享锁（S），排他锁（X），意向共享锁（IS）和意向排他锁（IX）。我们可以通过以下表格来总结上面这四种所的共存逻辑关系：

|           | 共享锁(S) | 排他锁(X) | 意向共享锁(IS) | 意向排他锁(IX) |
| --------- | ------ | ------ | --------- | --------- |
| 共享锁(S)    | 兼容     | 冲突     | 兼容        | 冲突        |
| 排他锁(X)    | 冲突     | 冲突     | 冲突        | 冲突        |
| 意向共享锁(IS) | 兼容     | 冲突     | 兼容        | 兼容        |
| 意向排他锁(IX) | 冲突     | 冲突     | 兼容        | 兼容        |



#### 注意

- 在不通过索引条件查询的时候，InnoDB确实使用的是表锁，而不是行锁
- 由于MySQL的行锁是针对索引加的锁，不是针对记录加的锁，所以虽然是访问不同行的记录，但是如果是使用相同的索引键，是会出现锁冲突的。
- 当表有多个索引的时候，不同的事务可以使用不同的索引锁定不同的行，另外，不论是使用主键索引、唯一索引或普通索引，InnoDB都会使用行锁来对数据加锁
- 即便在条件中使用了索引字段，但是否使用索引来检索数据是由MySQL通过判断不同执行计划的代价来决定的，如果MySQL认为全表扫描效率更高，比如对一些很小的表，它就不会使用索引，这种情况下InnoDB将使用表锁，而不是行锁。因此，在分析锁冲突时，别忘了检查SQL的执行计划，以确认是否真正使用了索引



