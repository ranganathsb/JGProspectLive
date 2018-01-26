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
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChatMessageReadStatus]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ChatMessageReadStatus](
	   Id int Primary Key Identity(1,1),
	   ChatMessageId int Foreign Key References ChatMessage(Id),
	   ReceiverId Int,
	   IsRead bit not null default(0)
	) 
END

Go
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChatLog]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ChatLog](
		Id int Primary Key Identity(1,1),
		ChatGroupId varchar(100),
		[Message] nvarchar(max),
		ChatSourceId int,
		UserId int,
		IP Varchar(20),
		CreatedOn DateTime Not Null Default(GetUTCDate())
	) 
END

Go
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ApplicationErrors]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ApplicationErrors](
		Id int Primary Key Identity(1,1),
		Type varchar(100),
		[Message] varchar(2000),
		StackTrace varchar(max),
		PageUrl  varchar(2000),
		CreatedOn DateTime Not Null Default(GetUTCDate())
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
			Select C.UserId, C.ConnectionId, U.FristName As FirstName, U.UserInstallId,
			U.LastName, U.Email, C.OnlineAt, U.Picture From ChatUser C Join tblInstallUsers U On C.UserId = U.Id
		End
	Else
		Begin
			IF OBJECT_ID('tempdb..#TempIds') IS NOT NULL DROP TABLE #TempIds Create Table #TempIds(Id int)
			Insert Into #TempIds SELECT * FROM [dbo].[CSVtoTable](@UserIds,',')
			Select C.UserId, C.ConnectionId, U.FristName As FirstName, U.UserInstallId,
			U.LastName, U.Email, C.OnlineAt, U.Picture From ChatUser C Join tblInstallUsers U On C.UserId = U.Id
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
	Select C.UserId, C.ConnectionId, U.FristName As FirstName, U.LastName, 
			U.Email, C.OnlineAt, U.Picture, U.UserInstallId
	From ChatUser C Join tblInstallUsers U On C.UserId = U.Id
	Where C.UserId = @UserId
END

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetChatUserByConnectionId' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetChatUserByConnectionId
  END
Go
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	GetChatUserByConnectionId '6eac4b34-a5fb-4f7a-8039-eec3fab3b4a2'
*/
CREATE PROCEDURE [dbo].GetChatUserByConnectionId
	@ConnectionId varchar(100)
AS    
BEGIN
	Select C.UserId, C.ConnectionId, U.FristName As FirstName, U.LastName, 
			U.Email, C.OnlineAt, U.Picture, U.UserInstallId
	From ChatUser C Join tblInstallUsers U On C.UserId = U.Id
	Where C.ConnectionId = @ConnectionId
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
	Declare @MessageId int
	Insert Into ChatMessage(ChatSourceId, SenderId, ChatGroupId, TextMessage, ChatFileId, ReceiverIds) Values
		(@ChatSourceId, @SenderId, @ChatGroupId, @TextMessage, @ChatFileId, @ReceiverIds)
	Set @MessageId = IDENT_CURRENT('ChatMessage')
	Insert Into ChatMessageReadStatus (ChatMessageId, ReceiverId) 
		Select @MessageId, RESULT from dbo.CSVtoTable(@ReceiverIds,',') Where RESULT > 0
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
	GetChatMessages '94f7e245-4208-4047-88d3-24feadc0498b'
*/
CREATE PROCEDURE [dbo].[GetChatMessages]
	@ChatGroupId varchar(100)
AS    
BEGIN
	Select S.Id, S.ChatSourceId, S.SenderId, S.TextMessage, S.ChatFileId, S.ReceiverIds, S.CreatedOn From ChatMessage S With(NoLock) 
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

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'SaveChatLog' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE SaveChatLog
  END
Go
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 27 Nov 2017   
-- Description: Get a list of top 5 users by starts with name, email 
-- =============================================    
/*
	SaveChatLog 'kapilpancholi','3697,1015'
*/
Create PROCEDURE SaveChatLog
	@ChatGroupId varchar(100),
	@Message varchar(50),
	@ChatSourceId int,
	@UserId int,
	@IP Varchar(20)
AS    
BEGIN
	Insert Into ChatLog (ChatGroupId, Message, ChatSourceId, UserId, IP) 
		Values (@ChatGroupId, @Message, @ChatSourceId, @UserId, @IP)
END   


GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'SaveApplicationError' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE SaveApplicationError
  END
Go
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 27 Nov 2017   
-- Description: Get a list of top 5 users by starts with name, email 
-- =============================================    
/*
	SaveChatLog 'kapilpancholi','3697,1015'
*/
Create PROCEDURE SaveApplicationError
	@Type varchar(100),
	@Message varchar(8000),
	@StackTrace varchar(max),
	@PageUrl varchar(8000)
AS    
BEGIN
	Insert Into ApplicationErrors (Type, Message, StackTrace, PageUrl) Values (@Type, @Message, @StackTrace, @PageUrl)
END


GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetOnlineUsers' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetOnlineUsers
  END
Go
 -- =============================================        
-- Author:  Jitendra Pancholi        
-- Create date: 27 Nov 2017     
-- Description: Get a list of top 5 users by starts with name, email   
-- =============================================      
/*  
	GetOnlineUsers 3797  
*/  
Create PROCEDURE GetOnlineUsers  
	@LoggedInUserId int  
AS      
BEGIN  
	IF OBJECT_ID('tempdb..#OnlineUsers') IS NOT NULL DROP TABLE #OnlineUsers  
	Create Table #OnlineUsers(Id int Primary Key Identity(1,1), UserId int, OnlineAt DateTime,   
	MessageId int, LastMessage NVarchar(max), MessageAt DateTime, LastMessageByUserId int, IsRead Bit Not Null Default(0))  
   
	Insert Into #OnlineUsers(UserId, OnlineAt)  
		Select U.UserId, Max(U.OnlineAt) As OnlineAt From ChatUser U With(NoLock)   
			Group By UserId  
			Order by UserId, OnlineAt Desc  
   
	Declare @Min int = 1, @Max int = 1, @UserId Int, @LastMessage NVarchar(Max),   
			@MessageId Int, @MessageAt DateTime, @IsRead Bit  
   
	Select @Min = Min(Id), @Max = Max(Id) from #OnlineUsers  
  
	While @Min <= @Max  
	Begin  
		Select @UserId = UserId From #OnlineUsers Where Id = @Min  
     
		Select top 1 @LastMessage = M.TextMessage, @MessageId = M.Id, @MessageAt = M.CreatedOn, @IsRead = S.IsRead  
		From ChatMessage M With(NoLock)   
				Join ChatMessageReadStatus S With(NoLock) On M.Id = S.ChatMessageId  
				Where (M.SenderId = @UserId And S.ReceiverId = @LoggedInUserId)  
					Or (M.SenderId = @LoggedInUserId And S.ReceiverId = @UserId)
				Order By M.CreatedOn Desc   
		Print @UserId
		Print @LastMessage
		Print @Min
		Update #OnlineUsers Set LastMessage = @LastMessage, MessageId = @MessageId,   
								MessageAt = @MessageAt, IsRead = IsNull(@IsRead,0)  
				Where Id = @Min  
		Set @LastMessage = NULL
		Set @MessageId = NULL
		Set @MessageAt = NULL
		Set @IsRead = 0
		Set @Min = @Min + 1  
	End  
  
	Select O.Id, O.UserId, O.OnlineAt, O.MessageId, O.LastMessage, O.MessageAt,  
			O.IsRead, U.FristName as FirstName, U.LastName, U.Email, U.UserInstallId, U.Picture  
	From #OnlineUsers O Join tblInstallUsers U With(NoLock)  On O.UserId = U.Id  
END

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'SetChatMessageRead' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE SetChatMessageRead
  END
Go
 -- =============================================        
-- Author:  Jitendra Pancholi        
-- Create date: 27 Nov 2017     
-- Description: Get a list of top 5 users by starts with name, email   
-- =============================================      
/*  
	SetChatMessageRead 31, 3797  
*/  
Create PROCEDURE SetChatMessageRead  
	@ChatMessageId int  ,
	@ReceiverId int
AS      
BEGIN
	Update ChatMessageReadStatus Set IsRead = 1
		Where ChatMessageId = @ChatMessageId And ReceiverId = @ReceiverId
End

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'SetChatMessageReadByChatGroupId' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE SetChatMessageReadByChatGroupId
  END
Go
 -- =============================================        
-- Author:  Jitendra Pancholi        
-- Create date: 27 Nov 2017     
-- Description: Get a list of top 5 users by starts with name, email   
-- =============================================      
/*  
	SetChatMessageReadByChatGroupId 31, 3797  
*/  
Create PROCEDURE SetChatMessageReadByChatGroupId  
	@ChatGroupId Varchar(100)  ,
	@ReceiverId int
AS      
BEGIN
	UPDATE S Set IsRead = 1
	From ChatMessageReadStatus S
		Join ChatMessage M On S.ChatMessageId = M.Id 
		Where M.ChatGroupId = @ChatGroupId  And S.ReceiverId = @ReceiverId
End