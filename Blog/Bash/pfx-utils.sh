#!/bin/bash

# THIS SCRIPT EXTRACT A CERTIFICATE AND PRIVATE KEY FROM PFX FILE
# Paolo Frigo, https://www.scriptinglibrary.com

read -p "Certificate name (e.g. MyCert.pfx):" PfxCert
CertName=${PfxCert/.pfx/}

#Export the private key
openssl pkcs12 -in $PfxCert -nocerts -out key.pem -nodes

#Export the certificate
openssl pkcs12 -in $PfxCert -nokeys -out $CertName.pem

#Remove the passphrase from the private key
openssl rsa -in key.pem -out $CertName.key

#Create a Zip file 
zip $CertName.zip $CertName.pem key.pem $CertName.key $PfxCert

echo "$CertName.pem, key.pem and $CertName.key generated from $PfxCert"
echo "All files added to a zip archive $CertName.zip"
