function data =  RLNC_decoder(coded_packet,GF_q,GF_m,num_packets)
    [row col]=size(coded_packet);
    number_of_symbol = col/GF_m-num_packets;
    
    if row<num_packets
        sprintf('The number of coded packet is not enough')
        data = [];
    else
        header = coded_packet(:,1:GF_m*num_packets);
        header_gf = gf(randi(GF_q-1,row,num_packets),GF_m);
        for i=1:row
            header_gf(i,:) = gf((2.^(GF_m-1:-1:0))*reshape(header(i,:),GF_m,num_packets),GF_m);
        end
        if rank(header_gf)<num_packets
             sprintf('The number of independent coded packets is not enough')
             data = [];           
        else
            coded_data = coded_packet(:,GF_m*num_packets+1:end);
            coded_data_gf = gf(randi(GF_q-1,row,number_of_symbol),GF_m);
            for i=1:row
                coded_data_gf(i,:) = gf((2.^(GF_m-1:-1:0))*reshape(coded_data(i,:),GF_m,number_of_symbol),GF_m);
            end
            data_gf = header_gf\coded_data_gf;
            data = integer_to_binary(double(data_gf.x),GF_m);
        end
    end
end
