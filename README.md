# ctrl+z.fish

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
