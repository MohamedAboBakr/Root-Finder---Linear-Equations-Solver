function [isvalid ,root, total_time, errors , itr_count] = newton (initial_guess, max_iteration, epsilon, equation)

syms x y z w;
equation1 = inline(equation);
z = diff(equation, x);
root(1)=initial_guess ;
errors(1) = 1;

isvalid=1;
i=1 ;
t = cputime;

while(i <= max_iteration)
    
   if(z == 0)
      isvalid=0;
      break;
   end
   
   x = root(i);
   y = subs(z);
   w = equation1(x);
   root(i+1) = root(i) -( w / y );
   errors(i+1) = abs(root(i+1)-root(i));
   if(errors(i+1) < epsilon)
       break;
   end
   i=i+1;

end

itr_count=i;
total_time=(cputime-t)*1000;
end