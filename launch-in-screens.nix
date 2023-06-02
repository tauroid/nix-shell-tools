pkgs: supplyPackagesGetCommandsAndPorts:
supplyPackagesGetCommandsAndPorts [ pkgs.netcat-gnu pkgs.screen ]
  (commandsAndPorts:
    builtins.concatStringsSep "\n" (
      map ({name, command, port ? null, sgr}: ''
             screen -d -m -S "${name}" bash -c "${command}"
           ''
           + (let reset = ''\033[0m'';
                  green = ''\033[1;32m'';
              in
              ''
                printf "Launched ${sgr}${name}${reset}, view using \`screen -r ${name}\`\n"
              ''
              + (if port == null then "" else ''
                  ((while ! nc -z localhost ${toString port}; do
                     sleep 0.5
                   done

                   printf "\n${sgr}${name}${reset} active on port ${toString port}"
                   printf "\n''${PS1@P}"
                  ) &)
                ''))
          ) commandsAndPorts
    )
  )
