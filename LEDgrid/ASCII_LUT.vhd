library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ASCII_LUT is
port( ASCIIin		: in std_logic_vector(7 downto 0);
		SEL_out		: out std_logic_vector(6 downto 0));
end ASCII_LUT;

architecture Behavioral of ASCII_LUT is

begin
COLORTEMP : process (ASCIIin)
	begin 
	
end process COLORTEMP;

with ASCIIin select
		  SEL_out   <= "000" & X"0" WHEN X"20"  ,   --SPACE
							"000" & X"1" WHEN X"41"  ,   --A
							"000" & X"2" WHEN X"42"  ,   --B
							"000" & X"3" WHEN X"43"  ,   --C
							"000" & X"4" WHEN X"44"  ,   --D
							"000" & X"5" WHEN X"45"  ,   --E
							"000" & X"6" WHEN X"46"  ,   --F
							"000" & X"7" WHEN X"47"  ,   --G
							"000" & X"8" WHEN X"48"  ,   --H
							"000" & X"9" WHEN X"49"  ,   --I
							"000" & X"A" WHEN X"4A"  ,   --J
							"000" & X"B" WHEN X"4B"  ,   --K
							"000" & X"C" WHEN X"4C"  ,   --L
							"000" & X"D" WHEN X"4D"  ,   --M
							"000" & X"E" WHEN X"4E"  ,   --N
							"000" & X"F" WHEN X"4F"  ,   --O
							"001" & X"0" WHEN X"50"  ,   --P
							"001" & X"1" WHEN X"51"  ,   --Q
							"001" & X"2" WHEN X"52"  ,   --R
							"001" & X"3" WHEN X"53"  ,   --S
							"001" & X"4" WHEN X"54"  ,   --T
							"001" & X"5" WHEN X"55"  ,   --U
							"001" & X"6" WHEN X"56"  ,   --V
							"001" & X"7" WHEN X"57"  ,   --W
							"001" & X"8" WHEN X"58"  ,   --X
							"001" & X"9" WHEN X"59"  ,   --Y
							"001" & X"A" WHEN X"5A"  ,   --Z
							"001" & X"B" WHEN X"61"  ,   --a
							"001" & X"C" WHEN X"62"  ,   --b
							"001" & X"D" WHEN X"63"  ,   --c
							"001" & X"E" WHEN X"64"  ,   --d
							"001" & X"F" WHEN X"65"  ,   --e
							"010" & X"0" WHEN X"66"  ,   --f
							"010" & X"1" WHEN X"67"  ,   --g
							"010" & X"2" WHEN X"68"  ,   --h
							"010" & X"3" WHEN X"69"  ,   --i
							"010" & X"4" WHEN X"6A"  ,   --j
							"010" & X"5" WHEN X"6B"  ,   --k
							"010" & X"6" WHEN X"6C"  ,   --l
							"010" & X"7" WHEN X"6D"  ,   --m
							"010" & X"8" WHEN X"6E"  ,   --n
							"010" & X"9" WHEN X"6F"  ,   --o
							"010" & X"A" WHEN X"70"  ,   --p
							"010" & X"B" WHEN X"71"  ,   --q
							"010" & X"C" WHEN X"72"  ,   --r
							"010" & X"D" WHEN X"73"  ,   --s
							"010" & X"E" WHEN X"74"  ,   --t
							"010" & X"F" WHEN X"75"  ,   --u
							"011" & X"0" WHEN X"76"  ,   --v
							"011" & X"1" WHEN X"77"  ,   --w
							"011" & X"2" WHEN X"78"  ,   --x
							"011" & X"3" WHEN X"79"  ,   --y
							"011" & X"4" WHEN X"7A"  ,   --z
							"011" & X"5" WHEN X"30"  ,   --0
							"011" & X"6" WHEN X"31"  ,   --1
							"011" & X"7" WHEN X"32"  ,   --2
							"011" & X"8" WHEN X"33"  ,   --3
							"011" & X"9" WHEN X"34"  ,   --4
							"011" & X"A" WHEN X"35"  ,   --5
							"011" & X"B" WHEN X"36"  ,   --6
							"011" & X"C" WHEN X"37"  ,   --7
							"011" & X"D" WHEN X"38"  ,   --8
							"011" & X"E" WHEN X"39"  ,   --9
							"011" & X"F" WHEN X"5B"  ,   --[
							"100" & X"0" WHEN X"5D"  ,   --]
--							"100" & X"1" WHEN X"  "  ,   --down
--							"100" & X"2" WHEN X"  "  ,   --up
--							"100" & X"3" WHEN X"  "  ,   --left
--							"100" & X"4" WHEN X"  "  ,   --right
							"100" & X"5" WHEN X"3A"  ,   --:
							"100" & X"6" WHEN X"3B"  ,   --;
							"100" & X"7" WHEN X"21"  ,   --!
							"100" & X"8" WHEN X"22"  ,   --"
							"100" & X"9" WHEN X"23"  ,   --#
							"100" & X"A" WHEN X"24"  ,   --$
							"100" & X"B" WHEN X"25"  ,   --%
							"100" & X"C" WHEN X"26"  ,   --&
							"100" & X"D" WHEN X"27"  ,   --'
							"100" & X"E" WHEN X"28"  ,   --(
							"100" & X"F" WHEN X"29"  ,   --)
							"101" & X"0" WHEN X"2A"  ,   --*
							"101" & X"1" WHEN X"2B"  ,   --+
							"101" & X"2" WHEN X"2C"  ,   --,
							"101" & X"3" WHEN X"2D"  ,   -- -
							"101" & X"4" WHEN X"2E"  ,   --. 
							"101" & X"5" WHEN X"2F"  ,   --/
							"101" & X"6" WHEN X"40"  ,   --@
							"101" & X"7" WHEN X"3F"  ,   --?
--							"101" & X"8" WHEN X"  "  ,   -- dev
							"101" & X"9" WHEN X"3D"  ,   --=
							"101" & X"A" WHEN X"5C"  ,   --\
--							"101" & X"B" WHEN X"  "  ,   -- degree
							"101" & X"C" WHEN X"7E"  ,   --~
							"101" & X"D" WHEN X"7C"  ,   --|
							"101" & X"E" WHEN X"3E"  ,   -->
							"101" & X"F" WHEN X"3C"  ,   --<
							"110" & X"0" WHEN X"7B"  ,   --{
							"110" & X"1" WHEN X"7D"  ,   --}
							"110" & X"2" WHEN X"5E"  ,   --^
							"110" & X"3" WHEN X"5F"  ,   --_
							"110" & X"4" WHEN X"FF"  ,   --BAR
							"000" & X"0" WHEN others;

end Behavioral;