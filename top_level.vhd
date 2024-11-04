library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level is
    port (
        -- Sinais do ADC
        ADC_CONVST : out std_logic;
        ADC_DIN    : out std_logic;
        ADC_DOUT   : in  std_logic;
        ADC_SCLK   : out std_logic;

        -- Clock e Reset
        CLOCK_50   : in  std_logic;
        KEY        : in  std_logic_vector(3 downto 0); -- Botões, ativos em nível baixo
        SW         : in  std_logic_vector(9 downto 0); -- Chaves

        -- Conexões Ethernet
--        HPS_ENET_TX_DATA     : out std_logic_vector(3 downto 0);
--        HPS_ENET_TX_EN       : out std_logic;
--        HPS_ENET_RX_DATA     : in  std_logic_vector(3 downto 0);
--        HPS_ENET_RX_CLK      : in  std_logic;
--        HPS_ENET_RX_DV       : in  std_logic;
--        HPS_ENET_MDIO        : inout std_logic;
--        HPS_ENET_MDC         : out std_logic;
--        HPS_ENET_INT_N       : in  std_logic;
--        HPS_ENET_GTX_CLK     : out std_logic;
--        HPS_ENET_RESET_N     : out std_logic;
        
        -- Outros sinais do HPS, caso necessários
        -- Sinais do HPS para controle de GPIO, UART, SD, etc.
        -- Adicione conforme necessário...
        
        -- Reset
        reset_n              : in std_logic
    );
end entity top_level;

architecture rtl of top_level is

    -- Sinais intermediários para conexão com a entidade ativiade5
    signal reset_in   : std_logic;
    signal start_in   : std_logic;
    signal ss_n       : std_logic;
    signal start_flag : std_logic := '0';

begin

    -- Inverte o sinal do botão KEY[0] para gerar um reset ativo em alto
    reset_in <= not KEY(0);

    -- Usa o botão KEY[1] como sinal de início da captura
    start_in <= not KEY(1);

    -- Detecção de borda do botão de início para iniciar a captura
    process(CLOCK_50)
    begin
        if rising_edge(CLOCK_50) then
            if start_in = '1' and start_flag = '0' then
                -- Configura o sinal start_flag para iniciar a captura
                start_flag <= '1';
            elsif reset_in = '1' then
                -- Reseta o sinal start_flag quando o botão de reset é pressionado
                start_flag <= '0';
            end if;
        end if;
    end process;

    -- Instancia a entidade ativiade5 com start_flag como controle de captura
    u0 : entity work.ativiade5
        port map (
            clk_clk                            => CLOCK_50,
            reset_controller_0_reset_in0_reset => reset_in,
            pio_0_external_connection_export   => SW,
            pio_1_external_connection_export   => start_flag,
            spi_0_external_MISO                => ADC_DOUT,
            spi_0_external_MOSI                => ADC_DIN,
            spi_0_external_SCLK                => ADC_SCLK,
            spi_0_external_SS_n                => ss_n

            -- Conexões Ethernet TSE
--            eth_tse_0_mac_gmii_connection_gmii_rx_d     => HPS_ENET_RX_DATA,
--            eth_tse_0_mac_gmii_connection_gmii_rx_dv    => HPS_ENET_RX_DV,
--            eth_tse_0_mac_gmii_connection_gmii_rx_err   => '0', -- Ajuste conforme necessário
--            eth_tse_0_mac_gmii_connection_gmii_tx_d     => HPS_ENET_TX_DATA,
--            eth_tse_0_mac_gmii_connection_gmii_tx_en    => HPS_ENET_TX_EN,
--            eth_tse_0_mac_gmii_connection_gmii_tx_err   => open, -- Ajuste conforme necessário
--            eth_tse_0_mac_mii_connection_mii_rx_d       => HPS_ENET_RX_DATA(3 downto 0),
--            eth_tse_0_mac_mii_connection_mii_rx_dv      => HPS_ENET_RX_DV,
--            eth_tse_0_mac_mii_connection_mii_rx_err     => '0', -- Ajuste conforme necessário
--            eth_tse_0_mac_mii_connection_mii_tx_d       => HPS_ENET_TX_DATA(3 downto 0),
--            eth_tse_0_mac_mii_connection_mii_tx_en      => HPS_ENET_TX_EN,
--            eth_tse_0_mac_mii_connection_mii_tx_err     => open, -- Ajuste conforme necessário
--            eth_tse_0_mac_misc_connection_magic_wakeup  => open,
--            eth_tse_0_mac_misc_connection_magic_sleep_n => '1',
--            eth_tse_0_mac_misc_connection_ff_tx_crc_fwd => '1',
--            eth_tse_0_mac_misc_connection_ff_tx_septy   => open,
--            eth_tse_0_mac_misc_connection_tx_ff_uflow   => open,
--            eth_tse_0_mac_misc_connection_ff_tx_a_full  => open,
--            eth_tse_0_mac_misc_connection_ff_tx_a_empty => open,
--            eth_tse_0_mac_misc_connection_rx_err_stat   => open,
--            eth_tse_0_mac_misc_connection_rx_frm_type   => open,
--            eth_tse_0_mac_misc_connection_ff_rx_dsav    => open,
--            eth_tse_0_mac_misc_connection_ff_rx_a_full  => open,
--            eth_tse_0_mac_misc_connection_ff_rx_a_empty => open,
--            eth_tse_0_mac_status_connection_set_10      => '0',
--            eth_tse_0_mac_status_connection_set_1000    => '0',
--            eth_tse_0_mac_status_connection_eth_mode    => open,
--            eth_tse_0_mac_status_connection_ena_10      => open
        );

    -- Inverte o sinal ss_n para obter o ADC_CONVST
    ADC_CONVST <= ss_n;

end architecture rtl;
