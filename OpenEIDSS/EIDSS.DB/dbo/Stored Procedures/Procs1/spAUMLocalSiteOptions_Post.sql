
CREATE PROCEDURE [dbo].[spAUMLocalSiteOptions_Post]
(
	@versionUpdate varchar(50)	
)
AS
begin
	declare @version varchar(50);
	select @version = [strValue] from dbo.tstLocalSiteOptions where strName = 'DatabaseVersion' collate Latin1_General_CI_AS

	if	@versionUpdate is null return;
	if	len(@versionUpdate) = 0 return;
	if	@versionUpdate like '%[^0-9.]%' collate Latin1_General_CI_AS
		or	(	@versionUpdate not like '%[^0-9.]%' collate Latin1_General_CI_AS
				and (	@versionUpdate like N'%.%.%.%.%' collate Latin1_General_CI_AS
						or	@versionUpdate not like N'%.%.%.%' collate Latin1_General_CI_AS
						or	(	@versionUpdate like N'%.%.%.%' collate Latin1_General_CI_AS
								and	(	@versionUpdate like N'%..%' collate Latin1_General_CI_AS
										or	(	@versionUpdate not like N'%..%' collate Latin1_General_CI_AS
												and (	@versionUpdate like N'.%' collate Latin1_General_CI_AS
														or	@versionUpdate like N'%.' collate Latin1_General_CI_AS
													)
											)
									)
							)
					)
			)
		return;

	if	(@version is null)
		or len(@version) = 0
		set	@version = N'0.0.0.0' collate Latin1_General_CI_AS

	if	@version like '%[^0-9.]%' collate Latin1_General_CI_AS
		or	(	@version not like '%[^0-9.]%' collate Latin1_General_CI_AS
				and (	@version like N'%.%.%.%.%' collate Latin1_General_CI_AS
						or	@version not like N'%.%.%.%' collate Latin1_General_CI_AS
						or	(	@version like N'%.%.%.%' collate Latin1_General_CI_AS
								and	(	@version like N'%..%' collate Latin1_General_CI_AS
										or	(	@version not like N'%..%' collate Latin1_General_CI_AS
												and (	@version like N'.%' collate Latin1_General_CI_AS
														or	@version like N'%.' collate Latin1_General_CI_AS
													)
											)
									)
							)
					)
			)
		set	@version = N'0.0.0.0' collate Latin1_General_CI_AS


	
	declare	@Major int
	declare @Minor int
	declare	@Build int
	declare @Revision int
	
	set	@Major = cast(left(@version, charindex('.', @version, 0) - 1) as int)
	set	@Minor = cast(substring(@version, charindex('.', @version, 0) + 1, charindex('.', @version, charindex('.', @version, 0) + 1) - charindex('.', @version, 0) - 1) as int)
	set	@Build = cast(substring(@version, charindex('.', @version, charindex('.', @version, 0) + 1) + 1, len(@version) - charindex('.', reverse(@version)) - charindex('.', @version, charindex('.', @version, 0) + 1)) as int)
	set	@Revision = cast(right(@version, charindex('.', reverse(@version)) - 1) as int)

	declare	@MajorUpdate int
	declare @MinorUpdate int
	declare	@BuildUpdate int
	declare @RevisionUpdate int
	
	set	@MajorUpdate = cast(left(@versionUpdate, charindex('.', @versionUpdate, 0) - 1) as int)
	set	@MinorUpdate = cast(substring(@versionUpdate, charindex('.', @versionUpdate, 0) + 1, charindex('.', @versionUpdate, charindex('.', @versionUpdate, 0) + 1) - charindex('.', @versionUpdate, 0) - 1) as int)
	set	@BuildUpdate = cast(substring(@versionUpdate, charindex('.', @versionUpdate, charindex('.', @versionUpdate, 0) + 1) + 1, len(@versionUpdate) - charindex('.', reverse(@versionUpdate)) - charindex('.', @versionUpdate, charindex('.', @versionUpdate, 0) + 1)) as int)
	set	@RevisionUpdate = cast(right(@versionUpdate, charindex('.', reverse(@versionUpdate)) - 1) as int)

	if	(@MajorUpdate > @Major)
		or	(	@MajorUpdate = @Major
				and	(	@MinorUpdate > @Minor
						or	(	@MinorUpdate = @Minor
								and	(	@BuildUpdate > @Build
										or	(	@BuildUpdate = @Build
												and @RevisionUpdate > @Revision
											)
									)
							)
					)
			)
	begin
		update tstLocalSiteOptions
		set [strValue] = @versionUpdate 
		where strName = 'DatabaseVersion' collate Latin1_General_CI_AS
	end;
end;

