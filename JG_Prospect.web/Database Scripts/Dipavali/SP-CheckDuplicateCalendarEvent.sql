USE [JGBS_Interview]
GO
/****** Object:  StoredProcedure [dbo].[CheckDuplicateCalendarEvent]    Script Date: 12-01-2017 PM 06:26:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[CheckDuplicateCalendarEvent] 
	-- Add the parameters for the stored procedure here
	@CalendarName varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from dbo.tbl_EventCalendar where CalendarName=@CalendarName
END
