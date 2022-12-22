// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract Proxy{
    event Deploy(address);
    function deploy(bytes memory _code)external payable returns (address Address){
     assembly{
          addr =  create(functionCallWithValue(),add(_code,0x20),mload(_code));
     }
    require(addr != address(0)
    }

}