 //Declaraci�n de estructuras
typedef struct
{
unsigned short Hor, Min, Seg;
}Hora;
typedef struct
{
unsigned short Dia, Fec, Mes, Ano;
}Fecha;
//Funci�n para definir direcci�n de memoria.
void DS1307SetDir( unsigned short dir )
{
I2C1_Start();
I2C1_Wr(0xD0);
I2C1_Wr(dir);
}
//Funci�n para convertir de c�digo Bcd a Entero.
unsigned short BcdToShort( unsigned short bcd )
{
unsigned short LV, HV;
LV = bcd&0x0F;
HV = (bcd>>4)&0x0F;
return LV + HV*10;
}
//Funci�n para convertir de Entero a Bcd.
unsigned short ShortToBcd( unsigned short valor )
{
unsigned short HV, LV;
HV = valor/10;
LV = valor - HV*10;
return LV + HV*16;
}
//Funci�n para inicializar el DS1307.
void DS1307Inicio( void )
{
unsigned short VAL[7], HV, LV, DATO;
I2C1_Init(100000); //Inicio del bus I2C.
delay_ms(50); //Retardo.
//Lectura de las primeras 7 direcciones.
DS1307SetDir(0);
I2C1_Repeated_Start();
I2C1_Wr(0xD1);
VAL[0] = I2C1_Rd(1);
VAL[1] = I2C1_Rd(1);
VAL[2] = I2C1_Rd(1);
VAL[3] = I2C1_Rd(1);
VAL[4] = I2C1_Rd(1);
VAL[5] = I2C1_Rd(1);
VAL[6] = I2C1_Rd(0);
I2C1_Stop();
delay_ms(50); //Retardo.
//Validaci�n y correcci�n de informaci�n,
//como hora y fecha.
DATO = BcdToShort( VAL[0] );
if( DATO > 59 )VAL[0]=0;
DATO = BcdToShort( VAL[1] );
if( DATO>59 )VAL[1]=0;
DATO = BcdToShort( VAL[2] );
if( DATO>23 )VAL[2]=0;
DATO = BcdToShort( VAL[3] );
if( DATO>7 || DATO==0 )VAL[3]=1;
DATO = BcdToShort( VAL[4] );
if( DATO>31 || DATO==0 )VAL[4]=1;
DATO = BcdToShort( VAL[5] );
if( DATO>12 || DATO==0 )VAL[5]=1;
DATO = BcdToShort( VAL[6] );
if( DATO>99 )VAL[6]=0;
//Grabaci�n de las primeras 7 direcciones.
DS1307SetDir(0);
I2C1_Wr(VAL[0]);
I2C1_Wr(VAL[1]);
I2C1_Wr(VAL[2]);
I2C1_Wr(VAL[3]);
I2C1_Wr(VAL[4]);
I2C1_Wr(VAL[5]);
I2C1_Wr(VAL[6]);
I2C1_Wr(0x10); //Se activa la salida oscilante 1Hz.
I2C1_Stop();
delay_ms(50); //Retardo.
}
//Funci�n para grabar la hora minutos y segundos.
void DS1307SetHora( Hora h )
{
DS1307SetDir(0);
I2C1_Wr( ShortToBcd(h.Seg) );
I2C1_Wr( ShortToBcd(h.Min) );
I2C1_Wr( ShortToBcd(h.Hor) );
I2C1_Stop();
}
//Funci�n para grabar el d�a, fecha, mes, y a�o.
void DS1307SetFecha( Fecha f )
{
DS1307SetDir(3);
I2C1_Wr( ShortToBcd(f.Dia) );
I2C1_Wr( ShortToBcd(f.Fec) );
I2C1_Wr( ShortToBcd(f.Mes) );
I2C1_Wr( ShortToBcd(f.Ano) );
I2C1_Stop();
}
//Funci�n para leer la hora minutos y segundos.
Hora DS1307GetHora( void )
{
Hora H;
unsigned short VAL[3];
DS1307SetDir(0);
I2C1_Repeated_Start();
I2C1_Wr(0xD1);
VAL[0] = I2C1_Rd(1);
VAL[1] = I2C1_Rd(1);
VAL[2] = I2C1_Rd(0);
I2C1_Stop();
H.Seg = BcdToShort( VAL[0] );
H.Min = BcdToShort( VAL[1] );
H.Hor = BcdToShort( VAL[2] );
return H;
}
//Funci�n para leer el d�a, fecha, mes, y a�o.
Fecha DS1307GetFecha( void )
{
Fecha F;
unsigned short VAL[4];
DS1307SetDir(3);
I2C1_Repeated_Start();
I2C1_Wr(0xD1);
VAL[0] = I2C1_Rd(1);
VAL[1] = I2C1_Rd(1);
VAL[2] = I2C1_Rd(1);
VAL[3] = I2C1_Rd(0);
I2C1_Stop();
F.Dia = BcdToShort( VAL[0] );
F.Fec = BcdToShort( VAL[1] );
F.Mes = BcdToShort( VAL[2] );
F.Ano = BcdToShort( VAL[3] );
return F;
}
// Funciones para leer y grabar datos individuales //
//Funci�n para leer las horas.
unsigned short DS1307GetHoras( void )
{
Hora h;
h=DS1307GetHora();
return h.Hor;
}
//Funci�n para leer los minutos.
unsigned short DS1307GetMinutos( void )
{
Hora h;
h=DS1307GetHora();
return h.Min;
}
//Funci�n para leer los segundos.
unsigned short DS1307GetSegundos( void )
{
Hora h;
h=DS1307GetHora();
return h.Seg;
}
//Funci�n para grabar las horas.
void DS1307SetHoras( unsigned short ho )
{
Hora h;
h=DS1307GetHora();
h.Hor = ho;
DS1307SetHora( h );
}
//Funci�n para grabar los minutos.
void DS1307SetMinutos( unsigned short mi )
{
Hora h;
h=DS1307GetHora();
h.Min = mi;
DS1307SetHora( h );
}
//Funci�n para grabar los segundos.
void DS1307SetSegundos( unsigned short se )
{
Hora h;
h=DS1307GetHora();
h.Seg = se;
DS1307SetHora( h );
}
//Funci�n para leer el d�a de la semana.
unsigned short DS1307GetDias( void )
{
Fecha f;
f=DS1307GetFecha();
return f.Dia;
}
//Funci�n para leer la fecha del mes.
unsigned short DS1307GetFechas( void )
{
Fecha f;
f=DS1307GetFecha();
return f.Fec;
}
//Funci�n para leer el mes del a�o.
unsigned short DS1307GetMeses( void )
{
Fecha f;
f=DS1307GetFecha();
return f.Mes;
}
//Funci�n para leer el a�o.
unsigned short DS1307GetAnos( void )
{
Fecha f;
f=DS1307GetFecha();
return f.Ano;
}
//Funci�n para grabar el dia de la semana.
void DS1307SetDias( unsigned short di )
{
Fecha f;
f=DS1307GetFecha();
f.Dia = di;
DS1307SetFecha(f);
}
//Funci�n para grabar la fecha del mes.
void DS1307SetFechas( unsigned short fe )
{
Fecha f;
f=DS1307GetFecha();
f.Fec = fe;
DS1307SetFecha(f);
}
//Funci�n para grabar el mes del a�o.
void DS1307SetMeses( unsigned short me )
{
Fecha f;
f=DS1307GetFecha();
f.Mes = me;
DS1307SetFecha(f);
}
//Funci�n para grabar el a�o.
void DS1307SetAnos( unsigned short an )
{
Fecha f;
f=DS1307GetFecha();
f.Ano = an;
DS1307SetFecha(f);
}

