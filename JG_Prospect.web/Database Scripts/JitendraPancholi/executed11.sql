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
	Declare @Min int = 1, @Max int = 1, @UserId int, @ConnectionId Varchar(max)
	IF OBJECT_ID('tempdb..#TempIds') IS NOT NULL DROP TABLE #TempIds Create Table #TempIds(Id int)
			Insert Into #TempIds SELECT * FROM [dbo].[CSVtoTable](@UserIds,',')

			IF OBJECT_ID('tempdb..#TempChatUsers') IS NOT NULL DROP TABLE #TempChatUsers 
				Create Table #TempChatUsers(Id int Identity(1,1), UserId int, ConnectionId Varchar(max), FirstName Varchar(100),
										UserInstallId Varchar(100), LastName Varchar(100), Email Varchar(100),
										OnlineAt DateTime, Picture Varchar(200))

			IF OBJECT_ID('tempdb..#ChatUsers') IS NOT NULL DROP TABLE #ChatUsers
				Create Table #ChatUsers(Id int Identity(1,1), UserId int, ConnectionId Varchar(max), FirstName Varchar(100),
											UserInstallId Varchar(100), LastName Varchar(100), Email Varchar(100),
											OnlineAt DateTime, Picture Varchar(200))
	IF @UserIds IS NULL OR @UserIds = ''
		Begin
			Insert Into #TempChatUsers
					Select C.UserId, C.ConnectionId, U.FristName As FirstName, U.UserInstallId,
					U.LastName, U.Email, C.OnlineAt, U.Picture From ChatUser C Join tblInstallUsers U On C.UserId = U.Id
					Where C.UserId in (Select Distinct UserId From ChatUser U With(NoLock))
	
			
			Select @Min = Min(Id), @Max = Max(Id) From #TempChatUsers

			While @Min <= @Max
			Begin
				Select @UserId = UserId, @ConnectionId = ConnectionId From #TempChatUsers Where Id = @Min

				If Not Exists (Select 1 from #ChatUsers Where UserId = @UserId)
					Begin
						Insert Into #ChatUsers
							Select UserId, ConnectionId, FirstName, UserInstallId, LastName, Email, OnlineAt, Picture 
								from #TempChatUsers Where Id = @Min
					End
				Else
					Begin
						Update #ChatUsers Set ConnectionId += ',' + @ConnectionId
					End


				Set @Min = @Min + 1
			End
			Select Id, UserId, ConnectionId, FirstName, UserInstallId, LastName, Email, OnlineAt, Picture From #ChatUsers
		End
	Else
		Begin
			Insert Into #TempChatUsers
					Select C.UserId, C.ConnectionId, U.FristName As FirstName, U.UserInstallId,
					U.LastName, U.Email, C.OnlineAt, U.Picture From ChatUser C Join tblInstallUsers U On C.UserId = U.Id
					Where C.UserId in (Select Id From #TempIds)
	
			Select @Min = Min(Id), @Max = Max(Id) From #TempChatUsers

			While @Min <= @Max
			Begin
				Select @UserId = UserId, @ConnectionId = ConnectionId From #TempChatUsers Where Id = @Min

				If Not Exists (Select 1 from #ChatUsers Where UserId = @UserId)
					Begin
						Insert Into #ChatUsers
							Select UserId, ConnectionId, FirstName, UserInstallId, LastName, Email, OnlineAt, Picture 
								from #TempChatUsers Where Id = @Min
					End
				Else
					Begin
						Update #ChatUsers Set ConnectionId += ',' + @ConnectionId
					End


				Set @Min = @Min + 1
			End
			Select Id, UserId, ConnectionId, FirstName, UserInstallId, LastName, Email, OnlineAt, Picture From #ChatUsers
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
	@ReceiverIds varchar(800),
	@TaskId int = null,
	@TaskMultilevelListId int =null
AS    
BEGIN
	Declare @MessageId int
	IF @TaskId = 0 Begin Set @TaskId = Null End
	IF @TaskMultilevelListId = 0 Begin Set @TaskMultilevelListId = Null End
	Insert Into ChatMessage(ChatSourceId, SenderId, ChatGroupId, TextMessage, ChatFileId, ReceiverIds, TaskId,TaskMultilevelListId) 
	Values
		(@ChatSourceId, @SenderId, @ChatGroupId, @TextMessage, @ChatFileId, @ReceiverIds,@TaskId,@TaskMultilevelListId)
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
	GetChatMessages 'b395e80d-e9d3-41c5-91f9-1219413eae57','901,3797',2
*/
CREATE PROCEDURE [dbo].[GetChatMessages]
	@ChatGroupId varchar(100),
	@ReceiverIds Varchar(800),
	@ChatSourceId Int = 0,
	@LoggedInUserId int = 780
AS    
BEGIN

	IF OBJECT_ID('tempdb..#TempChatMessages') IS NOT NULL DROP TABLE #TempChatMessages  
	Create Table #TempChatMessages(Id int Primary Key Identity(1,1), 
			ChatGroupId varchar(100), ChatSourceId int, SenderId int, TextMessage nVarchar(max), ChatFileId int, ReceiverIds varchar(800),
			CreatedOn datetime, ChatUserIds Varchar(1000), SortedChatUserIds Varchar(1000), ChatMessageId int)

	Insert Into #TempChatMessages (ChatGroupId,ChatSourceId, SenderId, TextMessage, ChatFileId,ReceiverIds,
									CreatedOn,ChatUserIds, ChatMessageId)
		Select S.ChatGroupId,S.ChatSourceId, S.SenderId, S.TextMessage, S.ChatFileId, 
					S.ReceiverIds, S.CreatedOn, Convert(varchar(12), S.SenderId) + ',' + S.ReceiverIds, S.Id
		From ChatMessage S With(NoLock) 
		Where S.ChatGroupId = @ChatGroupId

	Declare @Min int =1, @Max int =1, @ChatUserIds Varchar(1000)

	Select @Min = Min(Id), @Max = Max(Id) From #TempChatMessages

	While @Min <= @Max
	Begin
		Select @ChatUserIds = ChatUserIds From #TempChatMessages Where Id = @Min

		Update #TempChatMessages Set SortedChatUserIds = SUBSTRING(
					(SELECT ',' + Convert(Varchar(20),Result)
					From dbo.CSVtoTable(@ChatUserIds, ',') 
					Order by Result Asc
					FOR XML PATH('')),2,800) Where Id = @Min

		Set @Min = @Min + 1
	End
	--Select * From #TempChatMessages S Where S.SortedChatUserIds = @ReceiverIds And S.ChatSourceId = @ChatSourceId
	If ISNULL(@ChatSourceId,'0') = '0'
		Begin
			Select S.Id, S.ChatGroupId,S.ChatSourceId, S.SenderId, S.TextMessage, S.ChatFileId, S.ReceiverIds, S.CreatedOn,
				U.FristName As FirstName, U.LastName, (U.FristName + ' ' + U.LastName) As Fullname,
				U.UserInstallId, U.Picture, --MS.IsRead,
				IsNull((Select MS.IsRead From ChatMessageReadStatus MS Where MS.ChatMessageId = S.ChatMessageId And ReceiverId = @LoggedInUserId),0) As IsRead
			From #TempChatMessages S With(NoLock) 
			Join tblInstallUsers U With(NoLock) On S.SenderId = U.Id
			--Join ChatMessageReadStatus MS With(NoLock) On S.ChatMessageId = MS.ChatMessageId
			Where S.SortedChatUserIds = @ReceiverIds 
			Order By S.CreatedOn Asc
		End
	Else
		Begin
			Select S.Id, S.ChatGroupId,S.ChatSourceId, S.SenderId, S.TextMessage, S.ChatFileId, S.ReceiverIds, S.CreatedOn,
				U.FristName As FirstName, U.LastName, (U.FristName + ' ' + U.LastName) As Fullname,
				U.UserInstallId, U.Picture,-- MS.IsRead
				IsNull((Select MS.IsRead From ChatMessageReadStatus MS Where MS.ChatMessageId = S.ChatMessageId And ReceiverId = @LoggedInUserId),0) As IsRead
			From #TempChatMessages S With(NoLock) 
			Join tblInstallUsers U With(NoLock) On S.SenderId = U.Id
			--Join ChatMessageReadStatus MS With(NoLock) On S.ChatMessageId = MS.ChatMessageId
			Where S.SortedChatUserIds = @ReceiverIds /*And S.ChatSourceId = @ChatSourceId*/
			And S.ChatSourceId Not in (2)
			Order By S.CreatedOn Asc
		End
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
	GetUsersByKeyword 'yoge',''
*/
Create PROCEDURE GetUsersByKeyword
  @Keyword varchar(50),
  @ExceptUserIds varchar(100) = null,
  @LoggedInUserId Int = null
AS    
BEGIN
	Declare @ChatRoleId int = 0
	declare @rank table (ordering int identity(1,1), userStatus int)
	If @LoggedInUserId IS NOT NULL AND @LoggedInUserId > 0
	Begin
		Select @ChatRoleId = RoleId From ChatUserRole RU With(NoLock) Join ChatRole R With(NoLock) On RU.RoleId = R.Id
				Where RU.UserId = @LoggedInUserId
	End
	IF @ChatRoleId =  1 -- Admin
		Begin
			insert into @rank values (10)
			insert into @rank values (2)
			insert into @rank values (5)
			insert into @rank values (6)
			insert into @rank values (1)
		End
	ELSE
		Begin
			insert into @rank values (6)
			insert into @rank values (1)
		End

	Select top 5 U.Id, U.FristName as FirstName, U.LastName, U.Email, U.Phone, ISNULL(U.Picture,'') As Picture, U.UserInstallId
	From tblInstallUsers U With(NoLock)
	Where (FristName like @Keyword + '%' OR LastName like @Keyword + '%' OR Email like @Keyword + '%' OR
	(FristName + ' ' + LastName) Like  @Keyword + '%'
	) --order by @keyword
	And U.Id not in (Select * From [dbo].[CSVtoTable](@ExceptUserIds,','))
	And U.[Status] in (Select userStatus From @rank) -- Active, OfferMade,InterviewDate,Applicant,RefferalApplicant 
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
 /* Delete all entries which are more than 1 day old */  
 Delete From ChatUser Where OnlineAt < DATEADD(DAY, -1, GetDate())  
 /* Delete all entries which are more than 1 day old */  
    
 Declare @Min int = 1, @Max int = 1, @UserId Int, @LastMessage NVarchar(Max), @ChatUserIds Varchar(1000),      
   @MessageId Int, @MessageAt DateTime, @IsRead Bit, @ChatGroupId varchar(100),      
   @ChatRoleId int      
      
 IF OBJECT_ID('tempdb..#OnlineUsers') IS NOT NULL DROP TABLE #OnlineUsers        
 Create Table #OnlineUsers(Id int Primary Key Identity(1,1), UserId int,       
   ChatGroupId varchar(100), ReceiverIds varchar(800), OnlineAt DateTime,         
   MessageId int, LastMessage NVarchar(max), MessageAt DateTime, LastMessageByUserId int,       
   IsRead Bit Not Null Default(0), UserRank Int, UserStatus int,TaskId int, TaskMultilevelListId int)      
      
   IF OBJECT_ID('tempdb..#OnlineUsersOrGroups') IS NOT NULL DROP TABLE #OnlineUsersOrGroups        
 Create Table #OnlineUsersOrGroups(Id int Primary Key Identity(1,1), UserId int,       
   ChatGroupId varchar(100), ReceiverIds varchar(800), OnlineAt DateTime,         
   MessageId int, LastMessage NVarchar(max), MessageAt DateTime, LastMessageByUserId int,       
   IsRead Bit Not Null Default(0), GroupOrUsername Varchar(800), Picture Varchar(800),      
   UserInstallId Varchar(100), UserRank int, UserStatus int,TaskId int, TaskMultilevelListId int,  
   UnreadCount int, GroupNameAnchor NVarchar(2000))      
       
 IF OBJECT_ID('tempdb..#OnlineGroups') IS NOT NULL DROP TABLE #OnlineGroups        
  Create Table #OnlineGroups(Id int identity(1,1), ChatGroupId varchar(100), ChatUserIds varchar(800), ChatUserCount int,LastMessage NVarchar(max),      
    MessageId int, MessageAt DateTime, Picture Varchar(800),IsRead Bit Not Null Default(0),TaskId int, TaskMultilevelListId int)      
      
 IF OBJECT_ID('tempdb..#OnlineTempGroups') IS NOT NULL DROP TABLE #OnlineTempGroups        
  Create Table #OnlineTempGroups(Id int identity(1,1), ChatGroupId varchar(100), ChatUserIds varchar(800), ChatUserCount int,LastMessage NVarchar(max),      
    MessageId int, MessageAt DateTime, Picture Varchar(800),IsRead Bit Not Null Default(0),TaskId int, TaskMultilevelListId int)      
      
 IF OBJECT_ID('tempdb..#UserIds') IS NOT NULL DROP TABLE #UserIds      
  Create Table #UserIds(Id int)      
      
 IF OBJECT_ID('tempdb..#TempChatMessages') IS NOT NULL DROP TABLE #TempChatMessages        
  Create Table #TempChatMessages(Id int Primary Key Identity(1,1),       
   ChatGroupId varchar(100), ChatSourceId int, SenderId int, TextMessage nVarchar(max), ChatFileId int, ReceiverIds varchar(800),      
   CreatedOn datetime, ChatUserIds Varchar(1000), SortedChatUserIds Varchar(1000),    
   TaskId int, TaskMultilevelListId int, MessageId int)      
    
IF OBJECT_ID('tempdb..#TaskUsers') IS NOT NULL DROP TABLE #TaskUsers       
  Create Table #TaskUsers(UserId int, Aceptance bit, CreatedOn DateTime)    
      
 Insert Into #TempChatMessages (ChatGroupId,ChatSourceId, SenderId, TextMessage, ChatFileId,ReceiverIds,      
         CreatedOn,ChatUserIds, TaskId, TaskMultilevelListId, MessageId)      
  Select S.ChatGroupId,S.ChatSourceId, S.SenderId, S.TextMessage, S.ChatFileId,       
     S.ReceiverIds, S.CreatedOn, Convert(varchar(12), S.SenderId) + ',' + S.ReceiverIds,    
  S.TaskId, S.TaskMultilevelListId, S.Id  
  From ChatMessage S With(NoLock) Where S.ChatSourceId in (2, 10) --      
       
 Select @Min = Min(Id), @Max = Max(Id) From #TempChatMessages      
      
 While @Min <= @Max      
 Begin      
  Select @ChatUserIds = ChatUserIds From #TempChatMessages Where Id = @Min      
      
  Update #TempChatMessages Set SortedChatUserIds = SUBSTRING(      
     (SELECT ',' + Convert(Varchar(20),Result)      
     From dbo.CSVtoTable(@ChatUserIds, ',')       
     Order by Result Asc      
     FOR XML PATH('')),2,800) Where Id = @Min      
      
  Set @Min = @Min + 1      
 End      
      
 Set @Min = 1      
 Set @Max = 1      
     Insert Into #OnlineUsers(UserId, OnlineAt, UserRank, UserStatus)      
  Select U.UserId, Max(U.OnlineAt) As OnlineAt, 100, Null From ChatUser U With(NoLock)          
   Group By UserId        
   Order by OnlineAt Desc      
      
 -- Add Offline Users      
 Select @ChatRoleId = RoleId From ChatUserRole RU With(NoLock) Join ChatRole R With(NoLock) On RU.RoleId = R.Id      
     Where RU.UserId = @LoggedInUserId      
       
 declare @rank table (ordering int identity(1,1), number int)      
 declare @DistinctUserId table (id int identity(1,1), userid int)      
 Insert Into @DistinctUserId Select Distinct UserId From #OnlineUsers Where UserId Is Not NUll      
 --insert into @rank values (0)      
 IF @ChatRoleId =  1 -- Admin      
  Begin      
   insert into @rank values (10)      
   insert into @rank values (2)      
   insert into @rank values (5)      
   insert into @rank values (6)      
   insert into @rank values (1)      
  End      
 ELSE      
  Begin      
   insert into @rank values (6)      
   insert into @rank values (1)      
  End      
 Insert Into #OnlineUsers(UserId, OnlineAt, UserRank,UserStatus)        
 Select U.Id, Null, r.ordering, U.Status      
  From tblInstallUsers U With(NoLock)      
    join @rank r on  U.Status = r.number      
    Where U.Id Not In (Select userid From @DistinctUserId)      
    order by r.ordering      
  
      
 Select @Min = Min(Id), @Max = Max(Id) from #OnlineUsers        
       
 While @Min <= @Max        
 Begin        
  Select @UserId = UserId From #OnlineUsers Where Id = @Min        
      
  Select Top 1       
     @LastMessage = M.TextMessage, @MessageId = M.Id, @MessageAt = M.CreatedOn,       
     @ChatGroupId = M.ChatGroupId,      
     /*      
     @IsRead = (Case when (Select Count(1) From ChatMessageReadStatus S With(NoLock) Where S.ChatMessageId = M.Id) =      
       (Select Count(1) From ChatMessageReadStatus S With(NoLock) Where S.ChatMessageId = M.Id And IsRead = 1) Then '1'      
       Else '0' End),      
      */      
     @IsRead = (Select S.IsRead From ChatMessageReadStatus S With(NoLock) Where S.ChatMessageId = M.Id And (S.ReceiverId = @LoggedInUserId OR  S.ReceiverId = @UserId))      
    From ChatMessage M With(NoLock)      
    Where (M.SenderId = @LoggedInUserId And M.ReceiverIds = Convert(Varchar(12), @UserId))      
      Or (M.SenderId = @UserId And M.ReceiverIds = Convert(Varchar(12), @LoggedInUserId))      
      And M.ChatSourceId in (2, 10)      
    Order By M.CreatedOn Desc         
      
      
  Update #OnlineUsers Set LastMessage = @LastMessage, MessageId = @MessageId,         
        MessageAt = @MessageAt, IsRead = IsNull(@IsRead,0),      
        ChatGroupId = @ChatGroupId,      
        ReceiverIds = @UserId      
    Where Id = @Min        
  Set @LastMessage = NULL      
  Set @MessageId = NULL      
  Set @MessageAt = NULL      
  Set @IsRead = 0
  Set @ChatGroupId = Null
  Set @Min = @Min + 1        
 End      
      
 /* Select * From #OnlineUsers */  
  
 Insert Into #OnlineUsersOrGroups (UserId, OnlineAt, MessageId, LastMessage, MessageAt,        
          IsRead, GroupOrUsername, UserInstallId, Picture, ChatGroupId, ReceiverIds, UserRank, UserStatus)      
 Select O.UserId, O.OnlineAt, O.MessageId, O.LastMessage, ISNULL(O.MessageAt,'01-01-1900'),        
   O.IsRead, U.FristName + ' ' + U.LastName, U.UserInstallId, U.Picture,      
   O.ChatGroupId, O.ReceiverIds, O.UserRank, U.Status      
 From #OnlineUsers O Join tblInstallUsers U With(NoLock)  On O.UserId = U.Id      
       
 Insert Into #OnlineTempGroups(ChatGroupId,ChatUserIds,ChatUserCount,LastMessage,MessageId,MessageAt,Picture, IsRead, TaskId, TaskMultilevelListId)      
  Select Distinct M.ChatGroupId, M.SortedChatUserIds As ChatUserIds,       
   (Len( M.SortedChatUserIds) - Len(Replace(M.SortedChatUserIds,',','')) + 1) As UserCount,      
   (Select top 1 TextMessage From #TempChatMessages IM With(NoLock) Where IM.ChatGroupId = M.ChatGroupId And IM.SortedChatUserIds = M.SortedChatUserIds Order By IM.CreatedOn Desc) As LastMessage,      
   (Select top 1 IM.MessageId From #TempChatMessages IM With(NoLock) Where IM.ChatGroupId = M.ChatGroupId Order By IM.CreatedOn Desc) As MessageId,      
   (Select top 1 CreatedOn From #TempChatMessages IM With(NoLock) Where IM.ChatGroupId = M.ChatGroupId Order By IM.CreatedOn Desc) As MessageAt,      
   'chat-group.png',      
   ISNULL((Select S.IsRead From ChatMessageReadStatus S With(NoLock) Where S.ChatMessageId = M.Id And S.ReceiverId = @LoggedInUserId),0),    
   M.TaskId, M.TaskMultilevelListId    
  From #TempChatMessages M With(NoLock)       
  Where M.SortedChatUserIds Like '%' + Convert(Varchar(12),@LoggedInUserId) + '%'      
  Order By MessageAt Desc      
      
  Insert Into #OnlineGroups      
  Select Distinct OG.ChatGroupId,OG.ChatUserIds,OG.ChatUserCount,OG.LastMessage,OG.MessageId,ISNULL(OG.MessageAt,'01-01-1900'),OG.Picture,      
     OG.IsRead, OG.TaskId, OG.TaskMultilevelListId      
   From #OnlineTempGroups OG       
    Where /*ChatUserCount = (Select Max(ChatUserCount) From #OnlineTempGroups iOG Group By iOG.ChatGroupId Having iOG.ChatGroupId = OG.ChatGroupId)      
     And*/ ChatUserCount > 2      
   Order By MessageId Desc      
      
  Select @Min = Min(Id), @Max = Max(Id) from #OnlineGroups        
      
  While @Min <= @Max        
   Begin        
    Select @ChatUserIds = ChatUserIds From #OnlineGroups Where Id = @Min       
    --print @ChatUserIds      
    Truncate Table #UserIds      
    Insert Into #UserIds      
     Select Convert(int, Result) From dbo.CSVtoTable(@ChatUserIds,',') Order By Convert(int, Result)      
      
    Update #OnlineGroups Set ChatUserIds = SUBSTRING(      
     (SELECT ',' + Convert(Varchar(20),s.Id)      
     FROM #UserIds s      
     ORDER BY s.Id      
     FOR XML PATH('')),2,800) Where Id = @Min      
      
    Set @Min = @Min + 1        
   End      
      
 --Select * from #OnlineGroups Where ChatUserIds like '%' + Convert(Varchar(20),@LoggedInUserId) + '%'      
      
  Insert Into #OnlineUsersOrGroups (ChatGroupId,ReceiverIds,LastMessage,MessageId,MessageAt,OnlineAt,Picture, UserRank, UserStatus, IsRead, TaskId, TaskMultilevelListId)      
   Select Distinct ChatGroupId,ChatUserIds,LastMessage,MessageId,ISNULL(MessageAt,'01-01-1900'),MessageAt,Picture, 100, Null, IsRead, TaskId, TaskMultilevelListId      
    From #OnlineGroups --Where ChatUserIds like '%' + Convert(Varchar(12),@LoggedInUserId) + '%'      
        
  Update #OnlineUsersOrGroups Set GroupOrUsername = SUBSTRING(      
   (SELECT ' - ' + s.Fullname      
   FROM (select (U.FristName + ' ' + U.LastName) as Fullname From tblInstallUsers U       
   Where U.Id in (Select Result From dbo.CSVtoTable(ReceiverIds,','))) s      
   ORDER BY s.Fullname      
   FOR XML PATH('')),4,800)      
  Where UserId IS NULL     
      
-- Update GroupOrUsername if TaskId Is not null    
  Update G Set     
  G.GroupOrUsername = T.Title    
  From #OnlineUsersOrGroups G Join tblTask T On G.TaskId = T.TaskId Where G.TaskId Is Not Null  
   
 IF OBJECT_ID('tempdb..#TaskGroups') IS NOT NULL DROP TABLE #TaskGroups    
  Create Table #TaskGroups(Id int primary key identity(1,1), GroupId int, TaskId int)  
 Insert Into #TaskGroups Select Id, TaskId From #OnlineUsersOrGroups Where TaskId Is Not Null    
  
 Select @Max = Max(Id), @Min = Min(Id) From #TaskGroups  
  
 Declare @TaskId int, @ParentTaskId int = null, @ChatGroupName NVarchar(2000) = '', @GroupId int,  
   @TempChatGroupName NVarchar(200) = '', @Title NVarchar(1000), @TempTitle NVarchar(2000), @MainParentTaskId int 
   
 While @Min <= @Max  
  Begin  
   Select @TaskId = TaskId, @GroupId = GroupId From #TaskGroups Where Id = @Min  
   Select @ParentTaskId = T.ParentTaskId, @TempChatGroupName = T.InstallId,   
     @Title = '<a href="javascript:;">', @TempTitle = T.Title  
       From tblTask T With(NoLock) Where T.TaskId = @TaskId  
	   
	   If @TaskId IS NOT NULL AND @ParentTaskId IS NOT NULL
			Begin
				Set @Title = '<a onclick="event.stopPropagation();" href="/Sr_App/TaskGenerator.aspx?TaskId={MainParentTaskId}&hstid=' + Convert(Varchar(12),@TaskId) + '">'
			End
		Else IF @TaskId IS NOT NULL
			Begin
				Set @Title = '<a onclick="event.stopPropagation();" href="/Sr_App/TaskGenerator.aspx?TaskId=' + Convert(Varchar(12),@TaskId) + '">'
			End
   While @ParentTaskId Is Not Null  
    Begin  
		Select @TempChatGroupName = T.InstallId, @ParentTaskId = T.ParentTaskId, @TaskId = T.ParentTaskId  
			From tblTask T With(NoLock) Where T.TaskId = @TaskId And T.TaskId = @TaskId  
			Set @ChatGroupName =  @TempChatGroupName + '-' + @ChatGroupName  
		IF @ParentTaskId Is NOT NUll
			Begin
				Set @MainParentTaskId = @ParentTaskId
			End
    End  
   Set @Title = @Title + SUBSTRING(@ChatGroupName, 0, LEN(@ChatGroupName)) + '</a>-' + @TempTitle
   Set @Title = Replace(@Title,'{MainParentTaskId}',Convert(Varchar(12),@MainParentTaskId))
   
  
   Update G Set G.GroupNameAnchor = @Title From #OnlineUsersOrGroups G Where G.Id = @GroupId  
   Set @Min = @Min + 1  
  
   Set @Title = ''  
   Set @ChatGroupName = ''  
   Set @TempChatGroupName = ''  
   Set @TempTitle = ''  
  End  
   
   
-- Update GroupOrUsername if TaskId Is not null    
  
-- Update Unread Count  
Update G  
 Set G.UnreadCount = (Select Count(1) From ChatMessageReadStatus S With(NoLock) 
	Join ChatMessage M With(NoLock) On M.Id = S.ChatMessageId
	Where /*M.ChatGroupId=G.ChatGroupId And S.IsRead = 0 And S.ReceiverId = @LoggedInUserId*/
	S.IsRead = 0 And M.ChatGroupId=G.ChatGroupId And G.ReceiverIds like '%'+Convert(Varchar(12), M.SenderId) +'%' 
		And S.ReceiverId = @LoggedInUserId
	)  
 From #OnlineUsersOrGroups G  
-- Update Unread Count  
    
      
  Select* from #OnlineUsersOrGroups Order By /*MessageAt,*/ UserRank Desc      
  --Order By Max(M.CreatedOn) Desc      
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

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetUsersByIds' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetUsersByIds
  END
Go
 -- =============================================        
-- Author:  Jitendra Pancholi        
-- Create date: 27 Nov 2017     
-- Description: Get a list of top 5 users by starts with name, email   
-- =============================================      
/*  
	GetUsersByIds '3797,901'
	GetUsersByIds ''
*/  
Create PROCEDURE GetUsersByIds  
	@UserIds Varchar(800) = ''
AS      
BEGIN
	If @UserIds = ''
		Begin
			Select * From tblInstallUsers U With(NoLock)
		End
	Else
		Begin
			Select * From tblInstallUsers U With(NoLock) Where U.Id in (Select Result From dbo.CSVtoTable(@UserIds,','))
		End
End

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetChatMessagesByUsers' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetChatMessagesByUsers
  END
Go
 -- =============================================        
-- Author:  Jitendra Pancholi        
-- Create date: 27 Nov 2017     
-- Description: Get a list of top 5 users by starts with name, email   
-- =============================================      
/*  
	GetChatMessagesByUsers 3797,901,10
	GetChatMessagesByUsers 4848,3797
*/  
Create PROCEDURE GetChatMessagesByUsers  
	@UserId int,
	@ReceiverId int,
	@ChatSourceId int
AS      
BEGIN
	Select S.Id, S.ChatGroupId, S.ChatSourceId, S.SenderId, S.TextMessage, S.ChatFileId, S.ReceiverIds, S.CreatedOn,
			U.FristName As FirstName, U.LastName, (U.FristName + ' ' + U.LastName) As Fullname,
			U.UserInstallId, U.Picture, MS.IsRead
		From ChatMessage S With(NoLock)
			Join tblInstallUsers U With(NoLock) On S.SenderId = U.Id
			Join ChatMessageReadStatus MS With(NoLock) On S.Id = MS.ChatMessageId
		Where ((S.SenderId = @UserId And S.ReceiverIds = Convert(Varchar(12), @ReceiverId))
			Or (S.SenderId = @ReceiverId And S.ReceiverIds =  Convert(Varchar(12), @UserId)))
			/*And S.ChatSourceId = @ChatSourceId*/
			And S.ChatSourceId Not In (2)
		Order By S.CreatedOn Asc
End