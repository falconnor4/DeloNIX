{ config, pkgs, inputs, lib, ... }:

let
  model = pkgs.fetchurl {
    url = "https://huggingface.co/mradermacher/Huihui-LFM2.5-1.2B-Thinking-abliterated-i1-GGUF/resolve/main/Huihui-LFM2.5-1.2B-Thinking-abliterated.i1-Q4_K_M.gguf";
    sha256 = "157h2w47qzx64ywgxknl5127x88ccplp2pn7l0wfjx48hq8gs02s";
  };
in
{
  home.packages = with pkgs; [
    opencode
    llama-cpp
    
    (pkgs.writeShellScriptBin "llama-start" ''
      systemctl --user start llama-server
      echo "Llama Server started on http://127.0.0.1:8080"
    '')
    
    (pkgs.writeShellScriptBin "llama-stop" ''
      systemctl --user stop llama-server
      echo "Llama Server stopped"
    '')
  ];

  systemd.user.services.llama-server = {
    Unit = {
      Description = "Llama CPP Server";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${pkgs.llama-cpp}/bin/llama-server -m ${model} --port 8080 --host 127.0.0.1 --ctx-size 32768 --temp 0.05 --top-k 50 --repeat-penalty 1.05";
      Restart = "always";
    };
    Install = {
      WantedBy = lib.mkForce []; # Disable auto-start
    };
  };

  xdg.configFile."opencode/config.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    provider = {
      "llama.cpp" = {
        npm = "@ai-sdk/openai-compatible";
        name = "llama-server (local)";
        options = {
          baseURL = "http://127.0.0.1:8080/v1";
        };
        models = {
          "Huihui-LFM2.5-1.2B" = {
            name = "Huihui LFM 2.5 1.2B (local)";
            limit = {
              context = 32768;
              output = 4096;
            };
          };
        };
      };
    };
  };
}
