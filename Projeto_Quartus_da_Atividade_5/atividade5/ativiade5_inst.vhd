	component ativiade5 is
		port (
			clk_clk                            : in  std_logic                    := 'X';             -- clk
			pio_0_external_connection_export   : in  std_logic_vector(9 downto 0) := (others => 'X'); -- export
			reset_controller_0_reset_in0_reset : in  std_logic                    := 'X';             -- reset
			spi_0_external_MISO                : in  std_logic                    := 'X';             -- MISO
			spi_0_external_MOSI                : out std_logic;                                       -- MOSI
			spi_0_external_SCLK                : out std_logic;                                       -- SCLK
			spi_0_external_SS_n                : out std_logic                                        -- SS_n
		);
	end component ativiade5;

	u0 : component ativiade5
		port map (
			clk_clk                            => CONNECTED_TO_clk_clk,                            --                          clk.clk
			pio_0_external_connection_export   => CONNECTED_TO_pio_0_external_connection_export,   --    pio_0_external_connection.export
			reset_controller_0_reset_in0_reset => CONNECTED_TO_reset_controller_0_reset_in0_reset, -- reset_controller_0_reset_in0.reset
			spi_0_external_MISO                => CONNECTED_TO_spi_0_external_MISO,                --               spi_0_external.MISO
			spi_0_external_MOSI                => CONNECTED_TO_spi_0_external_MOSI,                --                             .MOSI
			spi_0_external_SCLK                => CONNECTED_TO_spi_0_external_SCLK,                --                             .SCLK
			spi_0_external_SS_n                => CONNECTED_TO_spi_0_external_SS_n                 --                             .SS_n
		);

