
CREATE PROCEDURE [spGeoLocation_Delete]
	@ID bigint
AS
delete from tflGeoLocationFiltered 
where idfGeoLocation = @ID

delete from tlbGeoLocation 
where idfGeoLocation = @ID

RETURN 0

