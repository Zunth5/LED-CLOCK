library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProjectMain is
  port ( CLKin			: in std_logic;
			BTNin			: in std_logic;
			BTN2in		: in std_logic;
			SWin			: in std_logic_vector(7 downto 0);
			LED_out		:  out std_logic_vector (7 downto 0);
			----LED-MATRIX--------------
			REFRESH_out	: out std_logic;
			STEP_out		: out std_logic;
			COLOR_out	: out std_logic_vector(5 downto 0);
			YCONTROL_out: out std_logic_vector(3 downto 0);
			----UART--------------------
			RXDin			:	in std_logic;
			TXD_out		:  out std_logic
			----SEVEN-SEG---------------
--			SEG_out		:  out std_logic_vector(6 downto 0);
--			SEG_sel		: 	out std_logic_vector(3 downto 0);
			----SRAM--------------------
--			SRAMDATA_io		:	inout	std_logic_vector(14 downto 0);
--			SRAMADDR_out	:  out   std_logic_vector(15 downto 0);
--			OE_out			:	out	std_logic;
--			WE_out			:	out	std_logic;
--			CE1_out			:	out	std_logic;
--			CE2_out			:	out	std_logic;
--			UB1_out			:	out	std_logic;
--			LB1_out			:	out	std_logic

);
end ProjectMain;
-------------------------------------------------------------------------------

architecture Behavioral of ProjectMain is
-------------------------------------------------------------------------------
signal STEP			: std_logic:='0';
signal YVAR			: std_logic_Vector(4 downto 0);
signal XVAR			: std_logic_Vector(5 downto 0);
signal COLOR		: std_logic_Vector(23 downto 0);
signal TEST			: std_logic_Vector(6 downto 0);
signal COLOR2		: std_logic_Vector(9 downto 0);
signal COLOR3		: std_logic_Vector(7 downto 0):=X"00";
signal ENABLE 	   : std_logic:= '0';
signal VAR1 	   : std_logic:= '0';
signal VAR2 	   : std_logic:= '0';

signal HEXVEC		: std_logic_vector(287 downto 0):=(others => '0');
signal HEXSEL1     : integer:= 0;
signal HEXSEL2     : integer:= 0;
signal TEST2			: std_logic_Vector(7 downto 0);

signal CLICK      : std_logic:= '0';
signal COUNT      : integer:= 0;
signal COUNT2     : integer:= 0;
signal NUM	      : integer:= 0;
signal NUM2	      : integer:= 0;
signal NUM3	      : integer:= 3;

------UART SIGS-------------------------------------
signal DATAI 	:	std_logic_vector(7 downto 0);
signal DATAO 	:	std_logic_vector(7 downto 0);
signal READI	: 	std_logic;
signal READO	:  std_logic; 
----------------------------------------------------
--------------------------------------------------------------------
component VideoCon is
  port ( CLKin			: in std_logic;
         REFRESH_out	: out std_logic;
			STEP_out		: out std_logic;
			COLORin		: in std_logic_vector(23 downto 0);
			COLOR_out   : out std_logic_vector(5 downto 0); 
--			READRAM_out	: out std_logic;
--			WRITERAM_out: out std_logic;
			YCON_out		: out std_logic_vector(3 downto 0);
			XSEL_out		: out std_logic_vector(5 downto 0);
			YSEL_out		: out std_logic_vector(4 downto 0));
end component;
--------------------------------------------------------------------
component UART is
    port (
			Clkin		:in  std_logic;
			READin	:in  std_logic;
			RXDin		:in  std_logic;
			ASCIIin  :in  std_logic_vector (7 downto 0);
			ASCII_out:out  std_logic_vector (7 downto 0);
			TXD_out	:out std_logic;
			READ_out: out std_logic);
end component;
--------------------------------------------------------------------
component SRAM_Controller is
	port(
		CLKin				:	in		std_logic;
		WRITEADDRin		:	in		std_logic_vector(15 downto 0);
		READADDRin		:  in    std_logic_vector(15 downto 0);
		DATAin			:	in		std_logic_vector(14 downto 0);
		READin			:	in		std_logic;
		WRITEin			:	in		std_logic;
		------------------------
		SRAMDATA_io		:	inout	std_logic_vector(14 downto 0);
		------------------------
		SRAMADDR_out	:  out   std_logic_vector(15 downto 0);  
		DATA_out			:	out	std_logic_vector(14 downto 0); 
		OE_out			:	out	std_logic;
		WE_out			:	out	std_logic;
		CE1_out			:	out	std_logic;
		CE2_out			:	out	std_logic;
		UB1_out			:	out	std_logic;
		LB1_out			:	out	std_logic);
end component;
--------------------------------------------------------------------
component CHAR_ROM is
  PORT (
    clka : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR(9 DOWNTO 0);
    douta : out STD_LOGIC_VECTOR(6 DOWNTO 0)
  );
end component;
--------------------------------------------------------------------
component ASCII_LUT is
port( ASCIIin		: in std_logic_vector(7 downto 0);
		SEL_out		: out std_logic_vector(6 downto 0));
end component;
-------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
VGA	: 		VideoCon		port map(  	CLKin 						=> CLKin,
--												READRAM_out					=> READRAM,
--												WRITERAM_out 				=> WRITERAM,
												XSEL_out						=>	XVAR,
												YSEL_out						=> YVAR,
												YCON_out						=> YCONTROL_out,
												COLOR_out               => COLOR_out,
												COLORin						=> COLOR,
												REFRESH_out					=> REFRESH_out,
												STEP_out						=> STEP_out);
				
UART_CON	:	UART			port map(	CLKin						=>	CLKin,
												READin					=> READI,
												RXDin						=> RXDin,
												ASCIIin(7 downto 0)	=> DATAI(7 downto 0),
												ASCII_out(7 downto 0)=>	DATAO(7 downto 0),
												TXD_out					=> TXD_out,
												READ_out					=> READO);	
		
--IMAGERAM  : SRAM_Controller	port map(	CLKin				=> CLKin,													
--														WRITEADDRin 	=> "00000000000000,
--														READADDRin		=> ,
----														DATAin			=>	SDATAI,
----														READin			=> READRAM,
----														WRITEin			=> WRITERAM,
--														SRAMDATA_io		=> SRAMDATA_io,
--														SRAMADDR_out 	=> SRAMADDR_out,
----														DATA_out			=> SDATAO,
--														OE_out			=> OE_out,
--														WE_out			=>	WE_out,
--														CE1_out			=> CE1_out,
--														CE2_out  		=>	CE2_out,
--														UB1_out  		=> UB1_out,
--														LB1_out  		=> LB1_out);

CHARACTERS	: 		CHAR_ROM		port map(  	clka 			=> CLKin,
														addra			=> COLOR2,--RADDRI,
														douta			=> TEST);--RDATAO);

CHARSELECT	: 		ASCII_LUT	port map(  	ASCIIin 		=> TEST2,
														SEL_out		=> COLOR2(9 downto 3));



COLORTEMP : process (CLKin)
	begin 



if TEST(6 - (conv_integer(XVAR) mod 7)) = '1' then
COLOR  <= "000111110001111100011111";
else 
COLOR  <= "000000000000001100000000";
end if;
COLOR2(2 downto 0) <= YVAR(2 downto 0);


if rising_edge(CLKin) then
	------DIRECT ASCII CONTROL LOGIC--------------------
	if HEXSEL1+HEXSEL2 = NUM3 then
		if CLICK = '1' then
			TEST2 <= x"FF";
		else
			TEST2 <= HEXVEC(8*(HEXSEL1+HEXSEL2)+7 downto (8*(HEXSEL1+HEXSEL2)));
		end if;
	else
		TEST2 <= HEXVEC(8*(HEXSEL1+HEXSEL2)+7 downto (8*(HEXSEL1+HEXSEL2)));
	end if;
	LED_out <= DATAO;
	if COUNT = 120000000 then
		COUNT <= 0;
	elsif COUNT < 60000000 then
		COUNT <= COUNT + 1;
		CLICK <= '1';
	else
		COUNT <= COUNT + 1;
		CLICK <= '0';
	end if;
	if falling_edge(READO) then
		HEXVEC((NUM*8)+7 downto (NUM*8)) <= DATAO;
		if NUM < 35 then
			NUM <= NUM + 1;
		else
			NUM <= 0;
		end if;
			if NUM3 < 35 then
			NUM3 <= NUM3 + 1;
		else
			NUM3 <= 0;
		end if;
	end if;
	-----ASCII CONTROL AXIS MANIP-------------------------------
	if XVAR < 8 then
		HEXSEL1 <= 0;
	elsif XVAR < 15 then
		HEXSEL1 <= 1;
	elsif XVAR < 22 then
		HEXSEL1 <= 2;
	elsif XVAR < 29 then
		HEXSEL1 <= 3;
	elsif XVAR < 36 then
		HEXSEL1 <= 4;
	elsif XVAR < 43 then
		HEXSEL1 <= 5;
	elsif XVAR < 50 then
		HEXSEL1 <= 6;
	elsif XVAR < 57 then
		HEXSEL1 <= 7;
	elsif XVAR < 63 then
		HEXSEL1 <= 8;
	end if;
	if YVAR < 8 then
		HEXSEL2 <= 0;
	elsif YVAR < 16 then
		HEXSEL2 <= 9;
	elsif YVAR < 24 then
		HEXSEL2 <= 18;
	else
		HEXSEL2 <= 27;
	end if;
	------------------------------------------------------
end if;
end process COLORTEMP;

end Behavioral;
