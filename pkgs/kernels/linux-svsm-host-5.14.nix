{ buildLinux
, fetchFromGitHub
, modDirVersionArg ? "5.14.0-rc2"
, extraPatches ? [ ]
, ...
}@args:

buildLinux (args // rec {
  version = "5.14";
  modDirVersion =
    if (modDirVersionArg == null) then
      builtins.replaceStrings [ "-" ] [ ".0-" ] version
    else
      modDirVersionArg;
  src = fetchFromGitHub {
    owner = "AMDESE";
    repo = "linux";
    rev = "e69def60bfa53acef2a5ebd8c85d8d544eb2cbbe"; # branch svsm-preview-hv
    sha256 = "sha256-DT3Ych/3BoeqxYFn2F8PajmmPufrN619zZa6X5WUHvo=";
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
  extraMeta.branch = "5.14";
  ignoreConfigErrors = true;
} // (args.argsOverride or { }))
