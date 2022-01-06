import { expect } from "chai";
import { ethers } from "hardhat";

describe("ProxyFactory", function () {
  it("Emits ProxyCreated with expected arguments", async function () {
    const ProxySubject = await ethers.getContractFactory("ProxySubject");
    const proxySubject = await ProxySubject.deploy();

    await proxySubject.deployed();

    const ProxyFactory = await ethers.getContractFactory("ProxyFactory");
    const proxyFactory = await ProxyFactory.deploy(proxySubject.address);

    await proxyFactory.deployed();

    await expect(proxyFactory.create("foo"))
      .to.emit(proxyFactory, "ProxyCreated")
      .withArgs("0x61c36a8d610163660E21a8b7359e1Cac0C9133e1", "foo");
  });
});
