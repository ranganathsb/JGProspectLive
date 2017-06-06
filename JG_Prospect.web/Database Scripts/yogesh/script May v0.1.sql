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

USE JGBS_Dev_New
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 05222017
-- Description:	This will load all tasks with title and sequence
-- =============================================
CREATE PROCEDURE usp_GetAllTaskWithSequence 

AS
BEGIN

	SELECT Title, [Sequence] AS TaskSequence FROM tblTask WHERE [Sequence] IS NOT NULL ORDER BY [Sequence] DESC

END
GO



-- =============================================  
-- Author:  Yogesh  
-- Create date: 14 Nov 16  
-- Description: Inserts, Updates or Deletes a task.  
-- =============================================  
ALTER PROCEDURE [dbo].[SP_SaveOrDeleteTask]    
  @Mode tinyint, -- 0:Insert, 1: Update, 2: Delete    
  @TaskId bigint,    
  @Title varchar(250),    
  @Url varchar(250),  
  @Description varchar(MAX),    
  @Status tinyint,    
  @DueDate datetime = NULL,    
  @Hours varchar(25),  
  @CreatedBy int,   
  @InstallId varchar(50) = NULL,  
  @ParentTaskId bigint = NULL,  
  @TaskType tinyint = NULL,  
  @TaskLevel int,  
  @MainTaskId int,  
  @TaskPriority tinyint = null,  
  @IsTechTask bit = NULL,  
  @DeletedStatus TINYINT = 9,  
  @Sequence bigint = NULL,
  @Result int output  
AS    
BEGIN    
    
 IF @Mode=0    
   BEGIN    
  INSERT INTO tblTask   
    (  
     Title,  
     Url,  
     [Description],  
     [Status],  
     DueDate,  
     [Hours],  
     CreatedBy,  
     CreatedOn,  
     IsDeleted,  
     InstallId,  
     ParentTaskId,  
     TaskType,  
     TaskPriority,  
     IsTechTask,  
     AdminStatus,  
     TechLeadStatus,  
     OtherUserStatus,  
     TaskLevel,  
     MainParentId  
    )  
  VALUES  
    (  
     @Title,  
     @Url,  
     @Description,  
     @Status,  
     @DueDate,  
     @Hours,  
     @CreatedBy,  
     GETDATE(),  
     0,  
     @InstallId,  
     @ParentTaskId,  
     @TaskType,  
     @TaskPriority,  
     @IsTechTask,  
     0,  
     0,  
     0,  
     @TaskLevel,  
     @MainTaskId  
    )    
    
  SET @Result=SCOPE_IDENTITY ()    
    
	--- Update task sequence
			IF(@Result > 0)
			BEGIN


			-- if sequence is already assigned to some other task, all sequence will push back by 1 from alloted sequence.
				IF EXISTS(SELECT TaskId FROM tblTask WHERE [Sequence] = @Sequence AND TaskId <> @Result)
				BEGIN

					UPDATE       tblTask
					SET                [Sequence] = [Sequence] + 1			
					WHERE        ([Sequence] >= @Sequence)

				END
		
					UPDATE tblTask
					SET                [Sequence] = @Sequence	
					WHERE        (TaskId = @Result)


		    END

  RETURN @Result    
 END    
 ELSE IF @Mode=1 -- Update    
 BEGIN      
  UPDATE tblTask    
  SET    
   Title=@Title,    
   Url = @Url,  
   [Description]=@Description,    
   [Status]=@Status,    
   DueDate=@DueDate,    
   [Hours]=@Hours,  
   [TaskType] = @TaskType,  
   [TaskPriority] = @TaskPriority,  
   [IsTechTask] = @IsTechTask  
  WHERE TaskId=@TaskId    
  
  SET @Result= @TaskId  
    
  RETURN @Result    
 END    
 ELSE IF @Mode=2 --Delete    
 BEGIN    
  UPDATE tblTask    
  SET    
   IsDeleted=1,  
   [Status] = @DeletedStatus  
  WHERE TaskId=@TaskId OR ParentTaskId=@TaskId    
 END    
    
END  

----------------------------------------------------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 05252017
-- Description:	This will load exams for user based on his designation
-- =============================================
-- usp_GetAptTestsByUserID 2934
CREATE PROCEDURE usp_GetAptTestsByUserID 
(
	@UserID bigint
)	  
AS
BEGIN
	
	DECLARE @DesignationID INT

	-- Get users designation based on its user id.
    SELECT        @DesignationID = DesignationID
	FROM            tblInstallUsers
	WHERE        (Id = @UserID)


	  IF(@DesignationID IS NOT NULL)
	  BEGIN

	     SELECT        MCQ_Exam.ExamID, MCQ_Exam.ExamDuration, MCQ_Exam.ExamTitle, ExamResult.MarksEarned, ExamResult.TotalMarks, ExamResult.[Aggregate], ExamResult.ExamPerformanceStatus
FROM            MCQ_Exam LEFT OUTER JOIN
                         MCQ_Performance AS ExamResult ON MCQ_Exam.ExamID = ExamResult.ExamID AND ExamResult.UserID = @UserID
WHERE        (@DesignationID IN
                             (SELECT        Item
                               FROM            dbo.SplitString(MCQ_Exam.DesignationID, ',') AS SplitString_1))

	  END



END
GO

-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 05252017  
-- Description: This will load exam questions randomly  
-- =============================================  
-- usp_GetQuestionsByExamID  20  
CREATE PROCEDURE usp_GetQuestionsByExamID   
(   
 @ExamId int   
)  
AS  
BEGIN  
  
DECLARE @Lower INT ---- The lowest random number  
DECLARE @Upper INT  
  
-- Generate random number and orderby questions according to it to load different sequence of exam everytime.  
SET @Lower = 1 ---- The lowest random number  
SET @Upper = 999 ---- The highest random number  
  
SELECT        MCQ_Question.QuestionID, MCQ_Question.Question, MCQ_Question.PositiveMarks, MCQ_Question.NegetiveMarks, MCQ_Question.ExamID, ABS(CAST(NEWID() AS binary(6)) % 1000) + 1 AS QuestionOrder, 
                         MCQ_Exam.ExamDuration
FROM            MCQ_Question INNER JOIN
                         MCQ_Exam ON MCQ_Question.ExamID = MCQ_Exam.ExamID
WHERE        (MCQ_Question.ExamID = @ExamId)
ORDER BY QuestionOrder  
  
END  
  
    
-- =============================================    
-- Author: Yogesh Keraliya    
-- Create date: 05262017    
-- Description: Update users exam performance.    
-- =============================================    
ALTER PROCEDURE [dbo].[SP_InsertPerfomace]     
 -- Add the parameters for the stored procedure here    
 @installUserID varchar(20),     
 @examID int = 0    
 ,@marksEarned int    
 ,@totalMarks int    
 ,@Aggregate real    
 ,@ExamPerformanceStatus int    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
  
 DECLARE @PassPercentage REAL  
   
 SELECT @PassPercentage = [PassPercentage] FROM MCQ_Exam WHERE [ExamID] = @examID  
  
  
 IF(@PassPercentage < @Aggregate)  
 BEGIN  
  
 SET @ExamPerformanceStatus = 1  
  
 END  
 ELSE  
  BEGIN  
   
  SET @ExamPerformanceStatus = 0  
  
  END  
 
 -- Get Total Marks Properly from Database
 
 SELECT @totalMarks = SUM([PositiveMarks]) FROM MCQ_Question WHERE ExamID = @examID
   
    -- Insert statements for procedure here    
 INSERT INTO [MCQ_Performance]    
           ([UserID]    
           ,[ExamID]    
           ,[MarksEarned]    
           ,[TotalMarks]    
           ,[Aggregate]    
     ,[ExamPerformanceStatus]               
     )    
     VALUES    
           (@installUserID    
           ,@examID    
           ,@marksEarned    
           ,@totalMarks    
           ,@Aggregate    
     ,@ExamPerformanceStatus    
           )    
END    


-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 05302017  
-- Description: This will load exam result for user based on his designation  
-- =============================================  
-- usp_isAllExamsGivenByUser 2934  
CREATE PROCEDURE usp_isAllExamsGivenByUser   
(  
 @UserID bigint , 
 @AggregateScored FLOAT= 0 OUTPUT,
 @AllExamsGiven BIT = 0 OUTPUT
)     
AS  
BEGIN  
   
	 DECLARE @DesignationID INT  
  
	 -- Get users designation based on its user id.  
	 SELECT        @DesignationID = DesignationID  
	 FROM            tblInstallUsers  
	 WHERE        (Id = @UserID)  
  
  
	   IF(@DesignationID IS NOT NULL)  
	   BEGIN  
  
			DECLARE @ExamCount INT
			DECLARE @GivenExamCount INT

			-- check exams available for existing designation
			SELECT      @ExamCount = COUNT(MCQ_Exam.ExamID)
		  FROM          MCQ_Exam 
		  WHERE        (@DesignationID IN 
						 (SELECT   Item   FROM  dbo.SplitString(MCQ_Exam.DesignationID, ',') AS SplitString_1))  

				-- check exams given by user
				SELECT @GivenExamCount = COUNT(ExamID) FROM MCQ_Performance WHERE UserID = @UserID

				-- IF all exam given, calcualte result.	  
				IF( @ExamCount = @GivenExamCount AND @GivenExamCount > 0)
				BEGIN

				 SELECT @AggregateScored = (SUM([Aggregate])/@GivenExamCount) FROM MCQ_Performance  WHERE UserID = @UserID

				 SET @AllExamsGiven = 1

				END
				ELSE
				BEGIN
					SET @AllExamsGiven = 0
				END


	END  
  
  RETURN @AggregateScored
  
END  
 
 

-- =============================================    
  
-- Author:  Yogesh    
  
-- Create date: 22 Sep 2016    
  
-- Description: Updates status and status related fields for install user.    
  
--    Inserts event and event users for interview status.    
  
--    Deletes any exising events and event users for non interview status.    
  
--    Gets install users details.    
  
-- =============================================    
  
CREATE PROCEDURE [dbo].[USP_ChangeUserStatusToReject]
(    
  
 @UserID BIGINT ,

 @StatusId int = 0,    
  
 @RejectionDate DATE = NULL,    
  
 @RejectionTime VARCHAR(20) = NULL,    
  
 @RejectedUserId int = 0,    
  
 @StatusReason varchar(max) = ''
  
)    
  
AS    
  
BEGIN  
  
		-- SET NOCOUNT ON added to prevent extra result sets from    
  
		-- interfering with SELECT statements.    
  
		SET NOCOUNT ON;  
  
  
		-- Updates user status and status related information.    
  
		UPDATE [dbo].[tblInstallUsers]  
  
		SET [Status] = @StatusId  
  
		 ,RejectionDate = @RejectionDate  
  
		 ,RejectionTime = @RejectionTime  
  
		 ,InterviewTime = @RejectionTime  
  
		 ,RejectedUserId = @RejectedUserId  
  
		 ,StatusReason = @StatusReason  
  
		WHERE Id = @UserID
  

END  
 
-- =============================================  
-- Author:  Jaylem  
-- Create date: 13-Dec-2016  
-- Description: Returns all/selected Active Designation   
  
-- Updated : Added DesignationCode.  
--  date: 22 Mar 2017  
--  by : Yogesh  
-- =============================================  
-- [dbo].[UDP_GetAllDesignationByTaskID] 418
CREATE PROCEDURE [dbo].[UDP_GetAllDesignationByTaskID]  
 (
 @TaskID As Int  
 )
AS  
BEGIN  

 SET NOCOUNT ON;   
   
SELECT        TD.DesignationID, D.DesignationName, TD.TaskId
FROM            tblTaskDesignations AS TD LEFT OUTER JOIN
                         tbl_Designation AS D ON TD.DesignationID = D.ID
WHERE        (TD.TaskId = @TaskID)

END


-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 05222017  
-- Description: This will load all tasks with title and sequence  
-- =============================================  
-- usp_GetAllTaskWithSequence 0,20
ALTER PROCEDURE usp_GetAllTaskWithSequence   
(  
 
 @PageIndex INT = 0,   
 @PageSize INT =20   
   
)  
As  
BEGIN  
  
DECLARE @StartIndex INT  = 0  
SET @StartIndex = (@PageIndex * @PageSize) + 1  
  
  
;WITH   
 Tasklist AS  
 (   
  select DISTINCT TaskId ,[Status],[Sequence], 
  Title,ParentTaskId,Assigneduser,ParentTaskTitle,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  TaskDesignation,
  case   
   when (ParentTaskId is null and  TaskLevel=1) then InstallId   
   when (tasklevel =1 and ParentTaskId>0) then   
    (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId    
   when (tasklevel =2 and ParentTaskId>0) then  
    (select InstallId from tbltask where taskid in (  
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))  
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId   
       
   when (tasklevel =3 and ParentTaskId>0) then  
   (select InstallId from tbltask where taskid in (  
   (select parenttaskid from tbltask where taskid in (  
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))  
   +'-'+  
    (select InstallId from tbltask where taskid in (  
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))  
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId   
  end as 'InstallId' ,Row_number() OVER (order by x.TaskId ) AS RowNo_Order  
  from (  
   select DISTINCT a.*  
   ,(select Title from tbltask where TaskId=(select * from [GetParent](a.TaskId))) AS ParentTaskTitle  
   ,t.FristName + ' ' + t.LastName AS Assigneduser,
   (
   STUFF((SELECT ', ' + Designation
           FROM tblTaskdesignations td 
           WHERE td.TaskID = a.TaskId 
          FOR XML PATH('')), 1, 2, '')
  )  AS TaskDesignation
   from  tbltask a  
   LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId   
   LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId  
   LEFT OUTER JOIN tblInstallUsers as t ON c.UserId = t.Id    
   where a.[Sequence] IS NOT NULL
  
   --and (CreatedOn >=@startdate and CreatedOn <= @enddate )   
  ) as x  
 )  
  
 ---- get CTE data into temp table  
 SELECT *  
 INTO #temp  
 FROM Tasklist  
   
 SELECT *   
 FROM #temp   
 WHERE   
 RowNo_Order >= @StartIndex AND   
 (  
  @PageSize = 0 OR   
  RowNo_Order < (@StartIndex + @PageSize)  
 )  
 ORDER BY [Sequence]  DESC
  
  
 SELECT  
 COUNT(*) AS TotalRecords  
  FROM #temp  

END

/*
   Monday, June 5, 20171:02:30 PM
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
	SequenceDesignationId int NULL,
	UpdatedBy int NULL,
	UpdatedOn datetime NULL
GO
ALTER TABLE dbo.tblTask ADD CONSTRAINT
	DF_tblTask_UpdatedOn DEFAULT getdate() FOR UpdatedOn
GO
ALTER TABLE dbo.tblTask SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'CONTROL') as Contr_Per 
  

USE JGBS_Dev_New
GO


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_UpdateTaskSequence]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_UpdateTaskSequence   

	END
		
GO
-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 05162017  
-- Description: This will update task sequence  
-- =============================================  
CREATE PROCEDURE usp_UpdateTaskSequence   
(   
 @Sequence bigint ,
 @DesignationID int,   
 @TaskId bigint,
 @IsTechTask bit   
)  
AS  
BEGIN  
  

-- if sequence is already assigned to some other task with same designation, all sequence will push back by 1 from alloted sequence for that designation.  
IF EXISTS(SELECT   T.TaskId
FROM            tblTask AS T 
WHERE        (T.[Sequence] = @Sequence) AND (T.TaskId <> @TaskId) AND (T.[SequenceDesignationId] = @DesignationID) AND T.IsTechTask = @IsTechTask)  
  BEGIN  
  
		-- push back all task sequence for 1 from sequence assigned in between.
		   UPDATE       tblTask  
		   SET                [Sequence] = [Sequence] + 1     
		   WHERE        ([Sequence] >= @Sequence) AND ([SequenceDesignationId] = @DesignationID) AND IsTechTask = @IsTechTask
  
  END  
  
  -- Update task sequence and its respective designationid.
  UPDATE tblTask  
   SET                [Sequence] = @Sequence , [SequenceDesignationId] = @DesignationID
   WHERE        (TaskId = @TaskId) 


END  
GO

USE JGBS_Dev_New
GO

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetAllTaskWithSequence]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_GetAllTaskWithSequence   

	END
		
GO

-- =============================================      
-- Author:  Yogesh Keraliya      
-- Create date: 05222017      
-- Description: This will load all tasks with title and sequence      
-- =============================================      
-- usp_GetAllTaskWithSequence 0,20,NULL,0,516
CREATE PROCEDURE usp_GetAllTaskWithSequence       
(      
     
 @PageIndex INT = 0,       
 @PageSize INT =20,
 @DesignationIds VARCHAR(20) = NULL,
 @IsTechTask BIT = 0,
 @HighLightedTaskID BIGINT = NULL
        
)      
As      
BEGIN      


IF( @DesignationIds = '' )
BEGIN

 SET @DesignationIds = NULL

END
            
      
;WITH       
 Tasklist AS      
 (       
  select DISTINCT TaskId ,[Status],[SequenceDesignationId],[Sequence],     
  Title,ParentTaskId,Assigneduser,IsTechTask,ParentTaskTitle,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  TaskDesignation,    
  case       
   when (ParentTaskId is null and  TaskLevel=1) then InstallId       
   when (tasklevel =1 and ParentTaskId>0) then       
    (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId        
   when (tasklevel =2 and ParentTaskId>0) then      
    (select InstallId from tbltask where taskid in (      
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))      
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId       
           
   when (tasklevel =3 and ParentTaskId>0) then      
   (select InstallId from tbltask where taskid in (      
   (select parenttaskid from tbltask where taskid in (      
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))      
   +'-'+      
    (select InstallId from tbltask where taskid in (      
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))      
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId       
  end as 'InstallId' ,Row_number() OVER (order by x.TaskId ) AS RowNo_Order      
  from (      
   select DISTINCT a.*      
   ,(select Title from tbltask where TaskId=(select * from [GetParent](a.TaskId))) AS ParentTaskTitle      
   ,t.FristName + ' ' + t.LastName AS Assigneduser,    
   (    
   STUFF((SELECT ', ' + Designation    
           FROM tblTaskdesignations td     
           WHERE td.TaskID = a.TaskId     
          FOR XML PATH('')), 1, 2, '')    
  )  AS TaskDesignation    
   from  tbltask a      
   LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId       
   LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId      
   LEFT OUTER JOIN tblInstallUsers as t ON c.UserId = t.Id        
   WHERE 
  ( 
	   (a.[Sequence] IS NOT NULL) 
	   AND (a.[SequenceDesignationId] IN (SELECT * FROM [dbo].[SplitString](ISNULL(@DesignationIds,a.[SequenceDesignationId]),',') ) ) 
	   AND (ISNULL(a.[IsTechTask],@IsTechTask) = @IsTechTask)
   
   ) 
   OR
   (
     a.TaskId = @HighLightedTaskID
   )     
   --and (CreatedOn >=@startdate and CreatedOn <= @enddate )       
  ) as x      
 )      
      
 ---- get CTE data into temp table      
 SELECT *      
 INTO #Tasks      
 FROM Tasklist      

-- find page number to show taskid sent.
DECLARE @StartIndex INT  = 0      

      
IF @HighLightedTaskID  > 0
	BEGIN
		DECLARE @RowNumber BIGINT = NULL

		-- Find in which rownumber highlighter taskid is.
		SELECT @RowNumber = RowNo_Order 
		FROM #Tasks 
		WHERE TaskId = @HighLightedTaskID

		-- if row number found then divide it with page size and round it to nearest integer , so will found pagenumber to be selected.
		-- for ex. if total 60 records are there,pagesize is 20 and highlighted task id is at 42 row number than. 
		-- 42/20 = 2.1 ~ 3 - 1 = 2 = @Page Index
		-- StartIndex = (2*20)+1 = 41, so records 41 to 60 will be fetched.
		 
		IF @RowNumber IS NOT NULL
		BEGIN
			SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1
		END
	END		

	-- Set start index to fetch record.
	SET @StartIndex = (@PageIndex * @PageSize) + 1      
 
 -- fetch records from temptable
 SELECT *       
 FROM #Tasks       
 WHERE       
 RowNo_Order >= @StartIndex AND       
 (      
  @PageSize = 0 OR       
  RowNo_Order < (@StartIndex + @PageSize)      
 )      
 ORDER BY [Sequence]  DESC    
      
 -- fetch other statistics, total records, total pages, pageindex to highlighted.     
 SELECT      
 COUNT(*) AS TotalRecords, CAST((COUNT(*)/@PageSize) AS INT) AS TotalPages, @PageIndex AS PageIndex     
  FROM #Tasks      

 DROP TABLE #Tasks

    
END  
GO
      
USE JGBS_Dev_New
GO


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetLastAvailableSequence]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_GetLastAvailableSequence   

	END
		
GO

-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 05152017  
-- Description: This will load last available sequence for task  
-- =============================================  
CREATE PROCEDURE usp_GetLastAvailableSequence   
(
	@DesignationID INT,
	@IsTechTask BIT
)  
AS  
BEGIN  
  
-- Got MAX allocated sequence to same designation and techtask or non techtask tasks.
SELECT  ISNULL(MAX([Sequence])+1,1) [Sequence] FROM tblTask WHERE [SequenceDesignationId] = @DesignationID AND IsTechTask = @IsTechTask    

  
END        