const HDWalletProvider = require('@truffle/hdwallet-provider');
const infuraKey = "eefb8ec8abeb4fe0b26ac31850c468b8";
const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();

module.exports = {
  
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
    },

    develop: {
      host: "127.0.0.1",
      port: 9545,
      network_id: "*",
    },

    test: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
    },

    rinkeby: {
      provider: () => new HDWalletProvider(mnemonic, `https://rinkeby.infura.io/v3/${infuraKey}`),
        network_id: 4,
        from: "0x49BF997b25e9C37Fd35D496ef9Cd0a31559E4f1a",
        gas: 4500000,
        gasPrice: 10000000000
    },
  },
  
  mocha: {
    timeout: 10000
  },

  compilers: {
    solc: {
      version: "0.5.16",
    }
  }
}
