import { DeployFunction } from "hardhat-deploy/dist/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const func: DeployFunction = async function ({
  getNamedAccounts,
  deployments,
}: HardhatRuntimeEnvironment) {
  const { deploy } = deployments;

  const { deployer } = await getNamedAccounts();

  const { address } = await deploy("Greeter", {
    from: deployer,
    args: ["Hello, world!"],
  });

  console.log(`Greeter deployed to ${address}`);
};

export default func;
