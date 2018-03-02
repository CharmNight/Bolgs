# SQL逻辑查询语句执行顺序

## SQL语句定义顺序

看一段伪代码

```
SELECT DISTINCT <select_list>
FROM <left_table>
<join_type> JOIN <right_table>
ON <join_condition>
WHERE <where_condition>
GROUP BY <group_by_list>
HAVING <having_condition>
ORDER BY <order_by_condition>
LIMIT <limit_number>
```

## 准备测试

### 新建一个测试数据库TestDB

```mysql
CREATE DATABASE TestDB DEFAULT charset utf8;
```

### 创建测试表table1和table2

```mysql
CREATE TABLE table1(
     customer_id VARCHAR(10) NOT NULL,
     city VARCHAR(10) NOT NULL,
     PRIMARY KEY(customer_id)
 )ENGINE=INNODB DEFAULT CHARSET=UTF8;


 CREATE TABLE table2(
     order_id INT NOT NULL auto_increment,
     customer_id VARCHAR(10),
     PRIMARY KEY(order_id)
 )ENGINE=INNODB DEFAULT CHARSET=UTF8;
```

### 插入测试数据

```mysql
INSERT INTO table1(customer_id,city) VALUES('163','hangzhou');
INSERT INTO table1(customer_id,city) VALUES('9you','shanghai');
INSERT INTO table1(customer_id,city) VALUES('tx','hangzhou');
INSERT INTO table1(customer_id,city) VALUES('baidu','hangzhou');

INSERT INTO table2(customer_id) VALUES('163');
INSERT INTO table2(customer_id) VALUES('163');
INSERT INTO table2(customer_id) VALUES('9you');
INSERT INTO table2(customer_id) VALUES('9you');
INSERT INTO table2(customer_id) VALUES('9you');
INSERT INTO table2(customer_id) VALUES('tx');
INSERT INTO table2(customer_id) VALUES(NULL);
```

### 效果

```
mysql> select * from table1;
 +-------------+----------+
 | customer_id | city     |
 +-------------+----------+
 | 163         | hangzhou |
 | 9you        | shanghai |
 | baidu       | hangzhou |
 | tx          | hangzhou |
 +-------------+----------+
 4 rows in set (0.00 sec)

 mysql> select * from table2;
 +----------+-------------+
 | order_id | customer_id |
 +----------+-------------+
 |        1 | 163         |
 |        2 | 163         |
 |        3 | 9you        |
 |        4 | 9you        |
 |        5 | 9you        |
 |        6 | tx          |
 |        7 | NULL        |
 +----------+-------------+
 7 rows in set (0.00 sec)
```

### 准备SQL逻辑查询测试语句

```mysql
SELECT
    a.customer_id,
    COUNT(b.order_id) as total_orders
FROM table1 AS a  LEFT JOIN table2 AS b
ON a.customer_id = b.customer_id
WHERE a.city = 'hangzhou'
GROUP BY a.customer_id
HAVING count(b.order_id) < 2
ORDER BY total_orders DESC;   　
```

SQL语句解释: 获得来自杭州，并且订单数少于2的客户



## SQL逻辑查询语句执行顺序

下面在每条语句的前面都标明了执行顺序号

```
(7)     SELECT 
(8)     DISTINCT <select_list>
(1)     FROM <left_table>
(3)     <join_type> JOIN <right_table>
(2)     ON <join_condition>
(4)     WHERE <where_condition>
(5)     GROUP BY <group_by_list>
(6)     HAVING <having_condition>
(9)     ORDER BY <order_by_condition>
(10)    LIMIT <limit_number>
```

## SQL执行先后顺序分析

### 重点

在这些SQL语句的执行过程中，都会产生一个虚拟表，用来保存SQL语句的执行结果（这是重点），我们现在就来跟踪这个虚拟表的变化，得到最终的查询结果的过程，来分析整个SQL逻辑查询的执行顺序和过程。

### 1.执行FORM语句

第一步，执行`FROM`语句。我们首先需要知道最开始从哪个表开始的，这就是`FROM`告诉我们的。现在有了``和``两个表，我们到底从哪个表开始，还是从两个表进行某种联系以后再开始呢？它们之间如何产生联系呢？——笛卡尔积

经过FROM语句对两个表执行笛卡尔积，会得到一个虚拟表，暂且叫VT1（vitual table 1），内容如下：

```
+-------------+----------+----------+-------------+
| customer_id | city     | order_id | customer_id |
+-------------+----------+----------+-------------+
| 163         | hangzhou |        1 | 163         |
| 9you        | shanghai |        1 | 163         |
| baidu       | hangzhou |        1 | 163         |
| tx          | hangzhou |        1 | 163         |
| 163         | hangzhou |        2 | 163         |
| 9you        | shanghai |        2 | 163         |
| baidu       | hangzhou |        2 | 163         |
| tx          | hangzhou |        2 | 163         |
| 163         | hangzhou |        3 | 9you        |
| 9you        | shanghai |        3 | 9you        |
| baidu       | hangzhou |        3 | 9you        |
| tx          | hangzhou |        3 | 9you        |
| 163         | hangzhou |        4 | 9you        |
| 9you        | shanghai |        4 | 9you        |
| baidu       | hangzhou |        4 | 9you        |
| tx          | hangzhou |        4 | 9you        |
| 163         | hangzhou |        5 | 9you        |
| 9you        | shanghai |        5 | 9you        |
| baidu       | hangzhou |        5 | 9you        |
| tx          | hangzhou |        5 | 9you        |
| 163         | hangzhou |        6 | tx          |
| 9you        | shanghai |        6 | tx          |
| baidu       | hangzhou |        6 | tx          |
| tx          | hangzhou |        6 | tx          |
| 163         | hangzhou |        7 | NULL        |
| 9you        | shanghai |        7 | NULL        |
| baidu       | hangzhou |        7 | NULL        |
| tx          | hangzhou |        7 | NULL        |
+-------------+----------+----------+-------------+
```

总共有28（table1的记录条数 * table2的记录条数）条记录。这就是VT1的结果，接下来的操作就在VT1的基础上进行。

### 2.执行ON过滤

执行完笛卡尔积以后，接着就进行`ON a.customer_id = b.customer_id`条件过滤，根据`ON`中指定的条件，去掉那些不符合条件的数据，得到VT2表，内容如下：

```
+-------------+----------+----------+-------------+
| customer_id | city     | order_id | customer_id |
+-------------+----------+----------+-------------+
| 163         | hangzhou |        1 | 163         |
| 163         | hangzhou |        2 | 163         |
| 9you        | shanghai |        3 | 9you        |
| 9you        | shanghai |        4 | 9you        |
| 9you        | shanghai |        5 | 9you        |
| tx          | hangzhou |        6 | tx          |
+-------------+----------+----------+-------------+
```

T2就是经过`ON`条件筛选以后得到的有用数据，而接下来的操作将在VT2的基础上继续进行。

 

### 3.添加外部行

这一步只有在连接类型为`OUTER JOIN`时才发生，如`LEFT OUTER JOIN`、`RIGHT OUTER JOIN`。在大多数的时候，我们都是会省略掉`OUTER`关键字的，但`OUTER`表示的就是外部行的概念。

`LEFT OUTER JOIN`把左表记为保留表，得到的结果为：

```
+-------------+----------+----------+-------------+
| customer_id | city     | order_id | customer_id |
+-------------+----------+----------+-------------+
| 163         | hangzhou |        1 | 163         |
| 163         | hangzhou |        2 | 163         |
| 9you        | shanghai |        3 | 9you        |
| 9you        | shanghai |        4 | 9you        |
| 9you        | shanghai |        5 | 9you        |
| tx          | hangzhou |        6 | tx          |
| baidu       | hangzhou |     NULL | NULL        |
+-------------+----------+----------+-------------+
```

`RIGHT OUTER JOIN`把右表记为保留表，得到的结果为：

```
+-------------+----------+----------+-------------+
| customer_id | city     | order_id | customer_id |
+-------------+----------+----------+-------------+
| 163         | hangzhou |        1 | 163         |
| 163         | hangzhou |        2 | 163         |
| 9you        | shanghai |        3 | 9you        |
| 9you        | shanghai |        4 | 9you        |
| 9you        | shanghai |        5 | 9you        |
| tx          | hangzhou |        6 | tx          |
| NULL        | NULL     |        7 | NULL        |
+-------------+----------+----------+-------------+
```

添加外部行的工作就是在VT2表的基础上添加保留表中被过滤条件过滤掉的数据，非保留表中的数据被赋予NULL值，最后生成虚拟表VT3。

由于我在准备的测试SQL查询逻辑语句中使用的是`LEFT JOIN`，过滤掉了以下这条数据：

```
| baidu       | hangzhou |     NULL | NULL        |
```

现在就把这条数据添加到VT2表中，得到的VT3表如下：

```
+-------------+----------+----------+-------------+
| customer_id | city     | order_id | customer_id |
+-------------+----------+----------+-------------+
| 163         | hangzhou |        1 | 163         |
| 163         | hangzhou |        2 | 163         |
| 9you        | shanghai |        3 | 9you        |
| 9you        | shanghai |        4 | 9you        |
| 9you        | shanghai |        5 | 9you        |
| tx          | hangzhou |        6 | tx          |
| baidu       | hangzhou |     NULL | NULL        |
+-------------+----------+----------+-------------+
```

接下来的操作都会在该VT3表上进行。

### 4.执行WHERE过滤

对添加外部行得到的VT3进行WHERE过滤，只有符合<where_condition>的记录才会输出到虚拟表VT4中。当我们执行`WHERE a.city = 'hangzhou'`的时候，就会得到以下内容，并存在虚拟表VT4中：

```
+-------------+----------+----------+-------------+
| customer_id | city     | order_id | customer_id |
+-------------+----------+----------+-------------+
| 163         | hangzhou |        1 | 163         |
| 163         | hangzhou |        2 | 163         |
| tx          | hangzhou |        6 | tx          |
| baidu       | hangzhou |     NULL | NULL        |
+-------------+----------+----------+-------------+
```

但是在使用WHERE子句时，需要注意以下两点：

1. 由于数据还没有分组，因此现在还不能在WHERE过滤器中使用`where_condition=MIN(col)`这类对分组统计的过滤；
2. 由于还没有进行列的选取操作，因此在SELECT中使用列的别名也是不被允许的，如：`SELECT city as c FROM t WHERE c='shanghai';`是不允许出现的。

### 5.执行GROUP BY分组

`GROU BY`子句主要是对使用`WHERE`子句得到的虚拟表进行分组操作。我们执行测试语句中的`GROUP BY a.customer_id`，就会得到以下内容：

```
+-------------+----------+----------+-------------+
| customer_id | city     | order_id | customer_id |
+-------------+----------+----------+-------------+
| 163         | hangzhou |        1 | 163         |
| baidu       | hangzhou |     NULL | NULL        |
| tx          | hangzhou |        6 | tx          |
+-------------+----------+----------+-------------+
```

得到的内容会存入虚拟表VT5中，此时，我们就得到了一个VT5虚拟表，接下来的操作都会在该表上完成。

### 6.执行HAVING过滤

`HAVING`子句主要和`GROUP BY`子句配合使用，对分组得到的VT5虚拟表进行条件过滤。当我执行测试语句中的`HAVING count(b.order_id) < 2`时，将得到以下内容：



```
+-------------+----------+----------+-------------+
| customer_id | city     | order_id | customer_id |
+-------------+----------+----------+-------------+
| baidu       | hangzhou |     NULL | NULL        |
| tx          | hangzhou |        6 | tx          |
+-------------+----------+----------+-------------+
```

这就是虚拟表VT6。

### 7.SELECT列表

现在才会执行到`SELECT`子句，不要以为`SELECT`子句被写在第一行，就是第一个被执行的。

我们执行测试语句中的`SELECT a.customer_id, COUNT(b.order_id) as total_orders`，从虚拟表VT6中选择出我们需要的内容。我们将得到以下内容：

```
+-------------+--------------+
| customer_id | total_orders |
+-------------+--------------+
| baidu       |            0 |
| tx          |            1 |
+-------------+--------------+
```

不，还没有完，这只是虚拟表VT7。

### 8.执行DISTINCT子句

如果在查询中指定了`DISTINCT`子句，则会创建一张内存临时表（如果内存放不下，就需要存放在硬盘了）。这张临时表的表结构和上一步产生的虚拟表VT7是一样的，不同的是对进行DISTINCT操作的列增加了一个唯一索引，以此来除重复数据。

由于我的测试SQL语句中并没有使用DISTINCT，所以，在该查询中，这一步不会生成一个虚拟表。

### 9.执行ORDER BY子句

对虚拟表中的内容按照指定的列进行排序，然后返回一个新的虚拟表，我们执行测试SQL语句中的`ORDER BY total_orders DESC`，就会得到以下内容：

[![复制代码](http://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
+-------------+--------------+
| customer_id | total_orders |
+-------------+--------------+
| tx          |            1 |
| baidu       |            0 |
+-------------+--------------+
```

[![复制代码](http://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

可以看到这是对total_orders列进行降序排列的。上述结果会存储在VT8中。

### 10.执行LIMIT子句

`LIMIT`子句从上一步得到的VT8虚拟表中选出从指定位置开始的指定行数据。对于没有应用ORDER BY的LIMIT子句，得到的结果同样是无序的，所以，很多时候，我们都会看到LIMIT子句会和ORDER BY子句一起使用。

MySQL数据库的LIMIT支持如下形式的选择：

```
LIMIT n, m
```

表示从第n条记录开始选择m条记录。而很多开发人员喜欢使用该语句来解决分页问题。对于小数据，使用LIMIT子句没有任何问题，当数据量非常大的时候，使用`LIMIT n, m`是非常低效的。因为LIMIT的机制是每次都是从头开始扫描，如果需要从第60万行开始，读取3条数据，就需要先扫描定位到60万行，然后再进行读取，而扫描的过程是一个非常低效的过程。所以，对于大数据处理时，是非常有必要在应用层建立一定的缓存机制（貌似现在的大数据处理，都有缓存哦）.