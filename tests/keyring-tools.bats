#!/usr/bin/env bats

setup() {
  export TEST_ROOT
  TEST_ROOT=$(mktemp -d)
  chmod 700 "$TEST_ROOT"
  REPAIR="$BATS_TEST_DIRNAME/../modules/ente-auth/files/.local/bin/roamarchy-repair-plaintext-keyring"
  UNLOCK="$BATS_TEST_DIRNAME/../modules/ente-auth/files/.local/bin/roamarchy-keyring-unlock"
}

teardown() { rm -rf "$TEST_ROOT"; }

write_keyring() {
  printf '%s' "$1" >"$TEST_ROOT/login.keyring"
  chmod 600 "$TEST_ROOT/login.keyring"
}

@test "repair escapes arbitrary multiline values and creates a private backup" {
  write_keyring $'[keyring]\ndisplay-name=Test\n[1]\nitem-type=0\nsecret=first\\path\nsecond line\nmtime=1\nctime=1\n'
  run "$REPAIR" "$TEST_ROOT/login.keyring" --backup "$TEST_ROOT/original.keyring"
  [ "$status" -eq 0 ]
  [ "$output" = "repaired_multiline_secrets=1" ]
  [ "$(stat -c %a "$TEST_ROOT/original.keyring")" = 600 ]
  grep -Fq 'secret=first\\path\nsecond line' "$TEST_ROOT/login.keyring"
}

@test "repair leaves a valid keyring byte-identical and creates no backup" {
  write_keyring $'[keyring]\ndisplay-name=Test\n[1]\nsecret=single-line\nmtime=1\n'
  cp "$TEST_ROOT/login.keyring" "$TEST_ROOT/expected"
  run "$REPAIR" "$TEST_ROOT/login.keyring" --backup "$TEST_ROOT/original.keyring"
  [ "$status" -eq 0 ]
  [ "$output" = "repaired_multiline_secrets=0" ]
  cmp "$TEST_ROOT/expected" "$TEST_ROOT/login.keyring"
  [ ! -e "$TEST_ROOT/original.keyring" ]
}

@test "unlock passes a private newline-free passphrase through stdin" {
  printf '%s' 'test-passphrase-that-is-long-enough' >"$TEST_ROOT/passphrase"
  chmod 600 "$TEST_ROOT/passphrase"
  printf '%s\n' '#!/bin/bash' 'test "$1" = --login' 'test "$2" = --foreground' 'test "$3" = --control-directory="$XDG_RUNTIME_DIR/keyring"' 'payload=$(cat)' 'test "$payload" = test-passphrase-that-is-long-enough' >"$TEST_ROOT/mock-daemon"
  chmod 700 "$TEST_ROOT/mock-daemon"
  run env ROAMARCHY_KEYRING_PASSPHRASE_FILE="$TEST_ROOT/passphrase" ROAMARCHY_GNOME_KEYRING_DAEMON="$TEST_ROOT/mock-daemon" XDG_RUNTIME_DIR="$TEST_ROOT" "$UNLOCK"
  [ "$status" -eq 0 ]
}

@test "unlock refuses unsafe permissions and newline-terminated input" {
  printf '%s\n' 'test-passphrase-that-is-long-enough' >"$TEST_ROOT/passphrase"
  chmod 644 "$TEST_ROOT/passphrase"
  run env ROAMARCHY_KEYRING_PASSPHRASE_FILE="$TEST_ROOT/passphrase" "$UNLOCK"
  [ "$status" -ne 0 ]
  chmod 600 "$TEST_ROOT/passphrase"
  run env ROAMARCHY_KEYRING_PASSPHRASE_FILE="$TEST_ROOT/passphrase" "$UNLOCK"
  [ "$status" -ne 0 ]
}
