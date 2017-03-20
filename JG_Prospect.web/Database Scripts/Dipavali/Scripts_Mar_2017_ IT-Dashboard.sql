
-- =============================================
-- Author:		<Dipavali Patel>
-- =============================================
-- Author:		<Dipavali Patel>
-- Create date: <20-Mar-2017>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetFrozenTasks] 
	-- Add the parameters for the stored procedure here

	@type varchar(100),
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
				and (DateCreated >=@startdate  
				and DateCreated <= @enddate) 

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

			select a.* from tbltask as a,tbltaskapprovals as b where a.TaskId=b.TaskId and 
			 (DateCreated >=@startdate  
			 and DateCreated <= @enddate) 
			) as x
	end


END



-- =============================================
-- Author:		<Dipavali Patel>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetInProgressTasks] 
	-- Add the parameters for the stored procedure here
	@userid int,
	@desigid int,
	@search varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @str nvarchar(700)
	set @str = ''
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

				SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,
				Title,[Hours],a.InstallId ,ParentTaskId,TaskLevel
				from dbo.tblTask as a, tbltaskassignedusers as b,tblInstallUsers as t
				where a.[Status]  in (1,2,3,4) and a.TaskId=b.TaskId and b.UserId=t.Id
				AND  (
				t.FristName LIKE '%'+ @search + '%'  or
				t.LastName LIKE '%'+ @search + '%'  or
				t.Email LIKE '%' + @search +'%'  
				) and  tasklevel=1 and parenttaskid is not null
				--order by [Status] desc

				union all

				SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,
				Title,[Hours],a.InstallId ,ParentTaskId,TaskLevel
				from dbo.tblTask as a, tbltaskassignedusers as b,tblInstallUsers as t
				where a.[Status]  in (1,2,3,4) and a.MainParentId=b.TaskId and b.UserId=t.Id
				AND  (
				t.FristName LIKE '%'+ @search + '%'  or
				t.LastName LIKE '%'+ @search + '%'  or
				t.Email LIKE '%' + @search +'%'  
				) and parenttaskid is not null
			) as x
			order by [Status] desc


		end
    else if @userid=0 and @desigid=0
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

				SELECT TaskId,[Description],[Status],convert(Date,DueDate ) as DueDate,
				Title,[Hours],InstallId,ParentTaskId,TaskLevel from dbo.tblTask 
				where [Status]  in (1,2,3,4)  and parenttaskid is not null

			)as x
			order by [Status] desc
		end
	else if @userid>0  
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


			SELECT a.TaskId,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],InstallId ,ParentTaskId,TaskLevel
			from dbo.tblTask as a, tbltaskassignedusers as b
			where [Status]  in (1,2,3,4) and a.TaskId=b.TaskId and b.UserId=@userid
			and  tasklevel=1 and parenttaskid is not null
			--order by [Status] desc

			union all 

			SELECT a.TaskId,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],InstallId ,ParentTaskId,TaskLevel
			from dbo.tblTask as a, tbltaskassignedusers as b
			where [Status]  in (1,2,3,4) and a.MainParentId=b.TaskId and b.UserId=@userid
			and parenttaskid is not null
			 
			) as x order by taskid, [Status] desc 

		end
	else if @userid=0 and @desigid>0
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

			SELECT a.TaskId,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],InstallId,ParentTaskId,TaskLevel
			from dbo.tblTask as a, tblTaskdesignations as b 
			where [Status]  in (1,2,3,4) and a.TaskId=b.TaskId and b.DesignationID=@desigid
			and  tasklevel=1 and parenttaskid is not null
			--order by [Status] desc

			union all 

			SELECT a.TaskId,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],InstallId,ParentTaskId,TaskLevel
			from dbo.tblTask as a, tblTaskdesignations as b 
			where [Status]  in (1,2,3,4) and a.MainParentId=b.TaskId and b.DesignationID=@desigid
			and parenttaskid is not null
			) as x

			order by taskid,  [Status] desc

		end

		

END



-- Create date: <20-Mar-2017>
-- Description:	<Description,,>
-- =============================================
create  PROCEDURE [dbo].[GetPartialFrozenTasks] 
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
	
			select * from tbltask where [Status]=1 and (CreatedOn >=@startdate and CreatedOn <= @enddate ) 
			) as x

END



-- =============================================
-- Author:		<Dipavali>
-- Create date: <30-Jan-2017>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetClosedTasks] 
	-- Add the parameters for the stored procedure here
	@userid int,
	@desigid int,
	@search varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @str nvarchar(700)
	set @str = ''
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

			SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],a.InstallId ,ParentTaskId,TaskLevel
			from dbo.tblTask as a, tbltaskassignedusers as b,tblInstallUsers as t
			where a.[Status]  in (7,8,9,10,11,12,14) and a.TaskId=b.TaskId and b.UserId=t.Id
			AND  (
			t.FristName LIKE '%'+ @search + '%'  or
			t.LastName LIKE '%'+ @search + '%'  or
			t.Email LIKE '%' + @search +'%'  
			) and  tasklevel=1 and parenttaskid is not null
			--order by [Status] desc

			union all

			SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],a.InstallId ,ParentTaskId,TaskLevel
			from dbo.tblTask as a, tbltaskassignedusers as b,tblInstallUsers as t
			where a.[Status]  in (7,8,9,10,11,12,14) and a.MainParentId=b.TaskId and b.UserId=t.Id
			AND  (
			t.FristName LIKE '%'+ @search + '%'  or
			t.LastName LIKE '%'+ @search + '%'  or
			t.Email LIKE '%' + @search +'%'  
			) and  parenttaskid is not null

			) as x
			order by [Status] desc


		end
   else if @userid=0 and @desigid=0
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
			SELECT TaskId,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],InstallId,ParentTaskId,TaskLevel from dbo.tblTask 
			where [Status]  in (7,8,9,10,11,12,14) and  tasklevel=1 and parenttaskid is not null
			) as x
			order by [Status] desc
		end
	else if @userid>0  
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

			SELECT a.TaskId,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],InstallId ,ParentTaskId,TaskLevel
			from dbo.tblTask as a, tbltaskassignedusers as b
			where [Status]  in (7,8,9,10,11,12,14) and a.TaskId=b.TaskId and b.UserId=@userid
			and  tasklevel=1 and parenttaskid is not null
			--order by [Status] desc

			union all

			SELECT a.TaskId,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],InstallId ,ParentTaskId,TaskLevel
			from dbo.tblTask as a, tbltaskassignedusers as b
			where [Status]  in (7,8,9,10,11,12,14) and a.MainParentId=b.TaskId and b.UserId=@userid
			and parenttaskid is not null
			
			) as x
			order by [Status] desc

		end
	else if @userid=0 and @desigid>0
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

			SELECT a.TaskId,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],InstallId,ParentTaskId,TaskLevel
			from dbo.tblTask as a, tblTaskdesignations as b 
			where [Status]  in (7,8,9,10,11,12,14) and a.TaskId=b.TaskId and b.DesignationID=@desigid
			and  tasklevel=1 and parenttaskid is not null
			--order by [Status] desc

			union all

			SELECT a.TaskId,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],InstallId,ParentTaskId,TaskLevel
			from dbo.tblTask as a, tblTaskdesignations as b 
			where [Status]  in (7,8,9,10,11,12,14) and a.MainParentId=b.TaskId and b.DesignationID=@desigid
			and  parenttaskid is not null

			) as x
			order by [Status] desc

		end
END
