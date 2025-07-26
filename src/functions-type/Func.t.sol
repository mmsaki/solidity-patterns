// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {C} from "./Func.sol";

contract TestFunc is Test {
    C c;

    function(address) external returns (bool) g;

    function setUp() public {
        c = new C();
    }

    function test_changeFunc() public {
        c.changeFunc();
        g = c.changeFunc();
        bool a = g(address(0));
        assertEq(a, false);

        skip(4);
        g = c.changeFunc();
        bool b = g(address(0));
        assertEq(b, true);
    }

    function test_changeFuncAssembly() public {
        c.changeFuncAssembly(address(c), 0);
        c.changeFuncAssembly(address(c), uint32(0x00c0ffee))();
    }
}
