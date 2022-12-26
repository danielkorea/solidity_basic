// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
contract AccessControl{
    event GrantRole(bytes indexed role, address indexed account);
    evert RevokeRole(bytes indexed role, address indexed account);
    mapping(bytes32) => mapping(address => bool) public roles;
    bytes32 private constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    bytes32 private constant USER = keccak256(abi.encodePacked("USER"));
   
   modifier onlyRole(bytes _role){
       require(roles[_role][mesg.sender],"not authrized");
       _;
   }
   constructor(){
       _grantRole(ADMIN,msg.sender);
   }
    //获取权限内部调用
    function _grantRole(bytes _role, address _account) internal{
        roles[_role][_account] = true;
        emit GrantRole(_role,_account);
    }
    //获取权限外部调用
function grantRole(bytes _role, address _account) external onlyRole(ADMIN{
         _grantRole(_role,_account);
    }
//撤销权限
    function revokeRole(bytes _role, address _account) external onlyRole(ADMIN{
            roles[_role][_account] = false;
        emit RevokeRole(_role,_account);
    }


}