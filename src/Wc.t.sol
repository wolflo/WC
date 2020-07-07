pragma solidity ^0.6.6;

import "ds-test/test.sol";

contract WcTest is DSTest {

    function setUp() public { }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
