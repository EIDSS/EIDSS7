
CREATE FUNCTION [dbo].[fnEventLog_GetObjectType]
(
	@idfsEventType bigint
)
RETURNS NVARCHAR(50)
AS
BEGIN
RETURN CASE 
	WHEN @idfsEventType = 10025030	
	THEN N'Settlement'--Settlement Changed
	WHEN @idfsEventType in (
			10025037	--	New human case was created at your site
			,10025038	--New human case was created at another site
			,10025039	--Human case diagnosis was changed at your site
			,10025040	--Human case diagnosis was changed at another site
			,10025041	--Human case classification was changed at your site
			,10025042	--Human case classification was changed at another site
			,10025043	--New test result for human case was registered at your site
			,10025044	--New test result for human case was registered at another site
			,10025045	--Test result for human case was amended at your site
			,10025046	--Test result for human case was amended at another site
			,10025047	--Closed human case was re-opened at your site
			,10025048	--Closed human case was re-opened at another site
			)
	THEN N'HumanCase'
	WHEN @idfsEventType in (
			10025049	--New outbreak was created at your site
			,10025050	--New outbreak was created at another site
			,10025051	--New human case was added to outbreak at your site
			,10025052	--New human case was added to outbreak at another site
			,10025053	--New veterinary case was added to outbreak at your site
			,10025054	--New veterinary case was added to outbreak at another site
			,10025055	--New vector surveillance session was added to outbreak at your site
			,10025056	--New vector surveillance session was added to outbreak at another site
			,10025057	--Outbreak status was changed at your site
			,10025058	--Outbreak status was changed at another site
			,10025059	--Primary case was changed in outbreak at your site
			,10025060	--Primary case was changed in outbreak at another site
			)
	THEN N'Outbreak'
	WHEN @idfsEventType in (
			10025061	--New veterinary case was created at your site
			,10025062	--New veterinary case was created at another site
			,10025063	--Veterinary case diagnosis was changed at your site
			,10025064	--Veterinary case diagnosis was changed at another site
			,10025065	--Veterinary case classification was changed at your site
			,10025066	--Veterinary case classification was changed at another site
			,10025067	--New field test result for veterinary case was registered at your site
			,10025068	--New field test result for veterinary case was registered at another site
			,10025069	--New laboratory test result for veterinary case was registered at your site
			,10025070	--New laboratory test result for veterinary case was registered at another site
			,10025071	--Laboratory test result for veterinary case was amended at your site
			,10025072	--Laboratory test result for veterinary case was amended at another site
			,10025073	--Closed veterinary case was re-opened at your site
			,10025074	--Closed veterinary case was re-opened at another site
			)
	THEN N'VetCase'
	WHEN @idfsEventType in (
			10025075	--New vector surveillance session was created at your site
			,10025076	--New vector surveillance session was created at another site
			,10025077	--New diagnosis was detected for vector surveillance session at your site
			,10025078	--New diagnosis was detected for vector surveillance session at another site
			,10025079	--New field test result for vector surveillance session was registered at your site
			,10025080	--New field test result for vector surveillance session was registered at another site
			,10025081	--New laboratory test result for vector surveillance session was registered at your site
			,10025082	--New laboratory test result for vector surveillance session was registered at another site
			,10025083	--Laboratory test result for vector surveillance session was amended at your site
			,10025084	--Laboratory test result for vector surveillance session was amended at another site
			)
	THEN N'VsSession'
	WHEN @idfsEventType in (
			 10025087	--New active surveillance session was created at your site
			,10025088	--New active surveillance session was created at another site
			,10025091	--Closed active surveillance session was re-opened at your site
			,10025092	--Closed active surveillance session was re-opened at another site
			,10025093	--New test result for active surveillance session was registered at your site
			,10025094	--New test result for active surveillance session was registered at another site
			,10025095	--Test result for active surveillance session was amended at your site
			,10025096	--Test result for active surveillance session was amended at another site
			)
	THEN N'AsSession'
	WHEN @idfsEventType in (
			10025085	--New active surveillance campaign was created at your site
			,10025086	--New active surveillance campaign was created at another site
			,10025089	--Active surveillance campaign status was changed at your site
			,10025090	--Active surveillance campaign status was changed at another site
			)
	THEN N'AsCampaign'
	WHEN @idfsEventType in (
			10025097	--New human aggregate case was created at your site
			,10025098	--New human aggregate case was created at another site
			,10025099	--Human aggregate case was changed at your site
			,10025100	--Human aggregate case was changed at another site
			)
	THEN N'HumanAggrCase'
	WHEN @idfsEventType in (
			10025101	--New veterinary aggregate case was created at your site
			,10025102	--New veterinary aggregate case was created at another site
			,10025103	--Veterinary aggregate case was changed at your site
			,10025104	--Veterinary aggregate case was changed at another site
			)
	THEN N'VetAggrCase'
	WHEN @idfsEventType in (
			10025105	--New veterinary aggregate action was created at your site
			,10025106	--New veterinary aggregate action was created at another site
			,10025107	--Veterinary aggregate action was changed at your site
			,10025108	--Veterinary aggregate action was changed at another site
			)
	THEN N'VetAggrAction'
	WHEN @idfsEventType in (
			10025115	--New AVR layout was published at your site
			,10025117	--New AVR layout was shared at your site
			,10025116	--New AVR layout was published at another site
			,10025132   --unpublish local
			,10025133	--unpublish remote
			)
	THEN N'AvrLayout'
	WHEN @idfsEventType in (
			10025134	--New AVR folder was published at your site
			,10025135	--New AVR folder was published at another site
			,10025136	--New AVR folder was unpublished at your site
			,10025137	--New AVR folder was unpublished at another site
			)
	THEN N'AvrFolder'
	WHEN @idfsEventType in (
			10025138	--New AVR query was published at your site
			,10025139	--New AVR query was published at another site
			,10025140	--New AVR query was unpublished at your site
			,10025141	--New AVR query was unpublished at another site
			)
	THEN N'AvrQuery'
	WHEN @idfsEventType = 10025118	--Aggregate settings were changed
	THEN N'AggregateSettings'
	WHEN @idfsEventType = 10025119	--Security policy was changed
	THEN N'SecurityPolicy'
	WHEN @idfsEventType in (
			10025120	--UNI template for a flexible form type was changed
			,10025121	--Determinant for a flexible form template was changed
			)
	THEN N'FFDesigner'
	WHEN @idfsEventType = 10025122	--Reference table was changed
	THEN N'Reference'
	WHEN @idfsEventType = 10025123	--Matrix was changed
	THEN N'Matrix'
	WHEN @idfsEventType in (
			10025125	--New sample was transferred to your laboratory
			,10025131	--New sample was transferred from your laboratory	
			)	
	THEN N'SampleTransfer'
	WHEN @idfsEventType in(
			10025126	--Test result for sample transferred out from your laboratory  is entered
			,10025142	--Test result for sample transferred in to your laboratory  is entered
			)
	THEN N'Test'
	WHEN @idfsEventType in (
			10025127	--New Basic Syndromic Surveillance Form was created at your site
			,10025128	--New Basic Syndromic Surveillance Form was created at another site
			)
	THEN N'BssForm'
	WHEN @idfsEventType in (
		10025129	--New Basic Syndromic Surveillance Aggregate Form was created at your site
		,10025130	--New Basic Syndromic Surveillance Aggregate Form was created at another site
			)
	THEN N'BssAggrForm'
	ELSE
	/* 
	10025109	Replication requested by user
	10025110	Replication started
	10025111	Replication failed
	10025112	Replication retrying
	10025113	Replication succeeded
	10025114	Notification service is not running
	10025124	Raise Reference Cache Change
	*/
		N''
	END

END

