
ruta='MatLab WorkSpace/TPI/TdC/images/'; %ejecutar primero

%% sin controlador 

fig=figure(1)
num=[2580];
den=[12664 1];
FTLA = tf(num,den)
step(FTLA);
saveas(fig,strcat(ruta,'ftla_sin_cont.png'));

fig=figure(2)
den2=[12664 2581];
FTLC = tf(num,den2)
step(FTLC);
saveas(fig,strcat(ruta,'ftlc_sin_cont.png'));

%% retardo de 2.1 segundos (solo funciona en lazo cerrado)

fig=figure(3);
num=[2580];
den=[12664 1];
FTLA = tf(num,den,'InputDelay',2.1) %si se cambia retardo, cambiar nombre
step(FTLA);
saveas(fig,strcat(ruta,'ftla_retardo2-1.png'));
%Como es de esperarse, en lazo abierto no afecta a C(t)
%Afecta, pero requiere un mayor tiempo de retardo

fig=figure(4);
den2=[12664 2581];
FTLC = tf(num,den2,'InputDelay',2.1) %si se cambia retardo, cambiar nombre
step(FTLC);
saveas(fig,strcat(ruta,'ftlc_retardo2-1.png'));


%% sintonizacion de controlador P

num=[2580];
den=[12664 2581];
Gp = tf(num,den)

Gc = pidtune(Gp,'P')
pidTuner(Gp,Gc);

%Despues del tuner
Kp = 5.473;
Gc = Kp;

fig=figure(1);
FTLA = Gp*Gc;
FTLC = feedback(FTLA,1)
step(FTLC);
saveas(fig,strcat(ruta,'pidtuner_p.png'));


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

fig=figure(1);
FTLA = Gp*Gc;
FTLC = feedback(FTLA,1)
step(FTLC);
saveas(fig,strcat(ruta,'pidtuner_pi.png'));


%% sintonizacion de controlador PD

num=[2580];
den=[12664 2581];
Gp = tf(num,den)

Gc = pidtune(Gp,'PD') 
pidTuner(Gp,Gc);

%Despues del tuner
Kp = 6.847;
Kd = 0;  
Gc = Kp + tf([Kd 0],[1]);

fig=figure(1);
FTLA = Gp*Gc;
FTLC = feedback(FTLA,1)
step(FTLC);
saveas(fig,strcat(ruta,'pidtuner_pd.png'));


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

fig=figure(1);
FTLC = Gp*Gc/(1+Gp*Gc)
step(FTLC);
saveas(fig,strcat(ruta,'pidtuner_pid.png'));


%% sintonizacion metodo de la curva de reaccion del proceso
fig=figure(5);
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
saveas(fig,strcat(ruta,'curva_reaccion_todos.png'));
%ver las graficas, por que quedan asi


%% Sintonizacion ultima ganancia
Kcr=1; %no existe k critico, el sistema no se inestabiliza 
Pcr=0; %no existe periodo critico
EC=[12664 Kcr*2580+1]; %denominador FTLC con controlador proporcional

num=[Kcr*2580]
den=[12664 1];
FTLA=tf(num,den);

fig=figure(1);
rlocus(FTLA);   %confirma que el sistema nunca se inestabiliza
saveas(fig,strcat(ruta,'rlocus_utl_ganancia.png'));
%NO se puede aplicar el metodo


%% Análisis de estabilidad
num=[2580];
den=[12664 1];
Gp = tf(num,den);

%proporcional
Kp = 5.473;
Gc = Kp;
FTLA = Gp*Gc;

fig=figure(6);
rlocus(FTLA);
saveas(fig,strcat(ruta,'estabilidad_pidtuner_p.png'));


%PI
Kp = 6.77;
Ki = 1.38;
Gc = Kp + tf([Ki],[1 0]);
FTLA = Gp*Gc;

fig=figure(7);
rlocus(FTLA);
saveas(fig,strcat(ruta,'estabilidad_pidtuner_pi.png'));


%PD
Kp=6.847;
Kd=0;
Gc = Kp + tf([Kd 0],[1]);
FTLA = Gp*Gc;

fig=figure(8);
rlocus(FTLA);
saveas(fig,strcat(ruta,'estabilidad_pidtuner_pd.png'));


%PID
Kp = 6.178;
Ki = 1.259;
Kd = 0;
Gc = Kp + tf([Ki],[1 0]) + tf([kd 0],[1]);
FTLA = Gp*Gc;

fig=figure(9);
rlocus(FTLA);
saveas(fig,strcat(ruta,'estabilidad_pidtuner_pid.png'));


%% Diagramas Bode y Nyquist
num=[2580];
den=[12664 1];
FTLA = tf(num,den);

figure(9);
bode(FTLA);

figure(10);
nyquist(FTLA);





