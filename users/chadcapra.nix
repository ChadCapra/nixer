{
  identity = {
    name = "Chad Capra";
    username = "chadcapra";
    email = "chadcapra@gmail.com";
  };

  deployments = {
    "ACME-LT-HQ-001" = { roles = [ "core" "creative" ]; };
    "CCAP-CB-RMT-001" = { roles = [ "core" ]; };
    "CCAP-CB-RMT-002" = { roles = [ "core" "creative" ]; }; # The Intel Chromebook
  };
}
