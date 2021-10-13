# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "megaraid_sas" "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "zroot/root/nixos";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    # set with: dosfslabel /dev/nvme0n1p1 boot
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

 fileSystems."/home" = {
   device = "zroot/root/home";
   fsType = "zfs";
 };

 fileSystems."/tmp" = {
   device = "zroot/root/tmp";
   fsType = "zfs";
 };
}
