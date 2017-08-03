function [ invalid, root, totalTime, errors, itr_count ] = Secant( equation, max_itr, epsilon, intial_guess0, intial_guess1 )

equation = inline(equation);

root(1) = intial_guess0;
root(2) = intial_guess1;

errors(1) = 1;
errors(2) = 1;

i = 3;
t = cputime;
invalid = 0;

while(i<=(max_itr)+1)
    
    %%check for divide by zero
    if((equation(root(i-2))-equation(root(i-1))) == 0)
        invalid = 1;
        break;
    end 
    
    root(i) = root(i-1) - (equation(root(i-1)) * (root(i-2) - root(i-1)))/(equation(root(i-2)) - equation(root(i-1)));
    error = abs((root(i-1)-root(i)));
    errors(i) = error;
    if(error < epsilon)
        break;
    end
    i=i+1;
end

itr_count=i;
totalTime=(cputime-t)*1000;

end