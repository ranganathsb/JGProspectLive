/****** Object:  StoredProcedure [dbo].[usp_GetTaskDetails]    Script Date: 30-Nov-16 10:37:04 AM ******/
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
GO

/****** Object:  StoredProcedure [dbo].[uspSearchTasks]    Script Date: 02-Dec-16 8:44:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 8/25/16
-- Description:	This procedure is used to search tasks by different parameters.
-- =============================================
ALTER PROCEDURE [dbo].[uspSearchTasks]
	@Designations	VARCHAR(4000) = '0',
	@UserId			INT = NULL,
	@Status			TINYINT = NULL,
	@CreatedFrom	DATETIME = NULL,
	@CreatedTo		DATETIME = NULL,
	@SearchTerm		VARCHAR(250) = NULL,
	@SortExpression	VARCHAR(250) = 'CreatedOn DESC',
	@ExcludeStatus	TINYINT = NULL,
	@Admin			BIT,
	@PageIndex		INT = 0,
	@PageSize		INT = 10,
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @PageIndex = @PageIndex + 1

	;WITH 
	
	Tasklist AS
	(	
	
		SELECT 
			--TaskUserMatch.IsMatch AS TaskUserMatch,
			--TaskUserRequestsMatch.IsMatch AS TaskUserRequestsMatch,
			--TaskDesignationMatch.IsMatch AS TaskDesignationMatch,
			Tasks.*
		FROM
			(
				SELECT 
					Tasks.*,
					1 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY [Status],
							CASE WHEN @SortExpression = 'UserID DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@AssignedStatus,@RequestedStatus)
					
				UNION

				SELECT 
					Tasks.*,
					2 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY [Status], [TaskPriority],
							CASE WHEN @SortExpression = 'UserID DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@OpenStatus) AND ISNULL([TaskPriority],'') <> ''

				UNION

				SELECT 
					Tasks.*,
					3 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY [Status], [TaskPriority],
							CASE WHEN @SortExpression = 'UserID DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@OpenStatus)

				UNION

				SELECT 
					Tasks.*,
					4 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'UserID DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] = @ClosedStatus

				UNION

				SELECT 
					Tasks.*,
					5 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'UserID DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] = @DeletedStatus
			) Tasks    
			OUTER APPLY
			(
				SELECT TOP 1 
						1 AS IsMatch,
						TaskUsers.UserId AS UserId,
						UsersMaster.FristName AS FristName
				FROM tblTaskAssignedUsers TaskUsers
						LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
				WHERE 
					TaskUsers.TaskId = Tasks.TaskId AND
					TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
					1 = CASE
							WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
							WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
							WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
							ELSE 0
						END
			) As TaskUserMatch
			OUTER APPLY
			(
				SELECT TOP 1 
						1 AS IsMatch,
						TaskUsers.UserId AS UserId,
						UsersMaster.FristName AS FristName
				FROM tblTaskAssignmentRequests TaskUsers
						LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
				WHERE 
					TaskUsers.TaskId = Tasks.TaskId AND
					TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
					1 = CASE
							WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
							WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
							WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
							ELSE 0
						END
			) As TaskUserRequestsMatch
			OUTER APPLY
			(
				SELECT TOP 1 
						CASE
						WHEN @SearchTerm IS NULL THEN
							CASE
								WHEN @Designations = '0' THEN 1
								WHEN EXISTS (SELECT ss.Item  FROM dbo.SplitString(@Designations,',') ss WHERE ss.Item = TaskDesignations.Designation) THEN 1
								ELSE 0 
							END
						ELSE 
							CASE
								WHEN @Designations = '0' AND TaskDesignations.Designation LIKE '%' + @SearchTerm + '%' THEN 1
								WHEN (Tasks.[InstallId] LIKE '%' + @SearchTerm + '%'  OR Tasks.[Title] LIKE '%' + @SearchTerm + '%') THEN 1
								ELSE 0
							END
						END AS IsMatch,
						TaskDesignations.Designation AS Designation
				FROM tblTaskDesignations AS TaskDesignations
				WHERE 
					TaskDesignations.TaskId = Tasks.TaskId AND
					1 = CASE
							WHEN @Designations = '0' AND @SearchTerm IS NULL THEN 1 -- set true, when '0' (all designations) is provided with no search term.
							WHEN @Designations = '0' AND @SearchTerm IS NOT NULL AND TaskDesignations.Designation LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if designations found by search term.
							WHEN EXISTS (SELECT ss.Item  FROM dbo.SplitString(@Designations,',') ss WHERE ss.Item = TaskDesignations.Designation) THEN 1 -- filter based on provided designations.
							ELSE 0
						END
			)  AS TaskDesignationMatch
		WHERE
			Tasks.ParentTaskId IS NULL 
			AND
			1 = CASE
					WHEN @Admin = 1 THEN 1
					ELSE
						CASE
							WHEN Tasks.[Status] = @ExcludeStatus THEN 0
							ELSE 1
					END
				END
			AND 
			1 = CASE 
					-- filter records only by user, when search term is not provided.
					WHEN @SearchTerm IS NULL THEN
						CASE
							WHEN TaskUserMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1 THEN 1
							WHEN TaskUserRequestsMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1 THEN 1
							ELSE 0
						END
					-- filter records by installid, title, users when search term is provided.
					ELSE
						CASE
							WHEN Tasks.[InstallId] LIKE '%' + @SearchTerm + '%' THEN 1
							WHEN Tasks.[Title] LIKE '%' + @SearchTerm + '%' THEN 1
							WHEN TaskUserMatch.IsMatch = 1 THEN 1
							WHEN TaskUserRequestsMatch.IsMatch = 1 THEN 1
							ELSE 0
						END
				END
			AND
			Tasks.[Status] = ISNULL(@Status,Tasks.[Status]) 
			AND
			CONVERT(VARCHAR,Tasks.[CreatedOn],101)  >= ISNULL(@CreatedFrom,CONVERT(VARCHAR,Tasks.[CreatedOn],101)) AND
			CONVERT(VARCHAR,Tasks.[CreatedOn],101)  <= ISNULL(@CreatedTo,CONVERT(VARCHAR,Tasks.[CreatedOn],101))
	),

	FinalData AS
	( 
		SELECT * ,
			Row_number() OVER(ORDER BY SortOrder ASC) AS RowNo
		FROM Tasklist 
	)
	
	-- get records
	SELECT * 
	FROM FinalData 
	WHERE  
		RowNo BETWEEN (@PageIndex - 1) * @PageSize + 1 AND 
		@PageIndex * @PageSize

	-- get record count
	SELECT 
		COUNT(DISTINCT Tasks.TaskId) AS VirtualCount
	FROM          
		tblTask AS Tasks 
		OUTER APPLY
		(
			SELECT TOP 1 
					1 AS IsMatch,
					TaskUsers.UserId AS UserId,
					UsersMaster.FristName AS FristName
			FROM tblTaskAssignedUsers TaskUsers
					LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
			WHERE 
				TaskUsers.TaskId = Tasks.TaskId AND
				TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
				1 = CASE
						WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
						WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
						WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
						ELSE 0
					END
		) As TaskUserMatch
		OUTER APPLY
		(
			SELECT TOP 1 
					1 AS IsMatch,
					TaskUsers.UserId AS UserId,
					UsersMaster.FristName AS FristName
			FROM tblTaskAssignmentRequests TaskUsers
					LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
			WHERE 
				TaskUsers.TaskId = Tasks.TaskId AND
				TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
				1 = CASE
						WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
						WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
						WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
						ELSE 0
					END
		) As TaskUserRequestsMatch
		OUTER APPLY
		(
			SELECT TOP 1 
					1 AS IsMatch,
					TaskDesignations.Designation AS Designation
			FROM tblTaskDesignations AS TaskDesignations
			WHERE 
				TaskDesignations.TaskId = Tasks.TaskId AND
				1 = CASE
						WHEN @Designations = '0' AND @SearchTerm IS NULL THEN 1 -- set true, when '0' (all designations) is provided with no search term.
						WHEN @Designations = '0' AND @SearchTerm IS NOT NULL AND TaskDesignations.Designation LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if designations found by search term.
						WHEN EXISTS (SELECT ss.Item  FROM dbo.SplitString(@Designations,',') ss WHERE ss.Item = TaskDesignations.Designation) THEN 1 -- filter based on provided designations.
						ELSE 0
					END
		)  AS TaskDesignationMatch
	WHERE
		Tasks.ParentTaskId IS NULL 
		AND 
		1 = CASE 
				-- filter records only by user, when search term is not provided.
				WHEN @SearchTerm IS NULL THEN
					CASE
						WHEN TaskUserMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1 THEN 1
						WHEN TaskUserRequestsMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1THEN 1
						ELSE 0
					END
				-- filter records by installid, title, users when search term is provided.
				ELSE
					CASE
						WHEN Tasks.[InstallId] LIKE '%' + @SearchTerm + '%' THEN 1
						WHEN Tasks.[Title] LIKE '%' + @SearchTerm + '%' THEN 1
						WHEN TaskUserMatch.IsMatch = 1 THEN 1
						WHEN TaskUserRequestsMatch.IsMatch = 1 THEN 1
						ELSE 0
					END
			END
		AND
		Tasks.[Status] = ISNULL(@Status,Tasks.[Status]) 
		AND
		CONVERT(VARCHAR,Tasks.[CreatedOn],101)  >= ISNULL(@CreatedFrom,CONVERT(VARCHAR,Tasks.[CreatedOn],101)) AND
		CONVERT(VARCHAR,Tasks.[CreatedOn],101)  <= ISNULL(@CreatedTo,CONVERT(VARCHAR,Tasks.[CreatedOn],101))

END
GO


-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all sub tasks of a task.
-- =============================================
-- usp_GetSubTasks 10015
ALTER PROCEDURE [dbo].[usp_GetSubTasks] 
(
	@TaskId INT,
	@Admin BIT,
	@SortExpression	VARCHAR(250) = 'Status DESC',
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	;WITH 
	
	Tasklist AS
	(	
	
		SELECT 
			--TaskUserMatch.IsMatch AS TaskUserMatch,
			--TaskUserRequestsMatch.IsMatch AS TaskUserRequestsMatch,
			--TaskDesignationMatch.IsMatch AS TaskDesignationMatch,
			Tasks.*
		FROM
			(
				SELECT 
					Tasks.*,
					1 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@AssignedStatus,@RequestedStatus)
					
				UNION

				SELECT 
					Tasks.*,
					2 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@InProgressStatus,@PendingStatus,@ReOpenedStatus)
					
				UNION

				SELECT 
					Tasks.*,
					3 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY 
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@OpenStatus) AND ISNULL([TaskPriority],'') <> ''

				UNION

				SELECT 
					Tasks.*,
					4 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY 
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@OpenStatus, @SpecsInProgressStatus)

				UNION

				SELECT 
					Tasks.*,
					5 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] = @ClosedStatus

				UNION

				SELECT 
					Tasks.*,
					6 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] = @DeletedStatus
			) Tasks
		WHERE
			Tasks.ParentTaskId = @TaskId
	),

	FinalData AS
	( 
		SELECT * ,
			Row_number() OVER(ORDER BY SortOrder ASC) AS RowNo
		FROM Tasklist 
	)
	
	-- get records
	SELECT * 
	FROM FinalData 

END
GO



-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 8/25/16
-- Description:	This procedure is used to search tasks by different parameters.
-- =============================================
ALTER PROCEDURE [dbo].[uspSearchTasks]
	@Designations	VARCHAR(4000) = '0',
	@UserId			INT = NULL,
	@Status			TINYINT = NULL,
	@CreatedFrom	DATETIME = NULL,
	@CreatedTo		DATETIME = NULL,
	@SearchTerm		VARCHAR(250) = NULL,
	@SortExpression	VARCHAR(250) = 'CreatedOn DESC',
	@ExcludeStatus	TINYINT = NULL,
	@Admin			BIT,
	@PageIndex		INT = 0,
	@PageSize		INT = 10,
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @PageIndex = @PageIndex + 1

	;WITH 
	
	Tasklist AS
	(	
	
		SELECT 
			--TaskUserMatch.IsMatch AS TaskUserMatch,
			--TaskUserRequestsMatch.IsMatch AS TaskUserRequestsMatch,
			--TaskDesignationMatch.IsMatch AS TaskDesignationMatch,
			Tasks.*
		FROM
			(
				SELECT 
					Tasks.*,
					1 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@AssignedStatus,@RequestedStatus)
					
				UNION

				SELECT 
					Tasks.*,
					2 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@InProgressStatus,@PendingStatus,@ReOpenedStatus)
					
				UNION

				SELECT 
					Tasks.*,
					3 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY 
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@OpenStatus) AND ISNULL([TaskPriority],'') <> ''

				UNION

				SELECT 
					Tasks.*,
					4 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY 
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@OpenStatus, @SpecsInProgressStatus)

				UNION

				SELECT 
					Tasks.*,
					5 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] = @ClosedStatus

				UNION

				SELECT 
					Tasks.*,
					6 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] = @DeletedStatus
			) Tasks    
			OUTER APPLY
			(
				SELECT TOP 1 
						1 AS IsMatch,
						TaskUsers.UserId AS UserId,
						UsersMaster.FristName AS FristName
				FROM tblTaskAssignedUsers TaskUsers
						LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
				WHERE 
					TaskUsers.TaskId = Tasks.TaskId AND
					TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
					1 = CASE
							WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
							WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
							WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
							ELSE 0
						END
			) As TaskUserMatch
			OUTER APPLY
			(
				SELECT TOP 1 
						1 AS IsMatch,
						TaskUsers.UserId AS UserId,
						UsersMaster.FristName AS FristName
				FROM tblTaskAssignmentRequests TaskUsers
						LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
				WHERE 
					TaskUsers.TaskId = Tasks.TaskId AND
					TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
					1 = CASE
							WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
							WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
							WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
							ELSE 0
						END
			) As TaskUserRequestsMatch
			OUTER APPLY
			(
				SELECT TOP 1 
						CASE
						WHEN @SearchTerm IS NULL THEN
							CASE
								WHEN @Designations = '0' THEN 1
								WHEN EXISTS (SELECT ss.Item  FROM dbo.SplitString(@Designations,',') ss WHERE ss.Item = TaskDesignations.Designation) THEN 1
								ELSE 0 
							END
						ELSE 
							CASE
								WHEN @Designations = '0' AND TaskDesignations.Designation LIKE '%' + @SearchTerm + '%' THEN 1
								WHEN (Tasks.[InstallId] LIKE '%' + @SearchTerm + '%'  OR Tasks.[Title] LIKE '%' + @SearchTerm + '%') THEN 1
								ELSE 0
							END
						END AS IsMatch,
						TaskDesignations.Designation AS Designation
				FROM tblTaskDesignations AS TaskDesignations
				WHERE 
					TaskDesignations.TaskId = Tasks.TaskId AND
					1 = CASE
							WHEN @Designations = '0' AND @SearchTerm IS NULL THEN 1 -- set true, when '0' (all designations) is provided with no search term.
							WHEN @Designations = '0' AND @SearchTerm IS NOT NULL AND TaskDesignations.Designation LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if designations found by search term.
							WHEN EXISTS (SELECT ss.Item  FROM dbo.SplitString(@Designations,',') ss WHERE ss.Item = TaskDesignations.Designation) THEN 1 -- filter based on provided designations.
							ELSE 0
						END
			)  AS TaskDesignationMatch
		WHERE
			Tasks.ParentTaskId IS NULL 
			AND
			1 = CASE
					WHEN @Admin = 1 THEN 1
					ELSE
						CASE
							WHEN Tasks.[Status] = @ExcludeStatus THEN 0
							ELSE 1
					END
				END
			AND 
			1 = CASE 
					-- filter records only by user, when search term is not provided.
					WHEN @SearchTerm IS NULL THEN
						CASE
							WHEN TaskUserMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1 THEN 1
							WHEN TaskUserRequestsMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1 THEN 1
							ELSE 0
						END
					-- filter records by installid, title, users when search term is provided.
					ELSE
						CASE
							WHEN Tasks.[InstallId] LIKE '%' + @SearchTerm + '%' THEN 1
							WHEN Tasks.[Title] LIKE '%' + @SearchTerm + '%' THEN 1
							WHEN TaskUserMatch.IsMatch = 1 THEN 1
							WHEN TaskUserRequestsMatch.IsMatch = 1 THEN 1
							ELSE 0
						END
				END
			AND
			Tasks.[Status] = ISNULL(@Status,Tasks.[Status]) 
			AND
			CONVERT(VARCHAR,Tasks.[CreatedOn],101)  >= ISNULL(@CreatedFrom,CONVERT(VARCHAR,Tasks.[CreatedOn],101)) AND
			CONVERT(VARCHAR,Tasks.[CreatedOn],101)  <= ISNULL(@CreatedTo,CONVERT(VARCHAR,Tasks.[CreatedOn],101))
	),

	FinalData AS
	( 
		SELECT * ,
			Row_number() OVER(ORDER BY SortOrder ASC) AS RowNo
		FROM Tasklist 
	)
	
	-- get records
	SELECT * 
	FROM FinalData 
	WHERE  
		RowNo BETWEEN (@PageIndex - 1) * @PageSize + 1 AND 
		@PageIndex * @PageSize

	-- get record count
	SELECT 
		COUNT(DISTINCT Tasks.TaskId) AS VirtualCount
	FROM          
		tblTask AS Tasks 
		OUTER APPLY
		(
			SELECT TOP 1 
					1 AS IsMatch,
					TaskUsers.UserId AS UserId,
					UsersMaster.FristName AS FristName
			FROM tblTaskAssignedUsers TaskUsers
					LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
			WHERE 
				TaskUsers.TaskId = Tasks.TaskId AND
				TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
				1 = CASE
						WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
						WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
						WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
						ELSE 0
					END
		) As TaskUserMatch
		OUTER APPLY
		(
			SELECT TOP 1 
					1 AS IsMatch,
					TaskUsers.UserId AS UserId,
					UsersMaster.FristName AS FristName
			FROM tblTaskAssignmentRequests TaskUsers
					LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
			WHERE 
				TaskUsers.TaskId = Tasks.TaskId AND
				TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
				1 = CASE
						WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
						WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
						WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
						ELSE 0
					END
		) As TaskUserRequestsMatch
		OUTER APPLY
		(
			SELECT TOP 1 
					1 AS IsMatch,
					TaskDesignations.Designation AS Designation
			FROM tblTaskDesignations AS TaskDesignations
			WHERE 
				TaskDesignations.TaskId = Tasks.TaskId AND
				1 = CASE
						WHEN @Designations = '0' AND @SearchTerm IS NULL THEN 1 -- set true, when '0' (all designations) is provided with no search term.
						WHEN @Designations = '0' AND @SearchTerm IS NOT NULL AND TaskDesignations.Designation LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if designations found by search term.
						WHEN EXISTS (SELECT ss.Item  FROM dbo.SplitString(@Designations,',') ss WHERE ss.Item = TaskDesignations.Designation) THEN 1 -- filter based on provided designations.
						ELSE 0
					END
		)  AS TaskDesignationMatch
	WHERE
		Tasks.ParentTaskId IS NULL 
		AND 
		1 = CASE 
				-- filter records only by user, when search term is not provided.
				WHEN @SearchTerm IS NULL THEN
					CASE
						WHEN TaskUserMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1 THEN 1
						WHEN TaskUserRequestsMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1THEN 1
						ELSE 0
					END
				-- filter records by installid, title, users when search term is provided.
				ELSE
					CASE
						WHEN Tasks.[InstallId] LIKE '%' + @SearchTerm + '%' THEN 1
						WHEN Tasks.[Title] LIKE '%' + @SearchTerm + '%' THEN 1
						WHEN TaskUserMatch.IsMatch = 1 THEN 1
						WHEN TaskUserRequestsMatch.IsMatch = 1 THEN 1
						ELSE 0
					END
			END
		AND
		Tasks.[Status] = ISNULL(@Status,Tasks.[Status]) 
		AND
		CONVERT(VARCHAR,Tasks.[CreatedOn],101)  >= ISNULL(@CreatedFrom,CONVERT(VARCHAR,Tasks.[CreatedOn],101)) AND
		CONVERT(VARCHAR,Tasks.[CreatedOn],101)  <= ISNULL(@CreatedTo,CONVERT(VARCHAR,Tasks.[CreatedOn],101))

END
GO

--=================================================================================================================================================================================================

-- Published on live 12022016 

--=================================================================================================================================================================================================

/****** Object:  StoredProcedure [dbo].[usp_GetSubTasks]    Script Date: 05-Dec-16 9:05:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all sub tasks of a task.
-- =============================================
-- usp_GetSubTasks 115, 1, 'Description DESC'
ALTER PROCEDURE [dbo].[usp_GetSubTasks] 
(
	@TaskId INT,
	@Admin BIT,
	@SortExpression	VARCHAR(250) = 'CreatedOn DESC',
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	;WITH 
	
	Tasklist AS
	(	
		SELECT
			Tasks.*,
			Row_number() OVER
			(
				ORDER BY
					CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
					CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
					CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
					CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
					CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
					CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
					CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
					CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
					CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
					CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
					CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,
					CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,
					CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
					CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC
			) AS RowNo_Order
		FROM
			(
				SELECT 
					Tasks.*,
					CASE Tasks.[Status]
						WHEN @AssignedStatus THEN 1
						WHEN @RequestedStatus THEN 1

						WHEN @InProgressStatus THEN 2
						WHEN @PendingStatus THEN 2
						WHEN @ReOpenedStatus THEN 2

						WHEN @OpenStatus THEN 
							CASE 
								WHEN ISNULL([TaskPriority],'') <> '' THEN 3
								ELSE 4
							END

						WHEN @SpecsInProgressStatus THEN 4

						WHEN @ClosedStatus THEN 5

						WHEN @DeletedStatus THEN 6

						ELSE 7

					END AS StatusOrder
				FROM 
					[TaskListView] Tasks
				WHERE
					Tasks.ParentTaskId = @TaskId
			) Tasks
	)
	
	-- get records
	SELECT * 
	FROM Tasklist 

END
GO


/****** Object:  StoredProcedure [dbo].[uspSearchTasks]    Script Date: 05-Dec-16 10:20:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 8/25/16
-- Description:	This procedure is used to search tasks by different parameters.
-- =============================================
ALTER PROCEDURE [dbo].[uspSearchTasks]
	@Designations	VARCHAR(4000) = '0',
	@UserId			INT = NULL,
	@Status			TINYINT = NULL,
	@CreatedFrom	DATETIME = NULL,
	@CreatedTo		DATETIME = NULL,
	@SearchTerm		VARCHAR(250) = NULL,
	@SortExpression	VARCHAR(250) = 'CreatedOn DESC',
	@ExcludeStatus	TINYINT = NULL,
	@Admin			BIT,
	@PageIndex		INT = 0,
	@PageSize		INT = 10,
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @PageIndex = @PageIndex + 1

	;WITH 
	
	Tasklist AS
	(	
	
		SELECT 
			--TaskUserMatch.IsMatch AS TaskUserMatch,
			--TaskUserRequestsMatch.IsMatch AS TaskUserRequestsMatch,
			--TaskDesignationMatch.IsMatch AS TaskDesignationMatch,
			Tasks.*,
			Row_number() OVER
			(
				ORDER BY
					CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
					CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
					CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
					CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
					CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
					CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
					CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
					CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
					CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
					CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
					CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,
					CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,
					CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
					CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC
			) AS RowNo_Order
		FROM
			(
				SELECT 
					Tasks.*,
					CASE Tasks.[Status]
						WHEN @AssignedStatus THEN 1
						WHEN @RequestedStatus THEN 1

						WHEN @InProgressStatus THEN 2
						WHEN @PendingStatus THEN 2
						WHEN @ReOpenedStatus THEN 2

						WHEN @OpenStatus THEN 
							CASE 
								WHEN ISNULL([TaskPriority],'') <> '' THEN 3
								ELSE 4
							END

						WHEN @SpecsInProgressStatus THEN 4

						WHEN @ClosedStatus THEN 5

						WHEN @DeletedStatus THEN 6

						ELSE 7

					END AS StatusOrder
				FROM 
					[TaskListView] Tasks
			) Tasks    
			OUTER APPLY
			(
				SELECT TOP 1 
						1 AS IsMatch,
						TaskUsers.UserId AS UserId,
						UsersMaster.FristName AS FristName
				FROM tblTaskAssignedUsers TaskUsers
						LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
				WHERE 
					TaskUsers.TaskId = Tasks.TaskId AND
					TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
					1 = CASE
							WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
							WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
							WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
							ELSE 0
						END
			) As TaskUserMatch
			OUTER APPLY
			(
				SELECT TOP 1 
						1 AS IsMatch,
						TaskUsers.UserId AS UserId,
						UsersMaster.FristName AS FristName
				FROM tblTaskAssignmentRequests TaskUsers
						LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
				WHERE 
					TaskUsers.TaskId = Tasks.TaskId AND
					TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
					1 = CASE
							WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
							WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
							WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
							ELSE 0
						END
			) As TaskUserRequestsMatch
			OUTER APPLY
			(
				SELECT TOP 1 
						CASE
						WHEN @SearchTerm IS NULL THEN
							CASE
								WHEN @Designations = '0' THEN 1
								WHEN EXISTS (SELECT ss.Item  FROM dbo.SplitString(@Designations,',') ss WHERE ss.Item = TaskDesignations.Designation) THEN 1
								ELSE 0 
							END
						ELSE 
							CASE
								WHEN @Designations = '0' AND TaskDesignations.Designation LIKE '%' + @SearchTerm + '%' THEN 1
								WHEN (Tasks.[InstallId] LIKE '%' + @SearchTerm + '%'  OR Tasks.[Title] LIKE '%' + @SearchTerm + '%') THEN 1
								ELSE 0
							END
						END AS IsMatch,
						TaskDesignations.Designation AS Designation
				FROM tblTaskDesignations AS TaskDesignations
				WHERE 
					TaskDesignations.TaskId = Tasks.TaskId AND
					1 = CASE
							WHEN @Designations = '0' AND @SearchTerm IS NULL THEN 1 -- set true, when '0' (all designations) is provided with no search term.
							WHEN @Designations = '0' AND @SearchTerm IS NOT NULL AND TaskDesignations.Designation LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if designations found by search term.
							WHEN EXISTS (SELECT ss.Item  FROM dbo.SplitString(@Designations,',') ss WHERE ss.Item = TaskDesignations.Designation) THEN 1 -- filter based on provided designations.
							ELSE 0
						END
			)  AS TaskDesignationMatch
		WHERE
			Tasks.ParentTaskId IS NULL 
			AND
			1 = CASE
					WHEN @Admin = 1 THEN 1
					ELSE
						CASE
							WHEN Tasks.[Status] = @ExcludeStatus THEN 0
							ELSE 1
					END
				END
			AND 
			1 = CASE 
					-- filter records only by user, when search term is not provided.
					WHEN @SearchTerm IS NULL THEN
						CASE
							WHEN TaskUserMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1 THEN 1
							WHEN TaskUserRequestsMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1 THEN 1
							ELSE 0
						END
					-- filter records by installid, title, users when search term is provided.
					ELSE
						CASE
							WHEN Tasks.[InstallId] LIKE '%' + @SearchTerm + '%' THEN 1
							WHEN Tasks.[Title] LIKE '%' + @SearchTerm + '%' THEN 1
							WHEN TaskUserMatch.IsMatch = 1 THEN 1
							WHEN TaskUserRequestsMatch.IsMatch = 1 THEN 1
							ELSE 0
						END
				END
			AND
			Tasks.[Status] = ISNULL(@Status,Tasks.[Status]) 
			AND
			CONVERT(VARCHAR,Tasks.[CreatedOn],101)  >= ISNULL(@CreatedFrom,CONVERT(VARCHAR,Tasks.[CreatedOn],101)) AND
			CONVERT(VARCHAR,Tasks.[CreatedOn],101)  <= ISNULL(@CreatedTo,CONVERT(VARCHAR,Tasks.[CreatedOn],101))
	)
	
	-- get records
	SELECT * 
	FROM Tasklist 
	WHERE  
		RowNo_Order BETWEEN (@PageIndex - 1) * @PageSize + 1 AND 
		@PageIndex * @PageSize

	-- get record count
	SELECT 
		COUNT(DISTINCT Tasks.TaskId) AS VirtualCount
	FROM          
		tblTask AS Tasks 
		OUTER APPLY
		(
			SELECT TOP 1 
					1 AS IsMatch,
					TaskUsers.UserId AS UserId,
					UsersMaster.FristName AS FristName
			FROM tblTaskAssignedUsers TaskUsers
					LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
			WHERE 
				TaskUsers.TaskId = Tasks.TaskId AND
				TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
				1 = CASE
						WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
						WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
						WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
						ELSE 0
					END
		) As TaskUserMatch
		OUTER APPLY
		(
			SELECT TOP 1 
					1 AS IsMatch,
					TaskUsers.UserId AS UserId,
					UsersMaster.FristName AS FristName
			FROM tblTaskAssignmentRequests TaskUsers
					LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
			WHERE 
				TaskUsers.TaskId = Tasks.TaskId AND
				TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
				1 = CASE
						WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
						WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
						WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
						ELSE 0
					END
		) As TaskUserRequestsMatch
		OUTER APPLY
		(
			SELECT TOP 1 
					1 AS IsMatch,
					TaskDesignations.Designation AS Designation
			FROM tblTaskDesignations AS TaskDesignations
			WHERE 
				TaskDesignations.TaskId = Tasks.TaskId AND
				1 = CASE
						WHEN @Designations = '0' AND @SearchTerm IS NULL THEN 1 -- set true, when '0' (all designations) is provided with no search term.
						WHEN @Designations = '0' AND @SearchTerm IS NOT NULL AND TaskDesignations.Designation LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if designations found by search term.
						WHEN EXISTS (SELECT ss.Item  FROM dbo.SplitString(@Designations,',') ss WHERE ss.Item = TaskDesignations.Designation) THEN 1 -- filter based on provided designations.
						ELSE 0
					END
		)  AS TaskDesignationMatch
	WHERE
		Tasks.ParentTaskId IS NULL 
		AND 
		1 = CASE 
				-- filter records only by user, when search term is not provided.
				WHEN @SearchTerm IS NULL THEN
					CASE
						WHEN TaskUserMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1 THEN 1
						WHEN TaskUserRequestsMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1THEN 1
						ELSE 0
					END
				-- filter records by installid, title, users when search term is provided.
				ELSE
					CASE
						WHEN Tasks.[InstallId] LIKE '%' + @SearchTerm + '%' THEN 1
						WHEN Tasks.[Title] LIKE '%' + @SearchTerm + '%' THEN 1
						WHEN TaskUserMatch.IsMatch = 1 THEN 1
						WHEN TaskUserRequestsMatch.IsMatch = 1 THEN 1
						ELSE 0
					END
			END
		AND
		Tasks.[Status] = ISNULL(@Status,Tasks.[Status]) 
		AND
		CONVERT(VARCHAR,Tasks.[CreatedOn],101)  >= ISNULL(@CreatedFrom,CONVERT(VARCHAR,Tasks.[CreatedOn],101)) AND
		CONVERT(VARCHAR,Tasks.[CreatedOn],101)  <= ISNULL(@CreatedTo,CONVERT(VARCHAR,Tasks.[CreatedOn],101))

END
GO


CREATE TABLE [dbo].[tblTaskApprovals](
	[Id] [bigint] IDENTITY(1,1) PRIMARY KEY,
	[TaskId] [bigint] NOT NULL REFERENCES tblTask,
	[EstimatedHours] VARCHAR(5) NOT NULL,
	[Description] [text] NULL,
	[UserId] INT NULL,
	[IsInstallUser] BIT NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateUpdated] [datetime] NOT NULL)
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 06 Dec 16
-- Description:	Insert Task approval.
-- =============================================
CREATE PROCEDURE [dbo].[InsertTaskApproval]
	@TaskId bigint,
	@EstimatedHours varchar(5),
	@Description text,
	@UserId int,
	@IsInstallUser bit
AS
BEGIN

	INSERT INTO [dbo].[tblTaskApprovals]
           ([TaskId]
           ,[EstimatedHours]
           ,[Description]
           ,[UserId]
           ,[IsInstallUser]
           ,[DateCreated]
           ,[DateUpdated])
     VALUES
           (@TaskId
           ,@EstimatedHours
           ,@Description
           ,@UserId
           ,@IsInstallUser
           ,GETDATE()
           ,GETDATE())

END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 06 Dec 16
-- Description:	Update Task approval.
-- =============================================
CREATE PROCEDURE [dbo].[UpdateTaskApproval]
	@Id		bigint,
	@TaskId bigint,
	@EstimatedHours VARCHAR(5),
	@Description text,
	@UserId int,
	@IsInstallUser bit
AS
BEGIN

	UPDATE [dbo].[tblTaskApprovals]
    SET
	    [TaskId] = @TaskId
       ,[EstimatedHours] = @EstimatedHours
       ,[Description] = @Description
       ,[UserId] = @UserId
       ,[IsInstallUser] = @IsInstallUser
       ,[DateUpdated] = GETDATE()
     WHERE
		Id = @Id

END
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[UDF_GetIsAdminUser]
(
	@Designation VARCHAR(50)
)
RETURNS BIT
AS
BEGIN
	declare @IsAdmin BIT

	SELECT 
		@IsAdmin = CASE UPPER(@Designation)
			WHEN 'ADMIN' THEN 1
			WHEN 'OFFICE MANAGER' THEN 1
			WHEN 'SALES MANAGER' THEN 1
			WHEN 'ITLEAD' THEN 1
			WHEN 'FOREMAN' THEN 1
			ELSE 0 
		END

	RETURN @IsAdmin
END
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[UDF_GetIsAdminOrITLeadUser]
(
	@Designation VARCHAR(50)
)
RETURNS BIT
AS
BEGIN
	declare @IsAdmin BIT

	SELECT 
		@IsAdmin = CASE UPPER(@Designation)
			WHEN 'ADMIN' THEN 1
			WHEN 'ITLEAD' THEN 1
			ELSE 0 
		END

	RETURN @IsAdmin
END
GO




SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[TaskApprovalsView] as

	SELECT
			s.*,
			
			u.Username AS Username,
			u.FirstName AS UserFirstName,
			u.LastName AS UserLastName,
			u.Email AS UserEmail,
			u.Designation AS UserDesignation,
			[dbo].[UDF_GetIsAdminOrITLeadUser](u.Designation) AS IsAdminOrITLead

	FROM tblTaskApprovals s
			OUTER APPLY
			(
				SELECT TOP 1 iu.Id,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email, iu.Designation
				FROM tblInstallUsers iu
				WHERE iu.Id = s.UserId AND s.IsInstallUser = 1
			
				UNION

				SELECT TOP 1 u.Id,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email, u.Designation
				FROM tblUsers u
				WHERE u.Id = s.UserId AND s.IsInstallUser = 0
			) AS u

GO



/****** Object:  StoredProcedure [dbo].[usp_GetSubTasks]    Script Date: 06-Dec-16 11:30:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all sub tasks of a task.
-- =============================================
-- usp_GetSubTasks 115, 1, 'Description DESC'
ALTER PROCEDURE [dbo].[usp_GetSubTasks] 
(
	@TaskId INT,
	@Admin BIT,
	@SortExpression	VARCHAR(250) = 'CreatedOn DESC',
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	;WITH 
	
	Tasklist AS
	(	
		SELECT
			Tasks.*,
			Row_number() OVER
			(
				ORDER BY
					CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
					CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
					CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
					CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
					CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
					CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
					CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
					CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
					CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
					CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
					CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,
					CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,
					CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
					CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC
			) AS RowNo_Order
		FROM
			(
				SELECT 
					Tasks.*,
					CASE Tasks.[Status]
						WHEN @AssignedStatus THEN 1
						WHEN @RequestedStatus THEN 1

						WHEN @InProgressStatus THEN 2
						WHEN @PendingStatus THEN 2
						WHEN @ReOpenedStatus THEN 2

						WHEN @OpenStatus THEN 
							CASE 
								WHEN ISNULL([TaskPriority],'') <> '' THEN 3
								ELSE 4
							END

						WHEN @SpecsInProgressStatus THEN 4

						WHEN @ClosedStatus THEN 5

						WHEN @DeletedStatus THEN 6

						ELSE 7

					END AS StatusOrder,
					TaskApprovals.Id AS TaskApprovalId,
					TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,
					TaskApprovals.Description AS TaskApprovalDescription,
					TaskApprovals.UserId AS TaskApprovalUserId,
					TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser
				FROM 
					[TaskListView] Tasks 
						LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId 
																	AND TaskApprovals.IsAdminOrITLead = @Admin
				WHERE
					Tasks.ParentTaskId = @TaskId
			) Tasks
	)
	
	-- get records
	SELECT * 
	FROM Tasklist 

END

GO


/****** Object:  StoredProcedure [dbo].[usp_GetSubTasks]    Script Date: 06-Dec-16 11:30:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all sub tasks of a task.
-- =============================================
-- usp_GetSubTasks 115, 1, 'Description DESC'
ALTER PROCEDURE [dbo].[usp_GetSubTasks] 
(
	@TaskId INT,
	@Admin BIT,
	@SortExpression	VARCHAR(250) = 'CreatedOn DESC',
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	;WITH 
	
	Tasklist AS
	(	
		SELECT
			Tasks.*,
			(SELECT EstimatedHours 
				FROM [TaskApprovalsView] TaskApprovals 
				WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,
			(SELECT EstimatedHours 
				FROM [TaskApprovalsView] TaskApprovals 
				WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours,
			Row_number() OVER
			(
				ORDER BY
					CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
					CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
					CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
					CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
					CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
					CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
					CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
					CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
					CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
					CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
					CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,
					CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,
					CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
					CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC
			) AS RowNo_Order
		FROM
			(
				SELECT 
					Tasks.*,
					CASE Tasks.[Status]
						WHEN @AssignedStatus THEN 1
						WHEN @RequestedStatus THEN 1

						WHEN @InProgressStatus THEN 2
						WHEN @PendingStatus THEN 2
						WHEN @ReOpenedStatus THEN 2

						WHEN @OpenStatus THEN 
							CASE 
								WHEN ISNULL([TaskPriority],'') <> '' THEN 3
								ELSE 4
							END

						WHEN @SpecsInProgressStatus THEN 4

						WHEN @ClosedStatus THEN 5

						WHEN @DeletedStatus THEN 6

						ELSE 7

					END AS StatusOrder,
					TaskApprovals.Id AS TaskApprovalId,
					TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,
					TaskApprovals.Description AS TaskApprovalDescription,
					TaskApprovals.UserId AS TaskApprovalUserId,
					TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser
				FROM 
					[TaskListView] Tasks 
						LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
				WHERE
					Tasks.ParentTaskId = @TaskId
			) Tasks
	)
	
	-- get records
	SELECT * 
	FROM Tasklist 

END

GO

ALTER TABLE tblTask
ADD Url VARCHAR(250) NULL
GO


/****** Object:  StoredProcedure [dbo].[SP_SaveOrDeleteTask]    Script Date: 07-Dec-16 11:34:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 14 Nov 16
-- Description:	Inserts, Updates or Deletes a task.
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
	 @TaskPriority tinyint = null,
	 @IsTechTask bit = NULL,
	 @DeletedStatus	TINYINT = 9,
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
					OtherUserStatus
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
					0
				)  
  
		SET @Result=SCOPE_IDENTITY ()  
  
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
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[TaskListView] 
AS
SELECT 
	Tasks.*,
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
		(SELECT  CAST(', ' + u.FristName as VARCHAR) AS Name
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
		(SELECT  CAST(', ' + tuf.[Attachment] + '@' + tuf.[AttachmentOriginal] as VARCHAR(max)) AS attachment
		FROM dbo.tblTaskUserFiles tuf
		WHERE tuf.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskUserFiles
FROM          
	tblTask AS Tasks 

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
	SELECT Title,Url, [Description], [Status], DueDate,Tasks.[Hours], Tasks.CreatedOn, Tasks.TaskPriority,
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

--=================================================================================================================================================================================================

-- Published on live 12072016 

--=================================================================================================================================================================================================
INSERT INTO [dbo].[tbl_Designation]
           ([DesignationName]
           ,[IsActive]
           ,[DepartmentID])
     VALUES
           ('Admin-Sales'
           ,1
           ,1)


INSERT INTO [dbo].[tbl_Designation]
           ([DesignationName]
           ,[IsActive]
           ,[DepartmentID])
     VALUES
           ('Admin Recruiter'
           ,1
           ,1)

GO

/****** Object:  UserDefinedFunction [dbo].[UDF_GetIsAdminOrITLeadUser]    Script Date: 15-Dec-16 12:33:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[UDF_GetIsAdminOrITLeadUser]
(
	@Designation VARCHAR(50)
)
RETURNS BIT
AS
BEGIN
	declare @IsAdmin BIT

	SELECT 
		@IsAdmin = CASE UPPER(@Designation)
			WHEN 'ADMIN' THEN 1
			WHEN 'ITLEAD' THEN 1
			WHEN 'ADMIN-SALES' THEN 1
			WHEN 'ADMIN RECRUITER' THEN 1
			ELSE 0 
		END

	RETURN @IsAdmin
END
GO

/****** Object:  UserDefinedFunction [dbo].[UDF_GetIsAdminUser]    Script Date: 15-Dec-16 12:34:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[UDF_GetIsAdminUser]
(
	@Designation VARCHAR(50)
)
RETURNS BIT
AS
BEGIN
	declare @IsAdmin BIT

	SELECT 
		@IsAdmin = CASE UPPER(@Designation)
			WHEN 'ADMIN' THEN 1
			WHEN 'OFFICE MANAGER' THEN 1
			WHEN 'SALES MANAGER' THEN 1
			WHEN 'ITLEAD' THEN 1
			WHEN 'FOREMAN' THEN 1
			WHEN 'ADMIN-SALES' THEN 1
			WHEN 'ADMIN RECRUITER' THEN 1
			ELSE 0 
		END

	RETURN @IsAdmin
END
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
	SELECT Title,Url, [Description], [Status], DueDate,Tasks.[Hours], Tasks.CreatedOn, Tasks.TaskPriority,
		   Tasks.InstallId, Tasks.CreatedBy, @AssigningUser AS AssigningManager ,Tasks.TaskType, Tasks.IsTechTask,
		   STUFF
			(
				(SELECT  CAST(', ' + ttuf.[Attachment] + '@' + ttuf.[AttachmentOriginal]  + '@' + CAST( ttuf.[AttachedFileDate] AS VARCHAR(100)) + '@' + (CASE WHEN ctuser.Id IS NULL THEN 'N.A.'ELSE ctuser.FristName + ' ' + ctuser.LastName END) as VARCHAR(max)) AS attachment
				FROM dbo.tblTaskUserFiles ttuf 
				INNER JOIN tblInstallUsers AS ctuser ON ttuf.UserId = ctuser.Id
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
				(SELECT  CAST(', ' + ttuf.[Attachment] + '@' + ttuf.[AttachmentOriginal] + '@' + CAST( ttuf.[AttachedFileDate] AS VARCHAR(100))+ '@'  + (CASE WHEN ctuser.Id IS NULL THEN 'N.A.'ELSE ctuser.FristName + ' ' + ctuser.LastName END) as VARCHAR(max)) AS attachment
				FROM dbo.tblTaskUserFiles ttuf
				INNER JOIN tblInstallUsers AS ctuser ON ttuf.UserId = ctuser.Id
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

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE VIEW [dbo].[TaskListView] 
AS
SELECT 
	Tasks.*,
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
		(SELECT  CAST(', ' + tuf.[Attachment] + '@' + tuf.[AttachmentOriginal]  + '@' + CAST( tuf.[AttachedFileDate] AS VARCHAR(100)) + '@' + (CASE WHEN ctuser.Id IS NULL THEN 'N.A.'ELSE ctuser.FristName + ' ' + ctuser.LastName END) as VARCHAR(max)) AS attachment
		FROM dbo.tblTaskUserFiles tuf  INNER JOIN tblInstallUsers AS ctuser ON tuf.UserId = ctuser.Id
		WHERE tuf.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskUserFiles
FROM          
	tblTask AS Tasks 

GO


/****** Object:  StoredProcedure [dbo].[SP_SaveOrDeleteTaskUserFiles]    Script Date: 19-Dec-16 9:25:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SaveOrDeleteTaskUserFiles]  
(   
	@Mode tinyint, -- 0:Insert, 1: Update 2: Delete  
	@TaskUpDateId bigint= NULL,  
	@TaskId bigint,  
	@FileDestination TINYINT = NULL,
	@UserId int,  
	@Attachment varchar(MAX),
	@OriginalFileName varchar(MAX),
	@UserType BIT,
    @FileType varchar(5)
) 
AS  
BEGIN  
  
	IF @Mode=0 
	BEGIN  

		/* Generate an image name starts */
		DECLARE @NextId INT = 1
		DECLARE @ParentTaskId BIGINT = NULL

		SELECT @ParentTaskId = t.ParentTaskId
		FROM tblTask t
		WHERE t.TaskId = @TaskId

		SELECT @NextId = (COUNT(*) + 1)
		FROM tblTaskUserFiles t
		WHERE 
			  t.TaskId = ISNULL(@ParentTaskId, @TaskId) OR
			  t.TaskId IN (SELECT TaskId FROM tblTask WHERE ParentTaskId = ISNULL(@ParentTaskId, @TaskId))

		SELECT @OriginalFileName = 
						ISNULL(
								CAST(t.InstallId AS VARCHAR), 
								'TASK' + CAST(t.TaskId AS VARCHAR)
							  ) 
						+ '-IMG'
						+ RIGHT('000'+CAST(@NextId AS VARCHAR),3)
						+ '.' + REVERSE(SUBSTRING(REVERSE(@OriginalFileName),0,CHARINDEX('.',REVERSE(@OriginalFileName))))
		FROM tblTask t
		WHERE t.TaskId = ISNULL(@ParentTaskId, @TaskId)

		/* Generate an image name ends */
		
		INSERT INTO tblTaskUserFiles (TaskId,UserId,Attachment,TaskUpdateID,IsDeleted, AttachmentOriginal, UserType,FileDestination, FileType, AttachedFileDate)   
		VALUES(@TaskId,@UserId,@Attachment,@TaskUpDateId,0, @OriginalFileName, @UserType,@FileDestination, @FileType ,GETDATE())  
	END  
	ELSE IF @Mode=1  
	BEGIN  
		UPDATE tblTaskUserFiles  
		SET 
			Attachment=@Attachment  
		WHERE TaskUpdateID = @TaskUpDateId
	END  
	ELSE IF @Mode=2 --DELETE  
	BEGIN  
		UPDATE tblTaskUserFiles  
		SET 
			IsDeleted =1  
		WHERE TaskUpdateID = @TaskUpDateId 
	END  
  
END  
GO


--=======================================================================================================================================================================================================

-- Published on Live 19 Dec 2016

--=======================================================================================================================================================================================================

/****** Object:  StoredProcedure [dbo].[SP_SaveOrDeleteTaskUserFiles]    Script Date: 20-Dec-16 9:46:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SaveOrDeleteTaskUserFiles]  
(   
	@Mode tinyint, -- 0:Insert, 1: Update 2: Delete  
	@TaskUpDateId bigint= NULL,  
	@TaskId bigint,  
	@FileDestination TINYINT = NULL,
	@UserId int,  
	@Attachment varchar(MAX),
	@OriginalFileName varchar(MAX),
	@UserType BIT,
    @FileType varchar(5)
) 
AS  
BEGIN  
  
	IF @Mode=0 
	BEGIN  

		/* Generate an image name starts */

		DECLARE @ParentTaskId BIGINT = NULL
		DECLARE @NextId VARCHAR(5)
		DECLARE @Initial VARCHAR(5) = '-FILE'
		DECLARE @Extension VARCHAR(5)

		SELECT @ParentTaskId = t.ParentTaskId
		FROM tblTask t
		WHERE t.TaskId = @TaskId

		SELECT @NextId = RIGHT('000'+CAST((COUNT(*) + 1) AS VARCHAR),3)
		FROM tblTaskUserFiles t
		WHERE 
			  t.TaskId = ISNULL(@ParentTaskId, @TaskId) OR
			  t.TaskId IN (SELECT TaskId FROM tblTask WHERE ParentTaskId = ISNULL(@ParentTaskId, @TaskId))

		SET @Extension = '.' + REVERSE(SUBSTRING(REVERSE(@OriginalFileName),0,CHARINDEX('.',REVERSE(@OriginalFileName))))

		IF @Extension = '.png' OR
			@Extension = '.jpg' OR
			@Extension = '.jpeg'
		BEGIN
			SET @Initial = '-IMG'
		END

		SELECT @OriginalFileName = 
						ISNULL(
								CAST(t.InstallId AS VARCHAR), 
								'TASK' + CAST(t.TaskId AS VARCHAR)
							  ) 
						+ @Initial
						+ @NextId
						+ @Extension
		FROM tblTask t
		WHERE t.TaskId = ISNULL(@ParentTaskId, @TaskId)

		/* Generate an image name ends */
		
		INSERT INTO tblTaskUserFiles (TaskId,UserId,Attachment,TaskUpdateID,IsDeleted, AttachmentOriginal, UserType,FileDestination, FileType, AttachedFileDate)   
		VALUES(@TaskId,@UserId,@Attachment,@TaskUpDateId,0, @OriginalFileName, @UserType,@FileDestination, @FileType ,GETDATE())  
	END  
	ELSE IF @Mode=1  
	BEGIN  
		UPDATE tblTaskUserFiles  
		SET 
			Attachment=@Attachment  
		WHERE TaskUpdateID = @TaskUpDateId
	END  
	ELSE IF @Mode=2 --DELETE  
	BEGIN  
		UPDATE tblTaskUserFiles  
		SET 
			IsDeleted =1  
		WHERE TaskUpdateID = @TaskUpDateId 
	END  
  
END  
GO


UPDATE tblTaskUserFiles
SET 
[AttachedFileDate] = UpdatedOn
WHERE [AttachedFileDate] IS NULL


/****** Object:  View [dbo].[TaskListView]    Script Date: 20-Dec-16 8:26:36 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[TaskListView] 
AS
SELECT 
	Tasks.*,
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
				SELECT TOP 1 iu.Id,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
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
GO

--=======================================================================================================================================================================================================

-- Published on Live 21 Dec 2016

--=======================================================================================================================================================================================================


ALTER table tblTask
ADD IsUiRequested BIT DEFAULT 0
GO

Update tblTask
Set
	IsUiRequested = 0


/****** Object:  StoredProcedure [dbo].[UpdateTaskUiRequestedById]    Script Date: 22-Dec-16 10:48:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 14 Nov 16
-- Description:	Updates ui requested status of sub Task by Id.
-- =============================================
CREATE PROCEDURE [dbo].[UpdateTaskUiRequestedById]
	@TaskId		BIGINT,
	@IsUiRequested BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE tblTask
	SET
		IsUiRequested = @IsUiRequested
	WHERE TaskId = @TaskId
END
GO



/****** Object:  View [dbo].[TaskListView]    Script Date: 22-Dec-16 9:28:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[TaskListView] 
AS
SELECT 
	Tasks.*,
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


/****** Object:  StoredProcedure [dbo].[usp_GetSubTasks]    Script Date: 23-Dec-16 8:57:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all sub tasks of a task.
-- =============================================
-- usp_GetSubTasks 115, 1, 'Description DESC'
ALTER PROCEDURE [dbo].[usp_GetSubTasks] 
(
	@TaskId INT,
	@Admin BIT,
	@SortExpression	VARCHAR(250) = 'CreatedOn DESC',
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	;WITH 
	
	Tasklist AS
	(	
		SELECT
			Tasks.*,
			(SELECT EstimatedHours 
				FROM [TaskApprovalsView] TaskApprovals 
				WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,
			(SELECT EstimatedHours 
				FROM [TaskApprovalsView] TaskApprovals 
				WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours,
			Row_number() OVER
			(
				ORDER BY
					CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
					CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
					CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
					CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
					CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
					CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
					CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
					CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
					CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
					CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
					CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,
					CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,
					CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
					CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC
			) AS RowNo_Order
		FROM
			(
				SELECT 
					Tasks.*,
					CASE Tasks.[Status]
						WHEN @AssignedStatus THEN 1
						WHEN @RequestedStatus THEN 1

						WHEN @InProgressStatus THEN 2
						WHEN @PendingStatus THEN 2
						WHEN @ReOpenedStatus THEN 2

						WHEN @OpenStatus THEN 
							CASE 
								WHEN ISNULL([TaskPriority],'') <> '' THEN 3
								ELSE 4
							END

						WHEN @SpecsInProgressStatus THEN 4

						WHEN @ClosedStatus THEN 5

						WHEN @DeletedStatus THEN 6

						ELSE 7

					END AS StatusOrder,
					TaskApprovals.Id AS TaskApprovalId,
					TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,
					TaskApprovals.Description AS TaskApprovalDescription,
					TaskApprovals.UserId AS TaskApprovalUserId,
					TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser
				FROM 
					[TaskListView] Tasks 
						LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
				WHERE
					Tasks.ParentTaskId = @TaskId
			) Tasks
	)
	
	-- get records
	SELECT * 
	FROM Tasklist 
	ORDER BY RowNo_Order

END
GO

