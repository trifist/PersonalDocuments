pragma solidity ^0.4.16;

contract TestModifier {
    
    uint public a = 0;
    
    modifier A {
        a = 1;
        _;
        a = 4;
    }
    
    modifier B {
        _;
        a = 2;
        return;
    }
    
    function test() A B external {
        a = 3;
    }
    
//    function funb() {
//        a=1;
//        {
//            {
//                a=3
//            }
//            a=2;
//            return;
//        }
//        a=4;
//    }
    
}