function [RI,RS]=Tsai_de(stegoI,maxbinL,maxbinR,z,Mlength,LSBlength)
bs=3;
% ��Ҧ���0�B255�������ȡA�q�G�i���ର�칳����
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
% ���XI2L��������
I2L=numel(CLM)/size(stegoI,2);
I2L=stegoI(I2L+1:end,1:size(stegoI,2));
RA=floor(size(I2L,1)/bs)*bs;        % �U�b������d��
CA=floor(size(I2L,2)/bs)*bs;        % �U�b�����C�d��
NAI=I2L(1:RA,1:CA);
[row,col]=size(NAI);                % ��504*510���j�p
II=mat2cell(NAI, bs*ones(1,row/bs), bs*ones(1,col/bs));    % ���Φ�168*170�j�p
% ��XII�϶����P��������
d=zeros(numel(II),numel(II{1}));
for i=1:numel(II)
    d(i,:)=II{i}(:)-II{i}(2,2);
end
d(:,5)=[];
% ���XS
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
% ��s���Φ��G����
Slocation=S(1:LSBlength);
Slocation2=reshape(Slocation,512,z)';
RS=S(LSBlength+1:end);
% ��shift�٭���l��m
RD2=zeros(size(d));
for r=1:size(d,1)
    for c=1:size(d,2)
        if RD(r,c)<maxbinL
            RD2(r,c)=RD(r,c)+1;
        elseif RD(r,c)>maxbinR
            RD2(r,c)=RD(r,c)-1;
        else
            RD2(r,c)=RD(r,c);                      %RD2���w�٭���l��m
        end
    end
end
% ��ܥXcover image
DD=zeros(size(RD2,1),size(RD2,2));
for r=1:size(RD2,1)
    for c=1:size(RD2,2)
        DD(r,c)=RD2(r,c)+II{r}(2,2);                %DD���w��p���ܦ��j��
    end
end
% �⤤���ȥ[�^���
ND=zeros(numel(II),numel(II{1}));
for r=1:size(d,1)
    ND(r,:)=[DD(r,1:4) II{r}(2,2) DD(r,5:8)];
end
% �٭즨3*3�x�}
NEWD=cell(II);
for r=1:numel(II)
    NEWD{r}=zeros(3);
    NEWD{r}(:)=ND(r,:)';
end
% �٭�Slocation2��
C=stegoI(1:z,1:size(stegoI,2));
C=floor(C/2)*2;
Slocation3=Slocation2+C;
% �٭즨�v��
ReI=stegoI;
ReI(1:z,1:size(stegoI,2))=Slocation3;
ReI(z+1:511,1:510)=cell2mat(NEWD);
% ��v�����Ҧ�1�P254���O�ܦ�0�P255
RI=ReI;
RI(RLM2==1 & ReI==1)=0;
RI(RLM2==1 & ReI==254)=255;