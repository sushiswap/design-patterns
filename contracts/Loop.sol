pragma solidity 0.8.11;

// Gas optimised for loops

contract Loop {

    function loop(uint256[] calldata array) external {

        uint256 n = array.length; // gas savings

        for(uint256 i = 0; i < n; i = increment(i)) { // gas savings

            // ...

        }

    }

    function increment(uint256 i) internal pure returns (uint256) {
        unchecked {
            return i = i + 1;
        }
    }

}