%% sin controlador 

figure(1)
num=[2580];
den=[12664 1];
FTLA = tf(num,den)
step(FTLA);

figure(2)
den2=[12664 2581];
FTLC = tf(num,den2)
step(FTLC);

%% retardo de 2.1 segundos (solo funciona en lazo cerrado)

figure(3)
num=[2580];
den=[12664 1];
FTLA = tf(num,den,'InputDelay',2.1)
step(FTLA); 
%Como es de esperarse, en lazo abierto no afecta a C(t)

figure(4)
den2=[12664 2581];
FTLC = tf(num,den2,'InputDelay',2.1)
step(FTLC);


%% sintonizacion de controlador P

num=[2580];
den=[12664 2581];
Gp = tf(num,den)

Gc = pidtune(Gp,'P') 
pidTuner(Gp,Gc);

%Despues del tuner
Kp = 5.473;
Gc = Kp;

FTLA = Gp*Gc;
FTLC = feedback(FTLA,1)
step(FTLC);


%% sintonizacion de controlador PI

num=[2580];
den=[12664 2581];
Gp = tf(num,den)

Gc = pidtune(Gp,'PI') 
pidTuner(Gp,Gc);

%Despues del tuner
Kp = 6.77;
Ki = 1.38;
Gc = Kp + tf([Ki],[1 0]);

FTLA = Gp*Gc;
FTLC = feedback(FTLA,1)
step(FTLC);


%% sintonizacion de controlador PD

num=[2580];
den=[12664 2581];
Gp = tf(num,den)

Gc = pidtune(Gp,'PD') 
pidTuner(Gp,Gc);

%Despues del tuner
Kp = 70.938;
Kd = 0;  %pidTuner no sintoniza el derivativo?
Gc = Kp + tf([kd 0],[1]);

FTLA = Gp*Gc;
FTLC = feedback(FTLA,1)
step(FTLC);


%% sintonizacion de controlador PID

num=[2580];
den=[12664 2581];
Gp = tf(num,den)
Gc = pidtune(Gp,'PID')

pidTuner(Gp,Gc);

%Despues del tuner
Kp = 6.178;
Ki = 1.259;
kd = 0;   %pidTuner no sintoniza el derivativo?

Gc = Kp + tf([Ki],[1 0]) + tf([kd 0],[1]);

FTLC = Gp*Gc/(1+Gp*Gc)
step(FTLC);




