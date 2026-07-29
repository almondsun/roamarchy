#!/usr/bin/env bats

setup() {
  export TEST_ROOT
  TEST_ROOT=$(mktemp -d)
  export XDG_RUNTIME_DIR="$TEST_ROOT/runtime"
  export HYPRLAND_INSTANCE_SIGNATURE=test-instance
  export ROAMARCHY_WORKSPACE_LIMIT=4
  export MOCK_EVAL_LOG="$TEST_ROOT/eval.log"
  export MOCK_EVENTS="$TEST_ROOT/events"
  export MOCK_ACTIVE_MONITORS="$BATS_TEST_DIRNAME/fixtures/active-dual.json"
  export MOCK_ALL_MONITORS="$BATS_TEST_DIRNAME/fixtures/all-dual.json"
  export MOCK_WORKSPACES="$BATS_TEST_DIRNAME/fixtures/workspaces-dual.json"
  export PATH="$BATS_TEST_DIRNAME/helpers/bin:$PATH"

  mkdir -p "$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE"
  : >"$MOCK_EVAL_LOG"
  : >"$MOCK_EVENTS"

  SCRIPT="$BATS_TEST_DIRNAME/../modules/monitor-layout/files/.local/bin/roamarchy-monitor-layout"
}

teardown() {
  rm -rf "$TEST_ROOT"
}

@test "dual-monitor apply chooses best modes and alternating workspace rules" {
  run "$SCRIPT" apply

  [ "$status" -eq 0 ]
  grep -Fq \
    'output = "HDMI-A-1", mode = "2560x1440@60.00", position = "0x0", scale = 1' \
    "$MOCK_EVAL_LOG"
  grep -Fq \
    'output = "eDP-1", mode = "1920x1080@120.00", position = "2560x0", scale = 1' \
    "$MOCK_EVAL_LOG"
  grep -Fq 'workspace = "1", monitor = "HDMI-A-1"' "$MOCK_EVAL_LOG"
  grep -Fq 'workspace = "2", monitor = "eDP-1"' "$MOCK_EVAL_LOG"
  grep -Fq 'workspace = "3", monitor = "HDMI-A-1"' "$MOCK_EVAL_LOG"
  grep -Fq 'workspace = "4", monitor = "eDP-1"' "$MOCK_EVAL_LOG"
  grep -Fq \
    'focus({ workspace = "1" })); hl.dispatch(hl.dsp.workspace.move({ monitor = "HDMI-A-1" }))' \
    "$MOCK_EVAL_LOG"
  grep -Fq \
    'focus({ workspace = "2" })); hl.dispatch(hl.dsp.workspace.move({ monitor = "eDP-1" }))' \
    "$MOCK_EVAL_LOG"
  ! grep -Fq 'workspace = "9"' "$MOCK_EVAL_LOG"
}

@test "internal-only apply uses one monitor for every managed workspace" {
  export MOCK_ACTIVE_MONITORS="$BATS_TEST_DIRNAME/fixtures/active-internal.json"
  export MOCK_ALL_MONITORS="$BATS_TEST_DIRNAME/fixtures/all-internal.json"
  export MOCK_WORKSPACES="$BATS_TEST_DIRNAME/fixtures/workspaces-internal.json"

  run "$SCRIPT" apply

  [ "$status" -eq 0 ]
  grep -Fq \
    'output = "eDP-1", mode = "1920x1080@60.00", position = "auto", scale = 1' \
    "$MOCK_EVAL_LOG"
  [ "$(grep -o 'monitor = "eDP-1"' "$MOCK_EVAL_LOG" | wc -l)" -ge 4 ]
  ! grep -Fq 'signature = "split:' "$MOCK_EVAL_LOG"
  grep -Fq 'signature = "single:eDP-1:4"' "$MOCK_EVAL_LOG"
}

@test "apply exits quietly when no internal display is active" {
  export MOCK_ACTIVE_MONITORS="$BATS_TEST_DIRNAME/fixtures/active-no-internal.json"

  run "$SCRIPT" apply

  [ "$status" -eq 0 ]
  [ ! -s "$MOCK_EVAL_LOG" ]
}

@test "unsafe monitor names are rejected before evaluating Lua" {
  export MOCK_ACTIVE_MONITORS="$BATS_TEST_DIRNAME/fixtures/active-unsafe.json"
  export MOCK_ALL_MONITORS="$BATS_TEST_DIRNAME/fixtures/all-unsafe.json"

  run "$SCRIPT" apply

  [ "$status" -ne 0 ]
  [ ! -s "$MOCK_EVAL_LOG" ]
}

@test "workspace limit must be a positive integer" {
  export ROAMARCHY_WORKSPACE_LIMIT=invalid

  run "$SCRIPT" apply

  [ "$status" -eq 2 ]
  [[ "$output" == *"ROAMARCHY_WORKSPACE_LIMIT must be a positive integer"* ]]
  [ ! -s "$MOCK_EVAL_LOG" ]
}

@test "unknown commands return usage and exit 2" {
  run "$SCRIPT" unknown

  [ "$status" -eq 2 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "watch applies initially and for relevant monitor events only" {
  printf '%s\n' \
    'workspace>>1' \
    'monitoradded>>HDMI-A-1' \
    'configreloaded>>' >"$MOCK_EVENTS"

  run "$SCRIPT" watch

  [ "$status" -eq 0 ]
  [ "$(grep -c 'output = "HDMI-A-1"' "$MOCK_EVAL_LOG")" -eq 3 ]
}
