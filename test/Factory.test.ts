import { expect } from "chai";
import { ethers } from "hardhat";

describe("Factory", function() {
  it("Emits Deployed with expected arguments", async function() {
    const Factory = await ethers.getContractFactory("Factory");
    const factory = await Factory.deploy();

    await factory.deployed();

    await expect(factory.deploy())
      .to.emit(factory, "Deployed")
      .withArgs("0xa16E02E87b7454126E5E10d957A927A7F5B5d2be");
  });
});
