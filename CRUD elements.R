#import the RMySQL library for connection with mySQL
library(RMySQL)
#connect to mySQL database called project with the given user and password
con<-dbConnect(MySQL(),user="root",password="password",host="localhost",dbname="project")
con
#get information about the mySQL driver
dbGetInfo(con)
#list tables of the database
dbListTables(con)
dbSendQuery(con,"CREATE TABLE students(id INT AUTO_INCREMENT PRIMARY KEY,first_name VARCHAR(50) not NULL,last_name VARCHAR(50),email VARCHAR(50) not NULL,phone_number VARCHAR(50), date_of_birth datetime,city VARCHAR(50),state VARCHAR(50),country VARCHAR(50));")
dbListTables(con)
#list of columns on a table
dbListFields(con,"students")
#create tables
dbSendQuery(con,"CREATE TABLE education_status(id INT AUTO_INCREMENT PRIMARY KEY,student_id int,institution_name VARCHAR(50),country VARCHAR(50),state VARCHAR(50),city VARCHAR(50),major VARCHAR(50),degree_type VARCHAR(50),from_date datetime,to_date datetime,FOREIGN KEY (student_id) references students(id) ON DELETE CASCADE);")
dbSendQuery(con,"CREATE TABLE contact_information(id INT AUTO_INCREMENT PRIMARY KEY,student_id int,first_name VARCHAR(50) not NULL,last_name VARCHAR(50), email VARCHAR(50) not NULL,phone_number VARCHAR(50),city VARCHAR(50),state VARCHAR(50),country VARCHAR(50),FOREIGN KEY (student_id) references students(id) ON DELETE CASCADE);")
dbListTables(con)
#create data
res<-dbSendQuery(con, "INSERT INTO students(first_name,last_name,email,phone_number,date_of_birth,city,state,country) VALUES('Abebe','Kebede','kebede@gmail.com','09876545779','2007-11-11','addis ababa','addis ababa','ethiopia');")
res
dbSendQuery(con, "INSERT INTO students(first_name,last_name,email,phone_number,date_of_birth,city,state,country) VALUES('beza','abebe','beza@gmail.com','095679764','2000-10-10','addis ababa','addis ababa','Ethiopia');")
dbSendQuery(con, "INSERT INTO education_status(student_id,institution_name,country,state,city,major,degree_type,from_date,to_date) VALUES(1,'Addis Ababa Institute','Ethiopia','addis ababa','addis ababa','software engineering','Bsc','2010-11-11','2016-11-11');")
dbSendQuery(con, "INSERT INTO education_status(student_id,institution_name,country,state,city,major,degree_type,from_date,to_date) VALUES(1,'Abyot Kirs','Ethiopia','addis ababa','addis ababa','natural','High School Diploma','2008-11-11','2010-11-11');")
dbSendQuery(con, "INSERT INTO contact_information(student_id,first_name,last_name,email,phone_number,city,state,country) VALUES(1,'Helen','kebede','helen@gmail.com','0976545678','addis ababa','addis ababa','Ethiopia');")
#read
result <- fetch(dbSendQuery(con,"select * from students;"))
result
result1 <- fetch(dbSendQuery(con,"select first_name,last_name,email,phone_number,institution_name from students, education_status where education_status.student_id = students.id;"))
result1
result3 <- fetch(dbSendQuery(con,"select * from students inner join contact_information on contact_information.student_id = students.id;"))
result3
#update student table of row
dbSendQuery(con,"update students set first_name='belelign',last_name='someone' where id=1;")
result <- fetch(dbSendQuery(con,"select first_name,last_name,email,phone_number,institution_name from students, education_status where education_status.student_id = students.id;"))
result
#delete
result<-fetch(dbSendQuery(con,"SELECT * from education_status;"))
result
dbSendQuery(con,"DELETE from education_status where institution_name = 'Abyot Kirs';")
result<-fetch(dbSendQuery(con,"SELECT * from education_status;"))
result
dbSendQuery(con,"DELETE from students where id = 1;")
result<-fetch(dbSendQuery(con,"SELECT * from students inner join education_status on education_status.student_id = students.id;"))
result

#read rows
student<-fetch(dbSendQuery(con,"SELECT * from students;"))
student
#add column age
student$age = floor(as.double(difftime(Sys.Date(),student$date_of_birth,units = "days"))/365)
student
#group by age
students_group <- vector(mode = 'character',length = length(student$age))
students_group
students_group[student$age < 18] = "young"
students_group
students_group[student$age >= 18 & student$age <50 ] = "adult"
students_group
students_group[student$age >= 50] = "old"
category <- factor(students_group,levels = c("young","adult","old"),ordered = TRUE)
category
#add column
student<- cbind(student,category)
student
head(student)
summary(student)
tail(student)
#write data frame to table
dbWriteTable(con,"new_students",student,overwrite = TRUE)
result<-fetch(dbSendQuery(con,"SELECT * FROM new_students"));
result
