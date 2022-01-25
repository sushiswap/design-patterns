pragma solidity 0.8.11;

// Efficient single hop swap without relying on UniswapV2Lib

import "@rari-capital/solmate/src/utils/SafeTransferLib.sol";

interface IUniswapV2Pair {
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

contract Swapper {

    using SafeTransferLib for ERC20;

    address public immutable factory;

    constructor(address _factory) {
        factory = _factory;
    }

    function swap(
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        uint256 amountOutMin
    ) external returns (uint256 outAmount) {

        address pair = _pairFor(tokenIn, tokenOut);

        ERC20(tokenIn).safeTransfer(pair, amountIn);

        (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(pair).getReserves();

        if (tokenIn < tokenOut) {
            outAmount = _getAmountOut(amountIn, reserve0, reserve1);
            IUniswapV2Pair(pair).swap(0, outAmount, address(this), "");
        } else {
            outAmount = _getAmountOut(amountIn, reserve1, reserve0);
            IUniswapV2Pair(pair).swap(outAmount, 0, address(this), "");
        }

        require(outAmount > amountOutMin);
    }

    function _getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) internal pure returns (uint256) {
        uint256 amountInWithFee = amountIn * 997;
        uint256 numerator = amountInWithFee * reserveOut;
        uint256 denominator = reserveIn * 1000 + amountInWithFee;
        return numerator / denominator;
    }

    function _pairFor(address tokenA, address tokenB) internal view returns (address) {
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        return address(uint160(uint256(keccak256(abi.encodePacked(
            hex'ff',
            factory,
            keccak256(abi.encodePacked(token0, token1)),
            hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303'
        )))));
    }

}