-- =============================================            
-- Author: Kapil Pancholi
-- Create date: 12/7/2017
-- Updated By: Kapil Pancholi   
-- Updated date: 12/7/2017
-- Description: SP_GetInstallUsers            
--[dbo].[SP_GetInstallUsersWithStatus] 2,'10',''
-- =============================================            
alter PROCEDURE [dbo].[SP_GetInstallUsersWithStatus]
 @Key int,          
 @Designations varchar(4000),        
 @UserStatus varchar(500)            
AS            
BEGIN            
IF @UserStatus = ''
BEGIN
	SET @UserStatus = null
END        
 IF @Key = 1          
 BEGIN        
  SELECT        
   DISTINCT(Designation) AS Designation         
  FROM tblinstallUsers         
  WHERE Designation IS NOT NULL             
  ORDER BY Designation        
 END        
 ELSE IF @Key = 2          
 BEGIN        
 IF @Designations = ''  
 BEGIN  
 SELECT FristName + ' ' + ISNULL(NameMiddleInitial + '. ','') + LastName + ' - ' + ISNULL(UserInstallId,'') as FristName,Id , [Status],ISNULL(UserInstallId,'') as  UserInstallId        
  FROM tblinstallUsers         
  WHERE          
   (FristName IS NOT NULL AND RTRIM(LTRIM(FristName)) <> '' )  AND         
   (        
    tblinstallUsers.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,tblinstallUsers.[Status]),','))
   )        
  ORDER BY CASE WHEN [Status] = '1' THEN 1 ELSE 2 END, [Status], DesignationID ,FristName + ' ' + LastName        
 END  
 ELSE  
 BEGIN  
  SELECT FristName + ' ' + ISNULL(NameMiddleInitial + '. ','') + LastName + ' - ' + ISNULL(UserInstallId,'') as FristName,Id , [Status],ISNULL(UserInstallId,'') as  UserInstallId        
  FROM tblinstallUsers         
  WHERE          
   (FristName IS NOT NULL AND RTRIM(LTRIM(FristName)) <> '' )  AND         
   (        
    tblinstallUsers.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,tblinstallUsers.[Status]),','))
   ) AND         
   (        
    Designation IN (SELECT Item FROM dbo.SplitString(@Designations,','))        
    OR        
    Convert(Nvarchar(max),DesignationID)  IN (SELECT Item FROM dbo.SplitString(@Designations,','))        
   )        
  ORDER BY CASE WHEN [Status] = '1' THEN 1 ELSE 2 END, [Status], DesignationID ,FristName + ' ' + LastName        
  END  
 END        
END 
GO

ALTER PROCEDURE [dbo].[usp_GetAllInProAssReqTaskWithSequence]                           
(                          
                         
 @PageIndex INT = 0,                             
 @PageSize INT = 20,                      
 @DesignationIds VARCHAR(200) = NULL,                                 
 @TaskStatus VARCHAR(100) = NULL,
 @UserStatus VARCHAR(100) = NULL,    
 @StartDate datetime = NULL,    
 @EndDate datetime = NULL,
 @UserIds varchar(100) = NULL
)                          
As                          
BEGIN                          
                    
                    
IF @StartDate=''  
BEGIN  
SET @StartDate = (SELECT TOP 1 CreatedOn FROM tblTask ORDER BY TASKID ASC)  
END  
  
IF @EndDate = ''  
BEGIN  
 SET @EndDate = (SELECT TOP 1 CreatedOn FROM tblTask ORDER BY TASKID DESC)  
END  
  
IF( @DesignationIds = '' )                    
BEGIN                    
                    
 SET @DesignationIds = NULL                    
                    
END
IF( @TaskStatus = '' )                    
BEGIN                    
                    
 SET @TaskStatus = NULL                    
                    
END
IF( @UserStatus = '' )                    
BEGIN                    
                    
 SET @UserStatus = NULL                    
                    
END
IF( @UserIds = '' )                    
BEGIN                    
                    
 SET @UserIds = NULL                    
                    
END 
                          
;WITH                           
 Tasklist AS                          
 (                           
  SELECT DISTINCT TaskId ,[Status],[SequenceDesignationId],[Sequence], [SubSequence],                        
  Title,ParentTaskId,IsTechTask,ParentTaskTitle,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  TaskDesignation,          
  [AdminStatus] , [TechLeadStatus], [OtherUserStatus],[AdminStatusUpdated],[TechLeadStatusUpdated],[OtherUserStatusUpdated],[AdminUserId],[TechLeadUserId],[OtherUserId],           
  AdminUserInstallId, AdminUserFirstName, AdminUserLastName,          
  TechLeadUserInstallId,ITLeadHours,UserHours, TechLeadUserFirstName, TechLeadUserLastName,          
  OtherUserInstallId, OtherUserFirstName,OtherUserLastName,TaskAssignedUserIDs,CreatedOn,          
  case                           
   when (ParentTaskId is null and  TaskLevel=1) then InstallId                           
   when (tasklevel =1 and ParentTaskId>0) then                           
    (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId                            
   when (tasklevel =2 and ParentTaskId>0) then                          
    (select InstallId from tbltask where taskid in (                          
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                          
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                           
                               
   when (tasklevel =3 and ParentTaskId>0) then                          
   (select InstallId from tbltask where taskid in (                          
   (select parenttaskid from tbltask where taskid in (                          
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))                          
   +'-'+                          
    (select InstallId from tbltask where taskid in (                          
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                          
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                           
  end as 'InstallId' ,Row_number() OVER (order by x.TaskId ) AS RowNo_Order                          
  from (                          
   select DISTINCT a.*                          
   ,(select Title from tbltask where TaskId=(select * from [GetParent](a.TaskId))) AS ParentTaskTitle,          
   (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.TechLeadUserId) AS ITLeadHours , (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.OtherUserId) AS UserHours,         


 
   ta.InstallId AS AdminUserInstallId, ta.FristName AS AdminUserFirstName, ta.LastName AS AdminUserLastName,          
   tT.InstallId AS TechLeadUserInstallId, tT.FristName AS TechLeadUserFirstName, tT.LastName AS TechLeadUserLastName,          
   tU.InstallId AS OtherUserInstallId, tU.FristName AS OtherUserFirstName, tU.LastName AS OtherUserLastName,          
   --,t.FristName + ' ' + t.LastName AS Assigneduser,                        
   (                        
   STUFF((SELECT ', {"Name": "' + Designation +'","Id":'+ CONVERT(VARCHAR(5),DesignationID)+'}'                      
           FROM tblTaskdesignations td                         
           WHERE td.TaskID = a.TaskId                         
          FOR XML PATH('')), 1, 2, '')                        
  )  AS TaskDesignation,      
  (      
    STUFF((SELECT ', {"Id" : "'+ CONVERT(VARCHAR(5),UserId) + '"}'                      
           FROM tbltaskassignedusers as tau      
           WHERE tau.TaskId = a.TaskId                         
          FOR XML PATH('')), 1, 2, '')                        
  ) AS TaskAssignedUserIDs               
  --(SELECT TOP 1 DesignationID                       
  --         FROM tblTaskdesignations td                         
  --         WHERE td.TaskID = a.TaskId ) AS DesignationId                       
   from  tbltask a                          
   --LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId                           
   --LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId                          
   LEFT OUTER JOIN tblInstallUsers as ta ON a.[AdminUserId] = ta.Id           
   LEFT OUTER JOIN tblInstallUsers as tT ON a.[TechLeadUserId] = tT.Id           
   LEFT OUTER JOIN tblInstallUsers as tU ON a.[OtherUserId] = tU.Id       
   JOIN tbltaskassignedusers as tau ON a.TaskId = tau.TaskId  
   JOIN tblInstallUsers as iu ON tau.[UserId] = iu.[Id]  
  -- LEFT OUTER JOIN tbltaskassignedusers as tau ON a.TaskId = tau.TaskId                          
   WHERE                     
  (                   
    (a.[Sequence] IS NOT NULL)                      
    AND (a.[SequenceDesignationId] IN (SELECT * FROM [dbo].[SplitString](ISNULL(@DesignationIds,a.[SequenceDesignationId]),',') ) )                         
 AND a.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@TaskStatus,a.[Status]),','))  
 AND iu.[Status] in( SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,iu.[Status]),','))  
 AND iu.[Id] in ( SELECT * FROM [dbo].[SplitString](ISNULL(@UserIds,iu.[Id]),','))  
 AND CreatedOn between @StartDate and @EndDate  
   )                     
                        
   --and (CreatedOn >=@startdate and CreatedOn <= @enddate )                           
  ) as x                          
 )                
                          
 ---- get CTE data into temp table                          
 SELECT *                          
 INTO #Tasks                          
 FROM Tasklist                          
                    
---- find page number to show taskid sent.                    
DECLARE @StartIndex INT  = 0                          
                    
                          
--IF @HighLightedTaskID  > 0                    
-- BEGIN                    
--  DECLARE @RowNumber BIGINT = NULL                    
                    
--  -- Find in which rownumber highlighter taskid is.                    
--  SELECT @RowNumber = RowNo_Order                     
--  FROM #Tasks                     
--  WHERE TaskId = @HighLightedTaskID                    
                    
--  -- if row number found then divide it with page size and round it to nearest integer , so will found pagenumber to be selected.                    
--  -- for ex. if total 60 records are there,pagesize is 20 and highlighted task id is at 42 row number than.                     
--  -- 42/20 = 2.1 ~ 3 - 1 = 2 = @Page Index                    
--  -- StartIndex = (2*20)+1 = 41, so records 41 to 60 will be fetched.                    
                       
--  IF @RowNumber IS NOT NULL                    
--  BEGIN                    
--   SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1                    
--  END                    
-- END                      
                    
 -- Set start index to fetch record.                    
 SET @StartIndex = (@PageIndex * @PageSize) + 1                          
                     
 ----missing rows bug solution BEGIN: kapil pancholi  
 --create temp table for Sequences  
 CREATE TABLE #S (TASKID INT, ROW_ID INT,[SEQUENCE] INT, [Status] INT)  
   
 INSERT INTO #S (TASKID,ROW_ID,[SEQUENCE],[Status])   
 SELECT TASKID, Row_Number() over (order by [Sequence]),[SEQUENCE],[Status] FROM #TASKS WHERE SubSequence IS NULL  
  
 update #Tasks set #Tasks.RowNo_Order = #S.ROW_ID  
 from #Tasks,#S  
 where #Tasks.TaskId=#S.TASKID  
  
 --create temp table for SubSequences  
 CREATE TABLE #SS (TASKID INT, ROW_ID INT,[SUB_SEQUENCE] INT,[Status] INT)  
   
 INSERT INTO #SS (TASKID,ROW_ID,[SUB_SEQUENCE],[Status])   
 SELECT TASKID, Row_Number() over (order by [SUBSEQUENCE]),[SUBSEQUENCE],[Status] FROM #TASKS WHERE SubSequence IS NOT NULL  
  
 update #Tasks set #Tasks.RowNo_Order = #SS.ROW_ID  
 from #Tasks,#SS  
 where #Tasks.TaskId=#SS.TASKID  
 ----missing rows bug solution END: kapil pancholi  
  
 -- fetch parent sequence records from temptable                    
 SELECT *                           
 FROM #Tasks                           
 WHERE                           
 (RowNo_Order >= @StartIndex AND                           
 (                          
  @PageSize = 0 OR                           
  RowNo_Order < (@StartIndex + @PageSize)                          
 ))        
 AND SubSequence IS NULL        
 --ORDER BY  [Sequence]  DESC                        
ORDER BY CASE [Status]   
    WHEN 4 THEN 1   
    WHEN 3 THEN 2   
    WHEN 2 THEN 3   
 WHEN 1 THEN 4  
 WHEN 8 THEN 5  
    END   
        
 -- fetch sub sequence records from temptable                    
 SELECT *                           
 FROM #Tasks                           
 WHERE                           
 (RowNo_Order >= @StartIndex AND                           
 (                          
  @PageSize = 0 OR                           
  RowNo_Order < (@StartIndex + @PageSize)                          
 ))        
 AND                 
 SubSequence IS NOT NULL        
 --ORDER BY  [Sequence]  DESC                        
ORDER BY CASE [Status]   
    WHEN 4 THEN 1   
    WHEN 3 THEN 2   
    WHEN 2 THEN 3   
 WHEN 1 THEN 4  
 WHEN 8 THEN 5  
    END   
        
        
 --or                
 --(                
 -- TaskId = @HighLightedTaskID            
 --)                          
 --ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC                        
                          
 -- fetch other statistics, total records, total pages, pageindex to highlighted.                         
 SELECT                          
 COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex                         
  FROM #Tasks  WHERE SubSequence IS NULL                   
                    
 DROP TABLE #Tasks                    
 DROP TABLE #S      
 DROP TABLE #SS   
                        
END   

GO


ALTER PROCEDURE [dbo].[GetClosedTasks] 
	-- Add the parameters for the stored procedure here
	--@userid int,
	@userid nvarchar(MAX)='0',
	@desigid nvarchar(MAX)='',
	@TaskStatus VARCHAR(100) = NULL,
	@UserStatus VARCHAR(100) = NULL,    
	@search varchar(100),
	@PageIndex INT, 
	@PageSize INT
AS
BEGIN
DECLARE @StartIndex INT  = 0
IF( @TaskStatus = '' )                    
BEGIN                    
                    
 SET @TaskStatus = NULL                    
                    
END
IF( @UserStatus = '' )                    
BEGIN                    
                    
 SET @UserStatus = NULL                    
                    
END
IF( @userid = '' )                    
BEGIN                    
                    
 SET @userid = NULL                    
                    
END 

SET @StartIndex = (@PageIndex * @PageSize) + 1

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @str nvarchar(700)
	set @str = ''
	if @search<>''
		begin
			;WITH 
		Tasklist AS
		(
			select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,Assigneduser,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,
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
			end as 'InstallId',Row_number() OVER (  ORDER BY CASE [Status] 
													WHEN 12 THEN 1 
													WHEN 11 THEN 2 
													WHEN 7 THEN 3 
													WHEN 14 THEN 4
													WHEN 9 THEN 5

																WHEN 10 THEN 6
													WHEN 8 THEN 7
													WHEN 6 THEN 8
													WHEN 5 THEN 9
													WHEN 4 THEN 10
													WHEN 3 THEN 11
													WHEN 2 THEN 12
													WHEN 1 THEN 13
													END ) 
													AS RowNo_Order
			from (

			SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],a.InstallId ,ParentTaskId,TaskLevel,t.FristName + ' ' + t.LastName AS Assigneduser
			from dbo.tblTask as a
			Left Join tbltaskassignedusers as b ON a.TaskId=b.TaskId
				Left Join tblInstallUsers as t ON b.UserId=t.Id
			--where a.[Status]  in (7,8,9,10,11,12,14)
			where a.[Status]  in (SELECT * FROM [dbo].[SplitString](ISNULL(@TaskStatus,a.[Status]),','))			
			AND t.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,t.[Status]),','))
			AND  (
			t.FristName LIKE '%'+ @search + '%'  or
			t.LastName LIKE '%'+ @search + '%'  or
			t.Email LIKE '%' + @search +'%'  
			) 
			and parenttaskid is not null
			) as x
			)
			
		SELECT *
		INTO #temp1
		FROM Tasklist

			SELECT
			*
			FROM #temp1
			WHERE 
			RowNo_Order >= @StartIndex AND 
			(
				@PageSize = 0 OR 
				RowNo_Order < (@StartIndex + @PageSize)
			)

		SELECT
		COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex 
		FROM #temp1

		end
   else if @userid='0' and @desigid=''
		begin
		;WITH 
		Tasklist AS
		(
			select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,Assigneduser,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,
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
			end as 'InstallId',Row_number() OVER (  ORDER BY CASE [Status] 
													WHEN 12 THEN 1 
													WHEN 11 THEN 2 
													WHEN 7 THEN 3 
													WHEN 14 THEN 4
													WHEN 9 THEN 5

																WHEN 10 THEN 6
													WHEN 8 THEN 7
													WHEN 6 THEN 8
													WHEN 5 THEN 9
													WHEN 4 THEN 10
													WHEN 3 THEN 11
													WHEN 2 THEN 12
													WHEN 1 THEN 13
													END ) 
													AS RowNo_Order
			from (
			SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],a.InstallId,ParentTaskId,TaskLevel,t.FristName + ' ' + t.LastName AS Assigneduser
			from dbo.tblTask  as a
			LEFT OUTER JOIN tbltaskassignedusers as b ON a.TaskId = b.TaskId
			LEFT OUTER JOIN tblInstallUsers as t ON t.Id = b.UserId
			where a.[Status]  in (SELECT * FROM [dbo].[SplitString](ISNULL(@TaskStatus,a.[Status]),','))			
			AND t.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,t.[Status]),','))
			
			and a.parenttaskid is not null
			)  as x 
			)

			
		SELECT *
		INTO #temp2
		FROM Tasklist

			SELECT
			*
			FROM #temp2
			WHERE 
			RowNo_Order >= @StartIndex AND 
			(
				@PageSize = 0 OR 
				RowNo_Order < (@StartIndex + @PageSize)
			)
			
			
		SELECT
		COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex 
		FROM #temp2

		end
	else if @userid<>'0'  
		begin
			;WITH 
		Tasklist AS
		(
			select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,Assigneduser,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,
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
			end as 'InstallId',Row_number() OVER (  ORDER BY CASE [Status] 
													WHEN 12 THEN 1 
													WHEN 11 THEN 2 
													WHEN 7 THEN 3 
													WHEN 14 THEN 4
													WHEN 9 THEN 5

																WHEN 10 THEN 6
													WHEN 8 THEN 7
													WHEN 6 THEN 8
													WHEN 5 THEN 9
													WHEN 4 THEN 10
													WHEN 3 THEN 11
													WHEN 2 THEN 12
													WHEN 1 THEN 13
													END ) 
													AS RowNo_Order
			from (

			SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],a.InstallId ,ParentTaskId,TaskLevel,t.FristName + ' ' + t.LastName AS Assigneduser
			from dbo.tblTask as a
			left outer join tbltaskassignedusers as b on a.TaskId=b.TaskId
			LEFT OUTER JOIN tblInstallUsers as t ON t.Id = b.UserId
			where a.[Status]  in (SELECT * FROM [dbo].[SplitString](ISNULL(@TaskStatus,a.[Status]),','))			
			AND t.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,t.[Status]),','))
			and b.UserId in (select * from [dbo].[SplitString](@userid,','))
			and parenttaskid is not null
			) as x
			)
			
		SELECT *
		INTO #temp3
		FROM Tasklist

		
			SELECT
			*
			FROM #temp3
			WHERE 
			RowNo_Order >= @StartIndex AND 
			(
				@PageSize = 0 OR 
				RowNo_Order < (@StartIndex + @PageSize)
			)
				
		SELECT
		COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex 
		FROM #temp3

		end
	else if @userid='0' and @desigid<>''
		begin
		;WITH 
		Tasklist AS
		(	
			select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,Assigneduser,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,
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
			end as 'InstallId',Row_number() OVER (  ORDER BY CASE [Status] 
													WHEN 12 THEN 1 
													WHEN 11 THEN 2 
													WHEN 7 THEN 3 
													WHEN 14 THEN 4
													WHEN 9 THEN 5

																WHEN 10 THEN 6
													WHEN 8 THEN 7
													WHEN 6 THEN 8
													WHEN 5 THEN 9
													WHEN 4 THEN 10
													WHEN 3 THEN 11
													WHEN 2 THEN 12
													WHEN 1 THEN 13
													END ) 
													AS RowNo_Order
			from (

			SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],a.InstallId,ParentTaskId,TaskLevel, t.FristName + ' ' + t.LastName AS Assigneduser
			from dbo.tblTask as a 
			LEFT JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId
			LEFT JOIN tblTaskdesignations as b ON b.TaskId = c.TaskId
			LEFT JOIN tblInstallUsers as t ON t.Id = c.UserId
			where a.[Status]  in (SELECT * FROM [dbo].[SplitString](ISNULL(@TaskStatus,a.[Status]),','))			
			AND t.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,t.[Status]),','))
			and b.DesignationID in (select * from [dbo].[SplitString](@desigid,',')) 
			and parenttaskid is not null

			) as x
			)
			
		SELECT *
		INTO #temp4
		FROM Tasklist

			SELECT
			*
			FROM #temp4
			WHERE 
			RowNo_Order >= @StartIndex AND 
			(
				@PageSize = 0 OR 
				RowNo_Order < (@StartIndex + @PageSize)
			)
			
		SELECT
		COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex 
		FROM #temp4

		end
END



