library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProjectMain is
  port ( CLKin			: in std_logic;
			LED_out		:  out std_logic_vector (7 downto 0);
			----LED-MATRIX--------------
			REFRESH_out	: out std_logic;
			STEP_out		: out std_logic;
			COLOR_out	: out std_logic_vector(5 downto 0);
			YCONTROL_out: out std_logic_vector(3 downto 0);
			----UART--------------------
			RXDin			:	in std_logic;
			TXD_out		:  out std_logic;
			----SRAM--------------------
			SRAMDATA_io		:	inout	std_logic_vector(14 downto 0);
			SRAMADDR_out	:  out   std_logic_vector(22 downto 0);
			OE_out			:	out	std_logic;
			WE_out			:	out	std_logic;
			CE1_out			:	out	std_logic;
			CE2_out			:	out	std_logic;
			UB1_out			:	out	std_logic;
			LB1_out			:	out	std_logic
			);
end ProjectMain;
-------------------------------------------------------------------------------

architecture Behavioral of ProjectMain is
------------------------------------------------------------------------------- 
signal YVAR			: std_logic_Vector(4 downto 0);
signal XVAR			: std_logic_Vector(5 downto 0);
signal COLOR		: std_logic_Vector(14 downto 0);
signal COLOR2		: std_logic_Vector(9 downto 0);
signal COLOR3		: std_logic_Vector(14 downto 0):=(others => '0');
signal COLOR4		: std_logic_Vector(14 downto 0):=(others => '0');

signal MODE			: std_logic_vector(1 downto 0):=(others => '0');
signal HEXVEC		: std_logic_vector(295 downto 0):=(others => '0');
signal PIXDISP    : std_logic_vector(511 downto 0):=(others => '0');
signal HEXSEL1    : integer:= 0;
signal HEXSEL2    : integer:= 0;
signal PIXRAM		: std_logic_vector(15 downto 0);
signal PIXRAM2    : std_logic_vector(22 downto 0);
signal PIXRAMX    : std_logic_vector(22 downto 0);
signal READRAM		: std_logic:='0';

signal ASCII2		: std_logic_vector(6 downto 0);  
signal ASCII1		: std_logic_vector(7 downto 0);
signal UPDAFOR		: std_logic;
signal RAMCON 	   : std_logic:= '0';
signal PIXSEL		: std_logic_vector(4 downto 0);

signal UARTFOR		: std_logic_vector(7 downto 0);
signal CLICK      : std_logic:= '0';
signal COUNT      : integer:= 0;
signal COUNT2     : integer:= 0;
signal COUNT3     : integer:= 0;
signal COUNT4     : integer:= 0;
signal XVAR2	   : std_logic_vector(5 downto 0);
signal NUM	      : integer:= 0;
signal NUM3	      : integer:= 3;
signal CLK2			: std_logic:='0';

signal CSEL		: std_logic_Vector(14 downto 0):="111110000100001";

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
			COLORin		: in std_logic_vector(14 downto 0);
			COLOR_out   : out std_logic_vector(5 downto 0); 
			YCON_out		: out std_logic_vector(3 downto 0);
			XSEL_out		: out std_logic_vector(5 downto 0);
			XSEL2_out	: out std_logic_vector(5 downto 0);
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
		WRITEADDRin		:	in		std_logic_vector(22 downto 0);
		READADDRin		:  in    std_logic_vector(22 downto 0);
		DATAin			:	in		std_logic_vector(14 downto 0);
		READin			:	in		std_logic;
		WRITEin			:	in		std_logic;
		------------------------
		SRAMDATA_io		:	inout	std_logic_vector(14 downto 0);
		------------------------
		SRAMADDR_out	:  out   std_logic_vector(22 downto 0);  
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
--------------------------------------------------------------------
component DATA_CONSTRUCT is
  port (	CLKin			: in  std_logic; 								--system clock
			UPDATEin   	: in  std_logic; 								--uart update signal
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
end component;
-------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
VGA	: 		VideoCon		port map(  	CLKin 						=> CLKin,
												XSEL_out						=>	XVAR,
												YSEL_out						=> YVAR,
												XSEL2_out					=> XVAR2,
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

MAKE_DATA : DATA_CONSTRUCT	port map(	CLKin				=> CLKin,		
													UPDATEin       => READO,
													UARTin 		   => DATAO,
													COLOR_out 		=> COLOR3,
													PIXSEL_out	   => PIXSEL,
													PIXRAM_out     => PIXRAM,
													MODE_out       => MODE,													
													UARTFOR_out 	=> UARTFOR,
													RAMCON_out     => RAMCON,
													UPDAFOR_out    => UPDAFOR, 
													UARTUPD_out    => READI,
													UARTDAT_out	   =>	DATAI);
													
IMAGERAM  : SRAM_Controller	port map(	CLKin				=> CLKin,													
														WRITEADDRin 	=> PIXRAMX(22 downto 0),
														READADDRin		=> PIXRAM2(22 downto 0),
														DATAin			=>	COLOR3,
														READin			=> READRAM,
														WRITEin			=> NOT READRAM,
														SRAMDATA_io		=> SRAMDATA_io,
														SRAMADDR_out 	=> SRAMADDR_out,
														DATA_out			=> COLOR4,
														OE_out			=> OE_out,
														WE_out			=>	WE_out,
														CE1_out			=> CE1_out,
														CE2_out  		=>	CE2_out,
														UB1_out  		=> UB1_out,
														LB1_out  		=> LB1_out);

CHARACTERS	: 		CHAR_ROM		port map(  	clka 			=> CLKin,
														addra			=> COLOR2,
														douta			=> ASCII2);

CHARSELECT	: 		ASCII_LUT	port map(  	ASCIIin 		=> ASCII1,
														SEL_out		=> COLOR2(9 downto 3));



COLORTEMP : process (CLKin)
	begin 
if rising_edge(CLK2) then
	if COUNT4 < 179 then
		COUNT4 <= COUNT4 + 1;
	else
		COUNT4 <= 0;
	end if;
	if COUNT4 >= 0 and COUNT4 <= 29 then
		CSEL(4 downto 0) <= CSEL(4 downto 0) + 1;
	elsif COUNT4 >= 30 and COUNT4 <= 59 then
		CSEL(14 downto 10) <= CSEL(14 downto 10) - 1;
	elsif COUNT4 >= 60 and COUNT4 <= 89 then
		CSEL(9 downto 5) <= CSEL(9 downto 5) + 1;
	elsif COUNT4 >= 90 and COUNT4 <= 119 then 
		CSEL(4 downto 0) <= CSEL(4 downto 0) - 1;	
	elsif COUNT4 >= 120 and COUNT4 <= 149 then
		CSEL(14 downto 10) <= CSEL(14 downto 10) + 1;	
	elsif COUNT4 >= 150 and COUNT4 <= 179 then 
		CSEL(9 downto 5) <= CSEL(9 downto 5) - 1;	
	end if;
end if;	
if rising_edge(CLKin) then
	if COUNT3 = 15000000 then
		COUNT3 <= 0;
		CLK2 <= '1';
	else
		COUNT3 <= COUNT3 + 1;
		CLK2 <= '0';
	end if;
	
	if MODE = "00" or MODE = "10" then --DISPLAY
		HEXVEC <= (others => '0');
		PIXRAM2 <=  conv_std_logic_vector(conv_integer(PIXDISP((conv_integer(YVAR(4 downto 3) & XVAR2(5 downto 3)))*16+15 downto (conv_integer(YVAR(4 downto 3) & XVAR2(5 downto 3)))*16))*64,23) + conv_integer(YVAR(2 downto 0) & "000") + conv_integer(XVAR2(2 downto 0)); 
		if PIXDISP((conv_integer(YVAR(4 downto 3) & XVAR(5 downto 3)))*16+15 downto (conv_integer(YVAR(4 downto 3) & XVAR(5 downto 3)))*16) = 0 then
		COLOR  <= "000000000000000"; 
		else
		COLOR <= COLOR4;
		end if;
		READRAM <= '1';	
		if mode = "10" then
			if rising_edge(UPDAFOR) then
				PIXDISP(conv_integer(PIXSEL)*16+15 downto conv_integer(PIXSEL)*16) <= PIXRAM;
			end if;
		end if;
	elsif MODE = "01" then
		if rising_edge(RAMCON) then	
			PIXRAMX <= conv_std_logic_vector(conv_integer(PIXRAM) * 64,23) + COUNT2; 
			READRAM <= '0';
			if COUNT2 < 63 then
				COUNT2 <= COUNT2 + 1;	
			else
				COUNT2 <= 0;
			end if;
		end if;
		COLOR  <= "000000000000000"; 
	elsif MODE = "11" then
		------DIRECT ASCII CONTROL LOGIC--------------------
		if HEXSEL1+HEXSEL2 = NUM3 then
			if CLICK = '1' then
				ASCII1 <= x"FF";
			else
				ASCII1 <= HEXVEC(8*(HEXSEL1+HEXSEL2)+7 downto (8*(HEXSEL1+HEXSEL2)));
			end if;
		else
			ASCII1 <= HEXVEC(8*(HEXSEL1+HEXSEL2)+7 downto (8*(HEXSEL1+HEXSEL2)));
		end if;
		
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
			if NUM < 36 then
				NUM <= NUM + 1;
			else
				NUM <= 0;
			end if;
			if NUM3 < 36 then
				NUM3 <= NUM3 + 1;
			else
				NUM3 <= 0;
			end if;
		end if;
		COLOR2(2 downto 0) <= YVAR(2 downto 0);
		if ASCII2(6 - (conv_integer(XVAR) mod 7)) = '1' then
			COLOR  <= CSEL;
		else 
			COLOR  <= "000000000000000";
		end if;
		
--		------------------------------------------------------	
	end if;
	if (XVAR = 0 or XVAR = 63 or YVAR = 0 or YVAR = 31) and MODE /= 3 then
		COLOR <= CSEL;
	end if;
end if;

LED_out <= conv_std_logic_vector(conv_integer(MODE),8);



	-----ASCII CONTROL AXIS MANIP-------------------------------
--	if XVAR < 7 then
--		HEXSEL1 <= 0;
--	elsif XVAR < 15 then
--		HEXSEL1 <= 1;
--	elsif XVAR < 22 then
--		HEXSEL1 <= 2;
--	elsif XVAR < 29 then
--		HEXSEL1 <= 3;
--	elsif XVAR < 36 then
--		HEXSEL1 <= 4;
--	elsif XVAR < 43 then
--		HEXSEL1 <= 5;
--	elsif XVAR < 50 then
--		HEXSEL1 <= 6;
--	elsif XVAR < 57 then
--		HEXSEL1 <= 7;
--	else
--		HEXSEL1 <= 8;
--	end if;
--	if YVAR < 8 then
--		HEXSEL2 <= 0;
--	elsif YVAR < 16 then
--		HEXSEL2 <= 9;
--	elsif YVAR < 24 then
--		HEXSEL2 <= 18;
--	else
--		HEXSEL2 <= 27;
--	end if;
	------------------------------------------------------
	
	
	
	

end process COLORTEMP;

end Behavioral;
