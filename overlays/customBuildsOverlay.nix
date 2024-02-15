importName: inputs: let
  overlay = self: super: { 
    ${importName} = {

      # I needed to do this because the one on nixpkgs wasnt working
      # reddit user bin-c found this link for me.
      # and I adapted the funtion to my overlay
      # It is the entry from nixpkgs.
      # https://github.com/NixOS/nixpkgs/blob/44a691ec0cdcd229bffdea17455c833f409d274a/pkgs/applications/editors/vim/plugins/overrides.nix#L746
      markdown-preview-nvim =  let
        nodeDep = super.yarn2nix-moretea.mkYarnModules rec {
          inherit (super.vimPlugins.markdown-preview-nvim) pname version;
          packageJSON = "${super.vimPlugins.markdown-preview-nvim.src}/package.json";
          yarnLock = "${super.vimPlugins.markdown-preview-nvim.src}/yarn.lock";
          offlineCache = super.fetchYarnDeps {
            inherit yarnLock;
            hash = "sha256-kzc9jm6d9PJ07yiWfIOwqxOTAAydTpaLXVK6sEWM8gg=";
          };
        };
      in super.vimPlugins.markdown-preview-nvim.overrideAttrs {
        # apparently I dont need this?
        # patches = [
        #   (super.substituteAll {
        #     src = "${super.vimPlugins.markdown-preview-nvim.src}/fix-node-paths.patch";
        #     node = "${super.nodejs}/bin/node";
        #   })
        # ];
        postInstall = ''
          ln -s ${nodeDep}/node_modules $out/app
        '';

        nativeBuildInputs = [ super.nodejs ];
        doInstallCheck = true;
        installCheckPhase = ''
          node $out/app/index.js --version
        '';
      };

      obsidian-nvim = super.vimPlugins.obsidian-nvim.overrideAttrs (oldAttrs: {
        version = "2024-02-14";
        src = super.fetchFromGitHub {
          owner = "epwalsh";
          repo = "obsidian.nvim";
          rev = "0a6739d2229c8eb30396db550f3818e092088c27";
          sha256 = "sha256-VIc5qgzqJjSv2A0v8tM25pWh+smX9DYXVsyFNTGMPbQ=";
        };
      });
    };
  };
in
overlay
