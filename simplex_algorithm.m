%PROGRAM FOR MODEL 17: Farm Fertilizer Problem

%Programming Requirement 1: input of question manually convert to standard
%Assume to be of the form:
% min Cx
% st  Ax = b
%     x >= 0 

%objective function
C = readmatrix("C^T.csv");

%A1 matrix Shop supply constrain in standard form
A = readmatrix("A.csv");

%b matrix in Ax = b; lb as non-negativity constrains
b = readmatrix("b.csv");
lb =zeros([length(C) 1]);
 
%Programming Requirement 2: detect if LP is feasible or not
%Check whether Ax <= b and x>= 0 has a feasible region or not
%Methodology used:
%Done by solving phase I problem and coding the simplex method
 
[cost_artificial, A_phase1,Reduced_cost_artificial,Xb,Xb_values] = Phase1_initialization(A,b);

[Xb_1,Xb_values1,A_next_1,Reduced_cost_new_1,opt_sol1] = simplex(Reduced_cost_artificial,Xb,b,cost_artificial,A_phase1,Xb_values);
if(opt_sol1 == 0)
    fprintf("LP is feasible, since optimal solution of phase 1 is 0\n")
else
    fprintf("LP is infeasible by solving Phase1.\n")
end
 
%Programming Requirement 3: detect if Coefficient matrix has full row rank
% Method to determine redundunt contrains is by solving the phase 1. if
% basis variable values are non-zero, then LP has full row rank, if not
% then there is degeneracy.
 
%this code is to check if at LEAST 1 bfs is = 0, if not, then its full row
%rank. Then if the corresponding row has all 0 (except for artificial
%variables), it means it is redundant
 
if(sum(Xb_values1 ~= 0) == length(Xb_values1))
     fprintf("LP has full row rank\n")
else 
    fprintf('LP might be degenerate, checking for redundant constrains..\n')
    %the degenerate equations are the one with coefficient of 0 
    [equation_num variable_num] = size(A)
    check_this_table = A_next_1(:,1:length(A))
     
    %check each of the row, if they all equate to 0, it means redundant
    for i = 1:equation_num
        check_this_table(i,:) == zeros(1,variable_num)
        if(sum(check_this_table(i,:) == 0) == variable_num)
            fprintf("Equation number %d is redundant\n",i)
        end 
    end
end
 
 
 
%Programming Requirement 4: Simplex method with identity matrix not
%                           readily available to use
% Methodology used:
% 2-Phase apporach used in class. Simplex method has already been coded
% and the difference is in implementation
 
%PART 1: Check BFS with the identity matrix as the corresponding basis is
%readily available

[num_constrain, num_variables] = size(A);
slack_variables = length(A) - num_constrain + 1;
slack_matrix = A(:,slack_variables:length(A));

if(slack_matrix == eye(length(slack_matrix)))
    fprintf('BFS with identity matrix is AVAILABLE, Next step is to apply simplex \n')
    [slack_var col_num] = size(A);
    Xb_slack = [col_num - slack_var + 1: col_num];
    [Xb_final,Xb_values_final,A_final,Reduced_cost_new_final] = simplex(-C,Xb_slack,b,C,A,b);
    
else
    fprintf('Identity matrix not AVAILABLE, start 2 phase approach: \n')
    fprintf('Start Phase 1 approach:\n')
    [cost_artificial, A_phase1,Reduced_cost_artificial,Xb,Xb_values] = Phase1_initialization(A,b);
    [Xb_1,Xb_values1,A_next_1,Reduced_cost_new_1,optsol_p1] = simplex(Reduced_cost_artificial,Xb,b,cost_artificial,A_phase1,Xb_values);
    
    %transition from PHASE 1 TO PHASE 2. Get rid of artificial variables
    %and recalculate reduced cost. Copy Xb_values and A.
    A_phase2 = A_next_1(:,1:length(A));
    Cost_Basis = C(:,Xb_1);
    
    [nrow, ndim] = size(A_phase2);
    B_inverse = A_next_1(:,Xb);
    Reduced_cost_phase2 = Cost_Basis*B_inverse*A_phase2 - C;
    Reduced_cost_phase2(:,Xb) = 0;
    %FIND REDUCED COST INTO PHASE 2
    fprintf("Phase1 done, start Phase2\n")
    [Xb_final,Xb_values_final,A_final,Reduced_cost_new_final,optsol_final] = simplex(Reduced_cost_phase2,Xb_1,b,C,A_phase2,Xb_values1);
    fprintf("final optimal solution is: %d\n",optsol_final)
    fprintf("The corresponding basis indexes (x_index) and values are:\n")
    result = [Xb_final,Xb_values]
    header = {'x_index','values'};
    output = [header; num2cell(result)];
    writecell(output,'output.csv');
    fprintf("Results are saved in result.csv \n")
 end
 
 
 
%Programming Requirement 5: Anti Cycling algorithm
%Methodology used: Bland's rule (The smallest subscript pivoting rule)


 
%STEP 0 -INITIALIZATION 
%Simplex code to solve artificial variables with objective function of
%minimizing artificial variables
function [cost_artificial, A_phase1,Reduced_cost_artificial,Xb,Xb_values] = Phase1_initialization(A,b)

%SIMPLEX Method of Phase 1
%Add artificial variables to places with negative slacks

size1 = size(A);
row1 = size1(2) - size1(1);
A1 = A(:,1:row1);
slacks = A(:,(row1+1):size1(2));
[row_numb,~] = find(slacks == -1);
remaining = length(slacks)-length(row_numb);
artificial_variables = [zeros(remaining,length(row_numb)) ; eye(length(row_numb))];
A_phase1 = [A artificial_variables];
% additional_cost = length(A_phase1) - length(C);

[basis_1, col_1] = find(slacks == 1);
[basis_2, col_2] = find(artificial_variables == 1);

col_1 = col_1 + length(A1);
col_2 = col_2 + length(A1) + length(slacks);

%this is the cost artificial
cost_artificial = zeros(1,length(A_phase1));
cost_artificial(:,col_2(1):col_2(length(col_2))) = 1;

%the cost variable for slacks would be 0 while the cost for artficial
%variable would be one, so we make a vector of it
Cost_Basis_Inverse = [zeros(length(basis_1),1); ones(length(basis_2),1)];

%The following code is Cb*B^(-1)(A) - Cn. in this case BASIS is identity matrix,
%so we don't need to multiply it
Reduced_cost_artificial = transpose(Cost_Basis_Inverse)*A_phase1 - cost_artificial;

%Choose initial basis with positive slack and artifical variables
 
Xb =[col_1; col_2];
Xb_values = b;
 
end
 
%STEP 1: Do simplex (reduced cost update)
%while there is at least 1 reduced cost that is non-zero keep iterating
%Assume given format in standard form and basis is "nice" (identity
%matrix)
%Input: A (initialized) ,b ,Cb*B^(-1)(A) - Cn (reduced cost),Xb_values,
%and original C value (cost_artificial)

function [Xb,Xb_values,A_next,Reduced_cost_new,Q] = simplex(Reduced_cost_artificial,Xb,b,cost_artificial,A_phase1,Xb_values)
 
A_next = A_phase1;
Reduced_cost_new = Reduced_cost_artificial;
Xb_still = Xb_values;
RHS_value =   cost_artificial(:,Xb)* Xb_values;

%this is to detect cycling
i = 0;
count = 0;
while (sum(round( Reduced_cost_new, 10) > 0) ~= 0)
    %find the reduced cost with max value. If tie, pick the one with smaller
    %index (or first index value in the logic below)
    index_numb = find(Reduced_cost_new == max(Reduced_cost_new));
    entering_index = index_numb(1);
    %Now, choose which basis to pivot with. done by picking the min value
    %of RHS divided by the column (ratio test),to figure out which current
    %basis goes to 0 first. We do not consider negative ratio because they
    %are INFEASIBLE
    ratio = Xb_values ./ A_next(:,entering_index);
    leaving_basis_index = find(ratio == min(ratio(ratio>0)));
     
    %Programming Requirement 5: Anti-Cycling rule. This is done by
    %implementing the bland's rule. Apply Bland's rule whenever there is no choice
    % of entering variable that will increase the objective function.
    
    if(i == 1)
        %find the basis with the smallest index
        leaving_basis_index = find(Xb == min(Xb));
        %find the first positive element in reduced cost
        entering_index = find(Reduced_cost_new > 0,1);
        i = 0;
    end
     
    %Programming Requirement 6:
    %Check for unboundedness case. This is done by checking the
    %column coeficient of the entering variables, if they are all <=0,
    %then we say its infeasible
    
    if(A_next(:,entering_index) <= 0)
        fprintf('LP is unbounded.\n')
        break;
    end
          
     
    %UPDATE new BASIS
    Xb(leaving_basis_index(1),:) = entering_index;
    
  
    %UPDATE B^(-1). Store it because frequently used
    new_Basis_inverse = inv( A_phase1(:,Xb));
 
    %UPDATE B^(-1) * N
    A_next = new_Basis_inverse * A_phase1;
     
    %UPDATE RHS (B^(-1)*b) or Xb_values
    Xb_values = new_Basis_inverse*Xb_still;
     
    %UPDATE Cb*B^(-1)* N - Cn or Reduced_cost
    Cb = cost_artificial(:,Xb);
    Reduced_cost_new = Cb*new_Basis_inverse*A_phase1 - cost_artificial;
     
    if(RHS_value == Cb*Xb_values)
        %detect cycling, if no increase in objective value, then next
        %iteration apply bland's rule
        fprintf("Cycling is detected\n")
        i = 1;
    end
     
    RHS_value = Cb*Xb_values;
    count = count +1;
end 
fprintf('simplex ended with %d iteration\n',count)
 
Q = Cb*Xb_values;
end 