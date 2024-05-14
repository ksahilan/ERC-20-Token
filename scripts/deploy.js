async function main() {
    const MyToken = await ethers.getContractFactory("KSAToken");

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
