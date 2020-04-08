library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Tb is
end Tb;

architecture Tb of Tb is
	signal rx, tx, ack, ce, rw, ckA, ckB, rst: std_logic;
	signal add: std_logic_vector (3 downto 0);
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
			(rst => rst, CK => ckA, ACK => ack, CE => ce, RW => rw, TX =>tx , rx => RX, add => ADD);

	SisB: Entity work.UART port map
			(rst => rst, CK => ckB, ACK => ack, CE => ce, RW => rw, TX =>tx , rx => RX, add => ADD);
end Tb;