// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract DeployWithCreate2{
    address public owner;
    constructor(address _owner){
        owner = _owner;
    }
}
contract create2Factory{
    event Deploy(address addr);
    //加盐,通过改变盐来改变未来新部署合约的地址
    function delpoy(uint _salt)external{
        //方法一
        // DeployWithCreate2 _contract = new DeployWithCreate2(msg.sender);
        //方法二。加盐
         DeployWithCreate2 _contract = new DeployWithCreate2{
             salt:bytes32(_salt)
         }(msg.sender);
        emit Deploy(address(_contract));

    }

        //新地址 = hash("0xFF",创建者地址, salt, bytecode)
    function getAddress(bytes memory bytecode,uint _salt)
        public
        view
        returns (address)
    {
    
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),address(this),_salt,keccak256(bytecode)
            )
        );
        return address(uint160(uint(hash)));
        
    }
    //获取上面的bytecode
    function getBytecode(address _owner) public pure returns(bytes memory){
        bytes memory bytecode = type(DeployWithCreate2).creationCode;
        return abi.encodePacked(bytecode,abi.encode(_owner));
    }


}