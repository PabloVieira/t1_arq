library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Tb is
end Tb;

architecture Tb of Tb is
	signal A2B, B2A, ackA, ackB, ceA, ceB, rwA, rwB , ckA, ckB, rstA, rstB: std_logic;
	signal addA, addB: std_logic_vector (3 downto 0);
	signal dataA,dataB: std_logic_vector( 7 downto 0);
	signal doneA,doneB: std_logic;
begin
	rst <= '1', '0' after 50 ns;
	process
	begin
		ckA <= '1', '0' after 5 ns;
		wait for 10 ns;
	end process;
	
	process
	begin
		ckB <= '1', '0' after 5 ns;
		wait for 20 ns;
	end process;

	SisA: Entity work.UART port map
			(rst => rst, ClK => ckA, ACK => ackA, CE => ceA, RW => rwA, TX =>A2B , rx => B2A, addA => ADD, data =>dataA );

	SisB: Entity work.UART port map
			(rst => rst, ClK => ckB, ACK => ackB, CE => ceB, RW => rwB, TX =>B2A , rx => A2B, addB => ADD, data=>dataB);
	

	process
	begin
		dataA <= X"41" after 5 ns, X'00' after 100 ns, ;
		ce<='1' after 5 ns, '0' after 20 ns;
		rw<='1' after 5 ns, '0' after 20 ns;
		addA <= "0100" after 5 ns,'0' after 20 ns;

		wait for 100 ns;


		

	end process;

end Tb;