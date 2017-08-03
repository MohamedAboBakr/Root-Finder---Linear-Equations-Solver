function [ x, total_Time ] = GaussSeidel(A,b,es,maxit)

[m,n] = size(A);

%time starts
t = cputime;

if m~=n, error('Matrix A must be square'); end
n=3;
  xold = zeros(n,1)+[0;0;0];

iter = 0;
while (1)
    
    for i=1:n
       x(i) = b(i); 
     
        for j=1:n
            if(i~=j)
              
                x(i) = x(i) - A(i,j)*xold(j);
            
            end
        end
        x(i) = x(i) / A(i,i);
        ea = abs(x(i) - xold(i));
        xold(i)=x(i);
    
    end
iter = iter+1;
if ea<=es | iter >= maxit, break, end
end

total_Time = (cputime-t) * 1000;