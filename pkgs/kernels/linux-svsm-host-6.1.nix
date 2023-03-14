{ buildLinux
, fetchFromGitHub
, modDirVersionArg ? "6.1.0-rc4"
, extraPatches ? [ ]
, ...
}@args:

buildLinux (args // rec {
  version = "6.1";
  modDirVersion =
    if (modDirVersionArg == null) then
      builtins.replaceStrings [ "-" ] [ ".0-" ] version
    else
      modDirVersionArg;
  src = fetchFromGitHub {
    owner = "AMDESE";
    repo = "linux";
    rev = "4c33a31c6e1524f1b90834aaaea250a085f72dac"; # branch svsm-preview-hv-2
    sha256 = "sha256-eNSQ1monsTvZuI0NnJQx9rqUD8zc3puCqtCS5eYDon0=";
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
        EXPERT y # AMD_MEM_ENCRYPT indirectly depends on EXPERT
      '';
    }
  ] ++ extraPatches;
  extraMeta.branch = "6.1";
  ignoreConfigErrors = true;
} // (args.argsOverride or { }))
