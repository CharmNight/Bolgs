# 慢查询日志

## 1.是什么

　　MySql的慢查询日志是MySQL提供的一种日志记录，它用来记录在MySQL中响应时间超过阀值的语句，具体指运行时间超过long_query_time值的SQL，则会被记录到慢查询日志中
　　long_query_time 的默认值为10，意思是运行10秒以上的语句。
　　由它来查看哪些SQL超出了我们的最大忍耐时间值，比如一条sql执行超过5秒种，我们就算慢SQL，希望能收集超过5秒的sql，结合之前explain进行全面分析。 　　

## 2.怎么用

### 1.说明

　　**默认情况下，MySQL数据库没有开启慢查询日志**，需要我们手动来设置这个参数。
　　**当然，如果不是调优需要的话，一般不建议启动该参数**，因为开启慢查询日志会或多或少带来一定的性能影响。慢查询日志支持将日志记录写入文件。

### 2.查看是否开启及如何开启

　　默认：`show variables like '%slow_query_log%';`
　　开启：`set global show_query_log=1;`，这个 **只对当前数据库生效**，如果MySQL重启后则会失效。如果要永久生效，必须修改配置文件my.cnf(其他系统变量也是如此)

### 3.开启慢查询后，什么样的SQL才会记录到慢查询日志里面呢？

　　这个是由参数long_query_time控制，默认情况下long_query_time的值为10秒，
　　命令：``show variables like ‘long_query_time%;’。可以使用命令修改，也可以在my.cnf参数里面修改。
　　假如运行时间正好等于 long_query_time 的情况，并不会被记录。也就是说，在mysql源码里是 **判断>long_query_time，而非>=**.

## 3.日志分析工具 mysqldumpslow

　　在生产环境中，如果要手工分析日志，查找、分析SQL，显然是个体力活，MySQL提供了日志分析工具 mysqldumpslow
查看 mysqldumpslow 的帮助信息：`mysqldumpslow --help`
　　s: 表示按何种方式排序
　　c: 访问次数
　　l: 锁定时间
　　r: 返回记录
　　t: 查询时间
　　al: 平均锁定时间
　　ar: 平均返回记录数
　　at: 平均查询时间
　　t: 返回前面多少条的数据
　　g: 后边搭配一个正则匹配模式，大小写不敏感的。

```mysql
得到返回记录集最多的10个SQL
mysqldumpslow -s r -t 10 /var/lib/mysql/show.log

得到访问次数最多的10个SQL
mysqldumpslow -s c -t 10 /var/lig/mysql/show.log

得到按照时间排序的前10条里面含有左连接的查询语句
mysqldumpslow -s t -t 10 -g "left join" /var/lig/mysql/show.log

另外建议在使用这些命令时结构 | 和more使用，否则有可能出现爆屏情况
mysqldumpslow -s r -t 10 /var/lig/mysql/show.log | more
```

## 4.show profile

　　这个是sql分析最强大的
　　默认情况下，参数处于关闭状态，并保存最近15次的运行结果

### 1.是什么

　　是mysql提供可以用来分析当前会话中语句执行的资源消耗情况。可以用于SQL的调优的测量

### 2.分析步骤

#### 1).是否支持，看看当前的mysql版本是否支持

　　　`show variables like 'profiling%'`

#### 2).开启功能，默认是关闭，使用前需要开启

　　　`set profiling=on`
#### 3).运行SQL
　　　`select * from emp group by id%10 limit 1500000`
　　　`select * from emp group by id%20 order by 5`
#### 4).查看结果，`show profiles`

```mysql
mysql> SHOW PROFILES;
+----------+----------+-------------------------------------------------------+
| Query_ID | Duration | Query                                                 |
+----------+----------+-------------------------------------------------------+
|        1 | 2.000088 | select * from emp group by id%10 limit 1500000        |
|        2 | 1.000136 | select * from emp group by id%20 order by 5           |
```

#### 5).诊断SQL，`show profile cpu, block io for query 2` 后的数字是 show profiles 里的query_id
参数备注：
　　all: 显示所有的开销信息
　　block io: 显示块IO相关开销
　　context switches: 上下文切换相关开销
　　cpu: 显示CPU相关开销信息
　　ipc: 显示发送和接收相关开销信息
　　memory: 显示内存相关开销信息
　　page faults: 显示页面错误相关开销信息
　　source: 显示和source_function, source_file, souce_line相关的开销信息
　　swaps: 显示交换次数相关开销的信息

#### 6).日常开发需要注意的结论
　　出现下一个情况，就很危险了。
　　　converting HEAP to MyISAM 查询结果太长，内存都不够用了往磁盘上搬了。
　　　Creating tmp table 创建临时表：copy数据到临时表，用完再删除
　　　Copying to tmp table on disk 把内存中临时表复制到磁盘，很危险！！！
　　　locaked

## 5.全局查询日志

永远不要在生产环境上打开，测试时可以
1、配置启用

```mysql
在mysql的my.cnf中，设置如下：
# 开启
general_log=1

# 记录日志文件的路径
general_log_file=/path/logfile

# 输出格式
log_output=FILE
```

2、编码启用

```mysql
mysql> set global general_log=1;
mysql> set global log_output='TABLE';
# 此后，你所编写的sql语句，将会记录到mysql库里的general_log表。

# 可以用下面的命令查看
mysql> select * from mysql.general_log;
```