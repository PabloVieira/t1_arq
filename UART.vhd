
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity RW is
	port(
			ce, clk, rst     :   in std_logic;
			ok2send         :   in std_logic;
			request         :   out std_logic;
			done2sys				: 	out std_logic;
			ackSys			:	in std_logic;
			data_in         :   in std_logic_vector(7 downto 0);
			data_out        :   out std_logic_vector(7 downto 0)
		);
end RW;--
architecture main of RW is
	signal data: std_logic_vector(7 downto 0) := X"00" ;
	signal busy: std_logic := '0';
begin
	process(clk,rst)
	begin
		if(rst ='1') then
			data <= X"00";
			request <= '0';
			busy <='0';
		elsif clk'event and clk ='1' then
			if ce='1' and busy ='0' then 
				request <= '1';
				busy <='1';
				data <= data_in;
			end if;
			if ok2send ='1' and busy='1' then 
				data_out <= data;
				request <='0';
            	busy <= '0';
			end if;
		end if;

	end process;
	done2sys <= '0' when ackSys ='1' else '1' when ok2send ='1' AND busy ='1';
end architecture main;


--=======================================		Register Write Output
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity RWO is 
    port(
        clk, rst          : in std_logic;
        data_incoming       : in std_logic;
		  data_in             : in std_logic_vector(7 downto 0);
        data_out            : out std_logic;
        busy                : out std_logic
    );
end RWO;

architecture main of RWO is
    type states_tx is   (
                        idle,
                        startbit,
                        d0,
                        d1, 
                        d2, 
                        d3, 
                        d4, 
                        d5, 
                        d6, 
                        d7,
                        endbit0, 
                        endbit1
        );
    signal state        : states_tx;
    signal data         : std_logic_vector(7 downto 0) := X"00";
begin
    process (clk, rst)
	begin
		if rst = '1' then
			state <= idle;
			busy <= '0';
		elsif (rising_edge(clk)) then
			case state is
				when idle =>
                    if data_incoming = '1'  then
                        data_out <='0';
                        state <= startbit;
                        busy <='1';
                    elsif data_incoming ='0' then
                        data_out <= '0';
								state <= idle;
						  end if;
				when startbit=>
                    if data_incoming = '0' then
                        data<=data_in;
                        busy<='0';
                        data_out<='1';
								state <= d0;
						  else
								state <= startbit;
						  end if;
				when d0 =>
                    data_out <= data(0);
                    state <= d1;
				when d1 =>
                    data_out <= data(1);
                    state <= d2;
            when d2=>
                    data_out <= data(2);
                    state <= d3;
            when d3=>
                    data_out <= data(3);
                    state <= d4;
            when d4=>
                    data_out <= data(4);
                    state <= d5;
            when d5=>
                    data_out <= data(5);
                    state <= d6;
            when d6=>
                    data_out <= data(6);
                    state <= d7;
            when d7=>
                    data_out <= data(7);
                    state <= endbit0;
            when endbit0 =>
                    data_out<= '1';
                    state <= endbit1;
            when endbit1 =>
                    data_out<='1';
                    state <= idle;
            end case;
		end if;
	end process;
end architecture main ; 



--=======================================		Register Read
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity rr is
    port(
        clk,rst: in std_logic;
        data_incoming: in std_logic;
        ack: in std_logic;
        data_in: in std_logic_vector(7 downto 0);
        done: out std_logic;
        data_out: out std_logic_vector(7 downto 0)
    );
end rr;

architecture main of rr is
    signal data: std_logic_vector(7 downto 0);
    signal busy: std_logic := '0';
begin
    process(clk,rst)
    begin
        if rst='1' then 
            data_out <= X"00";
            done <= '0';
            busy <='0';
        end if;
        if data_incoming ='1' and busy = '0' then 
            data <= data_in;
            done <= '1';
            busy <= '1';
        end if;
        if busy='1' then
            data_out <= data;
        end if;
        if ack ='1' then
            done <='0';
            busy <='0';
            data_out <= X"00";
        end if ;
    end process;
end architecture main;




--=======================================		Register Read Input
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity rri is
    port(
        clk, rst: in std_logic;
        done2RR: out std_logic;

        data_in: in std_logic;
        data_out: out std_logic_vector(7 downto 0)
    );
end rri;

architecture main of rri is
    type states_rx is   (
                        idle,
                        d0,
                        d1, 
                        d2, 
                        d3, 
                        d4, 
                        d5, 
                        d6, 
                        d7,
                        endbit0, 
                        endbit1
        );
    signal state        : states_rx;
    signal data         : std_logic_vector(7 downto 0) := X"00";
	
begin
    process (clk, rst)
	begin
		if rst = '1' then
			state <= idle;
		elsif (rising_edge(clk)) then
			case state is
				when idle=>
                    if data_in = '1' then
                        done2RR <= '0';
						state <= d0;
					else
						state <= idle;
                    end if;                    
                when d0=>
                    data(0)<= data_in;
                    state <= d1;
                   
                when d1=>
                    data(1)<= data_in;
                    state <= d2;
                when d2=>
                    data(2)<= data_in;
                    state <= d3;    
                when d3=>
                    data(3)<= data_in;
                    state <= d4;    
                when d4=>
                    data(4)<= data_in;
                    state <= d5;    
                when d5=>
                    data(5)<= data_in;
                    state <= d6;    
                when d6=>
                    data(6)<= data_in;
                    state <= d7;    
                when d7=>
                    data(7)<= data_in;
                    state <= endbit0;        
				when endbit0=>
					if data_in = '1' then
                        state <= endbit1;
                        data_out <= data;
                        done2RR <= '1';
					else
						state <= endbit0; --aqui poderia ter um erro
                    end if;
				when endbit1 =>
					if data_in = '1' then
						state <= idle;
					else
						state <= endbit1;
					end if;
			end case;
		end if;
	end process;
end main;


--=======================================		UART
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity uart is
	port(
		-----------------------------Clock e Reset
		clk, rst: in std_logic;

		------------------------------Confirmação[Sys->UART], Escrita/Leitura, Chip Enable 
		ack, rw, ce: in std_logic; 

		-----------------------------Confirmação[UART->Sys]
		done: out std_logic;

		-----------------------------Bits de transferência serial
		RX: in std_logic;
		TX: out std_logic;

		-----------------------------Endereço de acesso
		add: in std_logic_vector(3 downto 0);

		-----------------------------Dados
		data: inout std_logic_vector(7 downto 0)
	);
end entity uart;

architecture main of uart is
	signal ce_rr, ce_rw, ce_base: std_logic;
	signal RW_done: std_logic; -- bit de controle para RR 
	signal ce_base_setup: std_logic;
	signal done2RR_signal: std_logic;
	signal data2RR: std_logic_vector(7 downto 0);
	signal RR_done: std_logic;
	signal reg_base: std_logic_vector(7 downto 0);
	signal dataToRWO: std_logic_vector(7 downto 0);
	signal rwo_busy: std_logic;
	signal data_outRR: std_logic_vector(7 downto 0);
	signal requestToRWO: std_logic;
	
begin
	
	reg_base <= X"00" when RW_done='1' else
				X"01" when RR_done='1' else
				X"FF";

	ce_base_setup <= '1' when RW_done='1' OR RR_done='1' else '0';
	done <= ce_base_setup;

	RW_UART:    entity work.RW port map(
							clk=> clk,
							rst=> rst,
                            ce=> ce_rw,
                            data_in=> data,
                            data_out=> dataToRWO, 
                            request =>requestToRWO, 
                            ok2send=> rwo_busy,
							done2Sys => RW_done,
							acksys =>ack 
                            );

    RWO_UART:   entity work.RWO port map(
							clk=> clk,
							rst=> rst,
                            data_in=> dataToRWO, 
                            data_out=> TX, 
                            data_incoming=> requestToRWO, 
                            busy=> rwo_busy
                            );

    RR_UART:    entity work.RR port map(
							clk=> clk,
							rst=> rst,
							data_incoming=> done2RR_signal, 
							done=>RR_done,
							ack=>ack,
                            data_in=> data2RR, 
                            data_out => data_outRR 
                            );

    RRI_UART:   entity work.RRI port map(
							clk=> clk,
							rst=> rst,
							done2RR=> done2RR_signal,
                            data_in=> RX, 
                            data_out=> data2RR
                            );

	
	data <= data_outRR when ce_rr ='1' else reg_base when ce_base='1' else "ZZZZZZZZ";
	ce_rw <= '1' when ((add="0100") and (rw ='1') and (ce='1')) else '0';
	ce_rr <= '1' when (add="1000") and (rw ='0') and (ce='1') else '0';
	ce_base <= '1' when (add="0000") and (ce='1') else '0';

end architecture main;



--=======================================		Register Write