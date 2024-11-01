import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";

describe("DegenToken", function () {
  async function deployDegenTokenFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await hre.ethers.getSigners();

    const DegenToken = await hre.ethers.getContractFactory("DegenToken");
    const degenToken = await DegenToken.deploy();

    return { degenToken };
  }
});
