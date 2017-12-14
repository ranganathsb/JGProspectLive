CREATE PROCEDURE [dbo].[SP_GetInstallUsersWithStatus]
 @Key int,          
 @Designations varchar(4000),        
 @UserStatus int        
AS            
BEGIN            
        
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
    tblinstallUsers.[Status] = @UserStatus      
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
    tblinstallUsers.[Status] = @UserStatus       
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