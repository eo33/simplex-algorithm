# Simplex algorithm
A tool that is used to solve _Linear programming_ (LP) problems using the simplex algorithm. It accepts .csv files as inputs, and outputs the optimal solution in TEXT format. It uses the 2-phase approach to solve the problem. In addition, it uses Bland's rule to prevent cycling from happening. 

## Get started
       
### LP prerequisite
To use this tool, your LP model has to be:

<details>
  <summary>A minimization problem</summary>
  
  A minimization problem aims to minimize the objective function. If you have a maximization 
  problem, you can convert it to a minimization problem by multiplying the objective function by -1.
</details>

<details>
  <summary>In the standard form</summary>
  
  A standard form LP has the following conditions:
  - Only has equality constraints
  - A non-negative right hand side vector _b_
  - Has non-negative constraints for all variables
  
  You can convert any LP problems into standard form by converting _≤_ constraint to an _=_,
  and adding a _slack variable_. The variables and _slack variables_ should also be non- negative.
</details>

Your LP problem should take this form:

![image](https://user-images.githubusercontent.com/70526829/187185386-dd2d1573-640c-4dc8-a04b-ee5e5b33b278.png)

> ⚠️ Warning: This tool can't be used to solve maximization or unstandardized LP. You should convert your LP to a standardized minimization problem. 

### Running the simplex
Once your LP is formated, you should hardcode the variables as input in the csv format. Then, you can run the _simplex_algorithm.m_ in MATHLAB to solve your LP problem. 

## Inputs
### CSV inputs
The input variables should be in the .csv file. The input samples _C^T.csv_, _A.csv_ and _b.csv_ are used in the example. 

#### Objective function (C^T * x)
The objective function _C^T_ should be saved in the .csv format. Here is an example from _C^T.csv_.
```CSV
45,42.5,47.5,41.3,13.9,17.8,19.9,12.5,29.9,31,24,31.2,31.9,35,32.5,29.8,9.9,12.3,12.4,11,0,0,0,0,0,0,0,0,0
```

> 📖 Note: You should include the slack variables in the objective function. In the example, the last 9 zeros are slack variables.

#### Left hand side of the constraint (A * x)
The left hand side of the constraint _A_ should be saved in the .csv format. Here is an example from _A.csv_.
```CSV
1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0
0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0
0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0
0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,0,0
1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,0
0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0
0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0
0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,-1,0
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,-1
```

#### Right hand side of the constraint (b)
The right hand side of the constraint _b_ should be saved in the .csv format. Here is an example from _b.csv_.
```CSV
350
225
195
275
185
50
50
200
185
``` 
## Output
Running _simplex_algorithm.m_ will give you the optimal solution to your minimization problem. It will generate the _output.csv_ file, which saves the optimal values. In addition to that, it also tells you the following:
- Number of iterations
- Feasibility of phase 1
- Full row rank condition
- Availability of identity matrix
