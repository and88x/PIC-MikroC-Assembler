
_interrupt:

;VCP_Example.c,28 :: 		void interrupt(){
;VCP_Example.c,30 :: 		USBDev_IntHandler();
	CALL        _USBDev_IntHandler+0, 0
;VCP_Example.c,31 :: 		}
L_end_interrupt:
L__interrupt5:
	RETFIE      1
; end of _interrupt

_USBDev_CDCParamsChanged:

;VCP_Example.c,33 :: 		void USBDev_CDCParamsChanged(){
;VCP_Example.c,35 :: 		}
L_end_USBDev_CDCParamsChanged:
	RETURN      0
; end of _USBDev_CDCParamsChanged

_USBDev_CDCDataReceived:

;VCP_Example.c,42 :: 		void USBDev_CDCDataReceived(uint16_t size){
;VCP_Example.c,43 :: 		dataReceived = 1;
	MOVLW       1
	MOVWF       _dataReceived+0 
;VCP_Example.c,44 :: 		dataReceivedSize = size;
	MOVF        FARG_USBDev_CDCDataReceived_size+0, 0 
	MOVWF       _dataReceivedSize+0 
	MOVF        FARG_USBDev_CDCDataReceived_size+1, 0 
	MOVWF       _dataReceivedSize+1 
;VCP_Example.c,45 :: 		}
L_end_USBDev_CDCDataReceived:
	RETURN      0
; end of _USBDev_CDCDataReceived

_main:

;VCP_Example.c,47 :: 		void main(void){
;VCP_Example.c,48 :: 		ADCON1 |= 0x0F;                         // Configure all ports with analog function as digital
	MOVLW       15
	IORWF       ADCON1+0, 1 
;VCP_Example.c,49 :: 		CMCON  |= 7;                            // Disable comparators
	MOVLW       7
	IORWF       CMCON+0, 1 
;VCP_Example.c,52 :: 		USBDev_CDCInit();
	CALL        _USBDev_CDCInit+0, 0
;VCP_Example.c,55 :: 		USBDev_Init();
	CALL        _USBDev_Init+0, 0
;VCP_Example.c,58 :: 		IPEN_bit = 1;
	BSF         IPEN_bit+0, BitPos(IPEN_bit+0) 
;VCP_Example.c,59 :: 		USBIP_bit = 1;
	BSF         USBIP_bit+0, BitPos(USBIP_bit+0) 
;VCP_Example.c,60 :: 		USBIE_bit = 1;
	BSF         USBIE_bit+0, BitPos(USBIE_bit+0) 
;VCP_Example.c,61 :: 		GIEH_bit = 1;
	BSF         GIEH_bit+0, BitPos(GIEH_bit+0) 
;VCP_Example.c,64 :: 		while(1){
L_main0:
;VCP_Example.c,66 :: 		if(USB_CDC_DeviceConfigured){
	MOVF        _USB_CDC_DeviceConfigured+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main2
;VCP_Example.c,68 :: 		USBDev_CDCSetReceiveBuffer(buffer);
	MOVLW       _buffer+0
	MOVWF       FARG_USBDev_CDCSetReceiveBuffer_dataBuff+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_USBDev_CDCSetReceiveBuffer_dataBuff+1 
	CALL        _USBDev_CDCSetReceiveBuffer+0, 0
;VCP_Example.c,71 :: 		USB_CDC_DeviceConfigured = 0;
	CLRF        _USB_CDC_DeviceConfigured+0 
;VCP_Example.c,72 :: 		}
L_main2:
;VCP_Example.c,74 :: 		if(dataReceived == 1){
	MOVF        _dataReceived+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main3
;VCP_Example.c,75 :: 		dataReceived = 0;
	CLRF        _dataReceived+0 
;VCP_Example.c,77 :: 		USBDev_CDCSendData(buffer, dataReceivedSize);
	MOVLW       _buffer+0
	MOVWF       FARG_USBDev_CDCSendData_dataBuff+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_USBDev_CDCSendData_dataBuff+1 
	MOVF        _dataReceivedSize+0, 0 
	MOVWF       FARG_USBDev_CDCSendData_dataLen+0 
	MOVF        _dataReceivedSize+1, 0 
	MOVWF       FARG_USBDev_CDCSendData_dataLen+1 
	CALL        _USBDev_CDCSendData+0, 0
;VCP_Example.c,79 :: 		USBDev_CDCSetReceiveBuffer(buffer);
	MOVLW       _buffer+0
	MOVWF       FARG_USBDev_CDCSetReceiveBuffer_dataBuff+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_USBDev_CDCSetReceiveBuffer_dataBuff+1 
	CALL        _USBDev_CDCSetReceiveBuffer+0, 0
;VCP_Example.c,80 :: 		}
L_main3:
;VCP_Example.c,81 :: 		}
	GOTO        L_main0
;VCP_Example.c,83 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
