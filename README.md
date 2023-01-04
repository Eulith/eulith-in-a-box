# Eulith In a Box
This repo contains a standalone docker image (`eulith-devrpc`) 
that can be used to test your integration with Eulith.

When you run `eulith-devrpc`, you get:
1. A local Anvil development chain
2. The full Eulith webserver
3. Trivial forking support for Ethereum Mainnet and Goerli
4. Pre-funded wallets with ETH and WETH

🚨🚨 NOTE: Using this service WILL NOT consume any real ETH or GoerliETH. 
That's the whole point of having a dev binary like this. 🚨🚨

# Run
`./start.sh`

If you would like to force an update of the docker image, run `./start.sh -r`

If you need help, run `./start.sh -h` or get in touch with us

### Forking (ETH Mainnet & Goerli)
You can trivially (at least we think so) fork Mainnet and Goerli.

When you run the start script, just add:

1. `-c` : chain id (1 for ETH Mainnet, 5 for Goerli)
2. `-b` : block number

Examples:

`./start.sh -c 1 -b 16327616` fork Mainnet, block number 16327616

`./start.sh -c 5 -b 16327616` fork Goerli, block number 16327616

When you run the image, you'll need to wait until you see `Starting server on port: 7777`.
It may take a few seconds for everything to spin up.

# Shutdown
If you ran the docker image with the `-it` as suggested, you can just
`Crtl-C` the process.

Otherwise, you'll have to run `docker container ls`,
find the container ID, and kill with `docker container stop <CONTAINER_ID>`

🚨🚨 NOTE: This service DOES NOT preserve state. If you 
shut down the process and restart, YOUR LOCAL ACTIONS WILL 
NOT PERSIST 🚨🚨