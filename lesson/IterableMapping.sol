// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract IterableMapping{
    mapping(address=>unit)public balances;
    mapping(address=>bool)public inserted;
    address[] public keys;
    function set(address _key,unit _value)external{
        balances[_key]=_value;
        if(!inserted[_key]){
            inserted[_key]= true;
            keys.push[_key];
        }
    }
    function getSize()external view returns(unit){
        return keys.lenghth;
    }
    function first()external view returns (unit){
        return balances[keys[0]];

    }
    function last() external view returns(unit){
        return balances[keys[keys.length-1]];
    }
    function get(unit _i)external view returns(unit){
        return balances[keys[_i]];
    }

}