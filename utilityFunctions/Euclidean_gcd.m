%If a and b are n-bit numbers,the algorithm terminates after O(n) iterations.
%the cost of one iteration is dominated by the cost of the division and the multiplication O(n^2)
%the total running time of the algorithm is bounded by O(n^3).

% example (721,518)
%721 = 518 + 203
%518 = 2 · 203 + 112
%203 = 112 + 91
%112 = 91 + 21
%91 = 4 · 21 + 7
%21 = 3 · 7

function x = Euclidean_gcd (a,b)
    if a<b
        tmp=a; a=b; b=tmp;
    end
    while b~=0
        d = floor(a/b);
        r = a-b*d; 
        
        a = b;    
        b = r;
    end
    x=a;
end
