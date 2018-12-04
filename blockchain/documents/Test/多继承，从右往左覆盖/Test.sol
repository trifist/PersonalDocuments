----------------------------------------------测试1， 结果a=2， b=3， n=3-------------------------------------------------
pragma solidity ^0.4.25;

contract Base1 {
    uint public n;
    constructor(uint num) public {
        n = num;
    }
}

contract Base2 {
    uint public n;
    constructor(uint num) public {
        n = num;
    }
}

contract Derived is Base1, Base2 {
    uint public a;
    uint public b;
    constructor(uint n) Base1(n+1) Base2(n+2) public {
        a = Base1.n;
        b = Base2.n;
    }
}


----------------------------------------------测试2， 结果a=2， b=3， n=2-------------------------------------------------
pragma solidity ^0.4.25;

contract Base1 {
    uint public n;
    constructor(uint num) public {
        n = num;
    }
}

contract Base2 {
    uint public n;
    constructor(uint num) public {
        n = num;
    }
}

contract Derived is Base2, Base1 {
    uint public a;
    uint public b;
    constructor(uint n) Base1(n+1) Base2(n+2) public {
        a = Base1.n;
        b = Base2.n;
    }
}