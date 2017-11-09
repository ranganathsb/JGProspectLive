IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'JobSchedulerLog') AND type in (N'U'))
BEGIN
	CREATE TABLE JobSchedulerLog(
		Id Bigint Primary Key Identity(1,1),
		JobName Varchar(200) Not Null,
		StartsOn DateTime Not Null Default(GetDate()),
		EndsOn DateTime,
		ExecutionTime int
	)
END