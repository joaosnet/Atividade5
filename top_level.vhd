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
        SW         : in  std_logic_vector(9 downto 0)  -- Chaves
    );
end entity top_level;

architecture rtl of top_level is

    -- Sinais intermediários para conexão com a entidade atividade5
    signal reset_in : std_logic;
    signal ss_n     : std_logic;
    
begin

    -- Inverte o sinal do botão KEY[0] para gerar um reset ativo em alto
    reset_in <= not KEY(0);

    -- Instancia a entidade atividade5
    u0 : entity work.ativiade5
        port map (
            clk_clk                            => CLOCK_50,
            reset_controller_0_reset_in0_reset => reset_in,
            pio_0_external_connection_export   => SW,
            spi_0_external_MISO                => ADC_DOUT,
            spi_0_external_MOSI                => ADC_DIN,
            spi_0_external_SCLK                => ADC_SCLK,
            spi_0_external_SS_n                => ss_n
        );

    -- Inverte o sinal ss_n para obter o ADC_CONVST
    ADC_CONVST <= not ss_n;

end architecture rtl;
