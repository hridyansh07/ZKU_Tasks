// SPDX-License-Identifier: MIT 

pragma solidity 0.8.9;


contract HelloWorld
{

    /// @notice The event that emits whenever a new number is stored 
    event NumberStored(uint256 indexed _number);
        

    /// @notice The state variable used to store a number
    uint256 public numberToStore;

    /// @notice Function to store a given number inside the state variable
    /// @param _number The number to be stored
    function storeNumber(uint256 _number) public 
    {
        numberToStore = _number;
        emit NumberStored(numberToStore);
    }

    /// @notice Function to retreive the stored number inside the contract
    function retreiveNumber() public view returns(uint256)
    {
        return numberToStore;
    }

}