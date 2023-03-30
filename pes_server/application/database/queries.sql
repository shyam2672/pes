-- SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
-- SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
-- SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';


create table days(
day varchar(10),
	id integer
);

insert into days values('SUNDAY',0);
insert into days values('MONDAY',1);
insert into days values('TUESDAY',2);
insert into days values('WEDNESDAY',3);
insert into days values('THURSDAY',4);
insert into days values('FRIDAY',5);
insert into days values('SATURDAY',6);

create table syllabus(
    Batch serial Primary key,
    syllabus text not null,
    Remarks text not null
);


create table slots(
    slot_id serial Primary key,
    Pathshaala integer,
    Batch integer references syllabus(Batch) on delete cascade,
    Day varchar(10) not null,
    Description text,
    Time_Start time not null,
    Time_end time not null,
    Remarks text,
    UNIQUE (pathshaala, batch, day, time_start, time_end)
);

create table Volunteers(
    PES_ID varchar(30) Primary key,
    Password varchar(50) not null,
    Name varchar(30) not null,
    Phone varchar(10) not null,
    profession varchar(30) not null,
    Email varchar(40) not null,
    Pathshaala integer not null,
    Token text,
    fcm_token text,
    Status varchar(10) not null,
    address text not null,
    joining_date date not null
);

create table slot_attendance(
    Slot_ID integer references slots(slot_id) on delete cascade,
    PES_ID varchar(30) references Volunteers(PES_ID) on delete cascade,
    Date date not null
);


create table Volunteer_slots(
    PES_ID varchar(30) references Volunteers(PES_ID) on delete cascade,
    slot_id integer references slots(slot_id) on delete cascade
);

create table slot_change(
    PES_ID varchar(30) references Volunteers(PES_ID) on delete cascade,
    slot_id integer references slots(slot_id) on delete cascade
);

create table leaving_pehchaan(
    PES_ID varchar(30) references Volunteers(PES_ID) on delete cascade,
    reason text not null
);

create table notifications(
    n_id serial Primary key,
    Title text not null,
    Data text not null,
    post_time timestamp not null
);

create table new_notif(
    n_id integer references notifications(n_id) on delete cascade,
    PES_ID varchar(30) references Volunteers(PES_ID) on delete cascade
);

create table admins(
    admin_id text Primary key references volunteers(pes_id) on delete cascade,
    token text
);


create table applications(
    Name varchar(30) not null,
    Phone varchar(10) not null Primary key,
    profession varchar(30) not null,
    Email varchar(40) not null,
    address text not null,
    Pathshaala integer not null,
    text1 text not null,
    text2 text not null
);

create table student_needs(
    n_id serial Primary key,
    Data text not null,
    PES_ID varchar(30) references Volunteers(PES_ID) on delete cascade,
    Name varchar(30) ,
    Pathshaala integer not null,
    post_time timestamp not null
);

create index on new_notif (pes_id);
create index on new_notif (n_id);
create index on slot_change (pes_id);
create index on slot_attendance (pes_id);
create index on slot_attendance (Date);
create index on volunteer_slots (pes_id);
create index on volunteer_slots (slot_id);
create index on slots (batch);
create index on slots (pathshaala);
create index on volunteers (pathshaala);
create index on volunteers (status);



--datetime.now().strftime("%m-%d-%Y, %H:%M:%S")