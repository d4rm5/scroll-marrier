# Scroll Marrier 📜

My project for Scroll x Alchemy Mini Hackathon! dApp for marry on Scroll chain!

My motivation was keep learning in my smart contract development journey. In this project I learned about many things like OpenZeppelin contratcs, EIP-712 sigantures, ERC-712 tokens, Soulbound NFTs, Foundry usage, Wagmi hooks and RainBow Kit configuration.

## Structure

### This repo
Foundry project with two contracts:
1. `Marriage.sol`: a soulbound NFT that contains marriage data.
2. `MarriageFactory.sol`: a factory that generates marriages using EIP-712 signatures.

### [Front-end](https://github.com/d4rm5/scroll-marrier-react)
Vite + React + Viem + RainbowKit project with two pages:
1. Scroll Marrier main: a page to start a marriage process.
2. Signature page: a page to sign marriage.
