#define REG8(add) *((volatile INT8U *)(add))
#define REG16(add) *((volatile INT16U *)(add))
#define REG32(add) *((volatile INT32U *)(add))

#define IN_CLK 25000000             /* 输入时钟是25MHz */

/**********************************************************************

                            串口相关参数、函数
                                 
**********************************************************************/                               

#define UART_BAUD_RATE  9600          /* 串口速率是9600bps */
#define UART_BASE      0x10000000
#define UART_LC_REG    0x00000003    /* Line Control Register */
#define UART_IE_REG     0x00000001    /* Interrupt Enable Register */
#define UART_TH_REG    0x00000000    /* Transmitter Holding Register */
#define UART_LS_REG     0x00000005    /* Line Status Register */
#define UART_DLB1_REG   0x00000000    /* Divisor Latch Byte 1(LSB) */
#define UART_DLB2_REG   0x00000001    /* Divisor Latch Byte 2(MSB) */

/* Line Status Register的标志位 */
#define UART_LS_TEMT	0x40	/* Transmitter empty */
#define UART_LS_THRE	0x20	/* Transmit-hold-register empty */

/* Line Control Register的标志位 */
#define UART_LC_NO_PARITY	0x00	/* Parity Disable */
#define UART_LC_ONE_STOP	0x00	/* Stop bits: 0x00表示one stop bit */
#define UART_LC_WLEN8  0x03	/* Wordlength: 8 bits */

extern void uart_init(void);
extern void uart_putc(char);
extern void uart_print_str(char*);
extern void uart_print_int(unsigned int);

extern void main(void);
