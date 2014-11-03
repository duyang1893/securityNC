function bits = integer_to_binary(data_matrix,m)
    % initialization
    [row col]=size(data_matrix);
    bits = zeros(row,col*m);

    for r=1:row
        for c = 1:col
            data = data_matrix(r,c);
            pos = (c-1)*m+1;
            for i=1:m
                old_data = data;
                if data-2^(m-i)>=0
                    bits(r,pos+i-1)=1;
                    data = data-2^(m-i);
                else
                    bits(r,pos+i-1)=0;
                    data = old_data;
                end
            end
        end
    end
end
