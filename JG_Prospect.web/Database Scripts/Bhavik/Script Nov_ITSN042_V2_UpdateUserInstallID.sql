USE [JGBS]
GO

TRUNCATE TABLE tblUserDesigLastSequenceNo
GO


UPDATE tblInstallUsers SET UserInstallId= NULL
GO

GO

DECLARE @U_id  int 
DECLARE @U_designation varchar(50)
DECLARE @U_desc_code varchar(50)


DECLARE c_customers CURSOR FOR
  SELECT Id,Designation FROM tblInstallUsers

   OPEN c_customers
   FETCH  c_customers into @U_id, @U_designation 

  WHILE @@FETCH_STATUS=0
	BEGIN
		IF @U_designation = 'Admin'
			SET @U_desc_code = 'ADM'
                 
		 ELSE IF @U_designation = 'Jr. Sales'
			SET @U_desc_code = 'JSL'
                
		ELSE IF @U_designation = 'Jr. Project Manager'
			SET @U_desc_code = 'JPM'

		ELSE IF @U_designation = 'Office Manager'
			SET @U_desc_code = 'OFM'	

		ELSE IF @U_designation = 'Recruiter'
			SET @U_desc_code = 'REC'

		ELSE IF @U_designation = 'Sales Manager'
			SET @U_desc_code = 'SLM'

		ELSE IF @U_designation = 'Sr. Sales'
			SET @U_desc_code = 'SSL'

		ELSE IF @U_designation = 'IT - Network Admin"'
			SET @U_desc_code = 'ITNA'

		ELSE IF @U_designation = 'IT - Jr .Net Developer'
			SET @U_desc_code = 'ITJN'

		ELSE IF @U_designation = 'IT - Sr .Net Developer'
			SET @U_desc_code = 'ITSN'

		ELSE IF @U_designation = 'IT - Android Developer'
			SET @U_desc_code = 'ITAD'

		ELSE IF @U_designation = 'IT - PHP Developer'
			SET @U_desc_code = 'ITPH'

		ELSE IF @U_designation = 'IT - SEO / BackLinking'
			SET @U_desc_code = 'ITSB'

		ELSE IF @U_designation = 'Installer - Helper'
			SET @U_desc_code = 'INH'

		ELSE IF @U_designation = 'Installer – Journeyman'
			SET @U_desc_code = 'INJ'

		ELSE IF @U_designation = 'Installer – Mechanic'
			SET @U_desc_code = 'INM'

		ELSE IF @U_designation = 'Installer - Lead mechanic'
			SET @U_desc_code = 'INLM'

		ELSE IF @U_designation = 'Installer – Foreman'
			SET @U_desc_code = 'INF'

		ELSE IF @U_designation = 'Commercial Only'
			SET @U_desc_code = 'COM'

		ELSE IF @U_designation = 'SubContractor'
			SET @U_desc_code = 'SBC'
		ELSE 
			SET @U_desc_code = 'OUID'

	exec USP_SetUserDisplayID @U_id, @U_desc_code, 'No'

	fetch next from c_customers into @U_id, @U_designation
      
	END

	CLOSE c_customers
DEALLOCATE c_customers
