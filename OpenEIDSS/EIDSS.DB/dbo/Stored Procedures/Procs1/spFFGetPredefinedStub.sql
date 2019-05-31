

-- =============================================
-- Author:		Leonov E.N.
-- Create date: 29.09.09
-- Description:	Return list of Parameter Editors

--##REMARKS Update date: 16.05.2013 by Romasheva S.
-- =============================================

/*

exec dbo.spFFGetPredefinedStub 71090000000, 6750110000000, 'en'
exec EIDSS_version6_actual.dbo.spFFGetPredefinedStub 71090000000, 6750110000000, 'en'


*/
CREATE PROCEDURE [dbo].[spFFGetPredefinedStub]
(
	@MatrixID Bigint
	,@VersionList Varchar(600) -- �������� ������ ���������
	,@LangID Nvarchar(50) = Null
	,@idfsFormTemplate Bigint = Null
	
	/*    
    VetCase = 71090000000
    DiagnosticAction = 71460000000
    ProphylacticAction = 71300000000
    HumanCase = 71190000000
    SanitaryAction = 71260000000
    FormN1= 82350000000 ������� ��� � HumanCase
    */
)	
AS
BEGIN	
	Set Nocount On;
	
	If (@LangID Is Null) Set @LangID = 'en';
	Declare @langid_int Bigint
	Set @langid_int = dbo.fnGetLanguageCode(@LangID);	

	Declare @idfVersion Bigint

	If (Len(@VersionList) = 0) Begin		
		Select Top 1 @idfVersion = [idfVersion] From dbo.tlbAggrMatrixVersionHeader Where idfsMatrixType = @MatrixID And [blnIsActive]= 1 ORDER BY CAST(ISNULL(blnIsDefault,0) AS INT)+CAST(ISNULL(blnIsActive,0) AS INT) DESC, datStartDate DESC

		Set @VersionList = Cast(@idfVersion As Varchar(600));
	End;	

	Declare @StubTable As Table 
	(	
		idfVersion Bigint	
		,idfRow Bigint
		,idfsParameter Bigint
		,strDefaultParameterName Nvarchar(400)
		,idfsParameterValue Sql_variant
		,NumRow Int
		,[strNameValue] Nvarchar(200)
		,[idfsSection] Bigint		
	)
	
	Declare @idfRow Bigint
				,@idfsParameter Bigint
				,@strDefaultParameterName Nvarchar(600)
				,@idfsParameterValue Sql_variant
				,@strNameValue Nvarchar(600)
				,@idfRowCurrent Bigint -- ��� �������� �����
				,@NumRowCurrent Int -- ��� �������� �����
				,@NumRowTemp Int -- ��� �������� �����
				,@currentVersion Bigint
	
	Declare @VersionTable Table (
		[idfVersion] Bigint
	)
	
	Insert into @VersionTable
	(
		[idfVersion]
	)
	Select Cast([Value] As Bigint) From [dbo].[fnsysSplitList](@VersionList, null, null)
	
	-- ���� ������ �� ������, �� ��������� �. ������ ����� ���������� ������ � ������ ���������� ����� ��� ����������� ����� ������.
	-- ���� �������� ��������� ������ � ���������, �� ������ ����� ������� null � ������, ����� �� ������� ��������
	If (@idfVersion Is Null) Begin
		If Exists(Select Top 1 1 From @VersionTable Having Count([idfVersion]) = 1) Select Top 1 @idfVersion = [idfVersion] From @VersionTable
	End
	
	declare @tlbAggrMatrixVersion table
	(
		idfAggrMatrixVersion bigint identity(1,1) not null primary key,
		idfVersion bigint not null,
		intNumRow int null, 
		intColumnOrder int not null,
		idfRow bigint not null,
		idfsParameter bigint,
		strParameterName nvarchar(2000),
		varValue sql_variant,
		strParameterRefValue  nvarchar(2000)
	)
	
	declare 
		@VetCaseMTX bigint,
		@ProphylacticMTX bigint,
		@DiagnosticMTX bigint,
		@HumanCaseMTX bigint,
		@SanitaryMTX bigint
		
	set @VetCaseMTX = 71090000000		--Vet Aggregate Case
	set @ProphylacticMTX = 71300000000	--Treatment-prophylactics and vaccination measures
	set @DiagnosticMTX = 71460000000	--Diagnostic investigations
	set @HumanCaseMTX = 71190000000	--Human Aggregate Case
	set @SanitaryMTX = 71260000000	--Veterinary-sanitary measures
	
		
	declare 
		-- VetCaseMTX
		@vac_SpeciesColumn bigint,
		@vac_SpeciesColumnName nvarchar(2000),
		@vac_SpeciesColumnOrder int,
		
		@vac_DiagnosisColumn bigint,
		@vac_DiagnosisColumnName nvarchar(2000),
		@vac_DiagnosisColumnOrder int,
		
		@vac_OIECodeColumn bigint,
		@vac_OIECodeColumnName nvarchar(2000),
		@vac_OIECodeColumnOrder int,
		
		--ProphylacticMTX
		@p_SpeciesColumn bigint,
		@p_SpeciesColumnName nvarchar(2000),
		@p_SpeciesColumnOrder int,
		
		@p_DiagnosisColumn bigint,
		@p_DiagnosisColumnName nvarchar(2000),
		@p_DiagnosisColumnOrder int,
		
		@p_OIECodeColumn bigint,
		@p_OIECodeColumnName nvarchar(2000),
		@p_OIECodeColumnOrder int,	
			
		@p_ProphylacticColumn bigint,
		@p_ProphylacticColumnName nvarchar(2000),
		@p_ProphylacticColumnOrder int,
		
		@p_ProphylacticCodeColumn bigint,
		@p_ProphylacticCodeColumnName nvarchar(2000),
		@p_ProphylacticCodeColumnOrder int,
		
		--DiagnosticMTX
		@d_SpeciesColumn bigint,
		@d_SpeciesColumnName nvarchar(2000),
		@d_SpeciesColumnOrder int,
		
		@d_DiagnosisColumn bigint,
		@d_DiagnosisColumnName nvarchar(2000),
		@d_DiagnosisColumnOrder int,
		
		@d_OIECodeColumn bigint,
		@d_OIECodeColumnName nvarchar(2000),
		@d_OIECodeColumnOrder int,	
			
		@d_DiagnosticColumn bigint,
		@d_DiagnosticColumnName nvarchar(2000),
		@d_DiagnosticColumnOrder int,
		
		--HumanCaseMTX
		@hc_DiagnosisColumn bigint,
		@hc_DiagnosisColumnName nvarchar(2000),
		@hc_DiagnosisColumnOrder int,		
		
		@hc_ICD10CodeColumn bigint,
		@hc_ICD10CodeColumnName nvarchar(2000),
		@hc_ICD10CodeColumnOrder int,
		
		--SanitaryMTX
		@s_SanitaryActionColumn bigint,
		@s_SanitaryActionColumnName nvarchar(2000),
		@s_SanitaryActionColumnOrder int,
		
		@s_SanitaryActionCodeColumn bigint,
		@s_SanitaryActionCodeColumnName nvarchar(2000),
		@s_SanitaryActionCodeColumnOrder int
			
	-- VetCaseMTX		
	set @vac_SpeciesColumn = 239010000000
	set @vac_DiagnosisColumn = 226910000000
	set @vac_OIECodeColumn = 234410000000
	
	--ProphylacticMTX
	set @p_SpeciesColumn = 239050000000
	set @p_DiagnosisColumn = 226950000000
	set @p_OIECodeColumn = 234450000000
	set @p_ProphylacticColumn = 245270000000
	set @p_ProphylacticCodeColumn = 233170000000
	
	--DiagnosticMTX
	set @d_SpeciesColumn = 239030000000
	set @d_DiagnosisColumn = 226930000000
	set @d_OIECodeColumn = 234430000000
	set @d_DiagnosticColumn = 231670000000
	
	--HumanCaseMTX
	set @hc_DiagnosisColumn = 226890000000
	set @hc_ICD10CodeColumn = 229630000000	
	
	--SanitaryMTX
	set @s_SanitaryActionColumn = 233190000000
	set @s_SanitaryActionCodeColumn = 233150000000	
	
	
	-- VetCaseMTX
	select @vac_SpeciesColumnName = ref_MatrixColumn.[name], @vac_SpeciesColumnOrder = mc.intColumnOrder
	from dbo.trtMatrixColumn mc
		inner join fnReference(@LangID, 19000152 /*rftMatrixColumn*/) ref_MatrixColumn
		on ref_MatrixColumn.idfsReference = mc.idfsMatrixColumn
	where mc.idfsMatrixColumn = @vac_SpeciesColumn		
		
	select @vac_DiagnosisColumnName = ref_MatrixColumn.[name], @vac_DiagnosisColumnOrder = mc.intColumnOrder
	from dbo.trtMatrixColumn mc
		inner join fnReference(@LangID, 19000152 /*rftMatrixColumn*/) ref_MatrixColumn
		on ref_MatrixColumn.idfsReference = mc.idfsMatrixColumn
	where mc.idfsMatrixColumn = @vac_DiagnosisColumn
		
	select @vac_OIECodeColumnName = ref_MatrixColumn.[name], @vac_OIECodeColumnOrder = mc.intColumnOrder
	from dbo.trtMatrixColumn mc
		inner join fnReference(@LangID, 19000152 /*rftMatrixColumn*/) ref_MatrixColumn
		on ref_MatrixColumn.idfsReference = mc.idfsMatrixColumn
	where mc.idfsMatrixColumn = @vac_OIECodeColumn	
		
	--ProphylacticMTX
	select @p_SpeciesColumnName = ref_MatrixColumn.[name], @p_SpeciesColumnOrder = mc.intColumnOrder
	from dbo.trtMatrixColumn mc
		inner join fnReference(@LangID, 19000152 /*rftMatrixColumn*/) ref_MatrixColumn
		on ref_MatrixColumn.idfsReference = mc.idfsMatrixColumn
	where mc.idfsMatrixColumn = @p_SpeciesColumn		
		
	select @p_DiagnosisColumnName = ref_MatrixColumn.[name], @p_DiagnosisColumnOrder = mc.intColumnOrder
	from dbo.trtMatrixColumn mc
		inner join fnReference(@LangID, 19000152 /*rftMatrixColumn*/) ref_MatrixColumn
		on ref_MatrixColumn.idfsReference = mc.idfsMatrixColumn
	where mc.idfsMatrixColumn = @p_DiagnosisColumn
		
	select @p_OIECodeColumnName = ref_MatrixColumn.[name], @p_OIECodeColumnOrder = mc.intColumnOrder
	from dbo.trtMatrixColumn mc
		inner join fnReference(@LangID, 19000152 /*rftMatrixColumn*/) ref_MatrixColumn
		on ref_MatrixColumn.idfsReference = mc.idfsMatrixColumn
	where mc.idfsMatrixColumn = @p_OIECodeColumn	
		
	select @p_ProphylacticColumnName = ref_MatrixColumn.[name], @p_ProphylacticColumnOrder = mc.intColumnOrder
	from dbo.trtMatrixColumn mc
		inner join fnReference(@LangID, 19000152 /*rftMatrixColumn*/) ref_MatrixColumn
		on ref_MatrixColumn.idfsReference = mc.idfsMatrixColumn
	where mc.idfsMatrixColumn = @p_ProphylacticColumn	
		
	select @p_ProphylacticCodeColumnName = ref_MatrixColumn.[name], @p_ProphylacticCodeColumnOrder = mc.intColumnOrder
	from dbo.trtMatrixColumn mc
		inner join fnReference(@LangID, 19000152 /*rftMatrixColumn*/) ref_MatrixColumn
		on ref_MatrixColumn.idfsReference = mc.idfsMatrixColumn
	where mc.idfsMatrixColumn = @p_ProphylacticCodeColumn	

	--DiagnosticMTX
	select @d_SpeciesColumnName = ref_MatrixColumn.[name], @d_SpeciesColumnOrder = mc.intColumnOrder
	from dbo.trtMatrixColumn mc
		inner join fnReference(@LangID, 19000152 /*rftMatrixColumn*/) ref_MatrixColumn
		on ref_MatrixColumn.idfsReference = mc.idfsMatrixColumn
	where mc.idfsMatrixColumn = @d_SpeciesColumn		
		
	select @d_DiagnosisColumnName = ref_MatrixColumn.[name], @d_DiagnosisColumnOrder = mc.intColumnOrder
	from dbo.trtMatrixColumn mc
		inner join fnReference(@LangID, 19000152 /*rftMatrixColumn*/) ref_MatrixColumn
		on ref_MatrixColumn.idfsReference = mc.idfsMatrixColumn
	where mc.idfsMatrixColumn = @d_DiagnosisColumn
		
	select @d_OIECodeColumnName = ref_MatrixColumn.[name], @d_OIECodeColumnOrder = mc.intColumnOrder
	from dbo.trtMatrixColumn mc
		inner join fnReference(@LangID, 19000152 /*rftMatrixColumn*/) ref_MatrixColumn
		on ref_MatrixColumn.idfsReference = mc.idfsMatrixColumn
	where mc.idfsMatrixColumn = @d_OIECodeColumn	
		
	select @d_DiagnosticColumnName = ref_MatrixColumn.[name], @d_DiagnosticColumnOrder = mc.intColumnOrder
	from dbo.trtMatrixColumn mc
		inner join fnReference(@LangID, 19000152 /*rftMatrixColumn*/) ref_MatrixColumn
		on ref_MatrixColumn.idfsReference = mc.idfsMatrixColumn
	where mc.idfsMatrixColumn = @d_DiagnosticColumn

	--HumanCaseMTX
	select @hc_DiagnosisColumnName = ref_MatrixColumn.[name], @hc_DiagnosisColumnOrder = mc.intColumnOrder
	from dbo.trtMatrixColumn mc
		inner join fnReference(@LangID, 19000152 /*rftMatrixColumn*/) ref_MatrixColumn
		on ref_MatrixColumn.idfsReference = mc.idfsMatrixColumn
	where mc.idfsMatrixColumn = @hc_DiagnosisColumn
		
	select @hc_ICD10CodeColumnName = ref_MatrixColumn.[name], @hc_ICD10CodeColumnOrder = mc.intColumnOrder
	from dbo.trtMatrixColumn mc
		inner join fnReference(@LangID, 19000152 /*rftMatrixColumn*/) ref_MatrixColumn
		on ref_MatrixColumn.idfsReference = mc.idfsMatrixColumn
	where mc.idfsMatrixColumn = @hc_ICD10CodeColumn		
		
		
	--SanitaryMTX
	select @s_SanitaryActionColumnName = ref_MatrixColumn.[name], @s_SanitaryActionColumnOrder = mc.intColumnOrder
	from dbo.trtMatrixColumn mc
		inner join fnReference(@LangID, 19000152 /*rftMatrixColumn*/) ref_MatrixColumn
		on ref_MatrixColumn.idfsReference = mc.idfsMatrixColumn
	where mc.idfsMatrixColumn = @s_SanitaryActionColumn
		
	select @s_SanitaryActionCodeColumnName = ref_MatrixColumn.[name], @s_SanitaryActionCodeColumnOrder = mc.intColumnOrder
	from dbo.trtMatrixColumn mc
		inner join fnReference(@LangID, 19000152 /*rftMatrixColumn*/) ref_MatrixColumn
		on ref_MatrixColumn.idfsReference = mc.idfsMatrixColumn
	where mc.idfsMatrixColumn = @s_SanitaryActionCodeColumn		
	
	

		
		
	if @MatrixID = @VetCaseMTX	--Vet Aggregate Case
	begin
		insert @tlbAggrMatrixVersion 
			(idfVersion, intNumRow, intColumnOrder, idfRow, idfsParameter, strParameterName, varValue,	strParameterRefValue)
		select
			idfVersion, 
			intNumRow, 
			intColumnOrder, 
			idfRow, 
			
			idfsParameter, 
			strParameterName, 
			varValue,	
			strParameterRefValue
	
		from	(
						select 
							mtx.idfVersion							as idfVersion,
							mtx.intNumRow							as intNumRow,
							mtx.idfAggrVetCaseMTX					as idfRow,
							
							@vac_SpeciesColumnOrder					as intColumnOrder1,
							@vac_SpeciesColumn						as idfsParameter1,
							@vac_SpeciesColumnName					as strParameterName1,
							cast(mtx.idfsSpeciesType as sql_variant)as varValue1,	
							cast(ref_Species.[name] as nvarchar(2000))						as strParameterRefValue1,
							
							@vac_DiagnosisColumnOrder				as intColumnOrder2,
							@vac_DiagnosisColumn					as idfsParameter2,
							@vac_DiagnosisColumnName				as strParameterName2,
							cast(mtx.idfsDiagnosis as sql_variant)	as varValue2,
							cast(ref_Diagnosis.[name] as nvarchar(2000))					as strParameterRefValue2,
											
							@vac_OIECodeColumnOrder					as intColumnOrder3,
							@vac_OIECodeColumn						as idfsParameter3,
							@vac_OIECodeColumnName					as strParameterName3,
							cast(d.strOIECode as sql_variant)		as varValue3,
							cast('' collate Cyrillic_General_CI_AS  as nvarchar(2000))				as strParameterRefValue3 
					from dbo.tlbAggrVetCaseMTX mtx
						inner join fnReferenceRepair(@LangID, 19000086	/*rftSpeciesList*/) ref_Species
						on ref_Species.idfsReference = mtx.idfsSpeciesType
						
						inner join trtDiagnosis d
						on d.idfsDiagnosis = mtx.idfsDiagnosis
						
						inner join fnReferenceRepair(@LangID, 19000019	/*rftDiagnosis*/) ref_Diagnosis
						on ref_Diagnosis.idfsReference = d.idfsDiagnosis		
					where exists (select * from @VersionTable where mtx.idfVersion =  [idfVersion])
					and mtx.intRowStatus = 0
				) as s
			unpivot ( intColumnOrder		FOR intColumnOrders			IN (intColumnOrder1, intColumnOrder2, intColumnOrder3)) as unpvt_ColumnOrders
			unpivot ( idfsParameter			FOR idfsParameters			IN (idfsParameter1, idfsParameter2, idfsParameter3)) as unpvt_idfsParameters
			unpivot ( strParameterName		FOR strParameterNames		IN (strParameterName1, strParameterName2, strParameterName3)) as unpvt_strParameterNames
			unpivot ( varValue				FOR varValues				IN (varValue1, varValue2, varValue3)) as unpvt_varValues
			unpivot ( strParameterRefValue	FOR strParameterRefValues	IN (strParameterRefValue1, strParameterRefValue2, strParameterRefValue3)) as unpvt_strParameterRefValues
		where	right(intColumnOrders,1) =  right(idfsParameters,1) and
				right(intColumnOrders,1) =  right(strParameterNames,1) and
				right(intColumnOrders,1) =  right(varValues,1) and
				right(intColumnOrders,1) =  right(strParameterRefValues,1)

	end
	else
	if @MatrixID = @ProphylacticMTX	--Treatment-prophylactics and vaccination measures
	begin
		insert @tlbAggrMatrixVersion 
			(idfVersion, intNumRow, intColumnOrder, idfRow, idfsParameter, strParameterName, varValue,	strParameterRefValue)
		select
			idfVersion, 
			intNumRow, 
			intColumnOrder, 
			idfRow, 
			
			idfsParameter, 
			strParameterName, 
			varValue,	
			strParameterRefValue
	
		from	(
						select 
							mtx.idfVersion							as idfVersion,
							mtx.intNumRow							as intNumRow,
							mtx.idfAggrProphylacticActionMTX		as idfRow,
							
							@p_SpeciesColumnOrder					as intColumnOrder1,
							@p_SpeciesColumn						as idfsParameter1,
							@p_SpeciesColumnName					as strParameterName1,
							cast(mtx.idfsSpeciesType as sql_variant)as varValue1,	
							ref_Species.[name]						as strParameterRefValue1,
							
							@p_DiagnosisColumnOrder					as intColumnOrder2,
							@p_DiagnosisColumn						as idfsParameter2,
							@p_DiagnosisColumnName					as strParameterName2,
							cast(mtx.idfsDiagnosis as sql_variant)	as varValue2,
							ref_Diagnosis.[name]					as strParameterRefValue2,
											
							@p_OIECodeColumnOrder					as intColumnOrder3,
							@p_OIECodeColumn						as idfsParameter3,
							@p_OIECodeColumnName					as strParameterName3,
							cast(d.strOIECode as sql_variant)		as varValue3,
							cast(''  collate Cyrillic_General_CI_AS as nvarchar(2000))				as strParameterRefValue3,
							
							@p_ProphylacticColumnOrder						as intColumnOrder4,
							@p_ProphylacticColumn							as idfsParameter4,
							@p_ProphylacticColumnName						as strParameterName4,
							cast(mtx.idfsProphilacticAction as sql_variant)	as varValue4,
							ref_ProphilacticAction.[name]					as strParameterRefValue4,
							
							@p_ProphylacticCodeColumnOrder					as intColumnOrder5,
							@p_ProphylacticCodeColumn						as idfsParameter5,
							@p_ProphylacticCodeColumnName					as strParameterName5,
							cast(pa.strActionCode as sql_variant)			as varValue5,
							cast(''  collate Cyrillic_General_CI_AS as nvarchar(2000))						as strParameterRefValue5
							
					from dbo.tlbAggrProphylacticActionMTX mtx
						inner join fnReferenceRepair(@LangID, 19000086	/*rftSpeciesList*/) ref_Species
						on ref_Species.idfsReference = mtx.idfsSpeciesType
						
						inner join trtDiagnosis d
						on d.idfsDiagnosis = mtx.idfsDiagnosis
						
						inner join fnReferenceRepair(@LangID, 19000019	/*rftDiagnosis*/) ref_Diagnosis
						on ref_Diagnosis.idfsReference = d.idfsDiagnosis		
						
						inner join fnReferenceRepair(@LangID, 19000074	/*rftProphilacticActionList*/) ref_ProphilacticAction
						on ref_ProphilacticAction.idfsReference = mtx.idfsProphilacticAction		
			
						inner join trtProphilacticAction pa
						on pa.idfsProphilacticAction = mtx.idfsProphilacticAction
						
					where exists (select * from @VersionTable where mtx.idfVersion =  [idfVersion])
					and mtx.intRowStatus = 0
				) as s
			unpivot ( intColumnOrder		FOR intColumnOrders			IN (intColumnOrder1, intColumnOrder2, intColumnOrder3, intColumnOrder4, intColumnOrder5)) as unpvt_ColumnOrders
			unpivot ( idfsParameter			FOR idfsParameters			IN (idfsParameter1, idfsParameter2, idfsParameter3, idfsParameter4, idfsParameter5)) as unpvt_idfsParameters
			unpivot ( strParameterName		FOR strParameterNames		IN (strParameterName1, strParameterName2, strParameterName3, strParameterName4, strParameterName5)) as unpvt_strParameterNames
			unpivot ( varValue				FOR varValues				IN (varValue1, varValue2, varValue3, varValue4, varValue5)) as unpvt_varValues
			unpivot ( strParameterRefValue FOR strParameterRefValues	IN (strParameterRefValue1, strParameterRefValue2, strParameterRefValue3, strParameterRefValue4, strParameterRefValue5)) as unpvt_strParameterRefValues
		where	right(intColumnOrders,1) =  right(idfsParameters,1) and
				right(intColumnOrders,1) =  right(strParameterNames,1) and
				right(intColumnOrders,1) =  right(varValues,1) and
				right(intColumnOrders,1) =  right(strParameterRefValues,1)
	
	end
	else
	if @MatrixID = 71460000000	--Diagnostic investigations
	begin
		insert @tlbAggrMatrixVersion 
			(idfVersion, intNumRow, intColumnOrder, idfRow, idfsParameter, strParameterName, varValue,	strParameterRefValue)
		select
			idfVersion, 
			intNumRow, 
			intColumnOrder, 
			idfRow, 
			
			idfsParameter, 
			strParameterName, 
			varValue,	
			strParameterRefValue
	
		from	(
						select 
							mtx.idfVersion							as idfVersion,
							mtx.intNumRow							as intNumRow,
							mtx.idfAggrDiagnosticActionMTX			as idfRow,
							
							@d_SpeciesColumnOrder					as intColumnOrder1,
							@d_SpeciesColumn						as idfsParameter1,
							@d_SpeciesColumnName					as strParameterName1,
							cast(mtx.idfsSpeciesType as sql_variant)as varValue1,	
							ref_Species.[name]						as strParameterRefValue1,
							
							@d_DiagnosisColumnOrder					as intColumnOrder2,
							@d_DiagnosisColumn						as idfsParameter2,
							@d_DiagnosisColumnName					as strParameterName2,
							cast(mtx.idfsDiagnosis as sql_variant)	as varValue2,
							ref_Diagnosis.[name]					as strParameterRefValue2,
											
							@d_OIECodeColumnOrder					as intColumnOrder3,
							@d_OIECodeColumn						as idfsParameter3,
							@d_OIECodeColumnName					as strParameterName3,
							cast(d.strOIECode as sql_variant)		as varValue3,
							cast(''  collate Cyrillic_General_CI_AS as nvarchar(2000))				as strParameterRefValue3,
							
							@d_DiagnosticColumnOrder						as intColumnOrder4,
							@d_DiagnosticColumn								as idfsParameter4,
							@d_DiagnosticColumnName							as strParameterName4,
							cast(mtx.idfsDiagnosticAction as sql_variant)	as varValue4,
							ref_DiagnosticAction.[name]						as strParameterRefValue4
							
					from dbo.tlbAggrDiagnosticActionMTX mtx
						inner join fnReferenceRepair(@LangID, 19000086	/*rftSpeciesList*/) ref_Species
						on ref_Species.idfsReference = mtx.idfsSpeciesType
						
						inner join trtDiagnosis d
						on d.idfsDiagnosis = mtx.idfsDiagnosis
						
						inner join fnReferenceRepair(@LangID, 19000019	/*rftDiagnosis*/) ref_Diagnosis
						on ref_Diagnosis.idfsReference = d.idfsDiagnosis		
						
						inner join fnReferenceRepair(@LangID, 19000021 /*rftDiagnosticActionList*/) ref_DiagnosticAction
						on ref_DiagnosticAction.idfsReference = mtx.idfsDiagnosticAction	
						
					where exists (select * from @VersionTable where mtx.idfVersion =  [idfVersion])
					and mtx.intRowStatus = 0
				) as s
			unpivot ( intColumnOrder		FOR intColumnOrders			IN (intColumnOrder1, intColumnOrder2, intColumnOrder3, intColumnOrder4)) as unpvt_ColumnOrders
			unpivot ( idfsParameter			FOR idfsParameters			IN (idfsParameter1, idfsParameter2, idfsParameter3, idfsParameter4)) as unpvt_idfsParameters
			unpivot ( strParameterName		FOR strParameterNames		IN (strParameterName1, strParameterName2, strParameterName3, strParameterName4)) as unpvt_strParameterNames
			unpivot ( varValue				FOR varValues				IN (varValue1, varValue2, varValue3, varValue4)) as unpvt_varValues
			unpivot ( strParameterRefValue FOR strParameterRefValues	IN (strParameterRefValue1, strParameterRefValue2, strParameterRefValue3, strParameterRefValue4)) as unpvt_strParameterRefValues
		where	right(intColumnOrders,1) =  right(idfsParameters,1) and
				right(intColumnOrders,1) =  right(strParameterNames,1) and
				right(intColumnOrders,1) =  right(varValues,1) and
				right(intColumnOrders,1) =  right(strParameterRefValues,1)	
				
	end
	else
	if @MatrixID = 71190000000	--Human Aggregate Case
	begin
		insert @tlbAggrMatrixVersion 
			(idfVersion, intNumRow, intColumnOrder, idfRow, idfsParameter, strParameterName, varValue,	strParameterRefValue)
		select
			idfVersion, 
			intNumRow, 
			intColumnOrder, 
			idfRow, 
			
			idfsParameter, 
			strParameterName, 
			varValue,	
			strParameterRefValue
	
		from	(
						select 
							mtx.idfVersion							as idfVersion,
							mtx.intNumRow							as intNumRow,
							mtx.idfAggrHumanCaseMTX					as idfRow,
							
							@hc_DiagnosisColumnOrder				as intColumnOrder1,
							@hc_DiagnosisColumn						as idfsParameter1,
							@hc_DiagnosisColumnName					as strParameterName1,
							cast(mtx.idfsDiagnosis as sql_variant)	as varValue1,
							ref_Diagnosis.[name]					as strParameterRefValue1,
											
							@hc_ICD10CodeColumnOrder				as intColumnOrder2,
							@hc_ICD10CodeColumn						as idfsParameter2,
							@hc_ICD10CodeColumnName					as strParameterName2,
							cast(d.strIDC10 as sql_variant)			as varValue2,
							cast(''  collate Cyrillic_General_CI_AS as nvarchar(2000))				as strParameterRefValue2
							
					from dbo.tlbAggrHumanCaseMTX mtx
						inner join trtDiagnosis d
						on d.idfsDiagnosis = mtx.idfsDiagnosis
						
						inner join fnReferenceRepair(@LangID, 19000019	/*rftDiagnosis*/) ref_Diagnosis
						on ref_Diagnosis.idfsReference = d.idfsDiagnosis		
					where exists (select * from @VersionTable where mtx.idfVersion =  [idfVersion])
					and mtx.intRowStatus = 0
				) as s
			unpivot ( intColumnOrder		FOR intColumnOrders			IN (intColumnOrder1, intColumnOrder2)) as unpvt_ColumnOrders
			unpivot ( idfsParameter			FOR idfsParameters			IN (idfsParameter1, idfsParameter2)) as unpvt_idfsParameters
			unpivot ( strParameterName		FOR strParameterNames		IN (strParameterName1, strParameterName2)) as unpvt_strParameterNames
			unpivot ( varValue				FOR varValues				IN (varValue1, varValue2)) as unpvt_varValues
			unpivot ( strParameterRefValue	FOR strParameterRefValues	IN (strParameterRefValue1, strParameterRefValue2)) as unpvt_strParameterRefValues
		where	right(intColumnOrders,1) =  right(idfsParameters,1) and
				right(intColumnOrders,1) =  right(strParameterNames,1) and
				right(intColumnOrders,1) =  right(varValues,1) and
				right(intColumnOrders,1) =  right(strParameterRefValues,1)	
	end
	else
	if @MatrixID = 71260000000	--Veterinary-sanitary measures
	begin
		insert @tlbAggrMatrixVersion 
			(idfVersion, intNumRow, intColumnOrder, idfRow, idfsParameter, strParameterName, varValue,	strParameterRefValue)
		select
			idfVersion, 
			intNumRow, 
			intColumnOrder, 
			idfRow, 
			
			idfsParameter, 
			strParameterName, 
			varValue,	
			strParameterRefValue
	
		from	(
						select 
							mtx.idfVersion								as idfVersion,
							mtx.intNumRow								as intNumRow,
							mtx.idfAggrSanitaryActionMTX				as idfRow,
							
							@s_SanitaryActionColumnOrder				as intColumnOrder1,
							@s_SanitaryActionColumn						as idfsParameter1,
							@s_SanitaryActionColumnName					as strParameterName1,
							cast(mtx.idfsSanitaryAction as sql_variant)	as varValue1,
							ref_SanitaryAction.[name]					as strParameterRefValue1,
											
							@s_SanitaryActionCodeColumnOrder			as intColumnOrder2,
							@s_SanitaryActionCodeColumn					as idfsParameter2,
							@s_SanitaryActionCodeColumnName				as strParameterName2,
							cast(sa.strActionCode as sql_variant)		as varValue2,
							cast('' collate Cyrillic_General_CI_AS  as nvarchar(2000))					as strParameterRefValue2
							
					from dbo.tlbAggrSanitaryActionMTX mtx
						inner join trtSanitaryAction sa
						on sa.idfsSanitaryAction = mtx.idfsSanitaryAction
						
						inner join fnReferenceRepair(@LangID, 19000079	/*rftSanitaryActionList*/) ref_SanitaryAction
						on ref_SanitaryAction.idfsReference = sa.idfsSanitaryAction	
					where exists (select * from @VersionTable where mtx.idfVersion =  [idfVersion])
					and mtx.intRowStatus = 0
				) as s
			unpivot ( intColumnOrder		FOR intColumnOrders			IN (intColumnOrder1, intColumnOrder2)) as unpvt_ColumnOrders
			unpivot ( idfsParameter			FOR idfsParameters			IN (idfsParameter1, idfsParameter2)) as unpvt_idfsParameters
			unpivot ( strParameterName		FOR strParameterNames		IN (strParameterName1, strParameterName2)) as unpvt_strParameterNames
			unpivot ( varValue				FOR varValues				IN (varValue1, varValue2)) as unpvt_varValues
			unpivot ( strParameterRefValue	FOR strParameterRefValues	IN (strParameterRefValue1, strParameterRefValue2)) as unpvt_strParameterRefValues
		where	right(intColumnOrders,1) =  right(idfsParameters,1) and
				right(intColumnOrders,1) =  right(strParameterNames,1) and
				right(intColumnOrders,1) =  right(varValues,1) and
				right(intColumnOrders,1) =  right(strParameterRefValues,1)	
	end

	
	Declare curs Cursor For	
			--Select
			--	  AMV.[idfRow]
			--	  ,AMV.[idfsParameter]
			--	  ,Isnull(R1.[name], R1.[strDefault])
			--	  ,AMV.[varValue]
			--	  ,Isnull(SNT.[strTextString], BR1.[strDefault])
			--	  ,AMV.idfVersion
			--From dbo.tlbAggrMatrixVersion AMV
			--		Inner Join dbo.fnReference(@LangID, 19000066) R1 On AMV.idfsParameter = R1.idfsReference	
			--		Left Join dbo.trtBaseReference BR1 On AMV.varValue = BR1.idfsBaseReference --And BR1.intRowStatus = 0	
			--		Left Join dbo.trtStringNameTranslation SNT On SNT.idfsBaseReference = BR1.idfsBaseReference And SNT.idfsLanguage = @langid_int --And SNT.intRowStatus = 0	 					
			--Where AMV.idfVersion In (Select [idfVersion] From @VersionTable) And AMV.intRowStatus = 0						 
			--Order By AMV.intNumRow, AMV.idfRow, AMV.idfVersion, AMV.intColumnOrder
			
			select
				idfRow,
				idfsParameter,
				strParameterName,
				varValue,
				strParameterRefValue,
				idfVersion
			from @tlbAggrMatrixVersion
			where idfVersion In (Select [idfVersion] From @VersionTable)
			order by intNumRow, idfRow, idfVersion, intColumnOrder
			
			
	Open curs
	Fetch Next From curs Into @idfRow,@idfsParameter,@strDefaultParameterName,@idfsParameterValue,@strNameValue, @currentVersion
	
	Set @idfRowCurrent = @idfRow;	
	While (@@FETCH_STATUS = 0) Begin
		-- ���� ������� ����� ���� ��������� � �������� ������� ������ ���� ���.
		-- ������� ���� �� ����������� ������ � ��� �������, ��� ��� ��������� � ����� ��������
		
		-- ��������� ����� ����� �� ���� ������
		-- ���� ��� ����� �� �������, �� �������� �����		
		Set @NumRowTemp = Null;		
		Select Distinct @NumRowTemp = [NumRow] From @StubTable Where [idfRow] = @idfRow
		If (@NumRowTemp Is Null) begin 
			--Set  @NumRowCurrent =  @NumRowCurrent + 1 
			Select  @NumRowCurrent =  Isnull(Max([NumRow]), -1) + 1 From @StubTable	-- -1, ����� ������ ������� ����� ��� � ����		
		End else begin 
			Set  @NumRowCurrent = @NumRowTemp;
		End;
		
		If Not Exists(Select Top 1 1 From @StubTable 
								Where idfRow = @idfRow And idfsParameter = @idfsParameter) Begin
			Insert into @StubTable
			(
				idfVersion
				,idfRow
				,idfsParameter
				,strDefaultParameterName
				,idfsParameterValue
				,strNameValue
				,NumRow				
			)	
			Values
			(
				@currentVersion
				,@idfRow
				,@idfsParameter
				,@strDefaultParameterName
				,@idfsParameterValue
				,Isnull(@strNameValue, Cast(@idfsParameterValue As Nvarchar(600)))
				,@NumRowCurrent
			)			
			
		End
		
		Fetch Next From curs Into @idfRow,@idfsParameter,@strDefaultParameterName,@idfsParameterValue,@strNameValue, @currentVersion--,@intColumnOrder
		
	End
	
	Close curs
	Deallocate curs	
	
	declare @idfsSection bigint 
	declare @idfsMatrixType bigint 
	Declare @idfsFormType Bigint
	
	If (@idfsFormTemplate Is Not null) Select @idfsFormType = idfsFormType From dbo.ffFormTemplate Where idfsFormTemplate = @idfsFormTemplate
	Exec spFFGetSectionForAggregateCase @idfsFormTemplate, @idfsFormType, @idfsSection Output, @idfsMatrixType Output
	
	Select
		idfVersion
		,idfRow
		,idfsParameter
		,strDefaultParameterName
		,idfsParameterValue
		,NumRow
		,[strNameValue]		
		--,@MatrixID As [idfsSection]
		,@idfsSection As [idfsSection]
		,@LangID As [langid]
	From @StubTable
End



