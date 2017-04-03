USE [JGBS_Dev_New]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UpdateTaskTitleById]
	@TaskId bigint,
	@Title varchar(300)
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [dbo].[tblTask]
	SET 
		[Title] = @Title
		
	WHERE TaskId = @TaskId

END



go
CREATE PROCEDURE [dbo].[UpdateTaskURLById]
	@TaskId bigint,
	@URL varchar(250)
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [dbo].[tblTask]
	SET 
		[Url] = @URL
		
	WHERE TaskId = @TaskId

END


go
CREATE PROCEDURE [dbo].[UpdateTaskDescriptionById]
	@TaskId bigint,
	@Description varchar(max)
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [dbo].[tblTask]
	SET 
		[Description] = @Description
		
	WHERE TaskId = @TaskId

END

GO

CREATE PROCEDURE [dbo].[usp_GetTaskByaxId] 
	@parentTaskId bigint,
	@taskLVL smallint
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		*
	FROM
		tbltask 
	WHERE
		parenttaskid = @parentTaskId
		AND Taskid = (select max(taskid) from tbltask where parenttaskid = @parentTaskId and tasklevel=@taskLVL) 
	order by taskid
END

