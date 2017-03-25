USE [JGBS_Dev]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetUsersNDesignationForSalesFilter]    Script Date: 3/24/2017 10:50:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Shekhar Pawar
-- Create date: 16/11/2016
-- Description:	Fetch all sales and install users for who are in edit user in system

-- Updated on: 23rd March 2017 by Ketankumar Godhani
-- =============================================
ALTER PROCEDURE [dbo].[usp_GetUsersNDesignationForSalesFilter] 
AS
BEGIN

SET NOCOUNT ON;

SELECT * FROM (
SELECT  
		DISTINCT Users.Id, FristName + ' ' + LastName +'-'+ ISNULL(UserInstallId,'') AS FirstName,[Status], 'Group1' AS GroupNumber
	FROM tblInstallUsers AS Users 
	WHERE 
		Users.FristName IS NOT NULL AND 
		Users.FristName <> '' AND
		(
			[Status] = '1' --Active=1
		)
		AND Designation IN('Admin Recruiter','Recruiter', 'Admin', 'Office Manager', 'Jr. Sales', 'Sales Manager', 'Operations Manager')

	UNION ALL

	SELECT  
		DISTINCT Users.Id, FristName + ' ' + LastName +'-'+ ISNULL(UserInstallId,'') AS FirstName,[Status], 'Group2' AS GroupNumber
	FROM tblInstallUsers AS Users 
	WHERE 
		Users.FristName IS NOT NULL AND 
		Users.FristName <> '' AND
		(
			[Status] = '5' --Interview Date
		)
		AND Designation IN('Admin Recruiter','Recruiter', 'Admin', 'Office Manager', 'Jr. Sales', 'Sales Manager', 'Operations Manager')

	UNION ALL

	SELECT  
		DISTINCT Users.Id, FristName + ' ' + LastName +'-'+ ISNULL(UserInstallId,'') AS FirstName,[Status], 'Group3' AS GroupNumber
	FROM tblInstallUsers AS Users 
	WHERE 
		Users.FristName IS NOT NULL AND 
		Users.FristName <> '' AND
		(
			[Status] = '3' --Deactive
		)
		AND Designation IN('Admin Recruiter','Recruiter', 'Admin', 'Office Manager', 'Jr. Sales', 'Sales Manager', 'Operations Manager')

	--ORDER BY GroupNumber, [Status], FristName + ' ' + LastName +'-'+ ISNULL(UserInstallId,'')
	) as T

	WHERE T.Id in (
	SELECT     
   distinct
   ISNULL(t1.Id,t2.Id) As AddedById 
  FROM     
   tblInstallUsers t     
    LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser    
    LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser
	LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id    
    LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id       
    LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id      
    LEFT JOIN tblSource s ON t.SourceId = s.Id    
	OUTER APPLY
	(
		SELECT TOP 1 tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo
		FROM tblTaskAssignedUsers u 
				INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND 
					(tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1) 
		WHERE u.UserId = t.Id
	) AS Task
  WHERE  
  t.Status NOT IN ('6', '1')  
 )
END

