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

#define MAX_SAMPLES 1024
#define SW_BASE PIO_0_BASE
#define BUTTON_BASE PIO_1_BASE

// Estrutura para armazenar amostra e timestamp
typedef struct {
    int16_t value;
    alt_u32 timestamp;
} sample_t;

// Protótipos
void init_timer(void);
void timer_isr(void *context, alt_u32 id);
int16_t read_adc(void);
void send_samples(sample_t *samples, int num_samples);
void wait_for_button_press(void);

// Variáveis globais
volatile int timer_flag = 0;
alt_alarm timer;
int sample_interval_ms = 1;
alt_u32 start_time = 0;

int main(void) {
    sample_t samples[MAX_SAMPLES];
    int num_samples = 0;
    uint32_t switches = 0;

    printf("Sistema de Aquisição Iniciado\n");
    init_uart();
    init_timer();

    while (1) {
        // Leitura do número de amostras das chaves
        switches = IORD_ALTERA_AVALON_PIO_DATA(SW_BASE);
        num_samples = switches & 0x3FF;
        if (num_samples == 0 || num_samples > MAX_SAMPLES) {
            num_samples = MAX_SAMPLES;
        }

        printf("Aguardando botão. Número de amostras: %d\n", num_samples);
        wait_for_button_press();
        printf("Iniciando aquisição...\n");

        // Marca o tempo inicial
        start_time = alt_nticks();

        // Captura das amostras com timestamp
        for (int i = 0; i < num_samples; i++) {
            while (!timer_flag); // Aguarda o próximo período
            timer_flag = 0;
            
            samples[i].value = read_adc();
            samples[i].timestamp = alt_nticks() - start_time;
        }

        printf("Enviando dados...\n");
        send_samples(samples, num_samples);
        printf("Aquisição completa\n\n");
    }

    return 0;
}

void init_timer(void) {
    alt_alarm_start(&timer, sample_interval_ms, timer_isr, NULL);
}

alt_u32 timer_isr(void *context) {
    timer_flag = 1;
    return sample_interval_ms;
}

int16_t read_adc(void) {
    uint8_t tx_buffer[3] = {0};
    uint8_t rx_buffer[3] = {0};
    
    // Configuração específica para o ADC LTC2308
    tx_buffer[0] = 0x86;  // Single-ended, canal 0
    
    // Realiza a transação SPI
    alt_avalon_spi_command(SPI_0_BASE, 0, 3, tx_buffer, 3, rx_buffer, 0);
    
    // Processa os dados (12 bits)
    uint16_t adc_value = ((rx_buffer[1] & 0x0F) << 8) | rx_buffer[2];
    
    return (int16_t)adc_value;
}

void send_samples(sample_t *samples, int num_samples) {
    for (int i = 0; i < num_samples; i++) {
        printf("%d,%lu", samples[i].value, samples[i].timestamp);
        if (i < num_samples - 1) {
            printf(";");
        }
    }
    printf("\n");
}

void wait_for_button_press(void) {
    while ((IORD_ALTERA_AVALON_PIO_DATA(BUTTON_BASE) & 0x01) != 0);
    alt_u32 debounce_delay = alt_ticks_per_second() / 10; // 100ms debounce
    alt_u32 press_time = alt_nticks();
    while (alt_nticks() - press_time < debounce_delay);
}
