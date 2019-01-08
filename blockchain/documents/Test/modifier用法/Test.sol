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
    
    function test2() B A external {
        a = 3;
    }
    
    function test3() A B external {
        a = 3;
        return;
    }
}
    
//	function test() {
//	    a=1;
//	    {
//	        {
//	            a=3;
//	        }
//	        a=2;
//	        return;
//	    }
//	    a=4;
//	}
//	
//	function test2() {
//	    {
//			a = 1;
//			{
//				a = 3;
//			}
//			a = 4;
//		}
//		a = 2;
//		return;
//	}
//	
//	function test3() {
//	    a=1;
//	    {
//	        {
//	            a=3;
//				return;
//	        }
//	        a=2;
//	        return;
//	    }
//	    a=4;
//	}

    
