/*
Syed Tanveer % Eileen Xia
CS61
Lab 2c
*/


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
DROP TABLE IF EXISTS `stanveer_db`.`Editor` ;

CREATE TABLE IF NOT EXISTS `stanveer_db`.`Editor` (
  `idEditor` INT NOT NULL AUTO_INCREMENT,
  `Editor_first_name` VARCHAR(45) NOT NULL,
  `Editor_last_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idEditor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stanveer_db`.`Manuscript`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stanveer_db`.`Manuscript` ;

CREATE TABLE IF NOT EXISTS `stanveer_db`.`Manuscript` (
  `idManuscript` INT NOT NULL AUTO_INCREMENT,
  `Manuscript_title` VARCHAR(200) NOT NULL,
  `Manuscript_data` VARCHAR(200) NOT NULL,
  `Manuscript_status` VARCHAR(45) NOT NULL CHECK (Manuscript_status IN ('rejected', 'underreview', 'accepted', 'ready', 'scheduled', 'published')),
  `Manuscript_affiliation` VARCHAR(45) NOT NULL,
  `Manuscript_RI_Code` VARCHAR(45) NOT NULL,
  `Manuscript_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Manuscript_score` INT NULL,
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
  `Author_address` VARCHAR(45) NOT NULL,
  `Author_email` VARCHAR(100) NOT NULL,
  `Author_affiliation` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idAuthor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stanveer_db`.`Reviewer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stanveer_db`.`Reviewer` ;

CREATE TABLE IF NOT EXISTS `stanveer_db`.`Reviewer` (
  `idReviewer` INT NOT NULL AUTO_INCREMENT,
  `Reviewer_first_name` VARCHAR(45) NOT NULL,
  `Reviewer_Last_name` VARCHAR(45) NOT NULL,
  `Reviewer_email` VARCHAR(100) NOT NULL,
  `Reviewer_affiliation` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idReviewer`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stanveer_db`.`Feedback`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stanveer_db`.`Feedback` ;

CREATE TABLE IF NOT EXISTS `stanveer_db`.`Feedback` (
  `Feedback_appropriateness` INT NOT NULL,
  `Feedback_clarity` VARCHAR(45) NOT NULL,
  `Feedback_methodology` VARCHAR(45) NOT NULL,
  `Feedback_contribution` VARCHAR(45) NOT NULL,
  `Feedback_reccomendation` VARCHAR(45) NOT NULL,
  `Feedback_received_date` VARCHAR(45) NOT NULL,
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
  `Area_name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`RI_code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stanveer_db`.`Issue`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stanveer_db`.`Issue` ;

CREATE TABLE IF NOT EXISTS `stanveer_db`.`Issue` (
  `idIssue` INT NOT NULL AUTO_INCREMENT,
  `Issue_period` VARCHAR(45) NOT NULL,
  `Issue_year` VARCHAR(45) NOT NULL,
  `Issue_volume` VARCHAR(45) NOT NULL,
  `Issue_num` VARCHAR(45) NOT NULL,
  `Issue_print_date` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idIssue`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stanveer_db`.`Author_has_Manuscript`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stanveer_db`.`Author_has_Manuscript` ;

CREATE TABLE IF NOT EXISTS `stanveer_db`.`Author_has_Manuscript` (
  `Author_idAuthor` INT NOT NULL,
  `Manuscript_idManuscript` INT NOT NULL,
  `Author_order` VARCHAR(45) NOT NULL,
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
  `Manuscript_idManuscript` INT NOT NULL,
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