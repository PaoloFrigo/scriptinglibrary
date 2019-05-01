#Paolo Frigo, https://www.scriptinglibrary.com

# Create a AD DC with Powershell (mainly for lab env)
# ----------------------------------------------------
# Install the role, import the module, create a forest
# add this server as a Primary Domain Controller

install-windowsfeature AD-Domain-Services
Import-Module ADDSDeployment
Install-ADDSForest