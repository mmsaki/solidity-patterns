# Function types

Various things you can do with functions in solidity.
)

## Function in storage

Example of a declaration of a variable whose type is a function type:

> [Solidity Documentation](https://github.com/ethereum/solidity/blob/develop/docs/contracts/abstract-contracts.rst)

```solidity
abstract contract C {
    /// storage
    function(address) external returns (address) foo;
    /// interface 
    function foo(address) external returns (address);
}
```

### Security

- [Optimizer removes assembly block that initializes function](https://github.com/ethereum/solidity/issues/15716)
