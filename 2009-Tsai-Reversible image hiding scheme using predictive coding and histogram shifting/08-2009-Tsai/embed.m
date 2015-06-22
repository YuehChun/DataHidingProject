function [Stego,L,EmbMsg,RemMsg]=embed(Img,Msg,peak1,peak2)
I=Img;
SLEN=length(Msg);
[m,n]=size(I);
IS=I;
E=zeros(1,numel(I));
Scnt=0;
cnt=0;
flag=0;
L=[m-1,n-1];
row=1;
for i=2:3:m-1;
    col=1;
    for j=2:3:n-1
        bm=I(i,j);      % midddle base pixel
        
        pl=bm;
        pu=bm;
        pr=bm;
        pd=bm;
        plu=bm;
        pru=bm;
        pld=bm;
        prd=bm;
        
        % error calculation and conceal data
        E(cnt+1)=I(i,j-1)-pl;
        [IS(i,j-1),emb]=conceal(E(cnt+1),Msg(Scnt+1),pl,peak1,peak2);
        Scnt=Scnt+emb;
        if Scnt==SLEN
            flag=1;
            break
        end
        
        E(cnt+2)=I(i-1,j)-pu;
        [IS(i-1,j),emb]=conceal(E(cnt+2),Msg(Scnt+1),pu,peak1,peak2);
        Scnt=Scnt+emb;
        if Scnt==SLEN
            flag=1;
            break
        end
        
        E(cnt+3)=I(i,j+1)-pr;
        [IS(i,j+1),emb]=conceal(E(cnt+3),Msg(Scnt+1),pr,peak1,peak2);
        Scnt=Scnt+emb;
        if Scnt==SLEN
            flag=1;
            break
        end
        
        E(cnt+4)=I(i+1,j)-pd;
        [IS(i+1,j),emb]=conceal(E(cnt+4),Msg(Scnt+1),pd,peak1,peak2);
        Scnt=Scnt+emb;
        if Scnt==SLEN
            flag=1;
            break
        end
        
        E(cnt+5)=I(i-1,j-1)-plu;
        [IS(i-1,j-1),emb]=conceal(E(cnt+5),Msg(Scnt+1),plu,peak1,peak2);
        Scnt=Scnt+emb;
        if Scnt==SLEN
            flag=1;
            break
        end
        
        E(cnt+6)=I(i-1,j+1)-pru;
        [IS(i-1,j+1),emb]=conceal(E(cnt+6),Msg(Scnt+1),pru,peak1,peak2);
        Scnt=Scnt+emb;
        if Scnt==SLEN
            flag=1;
            break
        end
        
        E(cnt+7)=I(i+1,j+1)-prd;
        [IS(i+1,j+1),emb]=conceal(E(cnt+7),Msg(Scnt+1),prd,peak1,peak2);
        Scnt=Scnt+emb;
        if Scnt==SLEN
            flag=1;
            break
        end
        
        E(cnt+8)=I(i+1,j-1)-pld;
        [IS(i+1,j-1),emb]=conceal(E(cnt+8),Msg(Scnt+1),pld,peak1,peak2);
        Scnt=Scnt+emb;
        if Scnt==SLEN
            flag=1;
            break
        end
        cnt=cnt+8;
        col=col+1;
    end
    if flag==1
        L=[i,j];
        break
    end
    row=row+1;
end
%E=round(E(1:cnt));
Stego=IS;
EmbMsg=Msg(1:Scnt);
RemMsg=Msg(Scnt+1:end);
