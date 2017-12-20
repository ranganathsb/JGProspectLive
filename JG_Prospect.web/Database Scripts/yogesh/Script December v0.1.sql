USE JGBS_Dev_New
GO

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[usp_QuickSaveInstallUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE usp_QuickSaveInstallUser

    END  
GO    

  
-- =============================================    
-- Author:  Yogesh    
-- Create date: 09 Sep 2017    
-- Description: Checks if a customer is registered for first time or not.
-- =============================================    
CREATE PROCEDURE [dbo].[usp_QuickSaveInstallUser]   
(

@FirstName VARCHAR(50),
@LastName VARCHAR(50),
@Email VARCHAR(250),
@Phone VARCHAR(25),
@Zip VARCHAR(10),
@DesignationText VARCHAR(50),
@Status VARCHAR(20),
@SourceText VARCHAR(250),
@EmpType VARCHAR(50),
@StartDate VARCHAR(50),
@SalaryReq VARCHAR(50),
@SourceUserId VARCHAR(10), 
@PositionAppliedForDesignationId VARCHAR(50),
@SourceID INT,
@AddedByUserId INT, 
@IsEmailContactPreference BIT,
@IsCallContactPreference BIT,
@IsTextContactPreference BIT,
@IsMailContactPreference BIT,
@Id INT = OUTPUT

)
AS  
BEGIN  
 
 INSERT INTO tblInstallUsers
                         (FristName, LastName, Email, Phone, Zip, Designation, Status, Source, EmpType, StartDate, SalaryReq, UserType, SourceUser, DateSourced, CreatedDateTime, PositionAppliedFor, SourceID, AddedByUserID, IsFirstTime, 
                         IsEmailContactPreference, IsCallContactPreference, IsTextContactPreference, IsMailContactPreference)
 VALUES        (@FirstName,@LastName,@Email,@Phone,@Zip,@DesignationText,@Status,@SourceText,@EmpType,@StartDate,@SalaryReq,'SalesUser',@SourceUserId, GETDATE(), 
                         GETDATE(),@PositionAppliedForDesignationId,@SourceID,@AddedByUserId, 1,@IsEmailContactPreference,@IsCallContactPreference,@IsTextContactPreference,@IsMailContactPreference)
  
SELECT @Id = SCOPE_IDENTITY()

RETURN @Id
 
END  