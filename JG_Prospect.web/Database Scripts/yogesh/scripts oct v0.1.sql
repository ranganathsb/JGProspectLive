USE [JGBS]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 07/15/2016
-- Description:	Update task priority
-- =============================================
CREATE PROCEDURE [dbo].[usp_UpdateTaskPriority] 
(	
	@TaskId int , 	
	@TaskPriority tinyint
)
AS
BEGIN
	
	UPDATE tblTask
	SET TaskPriority = @TaskPriority
	WHERE TaskId = @TaskId

END
GO

 


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
	@PageIndex		INT = 0,
	@PageSize		INT = 10
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @PageIndex = @PageIndex + 1

	;WITH Tasklist
	AS
	(	
		SELECT 
			--TaskUserMatch.IsMatch AS TaskUserMatch,
			--TaskUserRequestsMatch.IsMatch AS TaskUserRequestsMatch,
			--TaskDesignationMatch.IsMatch AS TaskDesignationMatch,
			Tasks.TaskId, 
			Tasks.Title, 
			Tasks.InstallId, 
			Tasks.[Status], 
			Tasks.[CreatedOn],
			Tasks.[DueDate], 
			Tasks.IsDeleted,
			Tasks.CreatedBy,
			Tasks.TaskPriority,
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
				(SELECT  CAST(', ' + CAST(tu.UserId AS VARCHAR) + ':' + u.FristName as VARCHAR) AS Name
				FROM tblTaskAssignmentRequests tu
					INNER JOIN tblInstallUsers u ON tu.UserId = u.Id
				WHERE tu.TaskId = Tasks.TaskId
				FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
				,1
				,2
				,' '
			) AS TaskAssignmentRequestUsers
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
			--AND
			--1 = CASE 
			--	WHEN @SearchTerm IS NULL THEN 
			--		CASE
			--			WHEN TaskDesignationMatch.IsMatch = 1 THEN 1
			--			ELSE 0
			--		END
			--	ELSE
			--		CASE
			--			WHEN Tasks.[InstallId] LIKE '%' + @SearchTerm + '%' THEN 1
			--			WHEN Tasks.[Title] LIKE '%' + @SearchTerm + '%' THEN 1
			--			WHEN TaskDesignationMatch.IsMatch = 1 THEN 1
			--			ELSE 0
			--		END
			--END
			AND
			Tasks.[Status] = ISNULL(@Status,Tasks.[Status]) 
			AND
			CONVERT(VARCHAR,Tasks.[CreatedOn],101)  >= ISNULL(@CreatedFrom,CONVERT(VARCHAR,Tasks.[CreatedOn],101)) AND
			CONVERT(VARCHAR,Tasks.[CreatedOn],101)  <= ISNULL(@CreatedTo,CONVERT(VARCHAR,Tasks.[CreatedOn],101))
	),

FinalData AS( 
	SELECT * ,
			Row_number() OVER
			(
				ORDER BY
					CASE WHEN @SortExpression = 'UserID DESC' THEN Tasklist.TaskAssignedUsers END DESC,
					CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasklist.CreatedOn END DESC,
					CASE WHEN @SortExpression = 'Status ASC' THEN Tasklist.[Status] END ASC
			) AS RowNo
	FROM Tasklist )
	
	SELECT * FROM FinalData 
	WHERE  
		RowNo BETWEEN (@PageIndex - 1) * @PageSize + 1 AND 
		@PageIndex * @PageSize

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
		--AND
		--1 = CASE 
		--		WHEN @SearchTerm IS NULL THEN 
		--			CASE
		--				WHEN TaskDesignationMatch.IsMatch = 1 THEN 1
		--				ELSE 0
		--			END
		--		ELSE
		--			CASE
		--				WHEN Tasks.[InstallId] LIKE '%' + @SearchTerm + '%' THEN 1
		--				WHEN Tasks.[Title] LIKE '%' + @SearchTerm + '%' THEN 1
		--				WHEN TaskDesignationMatch.IsMatch = 1 THEN 1
		--				ELSE 0
		--			END
		--	END 
		AND
		Tasks.[Status] = ISNULL(@Status,Tasks.[Status]) 
		AND
		CONVERT(VARCHAR,Tasks.[CreatedOn],101)  >= ISNULL(@CreatedFrom,CONVERT(VARCHAR,Tasks.[CreatedOn],101)) AND
		CONVERT(VARCHAR,Tasks.[CreatedOn],101)  <= ISNULL(@CreatedTo,CONVERT(VARCHAR,Tasks.[CreatedOn],101))

END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 13 Sep 16
-- Update date: 06 Oct 16
-- Description:	Get last checked-in Task specification from history.
-- =============================================
ALTER PROCEDURE [dbo].[GetLatestTaskWorkSpecification]
	@TaskId int,
	@Status Bit = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- freezed copy (copy with given status).
	SELECT TOP 1
			
			s.Id AS Id,
			sv.[Status] AS [Status],
			sv.Content,
			sv.IsInstallUser,
			sv.DateCreated,
			LastUser.Id AS LastUserId,
			LastUser.Username AS LastUsername,
			LastUser.FirstName AS LastUserFirstName,
			LastUser.LastName AS LastUserLastName,
			LastUser.Email AS LastUserEmail

	FROM tblTaskWorkSpecification s
			INNER JOIN tblTaskWorkSpecificationVersions sv ON s.Id= sv.TaskWorkSpecificationId
			OUTER APPLY
			(
				SELECT TOP 1 iu.Id,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
				FROM tblInstallUsers iu
				WHERE iu.Id = sv.UserId AND sv.IsInstallUser = 1
			
				UNION

				SELECT TOP 1 u.Id,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
				FROM tblUsers u
				WHERE u.Id = sv.UserId AND sv.IsInstallUser = 0
			) AS LastUser
	WHERE s.TaskId = @TaskId AND sv.[Status] = @Status
	ORDER BY sv.DateCreated DESC

	-- working copy (last working copy).
    SELECT TOP 1
			
			s.Id AS Id,
			sv.[Status] AS [Status],
			sv.Content,
			sv.IsInstallUser,
			sv.DateCreated,
			CurrentUser.Id AS CurrentUserId,
			CurrentUser.Username AS CurrentUsername,
			CurrentUser.FirstName AS CurrentFirstName,
			CurrentUser.LastName AS CurrentLastName,
			CurrentUser.Email AS CurrentEmail

	FROM tblTaskWorkSpecification s
			INNER JOIN tblTaskWorkSpecificationVersions sv ON s.Id= sv.TaskWorkSpecificationId
			OUTER APPLY
			(
				SELECT TOP 1 iu.Id,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
				FROM tblInstallUsers iu
				WHERE iu.Id = sv.UserId AND sv.IsInstallUser = 1
			
				UNION

				SELECT TOP 1 u.Id,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
				FROM tblUsers u
				WHERE u.Id = sv.UserId AND sv.IsInstallUser = 0
			) AS CurrentUser
	WHERE s.TaskId = @TaskId
	ORDER BY sv.DateCreated DESC

END
GO

/*------------------------------------------------------------------------------------------------------*/
-- 7 OCT
/*------------------------------------------------------------------------------------------------------*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 07 Oct 16
-- Description:	Get all Task specifications related to a task, 
--				with optional status filter.
-- =============================================
-- EXEC GetTaskWorkSpecifications 115, 0
CREATE PROCEDURE [dbo].[GetTaskWorkSpecifications]
	@TaskId int,
	@Status bit = NULL,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @StartIndex INT  = 0

	IF @PageIndex IS NULL
	BEGIN
		SET @PageIndex = 0
	END

	IF @PageSize IS NULL
	BEGIN
		SET @PageSize = 0
	END

	SET @StartIndex = (@PageIndex * @PageSize) + 1

	;WITH TaskWorkSpecifications
	AS
	(
		-- working copies (last working copies for each specification).
		SELECT
				s.Id AS Id,
				sv.Id AS VersionId,
				sv.[Status] AS [Status],
				sv.Content AS Content,
				sv.IsInstallUser AS IsInstallUser,
				sv.DateCreated AS DateCreated,
				CurrentUser.Id AS CurrentUserId,
				CurrentUser.Username AS CurrentUsername,
				CurrentUser.FirstName AS CurrentFirstName,
				CurrentUser.LastName AS CurrentLastName,
				CurrentUser.Email AS CurrentEmail,
				ROW_NUMBER() OVER(ORDER BY s.ID ASC) AS RowNumber

		FROM tblTaskWorkSpecification s
				OUTER APPLY
				(
					SELECT TOP 1 *, ROW_NUMBER() OVER(ORDER BY ID DESC) AS RowNo
					FROM tblTaskWorkSpecificationVersions
					WHERE TaskWorkSpecificationId = s.Id
				) AS sv 
				OUTER APPLY
				(
					SELECT TOP 1 iu.Id,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
					FROM tblInstallUsers iu
					WHERE iu.Id = sv.UserId AND sv.IsInstallUser = 1
			
					UNION

					SELECT TOP 1 u.Id,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
					FROM tblUsers u
					WHERE u.Id = sv.UserId AND sv.IsInstallUser = 0
				) AS CurrentUser
		WHERE s.TaskId = @TaskId AND sv.[Status] = ISNULL(@Status,sv.[Status])
	)

			
	-- get records
	SELECT *
	FROM TaskWorkSpecifications
	WHERE 
		RowNumber >= @StartIndex AND 
		(
			@PageSize = 0 OR 
			RowNumber < (@StartIndex + @PageSize)
		)

	-- get record count
	SELECT COUNT(*) AS TotalRecordCount
	FROM tblTaskWorkSpecification s
				OUTER APPLY
				(
					SELECT TOP 1 *, ROW_NUMBER() OVER(ORDER BY ID DESC) AS RowNo
					FROM tblTaskWorkSpecificationVersions
					WHERE TaskWorkSpecificationId = s.Id
				) AS sv 
	WHERE s.TaskId = @TaskId AND sv.[Status] = ISNULL(@Status,sv.[Status])

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 13 Sep 16
-- Description:	Get last checked-in Task specification from history.
-- =============================================
ALTER PROCEDURE [dbo].[GetLatestTaskWorkSpecification]
	@Id		INT,
	@TaskId INT,
	@Status BIT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- freezed copy (copy with given status).
	SELECT TOP 1
			
			s.Id AS Id,
			sv.[Status] AS [Status],
			sv.Content,
			sv.IsInstallUser,
			sv.DateCreated,
			LastUser.Id AS LastUserId,
			LastUser.Username AS LastUsername,
			LastUser.FirstName AS LastUserFirstName,
			LastUser.LastName AS LastUserLastName,
			LastUser.Email AS LastUserEmail

	FROM tblTaskWorkSpecification s
			INNER JOIN tblTaskWorkSpecificationVersions sv ON s.Id= sv.TaskWorkSpecificationId
			OUTER APPLY
			(
				SELECT TOP 1 iu.Id,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
				FROM tblInstallUsers iu
				WHERE iu.Id = sv.UserId AND sv.IsInstallUser = 1
			
				UNION

				SELECT TOP 1 u.Id,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
				FROM tblUsers u
				WHERE u.Id = sv.UserId AND sv.IsInstallUser = 0
			) AS LastUser

	WHERE 
			s.Id = @Id AND 
			s.TaskId = @TaskId AND 
			sv.[Status] = @Status

	ORDER BY sv.DateCreated DESC

	-- working copy (last working copy).
    SELECT TOP 2
			
			s.Id AS Id,
			sv.[Status] AS [Status],
			sv.Content,
			sv.IsInstallUser,
			sv.DateCreated,
			CurrentUser.Id AS CurrentUserId,
			CurrentUser.Username AS CurrentUsername,
			CurrentUser.FirstName AS CurrentFirstName,
			CurrentUser.LastName AS CurrentLastName,
			CurrentUser.Email AS CurrentEmail

	FROM tblTaskWorkSpecification s
			INNER JOIN tblTaskWorkSpecificationVersions sv ON s.Id= sv.TaskWorkSpecificationId
			OUTER APPLY
			(
				SELECT TOP 1 iu.Id,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
				FROM tblInstallUsers iu
				WHERE iu.Id = sv.UserId AND sv.IsInstallUser = 1
			
				UNION

				SELECT TOP 1 u.Id,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
				FROM tblUsers u
				WHERE u.Id = sv.UserId AND sv.IsInstallUser = 0
			) AS CurrentUser
	
	WHERE 
			s.Id = @Id AND 
			s.TaskId = @TaskId 

	ORDER BY sv.DateCreated DESC

END
GO


/*------------------------------------------------------------------------------------------------------*/
-- 8 OCT
/*------------------------------------------------------------------------------------------------------*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 13 Sep 16
-- Description:	Get last checked-in Task specification from history.
-- =============================================
ALTER PROCEDURE [dbo].[GetLatestTaskWorkSpecification]
	@Id		INT,
	@TaskId INT,
	@Status BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- last copy with given status.
	SELECT TOP 1
			
			s.Id AS Id,
			sv.[Status] AS [Status],
			sv.Content,
			sv.IsInstallUser,
			sv.DateCreated,
			LastUser.Id AS LastUserId,
			LastUser.Username AS LastUsername,
			LastUser.FirstName AS LastUserFirstName,
			LastUser.LastName AS LastUserLastName,
			LastUser.Email AS LastUserEmail

	FROM tblTaskWorkSpecification s
			INNER JOIN tblTaskWorkSpecificationVersions sv ON s.Id= sv.TaskWorkSpecificationId
			OUTER APPLY
			(
				SELECT TOP 1 iu.Id,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
				FROM tblInstallUsers iu
				WHERE iu.Id = sv.UserId AND sv.IsInstallUser = 1
			
				UNION

				SELECT TOP 1 u.Id,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
				FROM tblUsers u
				WHERE u.Id = sv.UserId AND sv.IsInstallUser = 0
			) AS LastUser

	WHERE 
			s.Id = @Id AND 
			s.TaskId = @TaskId AND 
			sv.[Status] = @Status

	ORDER BY sv.DateCreated DESC

	-- last 2 working copies with any status.
    SELECT TOP 2
			
			s.Id AS Id,
			sv.[Status] AS [Status],
			sv.Content,
			sv.IsInstallUser,
			sv.DateCreated,
			CurrentUser.Id AS CurrentUserId,
			CurrentUser.Username AS CurrentUsername,
			CurrentUser.FirstName AS CurrentFirstName,
			CurrentUser.LastName AS CurrentLastName,
			CurrentUser.Email AS CurrentEmail

	FROM tblTaskWorkSpecification s
			INNER JOIN tblTaskWorkSpecificationVersions sv ON s.Id= sv.TaskWorkSpecificationId
			OUTER APPLY
			(
				SELECT TOP 1 iu.Id,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
				FROM tblInstallUsers iu
				WHERE iu.Id = sv.UserId AND sv.IsInstallUser = 1
			
				UNION

				SELECT TOP 1 u.Id,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
				FROM tblUsers u
				WHERE u.Id = sv.UserId AND sv.IsInstallUser = 0
			) AS CurrentUser
	
	WHERE 
			s.Id = @Id AND 
			s.TaskId = @TaskId 

	ORDER BY sv.DateCreated DESC

END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 07 Oct 16
-- Description:	Get all Task specifications related to a task, 
--				with optional status filter.
-- =============================================
-- EXEC GetTaskWorkSpecifications 115, 0, 1
ALTER PROCEDURE [dbo].[GetTaskWorkSpecifications]
	@TaskId int,
	@Status bit,
	@Admin bit,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @StartIndex INT  = 0

	IF @PageIndex IS NULL
	BEGIN
		SET @PageIndex = 0
	END

	IF @PageSize IS NULL
	BEGIN
		SET @PageSize = 0
	END

	SET @StartIndex = (@PageIndex * @PageSize) + 1

	;WITH TaskWorkSpecifications
	AS
	(
		-- working copies (last working copies for each specification).
		SELECT
				s.Id AS Id,
				ISNULL(sv.Id,svDefault.Id) AS VersionId,
				ISNULL(sv.[Status],svDefault.[Status]) AS [Status],
				ISNULL(sv.Content,svDefault.Content) AS Content,
				ISNULL(sv.IsInstallUser,svDefault.IsInstallUser) AS IsInstallUser,
				ISNULL(sv.DateCreated,svDefault.DateCreated) AS DateCreated,
				CurrentUser.Id AS CurrentUserId,
				CurrentUser.Username AS CurrentUsername,
				CurrentUser.FirstName AS CurrentFirstName,
				CurrentUser.LastName AS CurrentLastName,
				CurrentUser.Email AS CurrentEmail,
				ROW_NUMBER() OVER(ORDER BY s.ID ASC) AS RowNumber

		FROM tblTaskWorkSpecification s
				OUTER APPLY
				(
					SELECT TOP 1 *, ROW_NUMBER() OVER(ORDER BY ID DESC) AS RowNo
					FROM tblTaskWorkSpecificationVersions
					WHERE TaskWorkSpecificationId = s.Id AND [Status] = ISNULL(@Status,[Status])
				) AS sv 
				OUTER APPLY
				(
					SELECT TOP 1 *, ROW_NUMBER() OVER(ORDER BY ID DESC) AS RowNo
					FROM tblTaskWorkSpecificationVersions
					WHERE TaskWorkSpecificationId = s.Id
				) AS svDefault
				OUTER APPLY
				(
					SELECT TOP 1 iu.Id,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
					FROM tblInstallUsers iu
					WHERE iu.Id = ISNULL(sv.UserId,svDefault.UserId) AND ISNULL(sv.IsInstallUser,svDefault.IsInstallUser) = 1
			
					UNION

					SELECT TOP 1 u.Id,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
					FROM tblUsers u
					WHERE u.Id = ISNULL(sv.UserId,svDefault.UserId) AND ISNULL(sv.IsInstallUser,svDefault.IsInstallUser) = 0
				) AS CurrentUser
		WHERE s.TaskId = @TaskId AND 
				(@Admin = 1 OR (@Admin = 0 AND sv.Id IS NOT NULL))
	)

			
	-- get records
	SELECT *
	FROM TaskWorkSpecifications
	WHERE 
		RowNumber >= @StartIndex AND 
		(
			@PageSize = 0 OR 
			RowNumber < (@StartIndex + @PageSize)
		)

	-- get record count
	SELECT COUNT(*) AS TotalRecordCount
	FROM tblTaskWorkSpecification s
				OUTER APPLY
				(
					SELECT TOP 1 *, ROW_NUMBER() OVER(ORDER BY ID DESC) AS RowNo
					FROM tblTaskWorkSpecificationVersions
					WHERE TaskWorkSpecificationId = s.Id
				) AS sv 
	WHERE s.TaskId = @TaskId AND sv.[Status] = ISNULL(@Status,sv.[Status])

END
GO


/*------------------------------------------------------------------------------------------------------*/
-- 10 OCT
/*------------------------------------------------------------------------------------------------------*/

ALTER TABLE tblTaskWorkSpecificationVersions
ADD FreezedByCount INT NULL
GO

UPDATE tblTaskWorkSpecificationVersions
SET
	FreezedByCount = 0
WHERE [Status] = 0

UPDATE tblTaskWorkSpecificationVersions
SET
	FreezedByCount = 1
WHERE [Status] = 1

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 13 Sep 16
-- Description:	Insert Task specification and also record history.
-- =============================================
ALTER PROCEDURE [dbo].[InsertTaskWorkSpecification]
	@TaskId int,
	@Content text,
	@UserId	int,
	@IsInstallUser bit,
	@Status Bit,
	@FreezedByCount INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO tblTaskWorkSpecification
		(
			TaskId
		)
	VALUES
		(
			@TaskId
		)
	
	DECLARE @TaskWorkSpecificationId INT = SCOPE_IDENTITY()

	INSERT INTO tblTaskWorkSpecificationVersions
		(
			TaskWorkSpecificationId,
			Content,
			UserId,
			IsInstallUser,
			[Status],
			FreezedByCount,
			DateCreated
		)
	VALUES
		(
			@TaskWorkSpecificationId,
			@Content,
			@UserId,
			@IsInstallUser,
			@Status,
			@FreezedByCount,
			GETDATE()
		)
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 13 Sep 16
-- Description:	Update Task specification and also record history.
-- =============================================
ALTER PROCEDURE [dbo].[UpdateTaskWorkSpecification]
	@TaskWorkSpecificationId int,
	@Content text,
	@UserId	int,
	@IsInstallUser bit,
	@Status Bit,
	@FreezedByCount INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO tblTaskWorkSpecificationVersions
		(
			TaskWorkSpecificationId,
			Content,
			UserId,
			IsInstallUser,
			[Status],
			FreezedByCount,
			DateCreated
		)
	VALUES
		(
			@TaskWorkSpecificationId,
			@Content,
			@UserId,
			@IsInstallUser,
			@Status,
			@FreezedByCount,
			GETDATE()
		)
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 13 Sep 16
-- Description:	Get last checked-in Task specification from history.
-- =============================================
ALTER PROCEDURE [dbo].[GetLatestTaskWorkSpecification]
	@Id		INT,
	@TaskId INT,
	@Status BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- last copy with given status.
	SELECT TOP 1
			
			s.Id AS Id,
			sv.Id As VersionId,
			sv.[Status] AS [Status],
			sv.Content,
			sv.IsInstallUser,
			sv.DateCreated,
			LastUser.Id AS LastUserId,
			LastUser.Username AS LastUsername,
			LastUser.FirstName AS LastUserFirstName,
			LastUser.LastName AS LastUserLastName,
			LastUser.Email AS LastUserEmail

	FROM tblTaskWorkSpecification s
			INNER JOIN tblTaskWorkSpecificationVersions sv ON s.Id= sv.TaskWorkSpecificationId
			OUTER APPLY
			(
				SELECT TOP 1 iu.Id,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
				FROM tblInstallUsers iu
				WHERE iu.Id = sv.UserId AND sv.IsInstallUser = 1
			
				UNION

				SELECT TOP 1 u.Id,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
				FROM tblUsers u
				WHERE u.Id = sv.UserId AND sv.IsInstallUser = 0
			) AS LastUser

	WHERE 
			s.Id = @Id AND 
			s.TaskId = @TaskId AND 
			sv.[Status] = @Status

	ORDER BY sv.DateCreated DESC

	-- last 2 working copies with any status.
    SELECT TOP 2
			
			s.Id AS Id,
			sv.Id As VersionId,
			sv.[Status] AS [Status],
			sv.Content,
			sv.IsInstallUser,
			sv.DateCreated,
			CurrentUser.Id AS CurrentUserId,
			CurrentUser.Username AS CurrentUsername,
			CurrentUser.FirstName AS CurrentFirstName,
			CurrentUser.LastName AS CurrentLastName,
			CurrentUser.Email AS CurrentEmail

	FROM tblTaskWorkSpecification s
			INNER JOIN tblTaskWorkSpecificationVersions sv ON s.Id= sv.TaskWorkSpecificationId
			OUTER APPLY
			(
				SELECT TOP 1 iu.Id,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
				FROM tblInstallUsers iu
				WHERE iu.Id = sv.UserId AND sv.IsInstallUser = 1
			
				UNION

				SELECT TOP 1 u.Id,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
				FROM tblUsers u
				WHERE u.Id = sv.UserId AND sv.IsInstallUser = 0
			) AS CurrentUser
	
	WHERE 
			s.Id = @Id AND 
			s.TaskId = @TaskId 

	ORDER BY sv.DateCreated DESC

END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 07 Oct 16
-- Description:	Get all Task specifications related to a task, 
--				with optional status filter.
-- =============================================
-- EXEC GetTaskWorkSpecifications 151, NULL, 1
ALTER PROCEDURE [dbo].[GetTaskWorkSpecifications]
	@TaskId int,
	@Status bit = NULL,
	@Admin bit,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @StartIndex INT  = 0

	IF @PageIndex IS NULL
	BEGIN
		SET @PageIndex = 0
	END

	IF @PageSize IS NULL
	BEGIN
		SET @PageSize = 0
	END

	SET @StartIndex = (@PageIndex * @PageSize) + 1

	;WITH TaskWorkSpecifications
	AS
	(
		-- working copies (last working copies for each specification).
		SELECT
				sv.*,
				sv.Id as TaskWorkSpecificationVersionId,
				CurrentUser.Id AS CurrentUserId,
				CurrentUser.Username AS CurrentUsername,
				CurrentUser.FirstName AS CurrentFirstName,
				CurrentUser.LastName AS CurrentLastName,
				CurrentUser.Email AS CurrentEmail,
				ROW_NUMBER() OVER(ORDER BY s.ID ASC) AS RowNumber

		FROM tblTaskWorkSpecification s
				OUTER APPLY
				(
					SELECT TOP 1 *, ROW_NUMBER() OVER(ORDER BY ID DESC) AS RowNo
					FROM tblTaskWorkSpecificationVersions
					WHERE TaskWorkSpecificationId = s.Id AND [Status] = ISNULL(@Status,[Status])
				) AS sv 
				OUTER APPLY
				(
					SELECT TOP 1 iu.Id,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
					FROM tblInstallUsers iu
					WHERE iu.Id = sv.UserId AND sv.IsInstallUser = 1
			
					UNION

					SELECT TOP 1 u.Id,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
					FROM tblUsers u
					WHERE u.Id = sv.UserId AND sv.IsInstallUser = 0

				) AS CurrentUser
		WHERE 
			s.TaskId = @TaskId AND 
			sv.[Status] = ISNULL(@Status,[Status]) AND
			(
				@Admin = 1 OR 
				(
					@Admin = 0 AND 
					sv.FreezedByCount = 2
				)
			)
	)

			
	-- get records
	SELECT *
	FROM TaskWorkSpecifications
	WHERE 
		RowNumber >= @StartIndex AND 
		(
			@PageSize = 0 OR 
			RowNumber < (@StartIndex + @PageSize)
		)

	-- get record count
	SELECT COUNT(*) AS TotalRecordCount
	FROM tblTaskWorkSpecification s
				OUTER APPLY
				(
					SELECT TOP 1 *, ROW_NUMBER() OVER(ORDER BY ID DESC) AS RowNo
					FROM tblTaskWorkSpecificationVersions
					WHERE TaskWorkSpecificationId = s.Id AND [Status] = ISNULL(@Status,[Status])
				) AS sv 
	WHERE 
		s.TaskId = @TaskId AND 
		[Status] = ISNULL(@Status,[Status]) AND
		(
			@Admin = 1 OR 
			(
				@Admin = 0 AND 
				sv.FreezedByCount = 2
			)
		)

END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 07 Oct 16
-- Description:	Gets number of pending Task specifications related to a task.
-- =============================================
-- EXEC GetPendingTaskWorkSpecificationCount 0
CREATE PROCEDURE [dbo].[GetPendingTaskWorkSpecificationCount]
	@TaskId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT COUNT(DISTINCT s.id) AS TotalRecordCount
	FROM tblTaskWorkSpecification s
	WHERE 
		s.TaskId = @TaskId AND 
		s.Id NOT IN (
						SELECT TaskWorkSpecificationId
						FROM tblTaskWorkSpecificationVersions sv
						WHERE sv.TaskWorkSpecificationId = s.Id AND sv.FreezedByCount = 2
					)

END
GO


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
	@PageSize		INT = 10
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @PageIndex = @PageIndex + 1

	;WITH Tasklist
	AS
	(	
		SELECT 
			--TaskUserMatch.IsMatch AS TaskUserMatch,
			--TaskUserRequestsMatch.IsMatch AS TaskUserRequestsMatch,
			--TaskDesignationMatch.IsMatch AS TaskDesignationMatch,
			Tasks.TaskId, 
			Tasks.Title, 
			Tasks.InstallId, 
			Tasks.[Status], 
			Tasks.[CreatedOn],
			Tasks.[DueDate], 
			Tasks.IsDeleted,
			Tasks.CreatedBy,
			Tasks.TaskPriority,
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
				(SELECT  CAST(', ' + CAST(tu.UserId AS VARCHAR) + ':' + u.FristName as VARCHAR) AS Name
				FROM tblTaskAssignmentRequests tu
					INNER JOIN tblInstallUsers u ON tu.UserId = u.Id
				WHERE tu.TaskId = Tasks.TaskId
				FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
				,1
				,2
				,' '
			) AS TaskAssignmentRequestUsers
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
			--AND
			--1 = CASE 
			--	WHEN @SearchTerm IS NULL THEN 
			--		CASE
			--			WHEN TaskDesignationMatch.IsMatch = 1 THEN 1
			--			ELSE 0
			--		END
			--	ELSE
			--		CASE
			--			WHEN Tasks.[InstallId] LIKE '%' + @SearchTerm + '%' THEN 1
			--			WHEN Tasks.[Title] LIKE '%' + @SearchTerm + '%' THEN 1
			--			WHEN TaskDesignationMatch.IsMatch = 1 THEN 1
			--			ELSE 0
			--		END
			--END
			AND
			Tasks.[Status] = ISNULL(@Status,Tasks.[Status]) 
			AND
			CONVERT(VARCHAR,Tasks.[CreatedOn],101)  >= ISNULL(@CreatedFrom,CONVERT(VARCHAR,Tasks.[CreatedOn],101)) AND
			CONVERT(VARCHAR,Tasks.[CreatedOn],101)  <= ISNULL(@CreatedTo,CONVERT(VARCHAR,Tasks.[CreatedOn],101))
	),

FinalData AS( 
	SELECT * ,
			Row_number() OVER
			(
				ORDER BY
					CASE WHEN @SortExpression = 'UserID DESC' THEN Tasklist.TaskAssignedUsers END DESC,
					CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasklist.CreatedOn END DESC,
					CASE WHEN @SortExpression = 'Status ASC' THEN Tasklist.[Status] END ASC
			) AS RowNo
	FROM Tasklist )
	
	SELECT * FROM FinalData 
	WHERE  
		RowNo BETWEEN (@PageIndex - 1) * @PageSize + 1 AND 
		@PageIndex * @PageSize

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
		--AND
		--1 = CASE 
		--		WHEN @SearchTerm IS NULL THEN 
		--			CASE
		--				WHEN TaskDesignationMatch.IsMatch = 1 THEN 1
		--				ELSE 0
		--			END
		--		ELSE
		--			CASE
		--				WHEN Tasks.[InstallId] LIKE '%' + @SearchTerm + '%' THEN 1
		--				WHEN Tasks.[Title] LIKE '%' + @SearchTerm + '%' THEN 1
		--				WHEN TaskDesignationMatch.IsMatch = 1 THEN 1
		--				ELSE 0
		--			END
		--	END 
		AND
		Tasks.[Status] = ISNULL(@Status,Tasks.[Status]) 
		AND
		CONVERT(VARCHAR,Tasks.[CreatedOn],101)  >= ISNULL(@CreatedFrom,CONVERT(VARCHAR,Tasks.[CreatedOn],101)) AND
		CONVERT(VARCHAR,Tasks.[CreatedOn],101)  <= ISNULL(@CreatedTo,CONVERT(VARCHAR,Tasks.[CreatedOn],101))

END
GO

--==========================================================================================================================================================================================

-- Uploaded on live 10 Oct 2016

--==========================================================================================================================================================================================

DROP TABLE tblTaskWorkSpecificationVersions
GO

DROP TABLE tblTaskWorkSpecificationFreez
GO

DROP TABLE tblTaskWorkSpecification
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTaskWorkSpecifications](
	[Id] [bigint] IDENTITY(1,1) PRIMARY KEY,
	[CustomId] varchar(10) NOT NULL,
	[TaskId] [bigint] NOT NULL REFERENCES tblTask,
	[Description] [text] NULL,
	[Links] varchar(1000) NULL,
	[WireFrame] varchar(300) NULL,
	[UserId] [int] NOT NULL,
	[IsInstallUser] [bit] NOT NULL,
	[AdminStatus] [bit] NULL,
	[TechLeadStatus] [bit] NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateUpdated] [datetime] NOT NULL)
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 13 Sep 16
-- Description:	Insert Task specification and also record history.
-- =============================================
ALTER PROCEDURE [dbo].[InsertTaskWorkSpecification]
	@CustomId varchar(10),
	@TaskId bigint,
	@Description text,
	@Links varchar(1000),
	@WireFrame varchar(300),
	@UserId int,
	@IsInstallUser bit,
	@AdminStatus bit,
	@TechLeadStatus bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [dbo].[tblTaskWorkSpecifications]
		([CustomId]
		,[TaskId]
		,[Description]
		,[Links]
		,[WireFrame]
		,[UserId]
		,[IsInstallUser]
		,[AdminStatus]
		,[TechLeadStatus]
		,[DateCreated]
		,[DateUpdated])
	VALUES
		(@CustomId
		,@TaskId
		,@Description
		,@Links
		,@WireFrame
		,@UserId
		,@IsInstallUser
		,@AdminStatus
		,@TechLeadStatus
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
-- Create date: 13 Sep 16
-- Description:	Update Task specification and also record history.
-- =============================================
ALTER PROCEDURE [dbo].[UpdateTaskWorkSpecification]
	@Id bigint,
	@CustomId varchar(10),
	@TaskId bigint,
	@Description text,
	@Links varchar(1000),
	@WireFrame varchar(300),
	@UserId int,
	@IsInstallUser bit,
	@AdminStatus bit,
	@TechLeadStatus bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [dbo].[tblTaskWorkSpecifications]
	SET 
		[CustomId] = @CustomId
		,[TaskId] = @TaskId
		,[Description] = @Description
		,[Links] = @Links
		,[WireFrame] = @WireFrame
		,[UserId] = @UserId
		,[IsInstallUser] = @IsInstallUser
		,[AdminStatus] = @AdminStatus
		,[TechLeadStatus] = @TechLeadStatus
		,[DateUpdated] = GETDATE()
	WHERE Id = @Id

END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 07 Oct 16
-- Description:	Get all Task specifications related to a task, 
--				with optional status filter.
-- =============================================
-- EXEC GetTaskWorkSpecifications 151, NULL, 1
ALTER PROCEDURE [dbo].[GetTaskWorkSpecifications]
	@TaskId bigint,
	@Admin bit,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @StartIndex INT  = 0

	IF @PageIndex IS NULL
	BEGIN
		SET @PageIndex = 0
	END

	IF @PageSize IS NULL
	BEGIN
		SET @PageSize = 0
	END

	SET @StartIndex = (@PageIndex * @PageSize) + 1

	;WITH TaskWorkSpecifications
	AS
	(
		SELECT
				s.*,
				CurrentUser.Id AS CurrentUserId,
				CurrentUser.Username AS CurrentUsername,
				CurrentUser.FirstName AS CurrentFirstName,
				CurrentUser.LastName AS CurrentLastName,
				CurrentUser.Email AS CurrentEmail,
				ROW_NUMBER() OVER(ORDER BY s.ID ASC) AS RowNumber

		FROM tblTaskWorkSpecifications s
				OUTER APPLY
				(
					SELECT TOP 1 iu.Id,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
					FROM tblInstallUsers iu
					WHERE iu.Id = s.UserId AND s.IsInstallUser = 1
			
					UNION

					SELECT TOP 1 u.Id,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
					FROM tblUsers u
					WHERE u.Id = s.UserId AND s.IsInstallUser = 0

				) AS CurrentUser
		WHERE
			s.TaskId = @TaskId AND 
			1 = CASE
					-- load records with all status for admin users.
					WHEN @Admin = 1 THEN
						1
					-- load only approved records for non-admin users.
					ELSE
						CASE
							WHEN s.[AdminStatus] = 1 AND s.[TechLeadStatus] = 1 THEN 1
							ELSE 0
						END
				END
	)

			
	-- get records
	SELECT *
	FROM TaskWorkSpecifications
	WHERE 
		RowNumber >= @StartIndex AND 
		(
			@PageSize = 0 OR 
			RowNumber < (@StartIndex + @PageSize)
		)

	-- get record count
	SELECT COUNT(*) AS TotalRecordCount
	FROM tblTaskWorkSpecifications s
	WHERE
		s.TaskId = @TaskId AND 
		1 = CASE
				-- load records with all status for admin users.
				WHEN @Admin = 1 THEN
					1
				-- load only approved records for non-admin users.
				ELSE
					CASE
						WHEN s.[AdminStatus] = 1 AND s.[TechLeadStatus] = 1 THEN 1
						ELSE 0
					END
			END

END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 13 Sep 16
-- Description:	Get Task specification by Id.
-- =============================================
CREATE PROCEDURE [dbo].[GetTaskWorkSpecificationById]
	@Id		INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
			s.*,
			LastUser.Id AS LastUserId,
			LastUser.Username AS LastUsername,
			LastUser.FirstName AS LastUserFirstName,
			LastUser.LastName AS LastUserLastName,
			LastUser.Email AS LastUserEmail

	FROM tblTaskWorkSpecifications s
			OUTER APPLY
			(
				SELECT TOP 1 iu.Id,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
				FROM tblInstallUsers iu
				WHERE iu.Id = s.UserId AND s.IsInstallUser = 1
			
				UNION

				SELECT TOP 1 u.Id,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
				FROM tblUsers u
				WHERE u.Id = s.UserId AND s.IsInstallUser = 0
			) AS LastUser

	WHERE s.Id = @Id 

END
GO