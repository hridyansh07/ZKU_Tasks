#!/bin/bash

# [assignment] create your own bash script to compile Multipler3.circom modeling after compile-HelloWorld.sh below
cd contracts/circuits

mkdir Multiplier

# Download The Powers of Tau File 
if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "Powers of Tau file exists, Skipping."
else
    echo 'Downloading Powers of Tau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

# Complie the Circuit 
circom Multiplier3.circom --r1cs --wasm --sym -o Multiplier
snarkjs r1cs info Multiplier/Multiplier3.r1cs

# Start a new key and start contribution 

snarkjs groth16 setup Multiplier/Multiplier3.r1cs powersOfTau28_hez_final_10.ptau Multiplier/circuit_0000.zkey
snarkjs zkey contribute Multiplier/circuit_0000.zkey Multiplier/circuit_final.zkey --name="Contributor" -v -e="Hridyansh Khatri"
snarkjs zkey export verificationkey Multiplier/circuit_final.zkey Multiplier/verification_key.json

#generate Contract 
snarkjs zkey export solidityverifier Multiplier/circuit_final.zkey ../Multiplier3Verifier.sol

cd ../..