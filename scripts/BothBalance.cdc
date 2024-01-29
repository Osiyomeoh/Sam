import FungibleToken from 0x05 
import FlowToken from 0x05 
import MyFungibleToken from 0x05 

pub fun main(accountAddress: Address): {String: UFix64} {
    let account = getAccount(accountAddress)
    
    // For FlowToken
    let flowBalanceCapability = account.getCapability<&FlowToken.Vault{FungibleToken.Balance}>(/public/FlowTokenBalance)
    let flowVaultRef = flowBalanceCapability.borrow() ?? panic("Could not borrow reference to the user's FlowToken Vault")
    let flowBalance = flowVaultRef.balance

    // For MyFungibleToken
    let myTokenBalanceCapability = account.getCapability<&MyFungibleToken.Vault{FungibleToken.Balance}>(/public/MyFungibleTokenBalance)
    let myTokenVaultRef = myTokenBalanceCapability.borrow() ?? panic("Could not borrow reference to the user's MyFungibleToken Vault")
    let myTokenBalance = myTokenVaultRef.balance

    return {
        "FlowToken Balance": flowBalance,
        "MyFungibleToken Balance": myTokenBalance
    }
}
