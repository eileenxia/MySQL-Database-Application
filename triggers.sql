/*
Syed Tanveer % Eileen Xia
CS61
Lab 2c
*/


DROP TRIGGER IF EXISTS icode_trigger;
DROP TRIGGER IF EXISTS on_resign_trigger;
DROP TRIGGER IF EXISTS on_accepted;
-- ---
-- Trigger 1: When an author is submitting a new manuscript to the system with an 
-- ICode for which there is no reviewer who handles that ICode you should raise an 
-- exception that informs the author the paper can not be considered at this time.
-- --
DELIMITER $$
CREATE TRIGGER icode_trigger BEFORE INSERT ON Manuscript
	FOR EACH ROW
    BEGIN
		DECLARE message VARCHAR(128);
		IF (
        (SELECT COUNT(*) FROM Manuscript, Interest_area
											WHERE  Manuscript_RI_Code = new.Manuscript_RI_Code
											AND new.Manuscript_RI_Code = RI_code) = 0 )
		THEN
			SET message = CONCAT('UserException: RI Code does not exist, Please choose one that a reviewer is assigned to', new.Manuscript_RI_Code);
			-- MySQL doc defines SQLSTATE 45000 as "unhandled user-defined exception."
			SIGNAL SQLSTATE '45000' SET message_text = message;
		END IF;
	END$$
-- ---
-- Trigger 3: When a manuscript’s status changes to “accepted”, that update triggers an immediate status change to
-- “typesetting”.
-- ---

CREATE TRIGGER on_accepted AFTER UPDATE ON Manuscript
FOR EACH ROW
	BEGIN
    DECLARE message VARCHAR(300);
	IF (SELECT Manuscript_status FROM Manuscript WHERE Manuscript_status = 'accepted' AND idManuscript = new.idManuscript)
    THEN
         SET Manuscript_status = 'typesetting', Manuscript_timestamp = CURRENT_TIMESTAMP,
        message = CONCAT(' Manuscript status changed to typesetting from accepted');
    END IF;
END$$


-- ---
-- Trigger 2: When a reviewer resigns any manuscript in “UnderReview” state for which that reviewer was the'
-- only reviewer AND there is another reviewer in the system with the matching ICode that isn’t already assigned
--  to review it, that manuscript must be reset to “submitted” state and an appropriate exception message displayed.
-- ---

CREATE TRIGGER on_resign_trigger BEFORE DELETE ON Reviewer
FOR EACH ROW
BEGIN
	DECLARE message VARCHAR(300);
    IF (
        (SELECT Count(*) from Manuscript
			JOIN (SELECT * FROM Feedback WHERE Reviewer_idReviewer = OLD.idReviewer) AS reviews ON reviews.Manuscript_idManuscript = idManuscript
            WHERE Manuscript_status = 'underreview') > 0
    ) THEN
		UPDATE Manuscript
		JOIN (SELECT * FROM Feedback WHERE Reviewer_idReviewer = OLD.idReviewer) AS reviews ON reviews.Manuscript_idManuscript = idManuscript
        SET Manuscript_status = 'accepted', message = CONCAT(' Manuscript is now reset to submited because it does not have an appropriate number of reviewers')
        WHERE Manuscript_status = 'underreview';
    END IF;
    DELETE FROM Reviewer_has_Interest_area WHERE Reviewer_idReviewer = OLD.idReviewer;
	DELETE FROM Feedback WHERE Reviewer_idReviewer = OLD.idReviewer;
    DELETE FROM Reviewer WHERE idReviewer = OLD.idReviewer;
END$$

DELIMITER ;