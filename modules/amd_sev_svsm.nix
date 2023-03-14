{ pkgs, lib, ... }:
let

  # linux = pkgs.callPackage ../pkgs/kernels/linux-svsm-host-5.14.nix {
  # extraPatches = [
  #    {
  #      # for some reaon, the BTF build fails for 5.14 svsm kernel
  #      # so just disable it
  #      name = "disable BTF";
  #      patch = null;
  #      extraConfig = ''
  #        DEBUG_INFO_BTF n
  #      '';
  #    }
  #  ];
  # };

  linux = pkgs.callPackage ../pkgs/kernels/linux-svsm-host-6.1.nix {};
  linuxPackages = pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux);
in
{
  # Configuration for AMD SEV-SNP with SVSM support

  boot.kernelPackages = lib.mkForce linuxPackages;

  boot.kernelParams = [
    #"mem_encrypt=on"
    "kvm_amd.sev=1"
    "kvm_amd.sev_es=1"
    "kvm_amd.sev_snp=1"
    #"kvm.mmio_caching=on"
    "sp5100_tco.blacklist=yes"
  ];

  # enable libvirtd service
  virtualisation.libvirtd.enable = true;
}
