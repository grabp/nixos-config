{ pkgs, ... }:
{
  # Configure WirePlumber for proper Bluetooth A2DP support
  # This fixes low audio volume issues with AirPods Pro
  
  # WirePlumber 0.5.x configuration format
  # Remove old bluetooth.lua.d config and use wireplumber.conf.d instead
  xdg.configFile."wireplumber/wireplumber.conf.d/50-bluez-config.conf".text = ''
    monitor.bluez.properties = {
      bluez5.enable-sbc-xq = true
      bluez5.enable-msbc = true
      bluez5.enable-hw-volume = true
      bluez5.codecs = "[ sbc sbc_xq aac ldac aptx aptx_hd aptx_ll ]"
    }
  '';
}

