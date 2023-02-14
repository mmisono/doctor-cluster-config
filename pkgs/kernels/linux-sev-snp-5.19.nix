{ buildLinux, fetchFromGitHub, modDirVersionArg ? "5.19.0-rc5-next-20220706", ... }@args:

buildLinux (args // rec {
  version = "5.19";
  modDirVersion =
    if (modDirVersionArg == null) then
      builtins.replaceStrings [ "-" ] [ ".0-" ] version
    else
      modDirVersionArg;
  src = fetchFromGitHub {
    # https://github.com/AMDESE/linux/tree/sev-snp-5.19-rc5-v2
    # owner = "AMDESE";
    # repo = "linux";
    # rev = "8e4a0b83a7b0a312efc8a091c0d6d2d920049e5b";
    # sha256 = "sha256-A6UYI+Xo0uJh+KfUcVR/2Bi+m269rikoDs0Snvnf0Rg=";

    # https://github.com/mmisono/linux/tree/sev-snp-5.19-rc5-v2-dev
    owner = "mmisono";
    repo = "linux";
    rev = "671ad6d15cf883ae29e8c9613aa4dbbdd71244d7";
    sha256 = "sha256-XzTXafyv/tIIhBLPp2KsBTYd5otVlWr1fgy736mAZLw=";
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
  ];
  extraMeta.branch = "5.19";
  ignoreConfigErrors = true;
} // (args.argsOverride or { }))
