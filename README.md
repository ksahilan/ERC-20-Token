# Deploying your own ERC-20 token

Compiling and deploying an ERC-20 contract on **Sepolia testnet** using Hardhat in this assignment.

## Setting up the ERC-20 Project
1. Follow the instructions [here](https://www.respectedsir.com/ethlab/alchemy-api-key.html) to get an API key for Sepolia (not Goerli).

1.  Take note of the following:

    - `npx` commands are always run in the project root directory. Don't run them inside subdirectories.
    - **Never upload your `.env` files to Github**. It has your private key and Alchemy API key. These can be misused.

1. Create a new directory and enter it.
    ```
    mkdir my-token
    cd my-token
    ```
2. Initialize a new Node.js project.
    ```
    npm init -y
    ```
    The directory should contain a single file called `package.json`.
3. Install Hardhat by running the following command in the `my-token` directory.
    ```
    npm install --save-dev hardhat
    ```
    The `package.json` file will now have a `hardhat` section under `devDependencies`.
4. Create a Hardhat project by running the following command. 
    ```
    npx hardhat
    ```
    Select `Create a JavaScript project` and choose `Y` for installing `@nomicfoundation/hardhat-toolbox`.

    The directory will have a file called `hardhat.config.js` with the following contents.
    ```javascript
    require("@nomicfoundation/hardhat-toolbox");

    /** @type import('hardhat/config').HardhatUserConfig */
    module.exports = {
    solidity: "0.8.24",
    };
    ```
6. Create a file called `.env` in the project directory with the following contents.
    ```
    API_URL = "https://eth-sepolia.g.alchemy.com/v2/your-api-key"
    PRIVATE_KEY = "your-metamask-private-key"
    ```
    Follow [these instructions](https://metamask.zendesk.com/hc/en-us/articles/360015289632-How-to-Export-an-Account-Private-Key) to export your private key from Metamask. The `API_URL` needs to be copied from your Alchemy account.

    > NOTE: If you are going to push the project code to a public Github/Gitlab repository, remember to add the `.env` file to your `.gitignore`.

8. Update the `hardhat.config.js` file to have the following content.
    ```javascript
    require("@nomicfoundation/hardhat-toolbox");
    require('dotenv').config();

    const { API_URL, PRIVATE_KEY } = process.env;

    /** @type import('hardhat/config').HardhatUserConfig */
    module.exports = {
        solidity: "0.8.24",
        defaultNetwork: "sepolia",
        networks: {
            hardhat: {},
            sepolia: {
                url: API_URL,
                accounts: [`0x${PRIVATE_KEY}`]
            }
        },
    };

    ```
9. Your ERC-20 token will be based on the implementation by [OpenZeppelin](https://www.openzeppelin.com/). Install the Node.js package containing OpenZeppelin's contracts by running the following command in the project directory.
   ```
   npm install @openzeppelin/contracts
   ```
   The installed contracts can be found in the `node_modules` directory in your project directory. The path will be  `node_modules/@openzeppelin/contracts/`. We will be inheriting the ERC-20 implementation at `node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol`.

## Deploying the ERC-20 Contract

1. The project directory contains a `contracts` directory with a `Lock.sol` file. Delete it.
2. Create a new file in the `contracts` directory called `MyToken.sol`.
3. Copy and paste the following code into `MyToken.sol` **after** replacing `XYZ` with your initials. For example, my initials would be `SV`.

    ```javascript
    //SPDX-License-Identifier: Unlicense
    pragma solidity ^0.8.0;

    import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

    contract XYZToken is ERC20 {
        uint constant _initial_supply = 100 * (10**18);

        /* ERC 20 constructor takes in two strings:
         1. The name of your token name
         2. A symbol for your token
        */
        constructor() ERC20("XYZ Token", "XYZT") {
            _mint(msg.sender, _initial_supply);
        }
    }
    ```
4. Compile the contract by running the following command.
    ```
    npx hardhat compile
    ```
    You should see a message saying `Compiled 1 Solidity file successfully.`
5. Create a directory called `scripts`
    ```
    mkdir scripts
    ```
6. Create a file called `deploy.js` in the `scripts` directory with the following content. **Note:** Change "XYZToken" to the name of your contract.
    ```javascript
    async function main() {
        const MyToken = await ethers.getContractFactory("XYZToken");

        const my_token_promise = await MyToken.deploy();
        const my_token = await my_token_promise.waitForDeployment();
        const my_token_address = await my_token.getAddress();
        console.log("ERC-20 contract deployed to address:", my_token_address);
    }

    main()
        .then(() => process.exit(0))
        .catch(error => {
            console.error(error);
            process.exit(1);
    });
    ```
7. Deploy the contract by running the following command.
    ```
    npx hardhat run scripts/deploy.js --network sepolia
    ```
    You should see a message of the following form. The address will be different in your case.
    ```
    ERC-20 contract deployed to address: 0xbb8Ab9564596Ccbfe0C6eD49D7FdB056eE741CE5
    ```
8. Go to [https://sepolia.etherscan.io/token/[Your Token Address]](https://goerli.etherscan.io/) to see the token details. Notice that you have to enter the address of the newly created token in the URL.

9.  Follow the instructions in sections 4.1, 4.2 [here](https://www.respectedsir.com/ethlab/erc20/erc20.html) to deploy an ERC-20 token contract.
10. Follow the instructions in section 4.3 [here](https://www.respectedsir.com/ethlab/erc20/erc20.html) to transfer some your tokens to a different addresss.

11.    - My Sepolia ERC-20 contract: [HERE](https://sepolia.etherscan.io/address/0x73Af15775Fe4de5a62cbee0516465Fa8eBB125D0)

    - Sepolia Transaction transferring my token: [HERE](https://sepolia.etherscan.io/tx/0x3c0dbfa16ce9b5185cd34d774a225dac5460c83b02df0c8340c0a7910370dbc4)
