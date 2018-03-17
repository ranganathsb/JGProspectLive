Go
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PhoneScript]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[PhoneScript](
		Id int Primary Key Identity(1,1),
		[Type] int,-- 1: Inbound, 2: Outbound
		SubType int,-- 1: HR, 2: Sales, 3: Customer Service,
		Title NVarchar(2000) Not Null,
		[Description] NVarchar(Max) Not Null,
		CreatedOn DateTime Not Null Default(GetUTCDate())
	) 
END

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetPhoneScripts' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetPhoneScripts
  END
Go
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	GetPhoneScripts 
	GetPhoneScripts 0
*/
CREATE PROCEDURE [dbo].[GetPhoneScripts]
	@Id Int = Null
AS    
BEGIN
	If @Id IS NULL OR @Id = 0
		Begin
			Select P.Id,P.[Type],P.SubType,P.Title,P.[Description],P.CreatedOn From PhoneScript P With(NoLock) Order By P.[Type], P.SubType
		End
	Else
		Begin
			Select P.Id,P.[Type],P.SubType,P.Title,P.[Description],P.CreatedOn From PhoneScript P With(NoLock)
				Where P.Id = @Id Order By P.[Type], P.SubType
		End
End

Insert Into PhoneScript(Type,SubType,Title,Description)Values(1,1,'In Bound & Outbound Phone Calls','In Bound & Outbound Phone Calls')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(1,2,'In Bound & Outbound Phone Calls','In Bound & Outbound Phone Calls')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(1,2,'In Bound & Outbound Phone Calls','In Bound & Outbound Phone Calls')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(1,3,'In Bound & Outbound Phone Calls','In Bound & Outbound Phone Calls')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(2,1,'In Bound & Outbound Phone Calls','In Bound & Outbound Phone Calls')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(2,2,'In Bound & Outbound Phone Calls','In Bound & Outbound Phone Calls')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(2,3,'In Bound & Outbound Phone Calls','In Bound & Outbound Phone Calls')