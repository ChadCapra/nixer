{ lib, hostName }:

let
  # 1. Dynamically read all files in the users directory
  userFiles = builtins.attrNames (builtins.readDir ../users);

  # 2. Map over the filenames and import them
  allUsers = map (file: {
    username = lib.removeSuffix ".nix" file;
    data = import (../users + "/${file}");
  }) userFiles;

  # 3. Filter for users who actually have a deployment block for THIS host
  usersForThisHost = builtins.filter (u: 
    builtins.hasAttr hostName u.data.deployments
  ) allUsers;

  # 4. Reduce that list into the exact attrset the Host file expects
  # Result: { "chad" = { identity = {...}; roles = [...]; }; }
  buildRegistry = lib.foldl' (acc: u: 
    acc // {
      ${u.username} = {
        identity = u.data.identity;
        roles = u.data.deployments.${hostName}.roles;
      };
    }
  ) {} usersForThisHost;

in
  buildRegistry
