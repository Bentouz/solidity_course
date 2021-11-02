// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

//This smart contract is used as a multi signature wallet to make transactions on the ethereum blockchain.
//Mapping of adresses.
//Structure : str Name, address Address, bool Approved
contract MultiSigWallet {
    
    //Variables definition
    // struct User {
    //     string name;
    //     address addr;
    //     bool approved;
    // }
    
    struct Transfer {
        uint id;
        uint amount;
        address payable to;
        uint approvals;
        bool sent;
    }

    // mapping (uint => Transfer) public transfers;
    // uint public nextId;
    
    Transfer[] public transfers;
    
    address[] public approvers;
    uint public quorum;
    
    mapping(address => mapping(uint => bool)) public approvals;
    
    constructor (address[] memory _approvers, uint _quorum)   {
        approvers = _approvers;
        quorum = _quorum;
    }
    
    function getApprovers() external view returns(address[] memory){
        return approvers;
    }
    
    function getTransfers() external view returns(Transfer[] memory){
        return transfers;
    }
    
    // function createTransfer(uint _amount, address payable to) external {
    //     transfers[nextId] = Transfer(
    //         nextId,
    //         _amount,
    //         _to,
    //         0,
    //         false
    //     );
    //     nextId++;
    // }
    
    function createTransfer(uint amount, address payable to) external onlyApprover(){
        transfers.push(Transfer(
            transfers.length,
            amount,
            to,
            0,
            false)
        );
    }
    
    function approveTransfer(uint id) external onlyApprover(){
        require(transfers[id].sent == false, 'This transfer has already been sent.');
        require(approvals[msg.sender][id], 'Cannot approve transfer twice.');
        approvals[msg.sender][id] = true;
        transfers[id].approvals++;
        
        if (transfers[id].approvals >= quorum) {
            transfers[id].sent = true;
            address payable to = transfers[id].to;
            uint amount = transfers[id].amount;
            to.transfer(amount);
        }
    }
    
    receive() external payable{}
    
    modifier onlyApprover() {
        bool allowed = false;
        for (uint i = 0; i < approvers.length; i++) {
            if (approvers[i] == msg.sender) {
                allowed = true;
            }
        }
        require(allowed == true, 'User not approved.');
        _;
        
    }
}