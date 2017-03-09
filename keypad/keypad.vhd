----------------------------------
--		Library Declaration 	--
----------------------------------
-- Like any other programming language, we should declare libraries

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

----------------------------------
--		Entity Declaration 		--
----------------------------------
-- Here we specify all input/output ports

entity keypad is
	port(
		column_out : out std_logic_vector(3 downto 0);
		row_in : in std_logic_vector(3 downto 0);
		reset_btn : in std_logic;
		clk_50mhz : in std_logic;
		key : out character
	);
end entity;

----------------------------------
--	Architecture Declaration 	--
----------------------------------
--	here we put the description code of the design

architecture behave of keypad is

-- signal declaration
type table is array (0 to 3, 0 to 3) of character;
signal lookup: table := (('1','2','3','0'),('4','5','6','0'),('7','8','9','0'),('d','0','d','0'));

begin
	for n in 0 to 3 loop
		column_out <= "0000";
		column_out(n) <= "1";
		if row_in = "0001" then
			key <= lookup(3,n);
		elsif row_in = "0010" then 
			key <= lookup(2,n);
		elsif row_in = "0100" then
			key <= lookup(1,n);
		elsif row_in = "1000" then
			key <= lookup(0,n);
	end if;	
	end behave;
