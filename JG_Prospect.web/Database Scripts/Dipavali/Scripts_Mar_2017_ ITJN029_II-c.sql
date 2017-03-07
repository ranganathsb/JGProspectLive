-- =============================================
-- Author:		<Dipavali>
-- Create date: <7-Mar-2017>
-- Description:	<Description,,>
-- =============================================

ALTER PROCEDURE [dbo].[AddSubTasks] 
	-- Add the parameters for the stored procedure here
	@TaskId int,
	@Title varchar(400),
	@Description varchar(max),
	@Status int,
	@IsDeleted int,
    @CreatedOn datetime,
	@CreatedBy int,
	@TaskLevel int,
	@ParentTaskId int,
	@InstallId varchar(50),
	@MainParentId int,
	@TaskType int,
	@TaskPriority int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if @TaskId=0 
		begin 
			-- Insert statements for procedure here
			insert into dbo.tblTask 
			(Title,[Description],[Status],IsDeleted,CreatedOn,CreatedBy,TaskLevel,ParentTaskId,
			InstallId,MainParentId,TaskType,TaskPriority  )
			values
			(@Title,@Description,@Status,@IsDeleted,@CreatedOn,@CreatedBy,@TaskLevel,@ParentTaskId,
			@InstallId,@MainParentId,@TaskType,@TaskPriority )
		end
	else
		begin

				-- Insert statements for procedure here
			update dbo.tblTask 
			 set Title=@Title,[Description]=@Description,InstallId=@InstallId ,TaskPriority=@TaskPriority,
			 TaskType=@TaskType
			where TaskId=@TaskId
		end 

END

