// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

contract MyContract {
    uint value;
    uint[] array;
    
    constructor(uint _value, uint _arraySize) {
        value = _value;
        for(uint i = 0; i<_arraySize; i++) {
            array.push(i);
        }
    }
    
    function get() external view returns (uint) {
        return array[458];
    }
    
    function set(uint _value) external {
        value = _value;
    }
}

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

//This smart contract is used as a multi signature wallet to make transactions on the ethereum blockchain.
//Mapping of adresses.
//Structure : str Name, address Address, bool Approved
contract MultiSigWallet {
    //Variable definition
    
    struct User {
        string name;
        address addr;
        bool approved;
        
    }
    
    string[] list;
    
    function createUser(string _name, address _addr) external view {
        new User (_name, _addr, false);
        
    }
}