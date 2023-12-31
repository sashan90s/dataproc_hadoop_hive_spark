# rm 8088
# namenode 9870
```
gcloud compute ssh hadoop-cluster-m ^
  --project=studied-theater-392515 ^
  --zone=us-east1-d -- -D 1080 -N




"C:\Program Files\Google\Chrome\Application\chrome.exe" ^
  --proxy-server="socks5://localhost:1080" ^
  --user-data-dir="%Temp%\hadoop-cluster-m" http://hadoop-cluster-m:8088

```
## gloud related:
```
gcloud auth login

gcloud config set project <project_id>
gcloud projects list
gcloud config set dataproc/region <value>
gcloud dataproc clusters
describe <cluster_name>
```

## how to copy from local to gcloud
```
gcloud compute scp path/to/local/file instance_name:path/inside/the/instanace


Name,Age,Address
John,25,"123 Main St, Apt 4"
Jane,30,"456 Park Ave, Suite 7"


## Create the Hive table with CSV SerDe and escapeChar property
CREATE TABLE my_csv_table (
  Name STRING,
  Age INT,
  Address STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\"",
  "escapeChar" = "\\"
)
STORED AS TEXTFILE;
```
## Load data from the CSV file into the Hive table
LOAD DATA LOCAL INPATH 'data.csv' INTO TABLE my_csv_table;

## Query the Hive table to see the result
SELECT * FROM my_csv_table;

## details about SERDE

In programming and many data formats, such as CSV, XML, or JSON, the backslash is often used as an escape character to indicate that the character following it should be treated literally. This means that the backslash itself is not part of the value; it is used to escape the character that follows it.

In the context of Hive's CSV SerDe, specifying quoteChar = "\"" tells Hive that the double quote (") should be treated as a literal character for quoting values in the CSV data. Since the double quote is itself used as the enclosing character for values in the CSV data, we use the backslash to escape it, indicating that the double quote should be treated as a literal character, not as the end of the quoted value.

To clarify, here's the usage of quoteChar = "\"" in the context of Hive's CSV SerDe:

quoteChar = "\"" means that the double quote (") should be used to enclose values in the CSV data, but to interpret the double quote as a literal character, we escape it with the backslash (\).

For example, a CSV value like "123 Main St, Apt 4" is enclosed within double quotes ("), and to represent this in the quoteChar property, we use \".

In summary, the backslash (\) in quoteChar = "\"" is used as an escape character to ensure that the double quote (") is treated as a literal character for quoting values in the CSV data. It allows us to specify the double quote as part of the quoteChar property without any ambiguity.

## multidelimited SERDE

```
CREATE TABLE test (
id string,
hivearray array<binary>,
hivemap map<string,int>) 
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.MultiDelimitSerDe'                  
WITH SERDEPROPERTIES ("field.delim"="[,]","collection.delim"=":","mapkey.delim"="@");
```






# loading from hdfs
```
hive> create table department_data
    > (
    > dept_id int,
    > dept_name string,
    > manager_id int,
    > salary int
    > )
    > row format delimited
    > fields terminated by ',';

load data inpath '/tmp/inputdata/depart_data.csv' into table department_data;
 --{in this case, data is moved from here into the warehouse folder of the hive warehouse in hdfs}

# loading from vm local

load data local inpath 'file:///home/s01312283999/depart_data.csv' into table department_data;
```
# loading by creating an external table
```
hive> create external table department_data_external
    > (
    > dept_id int,
    > dept_name string,
    > manager_id int,
    > salary int
    > )
    > row format delimited
    > fields terminated by ','
    > location '/tmp/inputdata/'; -- just give location, dont give the actual file ```

# working with datasets having array type
```
-- Sihan, 28, Hadoop:aws:hive

hive> create table employee
    > (
    > id int,
    > name string,
    > skills array<string>
    > )
    > row format delimited
    > fields terminated by ','
    > collection items terminated by ':' ;

you have to mention the type of data array holds.

load data local inpath 'file:///home/s01312283999/array_data.csv' into table employee;

collection means array's collection. stuffs put in array.

Results be like: 
 
101     Amit    ["HADOOP","HIVE","SPARK","BIG-DATA"]
102     Sumit   ["HIVE","OZZIE","HADOOP","SPARK","STORM"]
103     Rohit   ["KAFKA","CASSANDRA","HBASE"]

Important Querries: 

select id, name, skills[0] as primary_skills from employee;

hive> select
    > id, name, size(skills) as size_of_array,
    > array_contains(skills, "HADOOP") as knows_array,
    > sort_array(skills) as sorted_array
    > from employee;
Results:
101     Amit    4       true    ["BIG-DATA","HADOOP","HIVE","SPARK"]
102     Sumit   5       true    ["HADOOP","HIVE","OZZIE","SPARK","STORM"]
103     Rohit   3       false   ["CASSANDRA","HBASE","KAFKA"]
```
```
# working with map data. 
Before hive
101,Amit,age:21|gender:M


After hive
hive> create table employee_map_data
    > (
    > id int,
    > name string,
    > details map<string, string>
    > )
    > row format delimited
    > fields terminated by ','
    > collection items terminated by '|'
    > map keys terminated by ':';

load data local inpath 'file:///home/s01312283999/map_data.csv' into table employee_map_data;

Result
101     Amit    {"age":"21","gender":"M"}
102     Sumit   {"age":"24","gender":"M"}
103     Mansi   {"age":"23","gender":"F"}
select name, details["age"] as age from employee_map_data;
select * from employee_map_data where details["age"] = "21";
select * from employee_map_data where details["age"]="21" and details["gender"]="M";
```

# github classik tockenso
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

## taking a back up of a table

# start with creating a table

hive> create table sales_data_v2
    > (
    > p_type string,
    > total_sales int
    > )
    > row format delimited
    > fields terminated by ',';
load data local inpath 'file:///home/s01312283999/sales_data_raw.csv' into table sales_data_v2;

# then back up table
```
create table sales_data_v2_bkup as select * from sales
_data_v2;

## using CSV SERDE library
```
CREATE TABLE csv_table
(
name string,
location string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = ",",
   "quoteChar"     = "\"",
   "escapeChar"    = "\\"
)  
STORED AS TEXTFILE
tblproperties ("skip.header.line.count" = "1"); ```

-- this one worked
```

## wroking with Json files
```
CREATE TABLE json_table
(
name string,
id int,
skills array<string>
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
STORED AS TEXTFILE; 

load data local inpath 'file:///home/s01312283999/json_file.json' into table json_table;

```


## changing file editing permissions in hadoop
```hadoop fs -chmod -R 777 /tmp/locaiton_data/*```

## how to create a directory in hadoop
```
hadoop fs -mkdir -p /tmp/location_data
hadoop fs -copyFromLocal file:///home/s01312283999/locations.csv /tmp/location_data
```

# Steps in managed parquet tables

## creating an external table
```
hadoop fs -mkdir -p /tmp/location_data
hadoop fs -copyFromLocal file:///home/s01312283999/locations.csv /tmp/location_data
hadoop fs -chmod -R 777 /path/to/hdfs_directory/*
```
### step 1:
```
CREATE EXTERNAL TABLE test_drive_1
(
id int,
location string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "escapeChar"    = "\\"
)  
STORED AS TEXTFILE
LOCATION 'file:///tmp/location_data;
```
### step 2:

```
CREATE TABLE managed_parquet_table (
    id int,
    location string
)
STORED AS PARQUET;

```

### step 3:

```
INSERT INTO TABLE managed_parquet_table
SELECT * FROM test_drive_1;
```
Keep in mind that the managed Parquet table will store its data within the Hive warehouse, while the external table's data remains in its original location (HDFS directory in this case). If you no longer need the external table, you can drop it using the DROP TABLE command:

```
DROP TABLE test_drive_1;
```

### reading the data from inside the warehouse
you cannot really read this data, only serde libraries can help read it properly. 
```
hadoop fs -cat /user/hive/warehouse/hive_db.db/managed_parquet_table/000000_0

```

## ORC file format and hive for analytics

### creating the csv table inside the hive

```
create table automobile_sales_data 
(
ORDERNUMBER int, 
QUANTITYORDERED int,
PRICEEACH float,
ORDERLINENUMBER int,
SALES float,
STATUS string,
QTR_ID int,
MONTH_ID int,
YEAR_ID int,
PRODUCTLINE string,
MSRP int,
PRODUCTCODE string,
PHONE string,
CITY string,
STATE string,
POSTALCODE string,
COUNTRY string,
TERRITORY string,
CONTACTLASTNAME string,
CONTACTFIRSTNAME string,
DEALSIZE string 
) 
row format delimited 
fields terminated by ','  
tblproperties("skip.header.line.count"="1") ;

load data local inpath 'file:///home/s01312283999/sales_order_data.csv' into table automobile_sales_data;

set hive.cli.print.header=true;

```

### now put the data into the ORC file from the csv table
```
create table automobile_sales_data_orc
(
ORDERNUMBER int, 
QUANTITYORDERED int,
PRICEEACH float,
ORDERLINENUMBER int,
SALES float,
STATUS string,
QTR_ID int,
MONTH_ID int,
YEAR_ID int,
PRODUCTLINE string,
MSRP int,
PRODUCTCODE string,
PHONE string,
CITY string,
STATE string,
POSTALCODE string,
COUNTRY string,
TERRITORY string,
CONTACTLASTNAME string,
CONTACTFIRSTNAME string,
DEALSIZE string 
) 
stored as orc;


insert overwrite table automobile_sales_data_orc
select * from automobile_sales_data;

``` 
you can now go to this and doule check in the filesystem of the hive

```
hadoop fs -ls /user/hive/warehouse/hive_db.db/automobile_sales_data_orc
```

## let's do some simple operations
```
select
year_id,
sum(sales) as total_sales
from 
automobile_sales_data_orc
group by year_id;
```

let's compare the time taken

```
select
year_id,
sum(sales) as total_sales
from 
automobile_sales_data
group by year_id;

```
# partitioning of the table

In paritioning the hive table, we do everything the same, but the column you want to partition by, do not include them in the main list of column creation. Leave it to use with with Partition by (column name you want to partition by)


## static partitioning

we need to first set the property for static partitioning

```
set hive.mapred.mode=strict;
```
#### creating the table for static partitioning
```
create table automobile_sales_static_part
(
ORDERNUMBER int, 
QUANTITYORDERED int,
SALES float,
YEAR_ID int
)

partitioned by (COUNTRY string);


-- do this and see if it was successful

describe formatted automobile_sales_static_part;

```



we will create the paritions <i> individually, manually and we will load the data manually into those partitions </i>

```
load data inpath '/hdfs/path/to/file/' into table employees PARTITION (year='2023')

or

insert overwrite table employees 
PARTITION (year = '2023')
select 
name,
age
from
emp_data
where year = '2023';
```


Let's see this in action


```
-- we will insert data from another orc table that we previously created.


insert overwrite table automobile_sales_static_part
PARTITION (country = 'USA')
select 
ORDERNUMBER, 
QUANTITYORDERED,
SALES,
YEAR_ID
from
automobile_sales_data_orc
where COUNTRY = 'USA';
```

Up there, you do not need to mention country in the select statements because
that is not how we created it. We do not want to have a country column in the first place.
if you go to the sales_data_static_part table, you would see we did not specify any country column to have.

now you can go ahead and query it


## dynamic partitioning
it is not a default paritioning system on hive. That is why you have to first enable it

```
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

```
We will first create the dynamic table


```
create table automobile_sales_dynamic_part
(
ORDERNUMBER int, 
QUANTITYORDERED int,
SALES float,
YEAR_ID int
)

partitioned by (COUNTRY string);


--now lets load the data

insert overwrite table automobile_sales_dynamic_part
PARTITION (country)
select 
ORDERNUMBER, 
QUANTITYORDERED,
SALES,
YEAR_ID,
COUNTRY
from
automobile_sales_data_orc
; 

```

Did you notice we have here explicitly added the partitioning column, because 
hive would not know otherwise.

Now if you do the following you will see, in the datawarehouse, it has automatically created its partitions, and in plenty.
You did not have to do anything manually to create these paritions;

```
hadoop fs -ls /user/hive/warehouse/hive_db.db/automobile_sales_dynamic_part
```


Below shows all the files that has the partitions

```
drwxr-xr-x   - s01312283999 hadoop          0 2023-08-07 02:04 /user/hive/warehouse/hive_db.db/automobile_sales_dynamic_part/country=Finland
drwxr-xr-x   - s01312283999 hadoop          0 2023-08-07 02:04 /user/hive/warehouse/hive_db.db/automobile_sales_dynamic_part/country=France
drwxr-xr-x   - s01312283999 hadoop          0 2023-08-07 02:04 /user/hive/warehouse/hive_db.db/automobile_sales_dynamic_part/country=Germany
drwxr-xr-x   - s01312283999 hadoop          0 2023-08-07 02:04 /user/hive/warehouse/hive_db.db/automobile_sales_dynamic_part/country=Ireland
drwxr-xr-x   - s01312283999 hadoop          0 2023-08-07 02:04 /user/hive/warehouse/hive_db.db/automobile_sales_dynamic_part/country=Italy
drwxr-xr-x   - s01312283999 hadoop          0 2023-08-07 02:04 /user/hive/warehouse/hive_db.db/automobile_sales_dynamic_part/country=Japan
drwxr-xr-x   - s01312283999 hadoop          0 2023-08-07 02:04 /user/hive/warehouse/hive_db.db/automobile_sales_dynamic_part/country=Norway
drwxr-xr-x   - s01312283999 hadoop          0 2023-08-07 02:04 /user/hive/warehouse/hive_db.db/automobile_sales_dynamic_part/country=Philippines
drwxr-xr-x   - s01312283999 hadoop          0 2023-08-07 02:04 /user/hive/warehouse/hive_db.db/automobile_sales_dynamic_part/country=Singapore
drwxr-xr-x   - s01312283999 hadoop          0 2023-08-07 02:04 /user/hive/warehouse/hive_db.db/automobile_sales_dynamic_part/country=Spain
drwxr-xr-x   - s01312283999 hadoop          0 2023-08-07 02:04 /user/hive/warehouse/hive_db.db/automobile_sales_dynamic_part/country=Sweden
drwxr-xr-x   - s01312283999 hadoop          0 2023-08-07 02:04 /user/hive/warehouse/hive_db.db/automobile_sales_dynamic_part/country=Switzerland
drwxr-xr-x   - s01312283999 hadoop          0 2023-08-07 02:04 /user/hive/warehouse/hive_db.db/automobile_sales_dynamic_part/country=UK
drwxr-xr-x   - s01312283999 hadoop          0 2023-08-07 02:04 /user/hive/warehouse/hive_db.db/automobile_sales_dynamic_part/country=USA
```

## multilevel paritioning

```
create table automobile_sales_multilevel_part
(
ORDERNUMBER int, 
QUANTITYORDERED int,
SALES float 
)
partitioned by (COUNTRY string, YEAR_ID int);
```

Now lets load in the data;

```
insert overwrite table automobile_sales_multilevel_part
PARTITION (country, year_id)
select 
ORDERNUMBER, 
QUANTITYORDERED,
SALES,
COUNTRY,
YEAR_ID
from
automobile_sales_data_orc
; 
```

Now you will see each partition has one folder with the country name first and inside that it has other folders with year name.

```
hadoop fs -ls /user/hive/warehouse/hive_db.db/automobile_sales_multilevel_part/country=USA
```

Below is the result:

```
drwxr-xr-x   - s01312283999 hadoop          0 2023-08-07 02:17 /user/hive/warehouse/hive_db.db/automobile_sales_multilevel_part/country=USA/year_id=2003
drwxr-xr-x   - s01312283999 hadoop          0 2023-08-07 02:17 /user/hive/warehouse/hive_db.db/automobile_sales_multilevel_part/country=USA/year_id=2004
drwxr-xr-x   - s01312283999 hadoop          0 2023-08-07 02:17 /user/hive/warehouse/hive_db.db/automobile_sales_multilevel_part/country=USA/year_id=2005
```

# bucketing

## first start with creating a normal table
```
create table users
(
id int,
name string,
salary int,
unit string
)

ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = ",",
   "quoteChar"     = "\"",
   "escapeChar"    = "\\"
)  
STORED AS TEXTFILE;


load data local inpath 'file:///home/s01312283999/users.csv' into table users; 
```
## create another locations table

```
create table locations
(
id int,
location string
)

ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = ",",
   "quoteChar"     = "\"",
   "escapeChar"    = "\\"
)  
STORED AS TEXTFILE;


load data local inpath 'file:///home/s01312283999/locations.csv' into table locations; 
```

# enabling properties for bucketing; 
```
set hive.enforce.bucketing=true;
```

## how to create buckets
```
create table buck_users
(
id int,
name string,
salary int,
unit string
)

clustered by (id)
into 3 buckets;

insert overwrite table buck_users select * from users;

 
```

# joins

## Hive join enabling- Map Side Join

```
set hive.enforce.bucketing=true;
SET hive.auto.convert.join=true;
SET hive.mapjoin.smalltable.filesize=50000000; -- this is optional, useful if you want to use it to limit the small table size that is sent to the datanode
 
```
lets create tables with equal number of buckets 

```
create table buck_users
(
id int,
name string,
salary int,
unit string
)

clustered by (id)
sorted by (id)
into 2 buckets;

insert overwrite table buck_users select * from users;

create table buck_locations
( 
id int, 
location string 
) 
clustered by (id)
sorted by (id) 
into 2 buckets;

insert overwrite table buck_locations select * from locations; 
```
Even though you have mentioned sorted in here, it will not work in the current properties set up.
Because, current properties set up is enabled for map side join. 

Let's query witj a join in the map side join configuration.

## map side join

```
set hive.enforce.bucketing=true;
SET hive.auto.convert.join=true;

select * from buck_users u
INNER JOIN buck_locations l
ON u.id = l.id;

Congratulations... this is how the result will look like

<b>
--results
u.id    u.name  u.salary        u.unit  l.id    l.location
2       Sumit   200     DNA     2       BIHAR
3       Yadav   300     DNA     3       MP
6       Mahoor  200     FCS     6       GOA
1       Amit    100     DNA     1       UP
4       Sunil   500     FCS     4       AP
5       Kranti  100     FCS     5       MAHARASHTRA
Time taken: 14.49 seconds, Fetched: 6 row(s)
hive> 
</b>
```


## bucket map join

For the BUCKET MAP JOIN you aint have to do anything. you create the table in the same way...
all you have to do is set configuration for BUCKET MAP JOIN.

```
set hive.enforce.bucketing=true;
SET hive.auto.convert.join=true;
set hive.optimize.bucketmapjoin=true; 

-- we keep the joins same

select * from buck_users u
INNER JOIN buck_locations l
ON u.id = l.id;

```

## Sorted merge bucket map join

```
set hive.enforce.sortmergebucketmapjoin=false; 
set hive.auto.convert.sortmerge.join=true; 
set hive.optimize.bucketmapjoin = true; 
set hive.optimize.bucketmapjoin.sortedmerge = true;

select * from buck_users u
INNER JOIN buck_locations l
ON u.id = l.id;

```
In any of the cases, we did not see any reducer at all. But their internal optimization will have it.

map side join = One data set large enough/small enough 
Bucket map join = if you data is bucketized, not with same amount of buckets
Sorted Merge Bucket Map Join = Equal number of buckets and data is sorted inside the buckets