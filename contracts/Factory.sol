// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import "hardhat/console.sol";

interface IFactory {
  event Deployed(address);

  function deploy() external;
}

contract Factory is IFactory {
  function deploy() external override(IFactory) {
    emit Deployed(address(new ERC20('Test', 'TEST')));
  }
}
