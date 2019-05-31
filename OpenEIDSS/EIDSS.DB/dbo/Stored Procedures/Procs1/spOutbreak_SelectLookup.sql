



CREATE           PROCEDURE [dbo].[spOutbreak_SelectLookup]
as
SELECT [idfOutbreak]
      ,strOutbreakID
      ,intRowStatus
  FROM tlbOutbreak 		
--where		intRowStatus = 0







