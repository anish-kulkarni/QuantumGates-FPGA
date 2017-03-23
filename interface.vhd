library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity interface is
    Port ( 
			      clk : in STD_LOGIC; 
               start : in STD_LOGIC;
               lcd_write : in STD_LOGIC;
               reset : in STD_LOGIC;
--               input1 : in STD_LOGIC_VECTOR (7 downto 0);
               lcd_data : out STD_LOGIC_VECTOR (7 downto 0);
               e : out STD_LOGIC;
               rs : out STD_LOGIC;
               rw : out STD_LOGIC;
					led : out STD_LOGIC_VECTOR ( 7 downto 0):="00000000"
--					button : in STd_LOGIC
					);
end interface;

architecture Behavioral of interface is

type data_type is array(0 to 6) of character;
constant char : data_type:= ('8','.','1','4','1','5','9');
signal p, p_next:integer :=0;
signal input1 : STD_LOGIC_VECTOR (7 downto 0):="00000000";
signal data : STD_LOGIC_VECTOR (7 downto 0):="00000000";--"01010000";
signal lcd_state : STD_LOGIC_VECTOR (0 to 1);
--signal char : character:= '1' ;

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

process(clk)
 begin
		if clk='1' and clk'event then
			p<=p_next;			
	  end if;
end process;
							

chartoBIN: process(lcd_state) --char will be changed to string
	begin	
	if lcd_state = "10" then
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
		elsif char(p) = '#' then
			data <= "00000000";
		end if;
	end if;	
	end process;




								
communicate: process(lcd_state)
begin
p_next<=p;
	if lcd_state = "00" then
		input1 <= "00000000";
	elsif lcd_state = "01" then
		if p<7 then 
			input1 <= data;
		else
			input1 <= "00000000";
		end if;
	elsif lcd_state = "10" then
		if p<7 then 
			input1 <= data;
		else
			input1 <= "00000000";
		end if;
	elsif lcd_state = "11" then
		p_next <= p+1;
	end if;

end process;
		  
end Behavioral;
