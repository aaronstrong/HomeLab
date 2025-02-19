# Readme






## Cloud-Init on Windows



There is a reimplementation of Cloud-Init available for Windows called [cloudbase-init](https://cloudbase.it/cloudbase-init/). Not every feature of Cloud-Init is available with Cloudbase-Init, and some features differ compared to Cloud-Init. Cloudbase-Init requires both ostype set to any Windows version and the citype set to configdrive2, which is the default with any Windows ostype. There are no ready-made cloud images for Windows available for free. Using Cloudbase-Init requires manually installing and configuring a Windows guest.

### Preparing Cloudbase-Init Templates

The first step is to install Windows in a VM. Download and install Cloudbase-Init in the guest. It may be necessary to install the Beta version. Don’t run Sysprep at the end of the installation. Instead configure Cloudbase-Init first.

A few common options to set would be:

* username: This sets the username of the administrator
* groups: This allows one to add the user to the Administrators group
* inject_user_password: Set this to true to allow setting the password in the VM config
* first_logon_behaviour: Set this to no to not require a new password on login
* rename_admin_user: Set this to true to allow renaming the default Administrator user to the username specified with username
* metadata_services: Set this to cloudbaseinit.metadata.services.configdrive.ConfigDriveService for Cloudbase-Init to first check this service. Otherwise it may take a few minutes for Cloudbase-Init to configure the system after boot.

Some plugins, for example the SetHostnamePlugin, require reboots and will do so automatically. To disable automatic reboots by Cloudbase-Init, you can set allow_reboot to false.

```conf
[DEFAULT]
username=cloudinit
groups=Administrators
rename_admin_user=true
inject_user_password=true
first_logon_behaviour=no
netbios_host_name_compatibility=true
enable_automatic_updates=true
raw_hhd=true
cdrom=true
vfat=true
bsdtar_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\bsdtar.exe
mtools_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\
verbose=true
debug=true
log_dir=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log\
log_file=cloudbase-init.log
default_log_levels=comtypes=INFO,suds=INFO,iso8601=WARN,requests=WARN
logging_serial_port_settings=
mtu_use_dhcp_config=true
ntp_use_dhcp_config=true
local_scripts_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts\
check_latest_version=false
plugins=cloudbaseinit.plugins.common.sethostname.SetHostNamePlugin,
cloudbaseinit.plugins.common.networkconfig.NetworkConfigPlugin,
cloudbaseinit.plugins.windows.extendvolumes.ExtendVolumesPlugin,
cloudbaseinit.plugins.common.userdata.UserDataPlugin,
cloudbaseinit.plugins.common.sshpublickeys.SetUserSSHPublicKeysPlugin,
cloudbaseinit.plugins.common.setuserpassword.SetUserPasswordPlugin,
cloudbaseinit.plugins.windows.createuser.CreateUserPlugin,
cloudbaseinit.plugins.windows.updates.WindowsAutoUpdatesPlugin
metadata_services=cloudbaseinit.metadata.services.configdrive.ConfigDriveService
```

cloudbase-init-unattended.conf
```conf
[DEFAULT]
username=cloudinit
groups=Administrators
rename_admin_user=true
inject_user_password=true
first_logon_behaviour=no
netbios_host_name_compatibility=true
enable_automatic_updates=true
raw_hhd=true
cdrom=true
vfat=true
bsdtar_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\bsdtar.exe
mtools_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\
verbose=true
debug=true
log_dir=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log\
log_file=cloudbase-init.log
default_log_levels=comtypes=INFO,suds=INFO,iso8601=WARN,requests=WARN
logging_serial_port_settings=
mtu_use_dhcp_config=true
ntp_use_dhcp_config=true
local_scripts_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts\
check_latest_version=false
plugins=cloudbaseinit.plugins.common.sethostname.SetHostNamePlugin,
cloudbaseinit.plugins.common.networkconfig.NetworkConfigPlugin,
cloudbaseinit.plugins.windows.extendvolumes.ExtendVolumesPlugin,
cloudbaseinit.plugins.common.userdata.UserDataPlugin,
cloudbaseinit.plugins.common.sshpublickeys.SetUserSSHPublicKeysPlugin,
cloudbaseinit.plugins.common.setuserpassword.SetUserPasswordPlugin,
cloudbaseinit.plugins.windows.createuser.CreateUserPlugin,
cloudbaseinit.plugins.windows.updates.WindowsAutoUpdatesPlugin
metadata_services=cloudbaseinit.metadata.services.configdrive.ConfigDriveService
allow_reboot=true
stop_service_on_exit=false
```

After configuring Cloudbase-Init you can start creating the template. Shutdown the Windows guest, add a Cloud-Init disk and make it into a template.

Clone the template into a new VM:



Make sure that the ostype is set to any Windows version before setting the password. Otherwise the password will be encrypted and Cloudbase-Init will use the encrypted password as plaintext password.

When everything is set, start the cloned guest. On the first boot the login won’t work and it will reboot automatically for the changed hostname. After the reboot the new password should be set and login should work.



### References

https://pve.proxmox.com/wiki/Cloud-Init_Support#_cloud_init_on_windows
https://docs-next.bennetg.de/products/proxmox-cp/miscellaneous/windows-cloudbase-init
https://github.com/ChristianLempa/boilerplates/blob/main/terraform/proxmox/vmqemu.tf
https://cloudbase-init.readthedocs.io/en/latest/plugins.html#configuring-selected-plugins
https://github.com/ZacksHomeLab/terraform-proxmox-cloudinit-vm/blob/main/main.tf
https://cloudbase.it/cloudbase-init/
https://www.reddit.com/r/Proxmox/comments/1ch32wt/proxmox_windows_cloudbaseinit/
---
2-19 attemp1
cloudbase-init.conf
```conf
[DEFAULT]
username=Administrator
groups=Administrators
rename_admin_user=true
inject_user_password=false
config_drive_raw_hhd=true
config_drive_cdrom=true
config_drive_vfat=true
bsdtar_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\bsdtar.exe
mtools_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\
verbose=true
debug=true
log_dir=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log\
log_file=cloudbase-init.log
default_log_levels=comtypes=INFO,suds=INFO,iso8601=WARN,requests=WARN
logging_serial_port_settings=
mtu_use_dhcp_config=true
ntp_use_dhcp_config=true
local_scripts_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts\
check_latest_version=true
plugins=cloudbaseinit.plugins.common.sethostname.SetHostNamePlugin,
cloudbaseinit.plugins.common.networkconfig.NetworkConfigPlugin,
cloudbaseinit.plugins.windows.extendvolumes.ExtendVolumesPlugin,
cloudbaseinit.plugins.common.userdata.UserDataPlugin,
cloudbaseinit.plugins.common.sshpublickeys.SetUserSSHPublicKeysPlugin,
cloudbaseinit.plugins.common.setuserpassword.SetUserPasswordPlugin,
cloudbaseinit.plugins.windows.createuser.CreateUserPlugin,
cloudbaseinit.plugins.windows.updates.WindowsAutoUpdatesPlugin
metadata_services=cloudbaseinit.metadata.services.configdrive.ConfigDriveService
```
cloudbase-init-unattend.conf
```conf
[DEFAULT]
username=Administrator
groups=Administrators
rename_admin_user=true
inject_user_password=true
config_drive_raw_hhd=true
config_drive_cdrom=true
config_drive_vfat=true
bsdtar_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\bsdtar.exe
mtools_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\
verbose=true
debug=true
log_dir=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log\
log_file=cloudbase-init-unattend.log
default_log_levels=comtypes=INFO,suds=INFO,iso8601=WARN,requests=WARN
logging_serial_port_settings=
mtu_use_dhcp_config=true
ntp_use_dhcp_config=true
local_scripts_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts\
check_latest_version=false
plugins=cloudbaseinit.plugins.common.sethostname.SetHostNamePlugin,
cloudbaseinit.plugins.common.networkconfig.NetworkConfigPlugin,
cloudbaseinit.plugins.windows.extendvolumes.ExtendVolumesPlugin,
cloudbaseinit.plugins.common.userdata.UserDataPlugin,
cloudbaseinit.plugins.common.sshpublickeys.SetUserSSHPublicKeysPlugin,
cloudbaseinit.plugins.common.setuserpassword.SetUserPasswordPlugin,
cloudbaseinit.plugins.windows.createuser.CreateUserPlugin,
cloudbaseinit.plugins.windows.updates.WindowsAutoUpdatesPlugin
metadata_services=cloudbaseinit.metadata.services.configdrive.ConfigDriveService
allow_reboot=false
stop_service_on_exit=false
```
---
phase 2
cloudbase-init.conf
```confg
[DEFAULT]
username=cloudinit
groups=Administrators
rename_admin_user=true
inject_user_password=true
first_logon_behavior=no
config_drive_raw_hhd=true
config_drive_cdrom=true
config_drive_vfat=true
bsdtar_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\bsdtar.exe
mtools_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\
verbose=true
debug=true
log_dir=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log\
log_file=cloudbase-init.log
default_log_levels=comtypes=INFO,suds=INFO,iso8601=WARN,requests=WARN
logging_serial_port_settings=
mtu_use_dhcp_config=true
ntp_use_dhcp_config=true
local_scripts_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts\
check_latest_version=true
plugins=cloudbaseinit.plugins.common.sethostname.SetHostNamePlugin,
cloudbaseinit.plugins.common.networkconfig.NetworkConfigPlugin,
cloudbaseinit.plugins.windows.extendvolumes.ExtendVolumesPlugin,
cloudbaseinit.plugins.common.userdata.UserDataPlugin,
cloudbaseinit.plugins.common.sshpublickeys.SetUserSSHPublicKeysPlugin,
cloudbaseinit.plugins.common.setuserpassword.SetUserPasswordPlugin,
cloudbaseinit.plugins.windows.createuser.CreateUserPlugin,
cloudbaseinit.plugins.windows.updates.WindowsAutoUpdatesPlugin
metadata_services=cloudbaseinit.metadata.services.configdrive.ConfigDriveService
```
cloudbase-int-unattend.conf
```conf
[DEFAULT]
username=cloudinit
groups=Administrators
rename_admin_user=true
inject_user_password=true
first_logon_behavior=no
config_drive_raw_hhd=true
config_drive_cdrom=true
config_drive_vfat=true
bsdtar_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\bsdtar.exe
mtools_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\
verbose=true
debug=true
log_dir=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log\
log_file=cloudbase-init.log
default_log_levels=comtypes=INFO,suds=INFO,iso8601=WARN,requests=WARN
logging_serial_port_settings=
mtu_use_dhcp_config=true
ntp_use_dhcp_config=true
local_scripts_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts\
check_latest_version=true
plugins=cloudbaseinit.plugins.common.sethostname.SetHostNamePlugin,
cloudbaseinit.plugins.common.networkconfig.NetworkConfigPlugin,
cloudbaseinit.plugins.windows.extendvolumes.ExtendVolumesPlugin,
cloudbaseinit.plugins.common.userdata.UserDataPlugin,
cloudbaseinit.plugins.common.sshpublickeys.SetUserSSHPublicKeysPlugin,
cloudbaseinit.plugins.common.setuserpassword.SetUserPasswordPlugin,
cloudbaseinit.plugins.windows.createuser.CreateUserPlugin,
cloudbaseinit.plugins.windows.updates.WindowsAutoUpdatesPlugin
metadata_services=cloudbaseinit.metadata.services.configdrive.ConfigDriveService
allow_reboot=false
stop_service_on_exit=false

```
