/*const char letra_A[4] = {30,5,5,30},
           letra_B[4] = {31,21,21,10},
           letra_C[4] = {14,17,17,17},
           letra_D[4] = {31,17,17,14},
           letra_E[4] = {31,21,21,17},
           letra_F[4] = {31,5,5,1},
           letra_G[4] = {14,17,21,31},
           letra_H[4] = {31,4,4,31},
           letra_I[3] = {17,31,17},
           letra_J[3] = {4,8,15},
           letra_K[4] = {31,4,10,17},
           letra_L[3] = {31,16,16},
           letra_M[5] = {31,2,4,2,31},
           letra_N[5] = {31,2,4,8,31},
           letra_O[4] = {14,17,17,14},
           letra_P[4] = {31,5,5,2},
           letra_Q[5] = {14,17,21,9,22},
           letra_R[4] = {31,5,13,18},
           letra_S[4] = {18,21,21,9},
           letra_T[3] = {1,31,1},
           letra_U[4] = {15,16,16,15},
           letra_V[3] = {15,16,15},
           letra_W[5] = {15,16,12,16,15},
           letra_X[5] = {17,10,4,10,17},
           letra_Y[4] = {17,10,4,3},
           letra_Z[5] = {17,25,21,19,17};  */

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
           
//char Mensaje[200] = {30,5,5,30,0,31,21,21,10,0};
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