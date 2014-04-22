library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DATA_CONSTRUCT is
  port (	CLKin	: in std_logic; 										--system clock
			UPDATEin   : in  std_logic; 								--uart update signal
			UARTin 		: in  std_logic_vector(7 downto 0);    --uart data in
			COLOR_out 	: out std_logic_vector(14 downto 0);	--color data
			PIXSEL_out	: out std_logic_vector(4 downto 0); 	--super pixel select
			PIXRAM_out  : out std_logic_vector(15 downto 0); 	--ram location select
			UARTFOR_out : out std_logic_vector(7 downto 0); 	--uart data forward
			MODE_out		: out std_logic_vector(1 downto 0);    --mode output
			RAMCON_out  : out std_logic;								--controls write to sram
			UPDAFOR_out : out std_logic;								--uart update forward
			UARTUPD_out : out std_logic;								--uart send control
			UARTDAT_out : out std_logic_vector(7 downto 0)     --uart send data
			);
end DATA_CONSTRUCT;

architecture Behavioral of DATA_CONSTRUCT is	    
--------------------------------------------------------------------------- 
  signal UARTDAT		: std_logic_vector(7 downto 0);
  signal COLOR1		: std_logic_vector(7 downto 0);
  signal PIXSEL		: std_logic_vector(4 downto 0);
  signal ENABLE      : std_logic:='0';
  signal ENABLE2     : std_logic:='1';
  signal CLK2      	: std_logic:='0';
  signal COUNT      	: integer:= 0;
  signal COUNT2      : integer:= 0;
  signal CLKCOUNT    : integer:= 0;
  signal STATE    	: integer:= 0;
  signal MODE      	: std_logic_vector(1 downto 0):= "11";
  signal REACH     	: integer:= 0;
  signal COLOR			: std_logic_vector(14 downto 0) := (others => '0'); 
  signal PIXRAM		: std_logic_vector(7 downto 0) := (others => '0'); 
---------------------------------------------------------------------------- 

begin
----------------------------------------------------------
UARTMANIP : process (CLKin)
begin
--COLOR_out 	<= COLOR;
--PIXRAM_out 	<= PIXRAM;
--MODE_out		<= MODE;
--UARTDAT_out <= UARTDAT;
--PIXSEL_out 	<= PIXSEL;
if rising_edge(CLKin) then
if STATE = 3 or STATE = 134 or STATE = 137 then
	if COUNT < 899 and ENABLE = '1' then
		COUNT <= COUNT + 1;
		UARTUPD_out <= '1';
	else
		UARTUPD_out <= '0';
		COUNT <= 0;
		ENABLE <= '0';
	end if;
else
	ENABLE <= '1';
	UARTUPD_out <= '0';
end if;
if STATE = 0 then
	UPDAFOR_out <= '1';
else
	UPDAFOR_out <= '0';
end if;
if STATE >= 69 and STATE <= 132 then
	RAMCON_out <= '1';
else
	RAMCON_out <= '0';
end if;
end if;


if rising_edge(UPDATEin) then

case STATE is 
	when 0 =>
		if UARTin = x"61" then
			STATE <= 3;
			MODE_out<="01";
			UARTDAT_out <= x"41";
		elsif UARTin = x"62" then
			STATE <= 134;
			MODE_out<="10";
			UARTDAT_out <= x"42";
		elsif UARTin = x"63" then
			STATE <= 137;
			MODE_out<="11";
			UARTDAT_out <= x"43";
		else
			MODE_out<="00";
		end if;

	when 3 =>
		PIXRAM <= UARTin;
		STATE <= STATE + 1;
	when 4 =>
		PIXRAM_out <= UARTin & PIXRAM;
		STATE <= STATE + 1;
	when 5 to 68 => 
		COLOR1 <= UARTin;
		STATE <= STATE + 64;		
	when 69 to 131 =>
		COLOR_out <=  COLOR1(6 downto 0) & UARTin;
		STATE <= STATE - 63;
	when 132 =>
		COLOR_out <=  COLOR1(6 downto 0) & UARTin;
		STATE <= 0;
	when 134 =>
		PIXRAM <= UARTin;
		STATE <= STATE + 1;
	when 135 =>
		PIXRAM_out <= UARTin & PIXRAM;
		STATE <= STATE + 1;
	when 136 =>
		PIXSEL_out <= UARTin(4 downto 0);
		STATE <= 0;
	when 137 to 171 =>
		UARTFOR_out <= UARTin;
		STATE <= STATE + 1;
	when 172 =>
		UARTFOR_out <= UARTin;
		STATE <= 0;
	when others =>	
		STATE <= 0;
	end case;
end if;		

end process UARTMANIP; 
----------------------------------------------------------					
end Behavioral;

