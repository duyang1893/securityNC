% J. Krigslund, J. Hansen, M. Hundebøll, D. E. Lucani, and F. H. P. Fitzek, “CORE : COPE with MORE in Wireless Meshed Networks,” 2013, no. 10, pp. 0–5.
% assumption 1)X-topology; 
% assumpiton 2)zeros packet loss; 
% assumpiton 3)one generation only;
% assumpiton 4)transmission scheduling: S1->R(D2); S2->R(D1); R->D1&D2

% Initialization
clear all;
GF_q        = 256;                               % Galios Field size =2^m : {0,1,...,2^m-1}
GF_m        = log2(GF_q);                        % m
packet_symbol = 2;                               % number of GF symbols in one packet
packet_size = packet_symbol*GF_m;                % number of bits in one packet
num_packets = 2;                                 % number of packets in one generation; generation size

S1 = struct('org_pkt',gf(zeros(num_packets,packet_symbol),GF_m),...
            'coeff',gf(zeros(num_packets,num_packets),GF_m));        
S2 = struct('org_pkt',gf(zeros(num_packets,packet_symbol),GF_m),...
            'coeff',gf(zeros(num_packets,num_packets),GF_m));
R  = struct('buffer_S1',gf([],GF_m),...
            'buffer_S2',gf([],GF_m));
D1 = struct('buffer_S1',gf([],GF_m),...
            'buffer_S2',gf([],GF_m),...
            'buffer_R',gf([],GF_m));
D2 = struct('buffer_S1',gf([],GF_m),...
            'buffer_S2',gf([],GF_m),...
            'buffer_R',gf([],GF_m));

bits = round(rand(num_packets,packet_size));     %Generate original bits in one generation
for i=1:num_packets
    S1.org_pkt(i,:)=gf((2.^(GF_m-1:-1:0))*reshape(bits(i,:),GF_m,packet_symbol),GF_m);
end
bits = round(rand(num_packets,packet_size));     %Generate original bits in one generation
for i=1:num_packets
    S2.org_pkt(i,:)=gf((2.^(GF_m-1:-1:0))*reshape(bits(i,:),GF_m,packet_symbol),GF_m);
end

for i=1:num_packets
    % S1->R(D2)
    header_gf=gf(randi(GF_q-1,1,num_packets),GF_m);
    coded_pkt = header_gf*S1.org_pkt;
    tx_pkt = [header_gf coded_pkt];
    S1.coeff(i,:)=header_gf;
    R.buffer_S1  = [R.buffer_S1; tx_pkt];
    D2.buffer_S1 = [D2.buffer_S1;tx_pkt];
    
    %S2->R(D1)
    header_gf=gf(randi(GF_q-1,1,num_packets),GF_m);
    coded_pkt = header_gf*S2.org_pkt;
    tx_pkt = [header_gf coded_pkt];
    S2.coeff(i,:)=header_gf;
    R.buffer_S2  = [R.buffer_S2; tx_pkt];
    D1.buffer_S2 = [D1.buffer_S2;tx_pkt];   
    
    %R->D1&D2
    %step1:RLNC recode  --> I2NC only recode when generating parity packets
    recode_pkt_S1 = gf(randi(GF_q-1,1,length(R.buffer_S1(:,1))),GF_m)*R.buffer_S1;
    recode_pkt_S2 = gf(randi(GF_q-1,1,length(R.buffer_S2(:,1))),GF_m)*R.buffer_S2;
    %step2:XOR payload  --> I2NC XOR both header and payload
    coded_data_S1 = recode_pkt_S1(num_packets+1:end);
    coded_data_S2 = recode_pkt_S2(num_packets+1:end);
    payload_gf = coded_data_S1+coded_data_S2;  %% This is equivalent to XOR bits
%   payload_bits = xor(integer_to_binary(double(coded_data_S1.x),GF_m), integer_to_binary(double(coded_data_S2.x),GF_m));
%   payload_gf = gf((2.^(GF_m-1:-1:0))*reshape(payload_bits,GF_m,packet_symbol),GF_m);
    %step3:appendix header  --> I2NC do not have an extended header
    tx_pkt = [recode_pkt_S1(1:num_packets) recode_pkt_S2(1:num_packets) payload_gf];
    D1.buffer_R = [D1.buffer_R; tx_pkt];
    D2.buffer_R = [D2.buffer_R; tx_pkt]; 
end

