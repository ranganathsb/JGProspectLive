-- =============================================
-- Author:		<Dipavali>
-- Create date: <30-Jan-2017>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetClosedTasks] 
	-- Add the parameters for the stored procedure here
	@userid int,
	@desigid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @str nvarchar(700)
	set @str = ''
    if @userid=0 and @desigid=0
		begin
			SELECT TaskId,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],InstallId,ParentTaskId from dbo.tblTask 
			where [Status]  in (7,8,9,10,11,12,13) and  tasklevel=1 and parenttaskid is not null
			order by [Status] desc
		end
	else if @userid>0  
		begin
			SELECT a.TaskId,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],InstallId ,ParentTaskId
			from dbo.tblTask as a, tbltaskassignedusers as b
			where [Status]  in (7,8,9,10,11,12,13) and a.TaskId=b.TaskId and b.UserId=@userid
			and  tasklevel=1 and parenttaskid is not null
			order by [Status] desc
		end
	else if @userid=0 and @desigid>0
		begin
			SELECT a.TaskId,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],InstallId,ParentTaskId
			from dbo.tblTask as a, tblTaskdesignations as b 
			where [Status]  in (7,8,9,10,11,12,13) and a.TaskId=b.TaskId and b.DesignationID=@desigid
			and  tasklevel=1 and parenttaskid is not null
			order by [Status] desc
		end
END

-- ========================
-- =============================================
-- Author:		<Dipavali>
-- Create date: <30-Jan-2017>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[GetInProgressTasks] 
	-- Add the parameters for the stored procedure here
	@userid int,
	@desigid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @str nvarchar(700)
	set @str = ''
    if @userid=0 and @desigid=0
		begin
			SELECT TaskId,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],InstallId,ParentTaskId from dbo.tblTask 
			where [Status]  in (1,2,3,4) and  tasklevel=1 and parenttaskid is not null
			order by [Status] desc
		end
	else if @userid>0  
		begin
			SELECT a.TaskId,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],InstallId ,ParentTaskId
			from dbo.tblTask as a, tbltaskassignedusers as b
			where [Status]  in (1,2,3,4) and a.TaskId=b.TaskId and b.UserId=@userid
			and  tasklevel=1 and parenttaskid is not null
			order by [Status] desc
		end
	else if @userid=0 and @desigid>0
		begin
			SELECT a.TaskId,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],InstallId,ParentTaskId
			from dbo.tblTask as a, tblTaskdesignations as b 
			where [Status]  in (1,2,3,4) and a.TaskId=b.TaskId and b.DesignationID=@desigid
			and  tasklevel=1 and parenttaskid is not null
			order by [Status] desc
		end
END