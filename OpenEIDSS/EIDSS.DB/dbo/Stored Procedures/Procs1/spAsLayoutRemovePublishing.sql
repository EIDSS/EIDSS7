

--##SUMMARY unpublish Layout

--##REMARKS Created by: Romasheva S.
--##REMARKS Date: 27.11.2013

--##RETURNS Don't use

/*

--Example of a call of procedure:

-- exec [spAsLayoutRemovePublishing] 111

*/ 


create PROCEDURE [dbo].[spAsLayoutRemovePublishing]
	 @idfsLayout		bigint OUTPUT  --##PARAM @idfsLayout -  global layout id
	, @idflLayout		bigint = null out	--##PARAM @idfsLayout - Id of local layout 
AS
begin
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
		
	end try
	begin catch
		declare @error nvarchar(max)
		set @error = ERROR_PROCEDURE() +': '+ ERROR_MESSAGE()
		Raiserror (N'Error while removing publishing layout object: %s', 15, 1, @error)
		return 1
	end catch


	return 0
END
