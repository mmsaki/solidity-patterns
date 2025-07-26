# Function types

Various things you can do with functions in solidity.

## Function in base contract

- Can declare function as:
  - Internal
  - External
  - Private
  - Public

```solidity
contract C {
    /// normal function
    function(address) external {};
    function(address) internal {};
    function(address) public {};
    function(address) private {};
}
```

## Function as storage variable

- Can be declared as a storage variable
- Function type in storage must be external
  - [Securuty Issue #15716 Optimizer removes assembly block that initializes function](https://github.com/ethereum/solidity/issues/15716)

```solidity
contract C {
    /// storage varible of function type
    function(address) external returns (address) foo;
}
```


## Function as abstract contract

- Function can be declared inside an abstract contract.
- Function in abstract contracts means a function is not yet implemented
- When the abstract contract is inherited, you are expected to implement function.

```solidity
abstract contract C {
    /// interface 
    function foo(address) external returns (address);
}
```

- [Abstract Contracts Documentation](https://github.com/ethereum/solidity/blob/develop/docs/contracts/abstract-contracts.rst)

## function as interface

- Can declare function in interface

```solidity
interfac IC {
    /// interface 
    function foo(address) external returns (address);
}
```

## Function as a return type

- Can declare a function as return type
- Can dynamically change function in return type

```solidity
contract C {
    /// Declaration of a variable whose type is a function type
    function(address) external returns (bool) whenZero;

    /// A function with a function return type
    function changeFunc() public returns (function(address) external returns (bool)) {
        if (block.timestamp % 5 == 0) {
            whenZero = this.isZero;
            return whenZero;
        } else {
            whenZero = this.notZero;
            return whenZero;
        }
    }

    function isZero(address addr) public pure returns (bool) {
        return addr == address(0);
    }

    function notZero(address addr) public pure returns (bool) {
        return addr != address(0);
    }
}
```

## Function as a mutable object

- Can change function selector of returned function
- Can change function address (the contract with call context)

```solidity
contract C {
    /// Change function object assembly
    function changeFuncAssembly(address newAddr, uint256 newSelector) public view returns (function() external func) {
        assembly {
            func.selector := newSelector
            func.address := newAddr
        }
        assert(newAddr == address(this));
        assert(func.address == address(this));
    }
}
```

## Function as function input

- Can use a function as an input to a function

```solidity
contract c {
    /// function as an input variable
    function foo(function(uint256) external returns (bool) f, uint256 a) public {
        f(a);
    }
}
```

## Use Cases

- [Resources for functioin value types](https://github.com/ethereum/solidity/blob/459ad2463c409a9d746f0fc7630ff7680e6a57b1/docs/types/value-types.rst#L993)
Example that shows how to use internal function types:

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

library ArrayUtils {
    // internal functions can be used in internal library functions because
    // they will be part of the same code context
    function map(uint[] memory self, function (uint) pure returns (uint) f)
        internal
        pure
        returns (uint[] memory r)
    {
        r = new uint[](self.length);
        for (uint i = 0; i < self.length; i++) {
            r[i] = f(self[i]);
        }
    }

    function reduce(
        uint[] memory self,
        function (uint, uint) pure returns (uint) f
    )
        internal
        pure
        returns (uint r)
    {
        r = self[0];
        for (uint i = 1; i < self.length; i++) {
            r = f(r, self[i]);
        }
    }

    function range(uint length) internal pure returns (uint[] memory r) {
        r = new uint[](length);
        for (uint i = 0; i < r.length; i++) {
            r[i] = i;
        }
    }
}


contract Pyramid {
    using ArrayUtils for *;

    function pyramid(uint l) public pure returns (uint) {
        return ArrayUtils.range(l).map(square).reduce(sum);
    }

    function square(uint x) internal pure returns (uint) {
        return x * x;
    }

    function sum(uint x, uint y) internal pure returns (uint) {
        return x + y;
    }
}
```

An oracle callback contract using external function types.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;


contract Oracle {
    struct Request {
        bytes data;
        function(uint) external callback;
    }

    Request[] private requests;
    event NewRequest(uint);

    function query(bytes memory data, function(uint) external callback) public {
        requests.push(Request(data, callback));
        emit NewRequest(requests.length - 1);
    }

    function reply(uint requestID, uint response) public {
        // Here goes the check that the reply comes from a trusted source
        requests[requestID].callback(response);
    }
}


contract OracleUser {
    Oracle constant private ORACLE_CONST = Oracle(address(0x00000000219ab540356cBB839Cbe05303d7705Fa)); // known contract
    uint private exchangeRate;

    function buySomething() public {
        ORACLE_CONST.query("USD", this.oracleResponse);
    }

    function oracleResponse(uint response) public {
        require(
            msg.sender == address(ORACLE_CONST),
            "Only oracle can call this."
        );
        exchangeRate = response;
    }
}
```
