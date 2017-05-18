--EXEC usp_GetCandidateTestsResults '2736'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 051472017
-- Description:	This will load candidates apptitude test results.
-- =============================================
-- usp_GetCandidateTestsResults '2736'
CREATE PROCEDURE usp_GetCandidateTestsResults 
(
	@UserID VARCHAR(MAX) 
)
AS
BEGIN


	SET NOCOUNT ON;

SELECT        TestResults.ExamID, MCQ_Exam.ExamTitle, TestResults.[Aggregate], ISNULL(TestResults.ExamPerformanceStatus,0) AS Result, TestResults.UserID
FROM            MCQ_Performance AS TestResults INNER JOIN
                         MCQ_Exam ON TestResults.ExamID = MCQ_Exam.ExamID
WHERE        (TestResults.UserID = @UserID)


END
GO
