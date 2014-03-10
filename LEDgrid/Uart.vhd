
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART is
    port (
			Clkin		:in  std_logic;
			READin	:in  std_logic;
			RXDin		:in  std_logic;
			ASCIIin  :in  std_logic_vector (7 downto 0);
			ASCII_out:out  std_logic_vector (7 downto 0);
			TXD_out	:out std_logic;
			READ_out : out std_logic);
end UART;

architecture Behavioral of UART is

signal TEST    :  std_logic;
signal CLKTXD	:	std_logic;
signal CLKRXD	:	std_logic;
signal X			:  std_logic_vector(1 downto 0);

-----------------------------------------------
component UartClkDiv
port(	
	CLKin			:	in std_logic;
	CLKTXD_out	:	inout std_logic;
	CLKRXD_out	:	inout std_logic);
end component;

-----------------------------------------------
component UartLogic is
    port (
		  reset		  :in  std_logic; 	
        txclk       :in  std_logic;
        ld_tx_data  :in  std_logic;
        tx_data     :in  std_logic_vector (7 downto 0);
        tx_enable   :in  std_logic;
        tx_out      :out std_logic;
        tx_empty    :out std_logic;
        ---------------
		  rxclk       :in  std_logic;
		  uld_rx_data :in  std_logic;
		  rx_data     :out std_logic_vector (7 downto 0);
		  rx_enable   :in  std_logic;
		  rx_in       :in  std_logic;
		  rx_empty    :out std_logic);
end component;
-----------------------------------------------
begin

UART_CLK_DIV 	:	UartClkDiv	port map(	CLKin			=> CLKin,
														CLKTXD_out	=>	CLKTXD,
														CLKRXD_out	=>	CLKRXD);

UART_LOGIC		:	UartLogic	port map(	reset			=> '0',
														-------------------------
														txclk			=> CLKTXD,
														ld_tx_data	=> READin,
														tx_data		=> ASCIIin,
														tx_enable	=> '1',
														tx_out		=> TXD_out,
														tx_empty		=> X(0),
														------------------------
														rxclk			=>	CLKRXD,
														uld_rx_data	=> '1',
														rx_data		=> ASCII_out,
														rx_enable	=>	'1',
														rx_in			=>	RXDin,
														rx_empty		=> READ_out);
end Behavioral;

