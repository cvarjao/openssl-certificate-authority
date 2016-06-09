@SETLOCAL
@echo off
set "CA_ROOT_BASEDIR=root"

IF NOT EXIST %CA_ROOT_BASEDIR%\certs mkdir %CA_ROOT_BASEDIR%\certs
IF NOT EXIST %CA_ROOT_BASEDIR%\crl mkdir %CA_ROOT_BASEDIR%\crl
IF NOT EXIST %CA_ROOT_BASEDIR%\newcerts mkdir %CA_ROOT_BASEDIR%\newcerts
IF NOT EXIST %CA_ROOT_BASEDIR%\private mkdir %CA_ROOT_BASEDIR%\private
IF NOT EXIST %CA_ROOT_BASEDIR%\db mkdir %CA_ROOT_BASEDIR%\db

IF NOT EXIST %CA_ROOT_BASEDIR%\db\index.txt type nul > %CA_ROOT_BASEDIR%\db\index.txt
IF NOT EXIST %CA_ROOT_BASEDIR%\serial echo 1000> %CA_ROOT_BASEDIR%\serial
IF NOT EXIST %CA_ROOT_BASEDIR%\crlnumber echo 1000> %CA_ROOT_BASEDIR%\crlnumber

@REM Create the root key
if not exist %CA_ROOT_BASEDIR%\private\ca.key.pem (
  echo Generating private key
  call openssl genrsa -aes256 -out %CA_ROOT_BASEDIR%\private\ca.key.pem 4096
)


@REM Create the root certificate
if not exist certs\ca.cert.cer (
  echo Generating root certificate
  call openssl req -config root-openssl.cnf -key %CA_ROOT_BASEDIR%\private\ca.key.pem -new -x509 -days 7300 -sha256 -extensions v3_ca -out %CA_ROOT_BASEDIR%\certs\ca.cert.cer
)

@REM echo Verifying root certificate
@REM openssl x509 -noout -text -in %CA_ROOT_BASEDIR%\certs\ca.cert.cer


@ENDLOCAL