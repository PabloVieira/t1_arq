library IEEE
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

------------------------	UART
entity UART is
	port(
		-----------------------------Clock e Reset
		ck, reset: in std_logic;

		------------------------------Confirmação[Sys->UART], Escrita/Leitura, Chip Enable 
		ack, rw, ce: in std_logic; 

		-----------------------------Confirmação[UART->Sys]
		done: out std_logic;

		-----------------------------Bits de transferência serial
		RX: in std_logic;
		TX: out std_logic;

		-----------------------------Endereço de acesso
		address: in std_logic_vector(3 downto 0);

		-----------------------------Dados
		data: inout std_logic_vector(7 downto 0)
	);
end UART;

architecture UART of UART is
    ---------------------------------Sinais de chip enable: BASE, (RW)REGISTER WRITE, (RR)REGISTER READ
    signal ce_base, ce_rw, ce_rr: std_logic;

    ---------------------------------Sinais interno (rw para rwo) & (rri para rr)
    signal dataToRWO, dataToRR: std_logic_vector(7 downto 0);

    ---------------------------------Sinais de entrada dos dados no Sistema superior(MESTRE)
    signal data_outBase, data_outRR: std_logic_vector(7 downto 0);

    ---------------------------------Sinal de pedido para enviar dados de RR para RWO
    signal requestToRWO: std_logic;

    ---------------------------------Sinal de resposta se RRW está ocupado ou não
    signal rwo_busy:std_logic;

begin
    ---------------------------------Instâncias dos módulos BASE, RW, RWO, RR, RRI
    RW_UART:    RW port map(
                            ce=> ce_rw,
                            data_in=> data,
                            data_out=> dataToRWO, 
                            request =>requestToRWO, 
                            ok2send=> rwo_busy
                            );

    RWO_UART:   RWO port map(
                            data_in=> dataToRWO, 
                            data_out=> TX, 
                            data_incoming=> requestToRWO, 
                            busy=> rwo_busy
                            );

    BASE_UART:  BASE port map(
                            ce=> ce_base, 
                            data_out=> data_outBase
                            );

    RR_UART:    RR port map(
                            ce=> ce_rr, 
                            data_in=> dataToRR, 
                            data_out => data_outRR 
                            );

    RRI_UART:   RRI port map(
                            data_in=> RX, 
                            data_out=> dataToRR
                            );

    --------------------------------- Chip enable BASE,RW,RR
    if (ce='1') then 
        ce_rw   <= '1' when address= 0x4 else '0';
        ce_base <= '1' when address= 0x0 else '0';
        ce_rr   <= '1' when address= 0xF else '0';
    end if;

    ---------------------------------Data recebe valores quando for uma leitura
    data <= data_OutBase    when (ce_base= '1' and ce='1') else
            data_outRR      when (ce_rr ='1'   and ce='1') else
                others('ZZZZZZZZ');

    -- IF rw = 0 then 
    --     data <= data_outBase or data_outRR;
    -- end if;

end UART;



------------------------	RW
entity RW is
	port(
        ce: in std_logic;
        request: out std_logic;
        ok2send: in std_logic;
		data_in: in std_logic_vector(7 downto 0);
		data_out: out std_logic_vector(7 downto 0)
	);
end RW;

architecture RW of RW is
signal data: std_logic_vector(7 downto 0);
	begin
        if ce ='1' then
            data <= data_in;
            request <= '1';
        end if;

end RW;


------------------------	RWO
entity RWO is
	port(
        clock, reset : in std_logic;
        data_incoming: in std_logic;
		data_in: in std_logic_vector(7 downto 0);
        data_out: out std_logic;
        busy: out std_logic
	);
end RWO;

architecture RWO of RWO is
type states_tx is (idle, startbit, d0, d1, d2, d3, d4, d5, d6, d7, endbit0, endbit1);
signal state states_tx;
    begin
        comb_part: process (reset, EA)	
            begin
                case state is
                    when idle =>
                        if reset='1' then 
                            state <= idle;
                            busy <= '0';
                            data_out <= '0';
                        elsif data_incoming ='1'then 
                            EA<= startbit;
                            busy<='1';
                            data_out <='1';	
                        end if;
                    when d0 =>
                        data_out <= data_in(0);
                        state <= d1
                    when d1 =>
                        data_out <= data_in(0);
                        state <= d2
                    when d2 =>
                        data_out <= data_in(0);
                        state <= d3





                    when S2 =>
                    PE<=S3;
                    hab_read_word<='1' ;
                    reset_count<='1';
                    busy<='1';
                    line<='0';
                    
                    when S3 =>
                    if count=7 then PE<=S1;
                    else PE<=S3; 
                        hab_count<='1';
                    end if;
                    busy<='1'	  ;
                    line<=pint(count);
                    
                    when others =>
                        null;
   end case;
   -- example
end process;

end RWO;


------------------------	BASE
entity BASE is
	port(
        ce: in std_logic;
        data_in: in std_logic_vector(7 downto 0);
        data_out: out std_logic_vector(7 downto 0)
	);
end BASE;

architecture BASE of BASE is

	begin

end BASE;


------------------------	RR
entity RR is
	port(
        ce: in std_logic;
        data_in: in std_logic_vector(7 downto 0);
        data_out: out std_logic_vector(7 downto 0)
	);
end RR;

architecture RR of RR is

	begin

end RR;


------------------------	RRI
entity RRI is
	port(
        ce: in std_logic;
        data_in: in std_logic;
        data_out: out std_logic_vector(7 downto 0)
	);
end RRI;

architecture RRI of RRI is

	begin

end RRI;