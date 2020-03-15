library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Tb is
end Tb;

architecture Tb of Tb is
	signal ck, rst: std_logic;
begin
	rst <= '1', '0' after 50 ns;
	process
	begin
		ck <= '1', '0' after 5 ns;
		wait for 10 ns;
	end process;

	SisA: Entity work.UART port map
			(rst => rst, ck => ck, tx => TX, rx => RX, ...
			);

	SisB: Entity work.UART port map
			(rst => rst, ck => ck, rx => TX, tx => RX, ...
			);
end Tb;