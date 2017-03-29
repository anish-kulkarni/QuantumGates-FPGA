----------------------------------
--		Library Declaration 	--
----------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ieee_proposed;
use ieee_proposed.fixed_pkg.all;

----------------------------------
--		Entity Declaration 		--
----------------------------------

entity QFT_1qbit is
	port(
		clk : in std_logic;
		reset : in std_logic; -- (Key0) on keypress, reset becomes zero, state becomes idle and input is taken. Press before start.
		start : in std_logic; -- (key1) on keypress, start becomes 0 and computation starts.
		--a0 : in ufixed(3 downto -4);
		--a1 : in ufixed(3 downto -4);
		b0 : out sfixed(4 downto -4);
		b1 : out sfixed(4 downto -4)
	);
end entity;

----------------------------------
--	Architecture Declaration 	--
----------------------------------

architecture compute of QFT_1qbit is
 
------------------------
-- signal declaration --
------------------------
type ket is array(0 to 1) of sfixed(4 downto -4);
signal Qstate, Qstate_next : ket := ("000000000", "000000000");

type FSM_state_type is (idle,hadamard1,finish);
signal state, state_next : FSM_state_type:=idle;




--signal sig1 : std_logic ;
--signal sig2 : integer range 0 to 25000000 ;
--signal sig3 : std_logic ;

------------------------
--      processes     --
------------------------
begin
process(clk,reset)
       begin
            if reset = '0' then
                 state <= idle;
					  Qstate(0) <= "000011000";--a0; -- Qstate(0) = 1.5 in decimal
					  Qstate(1) <= "000110010";--a1; -- Qstate(1) = 3.125 in decimal
           elsif clk = '1' and clk'event then
                 state<=state_next;
					  Qstate <= Qstate_next;
           end if;
       end process;
 
	QFT : process( clk, state, start )
	variable temp1,temp2,temp3,temp4 : sfixed(5 downto -4) := "0000000000";
	begin
	-- avoid lacth ( I'm not sure why this is done)
      state_next<=state;
		Qstate_next<=Qstate;
		case state is
		when idle =>
			if start ='0' then
				state_next <= hadamard1;
			else 
				state_next <= idle;
			end if;
		when hadamard1 =>
			 temp1 := Qstate(0) + Qstate(1);
			 temp2 := Qstate(0) - Qstate(1);
			 Qstate_next(0) <= temp1(4 downto -4);--resize(temp1,Qstate_next(1));
			 Qstate_next(1) <= temp2(5 downto -3);--resize(temp2,Qstate_next(0));
			 state_next <= finish;
		when finish =>
			 b0 <= Qstate(0);
			 b1 <= Qstate(1);
			 state_next <= finish;
		end case;

	end process QFT;

end compute;

--		if sig1 = '0' then 
--			--statements
--		elsif sig1 = '1' then 
--			--statements
--		end if;