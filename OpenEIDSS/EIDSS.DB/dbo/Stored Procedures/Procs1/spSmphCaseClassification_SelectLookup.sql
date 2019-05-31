
--##SUMMARY Selects data for Case Classification lookup to deliver to Android

--##REMARKS Author: Gorodentseva
--##REMARKS Create date: 23.12.2015

/*
Example of procedure call:

EXECUTE spSmphCaseClassification_SelectLookup

*/

CREATE PROCEDURE [dbo].[spSmphCaseClassification_SelectLookup]
AS
select idfsBaseReference as id, idfsReferenceType as tp, intHACode as ha, strDefault as df, br.intRowStatus as rs, isnull(br.intOrder,0) as rd,
isnull(blnInitialHumanCaseClassification,0) as f1, isnull(blnFinalHumanCaseClassification,0) as f2
from trtBaseReference br
inner join dbo.trtCaseClassification cc On cc.idfsCaseClassification = br.idfsBaseReference
where br.idfsReferenceType = 19000011 -- BaseReferenceType.rftCaseClassification

