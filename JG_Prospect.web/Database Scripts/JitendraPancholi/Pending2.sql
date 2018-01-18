Go
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChatUser]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ChatUser](
		Id int Primary Key Identity(1,1),
		UserId int foreign key references tblInstallUsers(Id),
		ConnectionId nvarchar(max),
		OnlineAt DateTime Not Null Default(GetUTCDate())
	) 
END
Go
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChatFile]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ChatFile](
		Id int Primary Key Identity(1,1),
		DisplayName Varchar(250) Not Null,
		SavedName Varchar(250) Not Null,
		Mime Varchar(250) Not Null,
		DownloadBinary Varbinary(max) Null,
	) 
END
Go
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChatMessage]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ChatMessage](
	   Id int Primary Key Identity(1,1),
	   ChatSourceId int not null default(1), -- 1:UserChat, 2:TaskChat
	   ChatGroupId varchar(100) Not Null,
	   SenderId int null foreign key references tblInstallUsers(Id),
	   TextMessage NVarchar(max),
	   ChatFileId int foreign key references ChatFile(Id),
	   ReceiverIds varchar(800), -- UserIds in CSV format
	   CreatedOn DateTime Not Null Default(GetUTCDATE())
	) 
END

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetChatUsers' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetChatUsers
  END
Go
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	GetChatUsers 
	GetChatUsers '4848'
*/
CREATE PROCEDURE [dbo].[GetChatUsers]
	@UserIds Varchar(200) = null
AS    
BEGIN
	IF @UserIds IS NULL OR @UserIds = ''
		Begin
			Select C.UserId, C.ConnectionId, U.FristName As FirstName,
			U.LastName, U.Email, C.OnlineAt From ChatUser C Join tblInstallUsers U On C.UserId = U.Id
		End
	Else
		Begin
			IF OBJECT_ID('tempdb..#TempIds') IS NOT NULL DROP TABLE #TempIds Create Table #TempIds(Id int)
			Insert Into #TempIds SELECT * FROM [dbo].[CSVtoTable](@UserIds,',')
			Select C.UserId, C.ConnectionId, U.FristName As FirstName,
			U.LastName, U.Email, C.OnlineAt From ChatUser C Join tblInstallUsers U On C.UserId = U.Id
			Where C.UserId in (Select Id From #TempIds)
		End
END

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetChatUserCount' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetChatUserCount
  END
Go
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	GetChatUserCount
*/
CREATE PROCEDURE [dbo].[GetChatUserCount]
AS    
BEGIN
	select COUNT(1) as TotalCount from ChatUser
END

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'DeleteChatUser' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE DeleteChatUser
  END
Go
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	DeleteChatUser
*/
CREATE PROCEDURE [dbo].[DeleteChatUser]
	@ConnectionId NVarchar(max)
AS    
BEGIN
	delete from [ChatUser] where [ConnectionID] = @ConnectionId
END

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'AddChatUser' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE AddChatUser
  END
Go
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	AddChatUser
*/
CREATE PROCEDURE [dbo].[AddChatUser]
	@UserId int,
	@ConnectionId NVarchar(max)
AS    
BEGIN
	If NOT EXISTS (Select 1 From ChatUser Where ConnectionId = @ConnectionId)
		Begin
			Insert Into ChatUser(UserId, ConnectionId) Values(@UserId, @ConnectionId)
		End
END

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetChatUser' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetChatUser
  END
Go
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	GetChatUser 3797
*/
CREATE PROCEDURE [dbo].[GetChatUser]
	@UserId int
AS    
BEGIN
	Select C.UserId, C.ConnectionId, U.FristName As FirstName,
	U.LastName, U.Email, C.OnlineAt From ChatUser C Join tblInstallUsers U On C.UserId = U.Id
	Where C.UserId = @UserId
END

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'SaveChatMessage' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE SaveChatMessage
  END
Go
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	SaveChatMessage 3797
*/
CREATE PROCEDURE [dbo].[SaveChatMessage]
	@ChatSourceId int,
	@ChatGroupId Varchar(100),
	@SenderId int,
	@TextMessage nvarchar(max),
	@ChatFileId int,
	@ReceiverIds varchar(800)
AS    
BEGIN
	Insert Into ChatMessage(ChatSourceId, SenderId, ChatGroupId, TextMessage, ChatFileId, ReceiverIds) Values
		(@ChatSourceId, @SenderId, @ChatGroupId, @TextMessage, @ChatFileId, @ReceiverIds)
END

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetChatMessages' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetChatMessages
  END
Go
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	GetChatMessages 3797
*/
CREATE PROCEDURE [dbo].[GetChatMessages]
	@ChatGroupId varchar(100)
AS    
BEGIN
	Select S.Id, S.ChatSourceId, S.SenderId, S.TextMessage, S.ChatFileId, S.ReceiverIds, S.CreatedOn From SaveChatMessage S With(NoLock) 
		Where S.ChatGroupId = @ChatGroupId
END


GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetUsersByKeyword' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetUsersByKeyword
  END
Go
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 27 Nov 2017   
-- Description: Get a list of top 5 users by starts with name, email 
-- =============================================    
/*
	GetUsersByKeyword 'kapilpancholi','3697,1015'
*/
Create PROCEDURE GetUsersByKeyword
  @Keyword varchar(50),
  @ExceptUserIds varchar(100) = null
AS    
BEGIN
	Select top 5 U.Id, U.FristName, U.LastName, U.Email, U.Phone, ISNULL(U.Picture,'') As Picture, U.UserInstallId
	From tblInstallUsers U With(NoLock)
	Where (FristName like @Keyword + '%' OR LastName like @Keyword + '%' OR Email like @Keyword + '%' OR
	(FristName+LastName) Like  @Keyword + '%'
	) --order by @keyword
	And U.Id not in (Select * From [dbo].[CSVtoTable](@ExceptUserIds,','))
END   