function [stegoI,maxbinL,maxbinR,z,Mlength,LSBlength]=Tsai_en(I,S)
bs=3;
% 秀出影像中所有為0、255的像素值，並轉為二進位
LM=(I==255 | I==0);            % 把所有0和255變為1
CLM=calic8en(LM);              % 壓縮影像LM
CLM=(dec2bin(CLM,8))-48;       % 變為二進位
CLM=CLM(:,:)';                 % 把範圍變為行到列執行
CLM=CLM(:)';
% 把影像中所有0與255分別變成1與254
I2=I;                          % 把I設給I2
I2(I==0)=1;                    % 把0設為1
I2(I==255)=254;                % 把255設為254
% 找出LocationMap之上行數之大小
z=ceil(numel(CLM)/size(I2,2));        % 範圍佔用七行
I2U=I2(1:z,:);                 % 範圍為7(z)*512(size(I2,2))
exI2U=I2U(:,:)';
exI2U=exI2U(:)';
I2L=I2(size(I2U,1)+1:size(I2,1),:);     % 範圍為505*512
% 取出z行數之LSB碼
ILSB=mod(I2(1:z,:),2);         % 取出7行中的SLB碼
ILSB=ILSB';                    % 把範圍由行至列執行
ILSB=ILSB(:)';
LSBlength=numel(ILSB);
% 把取出的LBS與S合併
Mx=[ILSB S];                    % 大小為所有LSB(3584)+S大小(50000)=53584個
% 將LocationMap嵌入於I2U
UI3=floor(I2U/2)*2;            % 把I2U上半部的像素值敲掉
UI3=UI3';
UI3=UI3(:)';
UI3=UI3(1:numel(CLM))+CLM;
% 把剩下的像素值加上
pi=round(numel(UI3)/size(I,2));     % 取出7行512列
pi=pi*size(I,1);
pi=pi-numel(UI3);                   % 第7行的pi2:end範圍為80
% 合併UI3加上最後面小部份
UI3=[UI3(1:end) exI2U((numel(UI3)+1):end)];   % 把前面加上後面的字
UI3=reshape(UI3,size(I,2),z)';       % 分割成7*512
% 將M嵌入I2L
RA=floor(size(I2L,1)/bs)*bs;        % 下半部的行範圍
CA=floor(size(I2L,2)/bs)*bs;        % 下半部的列範圍
NAI=I2L(1:RA,1:CA);
[row,col]=size(NAI);                % 為504*510的大小
II=mat2cell(NAI, bs*ones(1,row/bs), bs*ones(1,col/bs));    % 分割成168*170大小
% 找出II區塊中周圍減中間的值
d=zeros(numel(II),numel(II{1}));
for i=1:numel(II)
    d(i,:)=II{i}(:)-II{i}(2,2);     % 把II區塊中周圍減中間的值
end
d(:,5)=[];
% 找出maxbin與minbin，此為shift兩邊(可嵌入左邊與右邊)
md=d;
[feq,bin]=hist(d(:),min(md(:)):max(md(:)));
[bin1,pos1]=max(feq);
maxbin=bin(pos1);
feq(pos1)=0;
[bin2,pos2]=max(feq);
maxbin2=bin(pos2);
% minbinL=-inf; minbinR=inf;
payload=bin1+bin2;
if maxbin2>maxbin
    maxbinL=maxbin;
    maxbinR=maxbin2;
else
    maxbinR=maxbin;
    maxbinL=maxbin2;
end
% 把峰點資訊往谷點位移一個差值
for r=1:size(d,1)
    for c=1:size(d,2)
        if d(r,c)<=maxbinL-1
            md(r,c)=d(r,c)-1;
        elseif d(r,c)>=maxbinR+1
            md(r,c)=d(r,c)+1;
        else
            md(r,c)=d(r,c);
        end
    end
end
% 將合併之S計算可嵌入之長度，如超過可嵌入的空間數則顯示出此訊息
if length(Mx)>payload
    fprintf('LocationMap與機密資訊S的總和己超過最大載量，請減少機密資訊的嵌入量\n')
    fprintf('LocationMap與機密資訊S所需的空間為=%d\n',length(Mx))
    fprintf('實際已嵌入的LocationMap與機密資訊S的總和為=%d\n',payload)
    Mx=Mx(1:payload);
    Mlength=length(Mx);
else
    Mlength=length(Mx);
end
% 把資訊嵌入至md2中
md2=md; cnt=1;
for r=1:size(d,1)
    for c=1:size(d,2)
        if md(r,c)==maxbinL && cnt<=numel(Mx)
            if Mx(cnt)==1;
                md2(r,c)=md(r,c)-1;
            else
                md2(r,c)=md(r,c);
            end
            cnt=cnt+1;
        elseif md(r,c)==maxbinR && cnt<=numel(Mx)
            if Mx(cnt)==1;
                md2(r,c)=md(r,c)+1;
            else
                md2(r,c)=md(r,c);
            end
            cnt=cnt+1;
        end
    end
end
% M為把小值轉為大值
M=zeros(size(md,1),size(md,2));
for r=1:size(md2,1)
    for c=1:size(md2,2)
        M(r,c)=md2(r,c)+II{r}(2,2);
    end
end
% NEWS為把空值填補回原來位置
NEWS=zeros(numel(II),numel(II{1}));
for r=1:size(d,1)
    NEWS(r,:)=[M(r,1:4) II{r}(2,2) M(r,5:8)];
end
% Stego為建立170個cell
stego=cell(II);
for r=1:numel(II)
    stego{r}=zeros(3);
    stego{r}(:)=NEWS(r,:)';
end
% 把尋找出的stego歸回影像
stego2=I2L;
stego2((1:RA),(1:CA))=cell2mat(stego);
stegoI=[UI3;stego2];