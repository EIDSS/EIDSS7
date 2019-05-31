

CREATE FUNCTION [dbo].[fnsysSplitList]
(
	@List		nvarchar(max)
	,@ShowEmpty	 bit = 1
	,@DelimiterSymbol nvarchar(1) = ';'
)
returns @ResTable table
(
    num	int primary key,
    Value	 sql_variant
)
as
begin
    declare	
        @StartIndex				bigint,
		@Index 					bigint,
		@num					int,
		@Value 					nvarchar(100)
	Select
        @StartIndex	= 1,
		@num = 1	
	If (@DelimiterSymbol Is Null) Set @DelimiterSymbol = ';'

    --Добавляем в конец разделитель, если его еще нет
    if len(isnull(@List,''))>0
        if (right(@List, 1) <> @DelimiterSymbol)
            set @List = @List + @DelimiterSymbol

    while(1=1)
    begin
        set @Index = charindex(@DelimiterSymbol, @List, @StartIndex)

        if @Index <= 0 or @Index is null
            break;
		set @Value = ltrim(rtrim(substring(@List, @StartIndex, @Index-@StartIndex)))
		if @ShowEmpty = 1 or @Value <> ''
		begin 
			insert into @ResTable (num, Value)
				values (@num, @Value)
		end
		
		select
			@num = @num + 1,
			@StartIndex = @Index + 1
    end;

	return
end


