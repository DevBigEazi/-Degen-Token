// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract DegenToken {
    //the state variables
    string public name = "Degen Gaming Token";
    string public symbol = "DEGEN";
    uint256 public totalSupply;
    uint8 public decimals = 18;

    address public owner;

    //store item struct
    struct Item {
        string name;
        uint256 cost;
    }

    Item[] public items; //array

    //making an amount tracable by address
    mapping(address user => uint256) balances;

    //key => (key => value)
    mapping(address => mapping(address => uint256)) allow;

    constructor() {
        owner = msg.sender;
        //mint method
        mint(msg.sender, 1000000 * (10 ** decimals));

        _addStoreItem("Health", 70);
        _addStoreItem("Skins", 55);
        _addStoreItem("Emblems", 30);
        _addStoreItem("Weapon", 80);
        _addStoreItem("Diamond", 100);
    }

    // event for logging
    event Transfer(
        address indexed sender,
        address indexed reciever,
        uint256 amount
    );

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    event ItemRedeemed(address indexed player, string itemName, uint256 amount);

    //modifier
    modifier hasToken(uint256 _amount) {
        require(balanceOf(msg.sender) >= _amount, "Not enough Degen Token");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner is authorized");
        _;
    }

    //balance check
    function balanceOf(address _address) public view returns (uint256) {
        return balances[_address];
    }

    //the store items
    function _addStoreItem(string memory _name, uint256 _cost) private {
        items.push(Item(_name, _cost));
    }

    //get All Items
    function getAllItems() public view returns (Item[] memory) {
        return items;
    }

    //redeem item function
    function redeemItem(uint8 _itemId) external {
        require(_itemId < items.length, "Invalid item ID");

        Item memory item = items[_itemId];

        require(balanceOf(msg.sender) >= item.cost, "Insufficient balance");

        transfer(address(this), item.cost);

        emit ItemRedeemed(msg.sender, item.name, item.cost);
    }

    function transfer(address _reciever, uint256 _amountOfToken) public {
        require(_reciever != address(0), "Address zero is not allowed");
        require(msg.sender != address(0), "Address zero is not allowed");

        require(
            _amountOfToken <= balances[msg.sender],
            "Insufficient balance for this transfer"
        );

        balances[msg.sender] = balances[msg.sender] - _amountOfToken;

        balances[_reciever] = balances[_reciever] + _amountOfToken;

        emit Transfer(msg.sender, _reciever, _amountOfToken);
    }

    function approve(address _delegate, uint256 _amountOfToken) external {
        require(msg.sender != address(0), "Address zero is not allowed");
        require(balances[msg.sender] > _amountOfToken, "Balance is not enough");

        allow[msg.sender][_delegate] = _amountOfToken;

        emit Approval(msg.sender, _delegate, _amountOfToken);
    }

    function allowance(
        address _owner,
        address _delegate
    ) external view returns (uint) {
        return allow[_owner][_delegate];
    }

    function transferFrom(
        address _owner,
        address _buyer,
        uint256 _amountOfToken
    ) external {
        //sanity check
        require(_owner != address(0), "Address zero is not allowed");
        require(_buyer != address(0), "Address zero is not allowed");

        require(_amountOfToken <= balances[_owner]);
        require(_amountOfToken <= allow[_owner][msg.sender]);

        balances[_owner] = balances[_owner] - _amountOfToken;

        allow[_owner][msg.sender] = allow[_owner][msg.sender] - _amountOfToken;

        balances[_buyer] = balances[_buyer] + _amountOfToken;

        emit Transfer(_owner, _buyer, _amountOfToken);
    }

    function burn(uint256 _amount) public hasToken(_amount) {
        balances[msg.sender] = balances[msg.sender] - _amount;
        totalSupply = totalSupply - _amount;

        emit Transfer(msg.sender, address(0), _amount);
    }

    //method called in the constructor
    function mint(address to, uint256 _amount) public onlyOwner {
        uint256 actualSupply = _amount * (10 ** decimals);

        balances[to] = balances[to] + actualSupply;

        totalSupply = totalSupply + actualSupply;

        emit Transfer(address(0), to, actualSupply);
    }

    function transferOwnership(address _newOwner) external onlyOwner {
        owner = _newOwner;
    }
}
