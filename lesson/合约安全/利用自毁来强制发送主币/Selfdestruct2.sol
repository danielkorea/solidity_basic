// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/*
forcing ether with selfdestruct
code 
preventative techniques
*/
contract Foo{
    function getBalance()public view returns(uint){
        return address(this).balance;
    }
}
contract Bar{
    function kill(address payable addr)public payable{
        selfdestruct(addr);
    }
}