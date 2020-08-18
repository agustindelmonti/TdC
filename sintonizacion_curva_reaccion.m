%% sintonizacion metodo de la curva de reaccion del proceso

% Sistema con delay
figure(1);

k=2580;
L=2.1;  
T=12664;

num=[k];
den=[T 1];
Gp = tf(num,den,'InputDelay',L);
FTLC=feedback(Gp,1);  
step(FTLC,'-k');
                
%% Usando parametros
T = 3.24; %tiempo que tarda FTLC en llegar al 63,3%

figure(2);
hold on;

Gp = tf(num,den); 


%proporcional
kp=T/L ;

Gc= kp;
FTLAP=Gc*Gp;

FTLCP=feedback(FTLAP,1);
step(FTLCP,'-b');

% PI
kp=0.9*T/L 
ti = L/0.3;
td = 0;

Gc= tf([kp*td kp kp],[ti 0])
FTLAPI=Gc*Gp;

FTLCPI=feedback(FTLAPI,1);
step(FTLCPI,'-r');

%PID  
kp=1.2*T/L; 
ti = 2*L
td = 0.5*L;

Gc= tf([kp*td kp kp],[ti 0])
FTLAPID=Gc*Gp;

FTLCPID=feedback(FTLAPID,1);
step(FTLCPID,'-m');


%% Sintonizacion ultima ganancia
%No se puede aplicar

num=[Kcr*2580]
den=[12664 1];
FTLA=tf(num,den);

figure(1);
rlocus(FTLA);   
%No existe Kcritico para que el sistema sea criticamente estable


