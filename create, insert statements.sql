DROP TABLE IF EXISTS `division`; 
CREATE TABLE IF NOT EXISTS `division` ( 
  `division_code` int(11) NOT NULL, 
  `title` text, 
  `short_text` text, 
  `parent_division` int(11) DEFAULT NULL, 
  `fafm` char(9) DEFAULT NULL, 
  PRIMARY KEY (`division_code`), 
  KEY `cs3` (`parent_division`), 
  KEY `cs4` (`fafm`) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1; 
 

INSERT INTO `division` (`division_code`, `title`, `short_text`, `parent_division`, `fafm`) VALUES 
(1, 'Software', 'Genikos Tomeas', NULL, '023453344'), 
(2, 'Databases', 'Eidikeyetai stis baseis dedomenon', 1, '023451232'), 
(3, 'Data Structures', 'Eidikeyetai stis domes dedomenon', 1, '123432211'); 


ALTER TABLE `division` 
  ADD CONSTRAINT `cs3` FOREIGN KEY (`parent_division`) REFERENCES `division` (`division_code`) ON DELETE CASCADE ON UPDATE CASCADE, 
  ADD CONSTRAINT `cs4` FOREIGN KEY (`fafm`) REFERENCES `etaireia` (`AFM`) ON DELETE CASCADE ON UPDATE CASCADE; 
COMMIT; 
 
 
 


 
DROP TABLE IF EXISTS `evaluation`; 
CREATE TABLE IF NOT EXISTS `evaluation` ( 
  `aa_evaluation` int(11) NOT NULL AUTO_INCREMENT, 
  `personality` int(11) DEFAULT NULL, 
  `education` int(11) DEFAULT NULL, 
  `experience` int(11) DEFAULT NULL, 
  `rusername` varchar(12) DEFAULT NULL, 
  `cusername` varchar(12) DEFAULT NULL, 
  `completed` int(11) NOT NULL, 
  `job_id` int(11) NOT NULL, 
  PRIMARY KEY (`aa_evaluation`), 
  KEY `cs7` (`rusername`), 
  KEY `cs8` (`cusername`), 
  KEY `cs17` (`job_id`) 
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1; 
 

 
INSERT INTO `evaluation` (`aa_evaluation`, `personality`, `education`, `experience`, `rusername`, `cusername`, `completed`, `job_id`) 
VALUES 
(1, 2, 3, 4, 'bettyg', 'abrown', 1, 1), 
(2, 5, 4, 2, 'bettyg', 'liagourma', 1, 1), 
(3, 1, 1, 1, 'bettyg', 'cleogeo', 1, 1), 
(4, 5, 0, 3, 'Giankost', 'mnikol', 1, 2), 
(5, 2, 4, 2, 'msmith', 'zazahir23', 1, 2), 
(6, 1, 2, 3, 'Giankost', 'mnikol', 1, 2), 
(7, 0, 2, 3, 'n_tri', 'cleogeo', 1, 3), 
(8, 4, 0, 0, 'n_tri', 'liagourma', 1, 3), 
(9, 2, 1, 0, 'papad', 'mnikol', 0, 3), 
(10, 0, 0, 4, 'papad', 'mnikol', 0, 4); 


ALTER TABLE `evaluation` 
  ADD CONSTRAINT `cs17` FOREIGN KEY (`job_id`) REFERENCES `job` (`id`) ON DELETE CASCADE ON UPDATE CASCADE, 
  ADD CONSTRAINT `cs7` FOREIGN KEY (`rusername`) REFERENCES `recruiter` (`username`) ON UPDATE CASCADE, 
  ADD CONSTRAINT `cs8` FOREIGN KEY (`cusername`) REFERENCES `candidate` (`username`) ON UPDATE CASCADE; COMMIT; 
 
 
 




DROP TABLE IF EXISTS `history`; 
CREATE TABLE IF NOT EXISTS `history` ( 
  `username` varchar(12) DEFAULT NULL, 
  `hmer_ora` datetime DEFAULT NULL, 
  `apotelesma` varchar(12) DEFAULT NULL, 
  `eidos` varchar(12) DEFAULT NULL, 
  `onoma_pinaka` varchar(12) DEFAULT NULL 
) ENGINE=InnoDB DEFAULT CHARSET=latin1; 
COMMIT; 
 




 
DROP TABLE IF EXISTS `interview`; 
CREATE TABLE IF NOT EXISTS `interview` ( 
  `aa_interview` int(11) NOT NULL AUTO_INCREMENT, 
  `interviewdate` date DEFAULT NULL, 
  `intervietime` time DEFAULT NULL, 
  `comments` text, 
  `rusername` varchar(12) DEFAULT NULL, 
  `cusername` varchar(12) DEFAULT NULL, 
  PRIMARY KEY (`aa_interview`), 
  KEY `cs1` (`rusername`), 
  KEY `cs2` (`cusername`) 
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1; 
 
 
INSERT INTO `interview` (`aa_interview`, `interviewdate`, `intervietime`, `comments`, `rusername`, `cusername`) VALUES (1, '2019-01-02', '00:00:12', 'Kala', 'bettyg', 'abrown'), 
(2, '2019-01-01', '00:00:10', 'Polya kala', 'bettyg', 'cleogeo'), 
(3, '2019-01-01', '09:00:00', 'Metria', 'bettyg', 'liagourma'), 
(4, '2019-01-01', '12:00:00', 'Para poly kala', 'Giankost', 'mnikol'), 
(5, '2019-01-03', '00:00:14', 'Poly Metria', 'msmith', 'zazahir23'), 
(6, '2019-01-02', '00:00:15', 'Kalo apotelesma', 'Giankost', 'mnikol'), 
(7, '2019-01-03', '00:00:15', 'Poly Kaka', 'n_tri', 'abrown'), 
(8, '2019-01-02', '00:00:18', 'Etsi kai etsi', 'n_tri', 'cleogeo'), 
(9, '2019-01-03', '00:00:19', 'Metria pros Kaka', 'papad', 'mnikol'), 
(10, '2019-01-04', '00:00:22', 'Metria pros kala', 'papad', 'liagourma'); 
 

ALTER TABLE `interview` 
  ADD CONSTRAINT `cs1` FOREIGN KEY (`rusername`) REFERENCES `recruiter` (`username`) ON UPDATE CASCADE, 
  ADD CONSTRAINT `cs2` FOREIGN KEY (`cusername`) REFERENCES `candidate` (`username`) ON UPDATE CASCADE; COMMIT; 
 
 