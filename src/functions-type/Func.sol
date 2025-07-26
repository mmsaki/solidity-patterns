// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

contract C layout at 42 {
    uint256 private number;
    event Success();

    /// Declaration of a variable whose type is a function type
    function(address) external returns (bool) whenZero;

    /// A function with a function return type
    function changeFunc()
        public
        returns (function(address) external returns (bool))
    {
        if (block.timestamp % 5 == 0) {
            whenZero = this.isZero;
            return whenZero;
        } else {
            whenZero = this.notZero;
            return whenZero;
        }
    }

    /// Change function selector assembly
    function changeFuncAssembly(
        address newAddr,
        uint newSelector
    ) public view returns (function() external func) {
        assembly {
            func.selector := newSelector
            func.address := newAddr
        }
        assert(newAddr == address(this));
        assert(func.address == address(this));
    }

    function isZero(address addr) public pure returns (bool) {
        return addr == address(0);
    }

    function notZero(address addr) public pure returns (bool) {
        return addr != address(0);
    }

    fallback() external {
        emit Success();
    }
}
