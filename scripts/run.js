const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract depoloyed to:", nftContract.address);

  // Call the mint function.
  let txn = await nftContract.makeAnEpicNFT();
  // Wait for NFT to be mined.
  await txn.wait();

  // Mint another NFT.
  txt = await nftContract.makeAnEpicNFT();
  await txn.wait();
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
