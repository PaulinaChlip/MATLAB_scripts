%% Korelacja
a=load("corr_02.txt"); %plik z sygnałami
t=a(:,1)';
x=a(:,2)';
dt=t(2)-t(1);
ts=-200:dt:200;

% sygnał trójkątny o szerokości 10 i amplitudzie 1
tt=0:dt:10;
trojk=(1-abs(tt-5)/5).*(abs(tt-5)<5);

% szukanie wśród sygnałów wczytanych z pliku sygnału zdefiniowanego powyżej
xt=xcorr(1-x,1-trojk)+xcorr(x,trojk);
nr=find(xt==max(xt),3,"first");
ts(nr)

% funkcja Gaussa o środku w 145, amplituda 0.8
tg=0:dt:25;
gauss=0.8*exp(-((tg).^2)/(2*5^2));

% szukanie wśród sygnałów wczytanych z pliku sygnału zdefiniowanego powyżej
xg=xcorr(1-x,1-gauss)+xcorr(x,gauss);
nr=find(xg==max(xg),3,"first");
ts(nr)

f1=figure;
figure(f1);
subplot(211);
hold on
plot(t,x,'r') %sygnał wczytany z pliku
plot(tt+1,trojk,'b'); % kolorem niebieskim znaleziony s. trójkątny
plot(tg+145,gauss,'g'); % kolorem zielonym znaleziona funkcja Gaussa
hold off
title('Sygnały syntetyczne');
legend('sygnał z pliku','s. trójkątny','s. Gaussa','Orientation','horizontal')
legend('boxoff');


subplot(212),plot(ts,xt,'r',ts,xg,'b')
title('Korelacja sygnałów z pliku ze zdefiniowanymi sygnałami');
legend('korelacja z s. trójkątnym', 'korelacja z s. Gaussa',Location='northwest')
legend('boxoff');
