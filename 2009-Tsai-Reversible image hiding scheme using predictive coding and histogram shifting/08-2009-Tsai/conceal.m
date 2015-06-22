function [Is,emb,E]=conceal(E,b,P,peak1,peak2)
if peak1>peak2     % peak1 ¸û¤j
    if E==peak1    % embeddable
        emb=1;
        if b==1
            E=E+1;
        end
    elseif E==peak2
        emb=1;
        if b==1
            E=E-1;
        end
    elseif E>peak1
        emb=0;
        E=E+1;
    elseif E<peak2
        emb=0;
        E=E-1;
    else
        emb=0;
    end
else
    if E==peak1    % embeddable
        emb=1;
        if b==1
            E=E-1;
        end
    elseif E==peak2
        emb=1;
        if b==1
            E=E+1;
        end
    elseif E<peak1
        emb=0;
        E=E-1;
    elseif E>peak2
        emb=0;
        E=E+1;
    else
        emb=0;
    end
end
Is=E+P;



