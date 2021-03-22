Rem Paolo Frigo, https://scriptinglibrary.com

Rem This script launch the unattended in-place upgrade for Windows 10
Rem for attended mode use Microsoft Update Assistant https://www.microsoft.com/en-au/software-download/windows10

Rem Copy the content of the iso Windows 10 20H2 iso on a SMB Share
net use W: \\Nas\Media\Windows-20H2
W:

setup.exe /migchoice upgrade /showoobe none /eula accept /DynamicUpdate NoDrivers /Telemetry Disable /quiet