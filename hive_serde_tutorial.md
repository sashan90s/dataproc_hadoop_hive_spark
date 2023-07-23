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
CREATE TABLE test (
 id string,
 hivearray array<binary>,
 hivemap map<string,int>) 
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.MultiDelimitSerDe'                  
WITH SERDEPROPERTIES ("field.delim"="[,]","collection.delim"=":","mapkey.delim"="@");


