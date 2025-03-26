%% Filtracja częstotliwościowa
Fs=100;
t=-5:1/Fs:20;
%stworzenie 5 sygnałów (składowych) dla sygnału x
x1=1.5*(1-abs(t+1)/4).*(abs(t+1)<4); % s. trójkątny
x2=1.7*exp(-(t-9).*(t-9)/(2*8)); % f. Gaussa
x3=0.7*sin(2*pi*t.*(-3*t/25 + 22/5)); % s. harmoniczny
x4=(0.02*t+0.4).*sin(13*2*pi*t); % s. harmoniczny o modulowanej amplitudzie
x5=0.1+0.2*randn(size(t)); % szum

% sygnał do filtracji, złożony z powyższych składowych
x=x1+x2+x3+x4+x5;

f2=figure;
figure(f2);
subplot(2,4,1), plot(t,x1),title("Składowa x_1");
subplot(2,4,2), plot(t,x2),title("Składowa x_2");
subplot(2,4,3), plot(t,x3),title("Składowa x_3");
subplot(2,4,4), plot(t,x4),title("Składowa x_4");
subplot(2,4,5:8),plot(t,x), title("Sygnał do filtracji");


XT=fftshift(fft(x)); % widmo częstotliwościowe
WA=abs(XT); % widmo amplitudowe
f=linspace(-Fs/2,Fs/2,length(t));

%stosujemy filtr ciągły typu BandStop 
% wycinamy składową x4
N=4; w=1; f0=13; % parametry filtru, N=rząd, w=szerokość filtra
BS2=1.0 ./(1+((w*f./(f.^2-f0.^2)).^(2*N))); % wycinamy w f0
xn=real(ifft(ifftshift(XT.*BS2))); % sygnał po filtracji

f3=figure;
figure(f3);
subplot(2,1,1), plot(t,x,'g',t,xn,'r')
title('Sygnał przed i po filtracji');
legend('Sygnał bazowy','Sygnał po filtracji')
subplot(212), plot(f,WA,'b',f,BS2*300);
legend('Widmo amplitudowe','filtr BandStop')