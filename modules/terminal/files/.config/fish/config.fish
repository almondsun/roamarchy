if status is-interactive
    set -g fish_greeting

    if command -q starship
        starship init fish | source
    end

    if command -q fastfetch; and not set -q ROAMARCHY_FASTFETCH_SHOWN; and string match -q "xterm-kitty*" "$TERM"
        set -gx ROAMARCHY_FASTFETCH_SHOWN 1
        fastfetch --logo-recache true
    end
end
