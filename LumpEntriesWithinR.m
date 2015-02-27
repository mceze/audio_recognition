function [ N, X ] = LumpEntriesWithinR( Nold,Xold, R )
%this function lumps entries in "Xold" that are within "R"
%assumption: Xold is ordered

if (Nold == 1)
    N = Nold;
    X = Xold(1);
else 
    org = Xold(1); %first center
    k = 1;
    sum = org;
    kin = 1;
    for j = 2:Nold
        if (abs(Xold(j)-org) <= R)
            sum = sum + Xold(j);
            kin = kin + 1;
            org = sum/kin;
        else
            X(k) = org;
            k = k + 1;
            org = Xold(j);
            sum = org;
            kin = 1;            
        end
        if (j == Nold)
            %store last
            X(k) = org;
            k = k + 1;
        end
    end
    N = k-1;
end
end

