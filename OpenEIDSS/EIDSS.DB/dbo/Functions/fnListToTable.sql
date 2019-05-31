
Create Function [dbo].[fnListToTable] (@list nvarchar(MAX))
   Returns @tbl Table (LstColumn varChar(MAX) NOT NULL) 
As

Begin
   Declare @pos        int,
           @nextpos    int,
           @valuelen   int

   Select @pos = 0, @nextpos = 1

   While @nextpos > 0
   Begin
      Select @nextpos = charindex(',', @list, @pos + 1)
      Select @valuelen = Case
							When @nextpos > 0 Then @nextpos
                            Else len(@list) + 1
							End - @pos - 1
      Insert @tbl (LstColumn) Values (LTrim(RTrim(SubString(@list, @pos + 1, @valuelen))))
      Select @pos = @nextpos
   End
   
   Return
End


