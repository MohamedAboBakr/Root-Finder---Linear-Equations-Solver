function [ root ,totalTime,iteration,isDiv, errors ] = FixedPoint( g,max_itr,default_epsilon,initx )
t=cputime;
df = diff(sym(g),1);
df = inline(df);
g = inline(g);

if(df(initx) > 1)
    isDiv=1;
else
    isDiv=0;
end
errors(1)=0;
root(1)=0;
lastError=1;
i = 1;
while(i<=(max_itr)+1)
    iteration=i;
    root(i+1)=g(root(i));
    lastError=abs((root(i+1)-root(i)));
    errors(i+1)=lastError;
    if(lastError < default_epsilon)
        break;
    end
    i = i+1;
end
if(lastError>=default_epsilon || isnan(lastError))
    isDiv=1;
else
    isDiv=0;
end 
totalTime=(cputime-t)*1000;
iteration = iteration + 1;
end

