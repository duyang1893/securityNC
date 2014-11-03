%% ElGamal example using fixed data
q = 19;     % public prime number
alpha = 10;  % public primitive root of q;
XA = 5;      % private secret of A, randomly chosen
YA = mod_exp(alpha,XA,q);  % public key {q,alpha,YA}
% Bob using the public key to encrypt a msg 
M = 17;    % Bob wants to send a message M
k = 6;     % randomly chosen by Bob
K = mod_exp(YA,k,q);
C1 = mod_exp(alpha,k,q);
C2 = mod(K*M,q);
% Alice decrypt the message
KA = mod_exp(C1,XA,q);
[~,KA_inv,~]=extended_Euclidean_mod(q,KA,q);
M_decrypt = mod(C2*KA_inv,q);

%% ElGamal example using randomly generated values
nbits_q = 4;            % number of bits for q
q = 2^nbits_q+1;        % private
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
alpha = primitive_root(1);
XA = randi(q-1);
YA = mod_exp(alpha,XA,q);
M = randi(q-1);
k = randi(q-1);
K = mod_exp(YA,k,q);
C1 = mod_exp(alpha,k,q);
C2 = mod(K*M,q);
% Alice decrypt the message
KA = mod_exp(C1,XA,q);
[~,KA_inv,~]=extended_Euclidean_mod(q,KA,q);
M_decrypt = mod(C2*KA_inv,q);

%% Attack: calculate XA=dlog(alpha,q,YA) or k = dlog(alpha,q,K);
% q must be 300 decimal-digit long, and q-1 must contain at least one large
% prime factor

