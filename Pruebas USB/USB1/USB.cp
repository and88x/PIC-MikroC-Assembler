#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/EjemplosMios/USB1/USB.c"
unsigned char readbuff[64] absolute 0x500;
unsigned char writebuff[64] absolute 0x540;

char cnt;
char kk;

void interrupt(){
 USB_Interrupt_Proc();
}

void main(void){
 ADCON1 |= 0x0F;
 CMCON |= 7;

 HID_Enable(&readbuff,&writebuff);

 while(1){
 while(!HID_Read())
 ;

 for(cnt=0;cnt<64;cnt++)
 writebuff[cnt]=readbuff[cnt];

 while(!HID_Write(&writebuff,64))
 ;
 }
}
