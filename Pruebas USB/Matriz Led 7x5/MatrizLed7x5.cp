#line 1 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/EjemplosMios/Matriz Led 7x5/MatrizLed7x5.c"
#line 28 "C:/Users/Andres/Desktop/El resto/Pogramas MikroC/EjemplosMios/Matriz Led 7x5/MatrizLed7x5.c"
const char Alfabeto[95][5] = {
 {30,5,5,30},
 {31,21,21,10},
 {14,17,17,17},
 {31,17,17,14},
 {31,21,21,17},
 {31,5,5,1},
 {14,17,21,31},
 {31,4,4,31},
 {17,31,17},
 {4,8,15},
 {31,4,10,17},
 {31,16,16},
 {31,2,4,2,31},
 {31,2,4,8,31},
 {14,17,17,14},
 {31,5,5,2},
 {14,17,21,9,22},
 {31,5,13,18},
 {18,21,21,9},
 {1,31,1},
 {15,16,16,15},
 {15,16,15},
 {15,16,12,16,15},
 {17,10,4,10,17},
 {17,10,4,3},
 {17,25,21,19,17}
};


char MatrizLED[200], i, Mensaje[200];
char frase[]="HOLAMUNDO";

void MostrarMatriz(char *L);
void CargarSalida(char *M);

void main() {
LATB=0x7F;
TRISB = 0x00;
LATD=0x00;
TRISD=0x00;
CargarSalida(frase);

while (1){
 MostrarMatriz(MatrizLED);
}
}

void CargarSalida(char *M){
 unsigned short indice;
 char *res;
 int j,k;
 k=0;
 for (i=0; i<41; i++){
 if (*(M+i)==0) {
 break;
 } else if (*(M+i)>64) {
 indice=*(M+i)-65;
 for (j=0;j<5;j++) {
 if (Alfabeto[indice][j] != 0) {
 *(MatrizLED+k)=Alfabeto[indice][j];
 k++;
 }
 }
 *(MatrizLED+k)=0;
 k++;
 }
 }
}
void MostrarMatriz(char *L){
 for (i = 20; i<27; i++ ){
 LATD=0x00;
 asm rrncf LATB,1;
 LATD=*(L+i);
 delay_us(10);
 }
 LATB=0x7F;
}
