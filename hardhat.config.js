/** @type import('hardhat/config').HardhatUserConfig */
require('@nomicfoundation/hardhat-ethers');
require('@nomicfoundation/hardhat-ignition-ethers');

module.exports = {
  solidity: '0.8.20',
  networks: {
    dev: {
      url: 'http://127.0.0.1:9944', // Insert your RPC URL here
      chainId: 1281, // (hex: 0x501),
      accounts: ['0x5fb92d6e98884f76de468fa3f6278f8807c48bebc13595d45af5bdc4da702133'],
    },
    moonbase: {
      url: 'https://moonbase-alpha.public.blastapi.io', // Insert your RPC URL here
      chainId: 1287, // (hex: 0x507),
      accounts: ['878051c8817b5665c4848986bdce32413ab447416a4943e4f5199611ee9ece6b'],
    },
  },
};