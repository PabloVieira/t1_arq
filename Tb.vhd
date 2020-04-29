library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Tb is
end Tb;

architecture Tb of Tb is	
	signal ceA, ceB,rst, ckA, ckB, A2B, B2A: std_logic;
	signal rwA, rwB, doneA, doneB, baseRW, ackA, ackB: std_logic;
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
	
	process
	begin
		wait until rst'event and rst = '0';
		ceA <= '1';
		rwA <= '0';
		addA <= "0100";
		dataA <= x"41";
		ceB <= '1';
		rwB <= '1';
		addB <= "0000";
		wait until baseRW = '1' and doneB = '1';
		addB <= "1000";
--		rwB <= '0';
--		addB <= "0100";
--		dataB <= x"42";
--		rwA <= '1';
--		addA <= "1000";
	end process;
	
	
	process(ckA, ckB)
	begin
		if addA = "0000" and dataA = x"00" and doneA = '1' then
			baseRW <= '0';
			ackA <= '1';
		end if;
		if addA = "0000" and dataA = x"01" and doneA = '1' then
			baseRW <= '1';
			ackA <= '1';
		end if;
		if doneA = '0' then
			ackA <= '0';
		end if;
		
		if addB = "0000" and dataB = x"00" and doneB = '1' then
			baseRW <= '0';
			ackB <= '1';
		end if;
		if addB = "0000" and dataB = x"01" and doneB = '1' then
			baseRW <= '1';
			ackB <= '1';
		end if;
		if doneB = '0' then
			ackB <= '0';
		end if;

	end process;
end Tb;