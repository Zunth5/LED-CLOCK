library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProjectMain is
  port ( CLKin			: in std_logic;
			BTNin			: in std_logic;
			BTN2in		: in std_logic;
			SWin			: in std_logic_vector(7 downto 0);
			REFRESH_out	: out std_logic;
			STEP_out		: out std_logic;
			COLOR_out	: out std_logic_vector(5 downto 0);
			YCONTROL_out: out std_logic_vector(3 downto 0);
			RXDin			:	in std_logic;
			TXD_out		:  out std_logic;
			LED_out		:  out std_logic_vector (7 downto 0)
--			SEG_out		:  out std_logic_vector(6 downto 0);
--			SEG_sel		: 	out std_logic_vector(3 downto 0);
--			-----SRAM-------------------
--			SRAMDATA_io		:	inout	std_logic_vector(7 downto 0);
--			SRAMADDR_out	:  out   std_logic_vector(18 downto 0);
--			OE_out			:	out	std_logic;
--			WE_out			:	out	std_logic;
--			CE1_out			:	out	std_logic;
--			CE2_out			:	out	std_logic;
--			UB1_out			:	out	std_logic;
--			LB1_out			:	out	std_logic;
--			---keyboard------------------
--			K_Data_in		: 	in std_logic;
--			K_Clkin			:	in std_logic;
--			---KEV-----------------------
--			sig_eoc			: in std_logic;
--			sig_cba_out    : out std_logic_vector(2 downto 0);
--			sig_data			: in std_logic_vector(7 downto 0);
--			sig_start		: out std_logic;
--			sig_oe			: out std_logic;
--			sig_ale			: out std_logic;
--			sig_adcclk		: out std_logic;
--			sig_sscath		: out std_logic_vector(7 downto 0);
--			sig_ssan			: out std_logic_vector(3 downto 0);
--			opulse_right	: out std_logic;
--			opulse_left		: out std_logic;
--			-------------
--			eoc 				: in std_logic;
--			cba_out 			: out std_logic_vector(2 downto 0);
--			pot_data			: in std_logic_vector(7 downto 0);
--			start				: out std_logic;
--			oe					: out std_logic;
--			ale				: out std_logic;
--			adc_clk  		: out std_logic;
--			sevseg_anode 	: out std_logic_vector(3 downto 0);
--			sevseg_cathode	: out std_logic_vector(7 downto 0);
--			led_test			: out std_logic_vector(7 downto 0)
);
end ProjectMain;
-------------------------------------------------------------------------------

architecture Behavioral of ProjectMain is
-------------------------------------------------------------------------------
signal STEP			: std_logic:='0';
signal YVAR			: std_logic_Vector(4 downto 0);
signal XVAR			: std_logic_Vector(5 downto 0);
signal COLOR		: std_logic_Vector(23 downto 0);
signal COLOR1		: std_logic_Vector(7 downto 0):=X"00";
signal COLOR2		: std_logic_Vector(7 downto 0):=X"00";
signal COLOR3		: std_logic_Vector(7 downto 0):=X"00";
signal ENABLE 	   : std_logic:= '0';
signal VAR1 	   : std_logic:= '0';
signal VAR2 	   : std_logic:= '0';

signal COUNT      : integer:= 0;
signal COUNT2     : integer:= 0;
signal NUM	      : integer:= 0;
signal NUM2	      : integer:= 0;

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
--component SRAM_Controller is
--	port(
--		CLKin				:	in		std_logic;
--		WRITEADDRin		:	in		std_logic_vector(18 downto 0);
--		READADDRin		:  in    std_logic_vector(18 downto 0);
--		DATAin			:	in		std_logic_vector(7 downto 0);
--		READin			:	in		std_logic;
--		WRITEin			:	in		std_logic;
--		------------------------
--		SRAMDATA_io		:	inout	std_logic_vector(7 downto 0);
--		------------------------
--		SRAMADDR_out	:  out   std_logic_vector(18 downto 0);  
--		DATA_out			:	out	std_logic_vector(7 downto 0);
--		OE_out			:	out	std_logic;
--		WE_out			:	out	std_logic;
--		CE1_out			:	out	std_logic;
--		CE2_out			:	out	std_logic;
--		UB1_out			:	out	std_logic;
--		LB1_out			:	out	std_logic
--	);
--end component;
--------------------------------------------------------------------


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
	

	
--VGADATA  : 	SRAM_Controller					port map(	CLKin				=> CLKin,													
--																		WRITEADDRin 	=> WRITEADDR,
--																		READADDRin		=> XSEL(9 downto 0) & YSEL(8 downto 0),
--																		DATAin			=>	DATA2,
--																		READin			=> READRAM,
--																		WRITEin			=> WRITERAM,
--																		SRAMDATA_io		=> SRAMDATA_io,
--																		SRAMADDR_out 	=> SRAMADDR_out,
--																		DATA_out			=> DATA,
--																		OE_out			=> OE_out,
--																		WE_out			=>	WE_out,
--																		CE1_out			=> CE1_out,
--																		CE2_out  		=>	CE2_out,
--																		UB1_out  		=> UB1_out,
--																		LB1_out  		=> LB1_out);
COLORTEMP : process (CLKin)
	begin 
	
	

	
--	if rising_edge(CLKin) then
--		if NUM2 < 5000000 then
--			NUM2 <= NUM2 + 1;
--		else
--			NUM2 <= 0;
--			if COUNT2 > 30 then
--				VAR2 <= '1';
--				COUNT2 <= COUNT2 - 1;
--			elsif COUNT2 < 2 then
--				VAR2 <= '0';
--				COUNT2 <= COUNT2 + 1;
--			end if;
--			if VAR2 = '1' then
--				COUNT2 <= COUNT2 - 1;
--			else
--				COUNT2 <= COUNT2 + 1;
--			end if;
----		COUNT2 <= 31;
--		end if;
--			if XVAR = 10 then
--				COLOR(23 downto 0) <= SWin & SWin & SWin;
--			elsif YVAR >= 2 and YVAR <= 7 then
--				COLOR(7 downto 0) <= conv_std_logic_vector(COUNT2,8);
--				COLOR(23 downto 8) <= X"0000";
--			elsif YVAR >= 12 and YVAR <= 17 then
--				COLOR(15 downto 8) <= conv_std_logic_vector(COUNT2,8);
--				COLOR(23 downto 16) <= X"00";
--				COLOR(7 downto 0) <= X"00";
--			elsif YVAR >= 22 and YVAR <= 27 then
--				COLOR(23 downto 16) <= conv_std_logic_vector(COUNT2,8);
--				COLOR(15 downto 0) <= X"0000";
--			else
--				COLOR(23 downto 0) <= X"000000";
--			end if;
--	end if;	
	
	COLOR(23 downto 0) <= X"000000";
	
	
--------------------------------------------------------------------------------------	
	
--if XVAR = SWin(4 downto 0) then
--COLOR(23 downto 0) <= X"0000" & "00000" & SWin(7 downto 5);
--elsif YVAR = SWin(4 downto 0) then
--COLOR(23 downto 0) <= X"0000" & "00000100";
--else
--COLOR(23 downto 0) <= X"000000";
--end if;

-------------------------------------------------------------------------------------	
--	if rising_edge(CLKin) then
--		if NUM2 < 5000000 then
--			NUM2 <= NUM2 + 1;
--		else
--			NUM2 <= 0;
--			if COUNT2 > 53 then
--				COUNT2 <= COUNT2 - 1;
--				VAR2 <= '1';
--			elsif COUNT2 < 3 then
--				COUNT2 <= COUNT2 + 1;
--				VAR2 <= '0';
--			end if;
--			if VAR2 = '1' then
--				COUNT2 <= COUNT2 - 1;
--			else
--				COUNT2 <= COUNT2 + 1;
--			end if;
--		end if;
--		if NUM < 5000000 then
--			NUM <= NUM + 1;
--		else
--			NUM <= 0;	
--			if COUNT > 21 then
--				COUNT <= COUNT - 1;
--				VAR1 <= '1';
--			elsif COUNT < 3 then
--				COUNT <= COUNT + 1;
--				VAR1 <= '0';
--			end if;
--			if VAR1 = '1' then
--				COUNT <= COUNT - 1;
--			else
--				COUNT <= COUNT + 1;
--			end if;
--		end if;
--	end if;
--	if YVAR <= COUNT + 7 and YVAR >= COUNT and XVAR <= COUNT2 + 7 and XVAR >= COUNT2 then
--		COLOR <= "100001000010000";
--	else
--		if XVAR = 0 or XVAR = 63 or YVAR = 31 or YVAR = 0 then
--			COLOR  <= "000001000000000";
--		else
--			if XVAR <= 16 or XVAR >= 48 then
--				if XVAR = 16 or XVAR = 48 then
--					COLOR <= "000001000000000";
--				else
--					if XVAR < 16 and COUNT2 < 16 then
--					COLOR <= "000010000000000";
--					elsif XVAR > 48 and COUNT2 > 48 - 7 then
--					COLOR <= "000000000000001";
--					else
--					COLOR <= "000000000000000";
--					end if;
--				end if;
--			else
--			COLOR <= "000000000000000";
--			end if;
--		end if;
--	end if;
--end if;

LED_out<= DATAO;

end process COLORTEMP;

end Behavioral;
