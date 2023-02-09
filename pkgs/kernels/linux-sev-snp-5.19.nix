{ buildLinux, fetchFromGitHub, modDirVersionArg ? null, ... }@args:

buildLinux (args // rec {
  version = "5.19";
  modDirVersion =
    if (modDirVersionArg == null) then
      builtins.replaceStrings [ "-" ] [ ".0-" ] version
    else
      modDirVersionArg;
  src = fetchFromGitHub {
    owner = "AMDESE";
    repo = "linux";
    # https://github.com/AMDESE/linux/tree/sev-snp-5.19-rc5-v2
    rev = "8e4a0b83a7b0a312efc8a091c0d6d2d920049e5b";
    sha256 = "sha256-A6UYI+Xo0uJh+KfUcVR/2Bi+m269rikoDs0Snvnf0Rg=";
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
