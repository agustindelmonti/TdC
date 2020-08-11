

%respuesta en frecuencia 
t1 = [0:0.1:20];

a = 5;
x1 = a*sin(1*t1);

num=[2580];
den=[12664 1];
Gp = tf(num,den)

%% Sin accion controlador
FTLC = feedback(Gp, 1);

figure(1);
lsim(FTLC,x1,t1);
title('Respuesta SPO a entrada senoidal');
legend('CA(t)');

%% Con accion controlador

Kp = 6.178;
Ki = 1.259;
kd = 0;   

Gc = Kp + tf([Ki],[1 0]) + tf([kd 0],[1]);
FTLA = Gc*Gp

figure(2)
bode(FTLA);

FTLC = feedback(FTLA, 1);

figure(1);
lsim(FTLC,x1,t1);
title('Respuesta SPO a entrada senoidal');
legend('CA(t)');