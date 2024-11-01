# DegenToken For Test

 Here is the link to the deployed contract on the Base L2 network
[0xAfb412d118e02A6668c1bCFC51f4D9E252555c1e](https://sepolia.basescan.org/address/0xafb412d118e02a6668c1bcfc51f4d9e252555c1e)


Here is the results after interacting with the contract;

<img width="955" alt="degen" src="https://github.com/user-attachments/assets/bdfb5173-ead5-46e4-8d42-82cadf64f86b">

To interact, run the following;

```
npx hardhat run script/DegenToken.ts --network baseSepolia
```
The interaction steps are;
1.  Deployed Degen token contract To Base network
2.  Minted Degen tokens to the owner
3.  The owner/signer approved and transfered of tokens to the reciever
4.  The signer was allowed to redeem Items
5.  The owner was allowed to transfer the Ownership of the Degen token contract
6.  Allowed the signer to Fetched Store Items
7.  Allowed signer to check balance before redemption
8.  Allowed signer to check balance after redemption
