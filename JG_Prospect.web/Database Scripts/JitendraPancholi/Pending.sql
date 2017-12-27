IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetCurrentScheduledHtmlTemplates' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetCurrentScheduledHtmlTemplates
  END
Go
/* 

Exec GetCurrentScheduledHtmlTemplates

*/
Create Procedure GetCurrentScheduledHtmlTemplates
As
Begin
	Create Table #TempData(Id int identity(1,1), StartDateTime DateTime, Frequency int, TemplateId int)
			
	Insert Into #TempData
	SELECT FORMAT(CONVERT(DateTime, convert(varchar(20), CONVERT(date, T.FrequencyStartDate)) + ' ' +
			RIGHT('0'+CAST(DATEPART(hour, T.FrequencyStartTime) as varchar(2)),2) + ':' +
			RIGHT('0'+CAST(DATEPART(minute, T.FrequencyStartTime)as varchar(2)),2)),'yyyy-MM-dd HH:mm') As StartDateTime,	   
		   T.FrequencyInDays, T.Id--, T.Subject
	from tblHTMLTemplatesMaster T Where T.FrequencyStartTime Is Not Null
	Select *, DateAdd(Day, (Frequency*((DATEDIFF(Day,StartDateTime,GetDate()) / Frequency))), StartDateTime) As RunsOn
	/*DATEDIFF(Day,StartDateTime,GetDate()) As Days,
	 (DATEDIFF(Day,StartDateTime,GetDate()) / Frequency)*/
	 FROM #TempData
	 Where GetDate() = DateAdd(Day, (Frequency*((DATEDIFF(Day,StartDateTime,GetDate()) / Frequency))), StartDateTime)

	Drop Table #TempData

End


IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'UpdateEmpType' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE UpdateEmpType
  END
Go
Create PROCEDURE UpdateEmpType
	@ID int,
	@EmpType varchar(50)
AS
BEGIN
	update tblInstallUsers set EmpType=@EmpType where ID=@ID
END