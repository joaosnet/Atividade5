#include "system.h"
#include "alt_types.h"
#include "altera_avalon_spi.h"
#include "sys/alt_irq.h"          // Inclui interrupções
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_timer_regs.h"
#include <stdint.h>
#include <stdio.h>

#define CLOCK_FREQ 50000000        // Frequência do clock em Hz (50MHz)
#define SAMPLE_PERIOD_MS 1000      // Período de amostragem em ms
#define TICKS_PER_SAMPLE (CLOCK_FREQ / 1000 * SAMPLE_PERIOD_MS)

static volatile char flag_amostra;  // Flag de amostragem
static volatile uint32_t contador_ms = 0;  // Contador para timestamp em ms

// Função de interrupção do timer
void timer_isr(void* context, alt_u32 id) {
    IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_0_BASE, 0); // Limpa a interrupção
    flag_amostra = 1;
    contador_ms += SAMPLE_PERIOD_MS;  // Incrementa o contador em ms
}

// Função para ler valor do ADC via SPI
static alt_16 le_adc(void) {
    static uint8_t cmd[3] = {0x86}, resultado[3];
    alt_avalon_spi_command(SPI_0_BASE, 0, 3, cmd, 3, resultado, 0);
    return ((resultado[1] & 0x0F) << 8) | resultado[2];
}

// Função para aguardar pressionamento do botão com debounce
static void aguarda_botao(void) {
    while (IORD_ALTERA_AVALON_PIO_DATA(PIO_1_BASE) & 0x1);
    for (volatile int i = 0; i < 100000; i++);
}

// Função principal
int main(void) {
    printf("Iniciando sistema de aquisição de amostras...\n");
    fflush(stdout);

    // Configura o timer para gerar interrupções a cada TICKS_PER_SAMPLE
    IOWR_ALTERA_AVALON_TIMER_PERIODL(TIMER_0_BASE, TICKS_PER_SAMPLE & 0xFFFF);
    IOWR_ALTERA_AVALON_TIMER_PERIODH(TIMER_0_BASE, TICKS_PER_SAMPLE >> 16);
    IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_0_BASE, ALTERA_AVALON_TIMER_CONTROL_ITO_MSK | ALTERA_AVALON_TIMER_CONTROL_CONT_MSK | ALTERA_AVALON_TIMER_CONTROL_START_MSK);

    // Registra a interrupção do timer
    alt_ic_isr_register(TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID, TIMER_0_IRQ, timer_isr, NULL, NULL);

    while (1) {
        // Configura o número de amostras com base nos switches
        uint16_t N = IORD_ALTERA_AVALON_PIO_DATA(PIO_0_BASE) & 0x3FF; // Leitura de SW[0 a 9]
        if (N == 0) N = 1; // Garante pelo menos 1 amostra se N for zero

        printf("Numero de amostras configurado: %d\n", N);
        fflush(stdout);

        printf("Aguardando pressionamento do botão para iniciar...\n");
        fflush(stdout);
        aguarda_botao();

        // Inicializa o contador de timestamp
        contador_ms = 0;
        flag_amostra = 0;

        // Loop de aquisição de amostras
        for (uint16_t i = 0; i < N; i++) {
            while (!flag_amostra);     // Espera a flag de amostra ser acionada
            flag_amostra = 0;

            // Captura o valor do ADC e o timestamp
            alt_16 valor_adc = le_adc();
            uint32_t timestamp = contador_ms;

            // Imprime a amostra no formato solicitado
            printf("%d : %u ms", valor_adc, timestamp);
            if (i < N - 1) {
                printf(", ");
            } else {
                printf("\n");
            }
            fflush(stdout);
        }

        printf("Aquisicao concluida!\n");
        fflush(stdout);
    }
    return 0;
}
