#line 1 "C:/Users/Remigio Guevara/Dropbox/materias/microcontroladores de gama alta/clase/programa 16 EEPROM/programa16.c"
void main() {

 PORTB = 0;
 TRISB = 0;


 PORTD = 0;
 TRISD = 0;


 TRISA = 0xFF;


 ADCON1= 0X0E;
 PORTD = EEPROM_Read(5);

 do {
 PORTB = PORTB++;
 Delay_ms(100);

 if (~PORTA.B2) EEPROM_Write(5,PORTB);

 PORTD = EEPROM_Read(5);

 do {}
 while (~PORTA.B2);

 }
 while(1);
}
