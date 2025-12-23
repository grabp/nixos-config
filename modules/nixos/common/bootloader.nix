{ pkgs, config, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "max";
      timeout = 2;

      efi = {
        canTouchEfiVariables = true;
      };
    };

    # Better kernel for wine/gaming. Source: https://github.com/fufexan/nix-gaming?tab=readme-ov-file#-tips
    kernelPackages = pkgs.linuxPackages_xanmod_stable;

    # Initrd
    initrd.enable = true;
    initrd.verbose = false;

    # Plymouth Cattppuccin
    plymouth = {
      enable = true;
    };

    # Enable 'Silent Boot'
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
    '';
  };
}
