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


### static partitioning

we need to first set the property for static partitioning

```
set hive.mapred.mode=strict;
```

```
create table automobile_sales_static_part
(
ORDERNUMBER int, 
QUANTITYORDERED int,
SALES float,
YEAR_ID int
)

partitioned by (COUNTRY string);

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
### dynamic partitioning
it is not a default paritioning system on hive. That is why you have to first enable it

```
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

```