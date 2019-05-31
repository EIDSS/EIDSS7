CREATE  PROCEDURE [dbo].[usp_AccessoryCode_GetLookup] 
(
	@LangID AS NVARCHAR(50), --##PARAM @LangID - language ID
	@HACode AS INT = NULL  --##PARAM @HACode - bit mask that defines Area where diagnosis are used (human, LiveStock or avian)
)
AS 
DECLARE @returnMsg	VARCHAR(MAX) = 'Success'
DECLARE @returnCode BIGINT = 0

BEGIN
	BEGIN TRY  	

			SELECT		*
			FROM	(
						SELECT		ac.intHACode,
									r_ac.[name],
									r_ac.strDefault,
									ISNULL(r_ac.intOrder, 0) AS intOrder
						FROM		FN_GBL_ReferenceRepair(@LangID, 19000040) r_ac
						INNER JOIN	trtHACodeList ac
						ON			ac.idfsCodeName = r_ac.idfsReference
									AND ac.intHACode & 482 > 0
									AND ac.intHACode & ISNULL(@HACode, 482) > 0
						WHERE		r_ac.idfsReference <> 10040001 -- All

						UNION

						SELECT		ac1.intHACode + ac2.intHACode AS intHACode,
									r_ac1.[name] + N', ' + r_ac2.[name] AS [name],
									r_ac1.strDefault + N', ' + r_ac2.strDefault AS strDeafult,
									ISNULL(r_ac1.intOrder, 0) + ISNULL(r_ac2.intOrder, 0) AS intOrder
						FROM		FN_GBL_ReferenceRepair(@LangID, 19000040) r_ac1
						INNER JOIN	trtHACodeList ac1
						ON			ac1.idfsCodeName = r_ac1.idfsReference
									AND ac1.intHACode & 482 > 0
									AND ac1.intHACode & ISNULL(@HACode, 482) > 0
						INNER JOIN	FN_GBL_ReferenceRepair(@LangID, 19000040) r_ac2
						INNER JOIN	trtHACodeList ac2
						ON			ac2.idfsCodeName = r_ac2.idfsReference
						AND			ac2.intHACode & 482 > 0
						AND			ac2.intHACode & ISNULL(@HACode, 482) > 0
						ON			r_ac2.idfsReference <> 10040001 -- All
									AND REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac2.intHACode AS NVARCHAR(20)), 
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
										REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac1.intHACode AS NVARCHAR(20)), 
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
						WHERE		r_ac1.idfsReference <> 10040001 -- All

					UNION

					SELECT			ac1.intHACode + ac2.intHACode + ac3.intHACode AS intHACode,
									r_ac1.[name] + N', ' + r_ac2.[name] + N', ' + r_ac3.[name] AS [name],
									r_ac1.strDefault + N', ' + r_ac2.strDefault + N', ' + r_ac3.strDefault AS strDeafult,
									ISNULL(r_ac1.intOrder, 0) + ISNULL(r_ac2.intOrder, 0) + ISNULL(r_ac3.intOrder, 0) AS intOrder
					FROM			FN_GBL_ReferenceRepair(@LangID, 19000040) r_ac1
					INNER JOIN		trtHACodeList ac1
					ON				ac1.idfsCodeName = r_ac1.idfsReference
					AND				ac1.intHACode & 482 > 0
					AND				ac1.intHACode & ISNULL(@HACode, 482) > 0
					INNER JOIN		FN_GBL_ReferenceRepair(@LangID, 19000040) r_ac2
					INNER JOIN		trtHACodeList ac2
					ON				ac2.idfsCodeName = r_ac2.idfsReference
					AND				ac2.intHACode & 482 > 0
									AND ac2.intHACode & ISNULL(@HACode, 482) > 0
					ON				r_ac2.idfsReference <> 10040001 -- All
					AND				REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac2.intHACode AS NVARCHAR(20)), 
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
									REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac1.intHACode AS NVARCHAR(20)), 
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
					INNER JOIN	FN_GBL_ReferenceRepair(@LangID, 19000040) r_ac3
					INNER JOIN	trtHACodeList ac3
					ON			ac3.idfsCodeName = r_ac3.idfsReference
					AND			ac3.intHACode & 482 > 0
									AND ac3.intHACode & ISNULL(@HACode, 482) > 0
					ON			r_ac3.idfsReference <> 10040001 -- All
					AND			REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac3.intHACode AS NVARCHAR(20)), 
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
									REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac2.intHACode AS NVARCHAR(20)), 
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
					WHERE		r_ac1.idfsReference <> 10040001 -- All

					UNION

					SELECT		ac1.intHACode + ac2.intHACode + ac3.intHACode + ac4.intHACode AS intHACode,
								r_ac1.[name] + N', ' + r_ac2.[name] + N', ' + r_ac3.[name] + N', ' + r_ac4.[name] AS [name],
								r_ac1.strDefault + N', ' + r_ac2.strDefault + N', ' + r_ac3.strDefault + N', ' + r_ac4.strDefault AS strDeafult,
								ISNULL(r_ac1.intOrder, 0) + ISNULL(r_ac2.intOrder, 0) + ISNULL(r_ac3.intOrder, 0) + ISNULL(r_ac4.intOrder, 0) AS intOrder
					FROM		FN_GBL_ReferenceRepair(@LangID, 19000040) r_ac1
					INNER JOIN	trtHACodeList ac1
					ON			ac1.idfsCodeName = r_ac1.idfsReference
								AND ac1.intHACode & 482 > 0
								AND ac1.intHACode & ISNULL(@HACode, 482) > 0
					INNER JOIN	FN_GBL_ReferenceRepair(@LangID, 19000040) r_ac2
					INNER JOIN	trtHACodeList ac2
					ON			ac2.idfsCodeName = r_ac2.idfsReference
					AND			ac2.intHACode & 482 > 0
					AND			ac2.intHACode & ISNULL(@HACode, 482) > 0
					ON			r_ac2.idfsReference <> 10040001 -- All
					AND			REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac2.intHACode AS NVARCHAR(20)), 
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
									REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac1.intHACode AS NVARCHAR(20)), 
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
					INNER JOIN	FN_GBL_ReferenceRepair(@LangID, 19000040) r_ac3
					INNER JOIN	trtHACodeList ac3
					ON			ac3.idfsCodeName = r_ac3.idfsReference
					AND			ac3.intHACode & 482 > 0
					AND			ac3.intHACode & ISNULL(@HACode, 482) > 0
					ON			r_ac3.idfsReference <> 10040001 -- All
					AND			REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac3.intHACode AS NVARCHAR(20)), 
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
									REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac2.intHACode AS NVARCHAR(20)), 
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
					INNER JOIN	FN_GBL_ReferenceRepair(@LangID, 19000040) r_ac4
					INNER JOIN	trtHACodeList ac4
					ON			ac4.idfsCodeName = r_ac4.idfsReference
					AND			ac4.intHACode & 482 > 0
					AND			ac4.intHACode & ISNULL(@HACode, 482) > 0
					ON			r_ac4.idfsReference <> 10040001 -- All
					AND			REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac4.intHACode AS NVARCHAR(20)), 
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
									REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac3.intHACode AS NVARCHAR(20)), 
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
					WHERE		r_ac1.idfsReference <> 10040001 -- All

					UNION

					SELECT		ac1.intHACode + ac2.intHACode + ac3.intHACode + ac4.intHACode + ac5.intHACode AS intHACode,
								r_ac1.[name] + N', ' + r_ac2.[name] + N', ' + r_ac3.[name] + N', ' + r_ac4.[name] + N', ' + r_ac5.[name] AS [name],
								r_ac1.strDefault + N', ' + r_ac2.strDefault + N', ' + r_ac3.strDefault + N', ' + r_ac4.strDefault + N', ' + r_ac5.strDefault AS strDeafult,
								ISNULL(r_ac1.intOrder, 0) + ISNULL(r_ac2.intOrder, 0) + ISNULL(r_ac3.intOrder, 0) + ISNULL(r_ac4.intOrder, 0) + ISNULL(r_ac5.intOrder, 0) AS intOrder
					FROM		FN_GBL_ReferenceRepair(@LangID, 19000040) r_ac1
					INNER JOIN	trtHACodeList ac1
					ON			ac1.idfsCodeName = r_ac1.idfsReference
								AND ac1.intHACode & 482 > 0
								AND ac1.intHACode & ISNULL(@HACode, 482) > 0
					INNER JOIN	FN_GBL_ReferenceRepair(@LangID, 19000040) r_ac2
					INNER JOIN	trtHACodeList ac2
					ON			ac2.idfsCodeName = r_ac2.idfsReference
					AND			ac2.intHACode & 482 > 0
					AND			ac2.intHACode & ISNULL(@HACode, 482) > 0
					ON			r_ac2.idfsReference <> 10040001 -- All
					AND			REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac2.intHACode AS NVARCHAR(20)), 
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
									REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac1.intHACode AS NVARCHAR(20)), 
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
					INNER JOIN	FN_GBL_ReferenceRepair(@LangID, 19000040) r_ac3
					INNER JOIN	trtHACodeList ac3
					ON			ac3.idfsCodeName = r_ac3.idfsReference
					AND			ac3.intHACode & 482 > 0
					AND			ac3.intHACode & ISNULL(@HACode, 482) > 0
					ON			r_ac3.idfsReference <> 10040001 -- All
					AND			REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac3.intHACode AS NVARCHAR(20)), 
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
									REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac2.intHACode AS NVARCHAR(20)), 
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
					INNER JOIN	FN_GBL_ReferenceRepair(@LangID, 19000040) r_ac4
					INNER JOIN	trtHACodeList ac4
					ON			ac4.idfsCodeName = r_ac4.idfsReference
					AND			ac4.intHACode & 482 > 0
					AND			ac4.intHACode & ISNULL(@HACode, 482) > 0
					ON			r_ac4.idfsReference <> 10040001 -- All
					aND			REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac4.intHACode AS NVARCHAR(20)), 
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
									REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac3.intHACode AS NVARCHAR(20)), 
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
					INNER JOIN	FN_GBL_ReferenceRepair(@LangID, 19000040) r_ac5
					INNER JOIN	trtHACodeList ac5
					ON			ac5.idfsCodeName = r_ac5.idfsReference
					AND			ac5.intHACode & 482 > 0
								AND ac5.intHACode & ISNULL(@HACode, 482) > 0
					ON			r_ac5.idfsReference <> 10040001 -- All
					AND			REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac5.intHACode AS NVARCHAR(20)), 
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
									REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	REPLACE	(	CAST(ac4.intHACode AS NVARCHAR(20)), 
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
					WHERE		r_ac1.idfsReference <> 10040001 -- All
				) AS haCode
			ORDER BY [name]

			SELECT @returnCode, @returnMsg

	END TRY  

	BEGIN CATCH 
		SET @returnMsg = 
			'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
			+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
			+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
			+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
			+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
			+ ' ErrorMessage: '+ ERROR_MESSAGE()

		SET @returnCode = ERROR_NUMBER()
		SELECT @returnCode, @returnMsg
	END CATCH

END



