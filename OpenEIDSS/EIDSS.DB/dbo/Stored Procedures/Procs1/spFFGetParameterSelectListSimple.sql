
 CREATE PROCEDURE dbo.spFFGetParameterSelectListSimple
 (
 	@LangID nvarchar(50) = null
 	,@idfsParameterType bigint
	,@idfsFormType bigint
 	,@intHACode bigint = null
 )	
 as
 begin	
 	set nocount on;	
 
 	if (@LangID is null) set @LangID = 'en'
 
    declare @idfsReferenceType bigint    
    
	
 	select top 1 
 		@idfsReferenceType = [idfsReferenceType]
 	from	dbo.ffParameterType
 	where	[idfsParameterType] = @idfsParameterType 
 			and [intRowStatus] = 0
 	
 	declare @aggParam		bit 			
 			
 	set @aggParam = 0 	
 	
 	if (	
 			(@idfsFormType = 10034012) Or 
 			(@idfsFormType = 10034021) Or 
 			(@idfsFormType = 10034022) Or 
 			(@idfsFormType = 10034023) Or 
 			(@idfsFormType = 10034024)
 	)	set @aggParam = 1 
 	else	
 		set @aggParam = 0
     

     if (@idfsReferenceType = 19000069 /*'rftParametersFixedPresetValue'*/) 
     begin       
     		print 1
 			select distinct
 				 --p.idfsParameter								as [idfsParameter]
 				--,
				p.idfsParameterType							as [idfsParameterType]
 				,cast(19000069 as bigint)/*'rftParametersFixedPresetValue'*/	as [idfsReferenceType]
 				,fpv.idfsParameterFixedPresetValue				as [idfsValue]
 				,cast(fr.LongName	as nvarchar(300))								as [strValueCaption]
 				,@LangID										as [langid] 
 				,fr.intOrder									as [intOrder]
 				,fr.intHACode									as [intHACode]
 				,p.[intRowStatus]								as [intRowStatus]
 			from	dbo.ffParameter p
 			inner join	dbo.ffParameterFixedPresetValue fpv 
 			on	p.idfsParameterType = fpv.idfsParameterType 
 				and fpv.[intRowStatus] = 0
 			inner join	dbo.fnReference(@LangID, 19000069 /*'rftParametersFixedPresetValue'*/) fr 
 			on	fpv.idfsParameterFixedPresetValue = fr.idfsReference
 			--where	p.idfsParameter = @idfsParameter
			Where p.idfsParameterType = @idfsParameterType
			--order by fr.intOrder asc, fr.LongName asc
			order by 6 asc, 4 asc
     end 
     else 
     if (@idfsReferenceType is Not null) 
     begin
          if (@idfsReferenceType = 19000019) 
          begin
          	if (@aggParam = 1) 
          	begin
 					select 
 						-- @idfsParameter			as [idfsParameter]
 						--,
						@idfsParameterType		as [idfsParameterType]
 						,@idfsReferenceType		as [idfsReferenceType]
 						,idfsReference			as [idfsValue]
 						,cast([name]	as nvarchar(300))				as [strValueCaption]
 						,@LangID				as [langid] 
 						,intOrder				as [intOrder]
 						,intHACode				as [intHACode]
 						,cast((case 
 							when d.idfsUsingType = 10020002 
 							then 0 
 							else 1 
 						  end)	as int)				as intRowStatus
 						--,d.idfsUsingType		as idfsUsingType
 					from dbo.fnReferenceRepair(@LangID, @idfsReferenceType)	 rl
 					inner join dbo.trtDiagnosis d 
 					on rl.idfsReference = d.idfsDiagnosis
 					order by intOrder asc, [name] asc
 			
          	end -- if (@aggParam = 1) 
          	else -- if (@aggParam = 0) 
          	begin
 				select 
 					-- @idfsParameter			as [idfsParameter]
 					--,
					@idfsParameterType		as [idfsParameterType]
 					,@idfsReferenceType		as [idfsReferenceType]
 					,idfsReference			as [idfsValue]
 					,cast([name]	as nvarchar(300))				as [strValueCaption]
 					,@LangID				as [langid] 
 					,intOrder				as [intOrder]
 					,intHACode				as [intHACode]
 					, cast((case when
 							 (								
 								D.idfsUsingType = 10020001							
 								and D.intRowStatus = 0
 								and RL.intRowStatus = 0
 								and	
 								(	@intHACode = 0
 										or @intHACode is null
 										or intHACode is null
 										or	case 
 											--1=animal, 32=LiveStock , 64=avian
 											--below we assume that client will never pass animal bit without livstock or avian bits
 												when (RL.intHACode & 97) > 1
 													then (~1 & RL.intHACode) & @intHACode 
 													-- if avian or livstock bits are set, clear animal bit in  b.intHA_Code
 													
 												when (RL.intHACode & 97) = 1 
 													then (~1 & RL.intHACode | 96) & @intHACode
 													--if only animal bit is set, 
 													--clear animal bit and set both avian and livstock bits in  b.intHA_Code
 													
 												else RL.intHACode & @intHACode
 											end >0
 								)
 							 )	then 0 else 1 end) as int)	as intRowStatus
 					  ---,D.idfsUsingType
 				from dbo.fnReferenceRepair(@LangID, @idfsReferenceType)	 RL
 				inner join dbo.trtDiagnosis D on RL.idfsReference = D.idfsDiagnosis		
 				order by intOrder asc, [name] asc
 			end
          end --if (@idfsReferenceType = 19000019) 
          else begin  --if (@idfsReferenceType <> 19000019)                	
 			select 
 				-- @idfsParameter			as [idfsParameter]
 				--,
				@idfsParameterType		as [idfsParameterType]
 				,@idfsReferenceType		as [idfsReferenceType]
 				,idfsReference			as [idfsValue]
 				,cast([name]as nvarchar(300))					as [strValueCaption]
 				,@LangID				as [langid] 
 				,Isnull([intOrder], 0)	as [intOrder]
 				,intHACode				as [intHACode]
 				,intRowStatus			as [intRowStatus]
 			from dbo.fnReferenceRepair(@LangID, @idfsReferenceType)
 			order by intOrder asc, [name] asc
 		end
     end --if (@idfsReferenceType is Not null) 
     else
     select 
 		-- cast(0 as bigint) as [idfsParameter]
 		--,
		cast(0 as bigint) as [idfsParameterType]
 		,cast(0 as bigint) as [idfsReferenceType]
 		,cast(0 as bigint) as [idfsValue]
 		,cast('' as nvarchar(300)) as [strValueCaption]
 		,@LangID as [langid]
 		,cast(0 as int) as [intOrder]
 		,cast(0 as int) as [intHACode]
 		,cast(0 as int) as intRowStatus	
     where null = null
 end
