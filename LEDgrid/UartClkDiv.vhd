library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UartClkDiv is
port(	
	CLKin			:	in std_logic;
	CLKTXD_out	:	inout std_logic:='0';
	CLKRXD_out	:	inout std_logic:='0');
end UartClkDiv;

architecture Behavioral of UartClkDiv is

signal count : integer :=1;
signal count2 : integer :=1;

----------------------------------------------------------------------
begin

-------------------------------------------------
process(CLKin)
begin
	if(CLKin'event and CLKin='1') then
		count <= count + 1;
		if(count = 434) then --<FOR CLKIN 100MZ>--
			CLKTXD_out <= not CLKTXD_out;
			count <=1;
		end if;
	end if;
end process;

-------------------------------------------------
process(CLKin)
begin
	if(CLKin'event and CLKin='1') then
		count2 <= count2 + 1;
		if(count2 = 27) then --<FOR CLKIN 100MZ>--
			CLKRXD_out <= not CLKRXD_out;
			count2 <=1;
		end if;
	end if;
end process;




end Behavioral;

