%% Diagramas Bode y Nyquist con PI (controlador elegido)
num=[2580];
den=[12664 1];
Gp = tf(num,den,'InputDelay',2.1); %sin retraso la fase nunca llega a 180 -> nunca se inestabiliza?

Kp = 1.001%6.77;
Ki = 0.0000000000001%1.38;
Gc = Kp + tf([Ki],[1 0]);

FTLA=Gp*Gc

figure(9);
bode(FTLA);

figure(10);
nyquist(FTLA);