function [b_0, c_1] = Horner(coeff, x)
    m = length(coeff);
    h = zeros(m, 3);
    h(:,1) = coeff;
    h(1,2) = h(1,1);
    h(1,3) = h(1,1);
    for i = 2 : m
        h(i,2) = h(i,1) + x*h(i-1,2);
    end
    
    for i = 2 : m
        h(i,3) = h(i,2) + x*h(i-1,3);       
    end

    b_0 = h(m,2);
    c_1 = h(m-1,3);
end

