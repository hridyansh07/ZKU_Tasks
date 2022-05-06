pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";

template RangeProof(n) {
    assert(n <= 252);
    signal input in; // this is the number to be proved inside the range
    signal input range[2]; // the two elements should be the range, i.e. [lower bound, upper bound]
    signal output out;

    component low = LessEqThan(n);
    component high = GreaterEqThan(n);

    // [assignment] insert your code here
    // assuming that the range[0] is lower bound and range[1] is upper bound 
    
    // Checking whether the given input is greater than the lower bound
    high.in[0] <== in;
    high.in[1] <== range[0];
    high.out === 1;

    // Checking whether the given input is Lower than the upper bound
    low.in[0] <== range[1];
    low.in[1] <== in;
    low.out === 1;

    // If both the above checks passed we add and divide it to get back 1 
    out <-- (low.out + high.out) * 1/2;
    // Finally Checking that the output of both the Templates will be 1
    out === 1;
}