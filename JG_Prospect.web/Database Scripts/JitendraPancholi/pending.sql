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
/*
Insert Into PhoneScript(Type,SubType,Title,Description)Values(1,1,'In Bound & Outbound Phone Calls','In Bound & Outbound Phone Calls')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(1,2,'In Bound & Outbound Phone Calls','In Bound & Outbound Phone Calls')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(1,2,'In Bound & Outbound Phone Calls','In Bound & Outbound Phone Calls')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(1,3,'In Bound & Outbound Phone Calls','In Bound & Outbound Phone Calls')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(2,1,'In Bound & Outbound Phone Calls','In Bound & Outbound Phone Calls')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(2,2,'In Bound & Outbound Phone Calls','In Bound & Outbound Phone Calls')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(2,3,'In Bound & Outbound Phone Calls','In Bound & Outbound Phone Calls')
*/

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetUserDesignations' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetUserDesignations
  END
Go
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	GetUserDesignations
	GetUserDesignations 1
*/
CREATE PROCEDURE GetUserDesignations
	@Id Int = Null
AS    
BEGIN
	If @Id Is Null
		Begin
			Select Id, DesignationName, IsActive, DepartmentId, DesignationCode 
				From tbl_Designation D With(NoLock) Where D.IsActive = 1
		End
	Else
		Begin
			Select Id, DesignationName, IsActive, DepartmentId, DesignationCode 
			From tbl_Designation D With(NoLock) Where D.IsActive = 1 And D.Id = @Id
		End
End

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'sp_GetHrData' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE sp_GetHrData
  END
Go
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================     
-- [sp_GetHrData] '','0',0,0, 0, NULL, NULL,0,20, 'CreatedDateTime DESC','5','9','6','1'    
Create PROCEDURE [dbo].[sp_GetHrData]    
 @SearchTerm VARCHAR(15) = NULL, @Status VARCHAR(50), @DesignationId INT, @SourceId INT, @AddedByUserId INT, @FromDate DATE = NULL,    
 @ToDate DATE = NULL, @PageIndex INT = NULL,  @PageSize INT = NULL, @SortExpression VARCHAR(50), @InterviewDateStatus VARChAR(5) = '5',    
 @RejectedStatus VARChAR(5) = '9', @OfferMadeStatus VARChAR(5) = '6', @ActiveStatus VARChAR(5) = '1'     
AS    
BEGIN     
SET NOCOUNT ON;    
    
 IF @Status = '0'    
 BEGIN    
  SET @Status = NULL    
 END    
 IF @DesignationId = '0'    
 BEGIN    
  SET @DesignationId = NULL    
 END    
 IF @SourceId = '0'    
 BEGIN    
  SET @SourceId = NULL    
 END    
 IF @AddedByUserId = 0    
 BEGIN    
  SET @AddedByUserId = NULL    
 END    
     
 SET @PageIndex = isnull(@PageIndex,0)    
 SET @PageSize = isnull(@PageSize,0)    
     
 DECLARE @StartIndex INT  = 0    
 SET @StartIndex = (@PageIndex * @PageSize) + 1    
      
  -- get statistics (Status) - Table 0     
  SELECT t.Status, COUNT(*) [Count]    
  FROM tblInstallUsers t     
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser    
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id    
   WHERE     
  (t.UserType = 'SalesUser' OR t.UserType = 'sales')    
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)     
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)    
 GROUP BY t.status    
    
 -- get statistics (AddedBy) - Table 1    
 SELECT ISNULL(U.Username, t2.FristName + '' + t2.LastName)  AS AddedBy, COUNT(*) [Count]     
 FROM tblInstallUsers t    
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser    
   LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser    
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id    
   LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id    
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales')    
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)    
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)    
 GROUP BY U.Username,t2.FristName,t2.LastName    
    
 -- get statistics (Designation) - Table 2    
 SELECT t.Designation, COUNT(*) [Count]     
 FROM tblInstallUsers t    
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser    
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id    
   LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id    
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales')    
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)    
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)    
 GROUP BY t.Designation    
    
 -- get statistics (Source) - Table 3    
 SELECT t.Source, COUNT(*) [Count]    
 FROM tblInstallUsers t    
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser    
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id    
   LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id    
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales')    
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)    
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)    
 GROUP BY t.Source    
    
 -- get records - Table 4
 ;WITH SalesUsers    
 AS    
 (SELECT t.Id, t.FristName, t.LastName, t.Phone, t.Zip, t.City, d.DesignationName AS Designation, t.Status, t.HireDate, t.InstallId,    
 t.picture, t.CreatedDateTime, Isnull(s.Source,'') AS Source, t.SourceUser, ISNULL(U.Username,t2.FristName + ' ' + t2.LastName)    
 AS AddedBy, ISNULL (t.UserInstallId,t.id) As UserInstallId,    
 InterviewDetail = case when (t.Status=@InterviewDateStatus) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR)  + ' ' + coalesce(t.InterviewTime,'')     
       else '' end,    
 RejectDetail = case when (t.[Status]=@RejectedStatus ) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR) + ' ' + coalesce(t.RejectionTime,'')     
       else '' end,    
 CASE when (t.[Status]= @RejectedStatus ) THEN t.RejectedUserId ELSE NULL END AS RejectedUserId,    
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.FristName + ' ' + ru.LastName ELSE NULL END AS RejectedByUserName,    
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.[UserInstallId]  ELSE NULL END AS RejectedByUserInstallId,    
 t.Email, t.DesignationID, ISNULL(t1.[UserInstallId], t2.[UserInstallId]) As AddedByUserInstallId,    
 ISNULL(t1.Id,t2.Id) As AddedById, t.emptype as 'EmpType', t.Phone As PrimaryPhone, t.CountryCode, t.Resumepath,    
 --ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId,    
 /*Task.TaskId AS 'TechTaskId', Task.ParentTaskId AS 'ParentTechTaskId', Task.InstallId as 'TechTaskInstallId'*/  
 0 AS 'TechTaskId', 0 AS 'ParentTechTaskId', '' as 'TechTaskInstallId'  
 , bm.bookmarkedUser,    
 t.[StatusReason], dbo.udf_GetUserExamPercentile(t.Id) AS [Aggregate],    
 ROW_NUMBER() OVER(ORDER BY    
   CASE WHEN @SortExpression = 'Id ASC' THEN t.Id END ASC,    
   CASE WHEN @SortExpression = 'Id DESC' THEN t.Id END DESC,    
   CASE WHEN @SortExpression = 'Status ASC' THEN t.Status END ASC,    
   CASE WHEN @SortExpression = 'Status DESC' THEN t.Status END DESC,    
   CASE WHEN @SortExpression = 'FristName ASC' THEN t.FristName END ASC,    
   CASE WHEN @SortExpression = 'FristName DESC' THEN t.FristName END DESC,    
   CASE WHEN @SortExpression = 'Designation ASC' THEN d.DesignationName END ASC,    
   CASE WHEN @SortExpression = 'Designation DESC' THEN d.DesignationName END DESC,    
   CASE WHEN @SortExpression = 'Source ASC' THEN s.Source END ASC,    
   CASE WHEN @SortExpression = 'Source DESC' THEN s.Source END DESC,    
   CASE WHEN @SortExpression = 'Phone ASC' THEN t.Phone END ASC,    
   CASE WHEN @SortExpression = 'Phone DESC' THEN t.Phone END DESC,    
   CASE WHEN @SortExpression = 'Zip ASC' THEN t.Phone END ASC,    
   CASE WHEN @SortExpression = 'Zip DESC' THEN t.Phone END DESC,     
   CASE WHEN @SortExpression = 'City ASC' THEN t.City END ASC,    
   CASE WHEN @SortExpression = 'City DESC' THEN t.City END DESC,     
   CASE WHEN @SortExpression = 'CreatedDateTime ASC' THEN t.CreatedDateTime END ASC,    
   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN t.CreatedDateTime END DESC     
       ) AS RowNumber,    
    '' as Country    
  FROM tblInstallUsers t    
  LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser    
  LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser    
  LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId= ru.Id    
  LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id    
  LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id    
  LEFT JOIN tblSource s ON t.SourceId = s.Id    
  left outer join InstallUserBMLog as bm on t.id  =bm.bookmarkedUser and bm.isDeleted=0    
  OUTER APPLY    
 (     
 SELECT tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo    
 FROM tblTaskAssignedUsers u    
 INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND    
 (tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1)    
 WHERE u.UserId = t.Id    
 ) AS Task    
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') AND (@SearchTerm IS NULL OR     
    1 = CASE WHEN t.InstallId LIKE ''+ @SearchTerm + '%' THEN 1    
  WHEN t.FristName LIKE ''+ @SearchTerm + '%' THEN 1    
  WHEN t.LastName LIKE ''+ @SearchTerm + '%' THEN 1    
  WHEN t.Email LIKE ''+ @SearchTerm + '%' THEN 1    
  WHEN t.Phone LIKE ''+ @SearchTerm + '%' THEN 1    
  WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1    
  WHEN t.Zip LIKE ''+ @SearchTerm + '%' THEN 1    
  WHEN t.City LIKE ''+ @SearchTerm + '%' THEN 1    
  ELSE 0    
  END    
  )    
 AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))    
 AND t.Status NOT IN (@OfferMadeStatus, @ActiveStatus)    
 AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))    
 AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))    
 --AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))    
 AND ISNULL(t1.Id,t2.Id)=ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id))    
 AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)    
 AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)    
)    
SELECT  Id, FristName, LastName, Phone, Zip, Designation, Status, HireDate, InstallId, picture, CreatedDateTime, Source, SourceUser,    
AddedBy, UserInstallId, InterviewDetail, RejectDetail, RejectedUserId, RejectedByUserName, RejectedByUserInstallId, Email, DesignationID,    
AddedByUserInstallId, AddedById, EmpType, [Aggregate], PrimaryPhone, CountryCode, Resumepath, TechTaskId, ParentTechTaskId,    
TechTaskInstallId, bookmarkedUser,  [StatusReason], Country, City    
FROM SalesUsers    
WHERE RowNumber >= @StartIndex AND (@PageSize = 0 OR RowNumber < (@StartIndex + @PageSize))    
group by Id, FristName, LastName, Phone, Zip, Designation, Status, HireDate, InstallId, picture, CreatedDateTime, Source, SourceUser,    
AddedBy, UserInstallId, InterviewDetail, RejectDetail, RejectedUserId, RejectedByUserName, RejectedByUserInstallId, Email, DesignationID,    
AddedByUserInstallId, AddedById, EmpType, [Aggregate], PrimaryPhone, CountryCode, Resumepath, TechTaskId, ParentTechTaskId,    
TechTaskInstallId, bookmarkedUser,  [StatusReason], Country, City    
ORDER BY CASE WHEN @SortExpression = 'Id ASC' THEN Id END ASC,    
   CASE WHEN @SortExpression = 'Id DESC' THEN Id END DESC,    
   CASE WHEN @SortExpression = 'Status ASC' THEN Status END ASC,    
   CASE WHEN @SortExpression = 'Status DESC' THEN Status END DESC,    
   CASE WHEN @SortExpression = 'FristName ASC' THEN FristName END ASC,    
   CASE WHEN @SortExpression = 'FristName DESC' THEN FristName END DESC,    
   CASE WHEN @SortExpression = 'Designation ASC' THEN Designation END ASC,    
   CASE WHEN @SortExpression = 'Designation DESC' THEN Designation END DESC,    
   CASE WHEN @SortExpression = 'Source ASC' THEN Source END ASC,    
   CASE WHEN @SortExpression = 'Source DESC' THEN Source END DESC,    
   CASE WHEN @SortExpression = 'Phone ASC' THEN Phone END ASC,    
   CASE WHEN @SortExpression = 'Phone DESC' THEN Phone END DESC,    
   CASE WHEN @SortExpression = 'Zip ASC' THEN Phone END ASC,    
   CASE WHEN @SortExpression = 'Zip DESC' THEN Phone END DESC,    
   CASE WHEN @SortExpression = 'CreatedDateTime ASC' THEN CreatedDateTime END ASC,    
   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN CreatedDateTime END DESC    
    
 -- get record count - Table 5    
 SELECT COUNT(*) AS TotalRecordCount    
 FROM tblInstallUsers t    
 LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser    
 LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id    
 LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id    
 LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id    
 LEFT JOIN tblSource s ON t.SourceId = s.Id    
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') AND (@SearchTerm IS NULL OR    
   1 = CASE WHEN t.InstallId LIKE ''+ @SearchTerm + '%' THEN 1    
    WHEN t.FristName LIKE ''+ @SearchTerm + '%' THEN 1    
    WHEN t.LastName LIKE ''+ @SearchTerm + '%' THEN 1    
    WHEN t.Email LIKE ''+ @SearchTerm + '%' THEN 1    
    WHEN t.Phone LIKE ''+ @SearchTerm + '%' THEN 1    
    WHEN t.CountryCode LIKE ''+ @SearchTerm + '%' THEN 1    
    WHEN t.Zip LIKE ''+ @SearchTerm + '%' THEN 1    
    ELSE 0 END)    
  AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))    
  AND t.Status NOT IN (@OfferMadeStatus, @ActiveStatus)    
  AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))    
  AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))    
  AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))    
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)    
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)    
    
  -- Get the Total Count - Table 6    
   SELECT Count(*) as TCount    
  FROM tblInstallUsers t    
  LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser    
  LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser    
  LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId= ru.Id    
  LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id    
  LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id    
  LEFT JOIN tblSource s ON t.SourceId = s.Id    
  left outer join InstallUserBMLog as bm on t.id  =bm.bookmarkedUser and bm.isDeleted=0    
  OUTER APPLY(    SELECT TOP 1 tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo    
  FROM tblTaskAssignedUsers u    
  INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND (tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1)    
  WHERE u.UserId = t.Id    
   ) AS Task    
  WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') AND (@SearchTerm IS NULL OR    
    1 = CASE WHEN t.InstallId LIKE ''+ @SearchTerm + '%' THEN 1    
  WHEN t.FristName LIKE ''+ @SearchTerm + '%' THEN 1    
  WHEN t.LastName LIKE ''+ @SearchTerm + '%' THEN 1    
  WHEN t.Email LIKE ''+ @SearchTerm + '%' THEN 1    
  WHEN t.Phone LIKE ''+ @SearchTerm + '%' THEN 1    
  WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1    
  WHEN t.Zip LIKE ''+ @SearchTerm + '%' THEN 1    
  WHEN t.City LIKE ''+ @SearchTerm + '%' THEN 1    
  ELSE 0 END)    
   AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))    
   AND t.Status NOT IN (@OfferMadeStatus, @ActiveStatus)    
   AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))    
   AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))    
   --AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))    
   AND ISNULL(t1.Id,t2.Id)=ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id))    
   AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)    
   AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)    
       
     -- Get the Total Count - Table 7    
	IF OBJECT_ID('tempdb..#TempUserIds') IS NOT NULL DROP TABLE #TempUserIds
		Create Table #TempUserIds(Id int)
	
  ;WITH SalesUsers    
 AS    
 (SELECT t.Id, t.FristName, t.LastName, t.Phone, t.Zip, t.City, d.DesignationName AS Designation, t.Status, t.HireDate, t.InstallId,    
 t.picture, t.CreatedDateTime, Isnull(s.Source,'') AS Source, t.SourceUser, ISNULL(U.Username,t2.FristName + ' ' + t2.LastName)    
 AS AddedBy, ISNULL (t.UserInstallId,t.id) As UserInstallId,    
 InterviewDetail = case when (t.Status=@InterviewDateStatus) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR)  + ' ' + coalesce(t.InterviewTime,'')     
       else '' end,    
 RejectDetail = case when (t.[Status]=@RejectedStatus ) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR) + ' ' + coalesce(t.RejectionTime,'')     
       else '' end,    
 CASE when (t.[Status]= @RejectedStatus ) THEN t.RejectedUserId ELSE NULL END AS RejectedUserId,    
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.FristName + ' ' + ru.LastName ELSE NULL END AS RejectedByUserName,    
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.[UserInstallId]  ELSE NULL END AS RejectedByUserInstallId,    
 t.Email, t.DesignationID, ISNULL(t1.[UserInstallId], t2.[UserInstallId]) As AddedByUserInstallId,    
 ISNULL(t1.Id,t2.Id) As AddedById, t.emptype as 'EmpType', t.Phone As PrimaryPhone, t.CountryCode, t.Resumepath,    
 --ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId,    
 /*Task.TaskId AS 'TechTaskId', Task.ParentTaskId AS 'ParentTechTaskId', Task.InstallId as 'TechTaskInstallId'*/  
 0 AS 'TechTaskId', 0 AS 'ParentTechTaskId', '' as 'TechTaskInstallId'  
 , bm.bookmarkedUser,    
 t.[StatusReason], dbo.udf_GetUserExamPercentile(t.Id) AS [Aggregate],    
 ROW_NUMBER() OVER(ORDER BY    
   CASE WHEN @SortExpression = 'Id ASC' THEN t.Id END ASC,    
   CASE WHEN @SortExpression = 'Id DESC' THEN t.Id END DESC,    
   CASE WHEN @SortExpression = 'Status ASC' THEN t.Status END ASC,    
   CASE WHEN @SortExpression = 'Status DESC' THEN t.Status END DESC,    
   CASE WHEN @SortExpression = 'FristName ASC' THEN t.FristName END ASC,    
   CASE WHEN @SortExpression = 'FristName DESC' THEN t.FristName END DESC,    
   CASE WHEN @SortExpression = 'Designation ASC' THEN d.DesignationName END ASC,    
   CASE WHEN @SortExpression = 'Designation DESC' THEN d.DesignationName END DESC,    
   CASE WHEN @SortExpression = 'Source ASC' THEN s.Source END ASC,    
   CASE WHEN @SortExpression = 'Source DESC' THEN s.Source END DESC,    
   CASE WHEN @SortExpression = 'Phone ASC' THEN t.Phone END ASC,    
   CASE WHEN @SortExpression = 'Phone DESC' THEN t.Phone END DESC,    
   CASE WHEN @SortExpression = 'Zip ASC' THEN t.Phone END ASC,    
   CASE WHEN @SortExpression = 'Zip DESC' THEN t.Phone END DESC,     
   CASE WHEN @SortExpression = 'City ASC' THEN t.City END ASC,    
   CASE WHEN @SortExpression = 'City DESC' THEN t.City END DESC,     
   CASE WHEN @SortExpression = 'CreatedDateTime ASC' THEN t.CreatedDateTime END ASC,    
   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN t.CreatedDateTime END DESC     
       ) AS RowNumber,    
    '' as Country    
  FROM tblInstallUsers t    
  LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser    
  LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser    
  LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId= ru.Id    
  LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id    
  LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id    
  LEFT JOIN tblSource s ON t.SourceId = s.Id    
  left outer join InstallUserBMLog as bm on t.id  =bm.bookmarkedUser and bm.isDeleted=0    
  OUTER APPLY    
 (     
 SELECT tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo    
 FROM tblTaskAssignedUsers u    
 INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND    
 (tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1)    
 WHERE u.UserId = t.Id    
 ) AS Task    
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') AND (@SearchTerm IS NULL OR     
    1 = CASE WHEN t.InstallId LIKE ''+ @SearchTerm + '%' THEN 1    
  WHEN t.FristName LIKE ''+ @SearchTerm + '%' THEN 1    
  WHEN t.LastName LIKE ''+ @SearchTerm + '%' THEN 1    
  WHEN t.Email LIKE ''+ @SearchTerm + '%' THEN 1    
  WHEN t.Phone LIKE ''+ @SearchTerm + '%' THEN 1    
  WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1    
  WHEN t.Zip LIKE ''+ @SearchTerm + '%' THEN 1    
  WHEN t.City LIKE ''+ @SearchTerm + '%' THEN 1    
  ELSE 0    
  END    
  )    
 AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))    
 AND t.Status NOT IN (@OfferMadeStatus, @ActiveStatus)    
 AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))    
 AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))    
 --AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))    
 AND ISNULL(t1.Id,t2.Id)=ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id))    
 AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)    
 AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)    
)    
Insert Into #TempUserIds SELECT  Id   
FROM SalesUsers    
WHERE RowNumber >= @StartIndex AND (@PageSize = 0 OR RowNumber < (@StartIndex + @PageSize))    
group by Id, FristName, LastName, Phone, Zip, Designation, Status, HireDate, InstallId, picture, CreatedDateTime, Source, SourceUser,    
AddedBy, UserInstallId, InterviewDetail, RejectDetail, RejectedUserId, RejectedByUserName, RejectedByUserInstallId, Email, DesignationID,    
AddedByUserInstallId, AddedById, EmpType, [Aggregate], PrimaryPhone, CountryCode, Resumepath, TechTaskId, ParentTechTaskId,    
TechTaskInstallId, bookmarkedUser,  [StatusReason], Country, City    
ORDER BY CASE WHEN @SortExpression = 'Id ASC' THEN Id END ASC,    
   CASE WHEN @SortExpression = 'Id DESC' THEN Id END DESC,    
   CASE WHEN @SortExpression = 'Status ASC' THEN Status END ASC,    
   CASE WHEN @SortExpression = 'Status DESC' THEN Status END DESC,    
   CASE WHEN @SortExpression = 'FristName ASC' THEN FristName END ASC,    
   CASE WHEN @SortExpression = 'FristName DESC' THEN FristName END DESC,    
   CASE WHEN @SortExpression = 'Designation ASC' THEN Designation END ASC,    
   CASE WHEN @SortExpression = 'Designation DESC' THEN Designation END DESC,    
   CASE WHEN @SortExpression = 'Source ASC' THEN Source END ASC,    
   CASE WHEN @SortExpression = 'Source DESC' THEN Source END DESC,    
   CASE WHEN @SortExpression = 'Phone ASC' THEN Phone END ASC,    
   CASE WHEN @SortExpression = 'Phone DESC' THEN Phone END DESC,    
   CASE WHEN @SortExpression = 'Zip ASC' THEN Phone END ASC,    
   CASE WHEN @SortExpression = 'Zip DESC' THEN Phone END DESC,    
   CASE WHEN @SortExpression = 'CreatedDateTime ASC' THEN CreatedDateTime END ASC,    
   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN CreatedDateTime END DESC    
    
	Select E.* From #TempUserIds T Join tblUserEmail E On T.Id = E.UserID

   -- Get the Total Count - Table 8    
  Select P.* From #TempUserIds T Join tblUserPhone P On T.Id = P.UserID
    
    
  -- Get Notes from tblUserNotes - Table 9    
--  SELECT I.FristName+' - '+CAST(I.ID as varchar) as [AddedBy],N.AddedOn,N.Notes, N.UserID from tblInstallUsers I INNER JOIN tblUserNotes N ON    
--(I.ID = N.UserID)    
    
 SELECt UserTouchPointLogID , UserID, UpdatedByUserID, UpdatedUserInstallID, replace(LogDescription,'Note : ','') LogDescription, CurrentUserGUID,    
 CONVERT(VARCHAR,ChangeDateTime,101) + ' ' + convert(varchar, ChangeDateTime, 108) as CreatedDate    
 FROM tblUserTouchPointLog n WITH (NOLOCK)    
 --inner join tblinstallusers I on I.id=n.userid    
 where isnull(UserId,0)>0 and LogDescription like 'Note :%'    
 order by ChangeDateTime desc    
END  
  