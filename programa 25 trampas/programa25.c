int valor;

void IntDet() org 0x0014{    //vector INT0
  LATA--;                    //porta es decrementado
  IFS0.F0 = 0;               //bandera de interrupcion borrada
}

void TrapTrap() org 0x000C{
  INTCON1.F4 = 0;
  /*El problema es corregido seteando 
  el valor del puerto A con un valor dirferente de 0*/
  LATA = 5;
  LATB++;    //Contador de ocurrencias del la trampa
}

void main(){
  TRISB = 0x0080;
  TRISA = 0x0;
  LATB=0X0;
  LATA = 0x05;
  IFS0 = 0;     //Bandera de interrupcion borrada
  INTCON1 = 0;  //Bandera de trampa borrada
  IEC0 = 1;     //INterrupcíon en el flanco de subida INT0 (RB6) habilitado
  while(1){
     valor = 256 / LATA; //Si LATA=0 se produce un error y se llama a la rutina de atención de trampa
  }
}
