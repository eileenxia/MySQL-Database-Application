-- 100 is an unused RI code
INSERT INTO `Manuscript` (`Manuscript_title`,`Manuscript_data`,`Manuscript_status`,`Manuscript_affiliation`,`Manuscript_RI_Code`,`Editor_idEditor`) VALUES ("nibh dolor, nonummy","justo","ready","Eget Incorporated",100,1);

-- 31 has 1 reviewer
INSERT INTO `Manuscript` (`Manuscript_title`,`Manuscript_data`,`Manuscript_status`,`Manuscript_affiliation`,`Manuscript_RI_Code`,`Editor_idEditor`) VALUES ("nibh dolor, nonummy","justo","ready","Eget Incorporated",31,1);

-- 25 has 2 reviewers
INSERT INTO `Manuscript` (`Manuscript_title`,`Manuscript_data`,`Manuscript_status`,`Manuscript_affiliation`,`Manuscript_RI_Code`,`Editor_idEditor`) VALUES ("nibh dolor, nonummy","justo","ready","Eget Incorporated",25,1);


SELECT * FROM `Manuscript` WHERE idManuscript = 4;
DELETE FROM `Reviewer` WHERE idReviewer = 24;
SELECT * FROM `Manuscript` WHERE  idManuscript = 4;

SELECT * FROM `Manuscript` WHERE  idManuscript = 4;
DELETE FROM `Reviewer` WHERE idReviewer = 10;
SELECT * FROM `Manuscript` WHERE  idManuscript = 4;

SELECT
  idManuscript, Manuscript_status FROM Manuscript WHERE idManuscript = 50;
UPDATE Manuscript
SET Manuscript_status = 'accepted'
WHERE idManuscript = 50;
SELECT idManuscript, Manuscript_status FROM Manuscript WHERE idManuscript = 50;