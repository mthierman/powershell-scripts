# https://stackoverflow.com/questions/8169999/how-can-i-create-a-self-signed-cert-for-localhost
New-SelfSignedCertificate -DnsName "localhost" -CertStoreLocation "Cert:\LocalMachine\My"
# Move into Trusted Root Certificate Authorities 
# Export the PFX so we can load with vite
