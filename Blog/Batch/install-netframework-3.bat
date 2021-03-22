Rem Paolo Frigo, https://scriptinglibrary.com
Rem This script installs .Net Framework 3 from a SMB share

dism.exe /Online /Enable-Feature /FeatureName:NetFX3 /All /Source:\\NAS\WIN-ISO\Sources\sxs 