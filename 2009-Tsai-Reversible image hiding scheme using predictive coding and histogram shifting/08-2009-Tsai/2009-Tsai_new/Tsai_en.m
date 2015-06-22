function [stegoI,maxbinL,maxbinR,z,Mlength,LSBlength]=Tsai_en(I,S)
bs=3;
% �q�X�v�����Ҧ���0�B255�������ȡA���ର�G�i��
LM=(I==255 | I==0);            % ��Ҧ�0�M255�ܬ�1
CLM=calic8en(LM);              % ���Y�v��LM
CLM=(dec2bin(CLM,8))-48;       % �ܬ��G�i��
CLM=CLM(:,:)';                 % ��d���ܬ����C����
CLM=CLM(:)';
% ��v�����Ҧ�0�P255���O�ܦ�1�P254
I2=I;                          % ��I�]��I2
I2(I==0)=1;                    % ��0�]��1
I2(I==255)=254;                % ��255�]��254
% ��XLocationMap���W��Ƥ��j�p
z=ceil(numel(CLM)/size(I2,2));        % �d����ΤC��
I2U=I2(1:z,:);                 % �d��7(z)*512(size(I2,2))
exI2U=I2U(:,:)';
exI2U=exI2U(:)';
I2L=I2(size(I2U,1)+1:size(I2,1),:);     % �d��505*512
% ���Xz��Ƥ�LSB�X
ILSB=mod(I2(1:z,:),2);         % ���X7�椤��SLB�X
ILSB=ILSB';                    % ��d��Ѧ�ܦC����
ILSB=ILSB(:)';
LSBlength=numel(ILSB);
% ����X��LBS�PS�X��
Mx=[ILSB S];                    % �j�p���Ҧ�LSB(3584)+S�j�p(50000)=53584��
% �NLocationMap�O�J��I2U
UI3=floor(I2U/2)*2;            % ��I2U�W�b���������ȺV��
UI3=UI3';
UI3=UI3(:)';
UI3=UI3(1:numel(CLM))+CLM;
% ��ѤU�������ȥ[�W
pi=round(numel(UI3)/size(I,2));     % ���X7��512�C
pi=pi*size(I,1);
pi=pi-numel(UI3);                   % ��7�檺pi2:end�d��80
% �X��UI3�[�W�̫᭱�p����
UI3=[UI3(1:end) exI2U((numel(UI3)+1):end)];   % ��e���[�W�᭱���r
UI3=reshape(UI3,size(I,2),z)';       % ���Φ�7*512
% �NM�O�JI2L
RA=floor(size(I2L,1)/bs)*bs;        % �U�b������d��
CA=floor(size(I2L,2)/bs)*bs;        % �U�b�����C�d��
NAI=I2L(1:RA,1:CA);
[row,col]=size(NAI);                % ��504*510���j�p
II=mat2cell(NAI, bs*ones(1,row/bs), bs*ones(1,col/bs));    % ���Φ�168*170�j�p
% ��XII�϶����P��������
d=zeros(numel(II),numel(II{1}));
for i=1:numel(II)
    d(i,:)=II{i}(:)-II{i}(2,2);     % ��II�϶����P��������
end
d(:,5)=[];
% ��Xmaxbin�Pminbin�A����shift����(�i�O�J����P�k��)
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
% ��p�I��T�����I�첾�@�Ӯt��
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
% �N�X�֤�S�p��i�O�J�����סA�p�W�L�i�O�J���Ŷ��ƫh��ܥX���T��
if length(Mx)>payload
    fprintf('LocationMap�P���K��TS���`�M�v�W�L�̤j���q�A�д�־��K��T���O�J�q\n')
    fprintf('LocationMap�P���K��TS�һݪ��Ŷ���=%d\n',length(Mx))
    fprintf('��ڤw�O�J��LocationMap�P���K��TS���`�M��=%d\n',payload)
    Mx=Mx(1:payload);
    Mlength=length(Mx);
else
    Mlength=length(Mx);
end
% ���T�O�J��md2��
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
% M����p���ର�j��
M=zeros(size(md,1),size(md,2));
for r=1:size(md2,1)
    for c=1:size(md2,2)
        M(r,c)=md2(r,c)+II{r}(2,2);
    end
end
% NEWS����ŭȶ�ɦ^��Ӧ�m
NEWS=zeros(numel(II),numel(II{1}));
for r=1:size(d,1)
    NEWS(r,:)=[M(r,1:4) II{r}(2,2) M(r,5:8)];
end
% Stego���إ�170��cell
stego=cell(II);
for r=1:numel(II)
    stego{r}=zeros(3);
    stego{r}(:)=NEWS(r,:)';
end
% ��M��X��stego�k�^�v��
stego2=I2L;
stego2((1:RA),(1:CA))=cell2mat(stego);
stegoI=[UI3;stego2];