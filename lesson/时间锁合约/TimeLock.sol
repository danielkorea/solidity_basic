// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
//运用场景： DAPP(需要再一段时间后做事情）
contract TimeLock{
    //抛出错误==============
    error NotOwnerError();//不是拥有者
    error AlreadyQueuedError(bytes32 txId);//已经在队列中
    error TimestampNotInRangeError(uint blockTimestamp,uint timestamp);//时间戳不在范围内
    error NotQueuedError(bytes32 txId);//不在队列中  
    error TimestampNotPassedError(uint blockTimestamp,uint timestamp);
    error TimestampExpiredError(uint blockTimestamp,uint expiresAt);//超过宽限期
    error TxFailedError();
//事件=======================
    event Queue(
        bytes32 indexed txId,
        address indexed target,
        uint value,
        string  func,
        bytes  data,
        uint timestamp
    );
    event Execute(
        bytes32 indexed txId,
        address indexed target,
        uint value,
        string  func,
        bytes  data,
        uint timestamp
    );
    event Cancel(bytes32 indexed txId);

    //最小值和最大值
    uint public constant MIN_DELAY = 10;//(秒s)
    uint public constant MAX_DELAY = 1000;
    //宽限期
    uint public constant GRACE_PERIOD = 1000;

    address public owner;
    mapping(bytes32 => bool)public queued;
    constructor(){
        owner = msg.sender;
    }
    receive() external payable{

    }

    modifier onlyOwner(){
        if(msg.sender != owner){
            revert NotOwnerError();
        }
        _;

    }
    function getTxId(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) public pure returns (bytes32 txId){
        return keccak256(abi.encode(_target,_value,_func,_data,_timestamp));
    }
    function queue(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) external onlyOwner{
        //create tx id
        bytes32 txId = getTxId(_target,_value,_func,_data,_timestamp);
        if(queued[txId]){
            revert AlreadyQueuedError(txId);
        }
        //check tx id unique
    //......|.........|............|............
    //     block   block+min     block+max
        
        //check timestamp
        if(_timestamp<block.timestamp+MIN_DELAY || _timestamp>block.timestamp+MAX_DELAY){
            revert TimestampNotInRangeError(block.timestamp,_timestamp);

        }

        //queue tx
        queued[txId] = true;
        emit Queue(txId,_target,_value,_func,_data,_timestamp);


    }
    function execute(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) external payable onlyOwner returns(bytes memory){
        bytes32 txId = getTxId(_target,_value,_func,_data,_timestamp);
        //check tx is queued
        if(!queued[txId]){
            revert NotQueuedError(txId);
        }
        //check block.timestamp>_timestamp
        if(block.timestamp<_timestamp){
            revert TimestampNotPassedError(block.timestamp,_timestamp);
        }
          //....|...........|............|............
    //       timestamp     timestamp+ grace period(宽限期)
        if(block.timestamp > _timestamp + GRACE_PERIOD){
            revert TimestampExpiredError(block.timestamp,_timestamp + GRACE_PERIOD);
        }
    
        //delete tx from queue
       queued[txId] = false;
        //execute the tx
        bytes memory data;
        if(bytes(_func).length > 0){
            data = abi.encodePacked(
                bytes4( keccak256(bytes(_func))),_data
               
             
            );
        }else{
            data = _data;
        }
        (bool ok, bytes memory res) = _target.call{value:_value}(data);
        if(!ok){
            revert TxFailedError();
        }
        emit Execute(txId, _target, _value, _func, _data, _timestamp);
        return res;
    }
    function cancel(bytes32 _txId) external onlyOwner{
        if(!queued[_txId]){
            revert NotQueuedError(_txId);
        } 
        queued[_txId] = false;
        emit Cancel(_txId);
    }

}
contract TestTimeLock{
    address public addressTimeLock;
    constructor(address _timeLock){
        addressTimeLock = _timeLock;
    }
    function test() external{
        // require(msg.sender == addressTimeLock,"not timelock");//会报错，不知道啥原因
    }

    function getTimestamp()external view returns (uint){
        return block.timestamp + 100;
    }
}