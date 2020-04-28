library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Tb is
end Tb;

architecture Tb of Tb is
	signal ckA, ckB, rstA, rstB: std_logic := '0';
	signal A2B, B2A, ackA, ackB, ceA, ceB, rwA, rwB: std_logic := '0';
	signal addA, addB: std_logic_vector (3 downto 0);
	signal dataA, dataB: std_logic_vector( 7 downto 0);
	signal doneA, doneB: std_logic;
	signal rst: std_logic;
begin
	rst <= '1', '0' after 10 ns;
	process
	begin
		ckA <= '1', '0' after 5 ns;
		wait for 10 ns;
	end process;
	
	process
	begin
		ckB <= '1', '0' after 10 ns;
		wait for 20 ns;
	end process;

	SisA: Entity work.UART port map
			(
				rst => rst, ClK => ckA, ACK => ackA, CE => ceA, RW => rwA,
				TX =>A2B, rx => B2A, add => addA, data =>dataA, done => doneA
			);

	SisB: Entity work.UART port map
			(
				rst => rst, ClK => ckB, ACK => ackB, CE => ceB, RW => rwB,
				TX =>B2A , rx => A2B, add => addB, data=>dataB, done => doneB
			);
	
	process(rst)
	begin
		dataA <= x"41";
		dataB <= x"42";
	end process;
	
	process(dataA)
	begin
		--dataA <= X"41" after 5 ns, X"00" after 20 ns;
		ceA<='1' after 5 ns;
		rwA<='1' after 5 ns;
		addA <= "0100" after 5 ns,"0000" after 20 ns;
		if doneA = '1' then
			ackA <= '1';
		end if;
		
	end process;
	
	process(dataB)
	begin
		ceB<='1' after 105 ns;
		rwB<='1' after 105 ns;
		addB <= "0100" after 105 ns,"0000" after 120 ns;
		if doneB = '1' then
			ackB <= '1';
		end if;

	end process;

end Tb;