inputs:
NoEntryAfterTime(1530),
BBPrice( Close ),
Length( 20 ),
NumDevsUp( 2 ),
NumDevsDn( -2 ),
TickBarMultiple( 1 ) ;

variables: o_MAVal(0), o_StdDev(0), LowerBand(0), UpperBand(0),o_DoUpdate(0), count(0) ;
Condition1 = IES_Synth_SDevTick(BBPrice, Length, 1, TickBarMultiple, o_MAVal, o_StdDev,o_DoUpdate);

Array:	a_DailyClose[5](0);

UpperBand = o_MAVal + NumDevsUp * o_StdDev ;
LowerBand = o_MAVal + NumDevsDn * o_StdDev ;

Vars: IsTradeToday(false);
If currentsession(1) <> currentsession(1)[1] then begin
IsTradeToday = C < LowerBand ;
For count = 5 downto 2 begin
a_DailyClose[count] = a_DailyClose[count-1];
end;
a_DailyClose[1] = C[1];
end;

If IsTradeToday and T < NoEntryAfterTime then Buy next bar o_MAVal stop;
setexitonclose;
