# MySQL约束

## 五种完整性约束

约束是一种限制，他通过对表的行或列的数据做出限制，来确保表的数据的完整醒、唯一性	

### 非空约束

NOT NULL：非空约束 指定某列不能为空

#### 创建一个非空约束

```mysql
create table db1(
	id int not null,
  	name varchar(30) default 'asd' not null,
  	age int null
)
```

#### 取消非空约束

```mysql
alter table db1 modify name varchar(30) default 'asd'
```

或

```mysql
alter table db1 change name name varchar(30) default 'asd'
```

#### 添加一个非空约束

```mysql
alter table db1 add modify age int not null
```

或

```mysql
alter table db1 change age age int not null
```



### 唯一约束

UNIQUE： 唯一约束 指定某列不能重复

#### 列级约束语法建立约束

```mysql
create table test_unique(
	id int not null unique,
	age int 
)
```

```mysql
insert into test_unique values(1,2);	# success
insert into test_unique values(2,2);	# success
insert into test_unique values(2,3);	# [Err] 1062 - Duplicate entry '2' for key 'id'
```

#### 表级约束语法建立约束

```mysql
create table unique_test1(
	id int not NULL,
	test_name varchar(255),
	test_pass varchar(255),
	constraint test_unique unique(id,test_name)
)
```

#### 添加唯一约束

```mysql
alter table unique_test1 add unique(id)
```

或

```mysql
alter table unique_test1 modify id int not null unique
```



#### 删除唯一约束

```mysql
alter table unique_test1 drop index test_unique
```

或

```mysql
alter table unique_test1 modify id int not null
```



### 主键约束

PRIMARY KEY：主键 指定该列的值可以唯一的标识该列记录

- 主键约束相当于非空约束和唯一约束。
- 每个表只允许拥有一个主键，但是这个主键可以由多个数据列组成，这些列组合不能重复
- 标准SQL 允许给主键自行命名，但是对于MySQL来说自己的名字没有任何意义，总是默认为PRIMARY

简单说：主键这一行的数据**不能重复**且**不能为空**。



#### 列级约束语法建立约束

```mysql
create table test_primary(
	id int not null primary key,
	name varchar(50)
)
```

#### 表级约束语法建立约束

```mysql
create table primary_test2(
	id int not null,
	name varchar(50),
	constraint test_pk primary key(id)
  	# 指定主键约束为 test_pk ，对大部分数据库有效 但对于MySql无效，此主键约束名仍为PRIMARY
)
```

#### 创建复合主键

主键不仅可以是一列，也可以由表中的两列或多列来共同标识。——复合主键

```mysql
create table primary_test3(
	id int not null,
  	name varchar(50) not null,
  	primary key(id,name)
)
```

主键列自增长特性：如果某个数据列的类型是整型，而且该列作为主键列，则可指定该列具有自增长功能

#### 列级约束语法添加主键

```mysql
alter table primary_test2 modify id int not null primary key
```

#### 表级约束语法添加主键

```mysql
alter table primary_test2 add primary key(id,name)
```

#### 删除主键

```mysql
alter table primary_test2 drop primary key
```

##### 注意

```mysql
# 如果该主键具有自增特性，则在删除主键前需要将自增特性取消，在删除主键
alter table primary_test2 modify id int not null, drop primary key
```





### 外键约束

FOREIGN KEY：外键 指定该行记录从属主表的一条记录，用于参照完整性

#### 定义外键的条件

- 外键对应的字段数据类型保持一致,且被关联的字段(即references指定的另外一个表的字段)，必须保证唯一
- 所有tables的存储引擎必须是InnoDB类型.
- 外键的约束4种类型: 1.RESTRICT 2. NO ACTION 3.CASCADE 4.SET NULL
- 建议
  1. 如果需要外键约束,最好创建表同时创建外键约束.
  2. 如果需要设置级联关系,删除时最好设置为 SET NULL.

#### 创建外键约束

```mysql
CREATE TABLE IF NOT EXISTS dept (
    did int not null auto_increment PRIMARY KEY,
    dname VARCHAR(50) not null COMMENT '部门名称'
)ENGINE=INNODB DEFAULT charset utf8;
   
CREATE TABLE IF NOT EXISTS person(
    id int not null auto_increment PRIMARY KEY,
    name VARCHAR(50) not null,
    age TINYINT(4) null DEFAULT 0,
    sex enum('男','女') NOT NULL DEFAULT '男',
    salary decimal(10,2) NULL DEFAULT '250.00',
    hire_date date NOT NULL,
    dept_id int(11) DEFAULT NULL,
　  FOREIGN KEY(dept_id) REFERENCES dept(did) -- 添加外键约束
 	#如果使用表级约束语法，则需要使用foreign key指定本表的外键列，如果创建外键约束时没有指定约束名，   
	#则mysql会为该外键约束命名为table_name_ibfk_n,其中table_name是从表的表名，n是从1开始的整数  
)ENGINE = INNODB DEFAULT charset utf8;
```

#### 建立多列组合外键约束 

```mysql
create table teacher_tb(
	name varchar(255),
  	pass varchar(255),
  	primary key(name,pass)
);

create table student_tb(
	id int auto_increment not null primary key,
  	name varchar(50) not null,
  	py_pass varchar(255),
  	py_name varchar(255),
  	constraint fk_stu foreign key(py_pass,py_name) references teacher_tb(name,pass)
)
```

#### 删除外键约束

```mysql
alter table student_tb drop foreign key fk_stu
```

#### 添加外键约束

```mysql
alter table student_tb add foreign key (py_pass,py_name) references teacher_tb(name,pass)
```

#### 外键约束参照自身，自约束

    1. CASCADE: 从父表中删除或更新对应的行，同时自动的删除或更新自表中匹配的行。ON DELETE CANSCADE和ON UPDATE CANSCADE都被InnoDB所支持。

     2. SET NULL: 从父表中删除或更新对应的行，同时将子表中的外键列设为空。注意，这些在外键列没有被设为NOT NULL时才有效。ON DELETE SET NULL和ON UPDATE SET SET NULL都被InnoDB所支持。

     3. NO ACTION: InnoDB拒绝删除或者更新父表。

     4. RESTRICT: 拒绝删除或者更新父表。指定RESTRICT（或者NO ACTION）和忽略ON DELETE或者ON UPDATE选项的效果是一样的。

```mysql
[constraint [foreign_key_name]] foreign key 
[index_name] index_col_name1[,index_col_name2..]) 
references tb_name (index_col_name1[,index_col_name..]) 
[ON DELETE RESTRICT | CASCADE | SET NULL | NO ACTION]
[ON UPDATE RESTRICT | CASCADE | SET NULL | NO ACTION]
```

##### 外键约束使用最多的两种情况：

1. 父表更新时子表也更新，父表删除时如果子表有匹配的项，删除失败；
2. 父表更新时子表也更新，父表删除时子表匹配的项也删除。

```
前一种情况，在外键定义中，我们使用ON UPDATE CASCADE ON DELETE RESTRICT；
后一种情况，可以使用ON UPDATE CASCADE ON DELETE CASCADE。
```

#### 注意

- 插入数据时，先插入主表中的数据，再插入从表中的数据。
- 删除数据时，先删除从表中的数据，再删除主表中的数据。

### 检查约束

CHECK:  指定一个布尔表达式，用于指定对应的值必须满足该表达式（mysql不支持check约束）  

```mysql
CREATE TABLE class(
  cla_id INT(6) AUTO_INCREMENT PRIMARY KEY,
  cla_name VARCHAR(30) NOT NULL UNIQUE,
  CHECK(cla_id>0)
);
```



### 其他约束

#### 默认值约束

DEFAULT： 默认值约束 指定某列的默认值

##### 创建时添加约束

```mysql
create table default_test(
	id int not null auto_increment primary key,
 	name varchar(25),
  	age int not null default 18
);
```

##### 添加默认值约束

```mysql
alter table default_test modify age int not null default 18
```

或

```mysql
alter table default_test change age age int not null default 18
```



##### 删除默认值约束

```mysql
 alter table default_test modify age int not null
```

或

```mysql
alter table default_test change age age int not null
```



#### 自增长约束

AUTO_INCREMENT: 该列数据自增长，与约束一起使用（与主键一起使用）。每个表中只能有一个自增长约束

##### 创建时添加自增长约束

```mysql
create table auto_test(
	id int not null auto_increment primary key,
 	name varchar(25)
);
```

##### 添加自增长约束

```mysql
alter table default_test modify id int not null auto_increment
```

##### 删除自增长约束

```mysql
alter table auto_test modify id int not null
```



#### 无符号约束

UNSIGNED: 无符号约束仅作用于数值类型

##### 创建时添加

```mysql
CREATE TABLE t_user(user_id INT(10) UNSIGNED);
```

##### 通过ALTER语句

```mysql
ALTER TABLE t_user MODIFY user_id INT(10) UNSIGNED;
ALTER TABLE t_user CHANGE user_id user_id INT(10) UNSIGNED;


ALTER TABLE t_user MODIFY user_id INT(10);
ALTER TABLE t_user CHANGE user_id user_id INT(10);
```





#### ZEROFILL（零填充）

##### 在创建表的时候添加

```mysql
create table zero_test(
	id int not null auto_increment primary key,
  	age int zerofill
);
```

##### 添加

```mysql
alter table zer_test modify age int zerofill
```

或

```mysql
alter table zer_test change age age int zerofill
```



##### 删除

```mysql
alter table zero_test modify age int
```

或

```mysql
alter table zero_test change age age int
```

