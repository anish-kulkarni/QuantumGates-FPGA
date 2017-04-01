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
					ledtemp : out ufixed ( 3 downto -4 ):="00000000"
					);
					
end interface;

-------####################################----------

architecture Behavioral of interface is

signal result : ufixed(3 downto -4):="01010101"; -- = 15.4375 in decimal
type string is array (positive range <>) of character;
signal char: string (1 to 7):= "3.14159";
signal p, p_next:integer := 1;
signal input1 : STD_LOGIC_VECTOR (7 downto 0):="00000000";
signal data : STD_LOGIC_VECTOR (7 downto 0):="00000000";
signal lcd_state : STD_LOGIC_VECTOR (0 to 1);
signal my_state : STD_LOGIC:= '0' ;

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

component float_mult port(
			clk : in std_logic;
			product : out ufixed(3 downto -4);
			inter_state : in std_logic:= '0'
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
								
num : float_mult PORT MAP (
									clk => CLK,
									product => result,
									inter_state => my_state
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
			elsif char(p) = 'n' then
				data <= "00000000";
			end if;
		
	end if;	
	end process;

-------####################################----------


								
communicate: process(lcd_state)
begin
p_next<=p;
	if lcd_state = "00" then
		input1 <= "00000000";
		my_state <= '1';
	elsif lcd_state = "01" then
		if p<7 then 
			input1 <= data;
			my_state<='1';
		else
			input1 <= "00000000";
			my_state <= '1';
		end if;
	elsif lcd_state = "10" then
		my_state <= '0';
		if p<8 then 
			input1 <= data;
		else
			input1 <= "00000000";
		end if;
	elsif lcd_state = "11" then
		my_state <= '0';
		p_next <= p+1;
	end if;

end process;

conv : process(result) 
begin
	if result = to_ufixed(00.0000,result) then
	 	char <= "00.0000";
	elsif result = to_ufixed(00.0625,result) then
	 	char <= "00.0625";
	elsif result = to_ufixed(00.1250,result) then
	 	char <= "00.1250";
	elsif result = to_ufixed(00.1875,result) then
	 	char <= "00.1875";
	elsif result = to_ufixed(00.2500,result) then
	 	char <= "00.2500";
	elsif result = to_ufixed(00.3125,result) then
	 	char <= "00.3125";
	elsif result = to_ufixed(00.3750,result) then
	 	char <= "00.3750";
	elsif result = to_ufixed(00.4375,result) then
	 	char <= "00.4375";
	elsif result = to_ufixed(00.5000,result) then
	 	char <= "00.5000";
	elsif result = to_ufixed(00.5625,result) then
	 	char <= "00.5625";
	elsif result = to_ufixed(00.6250,result) then
	 	char <= "00.6250";
	elsif result = to_ufixed(00.6875,result) then
	 	char <= "00.6875";
	elsif result = to_ufixed(00.7500,result) then
	 	char <= "00.7500";
	elsif result = to_ufixed(00.8125,result) then
	 	char <= "00.8125";
	elsif result = to_ufixed(00.8750,result) then
	 	char <= "00.8750";
	elsif result = to_ufixed(00.9375,result) then
	 	char <= "00.9375";
	elsif result = to_ufixed(01.0000,result) then
	 	char <= "01.0000";
	elsif result = to_ufixed(01.0625,result) then
	 	char <= "01.0625";
	elsif result = to_ufixed(01.1250,result) then
	 	char <= "01.1250";
	elsif result = to_ufixed(01.1875,result) then
	 	char <= "01.1875";
	elsif result = to_ufixed(01.2500,result) then
	 	char <= "01.2500";
	elsif result = to_ufixed(01.3125,result) then
	 	char <= "01.3125";
	elsif result = to_ufixed(01.3750,result) then
	 	char <= "01.3750";
	elsif result = to_ufixed(01.4375,result) then
	 	char <= "01.4375";
	elsif result = to_ufixed(01.5000,result) then
	 	char <= "01.5000";
	elsif result = to_ufixed(01.5625,result) then
	 	char <= "01.5625";
	elsif result = to_ufixed(01.6250,result) then
	 	char <= "01.6250";
	elsif result = to_ufixed(01.6875,result) then
	 	char <= "01.6875";
	elsif result = to_ufixed(01.7500,result) then
	 	char <= "01.7500";
	elsif result = to_ufixed(01.8125,result) then
	 	char <= "01.8125";
	elsif result = to_ufixed(01.8750,result) then
	 	char <= "01.8750";
	elsif result = to_ufixed(01.9375,result) then
	 	char <= "01.9375";
	elsif result = to_ufixed(02.0000,result) then
	 	char <= "02.0000";
	elsif result = to_ufixed(02.0625,result) then
	 	char <= "02.0625";
	elsif result = to_ufixed(02.1250,result) then
	 	char <= "02.1250";
	elsif result = to_ufixed(02.1875,result) then
	 	char <= "02.1875";
	elsif result = to_ufixed(02.2500,result) then
	 	char <= "02.2500";
	elsif result = to_ufixed(02.3125,result) then
	 	char <= "02.3125";
	elsif result = to_ufixed(02.3750,result) then
	 	char <= "02.3750";
	elsif result = to_ufixed(02.4375,result) then
	 	char <= "02.4375";
	elsif result = to_ufixed(02.5000,result) then
	 	char <= "02.5000";
	elsif result = to_ufixed(02.5625,result) then
	 	char <= "02.5625";
	elsif result = to_ufixed(02.6250,result) then
	 	char <= "02.6250";
	elsif result = to_ufixed(02.6875,result) then
	 	char <= "02.6875";
	elsif result = to_ufixed(02.7500,result) then
	 	char <= "02.7500";
	elsif result = to_ufixed(02.8125,result) then
	 	char <= "02.8125";
	elsif result = to_ufixed(02.8750,result) then
	 	char <= "02.8750";
	elsif result = to_ufixed(02.9375,result) then
	 	char <= "02.9375";
	elsif result = to_ufixed(03.0000,result) then
	 	char <= "03.0000";
	elsif result = to_ufixed(03.0625,result) then
	 	char <= "03.0625";
	elsif result = to_ufixed(03.1250,result) then
	 	char <= "03.1250";
	elsif result = to_ufixed(03.1875,result) then
	 	char <= "03.1875";
	elsif result = to_ufixed(03.2500,result) then
	 	char <= "03.2500";
	elsif result = to_ufixed(03.3125,result) then
	 	char <= "03.3125";
	elsif result = to_ufixed(03.3750,result) then
	 	char <= "03.3750";
	elsif result = to_ufixed(03.4375,result) then
	 	char <= "03.4375";
	elsif result = to_ufixed(03.5000,result) then
	 	char <= "03.5000";
	elsif result = to_ufixed(03.5625,result) then
	 	char <= "03.5625";
	elsif result = to_ufixed(03.6250,result) then
	 	char <= "03.6250";
	elsif result = to_ufixed(03.6875,result) then
	 	char <= "03.6875";
	elsif result = to_ufixed(03.7500,result) then
	 	char <= "03.7500";
	elsif result = to_ufixed(03.8125,result) then
	 	char <= "03.8125";
	elsif result = to_ufixed(03.8750,result) then
	 	char <= "03.8750";
	elsif result = to_ufixed(03.9375,result) then
	 	char <= "03.9375";
	elsif result = to_ufixed(04.0000,result) then
	 	char <= "04.0000";
	elsif result = to_ufixed(04.0625,result) then
	 	char <= "04.0625";
	elsif result = to_ufixed(04.1250,result) then
	 	char <= "04.1250";
	elsif result = to_ufixed(04.1875,result) then
	 	char <= "04.1875";
	elsif result = to_ufixed(04.2500,result) then
	 	char <= "04.2500";
	elsif result = to_ufixed(04.3125,result) then
	 	char <= "04.3125";
	elsif result = to_ufixed(04.3750,result) then
	 	char <= "04.3750";
	elsif result = to_ufixed(04.4375,result) then
	 	char <= "04.4375";
	elsif result = to_ufixed(04.5000,result) then
	 	char <= "04.5000";
	elsif result = to_ufixed(04.5625,result) then
	 	char <= "04.5625";
	elsif result = to_ufixed(04.6250,result) then
	 	char <= "04.6250";
	elsif result = to_ufixed(04.6875,result) then
	 	char <= "04.6875";
	elsif result = to_ufixed(04.7500,result) then
	 	char <= "04.7500";
	elsif result = to_ufixed(04.8125,result) then
	 	char <= "04.8125";
	elsif result = to_ufixed(04.8750,result) then
	 	char <= "04.8750";
	elsif result = to_ufixed(04.9375,result) then
	 	char <= "04.9375";
	elsif result = to_ufixed(05.0000,result) then
	 	char <= "05.0000";
	elsif result = to_ufixed(05.0625,result) then
	 	char <= "05.0625";
	elsif result = to_ufixed(05.1250,result) then
	 	char <= "05.1250";
	elsif result = to_ufixed(05.1875,result) then
	 	char <= "05.1875";
	elsif result = to_ufixed(05.2500,result) then
	 	char <= "05.2500";
	elsif result = to_ufixed(05.3125,result) then
	 	char <= "05.3125";
	elsif result = to_ufixed(05.3750,result) then
	 	char <= "05.3750";
	elsif result = to_ufixed(05.4375,result) then
	 	char <= "05.4375";
	elsif result = to_ufixed(05.5000,result) then
	 	char <= "05.5000";
	elsif result = to_ufixed(05.5625,result) then
	 	char <= "05.5625";
	elsif result = to_ufixed(05.6250,result) then
	 	char <= "05.6250";
	elsif result = to_ufixed(05.6875,result) then
	 	char <= "05.6875";
	elsif result = to_ufixed(05.7500,result) then
	 	char <= "05.7500";
	elsif result = to_ufixed(05.8125,result) then
	 	char <= "05.8125";
	elsif result = to_ufixed(05.8750,result) then
	 	char <= "05.8750";
	elsif result = to_ufixed(05.9375,result) then
	 	char <= "05.9375";
	elsif result = to_ufixed(06.0000,result) then
	 	char <= "06.0000";
	elsif result = to_ufixed(06.0625,result) then
	 	char <= "06.0625";
	elsif result = to_ufixed(06.1250,result) then
	 	char <= "06.1250";
	elsif result = to_ufixed(06.1875,result) then
	 	char <= "06.1875";
	elsif result = to_ufixed(06.2500,result) then
	 	char <= "06.2500";
	elsif result = to_ufixed(06.3125,result) then
	 	char <= "06.3125";
	elsif result = to_ufixed(06.3750,result) then
	 	char <= "06.3750";
	elsif result = to_ufixed(06.4375,result) then
	 	char <= "06.4375";
	elsif result = to_ufixed(06.5000,result) then
	 	char <= "06.5000";
	elsif result = to_ufixed(06.5625,result) then
	 	char <= "06.5625";
	elsif result = to_ufixed(06.6250,result) then
	 	char <= "06.6250";
	elsif result = to_ufixed(06.6875,result) then
	 	char <= "06.6875";
	elsif result = to_ufixed(06.7500,result) then
	 	char <= "06.7500";
	elsif result = to_ufixed(06.8125,result) then
	 	char <= "06.8125";
	elsif result = to_ufixed(06.8750,result) then
	 	char <= "06.8750";
	elsif result = to_ufixed(06.9375,result) then
	 	char <= "06.9375";
	elsif result = to_ufixed(07.0000,result) then
	 	char <= "07.0000";
	elsif result = to_ufixed(07.0625,result) then
	 	char <= "07.0625";
	elsif result = to_ufixed(07.1250,result) then
	 	char <= "07.1250";
	elsif result = to_ufixed(07.1875,result) then
	 	char <= "07.1875";
	elsif result = to_ufixed(07.2500,result) then
	 	char <= "07.2500";
	elsif result = to_ufixed(07.3125,result) then
	 	char <= "07.3125";
	elsif result = to_ufixed(07.3750,result) then
	 	char <= "07.3750";
	elsif result = to_ufixed(07.4375,result) then
	 	char <= "07.4375";
	elsif result = to_ufixed(07.5000,result) then
	 	char <= "07.5000";
	elsif result = to_ufixed(07.5625,result) then
	 	char <= "07.5625";
	elsif result = to_ufixed(07.6250,result) then
	 	char <= "07.6250";
	elsif result = to_ufixed(07.6875,result) then
	 	char <= "07.6875";
	elsif result = to_ufixed(07.7500,result) then
	 	char <= "07.7500";
	elsif result = to_ufixed(07.8125,result) then
	 	char <= "07.8125";
	elsif result = to_ufixed(07.8750,result) then
	 	char <= "07.8750";
	elsif result = to_ufixed(07.9375,result) then
	 	char <= "07.9375";
	elsif result = to_ufixed(08.0000,result) then
	 	char <= "08.0000";
	elsif result = to_ufixed(08.0625,result) then
	 	char <= "08.0625";
	elsif result = to_ufixed(08.1250,result) then
	 	char <= "08.1250";
	elsif result = to_ufixed(08.1875,result) then
	 	char <= "08.1875";
	elsif result = to_ufixed(08.2500,result) then
	 	char <= "08.2500";
	elsif result = to_ufixed(08.3125,result) then
	 	char <= "08.3125";
	elsif result = to_ufixed(08.3750,result) then
	 	char <= "08.3750";
	elsif result = to_ufixed(08.4375,result) then
	 	char <= "08.4375";
	elsif result = to_ufixed(08.5000,result) then
	 	char <= "08.5000";
	elsif result = to_ufixed(08.5625,result) then
	 	char <= "08.5625";
	elsif result = to_ufixed(08.6250,result) then
	 	char <= "08.6250";
	elsif result = to_ufixed(08.6875,result) then
	 	char <= "08.6875";
	elsif result = to_ufixed(08.7500,result) then
	 	char <= "08.7500";
	elsif result = to_ufixed(08.8125,result) then
	 	char <= "08.8125";
	elsif result = to_ufixed(08.8750,result) then
	 	char <= "08.8750";
	elsif result = to_ufixed(08.9375,result) then
	 	char <= "08.9375";
	elsif result = to_ufixed(09.0000,result) then
	 	char <= "09.0000";
	elsif result = to_ufixed(09.0625,result) then
	 	char <= "09.0625";
	elsif result = to_ufixed(09.1250,result) then
	 	char <= "09.1250";
	elsif result = to_ufixed(09.1875,result) then
	 	char <= "09.1875";
	elsif result = to_ufixed(09.2500,result) then
	 	char <= "09.2500";
	elsif result = to_ufixed(09.3125,result) then
	 	char <= "09.3125";
	elsif result = to_ufixed(09.3750,result) then
	 	char <= "09.3750";
	elsif result = to_ufixed(09.4375,result) then
	 	char <= "09.4375";
	elsif result = to_ufixed(09.5000,result) then
	 	char <= "09.5000";
	elsif result = to_ufixed(09.5625,result) then
	 	char <= "09.5625";
	elsif result = to_ufixed(09.6250,result) then
	 	char <= "09.6250";
	elsif result = to_ufixed(09.6875,result) then
	 	char <= "09.6875";
	elsif result = to_ufixed(09.7500,result) then
	 	char <= "09.7500";
	elsif result = to_ufixed(09.8125,result) then
	 	char <= "09.8125";
	elsif result = to_ufixed(09.8750,result) then
	 	char <= "09.8750";
	elsif result = to_ufixed(09.9375,result) then
	 	char <= "09.9375";
	elsif result = to_ufixed(10.0000,result) then
	 	char <= "10.0000";
	elsif result = to_ufixed(10.0625,result) then
	 	char <= "10.0625";
	elsif result = to_ufixed(10.1250,result) then
	 	char <= "10.1250";
	elsif result = to_ufixed(10.1875,result) then
	 	char <= "10.1875";
	elsif result = to_ufixed(10.2500,result) then
	 	char <= "10.2500";
	elsif result = to_ufixed(10.3125,result) then
	 	char <= "10.3125";
	elsif result = to_ufixed(10.3750,result) then
	 	char <= "10.3750";
	elsif result = to_ufixed(10.4375,result) then
	 	char <= "10.4375";
	elsif result = to_ufixed(10.5000,result) then
	 	char <= "10.5000";
	elsif result = to_ufixed(10.5625,result) then
	 	char <= "10.5625";
	elsif result = to_ufixed(10.6250,result) then
	 	char <= "10.6250";
	elsif result = to_ufixed(10.6875,result) then
	 	char <= "10.6875";
	elsif result = to_ufixed(10.7500,result) then
	 	char <= "10.7500";
	elsif result = to_ufixed(10.8125,result) then
	 	char <= "10.8125";
	elsif result = to_ufixed(10.8750,result) then
	 	char <= "10.8750";
	elsif result = to_ufixed(10.9375,result) then
	 	char <= "10.9375";
	elsif result = to_ufixed(11.0000,result) then
	 	char <= "11.0000";
	elsif result = to_ufixed(11.0625,result) then
	 	char <= "11.0625";
	elsif result = to_ufixed(11.1250,result) then
	 	char <= "11.1250";
	elsif result = to_ufixed(11.1875,result) then
	 	char <= "11.1875";
	elsif result = to_ufixed(11.2500,result) then
	 	char <= "11.2500";
	elsif result = to_ufixed(11.3125,result) then
	 	char <= "11.3125";
	elsif result = to_ufixed(11.3750,result) then
	 	char <= "11.3750";
	elsif result = to_ufixed(11.4375,result) then
	 	char <= "11.4375";
	elsif result = to_ufixed(11.5000,result) then
	 	char <= "11.5000";
	elsif result = to_ufixed(11.5625,result) then
	 	char <= "11.5625";
	elsif result = to_ufixed(11.6250,result) then
	 	char <= "11.6250";
	elsif result = to_ufixed(11.6875,result) then
	 	char <= "11.6875";
	elsif result = to_ufixed(11.7500,result) then
	 	char <= "11.7500";
	elsif result = to_ufixed(11.8125,result) then
	 	char <= "11.8125";
	elsif result = to_ufixed(11.8750,result) then
	 	char <= "11.8750";
	elsif result = to_ufixed(11.9375,result) then
	 	char <= "11.9375";
	elsif result = to_ufixed(12.0000,result) then
	 	char <= "12.0000";
	elsif result = to_ufixed(12.0625,result) then
	 	char <= "12.0625";
	elsif result = to_ufixed(12.1250,result) then
	 	char <= "12.1250";
	elsif result = to_ufixed(12.1875,result) then
	 	char <= "12.1875";
	elsif result = to_ufixed(12.2500,result) then
	 	char <= "12.2500";
	elsif result = to_ufixed(12.3125,result) then
	 	char <= "12.3125";
	elsif result = to_ufixed(12.3750,result) then
	 	char <= "12.3750";
	elsif result = to_ufixed(12.4375,result) then
	 	char <= "12.4375";
	elsif result = to_ufixed(12.5000,result) then
	 	char <= "12.5000";
	elsif result = to_ufixed(12.5625,result) then
	 	char <= "12.5625";
	elsif result = to_ufixed(12.6250,result) then
	 	char <= "12.6250";
	elsif result = to_ufixed(12.6875,result) then
	 	char <= "12.6875";
	elsif result = to_ufixed(12.7500,result) then
	 	char <= "12.7500";
	elsif result = to_ufixed(12.8125,result) then
	 	char <= "12.8125";
	elsif result = to_ufixed(12.8750,result) then
	 	char <= "12.8750";
	elsif result = to_ufixed(12.9375,result) then
	 	char <= "12.9375";
	elsif result = to_ufixed(13.0000,result) then
	 	char <= "13.0000";
	elsif result = to_ufixed(13.0625,result) then
	 	char <= "13.0625";
	elsif result = to_ufixed(13.1250,result) then
	 	char <= "13.1250";
	elsif result = to_ufixed(13.1875,result) then
	 	char <= "13.1875";
	elsif result = to_ufixed(13.2500,result) then
	 	char <= "13.2500";
	elsif result = to_ufixed(13.3125,result) then
	 	char <= "13.3125";
	elsif result = to_ufixed(13.3750,result) then
	 	char <= "13.3750";
	elsif result = to_ufixed(13.4375,result) then
	 	char <= "13.4375";
	elsif result = to_ufixed(13.5000,result) then
	 	char <= "13.5000";
	elsif result = to_ufixed(13.5625,result) then
	 	char <= "13.5625";
	elsif result = to_ufixed(13.6250,result) then
	 	char <= "13.6250";
	elsif result = to_ufixed(13.6875,result) then
	 	char <= "13.6875";
	elsif result = to_ufixed(13.7500,result) then
	 	char <= "13.7500";
	elsif result = to_ufixed(13.8125,result) then
	 	char <= "13.8125";
	elsif result = to_ufixed(13.8750,result) then
	 	char <= "13.8750";
	elsif result = to_ufixed(13.9375,result) then
	 	char <= "13.9375";
	elsif result = to_ufixed(14.0000,result) then
	 	char <= "14.0000";
	elsif result = to_ufixed(14.0625,result) then
	 	char <= "14.0625";
	elsif result = to_ufixed(14.1250,result) then
	 	char <= "14.1250";
	elsif result = to_ufixed(14.1875,result) then
	 	char <= "14.1875";
	elsif result = to_ufixed(14.2500,result) then
	 	char <= "14.2500";
	elsif result = to_ufixed(14.3125,result) then
	 	char <= "14.3125";
	elsif result = to_ufixed(14.3750,result) then
	 	char <= "14.3750";
	elsif result = to_ufixed(14.4375,result) then
	 	char <= "14.4375";
	elsif result = to_ufixed(14.5000,result) then
	 	char <= "14.5000";
	elsif result = to_ufixed(14.5625,result) then
	 	char <= "14.5625";
	elsif result = to_ufixed(14.6250,result) then
	 	char <= "14.6250";
	elsif result = to_ufixed(14.6875,result) then
	 	char <= "14.6875";
	elsif result = to_ufixed(14.7500,result) then
	 	char <= "14.7500";
	elsif result = to_ufixed(14.8125,result) then
	 	char <= "14.8125";
	elsif result = to_ufixed(14.8750,result) then
	 	char <= "14.8750";
	elsif result = to_ufixed(14.9375,result) then
	 	char <= "14.9375";
	elsif result = to_ufixed(15.0000,result) then
	 	char <= "15.0000";
	elsif result = to_ufixed(15.0625,result) then
	 	char <= "15.0625";
	elsif result = to_ufixed(15.1250,result) then
	 	char <= "15.1250";
	elsif result = to_ufixed(15.1875,result) then
	 	char <= "15.1875";
	elsif result = to_ufixed(15.2500,result) then
	 	char <= "15.2500";
	elsif result = to_ufixed(15.3125,result) then
	 	char <= "15.3125";
	elsif result = to_ufixed(15.3750,result) then
	 	char <= "15.3750";
	elsif result = to_ufixed(15.4375,result) then
	 	char <= "15.4375";
	elsif result = to_ufixed(15.5000,result) then
	 	char <= "15.5000";
	elsif result = to_ufixed(15.5625,result) then
	 	char <= "15.5625";
	elsif result = to_ufixed(15.6250,result) then
	 	char <= "15.6250";
	elsif result = to_ufixed(15.6875,result) then
	 	char <= "15.6875";
	elsif result = to_ufixed(15.7500,result) then
	 	char <= "15.7500";
	elsif result = to_ufixed(15.8125,result) then
	 	char <= "15.8125";
	elsif result = to_ufixed(15.8750,result) then
	 	char <= "15.8750";
	elsif result = to_ufixed(15.9375,result) then
	 	char <= "15.9375";
	end if;
end process conv;


-------####################################----------
ledtemp <= result;
end Behavioral;
