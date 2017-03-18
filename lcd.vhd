library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lcd is
    Port ( clk : in STD_LOGIC; 
               start : in STD_LOGIC;
               lcd_write : in STD_LOGIC;
               reset : in STD_LOGIC;
               input1 : in STD_LOGIC_VECTOR (7 downto 0);
               lcd_data : out STD_LOGIC_VECTOR (7 downto 0);
               e : out STD_LOGIC;
               rs : out STD_LOGIC;
               rw : out STD_LOGIC);
end lcd;

architecture Behavioral of lcd is
       constant upper_limit:integer:=50000;
       type state_type is (idle,command,ready,write_lcd);
       signal state,state_next:state_type:=idle;
       type command_type is array (0 to 3) of std_logic_vector (7 downto 0);
       constant commando: command_type:=(x"38",x"01",x"06",x"0F"); --LCD commands
       signal n,n_next:integer:=0;
       signal lcd_write_tick,lcd_write_next:std_logic;
       signal counter,counter_next:integer:=0;
		 type data_type is array(0 to 6) of std_logic_vector(7 downto 0);
		 --constant data : data_type:= (x"51",x"55",x"41",x"4E",x"54",x"55",x"4B"); 
		 constant data : data_type:= (x"30",x"31",x"32",x"33",x"34",x"35",x"36");
		 signal p:integer:=0;
begin
       process(clk)
       begin
            if clk='1' and clk'event then
                  lcd_write_next<=lcd_write; 
            end if;
       end process;

       lcd_write_tick<= lcd_write and (not lcd_write_next);
       rw<='0';

       process(clk,reset)
       begin
            if reset='1' then
                 state<=idle;
                 n<=0;
					  --p<=0;
                 counter<=0;
           elsif clk='1' and clk'event then
                 state<=state_next;
                 n<=n_next;
                 counter<=counter_next; 
           end if;
       end process;

       process(state,n,start,lcd_write_tick,counter)
       begin
       -- avoid lacth
       state_next<=state;
       counter_next<=counter;
       n_next<=n;
       rs<='1';
       e<='1'; 
       case state is 
            when idle => 
						p<=0;
                  if start='1' then
                      state_next<=command;
                  end if;
            when command=> 
                 rs<='0';
                 lcd_data<=commando(n); 
                 if counter =upper_limit then
                     e<='0';
                     counter_next<=0;
                     n_next<=n+1;
                     if n = commando'high then
                          n_next<=0;
                          state_next<=ready;
                     end if;
                 else
                      counter_next<=counter+1;
                 end if;
            when ready => 
                 if p<7 then
                     state_next<=write_lcd; 
							p <= p+1;
                 end if;
            when write_lcd=>
                 lcd_data <= data(p);--"00110011";
                 if counter = upper_limit then
                     e<='0';
                     counter_next<=0;
                     state_next<=ready;
                 else
                      counter_next<=counter+1; 
                 end if; 
					  					  
          end case;
      end process; 
end Behavioral;
