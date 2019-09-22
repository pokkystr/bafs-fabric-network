#!/bin/bash
echo "================== CA =================="
cat crypto-config/peerOrganizations/bafsorg.oil.com/ca/ca.bafsorg.oil.com-cert.pem  >> ca.txt
echo "============================================"
echo
echo
echo "================== TLSCA =================="
cat crypto-config/peerOrganizations/bafsorg.oil.com/tlsca/tlsca.bafsorg.oil.com-cert.pem >> tlsca.txt
echo "============================================"
