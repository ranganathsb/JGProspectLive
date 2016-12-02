﻿/****** Object:  StoredProcedure [dbo].[usp_GetTaskDetails]    Script Date: 30-Nov-16 10:37:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all details of task for edit.
-- =============================================
-- usp_GetTaskDetails 170
ALTER PROCEDURE [dbo].[usp_GetTaskDetails] 
(
	@TaskId int 
)	  
AS
BEGIN
	
	SET NOCOUNT ON;

	-- task manager detail
	DECLARE @AssigningUser varchar(50) = NULL

	SELECT @AssigningUser = Users.[Username] 
	FROM 
		tblTask AS Task 
		INNER JOIN [dbo].[tblUsers] AS Users  ON Task.[CreatedBy] = Users.Id
	WHERE TaskId = @TaskId

	IF(@AssigningUser IS NULL)
	BEGIN
		SELECT @AssigningUser = Users.FristName + ' ' + Users.LastName 
		FROM 
			tblTask AS Task 
			INNER JOIN [dbo].[tblInstallUsers] AS Users  ON Task.[CreatedBy] = Users.Id
		WHERE TaskId = @TaskId
	END

	-- task's main details
	SELECT Title, [Description], [Status], DueDate,Tasks.[Hours], Tasks.CreatedOn, Tasks.TaskPriority,
		   Tasks.InstallId, Tasks.CreatedBy, @AssigningUser AS AssigningManager ,Tasks.TaskType, Tasks.IsTechTask,
		   STUFF
			(
				(SELECT  CAST(', ' + ttuf.[Attachment] + '@' + ttuf.[AttachmentOriginal] as VARCHAR(max)) AS attachment
				FROM dbo.tblTaskUserFiles ttuf
				WHERE ttuf.TaskId = Tasks.TaskId
				FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
				,1
				,2
				,' '
			) AS attachment
	FROM tblTask AS Tasks
	WHERE Tasks.TaskId = @TaskId

	-- task's designation details
	SELECT Designation
	FROM tblTaskDesignations
	WHERE (TaskId = @TaskId)

	-- task's assigned users
	SELECT UserId, TaskId
	FROM tblTaskAssignedUsers
	WHERE (TaskId = @TaskId)

	-- task's notes and attachment information.
	--SELECT	TaskUsers.Id,TaskUsers.UserId, TaskUsers.UserType, TaskUsers.Notes, TaskUsers.UserAcceptance, TaskUsers.UpdatedOn, 
	--	    TaskUsers.[Status], TaskUsers.TaskId, tblInstallUsers.FristName,TaskUsers.UserFirstName, tblInstallUsers.Designation,
	--		(SELECT COUNT(ttuf.[Id]) FROM dbo.tblTaskUserFiles ttuf WHERE ttuf.[TaskUpdateID] = TaskUsers.Id) AS AttachmentCount,
	--		dbo.UDF_GetTaskUpdateAttachments(TaskUsers.Id) AS attachments
	--FROM    
	--	tblTaskUser AS TaskUsers 
	--	LEFT OUTER JOIN tblInstallUsers ON TaskUsers.UserId = tblInstallUsers.Id
	--WHERE (TaskUsers.TaskId = @TaskId) 
	
	-- Description:	Get All Notes along with Attachments.
	-- Modify by :: Aavadesh Patel :: 10.08.2016 23:28

;WITH TaskHistory
AS 
(
	SELECT	
		TaskUsers.Id,
		TaskUsers.UserId, 
		TaskUsers.UserType, 
		TaskUsers.Notes, 
		TaskUsers.UserAcceptance, 
		TaskUsers.UpdatedOn, 
		TaskUsers.[Status], 
		TaskUsers.TaskId, 
		tblInstallUsers.FristName,
		tblInstallUsers.LastName,
		TaskUsers.UserFirstName, 
		tblInstallUsers.Designation,
		tblInstallUsers.Picture,
		tblInstallUsers.UserInstallId,
		(SELECT COUNT(ttuf.[Id]) FROM dbo.tblTaskUserFiles ttuf WHERE ttuf.[TaskUpdateID] = TaskUsers.Id) AS AttachmentCount,
		dbo.UDF_GetTaskUpdateAttachments(TaskUsers.Id) AS attachments,
		'' as AttachmentOriginal , 0 as TaskUserFilesID,
		'' as Attachment , '' as FileType
	FROM    
		tblTaskUser AS TaskUsers 
		LEFT OUTER JOIN tblInstallUsers ON TaskUsers.UserId = tblInstallUsers.Id
	WHERE (TaskUsers.TaskId = @TaskId) AND (TaskUsers.Notes <> '' OR TaskUsers.Notes IS NOT NULL) 
	
	
	Union All 
		
	SELECT	
		tblTaskUserFiles.Id , 
		tblTaskUserFiles.UserId , 
		'' as UserType , 
		'' as Notes , 
		'' as UserAcceptance , 
		tblTaskUserFiles.AttachedFileDate AS UpdatedOn,
		'' as [Status] , 
		tblTaskUserFiles.TaskId , 
		tblInstallUsers.FristName  ,
		tblInstallUsers.LastName,
		tblInstallUsers.FristName as UserFirstName , 
		'' as Designation , 
		tblInstallUsers.Picture,
		tblInstallUsers.UserInstallId,
		'' as AttachmentCount , 
		'' as attachments,
		 tblTaskUserFiles.AttachmentOriginal,
		 tblTaskUserFiles.Id as  TaskUserFilesID,
		 tblTaskUserFiles.Attachment, 
		 tblTaskUserFiles.FileType
	FROM   tblTaskUserFiles   
	LEFT OUTER JOIN tblInstallUsers ON tblInstallUsers.Id = tblTaskUserFiles.UserId
	WHERE (tblTaskUserFiles.TaskId = @TaskId) AND (tblTaskUserFiles.Attachment <> '' OR tblTaskUserFiles.Attachment IS NOT NULL)
)

SELECT * from TaskHistory ORDER BY  UpdatedOn DESC
	
	-- sub tasks
	SELECT Tasks.TaskId, Title, [Description], Tasks.[Status], DueDate,Tasks.[Hours], Tasks.CreatedOn, Tasks.TaskPriority,
		   Tasks.InstallId, Tasks.CreatedBy, @AssigningUser AS AssigningManager , UsersMaster.FristName,
		   Tasks.TaskType,Tasks.TaskPriority, Tasks.IsTechTask,
		   STUFF
			(
				(SELECT  CAST(', ' + ttuf.[Attachment] + '@' + ttuf.[AttachmentOriginal] as VARCHAR(max)) AS attachment
				FROM dbo.tblTaskUserFiles ttuf
				WHERE ttuf.TaskId = Tasks.TaskId
				FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
				,1
				,2
				,' '
			) AS attachment
	FROM 
		tblTask AS Tasks LEFT OUTER JOIN
        tblTaskAssignedUsers AS TaskUsers ON Tasks.TaskId = TaskUsers.TaskId LEFT OUTER JOIN
        tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id --LEFT OUTER JOIN
		--tblTaskDesignations AS TaskDesignation ON Tasks.TaskId = TaskDesignation.TaskId
	WHERE Tasks.ParentTaskId = @TaskId
    
	-- main task attachments
	SELECT 
		CAST(
				--tuf.[Attachment] + '@' + tuf.[AttachmentOriginal] 
				ISNULL(tuf.[Attachment],'') + '@' + ISNULL(tuf.[AttachmentOriginal],'') 
				AS VARCHAR(MAX)
			) AS attachment,
		ISNULL(u.FirstName,iu.FristName) AS FirstName
	FROM dbo.tblTaskUserFiles tuf
			LEFT JOIN tblUsers u ON tuf.UserId = u.Id --AND tuf.UserType = u.Usertype
			LEFT JOIN tblInstallUsers iu ON tuf.UserId = iu.Id --AND tuf.UserType = u.UserType
	WHERE tuf.TaskId = @TaskId

END
GO


/****** Object:  StoredProcedure [dbo].[UpdateTaskWorkSpecificationStatusByTaskId]    Script Date: 04-Nov-16 11:43:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 13 Sep 16
-- Description:	Updates status of Task specifications including childs by Id.
-- =============================================

ALTER PROCEDURE [dbo].[UpdateTaskWorkSpecificationStatusById]
	@Id		BIGINT,
	@AdminStatus BIT = NULL,
	@TechLeadStatus BIT = NULL,
	@OtherUserStatus BIT = NULL,
	@UserId int,
	@IsInstallUser bit
AS
BEGIN
	
	DECLARE	@tblTemp	TABLE(Id BIGINT)

	-- gets current as well as all child specifications.
	;WITH TWS AS
	(
		SELECT s.*
		FROM tblTaskWorkSpecifications s
		WHERE Id = @Id

		UNION ALL

		SELECT s.*
		FROM tblTaskWorkSpecifications s 
			INNER JOIN TWS t ON s.ParentTaskWorkSpecificationId = t.Id
	)

	INSERT INTO @tblTemp
	SELECT ID FROM TWS

	IF @AdminStatus IS NOT NULL
	BEGIN
		UPDATE tblTaskWorkSpecifications
		SET
			AdminStatus = @AdminStatus,
			AdminUserId= @UserId,
			IsAdminInstallUser = @IsInstallUser,
			AdminStatusUpdated = GETDATE(),
			DateUpdated = GETDATE()
		WHERE Id IN (SELECT ID FROM @tblTemp)
	END
	ELSE IF @TechLeadStatus IS NOT NULL
	BEGIN
		UPDATE tblTaskWorkSpecifications
		SET
			TechLeadStatus = @TechLeadStatus,
			TechLeadUserId= @UserId,
			IsTechLeadInstallUser = @IsInstallUser,
			TechLeadStatusUpdated = GETDATE(),
			DateUpdated = GETDATE()
		WHERE Id IN (SELECT ID FROM @tblTemp)
	END
	ELSE IF @OtherUserStatus IS NOT NULL
	BEGIN
		UPDATE tblTaskWorkSpecifications
		SET
			OtherUserStatus = @OtherUserStatus,
			OtherUserId= @UserId,
			IsOtherUserInstallUser = @IsInstallUser,
			OtherUserStatusUpdated = GETDATE(),
			DateUpdated = GETDATE()
		WHERE Id IN (SELECT ID FROM @tblTemp)
	END

END
GO

--=================================================================================================================================================================================================

-- Published on live 12012016 

--=================================================================================================================================================================================================


-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all sub tasks of a task.
-- =============================================
-- usp_GetSubTasks 10015
ALTER PROCEDURE [dbo].[usp_GetSubTasks] 
(
	@TaskId int,
	@Admin bit
)	  
AS
BEGIN
	
	SET NOCOUNT ON;

	-- task manager detail
	DECLARE @AssigningUser varchar(50) = NULL

	SELECT @AssigningUser = Users.[Username] 
	FROM 
		tblTask AS Task 
		INNER JOIN [dbo].[tblUsers] AS Users  ON Task.[CreatedBy] = Users.Id
	WHERE TaskId = @TaskId

	IF(@AssigningUser IS NULL)
	BEGIN
		SELECT @AssigningUser = Users.FristName + ' ' + Users.LastName 
		FROM 
			tblTask AS Task 
			INNER JOIN [dbo].[tblInstallUsers] AS Users  ON Task.[CreatedBy] = Users.Id
		WHERE TaskId = @TaskId
	END

	-- sub tasks
	SELECT 
			Tasks.*,
			--Tasks.TaskId, Title, [Description], Tasks.[Status], DueDate,Tasks.[Hours], Tasks.CreatedOn,
			--Tasks.InstallId, Tasks.CreatedBy, Tasks.TaskType,Tasks.TaskPriority,
			@AssigningUser AS AssigningManager,
			UsersMaster.FristName, 
			STUFF
			(
				(SELECT  CAST(', ' + ttuf.[Attachment] + '@' + ttuf.[AttachmentOriginal] as VARCHAR(max)) AS attachment
				FROM dbo.tblTaskUserFiles ttuf
				WHERE ttuf.TaskId = Tasks.TaskId
				FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
				,1
				,2
				,' '
			) AS attachment
	FROM 
		tblTask AS Tasks LEFT OUTER JOIN
        tblTaskAssignedUsers AS TaskUsers ON Tasks.TaskId = TaskUsers.TaskId LEFT OUTER JOIN
        tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id --LEFT OUTER JOIN
		--tblTaskDesignations AS TaskDesignation ON Tasks.TaskId = TaskDesignation.TaskId
	WHERE 
			Tasks.ParentTaskId = @TaskId 
			--AND
			--1 = CASE
			--		-- load records with all status for admin users.
			--		WHEN @Admin = 1 THEN
			--			1
			--		-- load only approved records for non-admin users.
			--		ELSE
			--			CASE
			--				WHEN Tasks.[AdminStatus] = 1 AND Tasks.[TechLeadStatus] = 1 THEN 1
			--				ELSE 0
			--			END
			--	END
    
END
