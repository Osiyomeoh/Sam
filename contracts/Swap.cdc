import FungibleToken from 0x05
import FlowToken from 0x05
import MyFungibleToken from 0x05

pub contract Swap {

    pub var lastSwapTimes: {Address: UFix64}

    pub var flowVault: @FlowToken.Vault

    pub resource interface IdentityPublic {
        pub fun getOwnerId(): Address
    }

    pub resource Identity: IdentityPublic {
    pub let ownerId: Address

    init(ownerId: Address) {
        self.ownerId = ownerId
    }

    pub fun getOwnerId(): Address {
        return self.ownerId
    }
}



    pub fun getCurrentTime(): UFix64 {
        return getCurrentBlock().timestamp
    }

    pub event TokensSwapped(flowAmount: UFix64, customTokenAmount: UFix64, swapper: Address)

   

    pub fun createIdentity(ownerId: Address): @Identity {
        return <- create Identity(ownerId: ownerId)
    }

   pub fun swapWithIdentity(identity: @Identity, payment: @FlowToken.Vault) {
    let sender = identity.ownerId
    let lastSwapTime = self.lastSwapTimes[sender] ?? 0.0
    let currentTime = self.getCurrentTime()
    let elapsedTime = currentTime - lastSwapTime
    let paymentBalance = payment.balance

    self.flowVault.deposit(from: <- payment)

    // Calculate the amount of tokens to mint based on elapsed time
    let mintedTokensAmount = elapsedTime * 2.0

    // Call the depositTo function from MyFungibleToken contract to mint and deposit tokens
    MyFungibleToken.depositTo(recipient: sender, amount: mintedTokensAmount)

    self.lastSwapTimes[sender] = currentTime

    emit TokensSwapped(flowAmount: paymentBalance, customTokenAmount: mintedTokensAmount, swapper: sender)

    destroy identity
}



    // Function using a reference to the user's FlowToken.Vault
  pub fun swapWithVaultRef(vaultRef: &FlowToken.Vault, amount: UFix64) {
    let sender = vaultRef.owner?.address ?? panic("Vault has no owner.")
    let lastSwapTime = self.lastSwapTimes[sender] ?? 0.0
    let currentTime = self.getCurrentTime()
    let elapsedTime = currentTime - lastSwapTime

    // Withdraw the specified amount from the user's FlowToken vault for swapping
    let payment <- vaultRef.withdraw(amount: amount)
    self.flowVault.deposit(from: <- payment)

    // Mint custom tokens based on elapsed time since the last swap
    MyFungibleToken.depositTo(recipient: sender, amount: elapsedTime * 2.0)

    self.lastSwapTimes[sender] = currentTime

    emit TokensSwapped(flowAmount: amount, customTokenAmount: elapsedTime * 2.0, swapper: sender)
}



    

    init() {
        self.flowVault <- FlowToken.createEmptyVault()
        self.lastSwapTimes = {}
    }
}