pragma circom 2.0.0;

// [assignment] Modify the circuit below to perform a multiplication of three signals


template Multiplier3 () {  

   // Declaration of signals.  
   signal input a;
   signal input b;
   signal input c;
   // Add an intermediate signal to hold states
   signal intermediate;
   signal output d;  

   // Constraints.  
   // Hold Constraint in intermeidate 
   intermediate <== a*b;
   // Final checking and taking it in output
   d <== intermediate*c;
}

component main = Multiplier3();