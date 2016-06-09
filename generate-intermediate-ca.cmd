@SETLOCAL
@echo off
set "CA_INTERMEDIATE_BASEDIR=intermediate"

IF NOT EXIST %CA_INTERMEDIATE_BASEDIR%\certs mkdir %CA_INTERMEDIATE_BASEDIR%\certs
IF NOT EXIST %CA_INTERMEDIATE_BASEDIR%\crl mkdir %CA_INTERMEDIATE_BASEDIR%\crl
IF NOT EXIST %CA_INTERMEDIATE_BASEDIR%\csr mkdir %CA_INTERMEDIATE_BASEDIR%\csr
IF NOT EXIST %CA_INTERMEDIATE_BASEDIR%\newcerts mkdir %CA_INTERMEDIATE_BASEDIR%\newcerts
IF NOT EXIST %CA_INTERMEDIATE_BASEDIR%\private mkdir %CA_INTERMEDIATE_BASEDIR%\private
IF NOT EXIST %CA_INTERMEDIATE_BASEDIR%\db mkdir %CA_INTERMEDIATE_BASEDIR%\db

IF NOT EXIST %CA_INTERMEDIATE_BASEDIR%\db\index.txt type nul > %CA_INTERMEDIATE_BASEDIR%\db\index.txt
IF NOT EXIST %CA_INTERMEDIATE_BASEDIR%\serial echo 1000> %CA_INTERMEDIATE_BASEDIR%\serial
IF NOT EXIST %CA_INTERMEDIATE_BASEDIR%\crlnumber echo 1000> %CA_INTERMEDIATE_BASEDIR%\crlnumber

@REM Create the intermediate key
if not exist %CA_INTERMEDIATE_BASEDIR%\private\intermediate.key.pem (
  echo Generating private key
  call openssl genrsa -aes256 -out %CA_INTERMEDIATE_BASEDIR%\private\intermediate.key.pem 4096
)

@REM Create the intermediate CSR
if not exist %CA_INTERMEDIATE_BASEDIR%\csr\intermediate.csr.pem (
  echo Generating intermediate CSR
  call openssl req -config intermediate-openssl.cnf -new -sha256 -key %CA_INTERMEDIATE_BASEDIR%\private\intermediate.key.pem -out %CA_INTERMEDIATE_BASEDIR%\csr\intermediate.csr.pem
)

if not exist %CA_INTERMEDIATE_BASEDIR%\certs\intermediate.cert.cer (
  echo Signing intermediate certificate
  call openssl ca -config root-openssl.cnf -extensions v3_intermediate_ca -days 3650 -notext -md sha256 -in %CA_INTERMEDIATE_BASEDIR%\csr\intermediate.csr.pem -out %CA_INTERMEDIATE_BASEDIR%\certs\intermediate.cert.cer
)

if not exist %CA_INTERMEDIATE_BASEDIR%\certs\intermediate.chain.pem (
  echo Generating intermediate certificate chain
  type %CA_INTERMEDIATE_BASEDIR%\certs\intermediate.cert.cer root\certs\ca.cert.cer > %CA_INTERMEDIATE_BASEDIR%\certs\intermediate.chain.pem
)

@ENDLOCAL