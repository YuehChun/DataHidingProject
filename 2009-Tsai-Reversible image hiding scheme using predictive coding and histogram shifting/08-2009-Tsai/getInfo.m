function [peak1,peak2,EC,E]=getInfo(Img)
% Embv: The embedding capacity for each threshold.
% V: variance of each block;
I=Img;
[m,n]=size(I);
cnt=0;
E=zeros(1,numel(I));
row=1;
% First loop. Find peak values ---------------------------------------
for i=2:3:m-1;
    col=1;
    for j=2:3:n-1
        bm=I(i,j);
        pl=bm;
        pu=bm;
        pr=bm;
        pd=bm;
        plu=bm;
        pru=bm;
        pld=bm;
        prd=bm;
        E(cnt+1)=I(i,j-1)-pl;
        E(cnt+2)=I(i-1,j)-pu;
        E(cnt+3)=I(i,j+1)-pr;
        E(cnt+4)=I(i+1,j)-pd;
        E(cnt+5)=I(i-1,j-1)-plu;
        E(cnt+6)=I(i-1,j+1)-pru;
        E(cnt+7)=I(i+1,j+1)-prd;
        E(cnt+8)=I(i+1,j-1)-pld;
        cnt=cnt+8;
        col=col+1;
    end
    row=row+1;
end

E=round(E(1:cnt));
[feq,bin]=hist(E,min(E):max(E));
[m1,pos1]=max(feq);
feq(pos1)=0;
[m2,pos2]=max(feq);
EC=m1+m2;
peak1=bin(pos1);
peak2=bin(pos2);

% Second loop. Get embeddable bits for each threshold -----------------

cnt=0;
E=zeros(1,numel(I));
row=1;
for i=2:3:m-1;
    col=1;
    for j=2:3:n-1
        bm=I(i,j);
        pl=bm;
        pu=bm;
        pr=bm;
        pd=bm;
        plu=bm;
        pru=bm;
        pld=bm;
        prd=bm;
        E(cnt+1)=I(i,j-1)-pl;
        E(cnt+2)=I(i-1,j)-pu;
        E(cnt+3)=I(i,j+1)-pr;
        E(cnt+4)=I(i+1,j)-pd;
        E(cnt+5)=I(i-1,j-1)-plu;
        E(cnt+6)=I(i-1,j+1)-pru;
        E(cnt+7)=I(i+1,j+1)-prd;
        E(cnt+8)=I(i+1,j-1)-pld;
        cnt=cnt+8;
        col=col+1;
    end
    row=row+1;
end
E=round(E(1:cnt));

