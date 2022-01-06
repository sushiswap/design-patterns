// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import "hardhat/console.sol";

interface Proxy {
  function create(string calldata) external;
}

contract ProxySubject is Proxy {
  string public data;

  function create(string calldata _data) external override(Proxy) {
    data = _data;
  }
}

contract ProxyFactory {
  address public subject;

  Proxy[] public proxies;

  event ProxyCreated(address, string);

  constructor(address _subject) {
    subject = _subject;
  }

  function create(string calldata data) external {
    address proxyAddress;

    bytes20 targetBytes = bytes20(subject);

    assembly {
      let clone := mload(0x40)
      mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
      mstore(add(clone, 0x14), targetBytes)
      mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
      proxyAddress := create(0, clone, 0x37)
    }

    Proxy proxy = Proxy(proxyAddress);

    proxies.push(proxy);

    proxy.create(data);

    emit ProxyCreated(proxyAddress, data);
  }
}
