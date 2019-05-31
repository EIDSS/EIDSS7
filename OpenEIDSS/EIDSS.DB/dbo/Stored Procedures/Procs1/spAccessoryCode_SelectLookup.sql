
--##REMARKS Author:Olga Mirnaya
--##REMARKS Create date: 29.01.2014

--##RETURNS Doesn't use

/*
Example of procedure call:
declare	@LangID	nvarchar(50)
set	@LangID = 'en'

exec spAccessoryCode_SelectLookup @LangID, 96
*/


CREATE  PROCEDURE spAccessoryCode_SelectLookup (
	@LangID as nvarchar(50), --##PARAM @LangID - language ID
	@HACode as int = null  --##PARAM @HACode - bit mask that defines Area where diagnosis are used (human, LiveStock or avian)
)

as 
select * from (
select		ac.intHACode,
			r_ac.[name],
			r_ac.strDefault,
			IsNull(r_ac.intOrder, 0) as intOrder
from		fnReference(@LangID, 19000040) r_ac
inner join	trtHACodeList ac
on			ac.idfsCodeName = r_ac.idfsReference
			and ac.intHACode & 482 > 0
			and ac.intHACode & IsNull(@HACode, 482) > 0
where		r_ac.idfsReference <> 10040001 -- All

union

select		ac1.intHACode + ac2.intHACode as intHACode,
			r_ac1.[name] + N', ' + r_ac2.[name] as [name],
			r_ac1.strDefault + N', ' + r_ac2.strDefault as strDeafult,
			IsNull(r_ac1.intOrder, 0) + IsNull(r_ac2.intOrder, 0) as intOrder
from		fnReference(@LangID, 19000040) r_ac1
inner join	trtHACodeList ac1
on			ac1.idfsCodeName = r_ac1.idfsReference
			and ac1.intHACode & 482 > 0
			and ac1.intHACode & IsNull(@HACode, 482) > 0
inner join	fnReference(@LangID, 19000040) r_ac2
	inner join	trtHACodeList ac2
	on			ac2.idfsCodeName = r_ac2.idfsReference
				and ac2.intHACode & 482 > 0
				and ac2.intHACode & IsNull(@HACode, 482) > 0
on			r_ac2.idfsReference <> 10040001 -- All
			and replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac2.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						) >
				replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac1.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						)
where		r_ac1.idfsReference <> 10040001 -- All

union

select		ac1.intHACode + ac2.intHACode + ac3.intHACode as intHACode,
			r_ac1.[name] + N', ' + r_ac2.[name] + N', ' + r_ac3.[name] as [name],
			r_ac1.strDefault + N', ' + r_ac2.strDefault + N', ' + r_ac3.strDefault as strDeafult,
			IsNull(r_ac1.intOrder, 0) + IsNull(r_ac2.intOrder, 0) + IsNull(r_ac3.intOrder, 0) as intOrder
from		fnReference(@LangID, 19000040) r_ac1
inner join	trtHACodeList ac1
on			ac1.idfsCodeName = r_ac1.idfsReference
			and ac1.intHACode & 482 > 0
			and ac1.intHACode & IsNull(@HACode, 482) > 0
inner join	fnReference(@LangID, 19000040) r_ac2
	inner join	trtHACodeList ac2
	on			ac2.idfsCodeName = r_ac2.idfsReference
				and ac2.intHACode & 482 > 0
				and ac2.intHACode & IsNull(@HACode, 482) > 0
on			r_ac2.idfsReference <> 10040001 -- All
			and replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac2.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						) >
				replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac1.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						)
inner join	fnReference(@LangID, 19000040) r_ac3
	inner join	trtHACodeList ac3
	on			ac3.idfsCodeName = r_ac3.idfsReference
				and ac3.intHACode & 482 > 0
				and ac3.intHACode & IsNull(@HACode, 482) > 0
on			r_ac3.idfsReference <> 10040001 -- All
			and replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac3.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						) >
				replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac2.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						)
where		r_ac1.idfsReference <> 10040001 -- All

union

select		ac1.intHACode + ac2.intHACode + ac3.intHACode + ac4.intHACode as intHACode,
			r_ac1.[name] + N', ' + r_ac2.[name] + N', ' + r_ac3.[name] + N', ' + r_ac4.[name] as [name],
			r_ac1.strDefault + N', ' + r_ac2.strDefault + N', ' + r_ac3.strDefault + N', ' + r_ac4.strDefault as strDeafult,
			IsNull(r_ac1.intOrder, 0) + IsNull(r_ac2.intOrder, 0) + IsNull(r_ac3.intOrder, 0) + IsNull(r_ac4.intOrder, 0) as intOrder
from		fnReference(@LangID, 19000040) r_ac1
inner join	trtHACodeList ac1
on			ac1.idfsCodeName = r_ac1.idfsReference
			and ac1.intHACode & 482 > 0
			and ac1.intHACode & IsNull(@HACode, 482) > 0
inner join	fnReference(@LangID, 19000040) r_ac2
	inner join	trtHACodeList ac2
	on			ac2.idfsCodeName = r_ac2.idfsReference
				and ac2.intHACode & 482 > 0
				and ac2.intHACode & IsNull(@HACode, 482) > 0
on			r_ac2.idfsReference <> 10040001 -- All
			and replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac2.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						) >
				replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac1.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						)
inner join	fnReference(@LangID, 19000040) r_ac3
	inner join	trtHACodeList ac3
	on			ac3.idfsCodeName = r_ac3.idfsReference
				and ac3.intHACode & 482 > 0
				and ac3.intHACode & IsNull(@HACode, 482) > 0
on			r_ac3.idfsReference <> 10040001 -- All
			and replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac3.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						) >
				replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac2.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						)
inner join	fnReference(@LangID, 19000040) r_ac4
	inner join	trtHACodeList ac4
	on			ac4.idfsCodeName = r_ac4.idfsReference
				and ac4.intHACode & 482 > 0
				and ac4.intHACode & IsNull(@HACode, 482) > 0
on			r_ac4.idfsReference <> 10040001 -- All
			and replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac4.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						) >
				replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac3.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						)
where		r_ac1.idfsReference <> 10040001 -- All

union

select		ac1.intHACode + ac2.intHACode + ac3.intHACode + ac4.intHACode + ac5.intHACode as intHACode,
			r_ac1.[name] + N', ' + r_ac2.[name] + N', ' + r_ac3.[name] + N', ' + r_ac4.[name] + N', ' + r_ac5.[name] as [name],
			r_ac1.strDefault + N', ' + r_ac2.strDefault + N', ' + r_ac3.strDefault + N', ' + r_ac4.strDefault + N', ' + r_ac5.strDefault as strDeafult,
			IsNull(r_ac1.intOrder, 0) + IsNull(r_ac2.intOrder, 0) + IsNull(r_ac3.intOrder, 0) + IsNull(r_ac4.intOrder, 0) + IsNull(r_ac5.intOrder, 0) as intOrder
from		fnReference(@LangID, 19000040) r_ac1
inner join	trtHACodeList ac1
on			ac1.idfsCodeName = r_ac1.idfsReference
			and ac1.intHACode & 482 > 0
			and ac1.intHACode & IsNull(@HACode, 482) > 0
inner join	fnReference(@LangID, 19000040) r_ac2
	inner join	trtHACodeList ac2
	on			ac2.idfsCodeName = r_ac2.idfsReference
				and ac2.intHACode & 482 > 0
				and ac2.intHACode & IsNull(@HACode, 482) > 0
on			r_ac2.idfsReference <> 10040001 -- All
			and replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac2.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						) >
				replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac1.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						)
inner join	fnReference(@LangID, 19000040) r_ac3
	inner join	trtHACodeList ac3
	on			ac3.idfsCodeName = r_ac3.idfsReference
				and ac3.intHACode & 482 > 0
				and ac3.intHACode & IsNull(@HACode, 482) > 0
on			r_ac3.idfsReference <> 10040001 -- All
			and replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac3.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						) >
				replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac2.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						)
inner join	fnReference(@LangID, 19000040) r_ac4
	inner join	trtHACodeList ac4
	on			ac4.idfsCodeName = r_ac4.idfsReference
				and ac4.intHACode & 482 > 0
				and ac4.intHACode & IsNull(@HACode, 482) > 0
on			r_ac4.idfsReference <> 10040001 -- All
			and replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac4.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						) >
				replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac3.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						)
inner join	fnReference(@LangID, 19000040) r_ac5
	inner join	trtHACodeList ac5
	on			ac5.idfsCodeName = r_ac5.idfsReference
				and ac5.intHACode & 482 > 0
				and ac5.intHACode & IsNull(@HACode, 482) > 0
on			r_ac5.idfsReference <> 10040001 -- All
			and replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac5.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						) >
				replace	(	replace	(	replace	(	replace	(	replace	(	cast(ac4.intHACode as nvarchar(20)), 
																			N'256', N'Order 5'
																		),
																N'128', N'Order 4'
															),
													N'32', N'Order 3'
												),
										N'2', N'Order 1'
									),
							N'64', N'Order 2'
						)
where		r_ac1.idfsReference <> 10040001 -- All
) as haCode
order by [name]


