pragma solidity ^0.4.18;


import "./StandardToken.sol";
import "./SafeMath.sol";

contract BLKGToken is StandardToken {
    using SafeMath for uint256;

    // metadata
    string public constant name = "Blockagram Token";
    string public constant symbol = "BLKG";
    uint256 public constant decimals = 18;
    string public version = "1.0";

    uint256 public constant INITIAL_SUPPLY = 1500000000 * (10 ** uint256(decimals));

    // constructor
    function BLKGToken() public {
        totalSupply = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
    }

    // bulk transfer to lower transaction costs
    function bulkTransfer(address[] _addresses, uint256[] _amounts) public returns (bool) {
        uint256 total = 0;
        require(_amounts.length == _addresses.length);
        for (uint i = 0; i < _amounts.length; i++) {
            total = total.add(_amounts[i]);
            require(_addresses[i] != address(0));
        }

        require(total <= balances[msg.sender]);

        // SafeMath.sub will throw if there is not enough balance.
        balances[msg.sender] = balances[msg.sender].sub(total);
        for (uint j = 0; j < _amounts.length; j++) {
            balances[_addresses[j]] = balances[_addresses[j]].add(_amounts[j]);
            Transfer(msg.sender, _addresses[j], _amounts[j]);
        }
        return true;
    }
}