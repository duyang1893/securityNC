function [header, coded_data] = RLNC_encoder(bits,GF_q,GF_m)
    % Initialization
    [number_of_packets, number_of_bits]= size(bits);               % number of uncoded packets
    number_of_symbol = number_of_bits/GF_m;
 
    % covert the input data from bits to GF symbols 
    uncoded_data_gf = gf(randi(GF_q-1,number_of_packets,number_of_symbol),GF_m);
    for i=1:number_of_packets
        uncoded_data_gf(i,:)=gf((2.^(GF_m-1:-1:0))*reshape(bits(i,:),GF_m,number_of_symbol),GF_m);
    end
    
    % Generate RLNC encoding coefficients
    header_gf = gf(randi(GF_q-1,1,number_of_packets),GF_m); % generate encoding coefficients in GF symbol
    coded_data_gf = header_gf*uncoded_data_gf;
    
    % Covert header and coded data from GF symbol to bits;
    header = integer_to_binary(double(header_gf.x),GF_m);
    coded_data = integer_to_binary(double(coded_data_gf.x),GF_m);
end
