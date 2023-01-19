// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
Let's say Alice can see the code of Foo and Bar but not Mal.
It is obvious to Alice that Foo.callBar() executes the code inside Bar.log().
However Eve deploys Foo with the address of Mal, so that calling Foo.callBar()
will actually execute the code at Mal.
*/

/*
1. Eve deploys Mal
2. Eve deploys Foo with the address of Mal
3. Alice calls Foo.callBar() after reading the code and judging that it is
   safe to call.
4. Although Alice expected Bar.log() to be execute, Mal.log() was executed.
*/
//隐藏的恶意代码无法在etherscan 看到
/*
Hiding Malicious Code
- contract hiding malicious code walkthrough
- coding an exploit
- demo on remix
*/


contract Bar {
    event Log(string message);

    function log() public {
        emit Log("Bar was called");
    }
}

contract Foo {
    Bar bar;
    constructor(address _bar) {
        bar = Bar(_bar);
    }
  //预防攻击：
//     Bar public bar;
//    constructor() public {
//     bar = new Bar();
//     }
    function callBar() public {
        bar.log();
    }
}
// This code is hidden in a separate file
//先部署这个mal合约再部署上面的合约，调用的就是 emit Log("Mal was called");
contract Mal {
    event Log(string message);

    // function () external {
    //     emit Log("Mal was called");
    // }

    // Actually we can execute the same exploit even if this function does
    // not exist by using the fallback
    function log() public {
        emit Log("Mal was called");
    }
}
