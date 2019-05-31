
CREATE PROCEDURE [dbo].[spAUMVersionCompare_Post]
(
	@eidssVersionShort varchar(50)
	,@versionDatabaseShort varchar(50)
)
as
begin

	if	@eidssVersionShort is not null and @versionDatabaseShort is not null
		and not (	@eidssVersionShort like '%[^0-9.]%' collate Latin1_General_CI_AS
					or	(	@eidssVersionShort not like '%[^0-9.]%' collate Latin1_General_CI_AS
							and (	@eidssVersionShort not like N'%.%.%' collate Latin1_General_CI_AS
									or	(	@eidssVersionShort like N'%.%.%' collate Latin1_General_CI_AS
											and	(	@eidssVersionShort like N'%..%' collate Latin1_General_CI_AS
													or	(	@eidssVersionShort not like N'%..%' collate Latin1_General_CI_AS
															and (	@eidssVersionShort like N'.%' collate Latin1_General_CI_AS
																	or	@eidssVersionShort like N'%.' collate Latin1_General_CI_AS
																)
														)
												)
										)
								)
						)
				)
		and not (	@versionDatabaseShort like '%[^0-9.]%' collate Latin1_General_CI_AS
					or	(	@versionDatabaseShort not like '%[^0-9.]%' collate Latin1_General_CI_AS
							and (	@versionDatabaseShort not like N'%.%.%' collate Latin1_General_CI_AS
									or	(	@versionDatabaseShort like N'%.%.%' collate Latin1_General_CI_AS
											and	(	@versionDatabaseShort like N'%..%' collate Latin1_General_CI_AS
													or	(	@versionDatabaseShort not like N'%..%' collate Latin1_General_CI_AS
															and (	@versionDatabaseShort like N'.%' collate Latin1_General_CI_AS
																	or	@versionDatabaseShort like N'%.' collate Latin1_General_CI_AS
																)
														)
												)
										)
								)
						)
				)
	begin
		update	tstVersionCompare
		set		 [strModuleVersion] = @versionDatabaseShort
				,[strDatabaseVersion] = @versionDatabaseShort
		where	[strModuleName] = 'MainDatabaseVersion' collate Latin1_General_CI_AS
				and (	[strDatabaseVersion] <> @versionDatabaseShort collate Latin1_General_CI_AS
						or [strModuleVersion] <> @versionDatabaseShort collate Latin1_General_CI_AS
					)

		if not exists	(
				select top 1 1
				from	tstVersionCompare
				where	[strModuleName]='eidss' collate Latin1_General_CI_AS
						and [strModuleVersion]=@eidssVersionShort collate Latin1_General_CI_AS
						and [strDatabaseVersion]=@versionDatabaseShort collate Latin1_General_CI_AS
						)
		begin
			insert into tstVersionCompare ([strModuleName],[strModuleVersion],[strDatabaseVersion])
			values('eidss', @eidssVersionShort, @versionDatabaseShort)
		end      
	end

end

