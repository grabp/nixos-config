{
  pkgs,
  inputs,
  ...
}:
{
  # https://discord.com/channels/539464400734519306/1449843649541308456/1454946747083128882
  environment.systemPackages = with pkgs; [
    (inputs.nix-citizen.packages.${system}.rsi-launcher-umu.override (prev: {
      preCommands = ''
        export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
        export radv_zero_vram=true
        export RADV_ZERO_VRAM=true
      '';
      # protonPath = "GE-Proton";
    }))
    # inputs.nix-citizen.packages.${system}.rsi-launcher-umu
    inputs.nix-citizen.packages.${system}.lug-helper
  ];

  # See https://github.com/starcitizen-lug/knowledge-base/wiki/Manual-Installation#prerequisites
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };

  # See RAM, ZRAM & Swap
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024; # 8 GB Swap
    }
  ];
  zramSwap = {
    enable = true;
    memoryMax = 8 * 1024 * 1024 * 1024; # 8 GB ZRAM
  };
}
