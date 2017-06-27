/*
   Tuesday, June 27, 20172:20:13 PM
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
ALTER TABLE dbo.tblAssignedSequencing
	DROP CONSTRAINT FK_tblAssignedSequencing_tblInstallUsers
GO
ALTER TABLE dbo.tblInstallUsers SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblInstallUsers', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblInstallUsers', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblInstallUsers', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblAssignedSequencing
	DROP CONSTRAINT FK_tblAssignedSequencing_tblTask
GO
ALTER TABLE dbo.tblTask SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblAssignedSequencing
	DROP CONSTRAINT DF_tblAssignedSequencing_CreatedDateTime
GO
ALTER TABLE dbo.tblAssignedSequencing
	DROP CONSTRAINT DF_tblAssignedSequencing_ModifiedDateTime
GO
CREATE TABLE dbo.Tmp_tblAssignedSequencing
	(
	Id bigint NOT NULL IDENTITY (1, 1),
	DesignationId int NOT NULL,
	AssignedDesigSeq bigint NOT NULL,
	UserId int NOT NULL,
	IsTechTask bit NOT NULL,
	TaskId bigint NOT NULL,
	IsTemp bit NOT NULL,
	CreatedDateTime datetime NULL,
	ModifiedDateTime datetime NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblAssignedSequencing SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_tblAssignedSequencing ADD CONSTRAINT
	DF_tblAssignedSequencing_IsTemp DEFAULT 1 FOR IsTemp
GO
ALTER TABLE dbo.Tmp_tblAssignedSequencing ADD CONSTRAINT
	DF_tblAssignedSequencing_CreatedDateTime DEFAULT (getdate()) FOR CreatedDateTime
GO
ALTER TABLE dbo.Tmp_tblAssignedSequencing ADD CONSTRAINT
	DF_tblAssignedSequencing_ModifiedDateTime DEFAULT (getdate()) FOR ModifiedDateTime
GO
SET IDENTITY_INSERT dbo.Tmp_tblAssignedSequencing ON
GO
IF EXISTS(SELECT * FROM dbo.tblAssignedSequencing)
	 EXEC('INSERT INTO dbo.Tmp_tblAssignedSequencing (Id, DesignationId, AssignedDesigSeq, UserId, IsTechTask, TaskId, CreatedDateTime, ModifiedDateTime)
		SELECT Id, DesignationId, AssignedDesigSeq, UserId, IsTechTask, TaskId, CreatedDateTime, ModifiedDateTime FROM dbo.tblAssignedSequencing WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblAssignedSequencing OFF
GO
DROP TABLE dbo.tblAssignedSequencing
GO
EXECUTE sp_rename N'dbo.Tmp_tblAssignedSequencing', N'tblAssignedSequencing', 'OBJECT' 
GO
ALTER TABLE dbo.tblAssignedSequencing ADD CONSTRAINT
	PK_tblAssignedSequencing PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

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
ALTER TABLE dbo.tblAssignedSequencing ADD CONSTRAINT
	FK_tblAssignedSequencing_tblInstallUsers FOREIGN KEY
	(
	UserId
	) REFERENCES dbo.tblInstallUsers
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblAssignedSequencing', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblAssignedSequencing', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblAssignedSequencing', 'Object', 'CONTROL') as Contr_Per 

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetUserAssignedDesigSequencnce]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_GetUserAssignedDesigSequencnce   

	END  
GO    
-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 06092017  
-- Description: This will fetch latest sequence assigned to same designation  
-- =============================================  
 -- usp_GetLastAssignedDesigSequencnce 10,0  
  
CREATE PROCEDURE usp_GetUserAssignedDesigSequencnce   
( -- Add the parameters for the stored procedure here  
 @DesignationId INT ,  
 @IsTechTask BIT,
 @UserID  INT  
)  
AS  
BEGIN  

-- Check if already assigned sequence available to given user.

IF NOT EXISTS ( SELECT [Id] FROM tblAssignedSequencing WHERE UserId = @UserID)
BEGIN

INSERT INTO tblAssignedSequencing  
                         (AssignedDesigSeq, UserId, IsTechTask, TaskId, CreatedDateTime, DesignationId,IsTemp)  
SELECT  TOP 1 ISNULL([Sequence],1), @UserID, @IsTechTask , TaskId, GETDATE() , @DesignationId, 1 FROM tblTask   
WHERE [SequenceDesignationId] = @DesignationID AND IsTechTask = @IsTechTask AND [Sequence] IS NOT NULL AND [Sequence] > (     
  
  SELECT       ISNULL(MAX(AssignedDesigSeq),0) AS LastAssignedSequence  
   FROM            tblAssignedSequencing  
  WHERE        (DesignationId = @DesignationId) AND (IsTechTask = @IsTechTask)  
  
)   
ORDER BY [Sequence] ASC  

END 

-- Get newly assigned sequence from inserted sequence / Already assigned sequence
SELECT  Id,[AssignedDesigSeq] AS [AvailableSequence],TBA.TaskId, dbo.udf_GetParentTaskId(TBA.TaskId) AS ParentTaskId, 
(SELECT Title FROM tblTask WHERE TaskId =  dbo.udf_GetParentTaskId(TBA.TaskId)) AS ParentTitle , dbo.udf_GetCombineInstallId(TBA.TaskId) AS InstallId , T.Title 

FROM tblTask AS T 

INNER JOIN tblAssignedSequencing AS TBA ON TBA.TaskId = T.TaskId
 
WHERE TBA.UserId = @UserId	AND TBA.IsTemp = 1
  
END    


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_UpdateUserAssignedSeqAcceptance]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_UpdateUserAssignedSeqAcceptance   

	END  
GO    
-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 06092017  
-- Description: This will update user assigned sequence status to accepted.
-- =============================================  
  
CREATE PROCEDURE usp_UpdateUserAssignedSeqAcceptance   
(   
 @AssignedSeqID INT
)  
AS  
BEGIN  

	UPDATE       tblAssignedSequencing
	SET                IsTemp = 0
	WHERE        (Id = @AssignedSeqID)

END


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_RemoveUserAssignedSeq]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_RemoveUserAssignedSeq   

	END  
GO    
-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 06092017  
-- Description: This will remove any assigned sequence to user , assign task to user and set its status 
-- to rejected with reject reason.
-- =============================================  
  
CREATE PROCEDURE usp_RemoveUserAssignedSeq   
(   
 @AssignedSeqID BIGINT,
 @UserId INT,
 @RejectedUserID INT 
)  
AS  
BEGIN  

-- Remove Assigned sequence from tblAssignedSequence
DELETE FROM  tblAssignedSequencing	WHERE (Id = @AssignedSeqID)

-- Remove Assigned Task from TaskAssigned table

DELETE FROM tblTaskAssignedUsers WHERE UserId = @UserId

-- Set STATUS TO Rejected with reject reason.
UPDATE tblInstallUsers SET [Status] = 9 , RejectionTime = GETDATE(), RejectedUserId = @RejectedUserID, RejectionDate = GETDATE(), StatusReason = 'Rejected Auto Assigned Task' WHERE Id = @UserId

END     


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Live publish 06272017

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
