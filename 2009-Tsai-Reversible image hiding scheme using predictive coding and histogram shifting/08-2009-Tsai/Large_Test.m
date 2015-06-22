clc
load Non_OFlow_img

pl=[];
snr=[];
for i=1:100
   name=[num2str(ImgNo(i)),'.png'];
   I=double(imread(name));
   [peak1,peak2,EC]=getInfo(I);
   S=randint(1,200000,[0 1],100);
   [Stego,L,EmbMsg,RemMsg]=embed(I,S,peak1,peak2);
   fprintf('Img:%3d, Max payload = %6d bits, PSNR = %5.2f\n',i,length(EmbMsg),PSNR(Stego,I));
   pl(i)=length(EmbMsg);
   snr(i)=PSNR(Stego,I);
end
fprintf('avg Payload= %5d, avg PSNR= %5.2f\n',round(mean(pl)),mean(snr));