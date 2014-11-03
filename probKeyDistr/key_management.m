% L. Eschenauer and V. D. Gligor, “A key-management scheme for distributed sensor networks,” in Proceedings of the 9th ACM conference on Computer and communications security - CCS ’02, 2002, pp. 41–47.

%% Random Graph and connectivity

%Pc = [0.1:0.1:0.9 0.99 0.999 0.9999 0.99999 0.999999];
Pc = [0.99 0.999 0.9999 0.99999 0.999999];    % Prob of connected graph
n = 1000:1000:10000;                          % number of total nodes
c = zeros(1,length(Pc));                      
p = zeros(length(n),length(Pc));              % G(n,p), probability of exisiting an edge
d = zeros(length(n),length(Pc));              % expected degree of a node
for j = 1:length(Pc)
    c(j) = -log(-log(Pc(j)));
    for i = 1:length(n)
        p(i,j) = log(n(i))/n(i)+c(j)/n(i);
        d(i,j)= p(i,j)*(n(i)-1);
    end
end

%% relationship between pool size, key ring size,

k = [1 15 50 100 150 200];                  % key-ring size
P = [1000 2000 5000 10000 100000];          % key pool size
prob =zeros(length(k),length(P));
for i=1:length(k)
    for j = 1:length(P)
        prob(i,j)=1-((1-k(i)/P(j))^(2*P(j)-k(i)+0.5))/((1-2*k(i)/P(j))^(P(j)-2*k(i)+0.5));
    end
end    

%% Example

n_example=10000;
Pc_example = 0.99999;
n_neighbor = 40;

c_example = -log(-log(Pc_example));
p_example = log(n_example)/n_example+c_example/n_example;
d_example = p_example*(n_example-1);
prob_example_1 = d_example/(n_neighbor-1);

prob_example_2 = log(n_neighbor)/n_neighbor+c_example/n_neighbor;
d_example_2 = prob_example_2*(n_neighbor-1);

%% verification of Fig 2 and corresponding equation
sample = 10000;
P_size = 1000;
k_size = 100;
number_of_shared_keys = zeros(1,sample);
for i=1:sample
    key_a = randsample(P_size,k_size);
    key_b = randsample(P_size,k_size);
    for j=1:k_size
        number_of_shared_keys(i) =  number_of_shared_keys(i)+ sum(key_a(j)==key_b);
    end
end
prob_shared = sum(number_of_shared_keys>0)/sample;


