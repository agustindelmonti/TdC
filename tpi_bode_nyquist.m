%% Diagramas Bode y Nyquist con PI (controlador elegido)
num=[2580];
den=[12664 1];

Gp = tf(num,den,'InputDelay',2.1); %sin retraso la fase nunca llega a 180 -> nunca se inestabiliza? -> SI


Kp = 1.001%6.77;
Ki = 0.0000000000001%1.38;
Gc = Kp + tf([Ki],[1 0]);

FTLA2 = Gp*Gc


Gcompensador = tf([1],[1 5]);
FTLA3 = FTLA2 * Gcompensador;

figure(9);
bode(FTLA1,FTLA2,FTLA3);

figure(10);
nyquist(FTLA3);