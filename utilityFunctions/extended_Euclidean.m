%If a and b are n-bit numbers,the algorithm terminates after O(n) iterations.
%the cost of one iteration is dominated by the cost of the division and the multiplication O(n^2)
%the total running time of the algorithm is bounded by O(n^3).

%Theorem 2.3. The extended Euclidean algorithm applied to polynomials of
%degree n over any field runs in O(n2) field operations.

% example gcd(721,518)=23*721-32*518=7

% The solution of [x,y,gcd(a,b)] is unique; and gcd(a,b) is the smallest
% positive value of ax+by. 

function [oldx oldy a]= extended_Euclidean(a,b)
    if a<b
        tmp=a; a=b; b=tmp;
        flag =1;
    else 
        flag =0;
    end
    x =0; oldx=1;
    y =1; oldy=0;
    while b~=0
        d = floor(a/b);
        r = a-b*d;         
        a = b;    
        b = r;
 
        tmp = oldx-d*x;
        oldx = x;
        x=tmp;
        
        tmp=oldy-d*y;
        oldy=y;
        y=tmp;    
    end
    if flag==1
        tmp=oldx;
        oldx=oldy;
        oldy=tmp;
    end
end
