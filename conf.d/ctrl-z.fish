# Makes it easy to toggle between $EDITOR and the terminal/shell
function __ctrl+z.fish -d "Keybind function for ctrl+z.fish. Not meant to be called directly"

    if not builtin jobs --quiet
        set -l reset (set_color normal)
        set -l color_command (set_color $fish_color_command)
        # https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797#cursor-controls
        printf "\x1b[0G" # Move cursor to the start of the line (0'th column).
        printf "\x1b[2K" # Clear the current line, to erase the leftover (partial) prompt.
        printf "%shint%s: this keybind, i.e. %s%s%s, only does something, if there are >= 1 background %sjobs%s ;)\n" \
            (set_color cyan) $reset \
            $color_command (status function) $reset \
            $color_command $reset

        return 1
    end

    # TODO: What if there is more that one job? Pick the latest, or use fzf to pick?
    builtin jobs | read job group cpu state command
    set -l n_jobs_before (builtin jobs | count)

    fg 2>/dev/null

    set -l n_jobs_after (builtin jobs | count)
    if test $n_jobs_before -eq $n_jobs_after
        # Only emit if sending job back to background, and not exiting the program
        emit ctrl_z_to_bg $command
    end
end

function __ctrl+z.fish::listener::hint_putting_in_foreground --on-event ctrl_z_to_bg -a command
    set -l reset (set_color normal)
    set -l blue (set_color blue)

    printf "\n%s><>%s press %sctrl+z%s to put the top background job (%s%s) in the foreground.\n" \
        $blue $reset \
        $blue $reset \
        (printf (printf $command | fish_indent --ansi)) $reset
end

function __ctrl+z.fish::listener::cargo_check --on-event ctrl_z_to_bg -a command
    test -f Cargo.toml; or return 0
    cargo check
end

function __ctrl+z.fish::listener::git_status --on-event ctrl_z_to_bg -a command
    # fg is a blocking call
    # When it returns, it would be nice to show some contextial information
    if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        command git status
    end

    # if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
    #     set --query __ctrl_z_prev_git_status_modified
    #     or set -g __ctrl_z_prev_git_status_modified (command git ls-files --modified)
    #     set -l __ctrl_z_git_status_modified (command git ls-files --modified)
    #     # Check if the two arrays are equal
    #     set -l equal 1
    #     # If the two arrays do not have the same length, then they are not equal
    #     test (count $__ctrl_z_prev_git_status_modified) -ne (count $__ctrl_z_git_status_modified); and set equal 0
    #     # If they have the same length, then check if they have the same elements
    #     if test $equal -eq 1
    #         for i in (seq (count $__ctrl_z_prev_git_status_modified))
    #             if test $__ctrl_z_prev_git_status_modified[$i] != $__ctrl_z_git_status_modified[$i]
    #                 set equal 0
    #                 break
    #             end
    #         endthe
    #     end

    #     if test $equal -eq 0
    #         command git status
    #         set -g __ctrl_z_prev_git_status_modified $__ctrl_z_git_status_modified
    #     end
    # else
    #     ls
    # end
end

bind \cz '__ctrl+z.fish; commandline --function repaint'
