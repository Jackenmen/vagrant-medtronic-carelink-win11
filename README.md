# vagrant-medtronic-carelink-win11

[Vagrant](https://www.vagrantup.com/) configuration of a Windows 11 virtual machine
set up for uploading data to Medtronic Carelink Personal. Meant for Linux users
who like me want to use CareLink Personal but would rather provision fresh VMs
and not deal with manual setup of VMs which is bothersome and requires maintenance
(Windows updates) to remain secure.

The machine is set up with CareLink Uploader software already installed and
opening the Edge browser puts you right on the login page to CareLink Personal.

The provided configuration files use my own settings but they can be easily modified:

- The machine uses Central European Standard Time.

  The usage of `tzutil` which sets the system timezone can be changed in `provision.ps1`
  file. `tzutil /l` can be used to get a list of all available timezones.

- The homepage and startup page are set to use Polish region for Medtronic Personal.

  The used `https://carelink.minimed.eu/patient/sso/login?country=pl&lang=pl` address
  can be modified in `MSEdgeSettings.reg` file.

- Contour Plus Link 2.4 is auto-attached to the virtual machine.

  The `usbfilter` can be removed or modified to allow a different device
  in `Vagrantfile` file.

## Disclaimer

All trademarks and brand names are the property of their respective owners. All company, product and service names used in this project are for identification purposes only. Use of these names, trademarks and brands does not imply endorsement.
