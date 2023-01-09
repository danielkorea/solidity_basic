// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract Enum{
    enum Status{
        None,
        Pending,
        Shipped,
        Completed,
        Rejected,
        Canceled
    }
    Status public status;
    struct Order{
        address buyer;
        Status status;//结构体元素嵌套
    }
    order[]public orders;
    function get()view returns (Status){
        return status;
    }
    function set(Status _status)external{
        status = _status;
    }
    function ship()external{
        status = status.shipped;
    }
    function reset()external{
        delete status;//默认为第一个值
    }

}