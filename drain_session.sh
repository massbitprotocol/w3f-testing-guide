while true; do

curl --location --request POST 'http://6d16b276-2ddb-4599-ac96-47f5ff92b97f.eth-mainnet.massbitroute.net/q2oOYKftvRa97TC6s1COew' \
--header 'Content-Type: application/json' \
--data-raw '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'

done
