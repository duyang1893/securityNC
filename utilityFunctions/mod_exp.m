% Calculate base^exponent mod p
% base is an integer
% exponent could one integer or a vector of integers
% p is an integer
function result = mod_exp(base,exponent,p)
    L = length(exponent);
    result = ones(1,L);
    for j = 1:L
%         % calculate base^b mod p; 
%         % b is expressed in k-bits; 
%         b = exponent(j);
%         k = ceil(log2(b));
%         % move from the highest k-th bits to the lowest 1-th bit
%         for i=k:-1:1
%             result(j) = mod(result(j)*result(j),p); 
%             q = floor(b/2); t = mod(b,2);
%             if t==1
%                 result(j) = mod(result(j)*base,p);
%             end
%             b = q;
%         end
%         
        for i=1:exponent(j)
            result(j) = mod(result(j)*base,p);        
        end
    end
end
