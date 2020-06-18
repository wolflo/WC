pragma solidity ^0.5.15;

import "ds-test/test.sol";

import "./Wc.sol";

contract WcTest is DSTest {
    Wc wc;

    function setUp() public {
        wc = new Wc();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
