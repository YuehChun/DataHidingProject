I=double((imread('lena_gray.tiff')));
%I=double(rgb2gray(I));

[peak1,peak2,EC]=getInfo(I);
S=randint(1,26000,[0 1],100);
[Stego,L,EmbMsg,RemMsg]=embed(I,S,peak1,peak2);
length(EmbMsg)
PSNR(Stego,I)

%%
[feq0,bin0]=hist(I(1:2:end)-I(2:2:end),-255:255);
[~,~,~,E0]=getInfo(I);
[~,~,~,E]=getInfo(Stego);
[feq,bin]=hist(E,min(E):max(E));
[feq0,bin0]=hist(E0,min(E0):max(E0));
hold on
plot(bin,feq,'s-')
plot(bin0,feq0,'ro-')
axis([-20,20,0,25000])


%%
[peak1,peak2,EC]=getInfo(I);

bpp=[];
psr=[];
minPL=5000;
maxPL=EC;
cnt=0;

for SLEN=round(minPL+(maxPL-minPL)*linspace(0,1,16).^1.2)
    cnt=cnt+1;
    S=randint(1,SLEN,[0 1],100);
    [Stego,L,EmbMsg,RemMsg]=embed(I,S,peak1,peak2);
    bpp(cnt)=length(EmbMsg)/numel(I);
    psr(cnt)=PSNR(Stego,I);
end

hold on
plot(bpp,psr,'m>-');

%%  For highPayload

Ori=double((imread('Baboon_gray.tiff')));
[peak1,peak2,EC]=getInfo(Ori);
S=randint(1,2000,[0 1],100);
[Stego,L,EmbMsg,RemMsg]=embed(Ori,S,peak1,peak2);
b1=length(EmbMsg)/numel(Ori)
p1=PSNR(Stego,Ori);

S=randint(1,7000,[0 1],100);
[Stego,L,EmbMsg,RemMsg]=embed(Ori,S,peak1,peak2);
b2=length(EmbMsg)/numel(Ori);
p2=PSNR(Stego,Ori);

I=Ori;
eSLEN=0;
bpp=[];snt=[];

for i=1:8
  [peak1,peak2,EC]=getInfo(I);
  S=randint(1,200000,[0 1],100);
  [Stego,L,EmbMsg,RemMsg]=embed(I,S,peak1,peak2);
  eSLEN=eSLEN+length(EmbMsg);
  bpp(i)=eSLEN/numel(I);
  snr(i)=PSNR(Stego,Ori);
  I=Stego;
end

plot([b1 b2 bpp],[p1,p2 snr],'m>-');
