function [RI,RS]=Tsai_de(stegoI,maxbinL,maxbinR,z,Mlength,LSBlength)
bs=3;
% 把所有為0、255的像素值，從二進位轉為原像素值
CLM=stegoI(1:z,1:size(stegoI,2));
CLM=mod(CLM,2);
CLM=CLM(:,:)';
CLM=CLM(:)';
RLM=reshape(CLM,length(CLM)/8,8)';
RLM=char(RLM+48);
RLM=RLM(:,:)';
RLM=RLM(:)';
RLM=reshape(RLM,8,length(RLM)/8)';
RLM=bin2dec(RLM);
RLM2=calic8de(RLM,size(stegoI,1),size(stegoI,2));
% 取出I2L的像素值
I2L=numel(CLM)/size(stegoI,2);
I2L=stegoI(I2L+1:end,1:size(stegoI,2));
RA=floor(size(I2L,1)/bs)*bs;        % 下半部的行範圍
CA=floor(size(I2L,2)/bs)*bs;        % 下半部的列範圍
NAI=I2L(1:RA,1:CA);
[row,col]=size(NAI);                % 為504*510的大小
II=mat2cell(NAI, bs*ones(1,row/bs), bs*ones(1,col/bs));    % 分割成168*170大小
% 找出II區塊中周圍減中間的值
d=zeros(numel(II),numel(II{1}));
for i=1:numel(II)
    d(i,:)=II{i}(:)-II{i}(2,2);
end
d(:,5)=[];
% 取出S
S=zeros(1,Mlength);
RD=zeros(size(d)); cnt=1;
for r=1:size(d,1)
    for c=1:size(d,2)
        if  d(r,c)==maxbinL-1 && cnt<=Mlength
            S(cnt)=1;
            RD(r,c)=d(r,c)+1;
            cnt=cnt+1;
        elseif d(r,c)==maxbinL && cnt<=Mlength
            S(cnt)=0;
            RD(r,c)=d(r,c);
            cnt=cnt+1;
        elseif d(r,c)==maxbinR+1 && cnt<=Mlength
            S(cnt)=1;
            RD(r,c)=d(r,c)-1;
            cnt=cnt+1;
        elseif d(r,c)==maxbinR && cnt<=Mlength
            S(cnt)=0;
            RD(r,c)=d(r,c);
            cnt=cnt+1;
        else
            RD(r,c)=d(r,c);
        end
    end
end
% 把s分割成二部份
Slocation=S(1:LSBlength);
Slocation2=reshape(Slocation,512,z)';
RS=S(LSBlength+1:end);
% 用shift還原到原始位置
RD2=zeros(size(d));
for r=1:size(d,1)
    for c=1:size(d,2)
        if RD(r,c)<maxbinL
            RD2(r,c)=RD(r,c)+1;
        elseif RD(r,c)>maxbinR
            RD2(r,c)=RD(r,c)-1;
        else
            RD2(r,c)=RD(r,c);                      %RD2為已還原到原始位置
        end
    end
end
% 顯示出cover image
DD=zeros(size(RD2,1),size(RD2,2));
for r=1:size(RD2,1)
    for c=1:size(RD2,2)
        DD(r,c)=RD2(r,c)+II{r}(2,2);                %DD為已把小值變成大值
    end
end
% 把中間值加回原位
ND=zeros(numel(II),numel(II{1}));
for r=1:size(d,1)
    ND(r,:)=[DD(r,1:4) II{r}(2,2) DD(r,5:8)];
end
% 還原成3*3矩陣
NEWD=cell(II);
for r=1:numel(II)
    NEWD{r}=zeros(3);
    NEWD{r}(:)=ND(r,:)';
end
% 還原Slocation2值
C=stegoI(1:z,1:size(stegoI,2));
C=floor(C/2)*2;
Slocation3=Slocation2+C;
% 還原成影像
ReI=stegoI;
ReI(1:z,1:size(stegoI,2))=Slocation3;
ReI(z+1:511,1:510)=cell2mat(NEWD);
% 把影像中所有1與254分別變成0與255
RI=ReI;
RI(RLM2==1 & ReI==1)=0;
RI(RLM2==1 & ReI==254)=255;