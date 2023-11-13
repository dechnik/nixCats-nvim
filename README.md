# nixCats-nvim: A Luanatic's kickstarter flake

This is a kickstarter style repo. It borrows a lot of lua from kickstarter.nvim. It has most of the same plugins.

The lua is not all 1 file. Because I dont like that much at all. It could be though.

It is aimed at people who know enough lua to comfortably proceed from a kickstarter level setup

who want to swap to using nix while still using lua for configuration.

It allows for project specific packaging using nixCats.

For 95% of plugins, you wont need to do more than add plugins to lists,

then configure in lua using the regular setup or config functions provided.

The end result is it ends up being very much like using a neovim package manager

except with the bonus of making sure ALL dependencies are installed and being able to install more than just neovim plugins.

You can also specify programs and environment variables accessible only to neovim's PATH.

[:help nixCats](./nixCatsHelp/nixCats.txt)

[:help nixCats.flake](./nixCatsHelp/nixCatsFlake.txt)

#### Introduction:
 
```
The mission: 
    Replace lazy and mason with nix, keep everything else in lua. 
    Still allow project specific packaging.

The solution: 
    Include the flake itself as a plugin
    Create nixCats so the lua may know what categories are packaged
    Also I added some really nice copy paste keybinds in clippy.lua
    You may optionally have your config in your normal directory as well.
        (You will still be able to reference nixCats and the help should you do this.)
```

#### These are the reasons I wanted to do it this way: 

    The setup instructions for new plugins are all in Lua so translating them is effort.

    I didnt want to be forced into creating a new lua file for every plugin.

    I wanted my neovim config to be neovim flavored 
        (so that I can take advantage of all the neovim dev tools with minimal fuss)

    I still wanted my config to know what plugins and LSPs I included in the package
        so I created nixCats

You should not have to leave [flake.nix](./flake.nix) or VERY occasionally [customPluginOverlay](./customPluginOverlay.nix), although there is a guide to doing so. [:help nixCats.flake.nixperts.nvimBuilder](./nixCatsHelp/nvimBuilder.txt)

All config folders like ftplugin work, if you want lazy loading put it in optionalPlugins in a category in the flake and call packadd when you want it.

You will need nix with flakes enabled, git, a clipboard manager of some kind, and a terminal that supports bracketed paste

---

#### Basic usage:

(full usage covered in included help files, accessible here and inside neovim)

You install the plugins/LSP/debugger/program using nix, by adding them to a category in the flake (or creating a new category for it!)

You may need to add their link to the flake inputs and/or overlays section if they are not on nixpkgs already.

You then choose what categories to include in the package.

You then set them up in your lua, using the default methods to do so. No more translating to your package manager!

You can optionally ask what categories you have, whenever you require nixCats

If you encounter any build steps that are not well handled by nixpkgs, 
or you need to import a plugin straight from git that has a non-standard build step,
and need to do a custom definition, [./customPluginOverlay.nix](./customPluginOverlay.nix) is the place for it.

You do not have to name your folder within the lua directory myLuaConf. Just change RCName in the flake.

---

#### Installation:

```bash
# to test:
nix shell github:BirdeeHub/nixCats-nvim#nixCats
# If using zsh, be sure to escape the #
```

However, you should really just clone or fork the repo, 
because to edit your config, you edit the lua in your flake. 

Unless you are using regularCats package, in which case your config will
be in the normal place, and you only need to flake itself to install new things.

If you want to add it to another flake, choose one of these methods:

```nix
{
    description = "How to import nixCats flake in a flake. 2 ways.";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        flake-utils.url = "github:numtide/flake-utils";
        nixCats-nvim.url = "github:BirdeeHub/nixCats-nvim";
    };
    outputs = { self, nixpkgs, flake-utils, nixCats-nvim }@inputs: 
    flake-utils.lib.eachDefaultSystem (system: let 
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            nixCats-nvim.outputs.overlays.${system}.nixCats
            nixCats-nvim.outputs.overlays.${system}.regularCats
          ];
        };
    in
        {
            packages.default = nixCats-nvim.outputs.packages.${system}.nixCats;
            packages.nixCats = pkgs.nixCats;
            packages.regularCats = pkgs.regularCats;
        }
    );
}
```

---

#### Special mentions:

Many thanks to Quoteme for a great repo to teach me the basics of nix!!! I borrowed some code from it as well because I couldn't have written it better yet.

[pluginOverlay](./nix/pluginOverlay.nix) is a file copy pasted from [a section of Quoteme's repo.](https://github.com/Quoteme/neovim-flake/blob/34c47498114f43c243047bce680a9df66abfab18/flake.nix#L42C8-L42C8)

Thank you!!! It taught me both about an overlay's existence and how it works.

I also borrowed some code from nixpkgs and included links.

#### Issues:

I'm somewhat new to neovim AND nix. However, all my issues are primarily related to lua.

I can install everything needed appropriately to do these things using nix, but I don't know enough about neovim to do the following:

1:

I haven't been able to connect a debugger to dap yet, but installing the stuff in nix is the easy part of that. I'm struggling with the lua...

dap, dap-ui, and dap-virtual-text are all already on nixpkgs, as are most if not all of the debuggers. I just have to connect them....

As such, I have included the config I've been using for dap, dap-ui and dap-virtual-text which all work but I have not enabled the category for them, because there are no debuggers connected to them.

2:

neodev only properly detects your library of plugins if your lua is in your .config folder. Strangely it does not matter if you have a wrapped or unwrapped rc.

It should be easy to fix if you know how to configure neodev to use a different config root dir, but I do not.

There is an override option for it in the setup function but I havent found docs for that.

If needed for that, you can pass the path to the flake from nix to the lua through nixCats.

Alternatively you could just unwrap your lua using the setting and copy it to your config dir. 
Or, you could clone the repo to your .config dir, name it nvim, and leave it wrapped. Either allows for it to do library detection.

3:

I don't know how to set up formatters in lua, so there is only lsp formatting right now.

4:

How would I add the motions on yank to clipboard to which-key like for regular yank?

---

If someone figures any of those out, please let me know.
