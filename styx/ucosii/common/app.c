#include "includes.h"

#define BOTH_EMPTY (UART_LS_TEMT | UART_LS_THRE)

#define WAIT_FOR_XMITR \
        do { \
                lsr = REG8(UART_BASE + UART_LS_REG); \
        } while ((lsr & BOTH_EMPTY) != BOTH_EMPTY)

#define WAIT_FOR_THRE \
        do { \
                lsr = REG8(UART_BASE + UART_LS_REG); \
        } while ((lsr & UART_LS_THRE) != UART_LS_THRE)

#define TASK_STK_SIZE 256

void uart_init(void)
{
    INT32U divisor;

    /* Set baud rate */
    divisor = (INT32U) IN_CLK/(16 * UART_BAUD_RATE);

    REG8(UART_BASE + UART_LC_REG) = 0x80;
    REG8(UART_BASE + UART_DLB1_REG) = divisor & 0x000000ff;
    REG8(UART_BASE + UART_DLB2_REG) = (divisor >> 8) & 0x000000ff;
    REG8(UART_BASE + UART_LC_REG) = 0x00;
    
    /* Disable all interrupts */
    REG8(UART_BASE + UART_IE_REG) = 0x00;
    
    /* Set 8 bit char, 1 stop bit, no parity */
    REG8(UART_BASE + UART_LC_REG) = UART_LC_WLEN8 | (UART_LC_ONE_STOP | UART_LC_NO_PARITY);

    uart_print_str("UART initialize done ! \n");
	return;
}

void uart_putc(char c)
{
    unsigned char lsr;
    WAIT_FOR_THRE;
    REG8(UART_BASE + UART_TH_REG) = c;
    if(c == '\n') {
        WAIT_FOR_THRE;
        REG8(UART_BASE + UART_TH_REG) = '\r';
    }
    WAIT_FOR_XMITR;
}

void uart_print_str(char* str)
{
    INT32U i=0;
    OS_CPU_SR cpu_sr;
    OS_ENTER_CRITICAL()

    while(str[i]!=0){
	    uart_putc(str[i]);
        i++;
    }
    
    OS_EXIT_CRITICAL()
}

void OSInitTick(void)
{
    INT32U compare = (INT32U)(IN_CLK / OS_TICKS_PER_SEC);
    
    asm volatile("mtc0   %0,$9"   : :"r"(0x0)); 
    asm volatile("mtc0   %0,$11"   : :"r"(compare));  
    asm volatile("mtc0   %0,$12"   : :"r"(0x10000401));

    return; 
}

void  Task1(void *pdata)
{
    pdata = pdata;        /* Prevent compiler warning                 */
    OSInitTick();	      /* don't put this function in main()        */       
    for (;;) {
        uart_print_str("task1\n");
        OSTimeDly(200);   /* Wait 2000ms                              */
    }
}

void  Task2(void *pdata)
{
    pdata = pdata;            /* Prevent compiler warning                 */
    OSInitTick();	          /* don't put this function in main()        */       
    for (;;) {
        uart_print_str("task2\n");
        OSTimeDly(20);        /* Wait 20ms                                */
    }
}

OS_STK Task1Stk[TASK_STK_SIZE];
OS_STK Task2Stk[TASK_STK_SIZE];

void main()
{
    OSInit();
    uart_init();
    OSTaskCreate(Task1,(void *)0,&Task1Stk[TASK_STK_SIZE - 1],0);
    OSTaskCreate(Task2,(void *)0,&Task2Stk[TASK_STK_SIZE - 1],2);
    OSStart();
}
