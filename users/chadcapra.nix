{
  identity = {
    name = "Chad Capra";
    username = "chadcapra";
    email = "chadcapra@gmail.com";
  };

  # Deploy to as many or as few devices as you want
  deployments = {
    "ACME-LT-HQ-001" = { roles = [ "core" "creative" ]; };
    "CCAP-CB-RMT-001" = { roles = [ "core" ]; };
  };
}
