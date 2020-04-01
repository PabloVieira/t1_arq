library IEEE;
use IEEE.std_logic_1164.all;

entity UART is
	port
	(
		CK, CK2, rst, ack, CE, RW: in std_logic;
		RX: in std_logic;
		TX, done: out std_logic;
		ADD: in std_logic_vector(3 downto 0);
		DATA: inout std_logic_vector(7 downto 0)
	);
end UART;

architecture UART of UART is
begin
			-- Implementação da UART --
end UART;