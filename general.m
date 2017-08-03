function [a, isvalid, total_time] = general (epsilon, equation)
	equation = 'x-9';
    epsilon= 0.001;
	%start time
	t = cputime;

	%set it to valid
	isvalid = 1;


	%array
	a = [];
	index = 0;

	for i=0:1000
		%test them all
		[isvalid1, xl, xu, root1, totalTime1, itr_count ,errors] = Bisection(equation,500,epsilon,i,i+1);
		[isvalid2, xl, xu, root2, totalTime2, itr_count ,errors] = Bisection(equation,500,epsilon,-i,-i-1);
		[isvalid3 ,root3, total_time3, errors , itr_count] = newton(i, 500, epsilon, equation);
		[isvalid4 ,root4, total_time4, errors , itr_count] = newton(-i, 500, epsilon, equation);
		[isvalid5 ,root5, total_time5, errors , itr_count] = newton(i*10, 500, epsilon, equation);
		[isvalid6 ,root6, total_time6, errors , itr_count] = newton(-i*10, 500, epsilon, equation);

		[a,index]  = check(isvalid1,root1,a,index);
		[a,index]  =check(isvalid2,root2,a,index);
		[a,index]  =check(isvalid3,root3,a,index);
		[a,index]  =check(isvalid4,root4,a,index);
		[a,index]  =check(isvalid5,root5,a,index);
		[a,index]  =check(isvalid6,root6,a,index);

    end
end

		function [a,index] = check(isvalid,root,a,index)
			if(isvalid == 1)
				found = 0;

				for j=1:index
					if(a(j) == root(length(root)))
						found = 1;
						break;
					end
				end
			
				if(found == 0)
					index = index + 1;
					a(index) = root(length(root));
				end

			end
		end