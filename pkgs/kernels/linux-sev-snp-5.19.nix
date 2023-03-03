{ buildLinux, fetchFromGitHub, ... }@args:
let
  # the original rc5 version (not work)
  # This failes to build due to binutils update
  # https://github.com/AMDESE/linux/tree/sev-snp-5.19-rc5-v2
  # rc5 = {
  #   owner = "AMDESE";
  #   repo = "linux";
  #   rev = "8e4a0b83a7b0a312efc8a091c0d6d2d920049e5b";
  #   sha256 = "sha256-A6UYI+Xo0uJh+KfUcVR/2Bi+m269rikoDs0Snvnf0Rg=";
  #   modDirVersionArg = "5.19.0-rc5-next-20220706";
  #   extraPatches = [];
  # };

  # rc5 version, wich bunitls patches
  # https://github.com/mmisono/linux/tree/sev-snp-5.19-rc5-v2-dev
  rc5 = {
    owner = "mmisono";
    repo = "linux";
    rev = "671ad6d15cf883ae29e8c9613aa4dbbdd71244d7";
    sha256 = "sha256-XzTXafyv/tIIhBLPp2KsBTYd5otVlWr1fgy736mAZLw=";
    modDirVersionArg = "5.19.0-rc5-next-20220706";
    extraPatches = [];
  };

  # rc6 version, with binutils patches
  # https://github.com/mmisono/linux/tree/sev-snp-iommu-avic_5.19-rc6_v4-dev
  rc6 = {
    owner = "mmisono";
    repo = "linux";
    rev = "92221f6d4d09653d0a6787d0906958e6d884b85c";
    sha256 = "sha256-2gHPMA84dWBnxMvL4Bmky0c5onDizcr48sPpZpDU79g=";
    modDirVersionArg = "5.19.0-rc6";
    extraPatches = [
      {
        # for some reaon, the BTF build fails, so just disable it
        name = "disable BTF";
        patch = null;
        extraConfig = ''
          DEBUG_INFO_BTF n
        '';
      }
    ];
  };

  # change here to change kernel
  snp_kernel = rc5;
  # snp_kernel = rc6;

in with snp_kernel;
buildLinux (args // rec {
  version = "5.19";
  modDirVersion =
    if (snp_kernel.modDirVersionArg == null) then
      builtins.replaceStrings [ "-" ] [ ".0-" ] version
    else
      modDirVersionArg;

  src = fetchFromGitHub {
    inherit owner repo rev sha256;
  };

  kernelPatches = [
    {
      name = "amd_sme-config";
      patch = null;
      extraConfig = ''
        AMD_MEM_ENCRYPT y
        CRYPTO_DEV_CCP y
        CRYPTO_DEV_CCP_DD y
        CRYPTO_DEV_SP_PSP y
        KVM_AMD_SEV y
        MEMORY_FAILURE y
      '';
    }
  ] ++ extraPatches;
  extraMeta.branch = "5.19";
  ignoreConfigErrors = true;
} // (args.argsOverride or { }))
