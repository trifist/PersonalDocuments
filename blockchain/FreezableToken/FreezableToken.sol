pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";

contract FreezableToken is StandardToken {
    string public name = 'FreezableToken';
    string public symbol = 'FRT';
    uint public decimals = 4;
    uint public INITIAL_SUPPLY = 10000 * (10 ** decimals);
    mapping(address => FrozenAccountArray) frozenAccounts;
    address admin;
    
    struct FrozenAccount {
        uint startTime;
        uint nextReleaseTime;
        uint duration;
        uint frozenAmount;
        uint releasePerUnit;
    }
    
    struct FrozenAccountArray {
        uint length;
        mapping(uint => FrozenAccount) data;
    }
    
    event FreezeSuccess(address target, uint amount, uint nextReleaseTime, uint duration, uint releasePerUnit);
    
    constructor() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
        admin = msg.sender;
    } 
    
    modifier onlyAdmin {
        require(msg.sender == admin);
        _;
    }
    
    function addToArray(FrozenAccountArray storage array, FrozenAccount memory account) internal {
        array.data[array.length++] = account;
    }
    
    function transfer(address to, uint tokens) public returns (bool success) {
        if(tokens <= getSpendableAmount(msg.sender)) {
            return super.transfer(to, tokens);
        } else {
            return false;
        }
    }
    
    
    function freeze(uint amount, uint nextReleaseTime, uint releasePerUnit, uint duration, address target) public onlyAdmin {
        if(frozenAccounts[target].length == 0) {
            frozenAccounts[target] = FrozenAccountArray(0);
        }
        require(amount <= getSpendableAmount(target));
        FrozenAccount memory frozen = FrozenAccount(now, nextReleaseTime, duration, amount, releasePerUnit);
        addToArray(frozenAccounts[target], frozen);
        emit FreezeSuccess(target, amount, nextReleaseTime, duration, releasePerUnit);
    }
    
    function getSpendableAmount(address target) internal returns(uint) {
        refreshAccount(target);
        uint total = 0;
        for(uint i=0; i<frozenAccounts[target].length; i++) {
            total = SafeMath.add(total, frozenAccounts[target].data[i].frozenAmount);
        }
        return SafeMath.sub(balances[target], total);
    }
    
    function refreshAccount(address target) internal {
        for(uint i=0; i<frozenAccounts[target].length; i++) {
            if(now >= frozenAccounts[target].data[i].nextReleaseTime) {
                uint count = SafeMath.div(SafeMath.sub(now, frozenAccounts[target].data[i].nextReleaseTime), frozenAccounts[target].data[i].duration);
                uint aboutToRelease = SafeMath.mul(count, frozenAccounts[target].data[i].releasePerUnit);
                if(aboutToRelease >= frozenAccounts[target].data[i].frozenAmount) {
                    frozenAccounts[target].data[i].frozenAmount = 0;
                    clearUselessAccount(target, i);
                    i = i - 1;
                } else {
                    frozenAccounts[target].data[i].frozenAmount = SafeMath.sub(frozenAccounts[target].data[i].frozenAmount, aboutToRelease);
                    frozenAccounts[target].data[i].nextReleaseTime = SafeMath.add(frozenAccounts[target].data[i].nextReleaseTime, SafeMath.mul(count, frozenAccounts[target].data[i].duration));
                }
            }
        }
    }
    
    function clearUselessAccount(address target, uint index) internal {
        frozenAccounts[target].data[index] = frozenAccounts[target].data[frozenAccounts[target].length - 1];
        frozenAccounts[target].length = frozenAccounts[target].length - 1;
    }
}