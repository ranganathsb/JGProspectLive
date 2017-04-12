﻿/****** Object:  StoredProcedure [dbo].[GetFrozenTasks]    Script Date: 08-Apr-17 9:23:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetFrozenTasks] 
	-- Add the parameters for the stored procedure here
	@search varchar(100),
	@startdate varchar(50),
	@enddate varchar(50),
	@PageIndex INT , 
	@PageSize INT ,
	@userid int,
	@desigid int

AS
BEGIN

DECLARE @StartIndex INT  = 0
SET @StartIndex = (@PageIndex * @PageSize) + 1

if @search<>''
	begin
		;WITH 
		Tasklist AS
		(
				select  distinct(TaskId) ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,InstallId as InstallId1,AdminStatus,TechLeadStatus,OtherUserStatus,InstallId
			FROM
			(
			select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
				Title,[Hours],ParentTaskId,TaskLevel,InstallId as InstallId1,AdminStatus,TechLeadStatus,OtherUserStatus,
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
				end as 'InstallId' ,Row_number() OVER (  order by x.TaskId ) AS RowNo_Order
				from (
										select a.TaskId,a.[Description],a.[Status],convert(Date,a.DueDate ) as DueDate,
					a.Title,a.[Hours],a.InstallId ,a.ParentTaskId,a.TaskLevel,a.AdminStatus,a.TechLeadStatus,a.OtherUserStatus
					 from tbltask as a,tbltaskapprovals as b,tbltaskassignedusers as c,
					tblInstallUsers as t 
					where a.TaskId=b.TaskId and b.UserId=c.UserId 
					and b.TaskId=c.TaskId and c.UserId=t.Id 
					AND  ( 
					t.FristName LIKE '%'+@search+'%'  or 
					t.LastName LIKE '%'+@search+'%'  or 
					t.Email LIKE '%'+@search+'%' 
					)  and  tasklevel=1 and parenttaskid is not null
					and (AdminStatus = 1 OR TechLeadStatus = 1)
					
					--and (DateCreated >=@startdate  
					--and DateCreated <= @enddate) 

					union all

					SELECT a.TaskId,a.[Description],a.[Status],convert(Date,a.DueDate ) as DueDate,
					a.Title,a.[Hours],a.InstallId ,a.ParentTaskId,a.TaskLevel,a.AdminStatus,a.TechLeadStatus,a.OtherUserStatus
					from dbo.tblTask as a,  tbltaskassignedusers as c,
					tbltaskapprovals as b,tblInstallUsers as t
					where   a.MainParentId=b.TaskId and b.UserId=t.Id  
					and b.UserId=c.UserId and b.TaskId=c.TaskId
					AND  (
					t.FristName LIKE '%'+ @search + '%'  or
					t.LastName LIKE '%'+ @search + '%'  or
					t.Email LIKE '%' + @search +'%'  
					) 
					and parenttaskid is not null
					and (AdminStatus = 1 OR TechLeadStatus = 1)
			) as x
			) as y
		)

		SELECT *,Row_number() OVER (  order by Tasklist.TaskId ) AS RowNo_Order
		INTO #temp
		FROM Tasklist


		SELECT
			Tasks.* ,
			TaskApprovals.Id AS TaskApprovalId,
			TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,
			TaskApprovals.Description AS TaskApprovalDescription,
			TaskApprovals.UserId AS TaskApprovalUserId,
			TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser,
			(SELECT TOP 1 EstimatedHours 
				FROM [TaskApprovalsView] TaskApprovals 
				WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,
			(SELECT TOP 1 EstimatedHours 
				FROM [TaskApprovalsView] TaskApprovals
				WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours
		FROM #temp AS t
			INNER JOIN [TaskListView] Tasks ON t.TaskId = Tasks.TaskId
			LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId --AND TaskApprovals.IsAdminOrITLead = @Admin
		WHERE 
			RowNo_Order >= @StartIndex AND 
			(
				@PageSize = 0 OR 
				RowNo_Order < (@StartIndex + @PageSize)
			)
		ORDER BY RowNo_Order

		SELECT
		COUNT(*) AS TotalRecords
		FROM #temp
	end
else if @userid=0 and @desigid=0
	begin
		;WITH 
		Tasklist AS
		(
			select  distinct(TaskId) ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,InstallId as InstallId1,AdminStatus,TechLeadStatus,OtherUserStatus,InstallId
			FROM
			(
			select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,InstallId as InstallId1,AdminStatus,TechLeadStatus,OtherUserStatus,
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
			end as 'InstallId',Row_number() OVER (  order by x.TaskId ) AS RowNo_Order
			from (

				select distinct( a.TaskId),a.[Description],a.[Status],convert(Date,a.DueDate ) as DueDate,
					a.Title,a.[Hours],a.InstallId ,a.ParentTaskId,a.TaskLevel,a.AdminStatus,a.TechLeadStatus,a.OtherUserStatus
					from tbltask as a,tbltaskapprovals as b,tbltaskassignedusers as c
					where a.TaskId=b.TaskId 
					and b.TaskId=c.TaskId  
					and  tasklevel=1 and parenttaskid is not null
					and (AdminStatus = 1 OR TechLeadStatus = 1)
				 --and (DateCreated >=@startdate  
				 --and DateCreated <= @enddate) 

				union all

					SELECT distinct( a.TaskId),a.[Description],a.[Status],convert(Date,a.DueDate ) as DueDate,
					a.Title,a.[Hours],a.InstallId ,a.ParentTaskId,a.TaskLevel,a.AdminStatus,a.TechLeadStatus,a.OtherUserStatus
					from dbo.tblTask as a
					where 
					parenttaskid is not null
					and (AdminStatus = 1 OR TechLeadStatus = 1)
			) as x
			) as y
		)


		SELECT *,Row_number() OVER (  order by Tasklist.TaskId ) AS RowNo_Order
		INTO #temp1
		FROM Tasklist

		SELECT
			Tasks.* ,
			TaskApprovals.Id AS TaskApprovalId,
			TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,
			TaskApprovals.Description AS TaskApprovalDescription,
			TaskApprovals.UserId AS TaskApprovalUserId,
			TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser,
			(SELECT TOP 1 EstimatedHours 
				FROM [TaskApprovalsView] TaskApprovals 
				WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,
			(SELECT TOP 1 EstimatedHours 
				FROM [TaskApprovalsView] TaskApprovals
				WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours
		FROM #temp1 AS t
			INNER JOIN [TaskListView] Tasks ON t.TaskId = Tasks.TaskId
			LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId --AND TaskApprovals.IsAdminOrITLead = @Admin
		WHERE 
			RowNo_Order >= @StartIndex AND 
			(
				@PageSize = 0 OR 
				RowNo_Order < (@StartIndex + @PageSize)
			)
		ORDER BY RowNo_Order

		SELECT
		COUNT(*) AS TotalRecords
		FROM #temp1
	end

else if @userid>0  
	begin
		;WITH 
		Tasklist AS
		(
				select  distinct(TaskId) ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,InstallId as InstallId1,AdminStatus,TechLeadStatus,OtherUserStatus,InstallId
			FROM
			(
			select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
				Title,[Hours],ParentTaskId,TaskLevel,InstallId as InstallId1,AdminStatus,TechLeadStatus,OtherUserStatus,
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
				end as 'InstallId' ,Row_number() OVER (  order by x.TaskId ) AS RowNo_Order
				from (
					select distinct(a.TaskId),a.[Description],a.[Status],convert(Date,a.DueDate ) as DueDate,
					a.Title,a.[Hours],a.InstallId ,a.ParentTaskId,a.TaskLevel,a.AdminStatus,a.TechLeadStatus,a.OtherUserStatus
					from tbltask as a,tbltaskapprovals as b,tbltaskassignedusers as c
					where a.TaskId=b.TaskId and b.TaskId=c.TaskId and c.UserId=@userid
					and  tasklevel=1 and parenttaskid is not null
					and (AdminStatus = 1 OR TechLeadStatus = 1)
					--and (DateCreated >=@startdate  
					--and DateCreated <= @enddate) 
					union all
				
					SELECT distinct(a.TaskId),a.[Description],a.[Status],convert(Date,a.DueDate ) as DueDate,
					a.Title,a.[Hours],a.InstallId ,a.ParentTaskId,a.TaskLevel,a.AdminStatus,a.TechLeadStatus,a.OtherUserStatus
					from dbo.tblTask as a,  tbltaskapprovals as c
					where   a.MainParentId=c.TaskId    and c.UserId=@userid
					and parenttaskid is not null
					and (AdminStatus = 1 OR TechLeadStatus = 1)

			) as x
			) as y
		)

		SELECT *,Row_number() OVER (  order by Tasklist.TaskId ) AS RowNo_Order
		INTO #temp2
		FROM Tasklist

		SELECT
			Tasks.* ,
			TaskApprovals.Id AS TaskApprovalId,
			TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,
			TaskApprovals.Description AS TaskApprovalDescription,
			TaskApprovals.UserId AS TaskApprovalUserId,
			TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser,
			(SELECT TOP 1 EstimatedHours 
				FROM [TaskApprovalsView] TaskApprovals 
				WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,
			(SELECT TOP 1 EstimatedHours 
				FROM [TaskApprovalsView] TaskApprovals
				WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours
		FROM #temp2 AS t
			INNER JOIN [TaskListView] Tasks ON t.TaskId = Tasks.TaskId
			LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId --AND TaskApprovals.IsAdminOrITLead = @Admin
		WHERE 
			RowNo_Order >= @StartIndex AND 
			(
				@PageSize = 0 OR 
				RowNo_Order < (@StartIndex + @PageSize)
			)
		ORDER BY RowNo_Order

		SELECT
		COUNT(*) AS TotalRecords
		FROM #temp2
	end

else if @userid=0 and @desigid>0
	begin
		;WITH 
		Tasklist AS
		(
				select  distinct(TaskId) ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,InstallId as InstallId1,AdminStatus,TechLeadStatus,OtherUserStatus,InstallId
			FROM
			(
			select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
				Title,[Hours],ParentTaskId,TaskLevel,InstallId as InstallId1,AdminStatus,TechLeadStatus,OtherUserStatus,
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
				end as 'InstallId' ,Row_number() OVER (  order by x.TaskId ) AS RowNo_Order
				from (
					--select a.* from tbltask as a,tbltaskapprovals as b,tbltaskassignedusers as c,
					--tblTaskdesignations as d
					--where a.TaskId=b.TaskId and b.TaskId=c.TaskId and c.TaskId=d.TaskId
					--and (DateCreated >=@startdate  
					--and DateCreated <= @enddate) 

					select distinct(a.TaskId),a.[Description],a.[Status],convert(Date,a.DueDate ) as DueDate,
					a.Title,a.[Hours],a.InstallId ,a.ParentTaskId,a.TaskLevel,a.AdminStatus,a.TechLeadStatus,a.OtherUserStatus
					 from tbltask as a,tbltaskapprovals as b,tbltaskassignedusers as c,
					 tblTaskdesignations as d
					where a.TaskId=b.TaskId 
					and b.TaskId=c.TaskId  and c.TaskId=d.TaskId and d.DesignationID=@desigid
					 and  tasklevel=1 and parenttaskid is not null
					and (AdminStatus = 1 OR TechLeadStatus = 1)

					 union all

					 	SELECT distinct(a.TaskId),a.[Description],a.[Status],convert(Date,a.DueDate ) as DueDate,
					a.Title,a.[Hours],a.InstallId ,a.ParentTaskId,a.TaskLevel,a.AdminStatus,a.TechLeadStatus,a.OtherUserStatus
					from dbo.tblTask as a,  tbltaskassignedusers as c,tblTaskdesignations as d,
					tbltaskapprovals as b 
					where   a.MainParentId=b.TaskId  and d.DesignationID=@desigid
					 and b.TaskId=c.TaskId and c.TaskId=d.TaskId
					and parenttaskid is not null
					and (AdminStatus = 1 OR TechLeadStatus = 1)

			) as x
			) as y
		)

		SELECT *,Row_number() OVER (  order by Tasklist.TaskId ) AS RowNo_Order
		INTO #temp3
		FROM Tasklist

		SELECT
			Tasks.* ,
			TaskApprovals.Id AS TaskApprovalId,
			TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,
			TaskApprovals.Description AS TaskApprovalDescription,
			TaskApprovals.UserId AS TaskApprovalUserId,
			TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser,
			(SELECT TOP 1 EstimatedHours 
				FROM [TaskApprovalsView] TaskApprovals 
				WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,
			(SELECT TOP 1 EstimatedHours 
				FROM [TaskApprovalsView] TaskApprovals
				WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours
		FROM #temp3 AS t
			INNER JOIN [TaskListView] Tasks ON t.TaskId = Tasks.TaskId
			LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId --AND TaskApprovals.IsAdminOrITLead = @Admin
		WHERE 
			RowNo_Order >= @StartIndex AND 
			(
				@PageSize = 0 OR 
				RowNo_Order < (@StartIndex + @PageSize)
			)
		ORDER BY RowNo_Order

		SELECT
		COUNT(*) AS TotalRecords
		FROM #temp3
	end

--if @search<>''
--	begin
--		;WITH 
--		Tasklist AS
--		(
--				select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
--				Title,[Hours],ParentTaskId,TaskLevel,InstallId as InstallId1,AdminStatus,TechLeadStatus,OtherUserStatus,
--				case 
--					when (ParentTaskId is null and  TaskLevel=1) then InstallId 
--					when (tasklevel =1 and ParentTaskId>0) then 
--						(select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId  
--					when (tasklevel =2 and ParentTaskId>0) then
--					 (select InstallId from tbltask where taskid in (
--					(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
--					+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
					
--					when (tasklevel =3 and ParentTaskId>0) then
--					(select InstallId from tbltask where taskid in (
--					(select parenttaskid from tbltask where taskid in (
--					(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))
--					+'-'+
--					 (select InstallId from tbltask where taskid in (
--					(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
--					+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
--				end as 'InstallId' ,Row_number() OVER (  order by x.TaskId ) AS RowNo_Order
--				from (
--					select a.TaskId,a.[Description],a.[Status],convert(Date,a.DueDate ) as DueDate,
--					a.Title,a.[Hours],a.InstallId ,a.ParentTaskId,a.TaskLevel,a.AdminStatus,a.TechLeadStatus,a.OtherUserStatus
--					 from tbltask as a,tbltaskapprovals as b,tbltaskassignedusers as c,
--					tblInstallUsers as t 
--					where a.TaskId=b.TaskId and b.UserId=c.UserId 
--					and b.TaskId=c.TaskId and c.UserId=t.Id 
--					AND  ( 
--					t.FristName LIKE '%'+@search+'%'  or 
--					t.LastName LIKE '%'+@search+'%'  or 
--					t.Email LIKE '%'+@search+'%' 
--					)  and  tasklevel=1 and parenttaskid is not null
					
--					--and (DateCreated >=@startdate  
--					--and DateCreated <= @enddate) 

--					union all

--					SELECT a.TaskId,a.[Description],a.[Status],convert(Date,a.DueDate ) as DueDate,
--					a.Title,a.[Hours],a.InstallId ,a.ParentTaskId,a.TaskLevel,a.AdminStatus,a.TechLeadStatus,a.OtherUserStatus
--					from dbo.tblTask as a,  tbltaskassignedusers as c,
--					tbltaskapprovals as b,tblInstallUsers as t
--					where   a.MainParentId=b.TaskId and b.UserId=t.Id  
--					and b.UserId=c.UserId and b.TaskId=c.TaskId
--					AND  (
--					t.FristName LIKE '%'+ @search + '%'  or
--					t.LastName LIKE '%'+ @search + '%'  or
--					t.Email LIKE '%' + @search +'%'  
--					) 
--					and parenttaskid is not null
--			) as x
--		)

--		SELECT *
--		INTO #temp
--		FROM Tasklist
--		WHERE (AdminStatus = 1 OR TechLeadStatus = 1)


--		SELECT * 
--		FROM #temp 
--		WHERE 
--			RowNo_Order >= @StartIndex AND 
--			(
--				@PageSize = 0 OR 
--				RowNo_Order < (@StartIndex + @PageSize)
--			)
--		ORDER BY RowNo_Order

--		SELECT
--		COUNT(*) AS TotalRecords
--		FROM #temp
--	end
--else if @userid=0 and @desigid=0
--	begin
--		;WITH 
--		Tasklist AS
--		(
--			select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
--			Title,[Hours],ParentTaskId,TaskLevel,InstallId as InstallId1,AdminStatus,TechLeadStatus,OtherUserStatus,
--			case 
--				when (ParentTaskId is null and  TaskLevel=1) then InstallId 
--				when (tasklevel =1 and ParentTaskId>0) then 
--					(select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId  
--				when (tasklevel =2 and ParentTaskId>0) then
--				 (select InstallId from tbltask where taskid in (
--				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
--				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
					
--				when (tasklevel =3 and ParentTaskId>0) then
--				(select InstallId from tbltask where taskid in (
--				(select parenttaskid from tbltask where taskid in (
--				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))
--				+'-'+
--				 (select InstallId from tbltask where taskid in (
--				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
--				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
--			end as 'InstallId',Row_number() OVER (  order by x.TaskId ) AS RowNo_Order
--			from (

--				select distinct( a.TaskId),a.[Description],a.[Status],convert(Date,a.DueDate ) as DueDate,
--					a.Title,a.[Hours],a.InstallId ,a.ParentTaskId,a.TaskLevel,a.AdminStatus,a.TechLeadStatus,a.OtherUserStatus
--					from tbltask as a,tbltaskapprovals as b,tbltaskassignedusers as c
--					where a.TaskId=b.TaskId 
--					and b.TaskId=c.TaskId  
--					and  tasklevel=1 and parenttaskid is not null
--				 --and (DateCreated >=@startdate  
--				 --and DateCreated <= @enddate) 

--				union all

--					SELECT distinct( a.TaskId),a.[Description],a.[Status],convert(Date,a.DueDate ) as DueDate,
--					a.Title,a.[Hours],a.InstallId ,a.ParentTaskId,a.TaskLevel,a.AdminStatus,a.TechLeadStatus,a.OtherUserStatus
--					from dbo.tblTask as a,  tbltaskassignedusers as c,
--					tbltaskapprovals as b 
--					where   a.MainParentId=b.TaskId  and
--					 b.TaskId=c.TaskId
--					and parenttaskid is not null


--			) as x
--		)


--		SELECT *
--		INTO #temp1
--		FROM Tasklist
--		WHERE (AdminStatus = 1 OR TechLeadStatus = 1)


--		SELECT * 
--		FROM #temp1 
--		WHERE 
--			RowNo_Order >= @StartIndex AND 
--			(
--				@PageSize = 0 OR 
--				RowNo_Order < (@StartIndex + @PageSize)
--			)
--		ORDER BY RowNo_Order

--		SELECT
--		COUNT(*) AS TotalRecords
--		FROM #temp1
--	end

--else if @userid>0  
--	begin
--		;WITH 
--		Tasklist AS
--		(
--				select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
--				Title,[Hours],ParentTaskId,TaskLevel,InstallId as InstallId1,AdminStatus,TechLeadStatus,OtherUserStatus,
--				case 
--					when (ParentTaskId is null and  TaskLevel=1) then InstallId 
--					when (tasklevel =1 and ParentTaskId>0) then 
--						(select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId  
--					when (tasklevel =2 and ParentTaskId>0) then
--					 (select InstallId from tbltask where taskid in (
--					(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
--					+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
					
--					when (tasklevel =3 and ParentTaskId>0) then
--					(select InstallId from tbltask where taskid in (
--					(select parenttaskid from tbltask where taskid in (
--					(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))
--					+'-'+
--					 (select InstallId from tbltask where taskid in (
--					(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
--					+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
--				end as 'InstallId' ,Row_number() OVER (  order by x.TaskId ) AS RowNo_Order
--				from (
--					select distinct(a.TaskId),a.[Description],a.[Status],convert(Date,a.DueDate ) as DueDate,
--					a.Title,a.[Hours],a.InstallId ,a.ParentTaskId,a.TaskLevel,a.AdminStatus,a.TechLeadStatus,a.OtherUserStatus
--					from tbltask as a,tbltaskapprovals as b,tbltaskassignedusers as c
--					where a.TaskId=b.TaskId and b.TaskId=c.TaskId and c.UserId=@userid
--					and  tasklevel=1 and parenttaskid is not null
--					--and (DateCreated >=@startdate  
--					--and DateCreated <= @enddate) 
--					union all
				
--					SELECT distinct(a.TaskId),a.[Description],a.[Status],convert(Date,a.DueDate ) as DueDate,
--					a.Title,a.[Hours],a.InstallId ,a.ParentTaskId,a.TaskLevel,a.AdminStatus,a.TechLeadStatus,a.OtherUserStatus
--					from dbo.tblTask as a,  tbltaskapprovals as c
--					where   a.MainParentId=c.TaskId    and c.UserId=@userid
--					and parenttaskid is not null

--			) as x
--		)

--		SELECT *
--		INTO #temp2
--		FROM Tasklist
--		WHERE (AdminStatus = 1 OR TechLeadStatus = 1)


--		SELECT * 
--		FROM #temp2 
--		WHERE 
--			RowNo_Order >= @StartIndex AND 
--			(
--				@PageSize = 0 OR 
--				RowNo_Order < (@StartIndex + @PageSize)
--			)
--		ORDER BY RowNo_Order

--		SELECT
--		COUNT(*) AS TotalRecords
--		FROM #temp2
--	end

--else if @userid=0 and @desigid>0
--	begin
--		;WITH 
--		Tasklist AS
--		(
--				select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
--				Title,[Hours],ParentTaskId,TaskLevel,InstallId as InstallId1,AdminStatus,TechLeadStatus,OtherUserStatus,
--				case 
--					when (ParentTaskId is null and  TaskLevel=1) then InstallId 
--					when (tasklevel =1 and ParentTaskId>0) then 
--						(select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId  
--					when (tasklevel =2 and ParentTaskId>0) then
--					 (select InstallId from tbltask where taskid in (
--					(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
--					+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
					
--					when (tasklevel =3 and ParentTaskId>0) then
--					(select InstallId from tbltask where taskid in (
--					(select parenttaskid from tbltask where taskid in (
--					(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))
--					+'-'+
--					 (select InstallId from tbltask where taskid in (
--					(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
--					+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
--				end as 'InstallId' ,Row_number() OVER (  order by x.TaskId ) AS RowNo_Order
--				from (
--					--select a.* from tbltask as a,tbltaskapprovals as b,tbltaskassignedusers as c,
--					--tblTaskdesignations as d
--					--where a.TaskId=b.TaskId and b.TaskId=c.TaskId and c.TaskId=d.TaskId
--					--and (DateCreated >=@startdate  
--					--and DateCreated <= @enddate) 

--					select distinct(a.TaskId),a.[Description],a.[Status],convert(Date,a.DueDate ) as DueDate,
--					a.Title,a.[Hours],a.InstallId ,a.ParentTaskId,a.TaskLevel,a.AdminStatus,a.TechLeadStatus,a.OtherUserStatus
--					 from tbltask as a,tbltaskapprovals as b,tbltaskassignedusers as c,
--					 tblTaskdesignations as d
--					where a.TaskId=b.TaskId 
--					and b.TaskId=c.TaskId  and c.TaskId=d.TaskId and d.DesignationID=@desigid
--					 and  tasklevel=1 and parenttaskid is not null

--					 union all

--					 	SELECT distinct(a.TaskId),a.[Description],a.[Status],convert(Date,a.DueDate ) as DueDate,
--					a.Title,a.[Hours],a.InstallId ,a.ParentTaskId,a.TaskLevel,a.AdminStatus,a.TechLeadStatus,a.OtherUserStatus
--					from dbo.tblTask as a,  tbltaskassignedusers as c,tblTaskdesignations as d,
--					tbltaskapprovals as b 
--					where   a.MainParentId=b.TaskId  and d.DesignationID=@desigid
--					 and b.TaskId=c.TaskId and c.TaskId=d.TaskId
--					and parenttaskid is not null

--			) as x
--		)

--		SELECT *
--		INTO #temp3
--		FROM Tasklist
--		WHERE (AdminStatus = 1 OR TechLeadStatus = 1)


--		SELECT * 
--		FROM #temp3
--		WHERE 
--			RowNo_Order >= @StartIndex AND 
--			(
--				@PageSize = 0 OR 
--				RowNo_Order < (@StartIndex + @PageSize)
--			)
--		ORDER BY RowNo_Order

--		SELECT
--		COUNT(*) AS TotalRecords
--		FROM #temp3
--	end
END
GO




/****** Object:  View [dbo].[TaskListView]    Script Date: 11-Apr-17 10:42:55 AM ******/
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


CREATE TABLE tblTaskComments
(
Id	BIGINT PRIMARY KEY IDENTITY(1,1),
Comment	VARCHAR(MAX) NOT NULL,
TaskId BIGINT NOT NULL REFERENCES tblTask,
ParentCommentId	BIGINT NULL REFERENCES tblTaskComments,
UserId	INT NOT NULL REFERENCES tblInstallUsers,
DateCreated	DATETIME DEFAULT GETDATE()
)
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 12 April 2017
-- Description:	This procedure is used to insert a comment for task or sub task.
-- =============================================
CREATE PROCEDURE InsertTaskComment
	@Comment VARCHAR(MAX),
	@TaskId BIGINT,
	@ParentCommentId BIGINT,
	@UserId INT
AS
BEGIN
	
	INSERT INTO [dbo].[tblTaskComments]
           ([Comment]
           ,[TaskId]
           ,[ParentCommentId]
           ,[UserId])
     VALUES
           (@Comment
           ,@TaskId
           ,@ParentCommentId
           ,@UserId)

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 12 April 2017
-- Description:	This procedure is used to update a comment for task or sub task.
-- =============================================
CREATE PROCEDURE UpdateTaskComment
	@Id	BIGINT,
	@Comment VARCHAR(MAX),
	@TaskId BIGINT,
	@ParentCommentId BIGINT,
	@UserId INT
AS
BEGIN
	
	 UPDATE [dbo].[tblTaskComments]
	   SET [Comment] = @Comment
		  ,[TaskId] = @TaskId
		  ,[ParentCommentId] = @ParentCommentId
		  ,[UserId] = @UserId
	 WHERE Id = @Id

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 12 April 2017
-- Description:	This procedure is used to delete a comment for task or sub task.
-- =============================================
CREATE PROCEDURE DeleteTaskComment
	@Id	BIGINT
AS
BEGIN
	
	-- do not delete a comment, if child comment exists.
	IF NOT EXISTS(SELECT TOP 1 1 
				FROM [tblTaskComments] 
				WHERE ParentCommentId = @Id)
	BEGIN
		DELETE 
		FROM [dbo].[tblTaskComments]
		WHERE Id = @Id
	END

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 12 April 2017
-- Description:	This procedure is used to get comments for task or sub task.
-- =============================================
CREATE PROCEDURE GetTaskComments
	@TaskId	BIGINT,
	@ParentCommentId BIGINT = NULL,
	@StartIndex INT = NULL,
	@PageSize	INT = NULL
AS
BEGIN
	
	IF @StartIndex IS NULL
	BEGIN
		SET @StartIndex = 0
	END

	DECLARE @EndIndex INT = NULL
	IF @PageSize IS NOT NULL
	BEGIN
		SET @EndIndex = (@StartIndex + @PageSize) - 1
	END

	;WITH cte_TaskComments AS
	(
		SELECT 
			tc.*,
			iu.InstallId ,
			iu.FristName AS Username, 
			iu.FristName AS FirstName, 
			iu.LastName, 
			iu.Email,
			ROW_NUMBER() OVER (ORDER BY tc.DateCreated DESC) AS RowNO
		FROM [tblTaskComments] tc
				INNER JOIN [tblInstallUsers] iu ON tc.UserId = iu.Id
		WHERE tc.TaskId = @TaskId 
			AND tc.ParentCommentId = ISNULL(@ParentCommentId, ParentCommentId)
	)

	SELECT *
	FROM cte_TaskComments
	WHERE RowNo >= @StartIndex AND RowNo <= ISNULL(@EndIndex, RowNo)

END
GO

