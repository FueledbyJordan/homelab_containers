{
  description = "Homelab deployment environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Define common dependencies once
        packages = with pkgs; [
          ansible
          docker
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = packages;

          shellHook = ''
            echo "Development environment loaded!"
            echo "Ansible version: $(ansible --version | head -n 1)"
            echo "Docker version: $(docker --version)"
          '';
        };

        packages.default = pkgs.writeShellApplication {
          name = "bootstrap-script";
          runtimeInputs = packages;
          text = ''
            INVENTORY=''${INVENTORY:-helium}
            echo "✅ Switching docker contexts..."
            docker context use "$INVENTORY"

            echo "✅ Setting up remote node..."
            ansible-playbook bootstrap.yml -i "$INVENTORY,"

            echo "✅ Applying containers..."
            op run --no-masking --env-file .secrets -- docker compose up -d
          '';
        };
      }
    );
}
