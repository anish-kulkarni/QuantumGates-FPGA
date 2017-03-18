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
		lcd : out STD_LOGIC_VECTOR(7 downto 0)
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
signal code : STD_LOGIC_VECTOR(7 downto 0);
signal key : character;
signal tempcolumn_out :  std_logic_vector(3 downto 0);
signal n : integer range 0 to 3 :=0;

begin
	Keyinput: process( clk_50mhz, reset_btn )
	begin 
	if rising_edge(clk_50mhz) then
			column_out <= "1111";
			column_out(n) <= '0';
	end if;
	if falling_edge(clk_50mhz) then
			if row_in = "1110" then
				key <= lookup(0,n);
			elsif row_in = "1101" then 
				key <= lookup(1,n);
			elsif row_in = "1011" then
				key <= lookup(2,n);
			elsif row_in = "0111" then
				key <= lookup(3,n);
			elsif row_in = "1111" then 
				key <= '#';
			else 
				key <= 'd';
			end if;			
			if n < 3 then
				n <= n+1;
			else
				n <= 0;
			end if;
	end if;
		
end process Keyinput;
	
	display : process( key )
	begin
	   if key = '0' then 
			code <= "00110000";
		elsif key = '1' then 
			code <= "00110001";
		elsif key = '2' then
			code <= "00110010";
		elsif key = '3' then
			code <= "00110011";
		elsif key = '4' then
			code <= "00110100";
		elsif key = '5' then
			code <= "00110101";
		elsif key = '6' then
			code <= "00110110";
		elsif key = '7' then
			code <= "00110111";
		elsif key = '8' then
			code <= "00111000";
		elsif key = '9' then
			code <= "00111001";
		elsif key = 'd' then
			code <= "00101110";
		elsif key = '#' then
			code <= "00000000";
		end if;
	end process;
	
	lcd <= code;
	end behave;
