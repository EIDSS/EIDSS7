

--##SUMMARY unpublish Layout

--##REMARKS Created by: Romasheva S.
--##REMARKS Date: 27.11.2013

--##REMARKS Updated by: Romasheva S.
--##REMARKS Date: 27.01.2014

--##RETURNS Don't use

/*

--Example of a call of procedure:

begin tran


set nocount on
declare 
	@idfsLayout bigint,
	@idflLayout bigint
	
set @idfsLayout = 6590000870	

exec spAsLayoutUnpublish @idfsLayout, @idflLayout out

print @idflLayout

rollback tran

*/ 


create PROCEDURE [dbo].[spAsLayoutUnpublish]
	 @idfsLayout		bigint --##PARAM @idfsLayout -  global layout id
	 ,@idflLayout		bigint OUTPUT	--##PARAM @idflLayout -  related local layout id
AS
set @idflLayout = null
begin
	if	not exists	(	
					select	*
					from	tasglLayout
					where	idfsLayout = @idfsLayout
					)
	begin
		Raiserror (N'Layout with ID=%I64d doesn''t exist.', 15, 1,  @idfsLayout)
		return 1
	end


	begin try
		-- update local tables
		--views
		update tv
		set
			tv.idfGlobalView = null
		from tasView tv
			inner join tasLayout tl
			on tl.idflLayout = tv.idflLayout
		where tl.idfsGlobalLayout = @idfsLayout
			
		--map images
		update tmi
			set tmi.idfGlobalMapImage = null 
		from tasMapImage tmi
			inner join tasLayoutToMapImage tltmi
			on tltmi.idfMapImage = tmi.idfMapImage
			inner join tasLayout tl
			on tl.idflLayout = tltmi.idflLayout
		where tl.idfsGlobalLayout	= @idfsLayout
			
		-- layouts
		select top 1 @idflLayout = idflLayout
		from tasLayout 
		where idfsGlobalLayout = @idfsLayout	

		update l
		set
			l.idfsGlobalLayout = null,
			l.blnReadOnly = 0
		from tasLayout l
		where l.idfsGlobalLayout = @idfsLayout	
			
		-- AVR Layout Name
		update br_l set
			br_l.intRowStatus = 1
		from		tasglLayout l
		inner join	trtBaseReference br_l
		on			br_l.idfsBaseReference = l.idfsLayout
					and br_l.idfsReferenceType = 19000050	-- AVR Layout Name
					and br_l.intRowStatus = 0
		where		l.idfsLayout = @idfsLayout
					

		-- AVR Layout Description
		update br_l set
			br_l.intRowStatus = 1
		from		tasglLayout l
		inner join	trtBaseReference br_l
		on			br_l.idfsBaseReference = l.idfsDescription
					and br_l.idfsReferenceType = 19000122	-- AVR Layout Description
					and br_l.intRowStatus = 0
		where		l.idfsLayout = @idfsLayout
					
		
		-- AVR Layout Field Name	
		update br_l set
			br_l.intRowStatus = 1
		from		tasglLayout l
		inner join	tasglLayoutSearchField lsf
		on			lsf.idfsLayout = l.idfsLayout
		inner join	trtBaseReference br_l
		on			br_l.idfsBaseReference = lsf.idfsLayoutSearchFieldName
					and br_l.idfsReferenceType = 19000143	-- AVR Layout Field Name
					and br_l.intRowStatus = 0
		where		l.idfsLayout = @idfsLayout
		
		-- AVR Layout Name	
		update snt set
			snt.intRowStatus = 1
		from		trtStringNameTranslation snt
		inner join	trtBaseReference br
		on			br.idfsBaseReference = snt.idfsBaseReference
					and br.idfsReferenceType = 19000050	-- AVR Layout Name
					and br.intRowStatus = 0
		inner join tasglLayout tl
		on			tl.idfsLayout = br.idfsBaseReference
					and tl.idfsLayout = @idfsLayout
		where		snt.intRowStatus = 0
					
								
		-- AVR Layout Description
		update snt set
			snt.intRowStatus = 1
		from		trtStringNameTranslation snt
		inner join	trtBaseReference br
		on			br.idfsBaseReference = snt.idfsBaseReference
					and br.idfsReferenceType = 19000122	-- AVR Layout Description
					and br.intRowStatus = 0
		inner join tasglLayout tl
		on			tl.idfsDescription = br.idfsBaseReference
					and tl.idfsLayout = @idfsLayout					
		where		snt.intRowStatus = 0
			
		-- AVR Layout Field Name	
		update snt set
			snt.intRowStatus = 1
		from		trtStringNameTranslation snt
		inner join	trtBaseReference br
		on			br.idfsBaseReference = snt.idfsBaseReference
					and br.idfsReferenceType = 19000143	-- AVR Layout Field Name
		inner join	tasglLayoutSearchField lsf
		on			lsf.idfsLayout = @idfsLayout
					and lsf.idfsLayoutSearchFieldName = br.idfsBaseReference		
		where		snt.intRowStatus = 0
		
		
		declare @ViewColumns table(idfViewColumn bigint primary key)
		
		insert into @ViewColumns (idfViewColumn)
		select distinct tglvc.idfViewColumn 
		from tasglViewColumn tglvc
			inner join tasglView tv 
			on tv.idfsLayout = @idfsLayout
			and tv.idfChartXAxisViewColumn = tglvc.idfViewColumn
			
			left join @ViewColumns vc
			on vc.idfViewColumn = tglvc.idfViewColumn
		where vc.idfViewColumn is null  
			
			
		insert into @ViewColumns (idfViewColumn)
		select distinct tglvc.idfViewColumn 
		from tasglViewColumn tglvc
			inner join tasglView tv 
			on	tv.idfsLayout = @idfsLayout
			and tv.idfMapAdminUnitViewColumn = tglvc.idfViewColumn  
			
			left join @ViewColumns vc
			on vc.idfViewColumn = tglvc.idfViewColumn
		where vc.idfViewColumn is null 
				
		insert into @ViewColumns (idfViewColumn)
		select distinct tglvc.idfViewColumn 
		from tasglViewColumn tglvc
			inner join tasglView tv 
				inner join tasglViewBand tvb
				on	tv.idfView = tvb.idfView
			on tv.idfsLayout = @idfsLayout
			and tvb.idfViewBand = tglvc.idfViewBand  
	
			left join @ViewColumns vc
			on vc.idfViewColumn = tglvc.idfViewColumn
		where vc.idfViewColumn is null 
		
		insert into @ViewColumns (idfViewColumn)
		select distinct tglvc.idfViewColumn 
		from tasglViewColumn tglvc
			inner join tasglView tv 
			on	tv.idfsLayout = @idfsLayout
			and tv.idfView = tglvc.idfView  
			
			left join @ViewColumns vc
			on vc.idfViewColumn = tglvc.idfViewColumn
		where vc.idfViewColumn is null 
		
		
		declare @ViewBands table (idfViewBand bigint primary key)
		
		insert into @ViewBands (idfViewBand)
		select distinct tglvb.idfViewBand from tasglViewBand tglvb
		left join @ViewBands vb
		on vb.idfViewBand = tglvb.idfViewBand
		where exists	(	
							select * 
							from	tasglView tv 
							where	tv.idfsLayout = @idfsLayout 
									and tv.idfView = tglvb.idfView
		) and vb.idfViewBand is null
		
		insert into @ViewBands (idfViewBand)
		select distinct tglvb.idfViewBand from tasglViewBand tglvb
		left join @ViewBands vb
		on vb.idfViewBand = tglvb.idfViewBand
		where exists	(
			select * from @ViewColumns vc
			inner join tasglViewColumn tvc
			on tvc.idfViewColumn = vc.idfViewColumn
			
			where tvc.idfViewBand = tglvb.idfViewBand
		)and vb.idfViewBand is null
		
		update tvc set
			tvc.idfViewBand = null
		from tasglViewBand tvb
		inner join @ViewBands vb
		on vb.idfViewBand = tvb.idfViewBand
		inner join tasglViewColumn tvc
		on tvc.idfViewBand = tvb.idfViewBand
		
		delete from tasglViewBand
		where exists (
			select * from @ViewBands vb
			where vb.idfViewBand = tasglViewBand.idfViewBand	
		)
		
		update tv set
			tv.idfChartXAxisViewColumn = null,
			tv.idfMapAdminUnitViewColumn = null
		from tasglView tv
		where idfsLayout = @idfsLayout
		
		delete from tasglViewColumn
		where exists
			(select * from @ViewColumns vc
				where vc.idfViewColumn = tasglViewColumn.idfViewColumn
			)
			
		delete from tasglView where idfsLayout = @idfsLayout
		
		declare @MapImage table (
			idfMapImage bigint primary key
		)

		insert into @MapImage 
		select distinct tmi.idfMapImage
		from tasglMapImage tmi
		where exists 
					(
						select * from tasglLayoutToMapImage ltmi
						where ltmi.idfMapImage =  tmi.idfMapImage
						and ltmi.idfsLayout = @idfsLayout
					)
		
		delete from tasglLayoutToMapImage
		where idfsLayout = @idfsLayout

		delete from tasglMapImage
		where exists (select * from @MapImage mi where mi.idfMapImage = tasglMapImage.idfMapImage)		
	
		delete from tasglLayoutSearchField where idfsLayout = @idfsLayout
	
		delete from tasglLayout where idfsLayout = @idfsLayout
		
		
		
			
	end try
	begin catch
		declare @error nvarchar(max)
		set @error = ERROR_PROCEDURE() +': '+ ERROR_MESSAGE()
		Raiserror (N'Error while unpublishing layout object: %s', 15, 1, @error)
		return 1
	end catch


	return 0
END
