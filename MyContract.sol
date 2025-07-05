// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    address public owner;

    enum Status { Created, Shipped, Received }

    struct Product {
        uint id;
        string name;
        address currentOwner;
        Status status;
    }

    uint public nextProductId = 1;
    mapping(uint => Product) public products;

    event ProductCreated(uint id, string name, address indexed owner);
    event ProductShipped(uint id, address indexed newOwner);
    event ProductReceived(uint id);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createProduct(string memory _name) public onlyOwner {
        products[nextProductId] = Product(nextProductId, _name, msg.sender, Status.Created);
        emit ProductCreated(nextProductId, _name, msg.sender);
        nextProductId++;
    }

    function shipProduct(uint _id, address _to) public {
        Product storage product = products[_id];
        require(msg.sender == product.currentOwner, "Not current owner");
        product.currentOwner = _to;
        product.status = Status.Shipped;
        emit ProductShipped(_id, _to);
    }

    function receiveProduct(uint _id) public {
        Product storage product = products[_id];
        require(msg.sender == product.currentOwner, "Not recipient");
        product.status = Status.Received;
        emit ProductReceived(_id);
    }
}
