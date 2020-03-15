library IEEE;
use IEEE.std_logic_1164.all;

entity UART is
	port
	(
		ck, rst: in std_logic;
		RX: in std_logic;
		TX: out std_logic;
		address: in std_logic_vector(3 downto 0);
		data: inout std_logic_vector(7 downto 0);
		...
	);
end UART;

architecture UART of UART is
begin
			-- Implementação da UART --
end UART;