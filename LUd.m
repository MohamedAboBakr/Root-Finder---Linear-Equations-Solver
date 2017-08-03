%A is the cofficients matrix.
%B is the result vector.
function [X, isValid, totalTime] = LUd(A,B,tol)
	
	%get the size of the A matrix.
	[n,m] = size(A);
	%if it is not matrix return with an error
	if(n ~= m)
		isValid = 5;
		return;
	end

	%time starts
	t = cputime; 

	%create L and U and O and S.
	U = zeros(n,n);
	L = eye(n);
	O = zeros(n,1);
	S = zeros(n,1);

	for i=1:n
		for j=1:n
			U(j,i) = A(j,i);
		end
	end

	%set the data
	errors = 0;
	
	
		for i=1:n
			%Initialize the vector O.
			O(i) = i;
			%Set the vector S.
			S(i) = abs(A(i,1));
			for j=2:n
				if(abs(A(i,j) > S(i)))
					S(i) = abs(A(i,j));
				end
			end
		end

		for k=1:n-1
			
			%pivot
			pivot(k);
			
			%check for sigular
			if(abs(A(O(k),k)) / S(O(k)) < tol)
				isValid = 0;
				return;
			end
			A
			for i=k+1:n
				
				factor = A(O(i),k) / A(O(k),k);
				
				A(O(i),k) = factor;
				L(i,k) = factor;
				
				for j=k+1:n
					U(i,j) = A(O(i),j) - factor * A(O(k),j);
					A(O(i),j) = A(O(i),j) - factor * A(O(k),j);
				end
				
			end
			
		end

		if(abs(A(O(n),n) / S(O(n))) < tol)
			isValid = 0;
			return;
		end
	
	%function to Pivot.
	function pivot(k)
		p = k;
		
		big = abs(A(O(k),k) / S(O(k)));
	
		for i = k+1:n
			dummy = abs(A(O(i),k) / S(O(i)));
			if(dummy > big)
				big = dummy;
				p = i;
			end
		end
		
		temp = A(p,:);
		A(p,:) = A(k,:);
		A(k,:) = temp;
		
		temp = B(k);
		B(k) = B(p);
		B(p) = temp;
		
		%swap them
		dummy = O(p);
		O(p) = O(k);
		O(k) = dummy;
	end


	%GENERATE THE RESULTS
	y = zeros(n,1);
	X = zeros(n,1);
	
	y(O(1)) = B(O(1));
	
	for i = 2 : n
	
		sum = B(O(i));
		for j=1:i-1
			sum = sum - A(O(i),j) * y(O(j));
		end
		y(O(i)) = sum;
		
	end
		
	
	X(n) = y(O(n)) / A(O(n),n);
	for i = n-1:-1:1
		disp(i);
		sum = 0;
		
		for j = i+1:n
			sum = sum + A(O(i),j) * X(j);
		end
		
		X(i) = (y(O(i)) - sum) / A(O(i),i);
	
	end
	
	totalTime = (cputime-t) * 1000;
	isValid = 1;
	
end
