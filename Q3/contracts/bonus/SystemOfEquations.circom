pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
// include ""; // hint: you can use more than one templates in circomlib-matrix to help you

// Trying with the elimination approach adding all the Coeff and constants together and then 
// multiplying with the inputs to compute whether LHS and RHS are equal or not 
// Highly inefficient and first try only. Is not Working will figure out after the deadline is finished

template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution
    signal intermediate;
    var sumCoff[n];
    var counter = 0;
    // [bonus] insert your code here
    // If I write out <-- 0 will the circuit revert from here ? 
    // Think it will need to figure out a better appraoch to change output values 
    // And enforce constraints 
    // out <-- 0;

    // Adding all the Coefficient into one array 
    while ( counter < n)
    {
    for (var i=0; i < n ; i ++)
    {
       sumCoff[counter] = sumCoff[counter] + A[i][counter];
    }
    counter ++; 
    }

    var sumConstant;
    
    // Adding All the constants into one array
    for(counter =0 ; counter < n; counter++)
    {
        sumConstant = sumConstant + b[counter];
    }

    var lhs;
    // Finaly computing the LHS of the equation 
    for(counter = 0; counter < n; counter++)
    {
        lhs  = x[counter]*sumCoff[counter] + lhs;
    }
    intermediate <-- lhs;
    // Comparing with the Right Hand side if equal return 1 
    assert(intermediate == sumConstant);
    out <== 1;
}

component main {public [A, b]} = SystemOfEquations(3);