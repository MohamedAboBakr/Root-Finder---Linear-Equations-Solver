function [root, errors, itr_count, TotalTime] = BirgeVieta(equation, intial_guess, max_itr, eplison)

%time starts
t=cputime;

x_new = intial_guess;

for i = 1 : max_itr
    
    itr_count = i;
    x_old = x_new;
    [b_0, c_1] = horner((sym2poly(sym(equation))), x_old);    
    x_new  = x_old - (b_0 / c_1);
    root(i) = x_new;
    
    error = (abs(x_old-x_new) / x_new);
    errors(i) = error;
    
    if error < eplison
       break;
    end
end

%time ends
TotalTime = (cputime - t) * 1000; 

end
 