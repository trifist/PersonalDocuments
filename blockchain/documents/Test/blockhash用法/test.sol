pragma solidity ^0.4.25;

//当前区块的blockhash是获取不到的，因为在交易进行时该值尚未确定，只有当所有交易完成后才确定。

contract Test {
    
    bytes32 public oriHash;
    bytes32 public newHash;
    uint public number;
    uint public newNumber;
    
    constructor() public {
        oriHash = blockhash(block.number);
        number = block.number;
    }
    
    function getHash() public {
        newHash = blockhash(block.number);
        newNumber = block.number;
    }
}