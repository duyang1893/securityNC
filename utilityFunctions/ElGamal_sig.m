%% ElGamal_sig example using fixed data
q = 19;     % public prime number
alpha = 10;  % public primitive root of q;
XA = 16;      % private secret of A, randomly chosen
YA = mod_exp(alpha,XA,q);  % public key {q,alpha,YA}
% Alice using the private key to sign a msg 
m = 14;    % Alice want to transmit message M, m = H(M)
K = 5;     % randomly chosen by Alice, gcd(K, q-1)=1
S1 = mod_exp(alpha,K,q);
[~,K_inv,~]=extended_Euclidean_mod(q-1,K,q-1);
S2 = mod(K_inv*(m-XA*S1),q-1); 
% Bob verify the signature
V1 = mod_exp(alpha,m,q);
V2 = mod(mod_exp(YA,S1,q)*mod_exp(S1,S2,q),q);
if V1==V2
    sprintf('Verification successed')   
else
    sprintf('Verification failed')
end

%% ElGamal_sig example using randomly generated values
nbits_q = 4;            % number of bits for q
q = 2^nbits_q+1;        % public
while ~isprime(q)
    ntest_q = ntest_q+1;
    q = q+2;
end
% finding primitive root of q using brute force method. any efficient alg?
element_order = zeros(1,q-1);
for i=1:q-1
    tmp = mod_exp(i,1:(q-1),q);
    index = find(tmp==1);
    element_order(i) = index(1);    
end
primitive_root = find(element_order==q-1);
alpha = primitive_root(1);     % public

XA = randi(q-1);               % private key XA\in (1,q-1)
YA = mod_exp(alpha,XA,q);      % public key {alpha,q,YA}
m = randi(q-1);                % m=H(M), m\in [1,q-1]
gcd_K_qm1 = 2;                 % chose K and K\in [1,q-1], gcd(K,q-1)=1
while gcd_K_qm1~=1;
    K = randi(q-1);
    [~,K_inv,gcd_K_qm1]=extended_Euclidean_mod(q-1,K,q-1);
end
S1 = mod_exp(alpha,K,q);
S2 = mod(K_inv*(m-XA*S1),q-1); 
% Bob verify the signature
V1 = mod_exp(alpha,m,q);
V2 = mod(mod_exp(YA,S1,q)*mod_exp(S1,S2,q),q);
if V1==V2
    sprintf('Verification successed')   
else
    sprintf('Verification failed')
end



