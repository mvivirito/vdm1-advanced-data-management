# vdm1-advanced-data-management

### Introduction

I am currently working on my Bachelors in Computer Science at WGU and this project is for my Advanced Data Managemnt course. 

## DVD Database

### Project Information

The task of this project is to summarize one real-world business report that can be created from the provided database of a movie rental company. 

## 1. Describe The Dataset

The provided dataset includes information such as customer information, film information, store information, etc.

We can dig into the psql command line tool to see exactly what we are working with. Navigate to the bin directory of your postgresql installation and run the psql command. Since I am on a mac, I have installed the pgadmin and postgresql bundle. They have a provided binary to launch the binary directly. We will run some commands to get more information about our database. First we will login to the postgresql sever with the provided tool. 

![](images/psql.png)

```bash
Server [localhost]: 
Database [postgres]: 
Port [5433]: 
Username [postgres]: 
Password for user postgres:********* 

psql (13.5)
Type "help" for help.

postgres=# 
```

# ERD Diagram

Here is a detailed view of the dataset

![](images/erd.png)



