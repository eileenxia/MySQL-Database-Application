/*
Syed Tanveer % Eileen Xia
CS61
Lab 2c
*/

-- Manual 11 is 'underreview' and should have a NULL score
SELECT Manuscript_status, Manuscript_score FROM Manuscript  WHERE idManuscript = 11;
SELECT ManuscriptDecision(11); -- score gets averaged and added to final score, status changes based on score
SELECT Manuscript_status, Manuscript_score FROM Manuscript  WHERE idManuscript = 11; -- status will be accepted

-- Manual 35 is 'underreview' and should have a NULL score
SELECT Manuscript_status, Manuscript_score FROM Manuscript  WHERE idManuscript = 35;
SELECT ManuscriptDecision(35); -- score gets averaged and added to final score, status changes based on score
SELECT Manuscript_status, Manuscript_score FROM Manuscript  WHERE idManuscript = 35; -- status will be rejected

-- Manual 50 is 'underreview' and should have a NULL score
SELECT Manuscript_status, Manuscript_score FROM Manuscript  WHERE idManuscript = 50;
SELECT ManuscriptDecision(50); -- score gets averaged and added to final score, status changes based on score
SELECT Manuscript_status, Manuscript_score FROM Manuscript  WHERE idManuscript = 50; -- status will be rejected