library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-------Real Number Representation Libraries----------

use IEEE.MATH_REAL.ALL;
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.float_pkg.all;

-------####################################----------

entity interface is
    Port ( 
			      clk : in STD_LOGIC; 
               start : in STD_LOGIC;
               lcd_write : in STD_LOGIC;
               reset : in STD_LOGIC;
               lcd_data : out STD_LOGIC_VECTOR (7 downto 0);
               e : out STD_LOGIC;
               rs : out STD_LOGIC;
               rw : out STD_LOGIC;
					led : out STD_LOGIC_VECTOR ( 7 downto 0):="00000000";
					--ledtemp : out ufixed ( 3 downto -4 ):="00000000"
					ledtemp : out std_LOGIC_VECTOR ( 7 downto 0):="00000000" --added by anish
					);
					
end interface;

-------####################################----------

architecture Behavioral of interface is

signal result : ufixed(3 downto -4):="01010101"; -- = 15.4375 in decimal
type string is array (positive range <>) of character;
signal char: string (1 to 64);
signal p, p_next:integer := 1;
signal input1 : STD_LOGIC_VECTOR (7 downto 0):="00000000";
signal data : STD_LOGIC_VECTOR (7 downto 0):="00000000";
signal lcd_state : STD_LOGIC_VECTOR (0 to 1);
signal my_state : STD_LOGIC:= '0' ;
signal finished : STD_LOGIC;

-- enable from float_mult is left!!!

-------####################################----------

component lcd Port(
					clk : in STD_LOGIC; 
               start : in STD_LOGIC;
               lcd_write : in STD_LOGIC;
               reset : in STD_LOGIC; 	
               input1 : in STD_LOGIC_VECTOR (7 downto 0);
               lcd_data : out STD_LOGIC_VECTOR (7 downto 0);
               e : out STD_LOGIC;
               rs : out STD_LOGIC;
               rw : out STD_LOGIC;
					led : out STD_LOGIC_VECTOR ( 7 downto 0):="00000000";
					lcd_state : out STD_LOGIC_VECTOR (0 to 1) := "00"
--					button : in STd_LOGIC
);
end component;

-------####################################----------

--component float_mult port(
--			clk : in std_logic;
--			product : out ufixed(3 downto -4);
--			inter_state : in std_logic:= '0'
--	);
--
--end component;

-------####################################----------

component qft_2qbit port(
		clk : in std_logic;
		reset : in std_logic; -- (Key0) on keypress, reset becomes zero, state becomes idle and input is taken. Press before start.
		start : in std_logic; -- (key1) on keypress, start becomes 0 and computation starts.
--		b0RE : out sfixed(4 downto -4); -- first bit represents sign with remaining in 2s complement for negative number.
--		b1RE : out sfixed(4 downto -4); -- Actually only 8 out of 9 bits for storing data.
--		b2RE : out sfixed(4 downto -4);
--		b3RE : out sfixed(4 downto -4);
--		b0IM : out sfixed(4 downto -4); 
--		b1IM : out sfixed(4 downto -4); 
--		b2IM : out sfixed(4 downto -4);
--		b3IM : out sfixed(4 downto -4);
		Output: out String(1 to 64);
		finished: out STD_logic:= '0'
);
end component;



-------####################################----------
begin

Init_lcd : lcd PORT MAP (
								clk=>clk,
								start=>start, 
								lcd_write=>lcd_write,
								reset=>reset, 
								input1=>input1, 
								lcd_data=>lcd_data, 
								e=>e, 
								rs=>rs, 
								rw=>rw, 
								led=>led,
								lcd_state=>lcd_state
								);
								
--num : float_mult PORT MAP (
--									clk => CLK,
--									product => result,
--									inter_state => my_state
--									);

qft : qft_2qbit PORT MAP (
		clk => clk,
		reset => reset,
		start => start,
		Output => char,
		finished => finished
);


-------####################################----------

process(clk)
 begin
		if clk='1' and clk'event then
			p<=p_next;			
	  end if;
end process;
												
-------####################################----------							

chartoBIN: process(clk, lcd_state) --char will be changed to string
	begin	
	if lcd_state = "10" OR lcd_state = "01" then
		
			if char(p) = '0' then 
				data <= "00110000";
			elsif char(p) = '1' then 
				data <= "00110001";
			elsif char(p) = '2' then
				data <= "00110010";
			elsif char(p) = '3' then
				data <= "00110011";
			elsif char(p) = '4' then
				data <= "00110100";
			elsif char(p) = '5' then
				data <= "00110101";
			elsif char(p) = '6' then
				data <= "00110110";
			elsif char(p) = '7' then
				data <= "00110111";
			elsif char(p) = '8' then
				data <= "00111000";
			elsif char(p) = '9' then
				data <= "00111001";
			elsif char(p) = '.' then
				data <= "00101110";
			elsif char(p) = '+' then		--added by anish
				data <= "00101011";
			elsif char(p) = '-' then		--added by anish
				data <= "00101101";
			elsif char(p) = 'n' then
				data <= "00000000";
			end if;
		
	end if;	
	end process;

-------####################################----------


								
communicate: process(lcd_state, finished)
begin
--if finished= '1' then --commented by anish
	p_next<=p;
		if lcd_state = "00" then
			input1 <= "00000000";
			my_state <= '1';
		elsif lcd_state = "01" then
			if p<31 then 
				input1 <= data;
				my_state<='1';
			else
				input1 <= "00000000";
				my_state <= '1';
			end if;
		elsif lcd_state = "10" then
			my_state <= '0';
			if p<32 then 
				input1 <= data;
			else
				input1 <= "00000000";
			end if;
		elsif lcd_state = "11" then
			my_state <= '0';
			p_next <= p+1;
		end if;
--end if; --commented by anish
end process;



ledtemp <= data; --added by anish
end Behavioral;
