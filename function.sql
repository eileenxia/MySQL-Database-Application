/*
Syed Tanveer % Eileen Xia
CS61
Lab 2c
*/


DROP FUNCTION IF EXISTS ManuscriptDecision;

DELIMITER $$
CREATE FUNCTION ManuscriptDecision(Manuscript_id INT) RETURNS INT DETERMINISTIC
	
    BEGIN
	DECLARE avgApp INT;
    DECLARE avgClarity INT;
    DECLARE avgMethod INT;
    DECLARE avgContribute INT;
    DECLARE avgRec INT;
    DECLARE averageScore INT;
	DECLARE minimum int;
    SET minimum= 35;
    
    SET avgApp = (SELECT AVG(Feedback_appropriateness) FROM Feedback WHERE Manuscript_id = Manuscript_idManuscript);
    SET avgClarity = (SELECT AVG(Feedback_clarity) FROM Feedback WHERE Manuscript_id = Manuscript_idManuscript);
	SET avgMethod = (SELECT AVG(Feedback_methodology) FROM Feedback WHERE Manuscript_id = Manuscript_idManuscript);
	SET avgContribute = (SELECT AVG(Feedback_contribution) FROM Feedback WHERE Manuscript_id = Manuscript_idManuscript);
	SET avgRec = (SELECT AVG(Feedback_reccomendation) FROM Feedback WHERE Manuscript_id = Manuscript_idManuscript);
	
    SET averageScore = avgApp + avgClarity + avgMethod + avgContribute + avgRec;
    
    IF averageScore < minimum THEN
		UPDATE Manuscript 
        SET Manuscript.Manuscript_status = 'rejected', 
        Manuscript.Manuscript_timestamp = CURRENT_TIMESTAMP,
		Manuscript.Manuscript_score =averageScore
        WHERE idManuscript = Manuscript_id;
	ELSEIF averageScore >= minimum THEN
		UPDATE Manuscript SET Manuscript.Manuscript_status = 'accepted',
        Manuscript.Manuscript_timestamp = CURRENT_TIMESTAMP,
		Manuscript.Manuscript_score =averageScore
        WHERE idManuscript = Manuscript_id;
	END IF;
    RETURN (averageScore);
END;$$
DELIMITER ;