# NixOS and nix-darwin Configurations for My Machines

### Copied a lot from https://github.com/AlexNabokikh/nix-config

## Structure

- `flake.nix`: The flake itself, defining inputs and outputs for NixOS, nix-darwin, and Home Manager configurations.
- `hosts/`: NixOS and nix-darwin configurations for each machine.
- `home/`: Home Manager configurations for each user on each machine.
- `files/`: Miscellaneous configuration files, scripts, avatars, and screenshots.
- `modules/`: Reusable platform-specific modules:
  - `nixos/`: NixOS-specific modules for system configuration.
  - `darwin/`: macOS-specific (nix-darwin) modules.
  - `home-manager/`: User-space configuration modules for applications and services.
- `overlays/`: Custom Nix overlays for package modifications or additions.
- `flake.lock`: Lock file ensuring reproducible builds by pinning input versions.

### Key Inputs

- **nixpkgs**: Points to the `nixos-25.11` channel.
- **home-manager**: Manages user-specific configurations.
- **darwin**: Enables nix-darwin for macOS system configuration.
- **hardware**: Provides NixOS modules to optimize settings for different hardware.
- **catppuccin**: Provides global Catppuccin theme integration.

## Usage

### Adding a New Machine with a New User

To add a new machine with a new user to your NixOS or nix-darwin configuration, follow these steps:

1. **Update `flake.nix`**:

   a. Add the new user to the `users` attribute set:

   ```nix
   users = {
     # Existing users...
     newuser = {
       avatar = ./files/avatar/face.jpg;
       email = "newuser@example.com";
       fullName = "New User";
       name = "newuser";
     };
   };
   ```

   b. Add the new machine to the appropriate configuration set:

   For NixOS:

   ```nix
   nixosConfigurations = {
     # Existing configurations...
     newmachine = mkNixosConfiguration "newmachine" "newuser";
   };
   ```

   For nix-darwin:

   ```nix
   darwinConfigurations = {
     # Existing configurations...
     newmachine = mkDarwinConfiguration "newmachine" "newuser";
   };
   ```

2. **Create System Configuration**:

   a. Create a new directory under `hosts/` for your machine:

   ```sh
   mkdir -p hosts/newmachine
   ```

   b. Create `default.nix` in this directory:

   ```sh
   touch hosts/newmachine/default.nix
   ```

   c. Add the basic configuration to `default.nix`:

   For NixOS:

   ```nix
   { inputs, hostname, nixosModules, ... }:
   {
     imports = [
       inputs.hardware.nixosModules.common-cpu-amd
       ./hardware-configuration.nix
       "${nixosModules}/common"
       "${nixosModules}/desktop/hyprland"
     ];

     networking.hostName = hostname;
   }
   ```

   For nix-darwin:

   ```nix
   { darwinModules, ... }:
   {
     imports = [
       "${darwinModules}/common"
     ];
     # Add machine-specific configurations here
   }
   ```

   d. For NixOS, generate `hardware-configuration.nix`:

   ```sh
   sudo nixos-generate-config --show-hardware-config > hosts/newmachine/hardware-configuration.nix
   ```

3. **Create Home Manager Configuration**:

   a. Create a new directory for the user's host-specific configuration:

   ```sh
   mkdir -p home/newuser/newmachine
   touch home/newuser/newmachine/default.nix
   ```

   b. Add basic home configuration:

   ```nix
   { nhModules, ... }:
   {
     imports = [
       "${nhModules}/common"
       # Add other home-manager modules
     ];
   }
   ```

4. **Build and apply**:

   Commit new files to git first:

   ```sh
   git add .
   ```

   Then rebuild (the `rb` alias does this, or run directly):

   For NixOS:

   ```sh
   sudo nixos-rebuild switch --flake .#newmachine
   ```

   For nix-darwin:

   ```sh
   darwin-rebuild switch --flake .#newmachine
   ```

   Home Manager is integrated into the system rebuild — a single `rb` applies both system and home configuration. No separate `home-manager switch` step is needed.

## Secret Management (sops-nix)

Secrets (e.g. SMB credentials) are managed with [sops-nix](https://github.com/Mic92/sops-nix). Each machine decrypts secrets using an age key at `/var/lib/sops-nix/keys.txt`.

### One-time setup on a new machine

**1. Generate an age key:**

```sh
sudo mkdir -p /var/lib/sops-nix
nix-shell -p age --run "age-keygen -o /tmp/age-key.txt"
# Output will print the public key — record it for step 3
sudo mv /tmp/age-key.txt /var/lib/sops-nix/keys.txt
sudo chmod 600 /var/lib/sops-nix/keys.txt
```

**2. Add the public key to `.sops.yaml`:**

```yaml
keys:
  - &newmachine age1...   # paste public key from step 1 here

creation_rules:
  - path_regex: ^secrets/newmachine\.yaml$
    key_groups:
      - age:
          - *newmachine
        pgp:
          - *main-pgp
```

**3. Re-encrypt or create the secrets file:**

To add the new key to an existing secrets file:
```sh
sops updatekeys secrets/koksownik.yaml
```

To create a new secrets file for a new machine:
```sh
sops secrets/newmachine.yaml
```

**4. Rebuild** to deploy the secrets:

```sh
sudo nixos-rebuild switch --flake .#newmachine
```

### Editing secrets

```sh
sops secrets/koksownik.yaml
```

## Updating Flakes

To update all flake inputs to their latest versions:

```sh
nix flake update
```

