## Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/Prodigal-Blockchain/PeerToPlay_Connectors.git
   cd PeerToPlay_Connectors
   ```

2. Install the dependencies:

   ```sh
   npm install
   ```

3. Compile the contracts using Hardhat:
   ```sh
   npx hardhat compile
   ```

## Environment Setup

1. Create a `.env` file in the root directory and update it with your environment variables. For example:

   ```ini
   RPC_URL=your_infura_api_key
   PRIVATE_KEY=your_private_key
   ETHERSCAN_API=your_etherscan_apikey
   ```

## Deployment

To deploy the contracts, use the following command:

```sh
npx hardhat run scripts/deploy.js --network your_network
```

crate protocol =0x8e34306579d69a1be524ddAE72B73D75Abdf5455

CricketConnector-v1 connector=0x7d5A95d10c7d332Ce1C2818D9dCc8db211dddD0f

## Contracts Deployed

- **Cricket Protocol**: [0x8e34306579d69a1be524ddAE72B73D75Abdf5455](https://sepolia.etherscan.io/address/0x8e34306579d69a1be524ddAE72B73D75Abdf5455)
- **CricketConnector-v1**: [0x7d5A95d10c7d332Ce1C2818D9dCc8db211dddD0f](https://sepolia.etherscan.io/address/0x7d5A95d10c7d332Ce1C2818D9dCc8db211dddD0f)
