%Seccion: analisis de estabilidad

num=[2580];
den=[12664 1];
Gp = tf(num,den)

%% Proporcional
kp = [2,5,7];
figure(1)
hold on;
for i = 1:length(kp)
    Gc = kp(i);
    FTLA = Gp*Gc;
    FTLC = feedback(FTLA,1);
    step(FTLC);
end
legend('Kp=2', 'Kp=10', 'Kp=45');

figure(2);
rlocus(FTLA)


%% PI
kp = 6.77;
ki = [.5,10,1.38];

figure(3); 
hold on;
for i = 1:length(ki)
    Gc = kp + tf([ki(i)],[1 0]);  % =(Kp*s + Ki)/s, es decir se introduce un polo en s=0 y un cero en s=Ki/Kp
    
    FTLA = Gp*Gc
    FTLC = feedback(FTLA,1);
    step(FTLC);
end
legend('Kp=6.77, Ki=0.5', 'Kp=6.77, Ki=10', 'Kp=6.77, Ki=1.38');

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
legend('Kp=6.847, Kd=0', 'Kp=6.847, Kd=1', 'Kp=6.847, Kd=5');

figure(6);
rlocus(FTLA);

%% PID
Kp = 6.178;
Ki = 1.38;
Kd = 5;

Gc = Kp + tf([Ki],[1 0]) + tf([Kd 0],[1])
FTLA = Gp*Gc;
figure(7);
rlocus(FTLA);
