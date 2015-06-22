%% 利用【tiffany_gray】為CoverImage，機密資訊S為亂數5000，帶入Tsai的方法
I=double(imread('tiffany_gray.tiff'));
S=randint(1,50000,[0,1],998);
%% 在原始嵌入LocationMap的方法中，與此方法有些稍許不同之處，在於把位置轉為二進位後嵌入影像所需之行數的上半部
[stegoI,maxbinL,maxbinR,z,Mlength,LSBlength]=Tsai_en(I,S);
[RI,RS]=Tsai_de(stegoI,maxbinL,maxbinR,z,Mlength,LSBlength);
%% 驗算原始影像I與StegoImage相減後的值是否為零
sum(abs(RI(:)-I(:)))
%% 驗算嵌入的機密資訊與取出的機密資訊相減後的值是否為零
S=S(1:numel(RS));
sum(abs(RS(:)-S(:)))