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
