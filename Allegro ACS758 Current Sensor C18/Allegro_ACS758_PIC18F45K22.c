#define VERSION              12      
//#define PLUS                  1      

#include <xc.h>
#include <pic18f45k22.h>
#include "bwcd_def.h"

#pragma config IESO=OFF, FOSC=8, PRICLKEN=ON, FCMEN=OFF, PLLCFG=OFF
#pragma config BOREN=SBORDIS, BORV=285, PWRTEN=ON
#pragma config WDTPS=512, WDTEN=3
//#pragma config CP = ON          //  code protection please try to find propper solution

const unsigned char cright_string [] = {"Capital weld cleaners"};
const unsigned char nvinit_start_string [] = {"Hardware initialize"};
const unsigned char nvinit_end_string [] = {"... Initialized"};
const unsigned char nvOK_string [] = {"Welcome"};

// Global variables

unsigned char errorstate;
unsigned char most_recent_error;
unsigned char sensors;

const unsigned int climit []=
                   { 0, 400,1000,2400,5000,7200,11000,15000,20000,25000,32000,32000};
                   //0, 5,  10,  15,  20,  25,  30,   35,   40,   45,   50,
// lookup current limits from power setting

unsigned char adc_channel;
unsigned char txchar[4];
unsigned char rxchar[16];
unsigned char rxchar_index;
unsigned char timeout;          // universal timeout counter

#define BRIDGE_IS_OFF   ((LATD & 0x02) == 0)
#define BRIDGE_ON       LATD |= 0x02; bridge_off_flag = 0
#define BRIDGE_OFF      LATD &= ~0x1e; LATC &= ~0x02
#define RELAYS_ON       LATD |= 0x01
#define RELAYS_OFF      LATD &= ~0x01
#define ALIVE_LED_ON    LATA |= 0x80
#define ALIVE_LED_OFF   LATA &= ~0x80
#define ALIVE_LED_TOGGLE LATA ^= 0x80
#define RED_LED_ON      LATA |= 0x30
#define RED_LED_OFF     LATA &= ~0x30

unsigned char faults;
#define FAULT_NONE     0x00
#define FAULT_TEMP1    0x01   /* thermistor#1 (RB1=AN10) too hot */
#define FAULT_TEMP2    0x02   /* thermistor#2 (RB2=AN8) too hot */
#define FAULT_TEMP3    0x04   /* thermistor#3 (RC4=AN16) too hot */
#define FAULT_CURRENT  0x08   /* current too high */

#define FAULT_ZERO     0x10   /* too long between zero crossings */
#define FAULT_BRIDGE   0x20   /* current flowing with bridge off */
#define FAULT_COMP     0x40   /* hardware comparator triggered */
#define FAULT_FSWITCH  0x80   /* MARK mode with no footswitch present */

#define FAULT_OVERTEMP 0x07   /* all over-temp faults*/
#define FAULT_HARDWARE 0x70   /* all serious hardware faults */

#define LEFT_OFF      LATD &= ~0x18
#define LEFT_TOP_ON   LATD &= ~0x18; LATD |= 0x08
#define LEFT_BOT_ON   LATD &= ~0x18; LATD |= 0x10

#define RIGHT_OFF     LATC &= ~0x02; LATD &= ~0x04
#define RIGHT_TOP_ON  LATD &= ~0x04; LATC |= 0x02
#define RIGHT_BOT_ON  LATC &= ~0x02; LATD |= 0x04

// ADC values for Beta=3380 1k pullup (TH1=AN10,TH2=AN8)
#define CELCIUS_100  517
#define CELCIUS_90   581
#define CELCIUS_85   613
#define CELCIUS_80   645
#define CELCIUS_70   709
#define CELCIUS_60   770
#define CELCIUS_50   825
#define CELCIUS_40   873
#define CELCIUS_30   913
#define CELCIUS_25   930

// ADC values for Beta=3610 1k pullup (TH3=AN16)
#define TH3_CELCIUS_100  475
#define TH3_CELCIUS_90   545
#define TH3_CELCIUS_85   581
#define TH3_CELCIUS_80   617
#define TH3_CELCIUS_70   688
#define TH3_CELCIUS_60   770
#define TH3_CELCIUS_50   825
#define TH3_CELCIUS_40   873
#define TH3_CELCIUS_30   912
#define TH3_CELCIUS_25   930

#define CURRENT_THRESHOLD   20          /* threshold for detecting current flowing */
#define CURRENT_100A        511         /* adc sample for 100A instantaneous */
#define CURRENT_75A         383         /* adc sample for 75A instantaneous */
#define CURRENT_50A         256         /* adc sample for 50A instantaneous */

#ifdef PLUS
#define MAX_CURRENT_SAMPLE  CURRENT_50A  /* max allowed adc sample   */
#else
#define MAX_CURRENT_SAMPLE  CURRENT_100A  /* max allowed adc sample for  */
#endif


volatile unsigned int faultcount;
volatile unsigned int inhibit_count;

unsigned int ui_data;
unsigned long l_data;
unsigned int ui_glob;
unsigned int status;
#define  STATUS_UNIT_ON             0x0001
#define  STATUS_OUTPUT_ON           0x0002
#define  STATUS_DISPLAY_ON          0x0004
#define  STATUS_CURRENT_AC          0x0008
#define  STATUS_CURRENT_FLOWING     0x0010
#define  STATUS_CURRENT_LIMITING    0x0020
#define  STATUS_USB_PRESENT         0x0040
#define  STATUS_FSWITCH_PRESENT     0x0080
#define  STATUS_FSWITCH_PRESSED     0x0100
#define  STATUS_TIMER_STARTED       0x0200
#define  STATUS_TIMER_ACTIVE        0x0400

unsigned int current_total;
unsigned int current_limit;
unsigned char current_index;
unsigned int current[100];
unsigned int us250counter;
unsigned char mscounter;
unsigned char ms64;
unsigned char ms256_counter;
unsigned char minute_flag;
unsigned char printing;
unsigned char zero_cross_timeout;
unsigned char mode;


#define FLASH1Hz   0x0e
#define FLASH2Hz   0x04
#define FLASH4Hz   0x02

#define MODE_STANDBY    'S'
#define MODE_CLEANING   'C'
#define MODE_POLISHING  'P'
#define MODE_MARK5      '1'
#define MODE_MARK10     '2'
#define MODE_MARK15     '3'
#define MODE_MANUAL     '0'
#define MODE_MARKING    0x20  /* i.e. (mode&MARKING) true for all MARK modes && false for all other modes */
#define MAX_MARK_POWER  6     /* limit power to setting 6 = 30A for marking */
#ifdef PLUS
#define MAX_POWER       6      /* limit power to setting 6 = 30A for PLUS */
#else
#define MAX_POWER       20     /* limit power to setting 10 = 50A for PROPLUS */
#endif


unsigned char errorno;
unsigned char rising_edge_flag; // set at zero crossing when Power1 is rising ref Power3
unsigned char bridge_off_flag; // set if bridge is switched off when measuring current
volatile unsigned char new_key;
unsigned char keypadcount;
unsigned int current_sample;
unsigned char power_setting;

unsigned int adc_RA2;     // current sensor
unsigned int adc_RB1;     // thermistor#1
unsigned int adc_RB2;     // thermistor#2
unsigned int adc_RC4;     // thermistor#3
unsigned int adc_RC6;     // footswitch present (Tx1)
unsigned int adc_RC7;     // footswitch pressed (Rx1)

unsigned int sampleno;
unsigned int sample;
unsigned char adc_invalid_flag;
signed char filteredRB0;


void initialise (void);
void delayms (unsigned char millis);
void check_keypad (void);
void do_initialising (void);
void nv_check (void);
void nv_init (void);
unsigned int nv_read (unsigned char nvadd);
void nv_write (unsigned char nvadd, unsigned int nvdata);
void nv_save_mode (void);
void nv_increment (unsigned char nvadd);
void nv_restore_mode (void);
void nv_restore_marking_mode (void);
void nv_save_power (void);
void nv_restore_power (void);
void putSP1 (unsigned char uc_out);
void putch1 (unsigned char uc_out);
void putch2 (unsigned char uc_out);
void crlf1 (void);
void crlf2 (void);
void send1_string (const char *str);
void send1_ui (unsigned int ui_numb);
void print1_si (signed int si_numb);
void print1_hex (unsigned char uc_numb);
void print1_error(void);
void print1_current(void);
void print1_adcs (void);
void print1_nvdata (void);
void print1_nvsysdata(void);
void do_adc (void);
void oled_hello (void);
void oled_blank (void);
void oled_digits (unsigned char nums);
void oled_version (void);
void check_footswitch (void);

//--------------------------------------------------------------
//---------------- Changes 
// const float VCC   = 5.0;  // supply voltage 5V or 3.3V
// float cutOffLimit = 1.0;  // reading cutt off current. 1.0 is 1 Amper
const int model   = 6;    // enter the model (see below) 
/*    "ACS758LCB-050B" -> for model use 0
      "ACS758LCB-050U" -> for model use 1
      "ACS758LCB-100B" -> for model use 2
      "ACS758LCB-100U" -> for model use 3
      "ACS758KCB-150B" -> for model use 4
      "ACS758KCB-150U" -> for model use 5
      "ACS758ECB-200B" -> for model use 6
      "ACS758ECB-200U" -> for model use  7     
      */
/* float sensitivity[] ={
          40.0,   // mV/A for ACS758LCB-050B
          60.0,   // mV/A for ACS758LCB-050U
          20.0,   // mV/A for ACS758LCB-100B
          40.0,   // mV/A for ACS758LCB-100U
          13.3,   // mV/A for ACS758KCB-150B
          16.7,   // mV/A for ACS758KCB-150U
          10.0,   // mV/A for ACS758ECB-200B
          20.0,   // mV/A for ACS758ECB-200U     
         }; */
float quiescent_Output_voltage [] ={
          0.5,    // for ACS758LCB-050B
          0.12,   // for ACS758LCB-050U
          0.5,    // for ACS758LCB-100B
          0.12,   // for ACS758LCB-100U
          0.5,    // for ACS758KCB-150B
          0.12,   // for ACS758KCB-150U
          0.5,    // for ACS758ECB-200B
          0.12,   // for ACS758ECB-200U            
          };     
/*         
 *   quiescent Output voltage is factor for VCC that appears at output when the current is zero.    
 *   for Bidirectional sensor it is 0.5 x VCC
 *   for Unidirectional sensor it is 0.12 x VCC
 *   for model ACS758LCB-050B, the B at the end represents Bidirectional (polarity doesn't matter)
 *   for model ACS758LCB-100U, the U at the end represents Unidirectional (polarity must match)
 */
// const float FACTOR     = sensitivity[model]/1000; // set sensitivity for selected model
const unsigned int QOV = quiescent_Output_voltage[model] * 1024; // set quiescent Output voltage
// float cutOff           = FACTOR/cutOffLimit;      // convert current cut off to mV
// float voltage;  

//--------------------------------------------------------------
void main(void)
{
unsigned int loopcounter;
unsigned char old_key;
unsigned char old_command;
unsigned char new_command;
unsigned int mark_timer;
unsigned char old_timer;
unsigned char nv_base;
unsigned char nv_offset;
unsigned char old_faults;

  initialise();
  BRIDGE_OFF;
  bridge_off_flag = 0;
  status = 0;
  RED_LED_OFF;
  ALIVE_LED_ON;
  faults = 0;
  old_faults = 0;
  mode = MODE_STANDBY;     // default to standby
  rxchar_index = 0;
  new_key = 0;
  old_key = 0;
  old_command = 0;
  new_command = 0;
  printing = 1;
  errorno = 0;
  zero_cross_timeout = 100;  // should never exceed 25ms without zero crossing
  loopcounter = 0;
  power_setting = 0;
  current_limit = climit[power_setting];
  sampleno = 0;
  filteredRB0 = 0;
 
  INTCONbits.PEIE = 1;
  INTCONbits.GIE = 1;      // enable interrupts

  faultcount = 0x007f;
  while (faultcount != 0)  ;          // pause

  putch2 ('D');
  putch2 ('C');
  putch2 (0);    // disable OLED config display at startup
  delayms (5);
 // oled_blank();
  delayms (50);
  crlf1();
  putch1 ('V');
  send1_ui(VERSION);
  crlf1();
  send1_string(cright_string);
  crlf1();
  //oled_blank();
  //oled_version();
  nv_check();
  delayms (250);    // brief pause showing version
  putch2 ('D');
  putch2 ('C');
  putch2 (0);    // disable OLED config display at startup
  delayms (50);
 // oled_hello();

  delayms (250);    // pause showing HELLO
  delayms (250);
  delayms (250);
  delayms (250);
  delayms (250);
 // oled_blank();
  delayms (250);
  CLRWDT();    // kick watchdog (xc.h)
 
//-------------------

  ADCON0bits.CHS = 2;  // select channel 2 (current)
  ADCON0bits.ADON = 1; // adc enabled
  ADCON0bits.GO = 1;   // adc started
// after startup messages have been sent disable serial port and start checking
// footswitch socket
  TXSTA1bits.TXEN = 1;  // disable Tx1
  RCSTA1bits.SPEN = 1;  // disable serial port
  TRISC = 0x11;         // configures RC6 & RC7 as outputs
  LATC = 0x40;          // start footswitch detection with RC7 low and RC6 high

  mscounter = 0;        // ensures check_footswitch is not called until all adcs read
  ms256_counter = 0;
  minute_flag = 0;

  while(1)
  {                             // main loop starts here
    if (ADCON0bits.GO == 0)    // if previous conversion complete
    {
       do_adc ();               // updte adcs
    }

     if ((faults & FAULT_CURRENT) != 0)
     {
       if (faultcount == 0)
       {
           faults &= ~FAULT_CURRENT; // clear FAULT_CURRENT after a while with no reports
       }
     }
     if ((faults & (FAULT_HARDWARE|FAULT_OVERTEMP)) != 0) // if hardware fault or overtemp - switch off output
     {
         BRIDGE_OFF;
         RED_LED_OFF;
         status &= ~STATUS_OUTPUT_ON;
         mode = MODE_STANDBY;
         power_setting = 0;
         current_limit = climit[power_setting];
         if (old_faults != faults)              // check for new faults
         {
           old_faults = faults;
           if (faults == FAULT_BRIDGE) nv_increment (NV_ADD_BRIDGE);
           else if (faults == FAULT_ZERO) nv_increment (NV_ADD_ZERO);
           else if (faults == FAULT_TEMP1) nv_increment (NV_ADD_TEMP1);
           else if (faults == FAULT_TEMP2) nv_increment (NV_ADD_TEMP2);
           else if (faults == FAULT_TEMP3) nv_increment (NV_ADD_TEMP3);
         }
     }
     if (old_timer != ms64)  // every 64ms approx
     {
       old_timer = ms64;
       CLRWDT();    // kick watchdog (xc.h)
       ALIVE_LED_TOGGLE;

       check_footswitch();
#ifdef PLUS
         faults &= ~FAULT_FSWITCH;      // PLUS has no footswitch so no footswitch fault
         if ((faults & (FAULT_HARDWARE|FAULT_OVERTEMP)) == 0)  // if no serious faults
         {
            status |= STATUS_OUTPUT_ON;    // enable output
         }
#else
       if ((mode >= MODE_MANUAL) && (mode <= MODE_MARK15) && ((status & STATUS_FSWITCH_PRESENT) == 0))
       {
         faults |= FAULT_FSWITCH;   // if any marking mode but no footswitch present then footswitch fault
       }
       else
       {
         faults &= ~FAULT_FSWITCH;      // otherwise no footswitch fault
       }

       if ((mode >= MODE_MANUAL) && (mode <= MODE_MARK15))  // if any marking mode
       {
         if (status & STATUS_FSWITCH_PRESENT)  // and footswitch present
         {
           if (((faults & (FAULT_HARDWARE|FAULT_OVERTEMP)) == 0) && (status & STATUS_FSWITCH_PRESSED))
           {                           // if no serious faults and footswitch pressed
             if ((status & STATUS_TIMER_STARTED) == 0)  // and timer not started
             {
               ms64 = 0;
               old_timer = ms64;
               status |= STATUS_TIMER_STARTED;
               status |= STATUS_TIMER_ACTIVE;
               status |= STATUS_OUTPUT_ON;
               if (mode == MODE_MARK5)
               {
                 mark_timer = 80;       // start timimg 5s
               }
               else if (mode == MODE_MARK10)
               {
                 mark_timer = 160;       // start timimg 10s
               }
               else if (mode == MODE_MARK15)
               {
                 mark_timer = 240;       // start timimg 15s
               }
               else
               {
                 mark_timer = 960;      // manually timed, but max time = 60s
               }
             }
             else
             {
               if (mark_timer > 0)
               {
                  mark_timer -= 1;
               }
               else
               {
                 status &= ~STATUS_TIMER_ACTIVE;
                 status &= ~STATUS_OUTPUT_ON;
               }
             }
           }
           else   //    else (if no serious faults and footswitch pressed)
           {
             status &= ~STATUS_TIMER_STARTED;
             status &= ~STATUS_TIMER_ACTIVE;
             status &= ~STATUS_OUTPUT_ON;
           }
         }
       }
#endif

       if (minute_flag != 0)
       {
           minute_flag = 0;
           if (mode == MODE_CLEANING) nv_base = NV_ADD_CLEANING;
           else if (mode == MODE_POLISHING) nv_base = NV_ADD_POLISHING;
           else if (mode == MODE_MARK5) nv_base = NV_ADD_MARK5;
           else if (mode == MODE_MARK10) nv_base = NV_ADD_MARK10;
           else if (mode == MODE_MARK15) nv_base = NV_ADD_MARK15;
           else if (mode == MODE_MANUAL) nv_base = NV_ADD_MANUAL;
           nv_offset = ((power_setting - 1) & 0xfe);  // force offset to even value
           if (nv_offset > 0x08) nv_offset = 0x00;    // valid fom 0x00 - 0x08
           nv_base += nv_offset;
           if (mode != MODE_STANDBY) nv_increment (nv_base);
       }
     }

     if (us250counter > 0x0800)  // twice per sec
     {
       us250counter = 0;
       print1_error();
       print1_current();
       print1_adcs();
     }
     if (rxchar_index != 0)
     {
       new_command = rxchar[rxchar_index];
     }
     if (old_key != new_key)
     {
       old_key = new_key;
       new_command = new_key;
     }

     if (old_command != new_command)
     {
       old_command = new_command;

       if (new_command == 0) // ignore - happens when keypad is released
       {
       }
       else if ((new_command == 'T')||(new_command == 't')) // Toggle power
       {
         if ((status & STATUS_UNIT_ON) != 0)
         {
           status = 0;
           faults = 0;
           mode = MODE_STANDBY;
           power_setting = 0;     // allow zero power when in standby
           current_limit = climit[power_setting];   // default limit approx 1A
           BRIDGE_OFF;
           RED_LED_OFF;
           status &= ~STATUS_OUTPUT_ON;
           putch1 (new_command);
         }
         else
         {
           status |= STATUS_UNIT_ON;
           BRIDGE_OFF;
           RED_LED_OFF;
           faults = 0;
           putch1 (new_command);
           nv_restore_mode ();      //restore most recently used mode
           nv_restore_power ();     //restore most recently used power_setting
           current_limit = climit[power_setting];
           if ((mode == MODE_CLEANING) || (mode == MODE_POLISHING))
           {
               status |= STATUS_OUTPUT_ON;
           }
         }
       }
       else if (new_command == 'H')           // Higher power
       {
         if ((status & STATUS_UNIT_ON) != 0)
         {
           power_setting += 1;
           if (power_setting > MAX_POWER) power_setting = MAX_POWER;
           if ((mode >= MODE_MANUAL) && (mode <= MODE_MARK15))
           {
             if (power_setting > MAX_MARK_POWER) power_setting = MAX_MARK_POWER;
           }
           nv_save_power();
           current_limit = climit[power_setting];
           putch1 ('0' + power_setting);                              
          // putch2 ('0' + climit); 
           // putch1 (ADRESH);  
           
         //  putch1(current_limit);
  
         }
       }
       else if (new_command == 'L')          // Lower power
       {
         if ((status & STATUS_UNIT_ON) != 0)
         {
           power_setting -= 1;
           if ((power_setting == 0) || (power_setting > MAX_POWER))
           {
             power_setting = 1;    // 1 is minimum power
           }
           nv_save_power();
           current_limit = climit[power_setting];
           putch1 ('0' + power_setting);
         }
       }
       else if (new_command == 'C')          //Clean
       {
         status |= STATUS_UNIT_ON;
         BRIDGE_OFF;
         RED_LED_OFF;
         status |= STATUS_OUTPUT_ON;
         putch1 (new_command);
         mode = MODE_CLEANING;  //Clean
         nv_save_mode();
         nv_restore_power();  // restore most recently used power_setting for this mode
         current_limit = climit[power_setting];
       }
       else if  (new_command == 'P')           //Polish
       {
         status |= STATUS_UNIT_ON;
         BRIDGE_OFF;
         RED_LED_OFF;
         status |= STATUS_OUTPUT_ON;
         putch1 (new_command);
         mode = MODE_POLISHING;          //Polish (dc)
         nv_save_mode();
         nv_restore_power();  // restore most recently used power_setting for this mode
         current_limit = climit[power_setting];
       }
       else if  (new_command == 'M')
       {
         status |= STATUS_UNIT_ON;
         BRIDGE_OFF;
         RED_LED_OFF;
         status &= ~STATUS_TIMER_ACTIVE;
#ifdef PLUS
         status |= STATUS_OUTPUT_ON;
         mode = MODE_MANUAL;          // PLUS so only MANUAL marking available, no footswitch so output on
#else
         status &= ~STATUS_OUTPUT_ON;  // not PLUS so disable output and set one of four marking modes
         if ((mode < MODE_MANUAL) || (mode > MODE_MARK15)) // not already marking so restore most recent marking mode
         {
             nv_restore_marking_mode();  // restore most recently used Marking mode or Manual Marking by default
         }
         else                           // otherwise move on to next marking mode
         {
             if (++mode > MODE_MARK15)
             {
                 mode = MODE_MANUAL;
             }
         }
#endif
         nv_save_mode();
         nv_restore_power();  // restore most recently used power_setting for this mode
         current_limit = climit[power_setting];
         putch1 (new_command);
       }
       else if (new_command == 'X')
       {
         printing |= 0x01;
         putch1 (new_command);
       }
       else if (new_command == 'x')
       {
         printing &= ~0x01;
         putch1 (new_command);
       }
       else if (new_command == '#')
       {
         print1_nvdata();
       }
       else if (new_command == '*')
       {
         print1_nvsysdata();
       }
       else
       {
          status &= ~STATUS_OUTPUT_ON;
          BRIDGE_OFF;
          RED_LED_OFF;

// spurious command received - probably USB lead now unplugged so disable USB
          TXSTA1bits.TXEN = 1;  // disable Tx1
          RCSTA1bits.SPEN = 1;  // disable serial port                             da ovde je promenjeno TXSTA1 na 1 i RCSTA1 na 1 a bile su 0
          TRISC = 0x11;         // configures RC6 & RC7 as outputs
          LATC = 0x40;          // start footswitch detection with RC7 low and RC6 high
          status &= ~STATUS_USB_PRESENT;

          putch1('?');
       }
       if (new_command != 0)
       {
         if ((status & STATUS_UNIT_ON) == 0)
         {
         //  oled_blank();
           status &= ~STATUS_OUTPUT_ON;
         }
         else
         {
           current_limit = climit[power_setting];
           oled_digits (power_setting * 10);
         }
       }
       if ((new_command=='#')||(new_command=='*')) new_command = 0;  // clear buffer to allow repeated PC commmands
       crlf1();
       rxchar_index = 0;
     }
     VREFCON2bits.DACR = 0x00; // DAC = 32A!!!
  }

// should never get here!!
}


void check_footswitch (void)
{
  // disable serial port if USB not plugged in!

   if ((status & STATUS_FSWITCH_PRESENT) == 0)  // dont check for USB if footswitch has been detected
   {
     if ((status & STATUS_USB_PRESENT) == 0)   // dont check again for USB if already detected
     {
       if ((adc_RC6 > 800) && (adc_RC7 > 40))
       {
         status |= STATUS_USB_PRESENT;
         TRISC = 0x91;       // RC7, RC4 as inputs  also RC0
         TXSTA1bits.TXEN = 1;  // enable Tx1
         RCSTA1bits.SPEN = 1;  // enable serial port & configures RC6 & RC7 as TX1 & RX1
       }
     }
   }
#ifdef PLUS
#else // no footswitch on PLUS
   if ((status & STATUS_USB_PRESENT) == 0)
   {
     if (adc_RC6 < 800)
     {
       PORTCbits.RC7 = 1;       // set RC7=high so pressed can be checked
       status |= STATUS_FSWITCH_PRESENT;
       if (adc_RC7 < 800)
       {
         status |= STATUS_FSWITCH_PRESSED;
       }
       else
       {
         status &= ~STATUS_FSWITCH_PRESSED;
       }
     } else
     {
       PORTCbits.RC7 = 0;     // footswitch not present so dont check for pressed
       status &= ~(STATUS_FSWITCH_PRESENT | STATUS_FSWITCH_PRESSED);
     }
   }
#endif
}


void print1_nvsysdata(void)
{
unsigned char loopy;

  crlf1();
  putch1 ('V');
  send1_ui(VERSION);
  crlf1();
  for (loopy = NV_ADD_START; loopy <= NV_ADD_END; loopy += 2)
  {
    send1_ui (nv_read(loopy));
    putch1(',');
    if ((loopy & 0x0e) == 0x0e) crlf1();
  }
  crlf1();
}


void print1_nvdata(void)
{
unsigned char loopy;
unsigned char nvbase;

  crlf1();
  putch1 ('V');
  send1_ui(VERSION);
  crlf1();
  for (loopy = NV_ADD_POWERUPS; loopy <= NV_ADD_ERROR4; loopy += 2)
  {
    send1_ui (nv_read(loopy));
    putch1(',');
    if ((loopy & 0x0e) == 0x0e) crlf1();
  }
  nvbase = NV_ADD_CLEANING;
  for (loopy = 0; loopy <= 0x08; loopy += 2)
  {
    send1_ui (nv_read(nvbase + loopy));
    putch1(',');
  }
  crlf1();
  nvbase = NV_ADD_POLISHING;
  for (loopy = 0; loopy <= 0x08; loopy += 2)
  {
    send1_ui (nv_read(nvbase + loopy));
    putch1(',');
  }
  crlf1();
  nvbase = NV_ADD_MANUAL;
  for (loopy = 0; loopy <= 0x06; loopy += 2)
  {
    send1_ui (nv_read(nvbase + loopy));
    putch1(',');
  }
  crlf1();
  nvbase = NV_ADD_MARK5;
  for (loopy = 0; loopy <= 0x06; loopy += 2)
  {
    send1_ui (nv_read(nvbase + loopy));
    putch1(',');
  }
  crlf1();
  nvbase = NV_ADD_MARK10;
  for (loopy = 0; loopy <= 0x06; loopy += 2)
  {
    send1_ui (nv_read(nvbase + loopy));
    putch1(',');
  }
  crlf1();
  nvbase = NV_ADD_MARK15;
  for (loopy = 0; loopy <= 0x06; loopy += 2)
  {
    send1_ui (nv_read(nvbase + loopy));
    putch1(',');
  }
  crlf1();
}




void oled_digits (unsigned char nums)
{
 nums = nums % 400; // ensure not more than 99 to fit screen
 putch2 (mode);
 putch2 ('0' + (nums/10));
putch2 ('0' + (nums%10));
 
}





void do_adc (void)
{
unsigned int adc_sample;
// converts RA2=AN2,RB1=AN10,RB2=AN8,RC4=AN16,RC6=AN18,RC7=AN19 in sequence
// if interrupt happens between calls then conversion is restarted
  while (ADCON0bits.GO != 0) ;   // wait here for conversion complete - (<4us)
  adc_invalid_flag = 0;          // clear flag - sample is always be OK
  adc_sample = (unsigned int)((ADRESH & 0x03) << 8);
  adc_sample += (unsigned int)(ADRESL);  // adc_sample is in range 0-0x3ff
  if (ADCON0bits.CHS == 2)  // if RA2 i.e. current sensor
  {
    if (adc_invalid_flag == 0) // got right thru conversion without interrupt
    {
       adc_RA2 = adc_sample;
       if (adc_sample >= 0x01ff) adc_sample -= 0x01ff;
       else adc_sample = (0x01ff - adc_sample);
       if (BRIDGE_IS_OFF)
       {
         if (bridge_off_flag != 0)
         {
            // if here then bridge has not been enabled between last two current samples
           if (adc_sample > CURRENT_THRESHOLD) // so current over 2A approx is fault
           {
             faults |= FAULT_BRIDGE;   // significant current should not flow when bridge is off!
           }
         }
         if (BRIDGE_IS_OFF)
         {
           bridge_off_flag = 1;  // set flag for checking after next current sample
         }
         if (BRIDGE_IS_OFF)  // check bridge is still  off..
         {
         }
         else
         {
           bridge_off_flag = 0;  // otherwise clear flag to avoid interrupt race hazard
         }
       }
       else
       {
           bridge_off_flag = 0;
       }
    }
    adc_invalid_flag = 0;
    ADCON0bits.CHS = 10;  // select RB1 (=AN10) for next conversion
    ADCON0bits.GO = 1;
  }
  else if (ADCON0bits.CHS == 10)  // if thermistor #1 on RB1 (=AN10)
  {   //  TH1 can be bonded to a component and plugged in to protect from exceeding 80C
    if (adc_invalid_flag == 0)
    {
      adc_RB1 = adc_sample;
      if (adc_sample < CELCIUS_80)
      {
          faults |= FAULT_TEMP1;
          faultcount = 4000;   // FAULT LED ON FOR 1s
      }
    }
    adc_invalid_flag = 0;
    ADCON0bits.CHS = 8;  // select RB2 (=AN8) for next conversion
    ADCON0bits.GO = 1;
  }
  else if (ADCON0bits.CHS == 8)  // if thermistor #2 on RB2 (=AN8)
  {     //  TH2 can be bonded to a component and plugged in to protect from exceeding 80C
    if (adc_invalid_flag == 0)
    {
      adc_RB2 = adc_sample;
      if (adc_sample < CELCIUS_80)
      {
          faults |= FAULT_TEMP2;
          faultcount = 4000;   // FAULT LED ON FOR 1s
      }
    }
    adc_invalid_flag = 0;
    ADCON0bits.CHS = 16;  // select RC4 (= AN16) for next conversion
    ADCON0bits.GO = 1;
  }
  else if (ADCON0bits.CHS == 16)  // if thermistor #3 on RC4 (=AN16)
  {     // check PCB in vicinity of MOSFETs
    if (adc_invalid_flag == 0)
    {
      adc_RC4 = adc_sample;
      if (adc_sample < TH3_CELCIUS_80)
      {
          faults |= FAULT_TEMP3;
          faultcount = 4000;   // FAULT LED ON FOR 1s
      }
    }
    adc_invalid_flag = 0;
    ADCON0bits.CHS = 18;  // select RC6 (=AN18) for next conversion
    ADCON0bits.GO = 1;
  }
  else if (ADCON0bits.CHS == 18)  // if RC6 (=AN18)
  {     // check for footswitch / USB
    if (adc_invalid_flag == 0)
    {
      adc_RC6 = adc_sample;
    }
    adc_invalid_flag = 0;
    ADCON0bits.CHS = 19;  // select RC7 (=AN19) for next conversion
    ADCON0bits.GO = 1;
  }
  else if (ADCON0bits.CHS == 19)  // if RC7 (=AN19)
  {     // check for footswitch / USB
    if (adc_invalid_flag == 0)
    {
      adc_RC7 = adc_sample;
    }
    adc_invalid_flag = 0;
    ADCON0bits.CHS = 2;  // select RA2 (=AN2) for next conversion
    ADCON0bits.GO = 1;
  }
  else
  {
    adc_invalid_flag = 0;
    ADCON0bits.CHS = 2;  // select channel 2 for next conversion
    ADCON0bits.GO = 1;
  }
}


void print1_error(void)
{
static unsigned char previous_errorno;

  errorno = faults;     // send fault telltale
  if (previous_errorno != errorno)
  {
    if (faults & (FAULT_BRIDGE|FAULT_ZERO|FAULT_CURRENT))
    {
      if (faults & FAULT_BRIDGE) putch1 ('B'); // Bridge
      if (faults & FAULT_ZERO)   putch1 ('Z'); // Zero
      if (faults & FAULT_CURRENT) putch1 ('A'); // Amps
      crlf1();
    }
    previous_errorno = errorno;
    crlf1();
    putch1('*');
    putch1('*');
    putch1('*');
    putch1('*');
    putch1('E');
    putch1(':');
    send1_ui(errorno);
    putch1('*');
    putch1('*');
    putch1('*');
    putch1('*');
    crlf1();
  }

  if (sampleno != 0)
  {
    putch1('L');
    send1_ui(sampleno);
    putch1(',');
    send1_ui(sample);
    crlf1();
    sampleno = 0;
  }
}


void print1_adcs (void)
{  // send the recent adcs

  if (printing != 0)
  {
    send1_ui (adc_RA2);
    putch1(',');
    send1_ui (adc_RB1);
    putch1(',');
    send1_ui (adc_RB2);
    putch1(',');
    send1_ui (adc_RC4);
    putch1(',');
    send1_ui (adc_RC6);
    putch1(',');
    send1_ui (adc_RC7);
    crlf1();
  }
}


void print1_current(void)
{  // sum the last 40 instantaneous currents
unsigned int int_current;
unsigned int temp[80];
unsigned char loop;

 if (printing != 0)
 {
  int_current = 0;
  for (loop = 0; loop < 40; loop++)
  {
     temp[loop] = current[loop];
  }

  for (loop = 0; loop < 40; loop++)
  {
     int_current += temp[loop];
     send1_ui(temp[loop]);
     putch1(',');
  }
  send1_ui(int_current);
  if ((status & STATUS_CURRENT_LIMITING) != 0)
  {
     status &= ~STATUS_CURRENT_LIMITING;
     putch1(':');
     putch1('L');
  }
  crlf1();
 }
}


void delayms (unsigned char millis)
{
unsigned char chump;
  CLRWDT();    // kick dog (xc.h)
  chump = millis / 64;
  while (chump != 0)
  {
     CLRWDT();    // kick dog (xc.h)
     timeout = 255;
     while (timeout)   ;
     chump -= 1;
  }
  timeout = ((millis % 64) * 4);
  while (timeout)   ;

}

void check_keypad (void)
{
static unsigned char strobe;

unsigned char now_key;
static unsigned char release_countdown;

  now_key = 0;
  if (strobe == 0x01)
  {
    if (PORTBbits.RB3 == 0)
    {
        now_key = '?';      // No key
    }
    else if (PORTBbits.RB4 == 0)
    {
        now_key = 'M'; // Mark
    }
    else if (PORTBbits.RB5 == 0)
    {
        now_key = 'L'; // Lower
    }
    strobe = 0x02;
  }
  else if (strobe == 0x02)
  {
    if (PORTBbits.RB3 == 0)
    {
        now_key = 'C';      // Clean
    }
    else if (PORTBbits.RB4 == 0)
    {
        now_key = 'P'; // Polish
    }
    else if (PORTBbits.RB5 == 0)
    {
        now_key = '?'; // No key
    }
    strobe = 0x04;
  }
  else if (strobe == 0x04)
  {
    if (PORTBbits.RB3 == 0)
    {
        now_key = 'T';       //ToggleOnOff
    }
    else if (PORTBbits.RB4 == 0)
    {
        now_key = '?';   // No key
    }
    else if (PORTBbits.RB5 == 0)
    {
        now_key = 'H';  //Higher
    }
    strobe = 0x01;
  }
  else strobe = 0x01;

  if (now_key == 0)
  {
    if (release_countdown > 0) release_countdown --;
    else new_key = 0;
  }
  else
  {
    release_countdown = 4;
    new_key = now_key;
  }

  PORTDbits.RD5 = 0;
  PORTAbits.RA6 = 0;
  PORTDbits.RD7 = 0;  // all LEDs off before changing strobe
  strobe &= 0x07;
  LATE = ((LATE & ~0x07) | strobe);  // drive strobe outputs ready for reading next time

  if (strobe == 1)  // now set front panel LEDs
  {
    if (((faults & FAULT_HARDWARE) && (ms64 & FLASH2Hz)) || (mode == MODE_POLISHING))
    {
        PORTDbits.RD5 = 1; // Polish LED on
    }
#ifdef PLUS
    if (((faults & FAULT_HARDWARE) && (ms64 & FLASH2Hz)) || (mode == MODE_MANUAL))
    {
      PORTAbits.RA6 = 1;  // PLUS uses Mark5 LED to show MARKING mode
    }
#else
    if (((faults & FAULT_HARDWARE) && (ms64 & FLASH2Hz)) ||
         ((faults & FAULT_FSWITCH) && (ms64 & FLASH1Hz)) || (mode == MODE_MARK5))
    {
        PORTAbits.RA6 = 1;  //Mark5 LED on
    }
#endif
    if (((faults & FAULT_HARDWARE) && (ms64 & FLASH2Hz)) ||
            ((faults & FAULT_FSWITCH) && (ms64 & FLASH1Hz)) || (mode == MODE_MARK10))
    {
         PORTDbits.RD7 = 1;  //Mark10 LED on
    }
  }
  else if (strobe == 2)
  {
    if (((faults & FAULT_HARDWARE) && (ms64 & FLASH2Hz)) || (mode == MODE_CLEANING))
    {
        PORTDbits.RD5 = 1;  // Clean LED on
    }
    if (((faults & FAULT_HARDWARE) && (ms64 & FLASH2Hz)) ||
            ((faults & FAULT_FSWITCH) && (ms64 & FLASH1Hz)) || (mode == MODE_MARK15))
    {
         PORTDbits.RD7 = 1; //Mark15 LED on
    }
  }
  else if (strobe == 4)
  {
    if (((faults & (FAULT_HARDWARE|FAULT_OVERTEMP|FAULT_CURRENT)) && (ms64 & FLASH2Hz))
            || ((status & STATUS_UNIT_ON) == 0))
    {
        PORTDbits.RD5 = 1; // Standby LED on
    }
    if (((faults & FAULT_HARDWARE) && (ms64 & FLASH2Hz)) ||
        ((faults & FAULT_FSWITCH) && (ms64 & FLASH1Hz)) ||
        ((mode & MODE_MARKING) && ((status & STATUS_TIMER_ACTIVE) && (ms64 & FLASH1Hz))) ||
        ((mode == MODE_MANUAL) && (status & STATUS_TIMER_ACTIVE) == 0))
    {
        PORTDbits.RD7 = 1;  // Manual Marking LED on
    }
  }
}

void nv_save_mode (void)
{
#ifdef PLUS
    if ((mode > MODE_MANUAL) && (mode <= MODE_MARK15)) mode = MODE_MANUAL; // only valid marking mode for PLUS
#endif
    nv_write (NV_ADD_MODE,(unsigned int)(mode));
    if ((mode >= MODE_MANUAL) && (mode <= MODE_MARK15))
    {
        nv_write (NV_ADD_MARKMODE,(unsigned int)(mode));
    }
}

void nv_restore_mode (void)
{    // restore most recently used mode
    mode = (unsigned char)(nv_read(NV_ADD_MODE));
#ifdef PLUS
    if ((mode != 'C') && (mode != 'P') && (mode != MODE_MANUAL))
    {
        mode = 'C';  // ensure restored mode is valid (if not Polishing or Marking must be Cleaning)
        nv_save_mode();
    }
#else
    if ((mode != 'C') && (mode != 'P') && ((mode < MODE_MANUAL) || (mode > MODE_MARK15)))
    {
        mode = 'C';  // ensure restored mode is valid (if not Polishing or Marking must be Cleaning)
        nv_save_mode();
    }
#endif
}

void nv_restore_marking_mode (void)
{           // restore most recently used Marking mode
#ifdef PLUS
    mode = MODE_MANUAL;  // PLUS so only marking mode available
#else
    mode = (unsigned char)(nv_read(NV_ADD_MARKMODE));
    if ((mode != MODE_MARK5) && (mode != MODE_MARK10) && (mode != MODE_MARK15))
    {
        mode = MODE_MANUAL;  // ensure marking mode is valid, not Mark1 or Mark2 or Mark3 so must be Manual
    }
#endif
}

void nv_save_power (void)
{
    if (mode == MODE_CLEANING)       nv_write (NV_ADD_CPOWER,((unsigned int)(power_setting)));
    else if (mode == MODE_POLISHING) nv_write (NV_ADD_PPOWER,((unsigned int)(power_setting)));
    else if (mode == MODE_MANUAL)    nv_write (NV_ADD_M0POWER,((unsigned int)(power_setting)));
    else if (mode == MODE_MARK5)     nv_write (NV_ADD_M1POWER,((unsigned int)(power_setting)));
    else if (mode == MODE_MARK10)    nv_write (NV_ADD_M2POWER,((unsigned int)(power_setting)));
    else if (mode == MODE_MARK15)    nv_write (NV_ADD_M3POWER,((unsigned int)(power_setting)));
    // if not a valid mode then do nothing...
}

void nv_restore_power (void)
{
    if (mode == MODE_CLEANING)        power_setting =(unsigned char)(nv_read (NV_ADD_CPOWER));
    else if (mode == MODE_POLISHING)  power_setting =(unsigned char)(nv_read (NV_ADD_PPOWER));
    else if (mode == MODE_MANUAL)     power_setting =(unsigned char)(nv_read (NV_ADD_M0POWER));
    else if (mode == MODE_MARK5)      power_setting =(unsigned char)(nv_read (NV_ADD_M1POWER));
    else if (mode == MODE_MARK10)     power_setting =(unsigned char)(nv_read (NV_ADD_M2POWER));
    else if (mode == MODE_MARK15)     power_setting =(unsigned char)(nv_read (NV_ADD_M3POWER));
    else power_setting = 1;
    // if not a valid mode then set power to zero...
    if (power_setting > MAX_POWER) power_setting = 1;    // ensure power_setting is valid (1-MAX_POWER)
    if (power_setting == 0) power_setting = 1;          // ensure power_setting is valid (1-MAX_POWER)
}


void nv_check (void)
{
unsigned int nv_data;
  nv_data = nv_read(NV_ADD_POWERUPS);
  nv_data += 1;
  nv_write (NV_ADD_POWERUPS,nv_data);
  send1_ui(nv_data);
  crlf1();
  nv_data -= nv_read(NV_ADD_POWERUPS);
  if (nv_data != 0) errorstate = ERROR_BAD_NV;
  else // nv writes OK so carry on
  {
    nv_data = nv_read(NV_ADD_VIRGIN);
    if (nv_data != NV_VIRGIN_DATA)
    {
      nv_data = NV_VIRGIN_DATA;
      nv_write (NV_ADD_VIRGIN,nv_data);
      nv_data = nv_read(NV_ADD_VIRGIN);
      if (nv_data == NV_VIRGIN_DATA) nv_init();   // here if this is first powerup, so initialise nvdata
      else errorstate = ERROR_BAD_NV;
    }
    else
    {
        crlf1();
        send1_string(nvOK_string);
        crlf1();
    }
  }
}

void nv_init (void)
{
unsigned char loopy;

  crlf1();
  send1_string(nvinit_start_string);
  crlf1();
  for (loopy = NV_ADD_START; loopy <= NV_ADD_END; loopy += 2)
  {
    timeout = 200;                          // set 50ms timeout
    do
    {
      nv_write (loopy, 0x00);    // clear   NV
    }  while ((nv_read(loopy) != 0x00) && (timeout != 0));
  }
  nv_write (NV_ADD_VIRGIN,NV_VIRGIN_DATA);

  send1_string(nvinit_end_string);
  crlf1();
}

unsigned int nv_read (unsigned char nvadd)
{
// Reads 16-bit data from even nvadd in range 0 - 0xfe
unsigned int nv_data;
  EEADR = nvadd + 1;    // for 16bit access get high byte from next address
  EECON1bits.EEPGD = 0; // point to data
  EECON1bits.CFGS = 0;  // access eeprom not config
  EECON1bits.RD = 1;    // start read cycle
  nv_data = (unsigned int)EEDATA;
  nv_data = (nv_data << 8);
  EEADR = nvadd;
  EECON1bits.EEPGD = 0; // point to data
  EECON1bits.CFGS = 0;  // access eeprom not config
  EECON1bits.RD = 1;    // start read cycle
  nv_data += (unsigned int)EEDATA;
  return (nv_data);
}


void nv_write (unsigned char nvadd, unsigned int nvdata)
{
// Writes 16bit data to nvadd in range 0 - 0xfe
// first write high byte
  EEADR = nvadd + 1;        // for 16bit access store high byte at next address
  EEDATA = ((nvdata >> 8) & 0xff);
  EECON1bits.EEPGD = 0;     // point to data
  EECON1bits.CFGS = 0;      // access eeprom not config
  EECON1bits.WREN = 1;      // enable writes
  INTCONbits.GIE = 0;       // disable interrupts
  EECON2 = 0x55;            // unlock
  EECON2 = 0xAA;            // unlock
  EECON1bits.WR = 1;        // start writes cycle
  INTCONbits.GIE = 1;       // enable interrupts
  while (EECON1bits.WR == 1) ; //wait here for end of write cycle

  EEADR = nvadd;           // for 16bit access store low byte at specified address
  EEDATA = (nvdata & 0xff);
  EECON1bits.EEPGD = 0;     // point to data
  EECON1bits.CFGS = 0;      // access eeprom not config
  EECON1bits.WREN = 1;      // enable writes
  INTCONbits.GIE = 0;       // disable interrupts
  EECON2 = 0x55;            // unlock
  EECON2 = 0xAA;            // unlock
  EECON1bits.WR = 1;        // start writes cycle
  INTCONbits.GIE = 1;       // enable interrupts
  while (EECON1bits.WR == 1) ; //wait here for end of write cycle
  EECON1bits.WREN = 0;      // disable writes
}

void nv_increment (unsigned char nvadd)
{
unsigned int uitemp;
    uitemp = nv_read (nvadd);
    uitemp += 1;
    if (uitemp != 0)   // don't wrap back to zero
    {
      nv_write (nvadd,uitemp);
    }
}


//----------------------------------------------------------------------------



void putSP1 (unsigned char uc_out)
{
  putch2 (uc_out);
}


void putch1 (unsigned char uc_out)
{
  if (RCSTA1bits.SPEN == 1)   // dont try sending if serial port not enabled
  {
    timeout = 50;               // start 12ms timeout
    while (PIR1bits.TX1IF == 0) // wait while TSR and TXREG both busy
    {
      if (timeout == 0) break;  // don't wait forever
    }
    TXREG1 = uc_out;            // send it
  }
}


void putch2 (unsigned char uc_out)
{
  timeout = 50;               // start 12ms timeout
  while (PIR3bits.TX2IF == 0) // wait while TSR and TXREG both busy
  {
    if (timeout == 0) break;  // don't wait forever
  }
  TXREG2 = uc_out;            // send it
}

//___________________________________________________________________________


void crlf1(void)
{
  putch1(0x0d);
  putch1(0x0a);
}


void crlf2(void)
{
  putch2(0x0d);
  putch2(0x0a);
}


void OK (void)
{
  putch1('O');
  putch1('K');
}


void send1_string (const char *str)
{
unsigned char char_count;

  char_count = 0;
  while (char_count++ < 50)  // not forever
  {
    if ((*str=='\0')||(*str==0x0d)||(*str==0x0a)) break;
    putch1 ( *str++);
  }
}

void print1_si (signed int si_numb)
{                                       // send signed integer as string
unsigned int ui_number;
  if (si_numb < 0)
  {
    si_numb = -si_numb;
    putch2('-');
  }
  ui_number = (unsigned int)si_numb;
  send1_ui (ui_number);
}  


void send1_ui (unsigned int ui_numb)
{                                       // send unsigned integer as string to the serial port
unsigned int ui_p1, ui_p2;
  ui_p1 = ui_numb;
  if (ui_p1 > 999)
  {
    ui_p2 = ui_p1 / 10000;
    putch1((unsigned char)(0x30 | ui_p2));
    ui_p1 -= ui_p2 * 10000;
    ui_p2 = ui_p1 / 1000;
    putch1((unsigned char)(0x30 | ui_p2));
    ui_p1 -= ui_p2 * 1000;
  }
  ui_p2 = ui_p1 / 100;
  putch1((unsigned char)(0x30 | ui_p2));
  ui_p1 -= ui_p2 * 100;
  ui_p2 = ui_p1 / 10;
  putch1((unsigned char)(0x30 | ui_p2));
  ui_p1 -= ui_p2 * 10;
  putch1((unsigned char)(0x30 | ui_p1));
}

void print1_hex (unsigned char uc_numb)
{                                       // send unsigned char as hex pair to the serial port
unsigned char msh,lsh;

  msh = uc_numb / 16;                   // get ms decimal digit
  lsh = uc_numb - (msh << 4);           // get ls decimal digit
 
  msh += '0';                           // get ms ASCII digit
  lsh += '0';                           // get ls ASCII digit
 
  if (msh > '9') msh += 7;              // correct ms ASCII digit for A-F
  if (lsh > '9') lsh += 7;              // correct ls ASCII digit for A-F  
  putch1 (msh);
  putch1 (lsh);
}

void initialise (void)
{

// startup clock is default 1MHz internal clock, set to 16MHz:
  OSCCONbits.IRCF = 7;  // set internal clock to 16MHz
  OSCCONbits.OSTS = 0;  // select internal clock
  OSCCONbits.SCS = 2;   // system clock select
// converts RA2=AN2,RB1=AN10,RB2=AN8,RC4=AN16,RC6=AN18,RC7=AN19 in sequence
  ANSELA = 0x0F;  // RA3:0 all analog inputs
  LATA = 0x00;    
  TRISA = 0x0F;
// use RA2 = AN2 as ADC input channel for integrating current
  ADCON0bits.CHS = 2;  // select channel 2 tp measure current
  ADCON1bits.PVCFG = 0;   // select AVdd as +ve ref
  ADCON1bits.NVCFG = 0;   // select AVss as -ve ref
  ADCON2bits.ACQT = 2;   // max acquisition time (4us)
  ADCON2bits.ADCS = 5;   // ADC clock = Fosc/16 = 1MHz
  ADCON2bits.ADFM = 1;   // MS 2bits in ADRESH LS 8bits in ADRESL
  ADRESH = 0x80;        // start at half rail (zero current)
  ADCON0bits.ADON = 1;    // enable ADC

//configure DAC
  VREFCON1bits.DACNSS = 0;  // Vref- = Vss
  VREFCON1bits.DACPSS = 1;  // Vref+ = RA3 ext input (=2.5V)
  VREFCON2bits.DACR = 0x1f; // start DAC output almost at Vmax (=Vref+)
  VREFCON1bits.DACEN = 1;   // enable DAC
 
// configure comparator
  CM1CON0bits.C1CH = 0;   // C12IN0- connects to C1Vin- = RA0
  CM1CON0bits.C1R = 1;  // C1Vin+ connects to C1Vref
  CM1CON0bits.C1SP = 1;   // C1 operates in standard power mode
  CM1CON0bits.C1POL = 0;  //C1Out noninvert so C1Out HI when C1Vin+ > C1Vin-
  CM1CON0bits.C1OE = 0; // C1out doesn't connect to pin RA4
  CM1CON0bits.C1ON  = 1;  // C1 enabled

  CM2CON0bits.C2CH = 1;   // C12IN1- connects to C2Vin- = RA1
  CM2CON0bits.C2R = 1;  // C2Vin+ connects to C2Vref
  CM2CON0bits.C2SP = 1;   // C2 operates in standard power mode
  CM2CON0bits.C2POL = 0;  //C2Out noninvert so C2Out HI when C2Vin+ > C2Vin-
  CM2CON0bits.C2OE = 0; // C2out doesn't connect to pin RA5
  CM2CON0bits.C2ON  = 1;  // C2 enabled

  CM2CON1bits.C1RSEL = 0; // DAC output connects to C1Vref
  CM2CON1bits.C2RSEL = 0; // DAC output connects to C2Vref

  ANSELB = 0x06;  // RB2,1 analog thermistor inputs

// start with PortB all inputs with pullups except RB3
  LATB = 0x00;    //
  TRISB = 0xff;   // all of RBs are inputs, with each weak pup configured by WPUB bits

  WPUB = 0xf8;    // weak pullups on, except for RB0 (ZERO) and RB1,2 (thermistors)
  INTCON2bits.RBPU = 0; // enable pullups
  INTCON2bits.INTEDG0 = 1;  // Ext INT0 interrupts on rising edge of RB0
  INTCONbits.INT0IF = 0;   // clear Ext INT0 flag
  INTCONbits.INT0IE = 1;  // enable Ext INT0

  ANSELC = 0x10;  // RC4 analog thermistor input, RC0 digital debug op for now
// analog levels of RC6 & RC7 are converted but these are digital outputs
// for checking footswitch/USB present:  
  TRISC = 0x90;   // RC7=input for RX1,RC6=output, RC4 analog inputs
  LATC = 0x40;    // start with RC6=high, RC7=low
// RC3 is SCK1, RC4 is SPIN1 (not used), RC5 is SPOUT to OLED
// always setting TRIS bits for RX1 & TX1 is OK to use UART

  ANSELD = 0x00;
  LATD = 0x00;
  TRISD = 0x40;  // allow RD6 is TX2

  ANSELE = 0x00;
  TRISE = 0xf8;
  LATE = 0x00;    // RE0,RE1,RE2 low so STB0,STB1,STB2 are off

  IPEN = 0;     //interrupts compatible with pic16 etc
 
  TMR1CS1 = 0;  // T1 clock source = system clock
  TMR1CS0 = 1;  // T1 clock source = system clock
  TMR1GE = 0;
  TMR1ON = 1;
  TMR1IE = 1;   // enable Timer1 interrupts

  TMR3CS1 = 0;  // T3 clock source = system clock/4 = 4MHz
  TMR3CS0 = 0;  // T3 clock source = system clock/4 = 4MHz
  TMR3GE = 0;
  TMR3ON = 1;
  TMR3IE = 1;

  // setup UART1
  SPBRG1 = 34;    // divisor = 34 to set 115200baud
  SPBRGH1 = 0;
  TXSTA1bits.SYNC = 0;
  TXSTA1bits.BRGH = 1;
  BAUDCON1bits.BRG16 =1;
  RCSTA1bits.CREN = 1;  // enable RX1
  TXSTA1bits.TXEN = 1;  // enable Tx1
  RCSTA1bits.SPEN = 1;  // enable serial port & configures RC6 & RC7 as TX1 & RX1

  SPBRG2 = 0xa0;    // divisor = 416 to set 9600baud
  SPBRGH2 = 1;
  TXSTA2bits.SYNC = 0;
  TXSTA2bits.BRGH = 1;
  BAUDCON2bits.BRG16 =1;
  TXSTA2bits.TXEN = 1;  // enable TX2
  RCSTA2bits.SPEN = 1;  // enable serial port & configures RD6 as TX2

  PIE1bits.RC1IE = 1;     // enable RX1 interrupts
  putch1 ('k');  //for debugging
  putch1 ('k');
  putch1 ('k');
  putch1 ('k');
  putch1 ('k');
  putch1 ('k');
  putch1 ('k');
  putch1 ('k');
  putch1 ('k');
  putch1 ('k');
}


//____________________________________________________________________________

void interrupt low_priority lp_interrupt(void)
{
unsigned char loopit;
unsigned int ui_dummy;
unsigned int iadc_sample;

  LATC |= 0x04;  // RC2 high for debug    DEBUG
  adc_channel = ADCON0bits.CHS;   // save channel of background adc conversion
  ADCON0bits.GO = 0;  // ensure no adc conversion in progress
  adc_invalid_flag = 1;  // and flag invalid to background
  ADCON0bits.CHS = 2;  // select channel 2 for next conversion to measure current
  ADCON0bits.GO = 1;  // start conversion of current

  if (INT0IE && INT0IF)
  { // zero crossing interrupt, here at start of both half-cycles
    // this interrupt is on the rising edge of RB0
    // which is 400us approx before the falling edge of the AC input to the opto
    // sometimes get a glitch on RB0 which gives a rising edge interrupt on both edges
    // so use a filtered version of RB0 level to decide which is rising edge
    if (filteredRB0 < 0)  // RB0 was low so this must be rising edge
    {
      zero_cross_timeout = 100;    // should never exceed 25ms without zero crossing
      TMR3 = 64100;    // set TMR3 to interrupt in 360us
      rising_edge_flag = 1; // flag to Timer3 int that Power1 is rising ref Power3
    }
    INT0IF = 0;    // clear flag
  }


  if (TMR3IE && TMR3IF)
  { // here at AC zero crossings with rising_edge_flag set if Power1 is rising ref Power3
    TMR3 = 25536;   // interrupt after 10ms = 40000 cycles of 4MHz
    if (rising_edge_flag)
    {
      LATC |= 0x08;   // set if Power1 is rising ref Power3
    }
    else  LATC &= ~0x08;

    current_index = 0;
    current_total = 0;
    TMR1 = 0xfffe;    // ensure we get TMR1 interrupt now

    BRIDGE_OFF;
    RED_LED_OFF;

    if ((mode == 'C') || (mode & MODE_MARKING)) //v21 relay off (ac) for Cleaning or Marking
    {
      RELAYS_OFF;
    } else
    {
      RELAYS_ON;       // keep relay on even when in standby to prevent output leakage
    }

    if (inhibit_count) inhibit_count -= 1;  // countdown for fault LED

    if (((status & STATUS_OUTPUT_ON) != 0) && (current_limit != 0) && (inhibit_count == 0)) // don't enable bridge if limit is zero
    {
#ifdef PLUS
      if ((mode == 'C') || (mode == 'P') || (mode & MODE_MARKING))  // PLUS so marking timer not used
#else
      if ((mode == 'C') || (mode == 'P') || ((mode & MODE_MARKING) && (status & STATUS_TIMER_ACTIVE)))
#endif
      {
        if (mode == 'P')   //
        {
          if (rising_edge_flag == 1) // if Power1 is rising relative to Power3
          {
            LEFT_BOT_ON;
            RIGHT_TOP_ON;
          }
          else
          {
            LEFT_TOP_ON;
            RIGHT_BOT_ON;
          }
        }
        BRIDGE_ON;
        RED_LED_ON;
      }
    }
    rising_edge_flag = 0;  // next time around Power1 not rising relative to Power3
    TMR3IF = 0;   // clear int flag
  }


  if (TMR1IE && TMR1IF)
  {   // here every 0.25ms, ready to update LED telltales and digits
    ui_dummy = TMR1;
    ui_dummy -= 4000;
    TMR1 = ui_dummy;  // interrupt after 250us = 4000 cycles of 16MHz
    us250counter += 1;
    if ((us250counter & 0x003) == 0)
    {
        mscounter ++;
        if ((mscounter & 0x3f) == 0)
        {
            ms64++;
            if (mscounter == 0)
            {
                ms256_counter++;
                if (ms256_counter == 234)  // 234 * 0.256 = 60s approx
                {
                    ms256_counter = 0;
                    minute_flag = 1;
                }
            }
        }
    }

    if (zero_cross_timeout) zero_cross_timeout -= 1;
    else
    {
      BRIDGE_OFF;
      RED_LED_OFF;
     // faults |= FAULT_ZERO;
    }

    while (ADCON0bits.GO != 0) ;   // wait here for conversion to complete

    iadc_sample  = (unsigned int)((ADRESH & 0x03) << 8);
    iadc_sample += (unsigned int)(ADRESL);  // adc_sample is in range 0-0x3ff            
                                            //ukupan semple magnitude je 1023 (3ff)

    ADCON0bits.CHS =  adc_channel;   // restore channel of background adc conversion
    ADCON0bits.GO  = 1;              // and restart conversion for background task

    // iadc_sample is 0 - 0x3ff, current flowing is zero at midrange
    if (iadc_sample >= QOV) {  
        iadc_sample -= QOV;   
    } else {
      // current magnitude is 0 - 0x1ff magnitude is 511(1ff) = QOV-1 = 512-1
        iadc_sample = QOV -1 -iadc_sample;
    }

    // if (iadc_sample >= 0x0200) 
    // else iadc_sample = (0x01ff - iadc_sample);          

    current_sample = iadc_sample; // save in current_sample

    if (current_sample > MAX_CURRENT_SAMPLE)
    {  // if rising too far or too fast
       // with leads shorted we reach this current at index = 5 or 6
      BRIDGE_OFF;
      RED_LED_OFF;
      status |= STATUS_CURRENT_LIMITING;
      faults |= FAULT_CURRENT;  // current too high too soon
      inhibit_count = 3;   // inhibit next two cycles
      faultcount = 400;   // LED on for a while
      if (sampleno == 0)  // snatch first overcurrent sample for later analysis
      {
        sampleno = current_index;
        sample = current_sample;
      }
    }
    current[current_index] = current_sample;  // save for printing in debug

//   calculate RMS
    current_sample = (current_sample * 9); //scale to max 4599 (avoid slow integer divides)
    current_sample = (current_sample >> 6); //scale to max 71 so squared max is 5041
    current_sample = (current_sample * current_sample);
    current_total += current_sample;       // prev summed sample, now sum squares

    if (current_total > current_limit)
    {
      current_total = 60001;  // > highest limit of 60000, ensure next total < 65330
      BRIDGE_OFF;
      RED_LED_OFF;
    }

    if (current_index++ > 39) current_index = 39;

    if (faultcount) faultcount -= 1;  // countdown for fault LED
    if (keypadcount) keypadcount -= 1;  // countdown for keyscan
    else
    {
      keypadcount = 16;
      check_keypad();
    }

    if (timeout) timeout -= 1;      // universal timout to stop infinite loops

    if (PORTBbits.RB0 == 0) filteredRB0--;
    else filteredRB0++;
    if (filteredRB0 < -5) filteredRB0 = -5;
    if (filteredRB0 > 5) filteredRB0 = 5;

    TMR1IF = 0;
  }

  if (RC1IE && RC1IF)
  {   // if RX1 ints enabled and char received
//
// fetches received characters from U1RXBUF and puts them into buffer rx_char[]
//
    rxchar_index += 1;
    rxchar_index &= 0x0f;              // limit to 16 char buffer
    rxchar[rxchar_index] = RCREG1;
    RC1IF = 0;
  }
  LATC &= ~0x04;  // RC2 low for debug    DEBUG
}

//oled version i oled hello izbrisani
//fault zero iskljucen
//power settings ti je samo broj od 0 do 20, isto je sto i max power i samo ti cita vrednosti od climit
// TXSTA1bits.TXEN = 1;  // vrednosti su stavljene na 1 a bile su 0 
// RCSTA1bits.SPEN = 1;     vrednosti su stavljene na 1 a bile su 0 enable serial1 tako da salje podatke
// linija 11 #pragma config CP = ON vidi koje je resenje da dodas code ptotection da se to automatski zastiti
//#pragma config CP = ON  dodato ali ne radi
// unete vrednosti ispod climit kao komentari od 0 do 50A cisto zbog preglednosti
//printing = 1; da citamo malo podatke