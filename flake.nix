{
  description = "human-mj-description: integration of mc-human in mc-mujoco";

  inputs = {
    mc-rtc-nix.url = "github:mc-rtc/nixpkgs";
    flake-parts.follows = "mc-rtc-nix/flake-parts";
    systems.follows = "mc-rtc-nix/systems";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        systems = import inputs.systems;
        imports = [
          inputs.mc-rtc-nix.flakeModule
          {
            mc-rtc-superbuild =
              { pkgs, ... }:
              {
                enable = true;
                configurations = {
                  human-mj-description = {
                    extends = [ "minimal" ];
                    mainRobot = "human";
                    enabled = "Posture";
                    runtime = {
                      apps = [
                        pkgs.mc-mujoco
                      ];
                    };
                    devel = {
                      robots = [ pkgs.mc-human ];
                    };
                  };
                };
              };

            flakoboros = {
              overrideAttrs.human-mj-description = {
                src = lib.cleanSource ./.;
              };
              overrides.mc-mujoco-robots =
                { pkgs-final, ... }:
                {
                  robots = with pkgs-final; [
                    human-mj-description
                  ];
                };
              overrides.mc-mujoco =
                { pkgs-final, ... }:
                {
                  inherit (pkgs-final) mc-mujoco-robots;
                };
            };
          }
        ];
      }
    );
}
