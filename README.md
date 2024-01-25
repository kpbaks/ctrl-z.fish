# ctrl+z.fish

Most TUI applications like `nvim`, `hx` and `htop` maps <kbd>ctrl+z</kbd> to send their process into the background and return to the shell prompt. To then bring the process back into the foreground you would use the `fg` command.
While this is quick, it can be made more seamless by creating a `fish` keybind for <kbd>ctrl+z</kbd> to call `fg`. Allowing you
to quickly toggle back and forth between the TUI program and the shell!

This functionality can be implemented in a single line:

```fish
bind \cz 'jobs --quiet && fg 2>/dev/null; commandline --function repaint'
```

So if this is enough functionality for you. You can simply copy the snippet into `~/.config/fish/config.fish`

Beyond this, `ctrl+z.fish` provides two features in addition:

- A notification is printed to the terminal when you press <kbd>ctrl+z</kbd> and there are no jobs to bring to the foreground.
- A `ctrl_z_to_bg` event is emitted when you press <kbd>ctrl+z</kbd> in the TUI application and return to the shell prompt. This allows you to create listeners for this event that can be used to run commands when you return to the shell prompt. The rationale is that when you press <kbd>ctrl+z</kbd> you do it because you want to run a quick command in the shell, and then return to the TUI application. So why not automate this?

## Installation

```fish
fisher install kpbaks/ctrl+z.fish
```

## Usage

To use the `ctrl_z_to_bg` event, you need to create a listener for it. This can be done as follows:

```fish
# Run `cargo check` when you return to the shell prompt in a cargo project
function __ctrl+z.fish::listener::cargo_check --on-event ctrl_z_to_bg -a command
    test -f Cargo.toml; or return 0
    cargo check
end

# Run `git status --short` when you return to the shell prompt in a git repository
function __ctrl+z.fish::listener::git_status --on-event ctrl_z_to_bg -a command
    if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        command git status --short
    end
end
```

**NOTE:** The name of the listener function does not matter.

When the event is emitted, the command that was put into the background is passed as an argument to the listener function. You can use this to only run a command when a specific program is put into the background.

```fish
set -l EDITOR hx
$EDITOR README.md
# Press ctrl+z to return to the shell prompt
# Then the `-a command` argument will be expanded to `hx README.md`
```
