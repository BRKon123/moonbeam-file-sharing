const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  const contractAddress = "0xcA2a0C49C6197eFd002991d8bf830ef3A37F93Fc"; // Replace with your contract address
  const Contract = await ethers.getContractFactory("FileSharing");
  const contract = Contract.attach(contractAddress);

  const fileId = 1; // Replace with your desired fileId
  const granteeAddress = "0xf24FF3a9CF04c71Dbc94D0b566f7A27B94566cac"; // Make sure the address is a string
  const cid = "QmExampleCid"; // Replace with the actual CID of the file
  const encryptedKey = "EncryptedSymmetricKey"; // Replace with the actual encrypted key

  await contract.grantAccess(fileId, granteeAddress, cid, encryptedKey);
  console.log(`Access granted to ${granteeAddress} for fileId ${fileId}`);

  const userFiles = await contract.getUserFiles(granteeAddress);
  console.log(`Files accessible by ${granteeAddress}: ${userFiles}`);

  const key = await contract.getEncryptedKey(fileId, granteeAddress);
  console.log(`Encrypted key for grantee: ${key}`);

  const hasAccess = await contract.hasAccess(fileId, granteeAddress);
  console.log(`Grantee has access: ${hasAccess}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
