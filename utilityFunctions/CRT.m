% Chinese reminder theorem
% vector_m={m1,m2,...,mk}, gcd(mi,mj)=1, \for all i\neq j;
% vector_c={c1,c2,...,ck}; c mod mi = ci mod mi; 
% This alg contruct the value of c, called constrct_c
% example: a = CRT([2 3 5],[0 2 4]), return a = 14; 

function construct_c = CRT(vector_m,vector_c)
    M = 1;
    for k=1:length(vector_m)
        M = M*vector_m(k);
    end
    
    Nk = zeros(1,length(vector_m));
    Mk = zeros(1,length(vector_m));
    for k=1:length(vector_m)
        Mk(k) = M/vector_m(k);
        [Nk(k),~,~]=extended_Euclidean_mod(Mk(k),vector_m(k),M);
    end
    
    construct_c = 0;
    for k = 1:length(vector_m)
        construct_c = mod(construct_c+mod(vector_c(k)*Nk(k)*Mk(k),M),M); 
    end 
end

