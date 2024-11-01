#include <stdio.h>
#include <stdint.h>
#include "system.h"
#include "alt_types.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_spi.h"
#include "altera_avalon_uart_regs.h"
#include "sys/alt_irq.h"
#include "sys/alt_stdio.h"
#include "sys/alt_alarm.h"

// Definições de hardware
#define MAX_SAMPLES 1024  // Número máximo de amostras
#define SW_BASE PIO_0_BASE  // Base address dos switches
#define BUTTON_BASE PIO_1_BASE  // Base address dos botões (assumindo que você tem um PIO para botões)

// Protótipos de funções
void init_uart(void);
void init_timer(void);
void timer_isr(void *context, alt_u32 id);
int16_t read_adc(void);
void send_samples(int16_t *samples, int num_samples);
void wait_for_button_press(void);

// Variáveis globais
volatile int timer_flag = 0;
alt_alarm timer;
int sample_interval_ms = 1;  // Intervalo de amostragem em milissegundos (ajuste conforme necessário)

int main(void) {
    int16_t samples[MAX_SAMPLES];
    int num_samples = 0;
    uint32_t switches = 0;

    // Inicializações
    init_uart();
    init_timer();

    while (1) {
        // Ler o número de amostras das chaves SW0-SW9
        switches = IORD_ALTERA_AVALON_PIO_DATA(SW_BASE);
        num_samples = switches & 0x3FF;  // Considerando 10 bits (SW0-SW9)
        if (num_samples == 0 || num_samples > MAX_SAMPLES) {
            num_samples = MAX_SAMPLES;
        }

        // Esperar pelo pressionamento do botão
        wait_for_button_press();

        // Capturar as amostras
        for (int i = 0; i < num_samples; i++) {
            samples[i] = read_adc();
            // Esperar pelo próximo intervalo de amostragem
            while (!timer_flag);
            timer_flag = 0;
        }

        // Enviar as amostras pela UART
        send_samples(samples, num_samples);
    }

    return 0;
}

// Inicialização da UART (se necessário)
void init_uart(void) {
    // Se estiver usando funções padrão como printf, a UART é inicializada automaticamente
    // Certifique-se de que o STDOUT está direcionado para a UART no BSP Editor
}

// Inicialização do timer
void init_timer(void) {
    // Configurar o timer para gerar interrupções a cada sample_interval_ms milissegundos
    alt_alarm_start(&timer, sample_interval_ms, timer_isr, NULL);
}

// Função de callback do timer
alt_u32 timer_isr(void *context) {
    timer_flag = 1;
    // Retornar o período para reiniciar o timer
    return sample_interval_ms;
}

// Função para ler dados do ADC via SPI
int16_t read_adc(void) {
    uint8_t tx_buffer[3];
    uint8_t rx_buffer[3];
    uint16_t adc_value = 0;

    // Comando para ler do ADC (configuração específica depende do ADC)
    tx_buffer[0] = 0x06;  // Start bit + Single-ended bit (ajuste conforme necessário)
    tx_buffer[1] = 0x00;
    tx_buffer[2] = 0x00;

    // Transação SPI
    alt_avalon_spi_command(SPI_0_BASE, 0, 3, tx_buffer, 3, rx_buffer, 0);

    // Processar os dados recebidos (depende do protocolo do ADC)
    adc_value = ((rx_buffer[1] & 0x0F) << 8) | rx_buffer[2];

    // Converter para int16_t se necessário
    return (int16_t)adc_value;
}

// Função para enviar as amostras pela UART
void send_samples(int16_t *samples, int num_samples) {
    for (int i = 0; i < num_samples; i++) {
        printf("%d", samples[i]);
        if (i < num_samples - 1) {
            printf(",");  // Separador de vírgula
        }
    }
    printf("\n");  // Nova linha após o envio das amostras
}

// Função para esperar pelo pressionamento do botão
void wait_for_button_press(void) {
    // Assumindo botão ativo em nível baixo (0)
    while ((IORD_ALTERA_AVALON_PIO_DATA(BUTTON_BASE) & 0x01) != 0) {
        // Espera até o botão ser pressionado
    }
    // Debounce simples
    while ((IORD_ALTERA_AVALON_PIO_DATA(BUTTON_BASE) & 0x01) == 0) {
        // Espera até o botão ser solto
    }
}