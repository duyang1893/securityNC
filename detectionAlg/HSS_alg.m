%P. Zhang, Y. Jiang, and C. Lin, “Padding for orthogonality: efficient subspace authentication for network coding,” in INFOCOM, 2011, pp. 1026–1034.
% copy functions "mod_exp.m" and "extended_Euclidean_mod.m" from utilityFunctions/ to the current folder

p = 59;         % modular field size p
q = 29;         % modular fieled size q; q|p-1

% % Exhaustive searching for order-q mod p generators
% element_order = zeros(1,p-1);
% for i=1:p-1
%     tmp = mod_exp(i,1:(p-1),p);
%     index = find(tmp==1);
%     element_order(i) = index(1);    
% end
% g_potential = find(element_order==q);
% g=g_potential(1);

% An alternative method of constructing order-q (mod p) generator g
s = randi(p-2)+1;               % randomly generate s; 1<s<q-1
g = mod_exp(s,(p-1)/q,p);       % generate g=s^((p-1)/q) mod p;


n = 3;                                     % packet length in symbols
m = 2;                                     % number of packets per generation
X = randi(q-1,m,n);                        % one generation of data, size(m,n)
X = [eye(m,m) X];                          % eye(m,m) RLNC coefficients

% %% Homomorphic subspace signature (data+signature orthogonal with the priviate key vector)
pr_key = randi(q-1,1,(m+n+1));       % private key vector in Z_q;
pu_key = mod_exp(g,pr_key,p);        % publick key vector in Z_p;

pr_key_ls = pr_key(end);       % last symbol of privite key;
% Calculate pr_key_ls^(-1) using Extended Euclidean algorithm
% inv_pr_key_ls*pr_key_ls + 1*q = gcd(pr_key_ls,q)=1; This inverse is unique;
[inv_pr_key_ls,~,~]= extended_Euclidean_mod(pr_key_ls,q,q);  

X_pad = [X zeros(m,1)];                          % each paket pad one symbol
for i=1:m
    tmp1 = mod(X(i,:)*pr_key(1:end-1)',q);       % tmp1 = \sum_i^{m+n} X(i)*pr_key(i) mod q;
    tmp2 = mod(0-tmp1,q);                        % tmp2 = pre_key(m+n+1)*pad mod q;
    pad  = mod(inv_pr_key_ls*tmp2,q);            % caclulate padding symbol
    X_pad (i,end)=pad;
end
alpha = randi(q-1,1,m);
x_coded = mod(alpha*X_pad,q);

% verification
delta = mod_exp(pu_key(1),x_coded(1),p);
for i=2:(m+n+1)
    delta = delta*mod_exp(pu_key(i),x_coded(i),p);
    delta = mod(delta,p);
end
if delta==1
    sprintf('verify=true')
else
    sprintf('verify=flase')
end
 
