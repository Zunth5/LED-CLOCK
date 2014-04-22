library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SRAM_Controller is
	port(
		CLKin				:	in		std_logic;
		READADDRin		:	in		std_logic_vector(22 downto 0);
		WRITEADDRin		:	in		std_logic_vector(22 downto 0);
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
		LB1_out			:	out	std_logic
	);
end SRAM_Controller;

architecture Behavioral of SRAM_Controller is

	signal	CLK			:	std_logic;
	signal	READENA		:	std_logic;
	signal	READCOM		:	std_logic;
	signal	WRITEENA		:	std_logic;
	signal	WRITECOM		:	std_logic;
	signal	QWRITE			:	std_logic_vector(1 downto 0);
	signal	QREAD				:	std_logic_vector(1 downto 0);
	signal 	WRITESTATE		: 	integer range 0 to 3 := 0;
	signal 	READSTATE		:	integer range 0 to 3 := 0;

begin

	CE1_out	<=	'0';
	CE2_out	<=	'0';
	UB1_out	<=	'0';
	LB1_out	<=	'0';
	
	
	process(CLKin)
	begin
		if (rising_edge(CLKin)) then
			QWRITE(0)		<=	WRITEin;
			QREAD(0)			<=	READin;
		end if;	
	end process;

	process(CLKin)
	begin
		if(rising_edge(CLKin)) then
			if (READin = '1') then
				SRAMADDR_out<=READADDRin;
				READENA	<=	'1';
				SRAMDATA_io		<= (others => 'Z');
			elsif (WRITEin = '1' and READENA = '0') then
				SRAMADDR_out<=WRITEADDRin;
				WRITEENA	<= '1';	
			end if;
			
			if (READENA = '1') then
				case READSTATE is
					when 0 =>
						READSTATE <= 1;
					when 1 =>
						READSTATE <= 2;
					when 2 =>
						READSTATE <= 3;
					when 3 =>
						READSTATE <= 0;
				end case;
			else
				if (READSTATE = 3) then
					READSTATE <= 0;
				end if;
			end if;

			if (WRITEENA = '1') then
				case WRITESTATE is
					when 0 =>
						WRITESTATE <= 1;
					when 1 =>
						WRITESTATE <= 2;
					when 2 =>
						WRITESTATE <= 3;
					when 3 =>
						WRITESTATE <= 0;
				end case;
			else
				if (WRITESTATE = 3) then
					WRITESTATE <= 0;
				end if;
			end if;

			case READSTATE is
				when 0 =>
					OE_out			<=	'1';				
				when 1 =>
					OE_out			<=	'0';
					DATA_out			<=	SRAMDATA_io(14 downto 0);
				when 2 =>
					OE_out			<=	'1';
					DATA_out			<=	SRAMDATA_io(14 downto 0);
					READENA		 	<= '0';
				when 3 =>
					OE_out			<= '1';					
			end case;

			case WRITESTATE is
				when 0 =>
					WE_out			<= '1';
					
				when 1 =>
					WE_out			<=	'0';	
					SRAMDATA_io		<=	DATAin;
				when 2 =>
					WE_out			<= '1';
					SRAMDATA_io		<=	DATAin;
					WRITEENA			<= '0';
				when 3 =>
					WE_out			<=	'1';
									
			end case;
		end if;
	end process;

end Behavioral;

