QUERIES

a. select user.name,user.surname,etaireia.name,job.id as kodikos_thesis,job.salary,count(applies.job_id) as plithos_aithseon from user,recruiter,etaireia,requires,job,candidate,applies where user.username=recruiter.username and recruiter.username=job.recruiter and recruiter.firm=etaireia.afm and job.id=requires.job_id and candidate.username=applies.cand_usrname and applies.job_id=job.id group by job.id; 

b. select candidate.username,certificates,count(degree.titlos),avg(grade) 	from 	candidate 	inner 	join 	has_degree on candidate.username=has_degree.cand_usrname inner join degree on has_degree.degr_idryma=degree.idryma group by candidate.username having count(degree.titlos)>1; 
 
c. select candidate.username,count(applies.job_id) as plithos_aithseon from candidate inner join applies on candidate.username=applies.cand_usrname inner join job on applies.job_id=job.id group by candidate.username having avg(salary)>1800; 
 
d. select etaireia.name,job.position,antikeim.title from etaireia, recruiter, job, requires, antikeim where etaireia.afm=recruiter.firm and recruiter.username=job.recruiter and job.id=requires.job_id and requires.antikeim_title=antikeim.title and antikeim.title like '%program%'; 
 
e. select distinct a.username,b.plithos,c.plithoss,b.mesos from recruiter aLEFT JOIN (SELECT recruiter, count(id) as plithos, avg(salary) as mesos from job group by recruiter) b on a.username=b.recruiter LEFT JOIN (SELECT rusername, count(aa_interview) as plithoss from interview group by rusername)      c on a.username=c.rusername having b.plithos>2 order by a.username; 
 


 
STORED PROCEDURES

drop procedure if exists askp1; delimiter $ 
create procedure askp1(IN jid int) begin 
 	declare nf int;  	declare temp int;  	declare fin int;  	declare cu varchar(12);  	declare tot int;  	declare av float(6,1);  	declare ed int;  	declare ex int;  	declare pers int; 
declare result text; 
 	 	 
 	declare bcursor cursor for select completed from evaluation where job_id=jid; 
 declare bcursor2 cursor for select cusername,avg(personality),education,experience,(personality+education+experience) as total from evaluation where job_id=jid group by cusername order by total desc; 
 	 	 
 	declare continue handler for not found set nf=1; 
 	 
 	set nf=0;  	set fin=0; 
 	 
 	open bcursor; 
 	 
 	repeat 
 	fetch bcursor into temp; 
 	 
 	if(nf=0) then 
 	 	 
 	 	if (temp=0) then  
 	 	 	set fin=1; 
 	 	end if; 
 	end if;  	until (nf=1) 
 	end repeat; 
 	close bcursor;               
 	 
 	 
 	if (fin=1) then 
 	    select 'den exei oloklhrothei h axiologhsh' as '';  
 	else 
 	 
 	 	set nf=0;  
 	 	 
 	 	 
 	 	open bcursor2; 
 	 	repeat 
 	 	fetch bcursor2 into cu,pers,ed,ex,tot; 
 	 	set result=""; 
 	 	if(nf=0) then 
 	 	    
 	 	   if (pers=0) then 
 	 	      set result=(SELECT CONCAT(result," ","failed the interview") AS result);  	 	   end if; 
 	 	 	  
 	 	   if (ed=0) then 
 	 	      set result=(SELECT CONCAT(result," ","inadequate education") AS result); 
 	 	 	end if;  
 	 	 	 
 	 	 	if (ex=0) then   
 	 	 	   set result=(SELECT CONCAT(result," ","no prior experience") AS result);  	 	    end if; 
 	 	    
 	 	     select cu,pers,ed,ex,tot,result; 
 	 	    
 	 	end if; 
 	 	until (nf=1)  	 	end repeat; 
 	 	close bcursor2; 
 	 
 	 end if; end$ delimiter ; 
call askp1(1); 
 


 
 
TRIGGERS

drop trigger if exists candidatetrig1; delimiter $ 
create trigger candidatetrig1 before insert on candidate for each row begin 
 	DECLARE recordusername VARCHAR(12); 
 	SET recordusername = (SELECT username FROM candidate WHERE username = NEW.username); 
 
    IF recordusername IS NOT NULL 
    THEN 
       	insert into history values(NEW.username,now(),'Failure','insert','candidate'); 
  SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'INSERT on candidate failed due to duplicate candidates username'; 
 	ELSE 
 	 	insert into history values(NEW.username,now(),'Success','insert','candidate'); 
    END IF; end$ delimiter ; 
insert into candidate values ('zazahir23','kalos','exei polles','10 ceritificates','zazahir23');-->FAIL 
insert into candidate values ('zazahir24','kalos','exei polles','10 ceritificates','zazahir24');-->OK arkei na yparxei kataxorimenso TO USERNAME STO recruiter 
================================================================= 
 
drop trigger if exists candidatetrig2; delimiter $ 
create trigger candidatetrig2 before UPDATE on candidate for each row begin 
 	DECLARE recordusername VARCHAR(12); 
 	SET recordusername = (SELECT username FROM candidate WHERE username = NEW.username); 
 
 IF recordusername IS NOT NULL and new.bio=old.bio and new.sistatikes=old.sistatikes and new.certificates=old.certificates and new.password=old.password     THEN 
       	insert into history values(NEW.username,now(),'Failure','update','candidate'); 
  SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'UPDATE on candidate failed due to duplicate candidates username'; 
 ELSEIF recordusername IS NOT NULL and (new.bio<>old.bio or new.sistatikes<>old.sistatikes or new.certificates<>old.certificates or new.password<>old.password)then 
 	 	insert into history values(NEW.username,now(),'Success','update','candidate'); 
  SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'UPDATE on candidate failed due to duplicate candidates username'; 
    END IF; end$ delimiter ; update candidate set username='zazahir23' where username='zazahir23'; -->Fail update candidate set username='abrown' where username='zazahir23'; -->Fail update candidate set bio='my bio' where username='zazahir23'; -->OK 
update candidate set bio='old bio' where username='zazahir230'; -->DEN DOYLEYEI ==================================================================== drop trigger if exists candidatetrig3; delimiter $ 
create trigger candidatetrig3 before delete on candidate for each row 
begin 
 	DECLARE res int; 
 	set res=(SELECT count(1) FROM candidate WHERE username = 'abrownn'); 
 	 
 	if res=0 then  
 	 	insert into history values(NEW.username,now(),'Success','update','candidate'); 
 	SIGNAL SQLSTATE VALUE '45000' ; 
 	else 
 	 	insert into history values(NEW.username,now(),'Success','update','candidate');  	end if; 
end$ delimiter ; 
 
delete from candidate where username='abrownn';-->Fail delete from candidate where username='abrown';-->OK 
=========================================== 
------------------------------------------------------------- drop trigger if exists recruitertrig1; delimiter $ 
create trigger recruitertrig1 before insert on recruiter for each row begin 
IF (EXISTS(SELECT 1 FROM user WHERE username = NEW.username)) THEN  	insert into history values(NEW.username,now(),'Failure','insert','recruiter'); 
    SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'INSERT failed due to duplicate recruiters username'; else 
 	insert into history values(NEW.username,now(),'Success','insert','recruiter'); 
END IF; end$ 
delimiter ; 
 
insert into recruiter values ('bettyg',3,'beta','12345'); 
================================================================= 
 
drop trigger if exists recruitertrig2; delimiter $ 
create trigger recruitertrig2 before update on recruiter for each row begin if ((select count(*) from recruiter where new.username = old.username)=0) then  	insert into history values(NEW.username,now(),'Failure','update','recruiter'); 
    SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'UPDATE failed on recruiter due to non existent username'; else 
 	insert into history values(NEW.username,now(),'Success','update','recruiter'); 
END IF; end$ delimiter ; 
update recruiter set exp_years=27 where username='bettyg'; 
 
update recruiter set exp_years=27 where username='betttyg'; 
==================================================================== drop trigger if exists recruitertrig3; delimiter $ 
create trigger recruitertrig3 before delete on recruiter for each row begin 
IF (NOT EXISTS(SELECT 1 FROM recruiter WHERE username = OLD.username)) THEN 
 	insert into history values(OLD.username,now(),'Failure','delete','recruiter'); 
    SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'DFELETE failed on recruiter due to a non existent username'; 
 	 
else 
 	insert into history values(OLD.username,now(),'Success','delete','recruiter'); 
END IF; end$ delimiter ; 
 
delete from recruiter where username='my19001'; 
================================================ 
-------------------------------------- drop trigger if exists usertrig1; delimiter $ 
create trigger usertrig1 before insert on user for each row begin 
IF (EXISTS(SELECT 1 FROM user WHERE username = NEW.username)) THEN  	insert into history values(NEW.username,now(),'Failure','insert','user'); 
    SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'INSERT failed due to duplicate username'; else 
 	insert into history values(NEW.username,now(),'Success','insert','user'); 
END IF; end$ delimiter ; 
 
 
insert into user values ('mnikol','jones','Andrew','Smith','2018-01-27 16:02:56','andrewbr@yahoo.com'); 
ERROR 1644 (45000): INSERT failed due to duplicate username 
======================================================================================= drop trigger if exists usertrig2; delimiter $ 
create trigger usertrig2 before update on user for each row begin 
IF (EXISTS(SELECT 1 FROM user WHERE username = NEW.username)) THEN  	insert into history values(NEW.username,now(),'Failure','update','user'); 
    SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'UPDATE failed due to duplicate username'; 
elseIF NEW.username <> OLD.username or NEW.username <> username  or NEW.password<>OLD.password or NEW.NAME <> OLD.NAME or NEW.SURNAME <> OLD.SURNAME OR NEW.REG_DATE <> OLD.REG_DATE OR NEW.EMAIL <> 
OLD.EMAIL then  
    insert into history values(NEW.username,now(),'Success','update','user'); else 
 	insert into history values(NEW.username,now(),'Failure','update','user'); 
    SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'UPDATE failed due to duplicate username'; 
END IF; end$ delimiter ; update user set username='mnikool' where username='betttyg'; update user set email='mnkppil@hotmail.gr' where username='mnikool';  update user set username='papad' where username='mnikool'; 
 
 
mysql> update user set username='mnikool' where username='mnikool'; ERROR 1644 (45000): UPDATE failed due to duplicate username 
mysql> update user set email='mnkppil@hotmail.gr' where username='mnikool'; ERROR 1644 (45000): UPDATE failed due to duplicate username mysql> update user set username='papad' where username='mnikool'; 
ERROR 1644 (45000): UPDATE failed due to duplicate username 
===================================================== 
 
drop trigger if exists usertrig3; delimiter $ 
create trigger usertrig3 before delete on user for each row begin 
IF (NOT EXISTS(SELECT * FROM user WHERE username = OLD.username)) THEN 
 	insert into history values(OLD.username,now(),'Failure','delete','user'); 
    SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'DFELETE on user failed due to a non existent username'; 
 	 
else 
 	insert into history values(OLD.username,now(),'Success','delete','user'); 
  SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'DFELETE on user Succeded due to a non existent username'; END IF; end$ delimiter ; 
 
delete from user where username='my19001'; 
========================================================== 
--------------------------------------------------------------------- drop trigger if exists etaireiatrig1; delimiter $ 
create trigger etaireiatrig1 before insert on etaireia for each row 
begin 
  
IF (EXISTS(SELECT 1 FROM etaireia WHERE afm = NEW.afm)) THEN 
 	insert into history values('unknown',now(),'Failure','insert','etaireia'); 
    SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'INSERT failed due to duplicate afm'; else 
 	insert into history values('unknown',now(),'Success','insert','etaireia'); 
END IF; end$ 
delimiter ; 
 
insert into etaireia values ('023453344','B Patras',' Sofitel A.E.','48385','Gounari',50,'Patras','Greece'); insert into etaireia values ('023453344','B Patras',' Sofitel A.E.','48385','Gounari',50,'Patras','Greece'); 
 
============================================= 
 
drop trigger if exists etaireiatrig2; delimiter $ 
create trigger etaireiatrig2 after update on etaireia for each row begin 
 	 
 	IF NEW.AFM <> OLD.AFM or NEW.DOY<>OLD.DOY or NEW.NAME <> OLD.NAME then   	    insert into history values('admin',now(),'Failure','update','etaireia'); 
  SIGNAL SQLSTATE VALUE '45000'; SET MESSAGE_TEXT = 'UPDATE failed due to invalid modification on AFM/DOY/NAME'; 
 	 	 
 	ELSE 
 	 	insert into history values('ADMIN',now(),'Success','update','etaireia');  	end if; 
end$ delimiter ; 
 
update etaireia set afm='023451232' where afm='fffff'; update etaireia set doy='gdfgfd' where doy='C Patras'; 
update etaireia set name='aaaaddfd' where name='EXPENDITURE Ltd'; 
==================================================================== 
 
drop trigger if exists etaireiatrig3; delimiter $ 
create trigger etaireiatrig3 before delete on etaireia; for each row begin 
IF (EXISTS(SELECT 1 FROM etaireia WHERE AFM = OLD.AFM)) THEN  	insert into history values(OLD.AFM,now(),'Success','delete','etaireia'); else 
 	insert into history values(OLD.AFM,now(),'Failure','delete','etaireia'); 
    SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'DELETE failed due to a non existent etaireia AFM'; 
END IF; end$ delimiter ; 
-------------------------------------------------------------- drop trigger if exists jobtrig1; delimiter $ 
create trigger jobtrig1 before insert on job for each row 
begin 
 	if new.announce_date > curdate() then 
 	   insert into history values('admin',now(),'failure','insert','job'); 
 	   SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'INSERT failed due to announce day> current day afm';  	else 
 	 	insert into history values('admin',now(),'success','insert','job');  	end if; end$ 
delimiter ; 
 
insert into job values (14,'2019-01-21',1000,'Java Developer','Patra','msmith','2020-10-2','2018-12-20'); insert into job values (14,'2019-01-01',1000,'Java Developer','Patra','msmith','2018-10-2','2018-12-20'); 
=========================================================================================== drop trigger if exists jobtrig2; delimiter $ 
create trigger jobtrig2 before update on job for each row begin 
if new.announce_date > curdate() then 
 	   insert into history values('admin',now(),'failure','update','job'); 
 	   SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'UPDATE failed due to announce day> current day';  	else 
 	   insert into history values('admin',now(),'sucess','update','job');  	end if; 
end$ delimiter ; 
 
update job set announce_date='2019-01-31' where id=1; 
===============================================================================================
= 
drop trigger if exists jobtrig3; delimiter $ 
create trigger jobtrig3 before delete on job for each row begin 
 	IF (EXISTS(SELECT 1 FROM job WHERE id = old.id)) THEN  	 	insert into history values('admin',now(),'Success','delete','job'); 
  SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'DELETE hit due to a non existent job';  	else 
 	 	insert into history values('admin',now(),'Failure','delete','job'); 
 	 	SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'DELETE failed due to a non existent job'; 
 	END IF; 
end$ delimiter ; 
delete from job where id=2; 
================================================= 
 
 
 
drop trigger if exists applies_job; delimiter $ 
create trigger applies_job before delete on applies for each row begin 
  IF (EXISTS(select 1 from job inner join applies on applies.job_id=job.id and OLD.job_id=job.id AND SUBMISSION_DATE<CUR-
DATE())) then 
       SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'DELETE of APPLICATION FAILED due to SUBMISSION_DATE<CURDATE()'; 
 	   insert into history values('cand_usrname',now(),'Failure','delete','applies');   else 
      insert into history values('cand_usrname',now(),'Success','delete','applies');   end if; end$ delimiter ; 
 
delete from applies where job_id=2; 
 
