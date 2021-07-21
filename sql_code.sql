create table Student(sid varchar2(10) primary key, 
sname varchar2(20) not null, gpa float, major varchar2(10));

create table Course(cno varchar2(10) primary key, 
cname varchar2(20) not null, credits int, dept varchar2(10));

create table Reg(sid references Student(sid) on delete cascade, 
  cno references Course(cno) on delete cascade, 
  grade varchar2(2), 
  primary key (sid, cno));

insert into Student values('111', 'Joe', 3.6 , 'MIS');

insert into Student values('222', 'Jack', 3.4  , 'MIS');

insert into Student values('333', 'Jill', 3.2 , 'CS');

insert into Student values('444', 'Mary', 3.7 , 'CS');

insert into Student values('555', 'Peter', 3.8 , 'CS');

insert into Student values('666', 'Pat', 3.9,  'Math');

insert into Student values('777', 'Tracy', 4.0,  'Math');

insert into Course values('c101', 'intro', 3 , 'CS');

insert into Course values('m415', 'database', 4 , 'Bus');

insert into Course values('m215', 'programming', 4 , 'Bus');

insert into Course values('a444', 'calculus', 3 , 'Math');

insert into Course values('x111', 'Bad Course', 3, 'Math');

insert into Reg values('111', 'c101', 'A');

insert into Reg values('111', 'm215', 'B');

insert into Reg values('111', 'm415', 'A');

insert into Reg values('222', 'm215', 'B');

insert into Reg values('222', 'm415', 'B');

insert into Reg values('333', 'c101', 'A');

insert into Reg values('444', 'm215', 'C');

insert into Reg values('444', 'm415', 'B');

insert into Reg values('555', 'c101', 'B');

insert into Reg values('555', 'm215', 'B');

insert into Reg values('555', 'm415', 'A');

insert into Reg values('666', 'c101', 'A');

insert into Reg values('666', 'a444', 'A');

--	Find the students who have taken the database class but not the intro class. 


select distinct s.sname 
from student s, reg r, course c 
where s.sid = r.sid and r.cno = c.cno 
and c.cname = 'database' 
minus 
select distinct s.sname 
from student s, reg r, course c 
where s.sid = r.sid and r.cno = c.cno 
and c.cname = 'intro';

--Find the students who have not taken any courses 


select distinct s.* 
from student s 
minus 
select s.* 
from student s, reg r, course c 
where s.sid = r.sid and r.cno = c.cno;

--Find courses in which no student got a B 


select distinct c.* 
from student s, reg r, course c 
where s.sid = r.sid and r.cno = c.cno 
minus 
select distinct c.* 
from student s, reg r, course c 
where s.sid = r.sid and r.cno = c.cno 
and r.grade ='B';

--ind students who did not take any course offered by the Bus department 


select Distinct s1.* 
from student s1, reg r1 
where  s1.sid = r1.sid 
and s1.sid not in ( select r.sid from reg r, course c where r.cno = c.cno and c.dept = 'Bus');

--Find students who did not take any 4 credit hour course 


select Distinct s1.* 
from student s1, reg r1 
where  s1.sid = r1.sid 
and s1.sid not in ( select r.sid from reg r, course c where r.cno = c.cno and c.credits = 4);



--Find courses where every student got an A 


select * from course c, reg r1 where c.cno = r1.cno 
and c.cno not in ( select r.cno from reg r where r.grade !='A');

--ind students who got an A in all courses that they took 


select distinct s.* 
from student s, reg r1 
where s.sid = r1.sid 
and s.sid  not in ( select  r.sid from reg r, course c where r.cno = c.cno and r.grade != 'A');

--ind courses where every registered student has a GPA over 3.5 


select c.* 
from course c, reg r 
where c.cno = r.cno and 
 not exists ( select  s.* from reg r, student s where r.cno = c.cno and  r.sid = s.sid  and s.gpa < 3.5);

--ind courses where every student who got an A has a GPA over 3.5 


select Distinct c.* 
from course c, reg r1 
where c.cno = r1.cno and r1.grade = 'A' and 
 not exists ( select  s.* from reg r, student s where r.cno = c.cno and  r.sid = s.sid  and s.gpa <= 3.5 and r.grade ='A' );



--23.	Find students who took every course offered by the Bus Department 


select s.* 
from student s where not exists ( select c.* from course c where c.dept = 'Bus' 
and not exists( select r.* from reg r where r.sid = s.sid and r.cno =c.cno));

--Find students who got a B in every course offered by the Bus department 


select * from student s 
 where not exists ( select* from course c where c.dept ='Bus' 
and not exists ( select * from reg r where r.cno = c.cno and r.sid = s.sid and grade = 'B'));

