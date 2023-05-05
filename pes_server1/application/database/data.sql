
-- SET NAMES utf8mb4;

insert into Volunteers(PES_ID,Password,Name,Phone,profession,Email,Pathshaala,Status,address,joining_date) 
    values(1234, 'pwd1','Bharat','9876543210','UG','2019csb1081@iitrpr.ac.in',1,'Active','Satluj Hostel, IIT Ropar','2022-01-01');

insert into Volunteers(PES_ID,Password,Name,Phone,profession,Email,Pathshaala,Status,address,joining_date) 
    values(1235, 'pwd2','Nitish','9876543210','UG','2019csb1103@iitrpr.ac.in',2,'Active','Satluj Hostel, IIT Ropar','2022-01-01');
insert into Volunteers(PES_ID,Password,Name,Phone,profession,Email,Pathshaala,Status,address,joining_date) 
    values(12345, 'pwd2','Karan','9876543210','UG','2019csb1093@iitrpr.ac.in',1,'Active','Satluj Hostel, IIT Ropar','2022-01-01');

insert into Volunteers(PES_ID,Password,Name,Phone,profession,Email,Pathshaala,Status,address,joining_date) 
    values(12346, 'pwd2','Rajesh','9876543210','PG','2019csb1103@iitrpr.ac.in',2,'Active','Satluj Hostel, IIT Ropar','2022-01-01');

insert into Volunteers(PES_ID,Password,Name,Phone,profession,Email,Pathshaala,Status,address,joining_date) 
    values(1110, 'pwd2','Shyam','9876543210','PG','2020csb1110@iitrpr.ac.in',2,'Active','Satluj Hostel, IIT Ropar','2022-01-01');

insert into Volunteers(PES_ID,Password,Name,Phone,profession,Email,Pathshaala,Status,address,joining_date) 
    values(1113, 'pwd2','Prashant','9876543210','PG','2020csb1113@iitrpr.ac.in',2,'Active','Satluj Hostel, IIT Ropar','2022-01-01');


insert into Volunteers(PES_ID,Password,Name,Phone,profession,Email,Pathshaala,Status,address,joining_date) 
    values(1064, 'pwd2','Aditi','9876543210','PG','2020csb1064@iitrpr.ac.in',2,'Active','Raavi Hostel, IIT Ropar','2022-01-01');


insert into Syllabus values(1,'https://drive.google.com/u/0/uc?id=1-26GBpGF_B1QmqUAZcOi8b4CwDTaqrXL&export=download','1 to 3');
insert into Syllabus values(2,'https://drive.google.com/u/0/uc?id=1-26GBpGF_B1QmqUAZcOi8b4CwDTaqrXL&export=download','4 and 5');
insert into Syllabus values(3,'https://drive.google.com/u/0/uc?id=1-26GBpGF_B1QmqUAZcOi8b4CwDTaqrXL&export=download','6 to 8');
insert into Syllabus values(4,'https://drive.google.com/u/0/uc?id=1-26GBpGF_B1QmqUAZcOi8b4CwDTaqrXL&export=download','6 to 8');

insert into slots(slot_id,pathshaala,batch,day,time_start,time_end) values(default,1,1,'MONDAY','10:00','12:00');
insert into slots(slot_id,pathshaala,batch,day,time_start,time_end) values(default,1,3,'TUESDAY','10:00','12:00');
insert into slots(slot_id,pathshaala,batch,day,time_start,time_end) values(default,1,2,'WEDNESDAY','10:00','12:00');
insert into slots(slot_id,pathshaala,batch,day,time_start,time_end) values(default,1,3,'THURSDAY','10:00','12:00');
insert into slots(slot_id,pathshaala,batch,day,time_start,time_end) values(default,2,1,'MONDAY','13:00','15:00');
insert into slots(slot_id,pathshaala,batch,day,time_start,time_end) values(default,2,1,'TUESDAY','13:00','15:00');
insert into slots(slot_id,pathshaala,batch,day,time_start,time_end) values(default,2,2,'WEDNESDAY','13:00','15:00');
insert into slots(slot_id,pathshaala,batch,day,time_start,time_end) values(default,1,1,'FRIDAY','09:00','12:00');
insert into slots(slot_id,pathshaala,batch,day,time_start,time_end) values(default,2,3,'FRIDAY','13:00','15:00');
insert into slots(slot_id,pathshaala,batch,day,time_start,time_end) values(default,1,3,'SATURDAY','11:00','12:00');
insert into slots(slot_id,pathshaala,batch,day,time_start,time_end) values(default,2,3,'SATURDAY','10:00','11:30');

insert into volunteer_slots values('1234',1);
insert into volunteer_slots values('1234',2);
insert into volunteer_slots values('1234',4);
insert into volunteer_slots values('12345',2);
insert into volunteer_slots values('12345',7);
insert into volunteer_slots values('12345',8);
insert into volunteer_slots values('1235',3);
insert into volunteer_slots values('1235',5);
insert into volunteer_slots values('1234',6);
insert into volunteer_slots values('1235',8);
insert into volunteer_slots values('12345',9);
insert into volunteer_slots values('1234',10);
insert into volunteer_slots values('12345',11);


insert into admins values('1234','ew');
insert into admins values('1235','ew');
insert into admins values('12345','ew');
insert into admins values('1110','ew');
insert into admins values('1113','ew');
insert into admins values('1064','ew');


insert into slots(slot_id,pathshaala,batch,day,time_start,time_end) values(default,2,2,'SUNDAY','13:00','15:00');
insert into volunteer_slots values('1235',12);


insert into slots(slot_id,pathshaala,batch,day,time_start,time_end) values(default,2,4,'MONDAY','00:00','01:30');
insert into volunteer_slots values('12346',13);

insert into applications values('Chetan','9876543210','3rd yr UG','2019csb1103@iitrpr.ac.in','Satluj Hostel, IIT Ropar',1,'Answer1','Answer2');
insert into applications values('Aman','9876543211','3rd yr UG','2019csb1103@iitrpr.ac.in','Beas Hostel, IIT Ropar',2,'Answer 1','Answer 2');
insert into applications values('Dhruv','9876543212','2nd yr PG','2019csb1103@iitrpr.ac.in','Beas Hostel, IIT Ropar',1,'Answer 1','Answer 2');
insert into applications values('Kamal','9876543213','2nd yr PhD','2019csb1103@iitrpr.ac.in','Chenab Hostel, IIT Ropar',2,'Answer 1','Answer 2');

insert into student_needs values(1,'9876543213','1110','Shyam','2','2016-06-22 19:10:25-07');

insert into volunteer_outreach_slots values('1110',default,'school1','Science','description','2022-01-01','11:00','12:00','pending','remarks' );

insert into schools values(default,'school1','address of school' );




