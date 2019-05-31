

/*
select * from fn_RepositorySchema('en',null,null)
*/

create   FUNCTION dbo.fn_RepositorySchema(
					@LangID as nvarchar(50),
					@idfFreezer as bigint, 
					@idfSubdivision as bigint
)
returns @Tree table
		(
			ID					bigint not null,
			idfFreezer			bigint,
			strFreezerName		nvarchar(200) COLLATE database_default,
			idfsStorageType		bigint,
			idfsSubdivisionType	bigint,
			FreezerBarcode		nvarchar(200) COLLATE database_default,
			idfSubdivision		bigint,
			idfParentSubdivision bigint,
			SubdivisionBarcode	nvarchar(200) COLLATE database_default,
			SubdivisionName		nvarchar(200) COLLATE database_default,
			FreezerNote			nvarchar(200) COLLATE database_default,
			SubdivisionNote		nvarchar(200) COLLATE database_default,
			[Path]				nvarchar(200) COLLATE database_default,
			[Level]				int,
			intCapacity			int
		)
as
begin
--declare @Path 		varchar(200)
declare @Level 		int
declare @Inserted 	int
--declare @LevelID 	varchar(36)

	insert into @Tree(
				ID,
				idfFreezer,
				strFreezerName,
				idfsStorageType,
				FreezerBarcode,
				FreezerNote,
				--idfSubdivision,
				--idfParentSubdivision,
				--SubdivisionBarcode,
				--SubdivisionName,
				[Path],
				[Level]
			)
	(
	select		distinct
				tlbFreezer.idfFreezer,
				tlbFreezer.idfFreezer,
				tlbFreezer.strFreezerName,
				tlbFreezer.idfsStorageType,
				tlbFreezer.strBarcode,
				tlbFreezer.strNote,
				--tlbFreezerSubdivision.idfSubdivision,
				--tlbFreezerSubdivision.idfParentSubdivision,
				--tlbFreezerSubdivision.strBarcode,
				--tlbFreezerSubdivision.strNameChars,
				tlbFreezer.strFreezerName,-- + N'.' + tlbFreezerSubdivision.strNameChars,
				0
	from		tlbFreezer
	left join	tlbFreezerSubdivision
	on			tlbFreezer.idfFreezer = tlbFreezerSubdivision.idfFreezer and
				tlbFreezerSubdivision.intRowStatus=0
	where
				(
					((@idfSubdivision is null) and (tlbFreezerSubdivision.idfParentSubdivision is null))
					or
					((@idfSubdivision is not null) and (tlbFreezerSubdivision.idfSubdivision = @idfSubdivision))
				)
				and
				((@idfFreezer is null) or (tlbFreezer.idfFreezer = @idfFreezer))
				and tlbFreezer.intRowStatus = 0
				and tlbFreezer.idfsSite=dbo.fnSiteID()
	)
	set @Inserted = @@ROWCOUNT
	set @Level = 0

	while(@Inserted > 0)
	begin
		set @Inserted = 0
		insert into @Tree(
					ID,
					idfFreezer,
					strFreezerName,
				    FreezerNote,
					idfsStorageType,
					idfsSubdivisionType,
					FreezerBarcode,
					idfSubdivision,
					idfParentSubdivision,
					SubdivisionBarcode,
					SubdivisionName,
					SubdivisionNote,
					[Path],
					[Level],
					intCapacity
				)
		(
		select		tlbFreezerSubdivision.idfSubdivision,
					tlbFreezer.idfFreezer,
					tlbFreezer.strFreezerName,
					tlbFreezer.strNote,
					tlbFreezer.idfsStorageType,
					tlbFreezerSubdivision.idfsSubdivisionType,
					tlbFreezer.strBarcode,
					tlbFreezerSubdivision.idfSubdivision,
					isnull(tlbFreezerSubdivision.idfParentSubdivision,tlbFreezer.idfFreezer),
					tlbFreezerSubdivision.strBarcode,
					tlbFreezerSubdivision.strNameChars,
					tlbFreezerSubdivision.strNote,
					Tree.[Path] + N'.' + tlbFreezerSubdivision.strNameChars,
					@Level + 1,
					tlbFreezerSubdivision.intCapacity
		from		@Tree as Tree
		inner join	tlbFreezer
		on			tlbFreezer.idfFreezer = Tree.idfFreezer
		inner join	tlbFreezerSubdivision
		on			tlbFreezerSubdivision.idfParentSubdivision = Tree.idfSubdivision or
					(tlbFreezerSubdivision.idfParentSubdivision is null and tlbFreezerSubdivision.idfFreezer=Tree.idfFreezer and 0=@Level)
		where		Tree.[Level] = @Level
					and tlbFreezer.intRowStatus = 0
					and tlbFreezerSubdivision.intRowStatus = 0
		)
		set @Inserted = @@ROWCOUNT
		set @Level = @Level + 1

	end
return
end


