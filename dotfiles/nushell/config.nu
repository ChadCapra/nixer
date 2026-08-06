# Do not show the banner at startup
$env.config.show_banner = false

# Aliases
alias ll = ls -l
alias gs = git status

# Auto-launch Sessionizer if not already in Tmux
if ($env.TMUX? | is-empty) {
    home
} 
