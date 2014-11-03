% Z. Yu, Y. Wei, B. Ramkumar, and Y. Guan,...
% “An Efficient Signature-Based Scheme for Securing Network Coding Against Pollution Attacks,”
% in 2008 IEEE INFOCOM - The 27th Conference on Computer Communications, 2008, pp. 1409–1417.
% The alternative method

% copy function mod_exp from the /utilityFunction folder 

q = 7;         % modular field size
p = 43;        % modular filed size; p-1 = k*q;
element_order = zeros(1,p-1);
for i=1:p-1
    tmp = mod_exp(i,1:(p-1),p);
    index = find(tmp==1);
    element_order(i) = index(1);    
end
g_potential = find(element_order==q);
g = g_potential(1);

n = 3;          % packet length in symbols
m = 2;           % number of packets per generation
X = randi(q-1,m,n); % one generation of data, size(m,n)
X = [eye(m,m) X];                         % eye(m,m) RLNC coefficients


% %% Homomorphic subspace signature (data+signature orthogonal with the priviate key vector)
beta = randi(q-1,1,(m+n));       % private key;
h = mod_exp(g,beta,p);           % expoential function of a order-q element in Modular-p
X_pad = [X zeros(m,1)];          % each paket pad one symbol
for i=1:m
    pad = mod(X(i,:)*beta',q);
    X_pad (i,end)=pad;
end
alpha = randi(q-1,1,m);
x_coded = mod(alpha*X_pad,q);

left_side = mod_exp(g,x_coded(end),p);
delta = mod_exp(h(1),x_coded(1),p);
for i=2:(m+n)
    delta = delta*mod_exp(h(i),x_coded(i),p);
    delta = mod(delta,p);
end
if delta==left_side
    sprintf('verify=true')
else
    sprintf('verify=flase')
end
 
