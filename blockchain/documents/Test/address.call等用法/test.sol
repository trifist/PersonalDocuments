pragma solidity ^0.5.0;

contract Counter
{
    uint public count = 10;
    uint public fb = 0;
    
    function() external {
        fb++;
    }
    
    function inc(uint num) public returns (uint)
    {
        return count += num;
    }
    
    function getCount() public view returns (uint) {
        return count;
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

    function callByAddr(address addr) public returns (bool, bytes memory)
    {
        bytes memory data = abi.encodeWithSignature("inc(uint256)", 2);
        bytes memory result;
        bool success;
        (success, result) = addr.call(data);
        return (success, result);
    }
}


//这种调用是在Caller_by_delegatecall的上下文中，也就是调用完之后Counter中的count不变，但是Caller_by_delegatecall中改变了
contract Caller_by_delegatecall
{
    uint public count = 20;

    function callByAddr(address addr) public returns(bool, bytes memory)
    {
        bytes memory data = abi.encodeWithSignature("inc(uint256)", 2);
        bytes memory result;
        bool success;
        (success, result) = addr.delegatecall(data);
        return (success, result);
    }
}

//staticcall只能调用view和pure函数
contract Caller_by_staticcall
{
    uint public count = 20;

    function callByAddr(address addr) public view returns(bool, bytes memory)
    {
        bytes memory data = abi.encodeWithSignature("getCount()");
        bytes memory result;
        bool success;
        (success, result) = addr.staticcall(data);
        return (success, result);
    }
}

contract Caller_by_delegatecall_without_count
{
    function callByAddr(address addr) public returns(bool, bytes memory)
    {
        bytes memory data = abi.encodeWithSignature("inc(uint256)", 2);
        bytes memory result;
        bool success;
        (success, result) = addr.delegatecall(data);
        return (success, result);
    }
}


//注：以上几种情况在发送交易时一定要多加一些gas，因为例如MetaMask中估计的都是一个合约方法内消耗的gas，如果它又调用了另一个合约，会消耗更多的gas。如果不加交易大概率会失败。