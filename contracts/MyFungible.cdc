import FungibleToken from 0x05
import FlowToken from 0x05

access(all) contract MyFungibleToken: FungibleToken {

    pub event TokensInitialized(initialSupply: UFix64)
    pub event TokensWithdrawn(amount: UFix64, from: Address?)
    pub event TokensDeposited(amount: UFix64, to: Address?)
    pub var totalSupply: UFix64

     // Store the Admin's address
    pub let adminAddress: Address

    // Function to check if an address is the Admin
    pub fun isAdmin(addr: Address): Bool {
        return addr == self.adminAddress
    }


    pub resource Vault: FungibleToken.Provider, FungibleToken.Receiver, FungibleToken.Balance {
        pub var balance: UFix64

        pub fun deposit(from: @FungibleToken.Vault) {
            let vault <- from as! @MyFungibleToken.Vault
            emit TokensDeposited(amount: vault.balance, to: self.owner?.address)
            self.balance = self.balance + vault.balance
            vault.balance = 0.0 // Set balance to 0.0 before destroying
            destroy vault
        }

        pub fun withdraw(amount: UFix64): @Vault {
            self.balance = self.balance - amount
            emit TokensWithdrawn(amount: amount, from: self.owner?.address)
            return <- create Vault(balance: amount)
        }

        destroy() {
            MyFungibleToken.totalSupply = MyFungibleToken.totalSupply - self.balance
        }

        init(balance: UFix64) {
            self.balance = balance
        }
    }

    pub resource Minter {
        pub fun mintToken(amount: UFix64): @FungibleToken.Vault {
            MyFungibleToken.totalSupply = MyFungibleToken.totalSupply + amount
            return <- create Vault(balance: amount)
        }

        init(){}
    }

    pub fun createEmptyVault(): @MyFungibleToken.Vault {
        return <- create Vault(balance: 0.0)
    }

   



    init(adminAddress: Address) {
         self.totalSupply = 1000.0

        // Define initial admin balance
        let initialAdminBalance: UFix64 = 100.0 // Example value
        self.adminAddress = adminAddress
        self.account.save(<- create Minter(), to: /storage/MyFungibleTokenMinter)

        // Create and store the Admin Vault
        let adminVault <- create Vault(balance: initialAdminBalance)
        self.account.save(<-adminVault, to: /storage/adminVault)
        self.account.link<&MyFungibleToken.Vault{FungibleToken.Provider}>(
            /private/adminVault,
            target: /storage/adminVault
        )

       
    }

    // A public function to expose minting capability in a controlled way
    pub fun mintTokens(amount: UFix64) {
        let minter = self.account.borrow<&MyFungibleToken.Minter>(from: /storage/MyFungibleTokenMinter)
            ?? panic("Could not borrow a reference to the minter")

        // Mint tokens and do something with them, like sending to a specific account
        // Example: deposit to the contract owner's vault
    }
      pub fun depositTo(recipient: Address, amount: UFix64) {
        // Borrow the Minter resource from the contract's storage
        let minter = self.account.borrow<&MyFungibleToken.Minter>(from: /storage/MyFungibleTokenMinter)
            ?? panic("Could not borrow a reference to the minter")

        // Use the minter to mint new tokens
        let mintedTokensVault <- minter.mintToken(amount: amount)

        // Borrow a reference to the recipient's Vault
        let recipientVaultRef = getAccount(recipient).getCapability(/public/MyFungibleTokenReceiver)
                               .borrow<&Vault{FungibleToken.Receiver}>()
                               ?? panic("Could not borrow reference to the recipient's MyFungibleToken Vault")

        // Deposit the minted tokens into the recipient's Vault
        recipientVaultRef.deposit(from: <- mintedTokensVault)
    }
}