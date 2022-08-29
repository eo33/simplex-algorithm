# Simplex
A tool that is used to solve _Linear programming_ (LP) problems. It accepts .CSV files as inputs, and outputs the optimal solution in TEXT format. 

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

### CSV inputs
Once you have a minimization and standard form LP problem, input the variables in the .CSV file.
#### Objective function (C^T * X)
Your C^T 
> Note: You should include the slack variables in the objective function.

#### Constraints (Ax = b)
##### A
##### b

#### 

  
