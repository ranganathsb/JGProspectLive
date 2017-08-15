/*
   Wednesday, August 9, 20179:05:07 PM
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
ALTER TABLE dbo.tblTask
	DROP CONSTRAINT DF__tblTask__IsUiReq__5319221E
GO
ALTER TABLE dbo.tblTask
	DROP CONSTRAINT DF__tblTask__TaskLev__4C364F0E
GO
ALTER TABLE dbo.tblTask
	DROP CONSTRAINT DF_tblTask_UpdatedOn
GO
CREATE TABLE dbo.Tmp_tblTask_1
	(
	TaskId bigint NOT NULL IDENTITY (1, 1),
	Title varchar(250) NOT NULL,
	Description varchar(MAX) NOT NULL,
	Status tinyint NOT NULL,
	DueDate datetime NULL,
	Hours varchar(25) NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	IsDeleted bit NOT NULL,
	InstallId varchar(50) NULL,
	ParentTaskId bigint NULL,
	TaskType tinyint NULL,
	TaskPriority tinyint NULL,
	IsTechTask bit NULL,
	AdminStatus bit NULL,
	TechLeadStatus bit NULL,
	OtherUserStatus bit NULL,
	AdminStatusUpdated datetime NULL,
	TechLeadStatusUpdated datetime NULL,
	OtherUserStatusUpdated datetime NULL,
	AdminUserId int NULL,
	TechLeadUserId int NULL,
	OtherUserId int NULL,
	IsAdminInstallUser bit NULL,
	IsTechLeadInstallUser bit NULL,
	IsOtherUserInstallUser bit NULL,
	Url varchar(250) NULL,
	IsUiRequested bit NULL,
	TaskLevel int NULL,
	MainParentId int NULL,
	Sequence bigint NULL,
	SubSequence varchar(5) NULL,
	SequenceDesignationId int NULL,
	UpdatedBy int NULL,
	UpdatedOn datetime NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblTask_1 SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_tblTask_1 ADD CONSTRAINT
	DF__tblTask__IsUiReq__5319221E DEFAULT ((0)) FOR IsUiRequested
GO
ALTER TABLE dbo.Tmp_tblTask_1 ADD CONSTRAINT
	DF__tblTask__TaskLev__4C364F0E DEFAULT ((1)) FOR TaskLevel
GO
ALTER TABLE dbo.Tmp_tblTask_1 ADD CONSTRAINT
	DF_tblTask_UpdatedOn DEFAULT (getdate()) FOR UpdatedOn
GO
SET IDENTITY_INSERT dbo.Tmp_tblTask_1 ON
GO
IF EXISTS(SELECT * FROM dbo.tblTask)
	 EXEC('INSERT INTO dbo.Tmp_tblTask_1 (TaskId, Title, Description, Status, DueDate, Hours, CreatedBy, CreatedOn, IsDeleted, InstallId, ParentTaskId, TaskType, TaskPriority, IsTechTask, AdminStatus, TechLeadStatus, OtherUserStatus, AdminStatusUpdated, TechLeadStatusUpdated, OtherUserStatusUpdated, AdminUserId, TechLeadUserId, OtherUserId, IsAdminInstallUser, IsTechLeadInstallUser, IsOtherUserInstallUser, Url, IsUiRequested, TaskLevel, MainParentId, Sequence, SequenceDesignationId, UpdatedBy, UpdatedOn)
		SELECT TaskId, Title, Description, Status, DueDate, Hours, CreatedBy, CreatedOn, IsDeleted, InstallId, ParentTaskId, TaskType, TaskPriority, IsTechTask, AdminStatus, TechLeadStatus, OtherUserStatus, AdminStatusUpdated, TechLeadStatusUpdated, OtherUserStatusUpdated, AdminUserId, TechLeadUserId, OtherUserId, IsAdminInstallUser, IsTechLeadInstallUser, IsOtherUserInstallUser, Url, IsUiRequested, TaskLevel, MainParentId, Sequence, SequenceDesignationId, UpdatedBy, UpdatedOn FROM dbo.tblTask WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblTask_1 OFF
GO
ALTER TABLE dbo.tblTaskComments
	DROP CONSTRAINT FK__tblTaskCo__TaskI__168449D3
GO
ALTER TABLE dbo.tblAssignedSequencingTemp
	DROP CONSTRAINT FK_tblAssignedSequencingTemp_tblTask
GO
ALTER TABLE dbo.tblTaskAcceptance
	DROP CONSTRAINT FK__tblTaskAc__TaskI__46E85563
GO
ALTER TABLE dbo.tblAssignedSequencing
	DROP CONSTRAINT FK_tblAssignedSequencing_tblTask
GO
ALTER TABLE dbo.tblTaskAcceptance
	DROP CONSTRAINT FK__tblTaskAc__TaskI__61A66D40
GO
ALTER TABLE dbo.tblTaskApprovals
	DROP CONSTRAINT FK__tblTaskAp__TaskI__1427CB6C
GO
ALTER TABLE dbo.tblTaskApprovals
	DROP CONSTRAINT FK__tblTaskAp__TaskI__31C24FF4
GO
ALTER TABLE dbo.tblTaskAssignedUsers
	DROP CONSTRAINT FK_tblTaskAssignedUsers_tblTask
GO
ALTER TABLE dbo.tblTaskAssignmentRequests
	DROP CONSTRAINT FK_tblTaskAssignmentRequests_tblTask
GO
ALTER TABLE dbo.tblTaskDesignations
	DROP CONSTRAINT FK_tblTaskDesignations_tblTask
GO
ALTER TABLE dbo.tblTaskWorkSpecifications
	DROP CONSTRAINT FK__tblTaskWo__TaskI__1BFDF75E
GO
ALTER TABLE dbo.tblTaskWorkSpecifications
	DROP CONSTRAINT FK__tblTaskWo__TaskI__4CAB505A
GO
DROP TABLE dbo.tblTask
GO
EXECUTE sp_rename N'dbo.Tmp_tblTask_1', N'tblTask', 'OBJECT' 
GO
ALTER TABLE dbo.tblTask ADD CONSTRAINT
	PK_tblTask PRIMARY KEY CLUSTERED 
	(
	TaskId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblTaskWorkSpecifications ADD CONSTRAINT
	FK__tblTaskWo__TaskI__1BFDF75E FOREIGN KEY
	(
	TaskId
	) REFERENCES dbo.tblTask
	(
	TaskId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblTaskWorkSpecifications ADD CONSTRAINT
	FK__tblTaskWo__TaskI__4CAB505A FOREIGN KEY
	(
	TaskId
	) REFERENCES dbo.tblTask
	(
	TaskId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblTaskWorkSpecifications SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblTaskWorkSpecifications', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblTaskWorkSpecifications', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblTaskWorkSpecifications', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblTaskDesignations ADD CONSTRAINT
	FK_tblTaskDesignations_tblTask FOREIGN KEY
	(
	TaskId
	) REFERENCES dbo.tblTask
	(
	TaskId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblTaskDesignations SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblTaskDesignations', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblTaskDesignations', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblTaskDesignations', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblTaskAssignmentRequests ADD CONSTRAINT
	FK_tblTaskAssignmentRequests_tblTask FOREIGN KEY
	(
	TaskId
	) REFERENCES dbo.tblTask
	(
	TaskId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblTaskAssignmentRequests SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblTaskAssignmentRequests', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblTaskAssignmentRequests', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblTaskAssignmentRequests', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblTaskAssignedUsers ADD CONSTRAINT
	FK_tblTaskAssignedUsers_tblTask FOREIGN KEY
	(
	TaskId
	) REFERENCES dbo.tblTask
	(
	TaskId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblTaskAssignedUsers SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblTaskAssignedUsers', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblTaskAssignedUsers', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblTaskAssignedUsers', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblTaskApprovals ADD CONSTRAINT
	FK__tblTaskAp__TaskI__1427CB6C FOREIGN KEY
	(
	TaskId
	) REFERENCES dbo.tblTask
	(
	TaskId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblTaskApprovals ADD CONSTRAINT
	FK__tblTaskAp__TaskI__31C24FF4 FOREIGN KEY
	(
	TaskId
	) REFERENCES dbo.tblTask
	(
	TaskId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblTaskApprovals SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblTaskApprovals', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblTaskApprovals', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblTaskApprovals', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblAssignedSequencing ADD CONSTRAINT
	FK_tblAssignedSequencing_tblTask FOREIGN KEY
	(
	TaskId
	) REFERENCES dbo.tblTask
	(
	TaskId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblAssignedSequencing SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblAssignedSequencing', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblAssignedSequencing', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblAssignedSequencing', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblTaskAcceptance ADD CONSTRAINT
	FK__tblTaskAc__TaskI__46E85563 FOREIGN KEY
	(
	TaskId
	) REFERENCES dbo.tblTask
	(
	TaskId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblTaskAcceptance ADD CONSTRAINT
	FK__tblTaskAc__TaskI__61A66D40 FOREIGN KEY
	(
	TaskId
	) REFERENCES dbo.tblTask
	(
	TaskId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblTaskAcceptance SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblTaskAcceptance', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblTaskAcceptance', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblTaskAcceptance', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblAssignedSequencingTemp ADD CONSTRAINT
	FK_tblAssignedSequencingTemp_tblTask FOREIGN KEY
	(
	TaskId
	) REFERENCES dbo.tblTask
	(
	TaskId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblAssignedSequencingTemp SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblAssignedSequencingTemp', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblAssignedSequencingTemp', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblAssignedSequencingTemp', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblTaskComments ADD CONSTRAINT
	FK__tblTaskCo__TaskI__168449D3 FOREIGN KEY
	(
	TaskId
	) REFERENCES dbo.tblTask
	(
	TaskId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblTaskComments SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblTaskComments', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblTaskComments', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblTaskComments', 'Object', 'CONTROL') as Contr_Per 

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
-- =============================================                      
-- Author:  Yogesh Keraliya                      
-- Create date: 05222017                      
-- Description: This will load all tasks with title and sequence                      
-- =============================================                      
-- usp_GetAllTaskWithSequence 0,20,'',10,575                

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetAllTaskWithSequence]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_GetAllTaskWithSequence   

	END  
GO    

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
  SELECT DISTINCT TaskId ,[Status],[SequenceDesignationId],[Sequence], [SubSequence],                    
  Title,ParentTaskId,IsTechTask,ParentTaskTitle,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  TaskDesignation,      
  [AdminStatus] , [TechLeadStatus], [OtherUserStatus],[AdminStatusUpdated],[TechLeadStatusUpdated],[OtherUserStatusUpdated],[AdminUserId],[TechLeadUserId],[OtherUserId],       
  AdminUserInstallId, AdminUserFirstName, AdminUserLastName,      
  TechLeadUserInstallId,ITLeadHours,UserHours, TechLeadUserFirstName, TechLeadUserLastName,      
  OtherUserInstallId, OtherUserFirstName,OtherUserLastName,TaskAssignedUserIDs,      
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
   ,(select Title from tbltask where TaskId=(select * from [GetParent](a.TaskId))) AS ParentTaskTitle,      
   (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.TechLeadUserId) AS ITLeadHours , (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.OtherUserId) AS UserHours,      
   ta.InstallId AS AdminUserInstallId, ta.FristName AS AdminUserFirstName, ta.LastName AS AdminUserLastName,      
   tT.InstallId AS TechLeadUserInstallId, tT.FristName AS TechLeadUserFirstName, tT.LastName AS TechLeadUserLastName,      
   tU.InstallId AS OtherUserInstallId, tU.FristName AS OtherUserFirstName, tU.LastName AS OtherUserLastName,      
   --,t.FristName + ' ' + t.LastName AS Assigneduser,                    
   (                    
   STUFF((SELECT ', {"Name": "' + Designation +'","Id":'+ CONVERT(VARCHAR(5),DesignationID)+'}'                  
           FROM tblTaskdesignations td                     
           WHERE td.TaskID = a.TaskId                     
          FOR XML PATH('')), 1, 2, '')                    
  )  AS TaskDesignation,  
  (  
    STUFF((SELECT ', {"Id" : "'+ CONVERT(VARCHAR(5),UserId) + '"}'                  
           FROM tbltaskassignedusers as tau  
           WHERE tau.TaskId = a.TaskId                     
          FOR XML PATH('')), 1, 2, '')                    
  ) AS TaskAssignedUserIDs           
  --(SELECT TOP 1 DesignationID                   
  --         FROM tblTaskdesignations td                     
  --         WHERE td.TaskID = a.TaskId ) AS DesignationId                   
   from  tbltask a                      
   --LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId                       
   --LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId                      
   LEFT OUTER JOIN tblInstallUsers as ta ON a.[AdminUserId] = ta.Id       
   LEFT OUTER JOIN tblInstallUsers as tT ON a.[TechLeadUserId] = tT.Id       
   LEFT OUTER JOIN tblInstallUsers as tU ON a.[OtherUserId] = tU.Id   
  -- LEFT OUTER JOIN tbltaskassignedusers as tau ON a.TaskId = tau.TaskId                      
   WHERE                 
  (                 
    (a.[Sequence] IS NOT NULL)                 
    AND (a.[SequenceDesignationId] IN (SELECT * FROM [dbo].[SplitString](ISNULL(@DesignationIds,a.[SequenceDesignationId]),',') ) )                 
    AND (ISNULL(a.[IsTechTask],@IsTechTask) = @IsTechTask)                
                   
   )                 
   OR                
   (                
     a.TaskId = @HighLightedTaskID  AND IsTechTask = @IsTechTask              
   )                     
   --and (CreatedOn >=@startdate and CreatedOn <= @enddate )                       
  ) as x                      
 )            
                      
 ---- get CTE data into temp table                      
 SELECT *                      
 INTO #Tasks                      
 FROM Tasklist                      
                
---- find page number to show taskid sent.                
DECLARE @StartIndex INT  = 0                      
                
                      
--IF @HighLightedTaskID  > 0                
-- BEGIN                
--  DECLARE @RowNumber BIGINT = NULL                
                
--  -- Find in which rownumber highlighter taskid is.                
--  SELECT @RowNumber = RowNo_Order                 
--  FROM #Tasks                 
--  WHERE TaskId = @HighLightedTaskID                
                
--  -- if row number found then divide it with page size and round it to nearest integer , so will found pagenumber to be selected.                
--  -- for ex. if total 60 records are there,pagesize is 20 and highlighted task id is at 42 row number than.                 
--  -- 42/20 = 2.1 ~ 3 - 1 = 2 = @Page Index                
--  -- StartIndex = (2*20)+1 = 41, so records 41 to 60 will be fetched.                
                   
--  IF @RowNumber IS NOT NULL                
--  BEGIN                
--   SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1                
--  END                
-- END                  
                
 -- Set start index to fetch record.                
 SET @StartIndex = (@PageIndex * @PageSize) + 1                      
                 
 -- fetch parent sequence records from temptable                
 SELECT *                       
 FROM #Tasks                       
 WHERE                       
 (RowNo_Order >= @StartIndex AND                       
 (                      
  @PageSize = 0 OR                       
  RowNo_Order < (@StartIndex + @PageSize)                      
 ))    
 AND             
 SubSequence IS NULL    
 --ORDER BY  [Sequence]  DESC                    
 ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC                    
    
 -- fetch sub sequence records from temptable                
 SELECT *                       
 FROM #Tasks                       
 WHERE                       
 (RowNo_Order >= @StartIndex AND                       
 (                      
  @PageSize = 0 OR                       
  RowNo_Order < (@StartIndex + @PageSize)                      
 ))    
 AND             
 SubSequence IS NOT NULL    
 --ORDER BY  [Sequence]  DESC                    
 ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC                    
    
    
 --or            
 --(            
 -- TaskId = @HighLightedTaskID        
 --)                      
 --ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC                    
                      
 -- fetch other statistics, total records, total pages, pageindex to highlighted.                     
 SELECT                      
 COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex                     
  FROM #Tasks  WHERE SubSequence IS NULL               
                
 DROP TABLE #Tasks                
                
                    
END 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/****** Object:  View [dbo].[TaskListView]    Script Date: 8/13/2017 6:17:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[TaskListView] 
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
		(SELECT  CAST(', ' + CONVERT(VARCHAR(5), td.DesignationID) as VARCHAR)
		FROM tblTaskDesignations td
		WHERE td.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskDesignationIds,
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

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[sp_GetHrData]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [sp_GetHrData]   

	END  
GO    

 
-- [sp_GetHrData] NULL,'0',0,0, 0, NULL, NULL,0,20, 'CreatedDateTime DESC','5','9','6','1'  
CREATE PROCEDURE [dbo].[sp_GetHrData]  
 @SearchTerm VARCHAR(15) = NULL, @Status VARCHAR(50), @DesignationId INT, @SourceId INT, @AddedByUserId INT, @FromDate DATE = NULL,  
 @ToDate DATE = NULL, @PageIndex INT = NULL,  @PageSize INT = NULL, @SortExpression VARCHAR(50), @InterviewDateStatus VARChAR(5) = '5',  
 @RejectedStatus VARChAR(5) = '9', @OfferMadeStatus VARChAR(5) = '6', @ActiveStatus VARChAR(5) = '1'   
AS  
BEGIN   
SET NOCOUNT ON;  
  
 IF @Status = '0'  
 BEGIN  
  SET @Status = NULL  
 END  
 IF @DesignationId = '0'  
 BEGIN  
  SET @DesignationId = NULL  
 END  
 IF @SourceId = '0'  
 BEGIN  
  SET @SourceId = NULL  
 END  
 IF @AddedByUserId = 0  
 BEGIN  
  SET @AddedByUserId = NULL  
 END  
   
 SET @PageIndex = isnull(@PageIndex,0)  
 SET @PageSize = isnull(@PageSize,0)  
   
 DECLARE @StartIndex INT  = 0  
 SET @StartIndex = (@PageIndex * @PageSize) + 1  
    
  -- get statistics (Status) - Table 0   
  SELECT t.Status, COUNT(*) [Count]  
  FROM tblInstallUsers t   
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser  
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id  
   WHERE   
  (t.UserType = 'SalesUser' OR t.UserType = 'sales')  
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)   
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)  
 GROUP BY t.status  
  
 -- get statistics (AddedBy) - Table 1  
 SELECT ISNULL(U.Username, t2.FristName + '' + t2.LastName)  AS AddedBy, COUNT(*) [Count]   
 FROM tblInstallUsers t  
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser  
   LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser  
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id  
   LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id  
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales')  
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)  
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)  
 GROUP BY U.Username,t2.FristName,t2.LastName  
  
 -- get statistics (Designation) - Table 2  
 SELECT t.Designation, COUNT(*) [Count]   
 FROM tblInstallUsers t  
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser  
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id  
   LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id  
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales')  
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)  
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)  
 GROUP BY t.Designation  
  
 -- get statistics (Source) - Table 3  
 SELECT t.Source, COUNT(*) [Count]  
 FROM tblInstallUsers t  
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser  
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id  
   LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id  
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales')  
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)  
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)  
 GROUP BY t.Source  
  
 -- get records - Table 4  
 ;WITH SalesUsers  
 AS  
 (SELECT t.Id, t.FristName, t.LastName, t.Phone, t.Zip, t.City, d.DesignationName AS Designation, t.Status, t.HireDate, t.InstallId,  
 t.picture, t.CreatedDateTime, Isnull(s.Source,'') AS Source, t.SourceUser, ISNULL(U.Username,t2.FristName + ' ' + t2.LastName)  
 AS AddedBy, ISNULL (t.UserInstallId,t.id) As UserInstallId,  
 InterviewDetail = case when (t.Status=@InterviewDateStatus) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR)  + ' ' + coalesce(t.InterviewTime,'')   
       else '' end,  
 RejectDetail = case when (t.[Status]=@RejectedStatus ) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR) + ' ' + coalesce(t.RejectionTime,'')   
       else '' end,  
 CASE when (t.[Status]= @RejectedStatus ) THEN t.RejectedUserId ELSE NULL END AS RejectedUserId,  
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.FristName + ' ' + ru.LastName ELSE NULL END AS RejectedByUserName,  
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.[UserInstallId]  ELSE NULL END AS RejectedByUserInstallId,  
 t.Email, t.DesignationID, ISNULL(t1.[UserInstallId], t2.[UserInstallId]) As AddedByUserInstallId,  
 ISNULL(t1.Id,t2.Id) As AddedById, t.emptype as 'EmpType', t.Phone As PrimaryPhone, t.CountryCode, t.Resumepath,  
 --ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId,  
 Task.TaskId AS 'TechTaskId', Task.ParentTaskId AS 'ParentTechTaskId', Task.InstallId as 'TechTaskInstallId', bm.bookmarkedUser,  
 t.[StatusReason], dbo.udf_GetUserExamPercentile(t.Id) AS [Aggregate],  
 ROW_NUMBER() OVER(ORDER BY  
   CASE WHEN @SortExpression = 'Id ASC' THEN t.Id END ASC,  
   CASE WHEN @SortExpression = 'Id DESC' THEN t.Id END DESC,  
   CASE WHEN @SortExpression = 'Status ASC' THEN t.Status END ASC,  
   CASE WHEN @SortExpression = 'Status DESC' THEN t.Status END DESC,  
   CASE WHEN @SortExpression = 'FristName ASC' THEN t.FristName END ASC,  
   CASE WHEN @SortExpression = 'FristName DESC' THEN t.FristName END DESC,  
   CASE WHEN @SortExpression = 'Designation ASC' THEN d.DesignationName END ASC,  
   CASE WHEN @SortExpression = 'Designation DESC' THEN d.DesignationName END DESC,  
   CASE WHEN @SortExpression = 'Source ASC' THEN s.Source END ASC,  
   CASE WHEN @SortExpression = 'Source DESC' THEN s.Source END DESC,  
   CASE WHEN @SortExpression = 'Phone ASC' THEN t.Phone END ASC,  
   CASE WHEN @SortExpression = 'Phone DESC' THEN t.Phone END DESC,  
   CASE WHEN @SortExpression = 'Zip ASC' THEN t.Phone END ASC,  
   CASE WHEN @SortExpression = 'Zip DESC' THEN t.Phone END DESC,   
   CASE WHEN @SortExpression = 'City ASC' THEN t.City END ASC,  
   CASE WHEN @SortExpression = 'City DESC' THEN t.City END DESC,   
   CASE WHEN @SortExpression = 'CreatedDateTime ASC' THEN t.CreatedDateTime END ASC,  
   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN t.CreatedDateTime END DESC   
       ) AS RowNumber,  
    '' as Country  
  FROM tblInstallUsers t  
  LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser  
  LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser  
  LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId= ru.Id  
  LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id  
  LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id  
  LEFT JOIN tblSource s ON t.SourceId = s.Id  
  left outer join InstallUserBMLog as bm on t.id  =bm.bookmarkedUser and bm.isDeleted=0  
  OUTER APPLY  
 (   
 SELECT tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo  
 FROM tblTaskAssignedUsers u  
 INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND  
 (tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1)  
 WHERE u.UserId = t.Id  
 ) AS Task  
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') AND (@SearchTerm IS NULL OR   
    1 = CASE WHEN t.InstallId LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.FristName LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.LastName LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.Email LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.Phone LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.Zip LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.City LIKE '%'+ @SearchTerm + '%' THEN 1  
  ELSE 0  
  END  
  )  
 AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))  
 AND t.Status NOT IN (@OfferMadeStatus, @ActiveStatus)  
 AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))  
 AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))  
 --AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))  
 AND ISNULL(t1.Id,t2.Id)=ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id))  
 AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)  
 AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)  
)  
SELECT  Id, FristName, LastName, Phone, Zip, Designation, Status, HireDate, InstallId, picture, CreatedDateTime, Source, SourceUser,  
AddedBy, UserInstallId, InterviewDetail, RejectDetail, RejectedUserId, RejectedByUserName, RejectedByUserInstallId, Email, DesignationID,  
AddedByUserInstallId, AddedById, EmpType, [Aggregate], PrimaryPhone, CountryCode, Resumepath, TechTaskId, ParentTechTaskId,  
TechTaskInstallId, bookmarkedUser,  [StatusReason], Country, City  
FROM SalesUsers  
WHERE RowNumber >= @StartIndex AND (@PageSize = 0 OR RowNumber < (@StartIndex + @PageSize))  
group by Id, FristName, LastName, Phone, Zip, Designation, Status, HireDate, InstallId, picture, CreatedDateTime, Source, SourceUser,  
AddedBy, UserInstallId, InterviewDetail, RejectDetail, RejectedUserId, RejectedByUserName, RejectedByUserInstallId, Email, DesignationID,  
AddedByUserInstallId, AddedById, EmpType, [Aggregate], PrimaryPhone, CountryCode, Resumepath, TechTaskId, ParentTechTaskId,  
TechTaskInstallId, bookmarkedUser,  [StatusReason], Country, City  
ORDER BY CASE WHEN @SortExpression = 'Id ASC' THEN Id END ASC,  
   CASE WHEN @SortExpression = 'Id DESC' THEN Id END DESC,  
   CASE WHEN @SortExpression = 'Status ASC' THEN Status END ASC,  
   CASE WHEN @SortExpression = 'Status DESC' THEN Status END DESC,  
   CASE WHEN @SortExpression = 'FristName ASC' THEN FristName END ASC,  
   CASE WHEN @SortExpression = 'FristName DESC' THEN FristName END DESC,  
   CASE WHEN @SortExpression = 'Designation ASC' THEN Designation END ASC,  
   CASE WHEN @SortExpression = 'Designation DESC' THEN Designation END DESC,  
   CASE WHEN @SortExpression = 'Source ASC' THEN Source END ASC,  
   CASE WHEN @SortExpression = 'Source DESC' THEN Source END DESC,  
   CASE WHEN @SortExpression = 'Phone ASC' THEN Phone END ASC,  
   CASE WHEN @SortExpression = 'Phone DESC' THEN Phone END DESC,  
   CASE WHEN @SortExpression = 'Zip ASC' THEN Phone END ASC,  
   CASE WHEN @SortExpression = 'Zip DESC' THEN Phone END DESC,  
   CASE WHEN @SortExpression = 'CreatedDateTime ASC' THEN CreatedDateTime END ASC,  
   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN CreatedDateTime END DESC  
  
 -- get record count - Table 5  
 SELECT COUNT(*) AS TotalRecordCount  
 FROM tblInstallUsers t  
 LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser  
 LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id  
 LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id  
 LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id  
 LEFT JOIN tblSource s ON t.SourceId = s.Id  
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') AND (@SearchTerm IS NULL OR  
   1 = CASE WHEN t.InstallId LIKE '%'+ @SearchTerm + '%' THEN 1  
    WHEN t.FristName LIKE '%'+ @SearchTerm + '%' THEN 1  
    WHEN t.LastName LIKE '%'+ @SearchTerm + '%' THEN 1  
    WHEN t.Email LIKE '%'+ @SearchTerm + '%' THEN 1  
    WHEN t.Phone LIKE '%'+ @SearchTerm + '%' THEN 1  
    WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1  
    WHEN t.Zip LIKE '%'+ @SearchTerm + '%' THEN 1  
    ELSE 0 END)  
  AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))  
  AND t.Status NOT IN (@OfferMadeStatus, @ActiveStatus)  
  AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))  
  AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))  
  AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))  
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)  
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)  
  
  -- Get the Total Count - Table 6  
   SELECT Count(*) as TCount  
  FROM tblInstallUsers t  
  LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser  
  LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser  
  LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId= ru.Id  
  LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id  
  LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id  
  LEFT JOIN tblSource s ON t.SourceId = s.Id  
  left outer join InstallUserBMLog as bm on t.id  =bm.bookmarkedUser and bm.isDeleted=0  
  OUTER APPLY(    SELECT TOP 1 tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo  
  FROM tblTaskAssignedUsers u  
  INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND (tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1)  
  WHERE u.UserId = t.Id  
   ) AS Task  
  WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') AND (@SearchTerm IS NULL OR  
    1 = CASE WHEN t.InstallId LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.FristName LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.LastName LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.Email LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.Phone LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.Zip LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.City LIKE '%'+ @SearchTerm + '%' THEN 1  
  ELSE 0 END)  
   AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))  
   AND t.Status NOT IN (@OfferMadeStatus, @ActiveStatus)  
   AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))  
   AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))  
   --AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))  
   AND ISNULL(t1.Id,t2.Id)=ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id))  
   AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)  
   AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)  
     
     -- Get the Total Count - Table 7  
 select * from tblUserEmail  
  
   -- Get the Total Count - Table 8  
 select * from tblUserPhone  
  
  -- Get Notes from tblUserNotes - Table 9  
--  SELECT I.FristName+' - '+CAST(I.ID as varchar) as [AddedBy],N.AddedOn,N.Notes, N.UserID from tblInstallUsers I INNER JOIN tblUserNotes N ON  
--(I.ID = N.UserID)  
  
 SELECt UserTouchPointLogID , UserID, UpdatedByUserID, UpdatedUserInstallID, replace(LogDescription,'Note : ','') LogDescription, CurrentUserGUID,  
 CONVERT(VARCHAR,ChangeDateTime,101) + ' ' + convert(varchar, ChangeDateTime, 108) as CreatedDate  
 FROM tblUserTouchPointLog n WITH (NOLOCK)  
 --inner join tblinstallusers I on I.id=n.userid  
 where isnull(UserId,0)>0 and LogDescription like 'Note :%'  
 order by ChangeDateTime desc  
END


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[SP_InsertPerfomace]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [SP_InsertPerfomace]   

	END  
GO    
    
-- =============================================      
-- Author: Yogesh Keraliya      
-- Create date: 05262017      
-- Description: Update users exam performance.      
-- =============================================      
CREATE PROCEDURE [dbo].[SP_InsertPerfomace]       
 (
 -- Add the parameters for the stored procedure here      
 @installUserID varchar(20),       
 @examID int = 0      
 ,@marksEarned int
)
AS      
BEGIN      
 -- SET NOCOUNT ON added to prevent extra result sets from      
 -- interfering with SELECT statements.      
 SET NOCOUNT ON;      
    
 DECLARE @totalMarks INT      
 DECLARE @Aggregate REAL      
 DECLARE @PassPercentage REAL    
        
 DECLARE @ExamPerformanceStatus INT      

 -- Get total marks for exam.
 SELECT @totalMarks = SUM(PositiveMarks) FROM MCQ_Question WHERE ExamID = @examID    
 
 -- User obtained percentage.
 SET @Aggregate =  (@marksEarned/@totalMarks) * 100
 
 -- Get total pass percentage for exam.    
 SELECT @PassPercentage = [PassPercentage] FROM MCQ_Exam WHERE [ExamID] = @examID    
 

 -- Add user pass and fail result.    
 IF(@PassPercentage < @Aggregate)    
	 BEGIN    
    
	 SET @ExamPerformanceStatus = 1    
    
	 END    
 ELSE    
	 BEGIN    
     
	  SET @ExamPerformanceStatus = 0    
    
	 END    
   
     
    -- Insert user exam result
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


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_isAllExamsGivenByUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [usp_isAllExamsGivenByUser]   

	END  
GO    

-- =============================================      
-- Author:  Yogesh Keraliya      
-- Create date: 05302017      
-- Description: This will load exam result for user based on his designation      
-- =============================================      
-- usp_isAllExamsGivenByUser 3555      
CREATE PROCEDURE [dbo].[usp_isAllExamsGivenByUser]       
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
		   (SELECT   Item   FROM  dbo.SplitString(MCQ_Exam.DesignationID, ',') AS SplitString_1)) AND  MCQ_Exam.IsActive = 1     
    
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
  
      