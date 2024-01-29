

# Flow Blockchain Cadence Contracts

## Overview
This repository contains a collection of Cadence smart contracts designed for the Flow blockchain. These contracts implement various functionalities, including fungible token standards, token swapping mechanisms, and vault management, among others.

## Contracts

### FungibleToken
Implements the standard fungible token interface for the Flow blockchain, providing a foundation for creating custom tokens with interoperable features.

### FlowToken
A contract that represents the Flow native token, including functionalities for token transfers, balance inquiries, and vault management.

### MyFungibleToken
A custom fungible token contract built on top of the FungibleToken standard, demonstrating how to create and manage your own token on Flow.

### Swap
A contract that facilitates token swapping functionalities, allowing users to exchange Flow tokens for MyFungibleToken tokens based on predefined logic.

## Getting Started

### Prerequisites
- [Flow CLI](https://docs.onflow.org/flow-cli/install/): A command-line interface to interact with Flow blockchain.
- [Flow Emulator](https://docs.onflow.org/flow-cli/start-emulator/): Local environment for testing Flow applications.

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/<repository-name>.git
   ```
2. Navigate to the repository directory:
   ```bash
   cd <repository-name>
   ```
3. Start the Flow emulator:
   ```bash
   flow emulator start
   ```

### Deployment
Deploy contracts to the Flow emulator using Flow CLI:
```bash
flow project deploy --network=emulator
```

## Usage
Interact with the contracts using Flow CLI or Cadence transactions and scripts.

### Example: Token Swap
1. Execute a token swap transaction:
   ```bash
   flow transactions send ./transactions/swapTokens.cdc <amount> --signer emulator-account
   ```
2. Query the balance after the swap:
   ```bash
   flow scripts execute ./scripts/checkBalance.cdc <account-address>
   ```

## Development
- Use Flow Playground for prototyping and testing contract logic: [Flow Playground](https://play.onflow.org/)
- Follow Cadence [best practices](https://docs.onflow.org/cadence/language/) for secure and efficient contract development.


## License
Distributed under the MIT License. See [LICENSE](LICENSE) for more information.

## Acknowledgments
- [Flow Documentation](https://docs.onflow.org/)
- [Cadence Language Repository](https://github.com/onflow/cadence)
