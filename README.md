1) 
a) Cloudformation_temp is used to define all the resources I want in AWS to spin up a EC2,S3 and AWS Athena. Here cloudformation provisions the EC2 instance first, wait for that to be ready, and then create the DNS record if needed afterwards. CloudFormation_temp      orchestrates the provisioning of the desired resources.

b) Why I chose S3 - Athena:
Athena is a serverless query service that makes it easy to analyze large amounts of data stored in Amazon S3 using Standard SQL. I can simply point Athena at some data stored in Amazon Simple Storage Service (S3), identify the fields, run the queries, and get results in seconds. I need not build, manage, or tune a cluster or any other infrastructure, and the pay is only for the queries that I run. Behind the scenes, Athena also parallelizes my query, spreads it out across hundreds or thousands of cores, and delivers results in seconds.
Each Athena table can be comprised of one or more S3 objects; each Athena database can contain one or more tables. Because Athena makes direct references to data stored in S3, you can take advantage of the scale, flexibility, data durability, and data protection options that it offers, including the IAM policies to control access to data.

Hence, I have selected AWS S3 and AWS Athena to upload the census data in S3 and load the preprocessed data into AWS Athena.

2) 
To upload the Census Dataset into S3, following steps were performed. In the Upload - Select Files wizard, click Add Files.
Select all of the files you downloaded and extracted, and then click Open.
s3://inflows/county-to-county-2013-2017-current-residence-sort.xlsx
s3://inflows/county-to-county-2013-2017-previous-residence-sort.xlsx

3) 
We can do this in Transposit via a query, but I created a table manually.
Query Data is already present in the S3 bucket. We just need to create a database -> Choose a data source -> Add a table and enter schema information manually -> Commit the table.

4)
A sample query is run on a table created in AWS athena. Code is attached.

5)
