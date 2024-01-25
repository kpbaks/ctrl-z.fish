# ctrl+z.fish

Most TUI applications like `nvim`, `hx` and `htop` maps <kbd>ctrl+z</kbd> to send their process into the background,
and return to the shell prompt. To then bring the process back into the foreground you would use the `fg` command.
While this is quick, and can be made more seamless by creating a `fish` keybind for <kbd>ctrl+z</kbd> to call `fg`. Allowing you
to quickly toggle back and forth between the TUI program and the shell!

This functionality can be implemented in a single line:

```fish
bind \cz 'jobs --quiet && fg 2>/dev/null; commandline --function repaint'
```

So if this is enough functionality for you. You can simply copy the snippet into `~/.config/fish/config.fish`




## Installation
```fish
fisher install kpbaks/ctrl+z.fish
```

## Usage

```fish
function __ctrl+z.fish::listener::cargo_check --on-event ctrl_z_to_bg -a command
    test -f Cargo.toml; or return 0
    cargo check
end

function __ctrl+z.fish::listener::git_status --on-event ctrl_z_to_bg -a command
    if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        command git status --short
    end
end
```
