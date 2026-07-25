-- Quattro already starts its clamshell recovery watcher. This separate watcher
-- adds Roamarchy's dynamic layout and odd/even workspace policy.
o.launch_on_start(os.getenv("HOME") .. "/.local/bin/roamarchy-monitor-layout watch")
