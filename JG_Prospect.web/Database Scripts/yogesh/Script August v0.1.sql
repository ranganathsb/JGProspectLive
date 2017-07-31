IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetUserAssignedDesigSequencnce]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_GetUserAssignedDesigSequencnce   

	END  
GO    
