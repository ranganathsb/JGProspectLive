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
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
   Friday, May 19, 20176:50:34 PM
   User: jgrovesa
   Server: jgdbserver001.cdgdaha6zllk.us-west-2.rds.amazonaws.com,1433
   Database: JGBS_Dev_New
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblTask ADD
	Sequence bigint NULL
GO
ALTER TABLE dbo.tblTask SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'CONTROL') as Contr_Per 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 05162017
-- Description:	This will update task sequence
-- =============================================
CREATE PROCEDURE usp_UpdateTaskSequence 
(	
	@Sequence bigint , 
	@TaskId bigint 
)
AS
BEGIN

-- if sequence is already assigned to some other task, all sequence will push back by 1 from alloted sequence.
		IF EXISTS(SELECT TaskId FROM tblTask WHERE [Sequence] = @Sequence AND TaskId <> @TaskId)
		BEGIN

			UPDATE       tblTask
			SET                [Sequence] = [Sequence] + 1			
			WHERE        ([Sequence] >= @Sequence)

		END


		
			UPDATE tblTask
			SET                [Sequence] = @Sequence	
			WHERE        (TaskId = @TaskId)


END
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


DROP VIEW [dbo].[TaskListView] 
GO

/****** Object:  View [dbo].[TaskListView]    Script Date: 5/19/2017 8:05:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[TaskListView] 
AS
SELECT 
	Tasks.*,

	TaskCreator.Id AS TaskCreatorId,
	TaskCreator.InstallId AS TaskCreatorInstallId,
	TaskCreator.FristName AS TaskCreatorUsername, 
	TaskCreator.FristName AS TaskCreatorFirstName, 
	TaskCreator.LastName AS TaskCreatorLastName, 
	TaskCreator.Email AS TaskCreatorEmail,

	--AdminUser.Id AS AdminUserId,
	AdminUser.InstallId AS AdminUserInstallId,
	AdminUser.Username AS AdminUsername,
	AdminUser.FirstName AS AdminUserFirstName,
	AdminUser.LastName AS AdminUserLastName,
	AdminUser.Email AS AdminUserEmail,
			
	--TechLeadUser.Id AS TechLeadUserId,
	TechLeadUser.InstallId AS TechLeadUserInstallId,
	TechLeadUser.Username AS TechLeadUsername,
	TechLeadUser.FirstName AS TechLeadUserFirstName,
	TechLeadUser.LastName AS TechLeadUserLastName,
	TechLeadUser.Email AS TechLeadUserEmail,

	--OtherUser.Id AS OtherUserId,
	OtherUser.InstallId AS OtherUserInstallId,
	OtherUser.Username AS OtherUsername,
	OtherUser.FirstName AS OtherUserFirstName,
	OtherUser.LastName AS OtherUserLastName,
	OtherUser.Email AS OtherUserEmail,
	STUFF
	(
		(SELECT  CAST(', ' + td.Designation as VARCHAR) AS Designation
		FROM tblTaskDesignations td
		WHERE td.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskDesignations,
	STUFF
	(
		(SELECT  CAST(', ' + u.FristName + ' ' + u.LastName as VARCHAR) AS Name
		FROM tblTaskAssignedUsers tu
			INNER JOIN tblInstallUsers u ON tu.UserId = u.Id
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskAssignedUsers,
	STUFF
	(
		(SELECT  ',' + CAST(tu.UserId as VARCHAR) AS Id
		FROM tblTaskAssignedUsers tu
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,1
		,''
	) AS TaskAssignedUserIds,
	STUFF
	(
		(SELECT  CAST(', ' + CAST(tu.UserId AS VARCHAR) + ':' + u.FristName as VARCHAR) AS Name
		FROM tblTaskAssignmentRequests tu
			INNER JOIN tblInstallUsers u ON tu.UserId = u.Id
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskAssignmentRequestUsers,
	STUFF
	(
		(SELECT  ', ' + CAST(tu.UserId AS VARCHAR) AS UserId
		FROM tblTaskAcceptance tu
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskAcceptanceUsers,
	STUFF
	(
		(SELECT  CAST(
						', ' + CAST(tuf.[Id] AS VARCHAR) + 
						'@' + tuf.[Attachment] + 
						'@' + tuf.[AttachmentOriginal]  + 
						'@' + CAST( tuf.[AttachedFileDate] AS VARCHAR(100)) + 
						'@' + (
								CASE 
									WHEN ctuser.Id IS NULL THEN 'N.A.' 
									ELSE ISNULL(ctuser.FirstName,'') + ' ' + ISNULL(ctuser.LastName ,'')
								END
							) as VARCHAR(max)) AS attachment
		FROM dbo.tblTaskUserFiles tuf  
			OUTER APPLY
			(
				SELECT TOP 1 iu.Id, iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
				FROM tblInstallUsers iu
				WHERE iu.Id = tuf.UserId
			
				UNION

				SELECT TOP 1 u.Id,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
				FROM tblUsers u
				WHERE u.Id = tuf.UserId
			) AS ctuser
		WHERE tuf.TaskId = Tasks.TaskId AND tuf.IsDeleted <> 1
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskUserFiles
FROM          
	tblTask AS Tasks
		LEFT JOIN tblInstallUsers TaskCreator ON TaskCreator.Id = Tasks.CreatedBy
		OUTER APPLY
		(
			SELECT TOP 1 iu.Id, iu.InstallId ,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
			FROM tblInstallUsers iu
			WHERE iu.Id = Tasks.AdminUserId AND Tasks.IsAdminInstallUser = 1
			
			UNION

			SELECT TOP 1 u.Id, '' AS InstallId ,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
			FROM tblUsers u
			WHERE u.Id = Tasks.AdminUserId AND Tasks.IsAdminInstallUser = 0
		) AS AdminUser
		OUTER APPLY
		(
			SELECT TOP 1 iu.Id, iu.InstallId ,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
			FROM tblInstallUsers iu
			WHERE iu.Id = Tasks.TechLeadUserId AND Tasks.IsTechLeadInstallUser = 1
			
			UNION

			SELECT TOP 1 u.Id, '' AS InstallId ,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
			FROM tblUsers u
			WHERE u.Id = Tasks.TechLeadUserId AND Tasks.IsTechLeadInstallUser = 0
		) AS TechLeadUser
		OUTER APPLY
		(
			SELECT TOP 1 iu.Id, iu.InstallId ,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
			FROM tblInstallUsers iu
			WHERE iu.Id = Tasks.OtherUserId AND Tasks.IsOtherUserInstallUser = 1
			
			UNION

			SELECT TOP 1 u.Id, '' AS InstallId ,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
			FROM tblUsers u
			WHERE u.Id = Tasks.OtherUserId AND Tasks.IsOtherUserInstallUser = 0
		) AS OtherUser






GO

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 05152017
-- Description:	This will load last available sequence for task
-- =============================================
CREATE PROCEDURE usp_GetLastAvailableSequence 

AS
BEGIN

	SELECT ISNULL(MAX([Sequence])+1,1) AS [Sequence] FROM tblTask

END
GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DROP PROCEDURE [dbo].GetTaskHierarchy
GO
-- =============================================    
-- Author:  Yogesh    
-- Create date: 20 March 2017    
-- Description: Get one or all tasks with all sub tasks from all levels.    
-- =============================================    
-- [GetTaskHierarchy] 418, 1  
    
CREATE PROCEDURE  [dbo].[GetTaskHierarchy]     
 @TaskId INT = NULL    
 ,@Admin BIT    
AS    
BEGIN    
     
 ;WITH cteTasks    
 AS    
 (    
  SELECT t1.*    
  FROM [TaskListView] t1    
  WHERE 1 = CASE      
      WHEN @TaskId IS NULL AND ParentTaskId IS NULL THEN 1    
      WHEN @TaskId = TaskId THEN 1    
      ELSE 0    
    END    
    
  UNION ALL    
    
  SELECT t2.*    
  FROM [TaskListView] t2 inner join cteTasks    
   on t2.ParentTaskId = cteTasks.TaskId  AND cteTasks.IsTechTask = 1  
  WHERE t2.IsTechTask = 1  
 )    
    
 SELECT *    
 FROM cteTasks LEFT JOIN [TaskApprovalsView] TaskApprovals     
   ON cteTasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin    
   
 ORDER BY [Sequence],cteTasks.TaskLevel, cteTasks.ParentTaskId    
    
END 

----------------------------------------------------------------------------------------------------------------------------------------

-- Live Published on 05212017


----------------------------------------------------------------------------------------------------------------------------------------