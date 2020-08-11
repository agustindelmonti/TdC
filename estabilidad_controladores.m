%Seccion: analisis de estabilidad

num=[2580];
den=[12664 1];
Gp = tf(num,den)

%% Proporcional
kp = [2,10,45];
figure(1)
hold on;
for i = 1:length(kp)
    Gc = kp(i);
    FTLA = Gp*Gc;
    FTLC = feedback(FTLA,1);
    step(FTLC);
end

figure(2) %root locus
rlocus(Gp)


%% PI
kp = 6.77;
ki = [.5,1.38,10];

figure(3); 
hold on;
for i = 1:length(ki)
    Gc = kp + tf([ki(i)],[1 0]);
    
    FTLA = Gp*Gc
    FTLC = feedback(FTLA,1);
    step(FTLC);
end

figure(4);
rlocus(FTLA);
% se anadio un polo en 0, aumentando el tipo de sistema en 1

%% PD

kp=6.847;
kd= [0,1,5]; %Error en respuesta?

figure(5); 
hold on;
for i = 1:length(kd)
    Gc = kp + tf([kd(i) 0],[1]);
    FTLA = Gp*Gc;
    
    FTLC = feedback(FTLA,1);
    step(FTLC);
end

figure(6);
rlocus(FTLA);

%% PID
Kp = 6.178;
Ki = 1;
Kd = 0;

Gc = Kp + tf([Ki],[1 0]) + tf([kd 0],[1]);
FTLA = Gp*Gc;
figure(7);
rlocus(FTLA);
