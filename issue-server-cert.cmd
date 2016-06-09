@SETLOCAL
@echo off
set "CA_INTERMEDIATE_BASEDIR=intermediate"

set /p CERT_SERIAL=<%CA_INTERMEDIATE_BASEDIR%\serial

@REM Create the intermediate key
if not exist %CA_INTERMEDIATE_BASEDIR%\private\%CERT_SERIAL%.key.pem (
  echo Generating private key
  call openssl genrsa -aes256 -out %CA_INTERMEDIATE_BASEDIR%\private\%CERT_SERIAL%.key.pem 2048
)

@REM Create the intermediate CSR
if not exist %CA_INTERMEDIATE_BASEDIR%\csr\%CERT_SERIAL%.csr.pem (
  echo Generating intermediate CSR
  call openssl req -config intermediate-openssl.cnf -new -sha256 -key %CA_INTERMEDIATE_BASEDIR%\private\%CERT_SERIAL%.key.pem -out %CA_INTERMEDIATE_BASEDIR%\csr\%CERT_SERIAL%.csr.pem
)

if not exist %CA_INTERMEDIATE_BASEDIR%\certs\%CERT_SERIAL%.cert.cer (
  echo Signing intermediate certificate
  call openssl ca -config intermediate-openssl.cnf -extensions server_cert -days 375 -notext -md sha256 -in %CA_INTERMEDIATE_BASEDIR%\csr\%CERT_SERIAL%.csr.pem -out %CA_INTERMEDIATE_BASEDIR%\certs\%CERT_SERIAL%.cert.cer
)

@ENDLOCAL