// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract TodoList{
    struct Todo{
        string text;
        bool completed;
    }
    Todo[] public todos;
    function create(string calldata _text)external{
        todos.push(Todo({
            text:_text,
            completed:false
            }));
    }
    function updateText(unit _index,string calldata _text)external{
        todos[_index].text = _text;//单个数据用这个比较节省gas
        // Todo storage todo = todos[_index]; //多个数据用这个比较节省gas
        // todo.text = _text;
    }
    function get()external view returns(string memory,bool){//默认有get方法
         Todo storage todo = todos[_index];//存储中的是直接从状态变量中读取的比较节省gas
         return (todo.text,todo.completed);
        //  Todo memory todo = todos[_index];//需要经过一次拷贝，比较消耗gas
        //  return (todo.text,todo.completed);
    }
    function toggleCompleted(unit _index)external{

        todos[_index].completed = !todos[_index].completed;
    }
}