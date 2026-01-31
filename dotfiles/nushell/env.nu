# Set default editor to Neovim
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

$env.PATH = ($env.PATH | split row (char esep) | prepend '~/nixer/bin')
