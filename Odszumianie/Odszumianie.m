%% Odszumianie
a=load("2023_tsd_szum_1a.txt");
t=a(:,1)';
x=a(:,2)'; %niezaszumiony
xs=a(:,3)'; %zaszumiony
dt=t(2)-t(1);
Fs=1./dt;

XT=fftshift(fft(xs));% widmo częstotliwościowe
WA=abs(XT); % widmo amplitudowe
f=linspace(-Fs/2,Fs/2,length(t));

%filtracja FFT
%stosujemy filtr ciągły typu BandStop 
w=2;N=4;f0=8.8;
BS=1.0./(1+((w*f./(f.*f-f0.*f0)).^(2*N)));
xn=real(ifft(ifftshift(XT.*BS)));

f4=figure;
figure(f4);
subplot(2,2,1), plot(t,x), title('Sygnał wejściowy niezaszumiony')
subplot(2,2,2), plot(t,xs), title('Sygnał wejściowy zaszumiony')
subplot(223), plot(t,xs,'b',t,xn,'r'),title('Sygnał przed i po filtracji');
legend('S. zaszumiony przed filtracją','S. zaszumiony po filtracji')
subplot(224), plot(f,WA,'g',f, BS*4000,'r'),title('Filtracja FFT');
legend('widmo amplitudowe','filtracja')

xs=xn;

%odszumianie
min_oc=Inf*ones(1,4);
    %pierwszy najlepszy krok w odszumianiu
    xw=medfilt1(xs,43);
    xs=xw;
    %drugi najlepszy krok
    LP2=fspecial('gaussian', [1 37], 37/4);
    xg=conv(xs,LP2,'same');
    xs=xg;
 
% for N=3:2:101
%     %filtry
%     LP=ones(1,N)/N;
%     LP2=fspecial('gaussian', [1 N], N/4);
%     xa=conv(xs,LP,'same');
%     xg=conv(xs,LP2,'same');
%     xm=medfilt1(xs,N);
%     xw=wiener2(xs,[1,N]);
% 
%     % ocena błędu każdego z filtrów
%     oc_a=sqrt(100/N * sum((x-xa).^2));
%     oc_g=sqrt(100/N * sum((x-xg).^2));
%     oc_m=sqrt(100/N * sum((x-xm).^2));
%     oc_w=sqrt(100/N * sum((x-xw).^2));
%     if oc_a<min_oc(1)
%           min_oc(1)=oc_a;
%           ka=N;
%     end
%     if oc_g<min_oc(2)
%           min_oc(2)=oc_g;
%           kg=N;
%     end
%     if oc_m<min_oc(3)
%           min_oc(3)=oc_m;
%           km=N;
%     end
%     if oc_w<min_oc(4)
%           min_oc(4)=oc_w;
%           kw=N;
%     end
% end 
% disp(min_oc); % wyświetla wektor z najmniejszymi wartościami błędu dla każdego filtra
% disp([ka kg km kw]); % wyświetla dla jakiego N wystąpiła najmniejsza wartość błędu dla każdego filtra

%subplot(211), plot(t,xs,'b',t,x,'y',t,xa,'g',t,xg,'r');
%subplot(212), plot(t,x,'b',t,xm,'g',t,xw,'r');

f5=figure;
figure(f5);
plot(t,x,'b--',t,xs,'r',t,xw,'g:',t,xg,'y:'),title('Odszumiony sygnał wraz z filtrami')
legend('Wzorcowy sygnał bez szumu','Sygnał po odszumieniu','Pierwszy użyty filtr (medianowy)', ...
    'Drugi użyty filtr (Gaussa)')
