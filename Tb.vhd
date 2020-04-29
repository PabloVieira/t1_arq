library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Tb is
end Tb;

architecture Tb of Tb is	
	signal ceA, ceB,rst, ckA, ckB, A2B, B2A: std_logic;
	signal rwA, rwB, doneA, doneB, ackA, ackB: std_logic;
	signal addA, addB: std_logic_vector (3 downto 0);
	signal dataA, dataB: std_logic_vector( 7 downto 0);
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
				rst => rst, clk => ckA, ACK => ackA, CE => ceA, RW => rwA,
				TX =>A2B, rx => B2A, add => addA, data =>dataA, done => doneA
			);

	SisB: Entity work.UART port map
			(
				rst => rst, clk => ckB, ACK => ackB, CE => ceB, RW => rwB,
				TX =>B2A , rx => A2B, add => addB, data=>dataB, done => doneB
			);
	
	process(ckA)
	begin
		if rst = '1' then
			ceA <= '1';
			rwA <= '0';
			addA <= "0100";
			dataA <= x"41";
			
			ceB <= '1';
			rwB <= '1';
			addB <= "1000";
		end if;
	end process;
	
	process(doneA, doneB)
	begin		
		if doneA = '0' then
			ackA <= '0';
		else
			ackA <= '1';
		end if;
		
		if doneB = '0' then
			ackB <= '0';
		else
			ackB <= '1';
		end if;
	end process;	
end Tb;