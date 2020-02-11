#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/EjemplosMios/USB CDC/VCP_Example.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/stdint.h"




typedef signed char int8_t;
typedef signed int int16_t;
typedef signed long int int32_t;


typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
typedef unsigned long int uint32_t;


typedef signed char int_least8_t;
typedef signed int int_least16_t;
typedef signed long int int_least32_t;


typedef unsigned char uint_least8_t;
typedef unsigned int uint_least16_t;
typedef unsigned long int uint_least32_t;



typedef signed char int_fast8_t;
typedef signed int int_fast16_t;
typedef signed long int int_fast32_t;


typedef unsigned char uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned long int uint_fast32_t;


typedef signed int intptr_t;
typedef unsigned int uintptr_t;


typedef signed long int intmax_t;
typedef unsigned long int uintmax_t;
#line 25 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/EjemplosMios/USB CDC/VCP_Example.c"
char buffer[64] absolute 0x500;


void interrupt(){

 USBDev_IntHandler();
}

void USBDev_CDCParamsChanged(){

}

extern const uint8_t _USB_CDC_BULK_EP_IN;
extern const uint8_t _USB_CDC_BULK_EP_OUT;
uint8_t dataReceived = 0;
uint16_t dataReceivedSize;

void USBDev_CDCDataReceived(uint16_t size){
 dataReceived = 1;
 dataReceivedSize = size;
}

void main(void){
 ADCON1 |= 0x0F;
 CMCON |= 7;


 USBDev_CDCInit();


 USBDev_Init();


 IPEN_bit = 1;
 USBIP_bit = 1;
 USBIE_bit = 1;
 GIEH_bit = 1;


 while(1){

 if(USB_CDC_DeviceConfigured){

 USBDev_CDCSetReceiveBuffer(buffer);


 USB_CDC_DeviceConfigured = 0;
 }

 if(dataReceived == 1){
 dataReceived = 0;

 USBDev_CDCSendData(buffer, dataReceivedSize);

 USBDev_CDCSetReceiveBuffer(buffer);
 }
 }

}
