import FungibleToken from 0x05

pub contract FlowToken: FungibleToken {

    pub event TokensInitialized(initialSupply: UFix64)
    pub event TokensWithdrawn(amount: UFix64, from: Address?)
    pub event TokensDeposited(amount: UFix64, to: Address?)
    pub var totalSupply: UFix64

    pub resource Vault: FungibleToken.Provider, FungibleToken.Receiver, FungibleToken.Balance {
        pub var balance: UFix64

        pub fun deposit(from: @FungibleToken.Vault) {
            let vault <- from as! @FlowToken.Vault
            self.balance = self.balance + vault.balance
            emit TokensDeposited(amount: vault.balance, to: self.owner?.address)
            vault.balance = 0.0
            destroy vault
        }

        pub fun withdraw(amount: UFix64): @Vault {
            self.balance = self.balance - amount
            emit TokensWithdrawn(amount: amount, from: self.owner?.address)
            return <-create Vault(balance: amount)
        }

        destroy() {
            FlowToken.totalSupply = FlowToken.totalSupply - self.balance
        }

        init(balance: UFix64) {
            self.balance = balance
        }
    }

    pub resource Minter {
        pub fun mintToken(amount: UFix64): @FungibleToken.Vault {
            FlowToken.totalSupply = FlowToken.totalSupply + amount
            return <-create Vault(balance: amount)
        }

        init() {}
    }

    pub fun createEmptyVault(): @FlowToken.Vault {
        return <-create Vault(balance: 0.0)
    }

    init() {
        self.totalSupply = 1000.0
        self.account.save(<-create Minter(), to: /storage/FlowTokenMinter)
    }

    pub fun mintTokens(amount: UFix64) {
        let minter = self.account.borrow<&FlowToken.Minter>(from: /storage/FlowTokenMinter)
            ?? panic("Could not borrow a reference to the minter")
        // Mint tokens and handle them as needed
    }
}
