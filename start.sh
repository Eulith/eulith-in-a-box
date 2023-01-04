TARFILE="$(find . -type f -iname "eulith-devrpc_*.tar.gz")"
RELOAD="f"
FORK_CHAIN_ID="0"
FORK_BLOCK_ID="0"
FORK_ARGS=""

function print_usage() {
    echo "Use this script to start Eulith DEV-RPC services. Example: ./start.sh"
    echo "If you run this script with no arguments, it will check whether the docker image already exists"
    echo "If it exists, it will load the existing image. Otherwise, it will import anew."
    echo "If you would like to force an image reload, just pass the -r argument. Example: ./start.sh -r"
}

while getopts 'hrb:c:' flag; do
  case "${flag}" in
    r) RELOAD='t' ;;
    h) print_usage
       exit 0 ;;
    b) FORK_BLOCK_ID="${OPTARG}" ;;
    c) FORK_CHAIN_ID="${OPTARG}" ;;
  esac
done

docker image inspect eulith-devrpc > /dev/null 2>&1
if [[ $? != 0  || $RELOAD == "t" ]]
then
  echo "Loading Docker image from $TARFILE... this may take a few moments"
  docker load < $TARFILE
  if [[ $? != 0 ]]
  then
    echo "Failed to load image"
    exit 1
  fi
  echo "Done loading"
fi

if [[ $FORK_CHAIN_ID != "0" ]]
then
  if [[ $FORK_CHAIN_ID != "5" && $FORK_CHAIN_ID != "1" ]]
  then
    echo "Only chain id 1 (mainnet) or 5 (goerli) is supported for forking"
    exit 1
  fi

  FORK_ARGS="-c $FORK_CHAIN_ID"
fi

if [[ $FORK_BLOCK_ID != "0" ]]
then
  FORK_ARGS="$FORK_ARGS -b $FORK_BLOCK_ID"
fi

if [[ $FORK_ARGS != "" ]]
then
  docker run -p 7777:7777 eulith-devrpc $FORK_ARGS > /dev/null 2>&1&
else
  docker run -p 7777:7777 eulith-devrpc > /dev/null 2>&1&
fi

echo "Starting server, please wait ..."
sleep 20

if [[ $? != 0 ]]
then
  echo "Server start failed"
fi

echo "Started Eulith DEV-RPC server on http://localhost:7777"
echo "Username: libtest"
echo "Password: test"
echo "Wallet private key: 0x4d5db4107d237df6a3d58ee5f70ae63d73d7658d4026f2eefd2f204c81682cb7"