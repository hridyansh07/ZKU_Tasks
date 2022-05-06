const { expect } = require("chai");
const { ethers } = require("hardhat");
const {abiCoder} = require("ethers");
const fs = require("fs");
const { groth16, plonk } = require("snarkjs");
const exp = require("constants");

function unstringifyBigInts(o) {
    if ((typeof(o) == "string") && (/^[0-9]+$/.test(o) ))  {
        return BigInt(o);
    } else if ((typeof(o) == "string") && (/^0x[0-9a-fA-F]+$/.test(o) ))  {
        return BigInt(o);
    } else if (Array.isArray(o)) {
        return o.map(unstringifyBigInts);
    } else if (typeof o == "object") {
        if (o===null) return null;
        const res = {};
        const keys = Object.keys(o);
        keys.forEach( (k) => {
            res[k] = unstringifyBigInts(o[k]);
        });
        return res;
    } else {
        return o;
    }
}

describe("HelloWorld", function () {
    let Verifier;
    let verifier;

    beforeEach(async function () {
        Verifier = await ethers.getContractFactory("HelloWorldVerifier");
        verifier = await Verifier.deploy();
        await verifier.deployed();
    });

    it("Should return true for correct proof", async function () {
        //[assignment] Add comments to explain what each line is doing
        // For a given input a=1 and b=2 this line runs the circuit built to check whether it runs correctly or not
        const { proof, publicSignals } = await groth16.fullProve({"a":"1","b":"2"}, "contracts/circuits/HelloWorld/HelloWorld_js/HelloWorld.wasm","contracts/circuits/HelloWorld/circuit_final.zkey");
        
        // The public output signal is printed in this line
        console.log('1x2 =',publicSignals[0]);

        // I believe line 45-46 are used to convert the given public Signals and the proof into acceptable inputs for snarkjs which 
        // converts them into parameters that can be passed to the Smart Contract for verification
        const editedPublicSignals = unstringifyBigInts(publicSignals);
        const editedProof = unstringifyBigInts(proof);
        // This line generates the parameters that need to be used for the verifier contract
        const calldata = await groth16.exportSolidityCallData(editedProof, editedPublicSignals);

        // This line splits the output from the above line into different arrays 
        const argv = calldata.replace(/["[\]\s]/g, "").split(',').map(x => BigInt(x).toString());
    
        // The different arrays are then assigned into the different variables namely a,b,c Input 
        const a = [argv[0], argv[1]];
        const b = [[argv[2], argv[3]], [argv[4], argv[5]]];
        const c = [argv[6], argv[7]];
        const Input = argv.slice(8);

        // We finally run the verifier contract to check whether the proof is true
        expect(await verifier.verifyProof(a, b, c, Input)).to.be.true;
    });
    it("Should return false for invalid proof", async function () {
        // We generate dummy variables to test whether the verifier returns true for false values
        let a = [0, 0];
        let b = [[0, 0], [0, 0]];
        let c = [0, 0];
        let d = [0]
        expect(await verifier.verifyProof(a, b, c, d)).to.be.false;
    });
});


describe("Multiplier3 with Groth16", function () {

    let Verifier;
    let verifierInstance;
    beforeEach(async function () {
        //[assignment] insert your script here
        Verifier = await ethers.getContractFactory("Multiplier3Verifier");
        verifierInstance = await Verifier.deploy();
        await verifierInstance.deployed();
    });

    it("Should return true for correct proof", async function () {
        //[assignment] insert your script here
        const {proof ,publicSignals} = await groth16.fullProve({"a":"11","b":"22","c":"10"}, "contracts/circuits/Multiplier/Multiplier3_js/Multiplier3.wasm","contracts/circuits/Multiplier/circuit_final.zkey");
        
        console.log("11x22x10 ", publicSignals[0]);
    
        const editedPublicSignals = unstringifyBigInts(publicSignals);
        const editedProof = unstringifyBigInts(proof);
        const calldata = await groth16.exportSolidityCallData(editedProof, editedPublicSignals);

        const argv = calldata.replace(/["[\]\s]/g, "").split(',').map(x => BigInt(x).toString());
        
        const a = [argv[0], argv[1]];
        const b = [[argv[2], argv[3]], [argv[4], argv[5]]];
        const c = [argv[6], argv[7]];
        const Input = argv.slice(8);
   
        expect(await verifierInstance.verifyProof(a, b, c, Input)).to.be.true;
    });
    it("Should return false for invalid proof", async function () {
        //[assignment] insert your script here
        let a = [0, 0];
        let b = [[0, 0], [0, 0]];
        let c = [0, 0];
        let d = [0]
        expect(await verifierInstance.verifyProof(a,b,c,d)).to.be.false;
    });
});


describe("Multiplier3 with PLONK", function () {

    let Verifier;
    let verifierInstance;
    beforeEach(async function () {
        //[assignment] insert your script here
        Verifier = await ethers.getContractFactory("PlonkVerifier");
        verifierInstance = await Verifier.deploy();
        await verifierInstance.deployed();
    });

    it("Should return true for correct proof", async function () {
        //[assignment] insert your script here
        const {proof, publicSignals} = await plonk.fullProve({"a" : "10", "b" : "25" , "c" : "30"},"contracts/circuits/_plonkMultiplier/Multiplier3_js/Multiplier3.wasm","contracts/circuits/_plonkMultiplier/circuit_0000.zkey");
        
        console.log("10x25x30", publicSignals[0]);
        
        const editedPublicSignals = unstringifyBigInts(publicSignals);
        const editedProof = unstringifyBigInts(proof);
        // Creating the Calldata 
        const calldata = await plonk.exportSolidityCallData(editedProof, editedPublicSignals);
        // Splitting the Calldata at the ","
        const argv = calldata.split(",");
        // Calling the Data
        expect(await verifierInstance.verifyProof(argv[0] ,JSON.parse(argv[1]))).to.be.true;
        
    });
    it("Should return false for invalid proof", async function () {
        //[assignment] insert your script here
        const a = 0x000000000000000000000000000000000000000000;
        const b = [0];
        expect(await verifierInstance.verifyProof(a,b)).to.be.false;
    });
});