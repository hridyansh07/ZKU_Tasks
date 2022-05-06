const fs = require("fs");
const solidityRegex = /pragma solidity \^\d+\.\d+\.\d+/

const verifierRegex = /contract Verifier/

let content = fs.readFileSync("./contracts/HelloWorldVerifier.sol", { encoding: 'utf-8' });
let bumped = content.replace(solidityRegex, 'pragma solidity ^0.8.0');
bumped = bumped.replace(verifierRegex, 'contract HelloWorldVerifier');


// [assignment] add your own scripts below to modify the other verifier contracts you will build during the assignment
// reading the contract and replacing the Pragma along with the Contract name
let content1 = fs.readFileSync("./contracts/Multiplier3Verifier.sol", {encoding : 'utf-8'});
let bump = content1.replace(solidityRegex, 'pragma solidity ^0.8.0');
bump = bump.replace(verifierRegex, "contract Multiplier3Verifier");

