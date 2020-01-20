CREATE EXTERNAL TABLE IF NOT EXISTS sampledb.alabama (
State_Current_Residence,
COR_Year_Ago string,
CR_State_Code integer
)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
WITH SERDEPROPERTIES ( 
  'escapeChar'='\\', 
  'separatorChar'=',')  
LOCATION 's3://pranav-test-bucket-athena/C2CFlows/' 
TBLPROPERTIES (
  'has_encrypted_data'='false',
  'skip.header.line.count'='1'
); 

--After creating a table, we can now run an Athena query in the AWS console
select State_Current_Residence where CR_State_Code = 001;
