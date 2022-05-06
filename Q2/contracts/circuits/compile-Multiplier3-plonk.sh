#!/bin/bash

# [assignment] create your own bash script to compile Multipler3.circom modeling after compile-HelloWorld.sh below
cd contracts/circuits

mkdir _plonkMultiplier

# Download The Powers of Tau File 
if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "Powers of Tau file exists, Skipping."
else
    echo 'Downloading Powers of Tau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

# Complie the Circuit 
circom Multiplier3.circom --r1cs --wasm --sym -o _plonkMultiplier
snarkjs r1cs info _plonkMultiplier/Multiplier3.r1cs

# Start a new key and start contribution 

snarkjs plonk setup _plonkMultiplier/Multiplier3.r1cs powersOfTau28_hez_final_10.ptau _plonkMultiplier/circuit_0000.zkey
# snarkjs zkey contribute _plonkMultiplier/circuit_0000.zkey _plonkMultiplier/circuit_final.zkey --name="Contributor" -v -e="Hridyansh Khatri"
snarkjs pkv _plonkMultiplier/Multiplier3.r1cs powersOfTau28_hez_final_10.ptau  _plonkMultiplier/circuit_0000.zkey
snarkjs zkey export verificationkey _plonkMultiplier/circuit_0000.zkey _plonkMultiplier/verification_key.json

#generate Contract 
snarkjs zkey export solidityverifier _plonkMultiplier/circuit_0000.zkey ../_plonkMultiplier3Verifier.sol

# Verify the proof from command line 
snarkjs plonk fullprove input.json _plonkMultiplier/Multiplier3_js/Multiplier3.wasm _plonkMultiplier/circuit_0000.zkey
cd ../..