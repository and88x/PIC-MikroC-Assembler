/*
 * Project name:
     Virtual COM Port Demo
 * Description
     Example showing usage USB CDC device that functions as a generic virtual 
     COM port. The example echoes data sent via USART terminal.
 * Test configuration:
     MCU:             P18F4550
     dev.board:       EasyPIC v7 Connectivity
                      http://www.mikroe.com/easypic/
     Oscillator:      HS-PLL, 48.000MHz
     Ext. Modules:    None.
     SW:              mikroC PRO for PIC
                      http://www.mikroe.com/mikroc/pic/
     Notes:           Example uses CDC Driver included in Windows. An .inf file
                      is supplied with the example in order to match the driver
                      with this device (user must guide driver installation 
                      wizard to the VCPDriver folder).

 */

#include <stdint.h>

// Buffer of 64 bytes
char buffer[64] absolute 0x500;

// USB interrupt service routine
void interrupt(){
  // Call library interrupt handler routine
  USBDev_IntHandler();
}

void USBDev_CDCParamsChanged(){

}

extern const uint8_t _USB_CDC_BULK_EP_IN;   // Data interface IN endpoint
extern const uint8_t _USB_CDC_BULK_EP_OUT;  // Data interface OUT endpoint
uint8_t dataReceived = 0;
uint16_t dataReceivedSize;

void USBDev_CDCDataReceived(uint16_t size){
  dataReceived = 1;
  dataReceivedSize = size;
}

void main(void){
  ADCON1 |= 0x0F;                         // Configure all ports with analog function as digital
  CMCON  |= 7;                            // Disable comparators

  // Initialize CDC Class
  USBDev_CDCInit();
  
  // Initialize USB device module
  USBDev_Init();
 
  // Enable USB device interrupt
  IPEN_bit = 1;
  USBIP_bit = 1;
  USBIE_bit = 1;
  GIEH_bit = 1;

  // Infinite loop
  while(1){
    // If device is configured
    if(USB_CDC_DeviceConfigured){
      // Set receive buffer where received data is stored
      USBDev_CDCSetReceiveBuffer(buffer);

      // Reset configured flag
      USB_CDC_DeviceConfigured = 0;
    }

    if(dataReceived == 1){
      dataReceived = 0;
      // Send back received packet
      USBDev_CDCSendData(buffer, dataReceivedSize);
      // Prepare receive buffer
      USBDev_CDCSetReceiveBuffer(buffer);
    }
  }

}