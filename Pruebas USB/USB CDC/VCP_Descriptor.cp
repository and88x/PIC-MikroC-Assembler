#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/EjemplosMios/USB CDC/VCP_Descriptor.c"
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
#line 10 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/EjemplosMios/USB CDC/VCP_Descriptor.c"
const uint8_t _USB_CDC_INT_EP_IN = 1;
const uint8_t _USB_CDC_BULK_EP_IN = 2;
const uint8_t _USB_CDC_BULK_EP_OUT = 3;

const uint8_t _USB_CDC_MANUFACTURER_STRING[] = "Mikroelektronika";
const uint8_t _USB_CDC_PRODUCT_STRING[] = "VCP Demo";
const uint8_t _USB_CDC_SERIALNUMBER_STRING[] = "0x00000004";
const uint8_t _USB_CDC_CONFIGURATION_STRING[] = "CDC Config desc string";
const uint8_t _USB_CDC_INTERFACE_STRING[] = "CDC Interface desc string";


const uint8_t _USB_CDC_CONFIG_DESC_SIZ = 3*9 + 3*5 + 4 + 3*7;


const uint8_t USB_CDC_LangIDDesc[0x04] = {
 0x04,
 _USB_DEV_DESCRIPTOR_TYPE_STRING,
 0x409 & 0xFF,
 0x409 >> 8,
};



const uint8_t USB_CDC_device_descriptor[] = {
 0x12,
 0x01,
 0x00,
 0x02,
 0x02,
 0x00,
 0x00,
 0x40,
 0x00, 0x00,
 0x00, 0x04,
 0x00,
 0x01,
 0x01,
 0x02,
 0x03,
 0x01

};



const uint8_t USB_CDC_cfg_descriptor[_USB_CDC_CONFIG_DESC_SIZ] = {

 0x09,
 0x02,
 _USB_CDC_CONFIG_DESC_SIZ,
 _USB_CDC_CONFIG_DESC_SIZ >> 8,
 0x02,
 0x01,
 0x00,
 0xC0,
 0x32,


 0x09,
 _USB_DEV_DESCRIPTOR_TYPE_INTERFACE,
 0x00,
 0x00,
 0x01,
 0x02,
 0x02,
 0x01,
 0x00,


 0x05,
 0x24,
 0x00,
 0x10,
 0x01,


 0x05,
 0x24,
 0x01,
 0x00,
 0x01,


 0x04,
 0x24,
 0x02,
 0x02,




 0x05,
 0x24,
 0x06,
 0x00,
 0x01,


 0x07,
 _USB_DEV_DESCRIPTOR_TYPE_ENDPOINT,
 0x80 | _USB_CDC_INT_EP_IN,
 0x03,
 0x08,
 0x00,
 0xFF,


 0x09,
 _USB_DEV_DESCRIPTOR_TYPE_INTERFACE,
 0x01,
 0x00,
 0x02,
 0x0A,
 0x00,
 0x00,
 0x00,


 0x07,
 _USB_DEV_DESCRIPTOR_TYPE_ENDPOINT,
 _USB_CDC_BULK_EP_OUT,
 0x02,
 64,
 0x00,
 0x00,


 0x07,
 _USB_DEV_DESCRIPTOR_TYPE_ENDPOINT,
 0x80 | _USB_CDC_BULK_EP_IN,
 0x02,
 64,
 0x00,
 0x00
};
