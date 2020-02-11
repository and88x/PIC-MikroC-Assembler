clear all;

fs = 10000;             % Frecuencia de muestreo (muestras por segundo).
t = 10;                  % Duracion (segundos).
fc = 300;               % Frecuencia de la portadora (Hertz).
fc2 = 2040;             % Frecuencia de adicion.
tb = 30;                % Tiempo de bit en representado en ciclos de fc.
dtB = 60;               % Tiempo de separacion entre bytes representado en ciclos de fc.
dtI = 1000;               % Tiempo para iniciar.

dato(1) = 181;
dato(2) = 182;
dato(3) = 183;

mc = fs / fc;
dt = 0:1/fs:t;
df = 2*sin(2*pi*fc*dt);
fa = 2*sin(2*pi*fc2*dt);
fo = zeros(1,length(df));

j = 1;
for j = j:j-1+(mc * dtI),
    fo(j) = df(j) * 0;
end

for k = 1:length(dato),
    if ((length(df) - j) < (mc*tb*9 + mc*dtB)),
        break;
    end
    
    trama = dec2bin(dato(k), 8);
    % Bit de inicio.
    for j = j:j-1+(mc * tb),
        fo(j) = df(j) * 1;
    end
    
    % Datos.
    for i = 1:8,
        for j = j:j-1+(mc * tb),
            fo(j) = df(j) * str2num(trama(9 - i)); 
        end
    end
    
    % Espacio entre bytes.
    for j = j:j-1+(mc * dtB),
        fo(j) = df(j) * 0;
    end
end
fo = fo + fa;
ruido = wgn(1, length(df), 1);
ruido = ruido .* 0.05;
fo = fo + ruido;
plot(fo)

%fprintf('%f\n', fo);
%fprintf('%f\n', dt);

A = [dt; fo];

fID = fopen('senal.txt','w');
%fprintf(fID,'%f\r\t%f\r\n', fo, dt);
fprintf(fID,'%f\t %f \r\n', A);
fclose(fID);