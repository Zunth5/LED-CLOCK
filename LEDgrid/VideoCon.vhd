library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity VideoCon is
  port ( CLKin			: in std_logic;
         REFRESH_out	: out std_logic;
			STEP_out		: out std_logic;
			COLORin		: in std_logic_vector(14 downto 0);
			COLOR_out   : out std_logic_vector(5 downto 0); 
--			READRAM_out	: out std_logic;
--			WRITERAM_out: out std_logic;
			YCON_out		: out std_logic_vector(3 downto 0);
			XSEL_out		: out std_logic_vector(5 downto 0);
			XSEL2_out	: out std_logic_vector(5 downto 0);
			YSEL_out		: out std_logic_vector(4 downto 0));
end VideoCon;

architecture Behavioral of VideoCon is	    
--------------------------------------------------------------------------- 
  signal CLK2 	: std_logic	:=	'1';
  signal CLK 	: std_logic	:=	'0';
  signal CLK3 	: std_logic	:=	'0';
  signal TAK	: std_logic	:=	'0';
  signal COLOR : std_logic_vector(14 downto 0);
  
  signal COUNT      : integer:= 0;
  signal COUNT2      : integer:= 0;
  signal COUNT3      : integer:= 0;
  
  signal COUNTER1      : integer:= 0;
  signal COUNTER2      : integer:= 0;
  signal COUNTER3      : integer:= 0; 

  signal HCOUNT: std_logic_vector(6 downto 0) := (others => '0');
  signal VCOUNT: std_logic_vector(4 downto 0) := (others => '0');
  signal VSIG: std_logic_vector(6 downto 0) := (others => '0'); 
---------------------------------------------------------------------------- 

begin
----------------------------------------------------------
VHSHIFTER : process (CLKin)
	begin
-----CLOCK DIV (SPEED)-----------------------------
	if rising_edge(CLKin) then
		if COUNT < 1 then
			COUNT <= COUNT + 1;
		else
			CLK <= not CLK;
			COUNT <= 0;
		end if;	
	end if;
	
-----CLOCK DIV (CONTROL)---------------------------
		if rising_edge(CLK) then
			CLK2 <= not CLK2;
			if COUNT2 = 1 then
				STEP_out <= '1';
				CLK3 <= '1';
				COUNT2 <= 0;
			else
				STEP_out <= '0';
				CLK3 <= '0';
				COUNT2 <= 1;
			end if;
			if COUNTER1 < 64 then --SET COLOR AND DEFINE X AXIS SELECT
				XSEL_out(5 downto 0) <= 63 - conv_std_logic_vector(COUNTER1,6);
				XSEL2_out(5 downto 0) <= 61 - conv_std_logic_vector(COUNTER1,6);
				if VCOUNT <= 15 then
					COLOR_out(0) <= COLOR(0);
					COLOR_out(1) <= '0';
					COLOR_out(2) <= COLOR(1);
					COLOR_out(3) <= '0';		
					COLOR_out(4) <= COLOR(2);
					COLOR_out(5) <= '0';
				elsif VCOUNT <= 31 then
					COLOR_out(0) <= '0';
					COLOR_out(1) <= COLOR(0);
					COLOR_out(2) <= '0';
					COLOR_out(3) <= COLOR(1);		
					COLOR_out(4) <= '0';
					COLOR_out(5) <= COLOR(2);	
				else
					COLOR_out <= (others => '0');
				end if;
			else
				COLOR_out <= (others => '0');
			end if;
			if COUNTER1 = 64 or COUNTER1 = 129 then --ENABLE THE SCREEN UPDATE
				if COUNTER2 = 0 then
					COUNTER2 <= COUNTER2 + 1;
					REFRESH_out <= '1';
				else
					REFRESH_out <= '0';
				end if;
			else
				COUNTER2 <= 0;
				REFRESH_out <= '0';
			end if;
		end if;
-----V & H SHIFT----------------------------------		
		if rising_edge(CLK2) then
			if COUNTER1 < 130 then --128+2
				COUNTER1 <= COUNTER1 + 1;			
					if COUNTER1 = 128 then	--128				
						if VCOUNT < 31 then  --16 - 1
							VCOUNT <= VCOUNT + 1;
						else
							VCOUNT <= (others => '0');
						end if;
					end if;
				if COUNTER1 = 129 then --RENEW THE Y CONTROL AND AXIS OUTPUT VALUES
					YCON_out(3 downto 0) <= VCOUNT(3 downto 0);
					YSEL_out(4 downto 0) <= 31 - VCOUNT;
				end if;			
			else
				COUNTER1 <= 0;
			end if;
		end if;	
--------------------------------------------------			
-------PULSE WIDTH--------------------------------------------------	
if rising_edge(CLK3) then
	if COUNTER3 < 32 then --2 ^ N + 1 (0-16 = 17) FOR SHIFTING
		COUNTER3 <= COUNTER3 + 1;
	else 
		COUNTER3 <= 0;
	end if;
end if;
------------------------------------------------- RED
if COUNTER3 <= COLORin(14 downto 10) then
	if COLORin(14 downto 10) = 0 then
		COLOR(0) <= '0';
	else
		COLOR(0) <= '1';
	end if;
else
	COLOR(0) <= '0';
end if;	
------------------------------------------------- GREEN
if COUNTER3 <= COLORin(9 downto 5) then
	if COLORin(9 downto 5) = 0 then
		COLOR(1) <= '0';
	else
		COLOR(1) <= '1';
	end if;
else
	COLOR(1) <= '0';
end if;
------------------------------------------------- BLUE
if COUNTER3 <= COLORin(4 downto 0) then
	if COLORin(4 downto 0) = 0 then
		COLOR(2) <= '0';
	else
		COLOR(2) <= '1';
	end if;
else
	COLOR(2) <= '0';
end if;
---------------------------------------------
-----SRAM SIGNALS*------------------------------------------------	
	
--	READRAM_out <= --MAKE RELEVANT CONTROL
	
--	WRITERAM_out <= --MAKE RELEVANT CONTROL
------------------------------------------------------------------
end process VHSHIFTER; 
----------------------------------------------------------					
end Behavioral;

