# Codefresh Virtual Machine Build

Builds a KVM Virtual Machine from scratch in order to run as a Codefresh Runtime Node.

Execute the following command to build a machine on a host running virt-manager and KVM:

```bash
virt-install --name Codefresh_VM --memory 6144 --vcpus 2 --disk size=20 --location http://ftp.au.debian.org/debian/dists/bullseye/main/installer-amd64/ --os-variant debian10 --extra-args="url=https://raw.githubusercontent.com/geoffh1977/codefresh-vm/main/preseed.cfg auto=true netcfg/get_hostname=codefresh netcfg/get_domain=vm.harrison.lan" --noautoconsole
```
