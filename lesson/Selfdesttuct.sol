// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Kill{
    constructor() payable{

    }
    function kill() external{
        selfdestruct(payable(msg.sender));//自毁，强制合约强制发送主币
    }

// function test() external pure returns (unit){
//     return 123;
// }
 
}

contract Helper{
    // function getBalance() external view returns (unit){
    //     return address(this).balance;
    // }
    function kill(Kill _kill)external{
        _kill.kill();
    }
}