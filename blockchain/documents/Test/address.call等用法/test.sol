pragma solidity ^0.4.16;

contract Counter
{
    uint public count = 10;
    uint public fb = 0;
    
    function() public {
        fb++;
    }
    
    function inc(uint num) public returns (uint)
    {
        return count += num;
    }
}


//这种是已知abi的情况下的调用，上下文是在Counter中
contract CallCounter
{
    uint public count = 20;

    function callByAddr(address addr) public returns (uint)
    {
        return Counter(addr).inc(2);
    }
}


//这种调用是在Counter的上下文中，也就是调用完之后Counter中的count改变了，但是CallCounter中不变
contract Caller_by_call
{
    uint public count = 20;
    bool public success = false;
    function callByAddr(address addr) public returns (bool)
    {
        bytes4 methodId = bytes4(keccak256("inc(uint256)"));
        success = addr.call(methodId, 2);
        return success;
    }
}


//这种调用是在Caller_by_delegatecall的上下文中，也就是调用完之后Counter中的count不变，但是Caller_by_delegatecall中改变了
contract Caller_by_delegatecall
{
    uint public count = 20;
    bool public success = false;
    function callByAddr(address addr) public returns(bool)
    {
        bytes4 methodId = bytes4(keccak256("inc(uint256)"));
        success = addr.delegatecall(methodId, 2);
        return success;
    }
}

contract Caller_by_delegatecall_without_count
{
    function callByAddr(address addr) public returns(bool)
    {
        bytes4 methodId = bytes4(keccak256("inc(uint256)"));
        return addr.delegatecall(methodId, 2);
    }
}


//注：以上几种情况在发送交易时一定要多加一些gas，因为例如MetaMask中估计的都是一个合约方法内消耗的gas，如果它又调用了另一个合约，会消耗更多的gas。如果不加交易大概率会失败。