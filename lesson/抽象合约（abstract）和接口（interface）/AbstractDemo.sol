// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
/*即某个函数缺少主体{}中的内容，则必须将该合约标为abstract，不然编译会报错*/
abstract contract Base{
    string public name = "Base";
    function getAlias() public pure virtual returns(string memory);
}

contract BaseImpl is Base{
    function getAlias() public pure override returns(string memory){
        return "BaseImpl";
    }
}

