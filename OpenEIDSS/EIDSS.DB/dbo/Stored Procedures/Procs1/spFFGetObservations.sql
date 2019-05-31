

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spFFGetObservations 
(
	@observationList Nvarchar(max)	
)
As
Begin
   Select idfObservation, idfsFormTemplate From dbo.tlbObservation
   Where idfObservation In (Select Cast([Value] As Bigint) From [dbo].[fnsysSplitList](@observationList, null, null))
				And intRowStatus = 0;
End

