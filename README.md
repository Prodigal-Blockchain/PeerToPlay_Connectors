## Installation

1. Clone the repository:

   ```sh
   git clone
   cd
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
