%% �Q�Ρitiffany_gray�j��CoverImage�A���K��TS���ü�5000�A�a�JTsai����k
I=double(imread('tiffany_gray.tiff'));
S=randint(1,50000,[0,1],998);
%% �b��l�O�JLocationMap����k���A�P����k���ǵy�\���P���B�A�b����m�ର�G�i���O�J�v���һݤ���ƪ��W�b��
[stegoI,maxbinL,maxbinR,z,Mlength,LSBlength]=Tsai_en(I,S);
[RI,RS]=Tsai_de(stegoI,maxbinL,maxbinR,z,Mlength,LSBlength);
%% ����l�v��I�PStegoImage�۴�᪺�ȬO�_���s
sum(abs(RI(:)-I(:)))
%% ���O�J�����K��T�P���X�����K��T�۴�᪺�ȬO�_���s
S=S(1:numel(RS));
sum(abs(RS(:)-S(:)))