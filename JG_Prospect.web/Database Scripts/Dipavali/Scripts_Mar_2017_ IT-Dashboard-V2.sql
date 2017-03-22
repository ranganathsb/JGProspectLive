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
	@searchterm  as varchar(300),
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL,
	@hstid int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @strt int
	DECLARE @StartIndex INT  = 0
	declare @pagenumber int
	set @pagenumber =0

	IF @PageIndex IS NULL
	BEGIN
		SET @PageIndex = 0
	END

	IF @PageSize IS NULL
	BEGIN
		SET @PageSize = 0
	END

	SET @StartIndex = (@PageIndex * @PageSize) + 1
	
	IF @searchterm = '' 
	BEGIN
		;WITH 
		Tasklist AS
		(	
			SELECT
				Tasks.*,
				(SELECT TOP 1 EstimatedHours 
					FROM [TaskApprovalsView] TaskApprovals 
					WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,
				(SELECT TOP 1 EstimatedHours 
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
						-- condition added by DP 23-jan-17 ---
						and Tasks.TaskLevel=1
				) Tasks
		)

		-- get records
		SELECT *
		INTO #temp
		FROM Tasklist
		
		IF @hstid = 0 
			begin

				set @pagenumber = @StartIndex

				SELECT * 
				FROM #temp 
				WHERE 
					RowNo_Order >= @StartIndex AND 
					(
						@PageSize = 0 OR 
						RowNo_Order < (@StartIndex + @PageSize)
					)
				ORDER BY RowNo_Order


			end
		else
			begin
				set @strt =( select RowNo_Order from #temp where TaskId=@hstid)
				print @strt
				--set @PageSize = 0

				declare @cel int
				set @cel =( SELECT CEILING( @strt / cast(@PageSize as float)) * @PageSize)
				print @cel 

				
				set @pagenumber = ( SELECT CEILING(  cast(@cel as float) /@PageSize) )
				

				if  @cel >0
					begin
						set @cel =@cel-  @PageSize
					end

				SELECT * 
				FROM #temp 
				WHERE 
					--RowNo_Order >= @StartIndex AND 
					RowNo_Order >@cel   AND
					(
						@PageSize = 0 OR 
						RowNo_Order < (@cel + @PageSize)
					)
				ORDER BY RowNo_Order
			end
		
		-- get records count
		SELECT
			COUNT(*) AS TotalRecords
		FROM 
			[TaskListView] Tasks 
				LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
		WHERE
			Tasks.ParentTaskId = @TaskId 
			-- condition added by DP 23-jan-17 ---
			and Tasks.TaskLevel=1


		select @pagenumber  as pagenumber

	END
	ELSE
	BEGIN
		;WITH 
		Tasklist AS
		(	
			SELECT
				Tasks.*,
				(SELECT TOP 1 EstimatedHours 
					FROM [TaskApprovalsView] TaskApprovals 
					WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,
				(SELECT TOP 1 EstimatedHours 
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
						tblinstallusers as a,
						[TaskListView] Tasks 
							LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
							LEFT JOIN [tbltaskassignedusers] t on Tasks.TaskId=t.TaskId
					WHERE
						Tasks.ParentTaskId = @TaskId 
						and a.Id=t.UserId and a.Fristname like '%'+@searchterm+'%'
						-- condition added by DP 23-jan-17 ---
						and Tasks.TaskLevel=1
				) Tasks
		)
		-- get records
		SELECT *
		INTO #temp1
		FROM Tasklist
		
		IF @hstid = 0 
			begin
				SELECT * 
				FROM #temp1 
				WHERE 
					RowNo_Order >= @StartIndex AND 
					(
						@PageSize = 0 OR 
						RowNo_Order < (@StartIndex + @PageSize)
					)
				ORDER BY RowNo_Order
			end
		else
			begin
				set @strt =( select RowNo_Order from #temp1 where TaskId=@hstid)
				--print @strt
				--set @PageSize = 0

				declare @cel1 int
				set @cel1 =( SELECT CEILING( @strt / cast(@PageSize as float)) * @PageSize)
				--print @cel 

				
				set @pagenumber = ( SELECT CEILING(  cast(@cel1 as float) /@PageSize) )
				

				if  @cel1 >0
					begin
						set @cel1 =@cel1-  @PageSize
					end

				SELECT * 
				FROM #temp1 
				WHERE 
					--RowNo_Order >= @StartIndex AND 
					RowNo_Order >@cel1   AND
					(
						@PageSize = 0 OR 
						RowNo_Order < (@cel1 + @PageSize)
					)
				ORDER BY RowNo_Order
			end

		-- get records count
		SELECT
			COUNT(*) AS TotalRecords
		FROM 
			tblinstallusers as a,
			[TaskListView] Tasks 
				LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
				LEFT JOIN [tbltaskassignedusers] t on Tasks.TaskId=t.TaskId
		WHERE
			Tasks.ParentTaskId = @TaskId 
			and a.Id=t.UserId and a.Fristname like '%'+@searchterm+'%'
			-- condition added by DP 23-jan-17 ---
			and Tasks.TaskLevel=1

		
		select @pagenumber  as pagenumber


	END
END






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetPartialFrozenTasks] 
	-- Add the parameters for the stored procedure here

	@startdate varchar(50),
	@enddate varchar(50)
AS
BEGIN

select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,InstallId as InstallId1,
			case 
				when (ParentTaskId is null and  TaskLevel=1) then InstallId 
				when (tasklevel =1 and ParentTaskId>0) then 
					(select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId  
				when (tasklevel =2 and ParentTaskId>0) then
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
					
				when (tasklevel =3 and ParentTaskId>0) then
				(select InstallId from tbltask where taskid in (
				(select parenttaskid from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))
				+'-'+
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
			end as 'InstallId'
			from (
	
			select * from tbltask where [Status]=1 
			--and (CreatedOn >=@startdate and CreatedOn <= @enddate ) 
			) as x

END



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetFrozenTasks] 
	-- Add the parameters for the stored procedure here
	@search varchar(100),
	@startdate varchar(50),
	@enddate varchar(50)
AS
BEGIN

if @search<>''
	begin

			select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,InstallId as InstallId1,
			case 
				when (ParentTaskId is null and  TaskLevel=1) then InstallId 
				when (tasklevel =1 and ParentTaskId>0) then 
					(select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId  
				when (tasklevel =2 and ParentTaskId>0) then
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
					
				when (tasklevel =3 and ParentTaskId>0) then
				(select InstallId from tbltask where taskid in (
				(select parenttaskid from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))
				+'-'+
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
			end as 'InstallId'
			from (
				select a.* from tbltask as a,tbltaskapprovals as b,tbltaskassignedusers as c,tblInstallUsers as t 
				where a.TaskId=b.TaskId and b.TaskId=c.TaskId and c.UserId=t.Id 
				AND  ( 
				t.FristName LIKE '%'+@search+'%'  or 
				t.LastName LIKE '%'+@search+'%'  or 
				t.Email LIKE '%'+@search+'%' 
				) 
				--and (DateCreated >=@startdate  
				--and DateCreated <= @enddate) 

		) as x
	end
else
	begin

			select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,InstallId as InstallId1,
			case 
				when (ParentTaskId is null and  TaskLevel=1) then InstallId 
				when (tasklevel =1 and ParentTaskId>0) then 
					(select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId  
				when (tasklevel =2 and ParentTaskId>0) then
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
					
				when (tasklevel =3 and ParentTaskId>0) then
				(select InstallId from tbltask where taskid in (
				(select parenttaskid from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))
				+'-'+
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
			end as 'InstallId'
			from (

			select a.* from tbltask as a,tbltaskapprovals as b where a.TaskId=b.TaskId  
			 --and (DateCreated >=@startdate  
			 --and DateCreated <= @enddate) 
			) as x
	end


END

