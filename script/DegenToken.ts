import hre from "hardhat";

const main = async () => {
  console.log(
    "######### Deploying DegenToken Contract To Base Network #########"
  );
  const DegenToken = await hre.ethers.getContractFactory("DegenToken");
  const degenToken = await DegenToken.deploy();

  console.log(
    "DegenTokenContractAddress deployed to Base:",
    await degenToken.getAddress()
  );

  const ownerAddress = await degenToken.owner();
  const signer = await hre.ethers.getSigner(ownerAddress);

  console.log("######### Minting Tokens #########");
  const mintAmount = hre.ethers.parseUnits("1000000", 18); // Mint 1,000,000 tokens
  await degenToken.connect(signer).mint(ownerAddress, mintAmount);

  const ownerBalance = await degenToken.balanceOf(ownerAddress);
  console.log(
    "Owner balance after mint:",
    hre.ethers.formatUnits(ownerBalance, 18).toString()
  );

  console.log("######### Approving and Transferring Tokens #########");
  const recipientAddress = "0xA6bFcA8DAd54238a6c0951bcbA0b66A7Ace5DaAC"; // Replace with a recipient address
  const transferAmount = hre.ethers.parseUnits("100", 18); // Transfer 100 tokens

  await degenToken.connect(signer).approve(recipientAddress, transferAmount);
  await degenToken.connect(signer).transfer(recipientAddress, transferAmount);

  const recipientBalance = await degenToken.balanceOf(recipientAddress);
  console.log(
    "Recipient balance after transfer:",
    hre.ethers.formatUnits(recipientBalance, 18).toString()
  );

  console.log("######### Redeeming Item #########");
  const itemId = 0; // Item ID for "Health"
  await degenToken.connect(signer).redeemItem(itemId);

  const newOwnerBalance = await degenToken.balanceOf(ownerAddress);
  console.log(
    "Owner balance after redeeming item:",
    hre.ethers.formatUnits(newOwnerBalance, 18).toString()
  );

  console.log("######### Transferring Ownership #########");
  const newOwner = "0xA6bFcA8DAd54238a6c0951bcbA0b66A7Ace5DaAC"; // Replace with new owner address
  await degenToken.connect(signer).transferOwnership(newOwner);

  console.log("Ownership transferred to:", newOwner);

  const degenTokenInstance = await hre.ethers.getContractAt(
    "DegenToken",
    await degenToken.getAddress()
  );

  console.log("######### Fetching Store Items #########");

  const storeItems = await degenTokenInstance.getAllItems();
  console.table(
    storeItems.map((item, index) => ({
      index,
      name: item.name,
      cost: hre.ethers.formatUnits(item.cost, 18),
    }))
  );

  const itemsToRedeem = [0, 1];

  console.log("######### Checking Balance Before Redemption #########");
  const initialBalance = await degenTokenInstance.balanceOf(ownerAddress);
  console.log("Initial Balance:", hre.ethers.formatUnits(initialBalance, 18));

  console.log("######### Redeeming Selected Items #########");
  for (const itemId of itemsToRedeem) {
    const item = storeItems[itemId];
    console.log(`Redeeming Item: ${item.name} with cost: ${item.cost} DEGEN`);
    await degenTokenInstance.connect(signer).redeemItem(itemId);
  }

  console.log("######### Checking Balance After Redemption #########");
  const finalBalance = await degenTokenInstance.balanceOf(ownerAddress);
  console.log("Final Balance:", hre.ethers.formatUnits(finalBalance, 18));
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
