# Definindo os pinos sem definir a tensão globalmente
# Atribuindo padrões de tensão específicos para cada componente

# Configuração do display de sete segmentos (HEX0)
set_location_assignment PIN_AE26 -to HEX0[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[0]

set_location_assignment PIN_AF26 -to HEX0[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[1]

set_location_assignment PIN_AE27 -to HEX0[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[2]

set_location_assignment PIN_AF27 -to HEX0[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[3]

set_location_assignment PIN_AG26 -to HEX0[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[4]

set_location_assignment PIN_AH26 -to HEX0[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[5]

set_location_assignment PIN_AG27 -to HEX0[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[6]

# Configuração dos LEDs (LEDR)
set_location_assignment PIN_Y23 -to LEDR[0]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LEDR[0]

set_location_assignment PIN_W23 -to LEDR[1]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LEDR[1]

set_location_assignment PIN_V23 -to LEDR[2]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LEDR[2]

set_location_assignment PIN_U23 -to LEDR[3]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LEDR[3]

# Configuração do botão (KEY)
set_location_assignment PIN_AA14 -to KEY[0]
set_instance_assignment -name IO_STANDARD "1.8-V" -to KEY[0]

set_location_assignment PIN_AB14 -to KEY[1]
set_instance_assignment -name IO_STANDARD "1.8-V" -to KEY[1]

# Configuração do clock externo
set_location_assignment PIN_W19 -to clk_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clk_clk

# Configuração da SPI (pinos conectados à interface SPI externa)
set_location_assignment PIN_F21 -to spi_0_external_MISO
set_instance_assignment -name IO_STANDARD "2.5-V" -to spi_0_external_MISO

set_location_assignment PIN_G21 -to spi_0_external_MOSI
set_instance_assignment -name IO_STANDARD "2.5-V" -to spi_0_external_MOSI

set_location_assignment PIN_H21 -to spi_0_external_SCLK
set_instance_assignment -name IO_STANDARD "2.5-V" -to spi_0_external_SCLK

set_location_assignment PIN_J21 -to spi_0_external_SS_n
set_instance_assignment -name IO_STANDARD "2.5-V" -to spi_0_external_SS_n

# Configuração do Ethernet (pinos conectados à interface Ethernet TSE)
set_location_assignment PIN_B26 -to eth_tse_0_mac_gmii_connection_gmii_rx_d[0]
set_instance_assignment -name IO_STANDARD "2.5-V" -to eth_tse_0_mac_gmii_connection_gmii_rx_d[0]

set_location_assignment PIN_C26 -to eth_tse_0_mac_gmii_connection_gmii_rx_d[1]
set_instance_assignment -name IO_STANDARD "2.5-V" -to eth_tse_0_mac_gmii_connection_gmii_rx_d[1]

set_location_assignment PIN_D26 -to eth_tse_0_mac_gmii_connection_gmii_rx_d[2]
set_instance_assignment -name IO_STANDARD "2.5-V" -to eth_tse_0_mac_gmii_connection_gmii_rx_d[2]

set_location_assignment PIN_E26 -to eth_tse_0_mac_gmii_connection_gmii_rx_d[3]
set_instance_assignment -name IO_STANDARD "2.5-V" -to eth_tse_0_mac_gmii_connection_gmii_rx_d[3]

set_location_assignment PIN_F26 -to eth_tse_0_mac_gmii_connection_gmii_tx_d[0]
set_instance_assignment -name IO_STANDARD "2.5-V" -to eth_tse_0_mac_gmii_connection_gmii_tx_d[0]

set_location_assignment PIN_G26 -to eth_tse_0_mac_gmii_connection_gmii_tx_d[1]
set_instance_assignment -name IO_STANDARD "2.5-V" -to eth_tse_0_mac_gmii_connection_gmii_tx_d[1]

set_location_assignment PIN_H26 -to eth_tse_0_mac_gmii_connection_gmii_tx_d[2]
set_instance_assignment -name IO_STANDARD "2.5-V" -to eth_tse_0_mac_gmii_connection_gmii_tx_d[2]

set_location_assignment PIN_J26 -to eth_tse_0_mac_gmii_connection_gmii_tx_d[3]
set_instance_assignment -name IO_STANDARD "2.5-V" -to eth_tse_0_mac_gmii_connection_gmii_tx_d[3]

# Configuração do Reset
set_location_assignment PIN_M24 -to reset_controller_0_reset_in0_reset
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to reset_controller_0_reset_in0_reset
