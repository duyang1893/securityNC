% ax+by mod n = gcd(a,b) mod n. 
% Classical algirthm finding gcd of two numbers in  mod(n) filed

function [oldx, oldy, gcd_ab]= extended_Euclidean_mod(a,b,n)
    if a<b
        tmp=a; a=b; b=tmp;
        flag =1;
    else 
        flag =0;
    end
    x =0; oldx=1;
    y =1; oldy=0;
    while b~=0
        d = mod(floor(a/b),n);
        r = mod(a-b*d,n);         
        a = b;    
        b = r;
 
        tmp = mod(oldx-d*x,n);
        oldx = x;
        x=tmp;
        
        tmp=mod(oldy-d*y,n);
        oldy=y;
        y=tmp;    
    end
    if flag==1
        tmp=oldx;
        oldx=oldy;
        oldy=tmp;
    end
    gcd_ab = a;
end
