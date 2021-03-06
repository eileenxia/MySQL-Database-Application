-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';




-- -----------------------------------------------------
-- Schema stanveer_db
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `stanveer_db` ;

-- -----------------------------------------------------
-- Schema stanveer_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `stanveer_db` DEFAULT CHARACTER SET utf8 ;
USE `stanveer_db` ;

-- -----------------------------------------------------
-- Table `stanveer_db`.`Editor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stanveer_db`.`Credential` ;

CREATE TABLE IF NOT EXISTS `stanveer_db`.`Credential` (
  `idCredential` INT NOT NULL AUTO_INCREMENT,
  `Credential_user_id`  VARCHAR(45) NOT NULL,
  `Credential_password` VARCHAR(200) NOT NULL,
  
  PRIMARY KEY (`idCredential`))
  
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stanveer_db`.`Editor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stanveer_db`.`Editor` ;

CREATE TABLE IF NOT EXISTS `stanveer_db`.`Editor` (
  `idEditor` INT NOT NULL AUTO_INCREMENT,
  `Editor_first_name` VARCHAR(45) NOT NULL,
  `Editor_last_name` VARCHAR(45) NOT NULL,
  `Editor_user_id`  VARCHAR(45) NULL,
  PRIMARY KEY (`idEditor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stanveer_db`.`Manuscript`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stanveer_db`.`Manuscript` ;

CREATE TABLE IF NOT EXISTS `stanveer_db`.`Manuscript` (
  `idManuscript` INT NOT NULL AUTO_INCREMENT,
  `Manuscript_title` VARCHAR(200) NOT NULL,
  `Manuscript_data` MEDIUMBLOB NOT NULL,
  `Manuscript_status` VARCHAR(45) NOT NULL CHECK (Manuscript_status IN ('rejected', 'underreview', 'accepted', 'ready', 'scheduled', 'published')),
  `Manuscript_affiliation` VARCHAR(45) NOT NULL,
  `Manuscript_RI_Code` VARCHAR(45) NOT NULL,
  `Manuscript_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Editor_idEditor` INT NOT NULL,
  PRIMARY KEY (`idManuscript`),
  INDEX `fk_Manuscript_Editor1_idx` (`Editor_idEditor` ASC) ,
  CONSTRAINT `fk_Manuscript_Editor1`
    FOREIGN KEY (`Editor_idEditor`)
    REFERENCES `stanveer_db`.`Editor` (`idEditor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stanveer_db`.`Author`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stanveer_db`.`Author` ;

CREATE TABLE IF NOT EXISTS `stanveer_db`.`Author` (
  `idAuthor` INT NOT NULL AUTO_INCREMENT,
  `Author_first_name` VARCHAR(45) NOT NULL,
  `Author_last_name` VARCHAR(45) NOT NULL,
  `Author_address` VARCHAR(45) NULL,
  `Author_email` VARCHAR(100) NULL,
  `Author_affiliation` VARCHAR(100) NULL,
  `Author_user_id`  VARCHAR(45) NULL,
  PRIMARY KEY (`idAuthor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stanveer_db`.`Reviewer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stanveer_db`.`Reviewer` ;

CREATE TABLE IF NOT EXISTS `stanveer_db`.`Reviewer` (
  `idReviewer` INT NOT NULL AUTO_INCREMENT,
  `Reviewer_first_name` VARCHAR(45) NULL,
  `Reviewer_Last_name` VARCHAR(45) NULL,
  `Reviewer_email` VARCHAR(100) NULL,
  `Reviewer_affiliation` VARCHAR(100) NULL,
  `Reviewer_user_id`  VARCHAR(45) NULL,
  PRIMARY KEY (`idReviewer`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stanveer_db`.`Feedback`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stanveer_db`.`Feedback` ;

CREATE TABLE IF NOT EXISTS `stanveer_db`.`Feedback` (
  `Feedback_appropriateness` INT NULL,
  `Feedback_clarity` VARCHAR(45) NULL,
  `Feedback_methodology` VARCHAR(45) NULL,
  `Feedback_contribution` VARCHAR(45) NULL,
  `Feedback_reccomendation` VARCHAR(45) NULL,
  `Feedback_received_date` VARCHAR(45) NULL,
  `Manuscript_idManuscript` INT NOT NULL,
  `Reviewer_idReviewer` INT NOT NULL,
  PRIMARY KEY (`Manuscript_idManuscript`, `Reviewer_idReviewer`),
  INDEX `fk_Feedback_Reviewer1_idx` (`Reviewer_idReviewer` ASC) ,
  CONSTRAINT `fk_Feedback_Manuscript1`
    FOREIGN KEY (`Manuscript_idManuscript`)
    REFERENCES `stanveer_db`.`Manuscript` (`idManuscript`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Feedback_Reviewer1`
    FOREIGN KEY (`Reviewer_idReviewer`)
    REFERENCES `stanveer_db`.`Reviewer` (`idReviewer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stanveer_db`.`Interest_area`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stanveer_db`.`Interest_area` ;

CREATE TABLE IF NOT EXISTS `stanveer_db`.`Interest_area` (
  `RI_code` INT NOT NULL AUTO_INCREMENT,
  `Area_name` VARCHAR(100) NULL,
  PRIMARY KEY (`RI_code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stanveer_db`.`Issue`s
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stanveer_db`.`Issue` ;

CREATE TABLE IF NOT EXISTS `stanveer_db`.`Issue` (
  `idIssue` INT NOT NULL AUTO_INCREMENT,
  `Issue_period` VARCHAR(45) NOT NULL,
  `Issue_year` VARCHAR(45) NOT NULL,
  `Issue_volume` VARCHAR(45) NOT NULL,
  `Issue_num` VARCHAR(45) NOT NULL,
  `Issue_print_date` VARCHAR(45) NOT NULL,
  `issue_status` VARCHAR(45) NULL,
  PRIMARY KEY (`idIssue`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stanveer_db`.`Author_has_Manuscript`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stanveer_db`.`Author_has_Manuscript` ;

CREATE TABLE IF NOT EXISTS `stanveer_db`.`Author_has_Manuscript` (
  `Author_idAuthor` INT NOT NULL,
  `Manuscript_idManuscript` INT NOT NULL,
  `Author_order` VARCHAR(45) NULL,
  PRIMARY KEY (`Author_idAuthor`, `Manuscript_idManuscript`),
  INDEX `fk_Author_has_Manuscript_Manuscript1_idx` (`Manuscript_idManuscript` ASC) ,
  INDEX `fk_Author_has_Manuscript_Author_idx` (`Author_idAuthor` ASC) ,
  CONSTRAINT `fk_Author_has_Manuscript_Author`
    FOREIGN KEY (`Author_idAuthor`)
    REFERENCES `stanveer_db`.`Author` (`idAuthor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Author_has_Manuscript_Manuscript1`
    FOREIGN KEY (`Manuscript_idManuscript`)
    REFERENCES `stanveer_db`.`Manuscript` (`idManuscript`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stanveer_db`.`Reviewer_has_Interest_area`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stanveer_db`.`Reviewer_has_Interest_area` ;

CREATE TABLE IF NOT EXISTS `stanveer_db`.`Reviewer_has_Interest_area` (
  `Reviewer_idReviewer` INT NOT NULL,
  `Interest_area_RI_code` INT NOT NULL,
  PRIMARY KEY (`Reviewer_idReviewer`, `Interest_area_RI_code`),
  INDEX `fk_Reviewer_has_Interest_area_Interest_area1_idx` (`Interest_area_RI_code` ASC) ,
  INDEX `fk_Reviewer_has_Interest_area_Reviewer1_idx` (`Reviewer_idReviewer` ASC) ,
  CONSTRAINT `fk_Reviewer_has_Interest_area_Reviewer1`
    FOREIGN KEY (`Reviewer_idReviewer`)
    REFERENCES `stanveer_db`.`Reviewer` (`idReviewer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Reviewer_has_Interest_area_Interest_area1`
    FOREIGN KEY (`Interest_area_RI_code`)
    REFERENCES `stanveer_db`.`Interest_area` (`RI_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stanveer_db`.`Manuscript_Accepted`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stanveer_db`.`Manuscript_Accepted` ;

CREATE TABLE IF NOT EXISTS `stanveer_db`.`Manuscript_Accepted` (
  `Manuscript_idManuscript` INT NULL,
  `Issue_idIssue` INT NOT NULL,
  PRIMARY KEY (`Manuscript_idManuscript`),
  INDEX `fk_Manuscript_has_Issue_Issue1_idx` (`Issue_idIssue` ASC) ,
  INDEX `fk_Manuscript_has_Issue_Manuscript1_idx` (`Manuscript_idManuscript` ASC) ,
  CONSTRAINT `fk_Manuscript_has_Issue_Manuscript1`
    FOREIGN KEY (`Manuscript_idManuscript`)
    REFERENCES `stanveer_db`.`Manuscript` (`idManuscript`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Manuscript_has_Issue_Issue1`
    FOREIGN KEY (`Issue_idIssue`)
    REFERENCES `stanveer_db`.`Issue` (`idIssue`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

/*
 * SQL scripts for CS61 Lab assignment 
 * FILENAME RICodes.SQL
 */

INSERT INTO Interest_area (Area_name) VALUES
('Agricultural engineering'),
('Biochemical engineering'),
('Biomechanical engineering'),
('Ergonomics'),
('Food engineering'),
('Bioprocess engineering'),
('Genetic engineering'),
('Human genetic engineering'),
('Metabolic engineering'),
('Molecular engineering'),
('Neural engineering'),
('Protein engineering'),
('Rehabilitation engineering'),
('Tissue engineering'),
('Aquatic and environmental engineering'),
('Architectural engineering'),
('Civionic engineering'),
('Construction engineering'),
('Earthquake engineering'),
('Earth systems engineering and management'),
('Ecological engineering'),
('Environmental engineering'),
('Geomatics engineering'),
('Geotechnical engineering'),
('Highway engineering'),
('Hydraulic engineering'),
('Landscape engineering'),
('Land development engineering'),
('Pavement engineering'),
('Railway systems engineering'),
('River engineering'),
('Sanitary engineering'),
('Sewage engineering'),
('Structural engineering'),
('Surveying'),
('Traffic engineering'),
('Transportation engineering'),
('Urban engineering'),
('Irrigation and agriculture engineering'),
('Explosives engineering'),
('Biomolecular engineering'),
('Ceramics engineering'),
('Broadcast engineering'),
('Building engineering'),
('Signal Processing'),
('Computer engineering'),
('Power systems engineering'),
('Control engineering'),
('Telecommunications engineering'),
('Electronic engineering'),
('Instrumentation engineering'),
('Network engineering'),
('Neuromorphic engineering'),
('Engineering Technology'),
('Integrated engineering'),
('Value engineering'),
('Cost engineering'),
('Fire protection engineering'),
('Domain engineering'),
('Engineering economics'),
('Engineering management'),
('Engineering psychology'),
('Ergonomics'),
('Facilities Engineering'),
('Logistic engineering'),
('Model-driven engineering'),
('Performance engineering'),
('Process engineering'),
('Product Family Engineering'),
('Quality engineering'),
('Reliability engineering'),
('Safety engineering'),
('Security engineering'),
('Support engineering'),
('Systems engineering'),
('Metallurgical Engineering'),
('Surface Engineering'),
('Biomaterials Engineering'),
('Crystal Engineering'),
('Amorphous Metals'),
('Metal Forming'),
('Ceramic Engineering'),
('Plastics Engineering'),
('Forensic Materials Engineering'),
('Composite Materials'),
('Casting'),
('Electronic Materials'),
('Nano materials'),
('Corrosion Engineering'),
('Vitreous Materials'),
('Welding'),
('Acoustical engineering'),
('Aerospace engineering'),
('Audio engineering'),
('Automotive engineering'),
('Building services engineering'),
('Earthquake engineering'),
('Forensic engineering'),
('Marine engineering'),
('Mechatronics'),
('Nanoengineering'),
('Naval architecture'),
('Sports engineering'),
('Structural engineering'),
('Vacuum engineering'),
('Military engineering'),
('Combat engineering'),
('Offshore engineering'),
('Optical engineering'),
('Geophysical engineering'),
('Mineral engineering'),
('Mining engineering'),
('Reservoir engineering'),
('Climate engineering'),
('Computer-aided engineering'),
('Cryptographic engineering'),
('Information engineering'),
('Knowledge engineering'),
('Language engineering'),
('Release engineering'),
('Teletraffic engineering'),
('Usability engineering'),
('Web engineering'),
('Systems engineering');

#idEditor is an AUTO_INCREMENT value, 1-40
INSERT INTO `Editor` (`Editor_first_name`,`Editor_last_name`) VALUES ("Kristen","Henry"),("Zahir","Chang"),("Maryam","Shields"),("Abdul","Duran"),("Luke","Joseph"),("Scott","Mcintosh"),("Ivana","Cole"),("Austin","Romero"),("Ralph","Little"),("Thomas","Walker");
INSERT INTO `Editor` (`Editor_first_name`,`Editor_last_name`) VALUES ("Cullen","Booker"),("Akeem","Jensen"),("Richard","Terry"),("Dillon","Armstrong"),("Ainsley","England"),("Megan","Snow"),("Kadeem","Schmidt"),("Cadman","Henry"),("Marsden","Valencia"),("Chloe","Rowland");
INSERT INTO `Editor` (`Editor_first_name`,`Editor_last_name`) VALUES ("Colby","Garner"),("Kameko","Guerrero"),("Ocean","Freeman"),("Randall","Paul"),("Chanda","Decker"),("Carolyn","Medina"),("Maya","Bean"),("Blythe","Bauer"),("Ira","Daniels"),("Cally","Boyle");
INSERT INTO `Editor` (`Editor_first_name`,`Editor_last_name`) VALUES ("Odette","Malone"),("MacKenzie","Clayton"),("Branden","Mcmahon"),("Margaret","Mcguire"),("Justine","Woodard"),("Wayne","Kidd"),("Raymond","Sims"),("Aline","Ortiz"),("Amela","Palmer"),("Yvonne","Heath");

#idAuthor is an AUTO_INCREMENT value, 1-40
INSERT INTO `Author` (`Author_first_name`,`Author_last_name`,`Author_address`,`Author_email`,`Author_affiliation`) VALUES ("Gregory","Marquez","9538 Convallis Rd.","amet.consectetuer.adipiscing@adipiscing.org","Ac Tellus Suspendisse Ltd"),("Declan","Tanner","6758 Ac Avenue","posuere.at.velit@elementumategestas.net","Duis Elementum Dui Inc."),("Leo","Blankenship","975-2661 Fermentum Ave","nunc.risus.varius@ultricesposuerecubilia.com","Lectus Institute"),("Axel","Good","4236 Fringilla St.","vitae.purus.gravida@nislsem.org","Class Aptent Taciti Inc."),("Gemma","Bates","6751 Mattis. St.","feugiat.non.lobortis@ipsumcursus.org","Aliquam Ornare Libero Inc."),("Rajah","Hall","3002 Lorem Road","ultrices.sit.amet@semutdolor.edu","Libero Et Tristique Limited"),("Nell","Stout","Ap #888-2452 Cras Road","eu.arcu.Morbi@Fusce.net","Lectus Ante Ltd"),("Lyle","Cross","5350 Ipsum Road","ligula.Aliquam.erat@Donec.edu","Rhoncus Corp."),("Emma","Terry","Ap #821-9348 Phasellus Avenue","Cras@necmetusfacilisis.ca","Ac Incorporated"),("Jarrod","Rivas","Ap #994-4033 Augue Av.","mi.Duis@tinciduntorci.org","Neque LLC");
INSERT INTO `Author` (`Author_first_name`,`Author_last_name`,`Author_address`,`Author_email`,`Author_affiliation`) VALUES ("Halee","Chase","1388 Fusce St.","sit.amet.faucibus@eget.edu","Enim Company"),("Gillian","Russo","902-5616 Lorem Avenue","posuere.cubilia.Curae@Utsemperpretium.org","Vulputate Risus Ltd"),("Josephine","Fisher","P.O. Box 169, 3095 Cras Road","elementum.dui@duiFuscediam.co.uk","Dis Parturient Montes PC"),("Gregory","Atkinson","547 Egestas St.","torquent@et.ca","Montes Nascetur Ridiculus Company"),("Wing","Kirk","9569 Nunc Ave","lectus.ante@Nunc.net","Faucibus Orci Luctus Incorporated"),("Nolan","Horn","P.O. Box 892, 903 Donec Rd.","quis.turpis@fringilla.net","Cursus Vestibulum Mauris Limited"),("Selma","Ewing","952-1311 Risus St.","Suspendisse@dictum.org","Curabitur Incorporated"),("Alea","Owens","Ap #546-4332 Dolor. Av.","a.purus@tinciduntorci.net","Sit Amet Diam Corporation"),("Lisandra","Mckenzie","4218 Nascetur Ave","adipiscing.lobortis@sollicitudin.net","Laoreet Posuere Enim Consulting"),("Jolene","Hess","P.O. Box 306, 4022 Tempus Rd.","arcu@malesuadafringilla.ca","Ante Consulting");
INSERT INTO `Author` (`Author_first_name`,`Author_last_name`,`Author_address`,`Author_email`,`Author_affiliation`) VALUES ("Vaughan","Cotton","Ap #498-1646 Ultrices Rd.","nulla.magna.malesuada@euismodurnaNullam.net","Sem Ut Foundation"),("Ori","Hampton","P.O. Box 180, 3938 Tellus Rd.","sagittis.lobortis@vitaealiquam.ca","Gravida Nunc Industries"),("Thor","Mason","Ap #318-5271 Risus. Avenue","semper.dui.lectus@nonlobortisquis.edu","Felis Purus Incorporated"),("Silas","Gross","7160 Lobortis St.","rutrum@sit.ca","Integer Sem Elit Corp."),("Bruce","Velez","P.O. Box 724, 8748 Egestas Av.","risus.Duis@Curabitursedtortor.org","Neque Inc."),("Gary","Frost","8956 In Avenue","mi.enim@laoreet.co.uk","Eu Neque Foundation"),("Chaim","Santana","1284 Rutrum Ave","dignissim.magna@Nullam.org","Lorem Corporation"),("Noah","Davenport","3096 Nec St.","enim@felis.com","Pellentesque Industries"),("Rhonda","Simon","6963 Integer Avenue","per@euaccumsan.com","Senectus Industries"),("Vera","Mercado","P.O. Box 549, 197 Dapibus Av.","erat.eget@ante.co.uk","Vulputate Nisi Sem Associates");
INSERT INTO `Author` (`Author_first_name`,`Author_last_name`,`Author_address`,`Author_email`,`Author_affiliation`) VALUES ("Uta","Hebert","P.O. Box 551, 8520 Odio. Av.","adipiscing.elit.Curabitur@utcursus.co.uk","Lorem LLP"),("Gregory","Cooke","P.O. Box 949, 4592 Euismod Street","tellus@leo.co.uk","Egestas Ltd"),("Zenaida","Rhodes","628-9810 Ac St.","ipsum.leo@risusQuisquelibero.co.uk","Hendrerit Ltd"),("Quentin","Tillman","Ap #323-9481 Pede Avenue","a@Aliquamvulputateullamcorper.net","A Ultricies Adipiscing Company"),("Leigh","Pena","2435 Natoque Rd.","risus.a@risusatfringilla.co.uk","Erat Vitae Risus PC"),("Pandora","Campbell","4661 Cum Av.","scelerisque.lorem.ipsum@vulputate.org","Donec Luctus Aliquet Institute"),("Clarke","Pruitt","878-1965 Lorem, Street","euismod.enim.Etiam@tempus.ca","Ultrices Duis Volutpat Limited"),("Iona","Burks","7720 Nunc Rd.","sollicitudin@nisisemsemper.co.uk","Nec Mauris Institute"),("Remedios","Gilbert","711-6876 Viverra. Rd.","nunc.Quisque@molestie.com","Aliquet Proin Company"),("Oprah","Golden","4548 Morbi Rd.","vitae.risus.Duis@pharetrafeliseget.com","Porta Elit A Ltd");

#idReviewer is an AUTO_INCREMENT value, 1-40
INSERT INTO `Reviewer` (`Reviewer_first_name`,`Reviewer_last_name`,`Reviewer_email`,`Reviewer_affiliation`) VALUES ("Magee","Brady","ornare@malesuada.net","Aptent Taciti Sociosqu Corp."),("Calista","Hunt","tempus.scelerisque.lorem@sagittis.co.uk","Eu Corp."),("Hannah","Nguyen","amet@lacinia.net","Sem Eget Massa PC"),("Rigel","Robbins","lectus.Cum.sociis@nequevenenatislacus.ca","Elit Pharetra Ut Incorporated"),("Bruno","Justice","risus@quamelementumat.ca","Pellentesque Habitant Corp."),("Denise","Ferguson","vehicula@Crasvehiculaaliquet.ca","Phasellus Vitae Incorporated"),("Sylvester","Booth","lobortis@Cras.edu","Ridiculus Mus Donec Foundation"),("Jonas","Mcdowell","Cras.pellentesque.Sed@vel.co.uk","Nisi Magna Incorporated"),("Zena","Moreno","egestas@mitempor.net","Hendrerit Consectetuer Cursus Incorporated"),("Mikayla","Andrews","Suspendisse.eleifend.Cras@fermentum.ca","Fermentum Corp.");
INSERT INTO `Reviewer` (`Reviewer_first_name`,`Reviewer_last_name`,`Reviewer_email`,`Reviewer_affiliation`) VALUES ("Bruce","Freeman","odio.Aliquam.vulputate@In.org","Diam Nunc LLP"),("Hermione","Tyler","venenatis@elitfermentumrisus.com","Penatibus Et Magnis Corporation"),("Alexa","Calderon","mollis.Duis@tellus.ca","Non Lorem Industries"),("Justine","Buckner","eget.magna.Suspendisse@malesuadavel.co.uk","Fusce Fermentum Fermentum Company"),("Rooney","Mcknight","mus.Aenean@lobortistellus.net","Gravida Sit Amet Corporation"),("Rigel","Henderson","lacinia@aliquet.co.uk","Dapibus Limited"),("Kellie","Cline","tincidunt.orci@risusQuisquelibero.com","Suspendisse Tristique Consulting"),("Rahim","Coffey","et.eros.Proin@perinceptos.com","Torquent Industries"),("Addison","Burris","elementum@Loremipsumdolor.edu","Suspendisse Aliquet Company"),("Zeus","Ryan","luctus@necmalesuada.org","Eget Magna LLP");
INSERT INTO `Reviewer` (`Reviewer_first_name`,`Reviewer_last_name`,`Reviewer_email`,`Reviewer_affiliation`) VALUES ("Dorothy","Frazier","nibh.Phasellus@ipsum.com","Lorem Luctus Ut Corp."),("Wyoming","Jarvis","eros@neccursusa.ca","Non Egestas Institute"),("Chadwick","Phelps","leo.Morbi@nasceturridiculusmus.org","Elit Corporation"),("Edan","Burch","ante.ipsum.primis@elit.ca","Tempus Mauris Erat PC"),("Chelsea","Joyner","lobortis@risus.com","Ut Limited"),("Dorothy","Burks","euismod.et@dictumeuplacerat.ca","Eu Lacus Quisque Industries"),("Logan","Finley","rutrum.Fusce@Duisacarcu.co.uk","Tellus Aenean Industries"),("Price","Dale","pede@incursuset.ca","Donec Tincidunt Donec Corporation"),("Darius","Parsons","eu.dui@tellusnon.com","Mauris Sapien Cursus Ltd"),("Slade","Sampson","vel.faucibus.id@tempus.co.uk","Sem Eget LLP");
INSERT INTO `Reviewer` (`Reviewer_first_name`,`Reviewer_last_name`,`Reviewer_email`,`Reviewer_affiliation`) VALUES ("Basil","Goff","scelerisque.lorem@vehicula.ca","Laoreet Ipsum Curabitur Corporation"),("Olga","Pruitt","Fusce.feugiat.Lorem@malesuadaiderat.co.uk","Augue Id Inc."),("Nicholas","Buck","mi@eutemporerat.co.uk","Et Commodo Limited"),("Yael","Wheeler","Morbi@arcuNunc.com","Dignissim LLC"),("Talon","Perry","est.congue.a@dictumultricies.ca","Aenean Massa Integer Corporation"),("Fritz","Barnett","pulvinar.arcu.et@ametnullaDonec.edu","Ut Company"),("Patricia","Wells","Sed.congue@sed.org","Quis Pede Suspendisse LLC"),("Leilani","Gentry","semper.erat@pellentesque.ca","Eros Ltd"),("Grace","Reid","at.pretium.aliquet@odiosagittissemper.com","Lacinia At Iaculis Consulting"),("Keegan","Jensen","mus@adipiscing.org","Parturient Montes LLP");

#idIssue is an AUTO_INCREMENT value, 1-50
INSERT INTO `Issue` (`Issue_period`,`Issue_year`,`Issue_volume`,`Issue_num`,`Issue_print_date`) VALUES (1, 2015, 1, 197, "2015-01-01 17:09:10"), (2, 2015, 1, 203, "2015-04-01 03:47:13"), (3, 2015, 1, 193, "2015-08-01 07:19:11"), (4, 2015, 1, 194, "2015-12-01 19:19:30");
INSERT INTO `Issue` (`Issue_period`,`Issue_year`,`Issue_volume`,`Issue_num`,`Issue_print_date`) VALUES (1, 2016, 2, 195, "2016-02-01 04:14:30"), (2, 2016, 2, 206, "2016-05-01 06:27:16"), (3, 2016, 2, 207, "2016-09-01 01:19:31"), (4, 2016, 2, 191, "2016-11-13 15:43:35");
INSERT INTO `Issue` (`Issue_period`,`Issue_year`,`Issue_volume`,`Issue_num`,`Issue_print_date`) VALUES (1, 2017, 3, 199, "2017-01-13 16:16:40"), (2, 2017, 3, 190, "2017-05-06 09:07:25"), (3, 2017, 3, 211, "2017-09-01 13:20:41"), (4, 2017, 3, 192, "2017-11-07 17:34:25");
INSERT INTO `Issue` (`Issue_period`,`Issue_year`,`Issue_volume`,`Issue_num`,`Issue_print_date`) VALUES (1, 2018, 4, 193, "2018-01-15 23:23:50"), (2, 2018, 4, 194, "2018-04-11 08:17:07"), (3, 2018, 4, 215, "2018-08-14 22:25:16"), (4, 2018, 4, 216, "2018-11-08 05:55:33");
INSERT INTO `Issue` (`Issue_period`,`Issue_year`,`Issue_volume`,`Issue_num`,`Issue_print_date`) VALUES (1, 2019, 5, 197, "2019-01-17 15:42:10"), (2, 2019, 5,198, "2019-04-21 13:17:13"), (3, 2019, 5, 191, "2019-08-15 21:42:19"), (4, 2019, 5, 220, "2019-12-01 08:52:20");


#manuscript status options are 1) under review 2) rejected 3) accepted 4) ready 5) scheduled 6) published
#idManuscript is an AUTO_INCREMENT value, 1-50
INSERT INTO `Manuscript` (`Manuscript_title`,`Manuscript_data`,`Manuscript_status`,`Manuscript_affiliation`,`Manuscript_RI_Code`,`Editor_idEditor`) VALUES ("nibh dolor, nonummy","justo","ready","Eget Incorporated",15,15),("mauris","auctor,","rejected","Taciti Sociosqu Ad LLP",15,12),("Aliquam auctor, velit eget laoreet posuere,","augue","rejected","Tempus Incorporated",28,21),("conubia nostra, per","Aliquam","ready","Nunc Mauris Morbi Company",28,5),("Sed pharetra, felis","Mauris","ready","Mauris Foundation",17,17),("orci, in consequat enim diam","Duis","accepted","Duis LLC",32,14),("Praesent eu dui. Cum sociis","dictum.","rejected","Sed Foundation",39,9),("aliquam eros turpis","Phasellus","ready","In Faucibus Associates",40,20),("interdum ligula eu enim. Etiam imperdiet","lorem","published","Ut Associates",18,12),("non ante bibendum ullamcorper. Duis cursus,","vitae","scheduled","Mauris Rhoncus Corp.",16,38);
INSERT INTO `Manuscript` (`Manuscript_title`,`Manuscript_data`,`Manuscript_status`,`Manuscript_affiliation`,`Manuscript_RI_Code`,`Editor_idEditor`) VALUES ("Suspendisse ac metus vitae","purus,","underreview","Placerat Cras Inc.",15,15),("Etiam vestibulum massa rutrum magna.","Nam","scheduled","Porttitor Vulputate Posuere Limited",40,19),("non nisi. Aenean eget metus. In","Cum","accepted","Accumsan Sed Corporation",1,13),("dis","nulla","ready","Ridiculus Mus Ltd",12,8),("in faucibus orci luctus","porta","scheduled","Eget Ipsum Donec Inc.",26,13),("blandit congue. In scelerisque","sagittis","rejected","Sed Nunc Est LLP",20,8),("ac metus vitae velit","ipsum.","scheduled","Et Ultrices Corp.",9,11),("nisl. Quisque fringilla","iaculis","scheduled","Tristique Ac Eleifend Company",24,12),("neque sed sem egestas","mollis","scheduled","Morbi Vehicula Pellentesque Ltd",40,21),("montes, nascetur ridiculus mus.","tempus","accepted","A Mi Corporation",17,17);
INSERT INTO `Manuscript` (`Manuscript_title`,`Manuscript_data`,`Manuscript_status`,`Manuscript_affiliation`,`Manuscript_RI_Code`,`Editor_idEditor`) VALUES ("Suspendisse sed","interdum.","scheduled","Ut Foundation",28,28),("elit, pellentesque a, facilisis non,","malesuada","ready","Sed Molestie Associates",33,32),("Etiam bibendum fermentum metus. Aenean","Nam","ready","Eros Turpis Non Inc.",38,23),("nisl. Quisque","pede","scheduled","Velit Eu Sem LLP",34,6),("parturient","accumsan","rejected","Lacinia PC",14,18),("ornare lectus justo eu arcu. Morbi","amet,","accepted","Arcu LLC",16,15),("quam. Pellentesque habitant morbi tristique senectus","sagittis","rejected","Nunc Id Corp.",25,11),("pede. Suspendisse dui.","libero.","scheduled","Quam Elementum Corporation",39,13),("erat eget ipsum. Suspendisse","at,","ready","Cras Interdum Nunc Incorporated",21,21),("per conubia nostra, per","vel,","rejected","Enim Industries",8,36);
INSERT INTO `Manuscript` (`Manuscript_title`,`Manuscript_data`,`Manuscript_status`,`Manuscript_affiliation`,`Manuscript_RI_Code`,`Editor_idEditor`) VALUES ("ac risus. Morbi metus. Vivamus euismod","eu","accepted","Est Tempor Corp.",3,3),("auctor velit. Aliquam nisl. Nulla","Duis","scheduled","In Molestie Industries",3,40),("ac risus. Morbi metus. Vivamus","Aliquam","scheduled","Auctor Mauris Vel Associates",17,1),("magna a tortor. Nunc commodo","et","rejected","Vestibulum Massa LLC",25,25),("Mauris molestie pharetra nibh.","nunc,","underreview","Eget Metus Institute",37,13),("eu enim. Etiam imperdiet","et","rejected","Posuere Vulputate Lacus Limited",34,4),("tincidunt tempus risus. Donec egestas. Duis","vitae","ready","Mauris Id LLP",1,16),("montes, nascetur","semper","rejected","Lacus Nulla Tincidunt Associates",13,19),("massa lobortis ultrices. Vivamus rhoncus. Donec","Nunc","accepted","Fringilla Limited",28,37),("sociis natoque penatibus et magnis","feugiat","ready","Quis Incorporated",30,30);
INSERT INTO `Manuscript` (`Manuscript_title`,`Manuscript_data`,`Manuscript_status`,`Manuscript_affiliation`,`Manuscript_RI_Code`,`Editor_idEditor`) VALUES ("magna. Praesent","lobortis","accepted","Etiam Bibendum Fermentum Corporation",4,5),("neque non quam. Pellentesque habitant morbi","ac","accepted","Vitae Inc.",4,18),("Quisque varius.","commodo","scheduled","Ac Nulla Industries",27,33),("tristique aliquet.","malesuada","ready","Praesent LLP",25,7),("nec, leo. Morbi neque","sit","accepted","Leo Cras LLC",14,24),("orci. Ut semper pretium","sem","accepted","Ut Nisi A Institute",5,13),("Quisque ornare tortor at","tempus","accepted","Duis Risus Institute",2,22),("fringilla mi lacinia","amet","scheduled","Volutpat Nunc PC",35,31),("Phasellus","Nulla","rejected","Neque Nullam Ut Ltd",31,11),("amet ornare lectus justo eu arcu.","neque.","underreview","Nec Tempus Incorporated",30,23);


#include cases where the same manuscript gets multiple feedbacks (repeating `Manuscript_idManuscript`s)
#includes cases where the same reviewer gives multiple feedbacks (repeating `Reviewer_idReviewer`s)
#if a manuscript has fewer than 3 reviewers, it is rejected. All else need at least 3. A reviewer may not have received a manuscript to review
#ACME is 10 points for each, plus recommendation for publication (ACCEPT (10 points) or REJECT (0 points))
INSERT INTO `Feedback` (`Feedback_appropriateness`,`Feedback_clarity`,`Feedback_methodology`,`Feedback_contribution`,`Feedback_reccomendation`,`Feedback_received_date`,`Manuscript_idManuscript`,`Reviewer_idReviewer`) VALUES (7,10,7,3,10,"2018-04-12 09:00:14",1,22),(10,9,8,9,10,"2018-05-09 21:14:55",6,5),(1,3,8,2,0,"2018-05-08 06:46:43",2,15),(3,6,9,2,0,"2019-03-13 13:00:27",4,14),(2,9,9,10,0,"2018-10-24 00:54:33",5,6),(10,8,6,10,0,"2019-01-22 09:50:30",7,24),(4,2,3,7,10,"2019-11-02 23:53:31",8,7),(9,4,8,8,0,"2019-02-21 04:57:12",9,9),(3,2,2,9,0,"2019-12-04 10:50:59",10,13),(1,8,1,2,0,"2018-08-04 01:08:04",3,19);
INSERT INTO `Feedback` (`Feedback_appropriateness`,`Feedback_clarity`,`Feedback_methodology`,`Feedback_contribution`,`Feedback_reccomendation`,`Feedback_received_date`,`Manuscript_idManuscript`,`Reviewer_idReviewer`) VALUES (10,10,10,10,10,"2019-06-05 07:35:29",11,38),(2,4,9,5,10,"2018-09-26 06:11:07",12,37),(10,5,7,10,10,"2019-08-09 08:12:59",13,25),(7,8,3,1,0,"2019-05-12 22:51:22",14,36),(8,1,6,3,0,"2018-02-22 10:31:58",15,40),(6,10,6,4,0,"2019-01-29 17:41:56",16,8),(3,2,6,10,10,"2018-08-06 06:24:34",17,16),(2,2,2,6,10,"2019-09-07 14:34:11",18,2),(1,8,5,7,0,"2018-03-31 04:34:53",19,3),(8,8,9,10,10,"2018-08-17 12:47:56",20,17);
INSERT INTO `Feedback` (`Feedback_appropriateness`,`Feedback_clarity`,`Feedback_methodology`,`Feedback_contribution`,`Feedback_reccomendation`,`Feedback_received_date`,`Manuscript_idManuscript`,`Reviewer_idReviewer`) VALUES (8,6,5,3,0,"2020-01-18 01:09:45",21,19),(6,6,7,1,0,"2019-06-20 10:19:59",22,1),(4,9,6,8,0,"2019-11-30 15:29:26",23,6),(10,10,9,7,0,"2019-03-15 13:55:38",24,37),(5,1,2,1,0,"2018-08-16 17:19:10",25,18),(10,6,10,6,10,"2019-02-18 18:39:50",26,20),(9,1,8,1,0,"2018-12-25 11:14:23",27,26),(4,1,3,2,0,"2019-11-20 18:00:32",28,27),(8,6,7,10,10,"2018-12-30 23:57:12",29,31),(10,2,2,9,0,"2019-10-05 05:10:40",30,2);
INSERT INTO `Feedback` (`Feedback_appropriateness`,`Feedback_clarity`,`Feedback_methodology`,`Feedback_contribution`,`Feedback_reccomendation`,`Feedback_received_date`,`Manuscript_idManuscript`,`Reviewer_idReviewer`) VALUES (4,9,6,1,0,"2018-08-14 02:11:40",33,6),(1,8,4,4,0,"2019-06-01 03:28:28",36,37),(4,5,7,2,10,"2019-10-19 23:59:32",37,25),(9,8,9,10,10,"2019-02-08 14:36:38",39,19),(1,5,10,4,0,"2019-04-09 10:35:44",40,29),(8,4,8,6,10,"2018-06-01 03:45:20",44,26),(10,10,8,8,10,"2020-02-05 22:32:31",45,18),(7,10,3,1,10,"2019-03-20 00:11:55",50,29),(4,5,6,6,10,"2019-11-01 20:05:07",31,5),(9,8,1,4,0,"2019-03-10 17:44:00",34,5);
INSERT INTO `Feedback` (`Feedback_appropriateness`,`Feedback_clarity`,`Feedback_methodology`,`Feedback_contribution`,`Feedback_reccomendation`,`Feedback_received_date`,`Manuscript_idManuscript`,`Reviewer_idReviewer`) VALUES (1,9,10,4,0,"2019-04-17 14:14:17",35,1),(2,7,7,5,10,"2018-11-26 16:30:34",38,1),(10,7,7,7,10,"2019-07-30 03:22:45",41,21),(9,10,6,9,0,"2019-11-03 04:16:12",42,21),(9,2,5,8,0,"2018-12-24 15:08:03",43,22),(7,8,10,10,10,"2019-08-13 01:30:30",46,23),(6,7,10,10,10,"2018-05-06 20:14:55",47,23),(6,3,1,2,10,"2018-05-10 10:27:36",48,32),(10,3,9,6,0,"2019-01-12 23:15:58",49,32),(9,5,1,3,10,"2019-03-29 16:42:26",32,29);
INSERT INTO `Feedback` (`Feedback_appropriateness`,`Feedback_clarity`,`Feedback_methodology`,`Feedback_contribution`,`Feedback_reccomendation`,`Feedback_received_date`,`Manuscript_idManuscript`,`Reviewer_idReviewer`) VALUES (8,1,9,2,10,"2020-01-29 09:13:21",1,4),(10,9,10,6,10,"2018-12-10 08:36:05",4,10),(3,3,7,3,10,"2019-05-13 17:09:19",5,11),(4,6,9,9,10,"2018-11-30 14:43:30",6,12),(5,4,5,8,0,"2019-04-02 06:51:57",8,13),(5,2,10,4,0,"2019-08-22 19:21:29",9,14),(6,8,3,4,0,"2019-11-16 08:34:03",10,15),(2,9,6,7,10,"2018-07-06 06:02:16",11,16),(7,8,8,4,0,"2019-01-09 11:18:24",12,17),(9,5,10,10,10,"2019-03-29 16:42:26",13,18);
INSERT INTO `Feedback` (`Feedback_appropriateness`,`Feedback_clarity`,`Feedback_methodology`,`Feedback_contribution`,`Feedback_reccomendation`,`Feedback_received_date`,`Manuscript_idManuscript`,`Reviewer_idReviewer`) VALUES (8,4,10,3,10,"2018-06-15 01:37:27",1,16),(6,6,8,4,0,"2019-07-17 01:06:12",4,19),(9,10,5,8,10,"2018-06-01 11:05:47",5,17),(6,9,6,8,10,"2019-09-12 14:06:26",6,32),(4,6,2,10,10,"2020-01-29 13:37:24",8,17),(4,4,5,1,10,"2018-03-06 00:49:04",9,38),(8,7,6,9,10,"2018-03-27 20:17:51",10,3),(10,1,2,9,0,"2019-06-01 08:26:17",11,20),(9,3,1,5,10,"2018-10-03 09:58:38",12,39),(9,10,10,4,10,"2019-04-16 23:47:14",13,28);
INSERT INTO `Feedback` (`Feedback_appropriateness`,`Feedback_clarity`,`Feedback_methodology`,`Feedback_contribution`,`Feedback_reccomendation`,`Feedback_received_date`,`Manuscript_idManuscript`,`Reviewer_idReviewer`) VALUES (4,6,8,7,10,"2019-12-29 10:19:32",36,2),(10,9,5,10,10,"2018-06-10 11:41:17",38,39),(2,6,5,9,10,"2019-11-03 12:36:43",14,25),(6,7,6,7,0,"2018-09-23 10:35:48",15,39),(5,7,10,10,10,"2020-02-02 15:49:54",20,6),(2,4,7,1,0,"2019-12-06 01:49:01",17,40),(4,4,4,2,10,"2019-07-24 09:37:44",18,31),(2,8,9,2,0,"2020-01-15 03:13:34",19,13),(8,7,9,3,10,"2018-07-14 11:18:58",21,10),(6,7,8,8,10,"2018-03-09 00:12:43",22,36);
INSERT INTO `Feedback` (`Feedback_appropriateness`,`Feedback_clarity`,`Feedback_methodology`,`Feedback_contribution`,`Feedback_reccomendation`,`Feedback_received_date`,`Manuscript_idManuscript`,`Reviewer_idReviewer`) VALUES (7,8,10,10,0,"2019-10-15 06:25:45",20,28),(9,9,9,6,10,"2019-06-20 07:27:37",14,35),(2,7,4,2,10,"2019-07-28 05:05:29",15,35),(7,9,5,10,0,"2018-03-25 03:37:48",17,3),(4,7,7,6,0,"2019-01-28 04:47:08",18,35),(9,5,9,10,10,"2020-01-25 16:29:40",19,39),(7,3,5,9,10,"2018-06-16 12:10:15",21,40),(3,9,2,4,0,"2018-03-07 10:06:02",22,38),(4,9,2,1,0,"2019-12-27 23:21:34",23,37),(4,5,10,5,10,"2018-07-13 00:22:35",23,36);
INSERT INTO `Feedback` (`Feedback_appropriateness`,`Feedback_clarity`,`Feedback_methodology`,`Feedback_contribution`,`Feedback_reccomendation`,`Feedback_received_date`,`Manuscript_idManuscript`,`Reviewer_idReviewer`) VALUES (3,2,1,10,10,"2019-02-23 06:05:58",24,33),(3,2,6,10,10,"2019-10-24 18:19:34",24,34),(8,10,8,10,10,"2018-05-06 16:42:08",26,30),(6,6,10,10,10,"2019-07-20 13:12:53",26,34),(1,7,6,3,10,"2019-07-01 13:16:56",28,33),(6,6,5,6,0,"2020-01-05 10:13:06",28,34),(2,3,10,9,0,"2019-10-31 11:29:31",29,29),(9,4,5,9,10,"2019-11-17 00:53:06",29,30),(10,3,10,10,10,"2019-07-20 22:45:40",31,33),(10,10,7,7,10,"2018-12-01 20:27:51",31,27);
INSERT INTO `Feedback` (`Feedback_appropriateness`,`Feedback_clarity`,`Feedback_methodology`,`Feedback_contribution`,`Feedback_reccomendation`,`Feedback_received_date`,`Manuscript_idManuscript`,`Reviewer_idReviewer`) VALUES (3,5,2,8,10,"2019-09-12 05:42:23",32,30),(10,3,1,3,10,"2019-03-07 07:42:01",32,31),(4,9,10,3,10,"2019-04-24 09:23:51",33,4),(7,7,8,9,0,"2018-12-17 04:24:21",33,12),(3,2,10,2,0,"2018-07-25 06:12:22",35,27),(10,3,6,2,1,"2018-03-16 17:06:18",35,28),(10,9,1,3,0,"2018-02-16 03:21:51",37,28),(8,3,4,8,0,"2019-02-04 17:18:59",37,18),(8,6,6,8,10,"2018-12-10 04:12:51",39,14),(9,7,7,5,10,"2018-07-17 09:19:18",39,10);
INSERT INTO `Feedback` (`Feedback_appropriateness`,`Feedback_clarity`,`Feedback_methodology`,`Feedback_contribution`,`Feedback_reccomendation`,`Feedback_received_date`,`Manuscript_idManuscript`,`Reviewer_idReviewer`) VALUES (10,10,9,9,10,"2019-10-26 00:54:09",41,9),(7,7,7,7,10,"2018-09-10 17:23:40",46,7),(7,10,9,9,10,"2019-07-01 07:31:49",45,29),(7,9,8,9,10,"2019-06-08 23:55:09",42,4),(8,10,10,8,10,"2018-09-12 18:20:38",41,2),(7,3,3,10,0,"2019-01-22 03:50:26",50,31),(1,7,6,8,0,"2019-11-07 03:03:41",48,9),(5,3,1,9,10,"2018-11-04 05:29:04",44,5),(8,7,3,8,0,"2018-08-01 13:40:14",43,6),(1,1,6,2,0,"2018-06-22 07:50:02",40,30);
INSERT INTO `Feedback` (`Feedback_appropriateness`,`Feedback_clarity`,`Feedback_methodology`,`Feedback_contribution`,`Feedback_reccomendation`,`Feedback_received_date`,`Manuscript_idManuscript`,`Reviewer_idReviewer`) VALUES (9,9,10,6,10,"2019-06-02 18:06:49",41,10),(10,8,10,8,10,"2019-04-28 16:29:51",46,8),(9,7,9,9,10,"2019-12-11 21:21:31",45,8),(9,8,8,9,10,"2019-01-20 10:40:18",42,6),(8,7,9,9,10,"2018-11-19 13:33:05",41,24),(4,3,3,6,0,"2019-02-13 10:05:54",50,11),(5,9,6,10,0,"2018-02-14 00:40:03",48,10),(2,7,4,6,10,"2019-04-24 07:22:08",44,21),(5,1,4,9,10,"2019-06-11 21:07:12",43,7),(1,7,3,6,0,"2018-06-03 06:06:25",40,26);

#RI_code is an AUTO_INCREMENT value, 1-40
INSERT INTO `Interest_area` (`Area_name`) VALUES ("porttitor scelerisque neque. Nullam nisl. Maecenas malesuada"),("Duis sit amet diam"),("Nunc ac sem ut dolor dapibus gravida. Aliquam"),("augue id ante dictum cursus. Nunc"),("Aenean euismod"),("quis accumsan convallis,"),("sociis natoque penatibus et magnis"),("convallis dolor."),("Suspendisse eleifend. Cras sed leo."),("dignissim pharetra. Nam ac nulla. In tincidunt congue");
INSERT INTO `Interest_area` (`Area_name`) VALUES ("blandit mattis. Cras"),("ridiculus mus. Aenean eget magna. Suspendisse tristique neque venenatis"),("libero"),("at auctor ullamcorper, nisl arcu"),("penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec"),("Sed eu nibh vulputate mauris sagittis placerat. Cras dictum"),("dapibus id, blandit at,"),("arcu et pede. Nunc sed"),("imperdiet, erat nonummy ultricies"),("ligula tortor, dictum eu, placerat eget, venenatis a, magna. Lorem");
INSERT INTO `Interest_area` (`Area_name`) VALUES ("litora torquent per conubia"),("sit amet nulla. Donec non"),("In at"),("euismod enim. Etiam gravida molestie arcu. Sed eu"),("eu, euismod ac, fermentum vel, mauris. Integer"),("enim, sit amet ornare lectus justo eu arcu."),("Nunc mauris elit, dictum eu,"),("lacinia orci, consectetuer"),("pede, ultrices a, auctor non, feugiat"),("lorem tristique aliquet. Phasellus fermentum convallis");
INSERT INTO `Interest_area` (`Area_name`) VALUES ("mauris"),("non, vestibulum nec, euismod in,"),("sapien, cursus"),("pede."),("arcu. Vestibulum ante ipsum primis in faucibus orci"),("In scelerisque scelerisque"),("ac mattis semper, dui lectus rutrum urna, nec luctus felis"),("luctus. Curabitur egestas nunc sed libero. Proin sed"),("ipsum dolor"),("sit amet luctus vulputate, nisi sem semper erat, in");


#includes cases where same reviewer has multiple interest areas
#includes cases where same interest area has multiple reviewers 
#all reviewers must specify at least one area of interest, and can have up to 3. An area of interest can have many reviewers
INSERT INTO `Reviewer_has_Interest_area` (`Reviewer_idReviewer`,`Interest_area_RI_code`) VALUES (1,33),(1,37),(1,13),(2,24),(2,8),(2,34),(3,40),(3,16),(3,9),(4,15),(4,17),(4,4);
INSERT INTO `Reviewer_has_Interest_area` (`Reviewer_idReviewer`,`Interest_area_RI_code`) VALUES (9,18),(9,2),(9,35),(10,28),(10,2),(10,35),(11,17),(11,30),(12,32),(12,17);
INSERT INTO `Reviewer_has_Interest_area` (`Reviewer_idReviewer`,`Interest_area_RI_code`) VALUES (5,32),(5,3),(5,25),(6,17),(6,4),(6,27),(7,40),(7,27),(7,5),(8,20),(8,14),(8,5);
INSERT INTO `Reviewer_has_Interest_area` (`Reviewer_idReviewer`,`Interest_area_RI_code`) VALUES (13,16),(13,40),(14,28),(14,18),(15,15),(15,16),(16,9),(16,15),(17,17),(17,40);
INSERT INTO `Reviewer_has_Interest_area` (`Reviewer_idReviewer`,`Interest_area_RI_code`) VALUES (18,14),(18,1),(19,28),(20,16),(20,15),(21,8),(21,4),(21,25),(22,15),(22,27);
INSERT INTO `Reviewer_has_Interest_area` (`Reviewer_idReviewer`,`Interest_area_RI_code`) VALUES (23,5),(23,2),(24,39),(24,8),(25,1),(25,12),(26,25),(26,30),(27,39),(27,3);
INSERT INTO `Reviewer_has_Interest_area` (`Reviewer_idReviewer`,`Interest_area_RI_code`) VALUES (27,37),(28,1),(28,17),(28,37),(29,30),(29,21),(29,14),(30,16),(30,21),(30,30);
INSERT INTO `Reviewer_has_Interest_area` (`Reviewer_idReviewer`,`Interest_area_RI_code`) VALUES (31,21),(31,24),(31,30),(32,35),(32,31),(32,32),(33,34),(33,39),(33,3),(34,34);
INSERT INTO `Reviewer_has_Interest_area` (`Reviewer_idReviewer`,`Interest_area_RI_code`) VALUES (34,16),(34,39),(35,12),(35,26),(35,24),(36,12),(36,33),(36,38),(37,40),(37,34);
INSERT INTO `Reviewer_has_Interest_area` (`Reviewer_idReviewer`,`Interest_area_RI_code`) VALUES (37,38),(38,15),(38,18),(38,33),(39,40),(39,13),(39,26),(40,26),(40,9),(40,28);

#includes cases where same author has multiple manuscripts
#includes cases where same manuscript has multiple authors
#includes cases where an author is the primary author for multiple manuscripts
#includes cases where author is not a primary author for any manuscript
#author order starts at 0 for primary author, and increments from there
#every manuscript has a primary author. An author can be the primary author for multiple manuscripts. Every author has a manuscript
INSERT INTO `Author_has_Manuscript` (`Author_idAuthor`,`Manuscript_idManuscript`,`Author_order`) VALUES (17,1,0),(2,2,0),(13,3,0),(5,4,0),(13,5,0),(21,6,0),(11,7,0),(34,8,0),(5,9,0),(31,10,0);
INSERT INTO `Author_has_Manuscript` (`Author_idAuthor`,`Manuscript_idManuscript`,`Author_order`) VALUES (1,11,0),(25,12,0),(33,13,0),(13,14,0),(31,15,0),(32,16,0),(13,17,0),(15,18,0),(24,19,0),(11,20,0);
INSERT INTO `Author_has_Manuscript` (`Author_idAuthor`,`Manuscript_idManuscript`,`Author_order`) VALUES (3,21,0),(32,22,0),(12,23,0),(13,24,0),(39,25,0),(30,26,0),(23,27,0),(20,28,0),(7,29,0),(20,30,0);
INSERT INTO `Author_has_Manuscript` (`Author_idAuthor`,`Manuscript_idManuscript`,`Author_order`) VALUES (13,31,0),(18,32,0),(20,33,0),(25,34,0),(18,35,0),(3,36,0),(6,37,0),(9,38,0),(3,39,0),(5,40,0);
INSERT INTO `Author_has_Manuscript` (`Author_idAuthor`,`Manuscript_idManuscript`,`Author_order`) VALUES (3,41,0),(39,42,0),(10,43,0),(19,44,0),(36,45,0),(25,46,0),(6,47,0),(17,48,0),(12,49,0),(35,50,0);
INSERT INTO `Author_has_Manuscript` (`Author_idAuthor`,`Manuscript_idManuscript`,`Author_order`) VALUES (22,1,1),(14,2,1),(4,3,1),(16,4,1),(26,5,1),(27,6,1),(37,7,1),(8,8,1),(28,9,1),(38,10,1);
INSERT INTO `Author_has_Manuscript` (`Author_idAuthor`,`Manuscript_idManuscript`,`Author_order`) VALUES (29,11,1),(40,12,1),(29,13,1),(2,5,2),(3,5,3),(12,4,2),(36,4,3),(39,4,4),(40,4,5),(21,1,2);

#manuscript accepted only if status is accepted
#includes multiple manuscripts in same issue
INSERT INTO `Manuscript_Accepted` (`Manuscript_idManuscript`,`Issue_idIssue`) VALUES (6,2),(13,7),(20,10),(26,3),(31,15),(39,16),(41,6),(42,5),(45,11),(46,7),(47,2);

-- ---
-- For all authors, return tuples with their last name, author id,
-- and the manuscript id for which they are the primary author,
-- along with the current status of the manuscript, and the timestamp
-- of the most recent status change. If an author currently has two
-- manuscripts in the system, the view would return two tuples (rows).
-- Results ordered by author last name, author id number, and then by
-- increasing timestamp of most recent status change. 
-- Permissions: Editor.
-- ---

-- Drop to be safe
DROP VIEW IF EXISTS LeadAuthorManuscripts;

-- Create view
CREATE VIEW LeadAuthorManuscripts AS
    SELECT Author_last_name, idAuthor, idManuscript, Manuscript_status, Manuscript_timestamp
    FROM Author a, Manuscript m, Author_has_Manuscript am
    WHERE Author_order = '0'
				AND idAuthor = Author_idAuthor 
                AND idManuscript = Manuscript_idManuscript
    ORDER BY Author_last_name, idAuthor, Manuscript_timestamp ASC;

-- ---
-- For all authors, their name, id, and the manuscript(s) for which they 
-- are among the authors (if any), along with the status of the manuscript(s). 
-- Results ordered by author last name and then by increasing timestamp of most recent
-- status change. 
-- Permissions: Author, Editor.
-- ---

-- Drop to be safe
DROP VIEW IF EXISTS AnyAuthorManuscripts;

-- Create the view
CREATE VIEW AnyAuthorManuscripts AS
	SELECT Author_first_name, Author_last_name, idAuthor, idManuscript, Manuscript_status
    FROM Author a, Manuscript, Author_has_Manuscript
    WHERE  idAuthor = Author_idAuthor 
                AND idManuscript = Manuscript_idManuscript
    ORDER BY Author_last_name, Manuscript_timestamp ASC;

-- ---
-- For all completed (published) issues, the issue year, 
-- issue number (1, 2, 3, or 4), the title of each manuscript included in that issue, 
-- with page numbers, ordered by issue year, issue number, and page numbers. 
-- Permissions: Author, Editor, Reviewer.
-- ---
    
-- Drop to be safe
DROP VIEW IF EXISTS PublishedIssues;

-- Create the view
CREATE VIEW PublishedIssues AS
    SELECT Issue_year, Issue_period, Manuscript_title, Issue_num
    FROM Issue i, Manuscript m, Manuscript_Accepted ma
    WHERE idManuscript = Manuscript_idManuscript
    ORDER BY Issue_year, Issue_period, issue_num;
-- ---
-- For all manuscripts in UnderReview state. The view should contain the primary
-- author, author id, manuscript id, and assigned reviewer(s) are included all together
 -- in one row, with the rows ordered by increasing most recent status change timestamp. 
 -- Also used by ReviewStatus view. 
 -- Permissions: Editor.
-- ---

DROP VIEW IF EXISTS ReviewQueue;


CREATE VIEW ReviewQueue AS
    SELECT Author_first_name, Author_last_name, Author_idAuthor , f.Manuscript_idManuscript, Reviewer_first_name, Reviewer_last_name
    FROM Author a, Manuscript m, Author_has_Manuscript am, Reviewer r, Feedback f
    WHERE Author_order = '0'
                AND Manuscript_status = 'underreview'
                AND idAuthor = Author_idAuthor 
                AND idManuscript = f.Manuscript_idManuscript
                
    ORDER BY Manuscript_timestamp;

-- --- 
 -- For all manuscripts, the manuscript id, current status, 
 -- and the timestamp of the current status.
 -- Permissions: Editor.
-- ---

-- Drop to be safe
DROP VIEW IF EXISTS WhatsLeft;

-- Create view
CREATE VIEW WhatsLeft AS
	SELECT idManuscript, Manuscript_status, Manuscript_timestamp
    FROM Manuscript;

-- ---
-- For all manuscripts assigned to the Reviewer, a view including:

-- the timestamp when it was assigned to this review
-- the manuscript id
-- the manuscript title
-- the review results (integer values 1-10)
-- appropriatenes score
-- clarity score
-- methodology score
-- experimental resuts score
-- recommendation (either “accept” or “reject”)
-- ordered by increasing submission timestamp.
-- HINT: Since you cannot modify a view “on the fly”, you will need to do something like the following to get the desired ReviewerId into the view:

-- create a SQL function ViewRevId that returns the value of a SQL variable (e.g., @rev_id)
-- use that SQL function in the view to identify the desired reviewer id
-- set the variable (e.g., SET @rev_id = reviewer_id_you_want)
-- SELECT whatever FROM ViewRevId @rev_id
-- Permissions: Editor, Reviewer.

DROP FUNCTION IF EXISTS ViewRevId;

DELIMITER $$
CREATE FUNCTION ViewRevId(reviewer_id_wanted INT) RETURNS INT DETERMINISTIC
BEGIN
	DECLARE rev_id INT;
	SET rev_id = reviewer_id_wanted;
    RETURN (rev_id);
END; $$
DELIMITER ;

-- Drop view to be safe
DROP VIEW IF EXISTS ReviewStatuses;

-- Create view
CREATE VIEW ReviewStatuses AS
	SELECT idReviewer, idManuscript, Manuscript_title, Feedback_appropriateness, Feedback_clarity, Feedback_methodology, Feedback_contribution, Feedback_reccomendation
    FROM Feedback
		JOIN Reviewer ON Reviewer_idReviewer = idReviewer
        JOIN Manuscript ON idManuscript = Manuscript_idManuscript
        WHERE
        idManuscript = Manuscript_idManuscript  AND Reviewer_idReviewer = idReviewer AND Reviewer_idReviewer = ViewRevId(1)
    ORDER BY Manuscript_timestamp;
