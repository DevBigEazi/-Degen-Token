import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const DegenTokenModule = buildModule("DegenTokenModule", (m) => {
  const degenToken = m.contract("DegenToken");

  return { degenToken };
});

export default DegenTokenModule;
