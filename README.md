*** Question 1 ***

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
Athena is priced at $5 per TB (terabyte) scanned per query execution. There is a 10 MB data scanning minimum per execution. If I cancel a query, I am charged for the data scanned up to the point of cancelling the query.
Doing the math for my small query:
$5 / 1024 / 1024 = $4.768e-6

All DDL executions are free and in this case Amazon Athena is reading data stored in Amazon S3. There will be normal S3 data charges for the storage of that data, depending on how it’s stored.Amazon Athena stores query history and results in a secondary S3 bucket. So there will also be normal S3 data charges for that new data stored in that bucket as well.


*** Question 2***

1)
Since, I have already used Neo4j, I am inclined more towards neo4j because of the following:
Neo4j is open source, NEptune is commercial(as far as I know from website). Neo4j uses ACID model and supports in-memory sharding of the graph along natural chunks that can be kept hot on specific instances. Queries that map to those chunks can then be routed. Neptune offers visualization via partners which come with add-on costs. But Neo4j server comes with a powerful customizable graph visualization tool built-in D3.js library. On top of being an easy way to visualize graph data, it can be used for querying, adding data and creating relationships amongst other things.

2)
Given the csv files, I would batch the import into sections with periodic COMMIT in Neo4j. This clause is added before the LOAD CSV clause to tell the Cypher to only process so many rows of the file before clearing memory and transaction state. 
A sample:
USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM 'file:///county_to_county_prev_residence_sort.csv' AS row
MERGE (County_Code:SCR {County_Code: row.County_Code})
MERGE (MOE:Current_Residence {MOE: row.MOE})
 ON CREATE SET County_Code.name = row.County_Code
MERGE (County_Code)-[r:OWNED_BY]->(County_Code)

Design is based on the following:
A row is a node
A table name is a label name
A join or foreign key is a relationship
*Cypher’s LOAD CSV command can transform the contents of the CSV file into a graph structure.


3)
Writing a ER diagram in a graph database makes it easy to exploit relationships between elements in Flows datasets and makes it ideally suited to represent, query and manage the connected data. Neo4j graph database gives a property graph that depicts the dataset’s entities, or nodes, and the relationships that connect them. Given this flows dataset, Relationships are named connections between two entities in a graph which always has a start node, an end node, a direction and a type.
Like nodes, we can give relationships, properties. In this case, those properties are quantitative measures such as Estimate, MOE
for movers and non movers. I like Neo4j as, nodes can share any number or type of relationships without sacrificing performance and although relationships are directional, graph queries can navigate them in either direction.
We can have different natures of data relationships given this dataset. Some of them have a permanent life, like the County of Current Residence; some of them, like pointers, have a lifecycle and are supposed to store a state where we Find the next node, Delete the current pointer relationship and Create a new pointer relationship on the next node.




