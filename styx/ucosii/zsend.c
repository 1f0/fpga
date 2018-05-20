#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <termios.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* baudrate settings are defined in <asm/termbits.h>, which is
included by <termios.h> */
#define BAUDRATE B9600           
/* change this definition for the correct port */
#define MODEMDEVICE "/dev/ttyUSB0"
#define _POSIX_SOURCE 1 /* POSIX compliant source */

#define FALSE 0
#define TRUE 1

void main(int argc, char ** argv)
{
  int err = 0;
  int fd,c, res;
  struct termios oldtio,newtio;
  char buf[255];
/* 
  Open modem device for reading and writing and not as controlling tty
  because we don't want to get killed if linenoise sends CTRL-C.
*/
 fd = open(MODEMDEVICE, O_RDWR | O_NOCTTY ); 
 if (fd <0) {perror(MODEMDEVICE); exit(-1); }

 tcgetattr(fd,&oldtio); /* save current serial port settings */
 bzero(&newtio, sizeof(newtio)); /* clear struct for new port settings */

/* 
  BAUDRATE: Set bps rate. You could also use cfsetispeed and cfsetospeed.
  CRTSCTS : output hardware flow control (only used if the cable has
            all necessary lines. See sect. 7 of Serial-HOWTO)
  CS8     : 8n1 (8bit,no parity,1 stopbit)
  CLOCAL  : local connection, no modem contol
  CREAD   : enable receiving characters
*/
 newtio.c_cflag = BAUDRATE | CS8 | CLOCAL | CREAD;//| CRTSCTS
 
/*
  IGNPAR  : ignore bytes with parity errors
  ICRNL   : map CR to NL (otherwise a CR input on the other computer
            will not terminate input)
  otherwise make device raw (no other input processing)
*/
 newtio.c_iflag = IGNPAR; //| ICRNL;
 
/*
 Raw output.
*/
 newtio.c_oflag = 0;
 
/*
  ICANON  : enable canonical input
  disable all echo functionality, and don't send signals to calling program
*/
// newtio.c_lflag = ICANON;

/* 
  now clean the modem line and activate the settings for the port
*/
 tcflush(fd, TCIFLUSH);
 tcsetattr(fd,TCSANOW,&newtio);

 FILE* fp;
 if(argc<2) fp = fopen("inst_rom.bin","rb");
 else fp = fopen(argv[1],"rb");

 if(!fp){
    printf("Cannot open file\n");
	return 1;
 }
 
 int i=0;

 printf(">> Start Trans\n");

 while (!feof(fp)) {
    i++;
    fread(buf,4,1,fp);
    if(!feof(fp)){
      res = write(fd,buf,4);
      if(res!=4)err++;
      printf("%d: %d, ",i,res);
      if(i%5==4)printf("\n");
      usleep(100);
    }
 }
 for(i=0;i<4;i++)
   buf[i]=-1;
 res = write(fd,buf,4);
 printf("\n<< Send FF*4\n");
 printf("Err: %d\n",err);
 printf("Goto: 0x0\n=====\n");

 int rec;

 while(1){
 	rec = read(fd,buf,1);
 	if(rec>0) printf("%c",buf[0]);
 }

 
 /* restore the old port settings */
 tcsetattr(fd,TCSANOW,&oldtio);
 
}
