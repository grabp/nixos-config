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
        # WiVRN Environment Variables taken from Server Window (Doublecheck they match your system)
        export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
        # PRESSURE_VESSEL_FILESYSTEMS_RW=/var/lib/flatpak/app/io.github.wivrn.wivrn
        export DXVK_FILTER_DEVICE_NAME="NVIDIA GeForce RTX 4070"

        # DLSS settings for Nvidia
        export PROTON_ENABLE_NGX_UPDATER="1"
        export DXVK_NVAPI_DRS_NGX_DLSS_SR_OVERRIDE="on"
        export DXVK_NVAPI_DRS_NGX_DLSS_RR_OVERRIDE="on"
        export DXVK_NVAPI_DRS_NGX_DLSS_FG_OVERRIDE="on"
        export DXVK_NVAPI_DRS_NGX_DLSS_SR_OVERRIDE_RENDER_PRESET_SELECTION="render_preset_latest"
        export DXVK_NVAPI_DRS_NGX_DLSS_RR_OVERRIDE_RENDER_PRESET_SELECTION="render_preset_latest"
        # export DXVK_HUD=compiler
        export DXVK_HUD=1
        unset DISPLAY
        export WAYLANDDRV_PRIMARY_MONITOR=HDMI-A-1
      '';
      protonPath = "GE-Proton";
    }))
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
