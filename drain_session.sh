#!/bin/bash

while true; do

curl --location --request POST $1 \
--header 'Content-Type: application/json' \
--data-raw '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'

done
