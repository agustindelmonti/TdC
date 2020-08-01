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
%Afecta, pero requiere un mayor tiempo de retardo

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


%% sintonizacion metodo de la curva de reaccion del proceso
figure(5);
hold on;
k=2580;
L=2000;
T=12664;
num=[k];
den=[T 1];
Gp = tf(num,den,'InputDelay',L)
step(Gp,'-k');


%proporcional
kp=T/L;
Gc=kp;
FTLAP=Gc*Gp;
FTLCP=feedback(FTLAP,1);
step(FTLCP,'-b');

% PI
kp=0.9*T/L;
ki=kp/(L/0.3);
Gc=kp + tf([ki],[1 0])
FTLAPI=Gc*Gp;
FTLCPI=feedback(FTLAPI,1);
step(FTLCPI,'-r');

%PID
kp=1.2*T/L;
ki=kp/(2*L);
kd=kp*(0.5*L);
Gc=kp + tf([ki],[1 0]) + tf([kd 0],[1])
FTLAPID=Gc*Gp;
FTLCPID=feedback(FTLAPID,1);
step(FTLCPID,'-m');

xlim([0 2100]);
legend('Sin controlador','P','PI','PID');
%ver las graficas, por que quedan asi


%% Análisis de estabilidad
num=[2580];
den=[12664 1];
Gp = tf(num,den);

%proporcional
Kp = 5.473;
Gc = Kp;
FTLA = Gp*Gc;

figure(6);
rlocus(FTLA);


%PI
Kp = 6.77;
Ki = 1.38;
Gc = Kp + tf([Ki],[1 0]);
FTLA = Gp*Gc;

figure(7);
rlocus(FTLA);

%PID
Kp = 6.178;
Ki = 1.259;
Kd = 0;
Gc = Kp + tf([Ki],[1 0]) + tf([kd 0],[1]);
FTLA = Gp*Gc;

figure(8);
rlocus(FTLA);





