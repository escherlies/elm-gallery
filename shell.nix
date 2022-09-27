{ pkgs ? import <nixpkgs> {
    overlays = [
      (self: super: {
        build = self.writers.writeDashBin "build" ''
          set -efu
          export PATH=${self.lib.makeBinPath [
            self.elmPackages.elm
          ]}
          cd ${self.lib.escapeShellArg (toString ./.)}
          elm make
          cd example
          elm make Example.elm --output /dev/null
        '';
      })
    ];
  }
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.build
    pkgs.elmPackages.elm
    pkgs.elmPackages.elm-format
    pkgs.elmPackages.elm-json
    pkgs.elmPackages.elm-test
  ];
}
