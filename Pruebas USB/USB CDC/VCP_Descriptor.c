/*
 * Project name
     VCP Demo
 * Project file
     VCP_Descriptor.c
*/

#include <stdint.h>

const uint8_t _USB_CDC_INT_EP_IN = 1;    // Communication interface IN endpoint
const uint8_t _USB_CDC_BULK_EP_IN = 2;   // Data interface IN endpoint
const uint8_t _USB_CDC_BULK_EP_OUT = 3;  // Data interface OUT endpoint

const uint8_t _USB_CDC_MANUFACTURER_STRING[]  = "Mikroelektronika";
const uint8_t _USB_CDC_PRODUCT_STRING[]       = "VCP Demo";
const uint8_t _USB_CDC_SERIALNUMBER_STRING[]  = "0x00000004";
const uint8_t _USB_CDC_CONFIGURATION_STRING[] = "CDC Config desc string";
const uint8_t _USB_CDC_INTERFACE_STRING[]     = "CDC Interface desc string";

// Sizes of various descriptors
const uint8_t _USB_CDC_CONFIG_DESC_SIZ  = 3*9 + 3*5 + 4 + 3*7;

//String Descriptor Zero, Specifying Languages Supported by the Device
const uint8_t USB_CDC_LangIDDesc[0x04] = {
  0x04,
  _USB_DEV_DESCRIPTOR_TYPE_STRING,
  0x409 & 0xFF,
  0x409 >> 8,
};


// device descriptor
const uint8_t USB_CDC_device_descriptor[] = {
  0x12,       // bLength
  0x01,       // bDescriptorType
  0x00,       // bcdUSB
  0x02,
  0x02,       // bDeviceClass : CDC code
  0x00,       // bDeviceSubClass
  0x00,       // bDeviceProtocol
  0x40,       // bMaxPacketSize0
  0x00, 0x00, // idVendor
  0x00, 0x04, // idProduct
  0x00,       // bcdDevice
  0x01,
  0x01,       // iManufacturer
  0x02,       // iProduct
  0x03,       // iSerialNumber
  0x01        // bNumConfigurations

};

//contain configuration descriptor, all interface descriptors, and endpoint
//descriptors for all of the interfaces
const uint8_t USB_CDC_cfg_descriptor[_USB_CDC_CONFIG_DESC_SIZ] = {
    // Configuration Descriptor
    0x09,   //  bLength: Configuration Descriptor size
    0x02,   //  bDescriptorType: Configuration
    _USB_CDC_CONFIG_DESC_SIZ,       //  wTotalLength: number of returned bytes
    _USB_CDC_CONFIG_DESC_SIZ >> 8,
    0x02,   //  bNumInterfaces: 2 interfaces
    0x01,   //  bConfigurationValue: Configuration value
    0x00,   //  iConfiguration: Index of string descriptor describing the configuration
    0xC0,   //  bmAttributes: self powered
    0x32,   //  bMaxPower: 100 mA

    // Interface Descriptor
    0x09,   //  bLength: Interface Descriptor size
    _USB_DEV_DESCRIPTOR_TYPE_INTERFACE,  //  bDescriptorType: Interface
    0x00,   //  bInterfaceNumber: Number of Interface
    0x00,   //  bAlternateSetting: Alternate setting
    0x01,   //  bNumEndpoints: One endpoint used
    0x02,   //  bInterfaceClass: Communication Interface Class
    0x02,   //  bInterfaceSubClass: Abstract Control Model
    0x01,   //  bInterfaceProtocol: AT commands
    0x00,   //  iInterface: string descriptor index

    // Header Functional Descriptor
    0x05,   //  bLength: Descriptor size
    0x24,   //  bDescriptorType: CS_INTERFACE
    0x00,   //  bDescriptorSubtype: Header Functional Descriptor
    0x10,   //  bcdCDC: specification release number
    0x01,

    // Call Management Functional Descriptor
    0x05,   //  bFunctionLength: Descriptor size
    0x24,   //  bDescriptorType: CS_INTERFACE
    0x01,   //  bDescriptorSubtype: Call Management Functional descriptor
    0x00,   //  bmCapabilities: Device does not handle call management itself
    0x01,   //  bDataInterface: 1

    // Abstract Control Management Functional Descriptor
    0x04,   //  bFunctionLength: Descriptor size
    0x24,   //  bDescriptorType: CS_INTERFACE
    0x02,   //  bDescriptorSubtype: Abstract Control Management descriptor
    0x02,   //  bmCapabilities:  Device supports the request combination of
            //  Set_Line_Coding, Set_Control_Line_State,
            //  Get_Line_Coding, and the notification Serial_State

    // Union Functional Descriptor
    0x05,   //  bFunctionLength: Descriptor size
    0x24,   //  bDescriptorType: CS_INTERFACE
    0x06,   //  bDescriptorSubtype: Union functional descriptor
    0x00,   //  bMasterInterface: Communication class interface
    0x01,   //  bSlaveInterface0: Data Class Interface

    // Interrupt IN Endpoint Descriptor
    0x07,   //  bLength: Endpoint Descriptor size
    _USB_DEV_DESCRIPTOR_TYPE_ENDPOINT,   //  bDescriptorType: Endpoint
    0x80 | _USB_CDC_INT_EP_IN,           //  bEndpointAddress
    0x03,   //  bmAttributes: Interrupt
    0x08,   //  wMaxPacketSize
    0x00,
    0xFF,   //  bInterval

    // Data class interface descriptor
    0x09,   //  bLength: Endpoint Descriptor size
    _USB_DEV_DESCRIPTOR_TYPE_INTERFACE,  //  bDescriptorType:
    0x01,   //  bInterfaceNumber: Number of Interface
    0x00,   //  bAlternateSetting: Alternate setting
    0x02,   //  bNumEndpoints: Two endpoints used
    0x0A,   //  bInterfaceClass: CDC
    0x00,   //  bInterfaceSubClass
    0x00,   //  bInterfaceProtocol
    0x00,   //  iInterface

    // Bulk OUT Endpoint Descriptor
    0x07,   //  bLength: Endpoint Descriptor size
    _USB_DEV_DESCRIPTOR_TYPE_ENDPOINT,   //  bDescriptorType: Endpoint
    _USB_CDC_BULK_EP_OUT,                //  bEndpointAddress
    0x02,   //  bmAttributes: Bulk
    64,     //  wMaxPacketSize
    0x00,
    0x00,   //  bInterval: ignore for Bulk transfer

    // Bulk IN Endpoint Descriptor
    0x07,   //  bLength: Endpoint Descriptor size
    _USB_DEV_DESCRIPTOR_TYPE_ENDPOINT,   //  bDescriptorType: Endpoint
    0x80 | _USB_CDC_BULK_EP_IN,          //  bEndpointAddress
    0x02,   //  bmAttributes: Bulk
    64,     //  wMaxPacketSize
    0x00,
    0x00    //  bInterval
};