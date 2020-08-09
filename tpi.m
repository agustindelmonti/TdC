
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


%% sintonizacion de controlador P pidTuner

num=[2580];
den=[12664 2581];
Gp = tf(num,den)

Gc = pidtune(Gp,'P')
%pidTuner(Gp,Gc);

%Despues del tuner
Kp = 5.473;
Gc = Kp;

fig=figure(1);
hold on;
FTLA = Gp*Gc;
FTLC = feedback(FTLA,1)
step(FTLC,'-r');
%saveas(fig,strcat(ruta,'pidtuner_p.png'));


% sintonizacion de controlador PI

num=[2580];
den=[12664 2581];
Gp = tf(num,den)

Gc = pidtune(Gp,'PI') 
%pidTuner(Gp,Gc);

%Despues del tuner
Kp = 6.77;
Ki = 1.38;
Gc = Kp + tf([Ki],[1 0]);

%fig=figure(1);
FTLA = Gp*Gc;
FTLC = feedback(FTLA,1)
step(FTLC,'-k');
%saveas(fig,strcat(ruta,'pidtuner_pi.png'));


% sintonizacion de controlador PD

num=[2580];
den=[12664 2581];
Gp = tf(num,den)

Gc = pidtune(Gp,'PD') 
%pidTuner(Gp,Gc);

%Despues del tuner
Kp = 6.847;
Kd = 0;  
Gc = Kp + tf([Kd 0],[1]);

%fig=figure(1);
FTLA = Gp*Gc;
FTLC = feedback(FTLA,1)
step(FTLC,'-b');
%saveas(fig,strcat(ruta,'pidtuner_pd.png'));


% sintonizacion de controlador PID

num=[2580];
den=[12664 2581];
Gp = tf(num,den)
Gc = pidtune(Gp,'PID')

%pidTuner(Gp,Gc);

%Despues del tuner
Kp = 6.178;
Ki = 1.259;
kd = 0;   %pidTuner no sintoniza el derivativo?

Gc = Kp + tf([Ki],[1 0]) + tf([kd 0],[1]);

%fig=figure(1);
FTLC = Gp*Gc/(1+Gp*Gc)
step(FTLC,'-g');
legend('P','PI','PD','PID');
ylim([0 1.2]);
saveas(fig,strcat(ruta,'pidtuner_todos.png'));


%% sintonizacion pidTuner con retardo P
k=2580;
L=2.1;
T=12664;
num=[k];
den=[T 1];
Gp = tf(num,den,'InputDelay',L)
FTLCp=feedback(Gp,1)


Gc = pidtune(FTLCp,'P')
pidTuner(FTLCp,Gc);

%Despues del tuner
Kp = 1.503; % un buen valor, teniendo en cuenta el analisis siguiente
Gc = Kp;

fig=figure(1);
FTLA = Gp*Gc;
FTLC = feedback(FTLA,1)
step(FTLC);
saveas(fig,strcat(ruta,'pidtuner_retraso2-1_p.png'));


%% sintonizacion metodo de la curva de reaccion del proceso
fig=figure(5);
hold on;

k=2580;
L=2.1; % con L=7.71, sistema criticamente estable, por que?? --> si aumenta el retraso tiene que disminuir kp para que el sistema sea estable
T=12664;
num=[k];
den=[T 1];
Gp = tf(num,den,'InputDelay',L); %si se usa la funcion con retardo para calcular FTLC con controlador da cualquier cosa
FTLC=feedback(Gp,1);  %esta da bien con un Gp con retardo, entonces lo demas tambien deberia estar bien, quizas es un error grafico
step(FTLC,'-k'); %si se grafica junto con los otros no se ve bien, porque es mucho mas lenta la respuesta (L=2.1)
                 %grafica parecida en cuato a tiempo de respuesta (L=20000)
                 %Lo anterior es valido usando los valores de parametros de la tabla
                 %Poniendo valores distintos, por ej kp=2(en vez de 6), se tiene una respues similar con valores normales de retardo
                 

%proporcional
kp=T/L  %T/L=6.3 (L=2000) hace inestable el sistema, por que el valor de la tabla no da estable??
Gc=kp;
FTLAP=Gc*Gp;
FTLCP=feedback(FTLAP,1);
step(FTLCP,'-b');

% PI
kp=0.9*T/L
ki=kp/(L/0.3)
Gc=kp + tf([ki],[1 0]);
FTLAPI=Gc*Gp;
FTLCPI=feedback(FTLAPI,1);
step(FTLCPI,'-r');

%PID  provoca error grafico al graficarlo junto con los otros
kp=1.2*T/L
ki=kp/(2*L)
kd=kp*(0.5*L)
Gc=kp + tf([ki],[1 0]) + tf([kd 0],[1]);
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





