DROP PROCEDURE UDP_deleteInstalluser
GO

/****** Object:  StoredProcedure [dbo].[DeleteInstallUsers]    Script Date: 03-Feb-17 9:59:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 19 Jan 2017
-- Description:	Deletes install users.
-- =============================================
ALTER PROCEDURE [dbo].[DeleteInstallUsers]
	@IDs IDs READONLY
AS
BEGIN

	DELETE
	FROM dbo.tblInstallUsers 
	WHERE Id IN (SELECT Id FROM @IDs)
	
 END
 GO

 /****** Object:  StoredProcedure [dbo].[DeleteInstallUsers]    Script Date: 03-Feb-17 9:59:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 19 Jan 2017
-- Description:	Deactivates install users.
-- =============================================
CREATE PROCEDURE [dbo].[DeactivateInstallUsers]
	@IDs IDs READONLY,
	@DeactiveStatus Varchar(5) = '3'
AS
BEGIN
	
	UPDATE dbo.tblInstallUsers 
	SET 
		[STATUS] = @DeactiveStatus
	WHERE Id IN (SELECT Id FROM @IDs)
       
 END
 GO


CREATE TABLE tblRoles_ApplicationFeatures
(
Id INT IDENTITY(1,1) UNIQUE NOT NULL,
RoleId INT NOT NULL,
ApplicationFeatureId INT NOT NULL,
IsEnabled BIT NOT NULL,
PRIMARY KEY(RoleId, ApplicationFeatureId)
)
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 07 Feb 2017
-- Description:	Gets all application features for role.
-- =============================================
CREATE PROCEDURE [dbo].[GetApplicationFeaturesByRoleId]
	@RoleId INT
AS
BEGIN
	
	SELECT *
	FROM tblRoles_ApplicationFeatures
	WHERE RoleId = @RoleId
	ORDER BY RoleId

 END
 GO

