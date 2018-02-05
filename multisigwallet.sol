pragma solidity ^0.4.0;


contract MultiSigWallet {
    address private _owner;
    mapping(address => uint8) private _owners;

    event DispositeFunds(address from, uint value);
    event WithDrawFunds(address to, uint value);
    event TransferFunds(address from, address to, uint value);

    modifier isOwner() {
        require(msg.sender == _owner);
        _;
    }

    modifier validOwner() {
        require(_owners[msg.sender] == 1 || msg.sender == _owner);
        _;
    }

    function MultiSigWallet() {
        _owner = msg.sender;
    }

    function addOwner(address newOwner) isOwner {
        _owners[newOwner] = 1;
    }

    function removeOwner(address oldOwner) isOwner {
        _owners[oldOwner] = 0;
    }

    function deposit(uint value) validOwner payable {
        DispositeFunds(msg.sender, value);
    }

    function withDraw(uint amount) validOwner {
        require(address(this).balance >= amount);
        msg.sender.transfer(amount);
        WithDrawFunds(msg.sender, amount);
    }

    function transferTO(address to, uint amount) validOwner {
        require(address(this).balance >= amount);
        msg.sender.transfer(amount);
        TransferFunds(msg.sender, to, amount);
    }

}