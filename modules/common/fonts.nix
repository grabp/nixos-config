{ pkgs, ... }:

{
  fonts = with pkgs; {
    packages = [
      jetbrains-mono
      noto-fonts
      noto-fonts-color-emoji
      twemoji-color-font
      powerline-fonts
      powerline-symbols

      fira-code
      fira-code-symbols

      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.symbols-only
      nerd-fonts.jetbrains-mono

      maple-mono.variable
      maple-mono.truetype
      maple-mono.NF-unhinted
      maple-mono.NF-CN-unhinted

      font-awesome
    ];
  };
}
