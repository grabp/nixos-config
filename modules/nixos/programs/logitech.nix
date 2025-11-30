{ pkgs, ... }: {
  
  environment.systemPackages = with pkgs; [
    usbutils
  ];
  services.solaar.enable = true;
}
