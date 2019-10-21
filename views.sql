/*
Syed Tanveer % Eileen Xia
CS61
Lab 2c
*/


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
    WHERE Author_order = '1'
				AND idAuthor = Author_idAuthor 
                AND idManuscript = Manuscript_idManuscript
    ORDER BY Author_last_name, idAuthor, Manuscript_timestamp ASC;
    
-- Show view
SELECT * FROM LeadAuthorManuscripts;


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

-- Show view
SELECT * FROM AnyAuthorManuscripts;

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

-- Show view
SELECT * FROM PublishedIssues;

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
    WHERE Author_order = '1'
                AND Manuscript_status = 'underreview'
                AND idAuthor = Author_idAuthor 
                AND idManuscript = f.Manuscript_idManuscript
                
    ORDER BY Manuscript_timestamp;

-- Show view

SELECT * FROM ReviewQueue;

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

-- Show view
SELECT * FROM WhatsLeft;

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
	SELECT idManuscript, Manuscript_title, Feedback_appropriateness, Feedback_clarity, Feedback_methodology, Feedback_contribution, Feedback_reccomendation
    FROM Feedback
		JOIN Reviewer ON Reviewer_idReviewer = idReviewer
        JOIN Manuscript ON idManuscript = Manuscript_idManuscript
        WHERE
        idManuscript = Manuscript_idManuscript  AND Reviewer_idReviewer = idReviewer AND Reviewer_idReviewer = ViewRevId(1)
    ORDER BY Manuscript_timestamp;

-- Show view
SELECT * FROM ReviewStatuses;



