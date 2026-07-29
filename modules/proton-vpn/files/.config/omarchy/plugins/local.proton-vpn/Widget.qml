import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

BarIndicator {
  id: root
  moduleName: "local.proton-vpn"

  property bool connected: false
  property bool busy: false
  property string server: ""
  property string lastError: ""

  active: connected
  activeText: busy ? "󰔟" : "󰌾"
  inactiveText: busy ? "󰔟" : "󰌿"
  activeTooltipText: busy
    ? "Disconnecting Proton VPN…"
    : "Disconnect Proton VPN" + (server ? "\n" + server : "")
  inactiveTooltipText: busy
    ? "Connecting Proton VPN…"
    : (lastError ? "Connect Proton VPN\n" + lastError : "Connect Proton VPN")

  indicatorBlock: "single"
  indicatorHost: revealState
  visible: effectiveActive || inactiveRevealed

  QtObject {
    id: revealState

    readonly property bool revealInactiveIndicators: root.busy
      || (root.bar
        && root.bar.centerSectionRevealHeld === true
        && root.bar.centerHoverRevealSuppressed !== true)

    function setIndicatorItemHovered(hovered) {}
  }

  function compactError(raw) {
    var firstLine = String(raw || "").trim().split("\n")[0]
    if (!firstLine) return "Proton VPN command failed"
    if (/timed out/i.test(firstLine))
      return "Proton VPN command timed out"
    if (/desktop app is currently running/i.test(firstLine))
      return "Quit the Proton VPN desktop app to use this indicator"
    if (/authentication required|sign in/i.test(firstLine))
      return "Sign in with the Proton VPN app, then choose Quit"
    return firstLine.length > 180 ? firstLine.slice(0, 177) + "…" : firstLine
  }

  function refresh() {
    if (!statusProcess.running && !actionProcess.running)
      statusProcess.running = true
  }

  function updateStatus(raw) {
    var output = String(raw || "")
    var serverMatch = output.match(/^proton0:connected:(.+)$/m)
    connected = serverMatch !== null
    server = serverMatch ? serverMatch[1].trim() : ""
    lastError = ""
    busy = false
  }

  function reportFailure(raw) {
    var message = compactError(raw)
    lastError = message
    busy = false

    Quickshell.execDetached([
      "notify-send",
      "--urgency=critical",
      "Proton VPN",
      message
    ])

    if (/authentication required|sign in/i.test(String(raw || "")))
      Quickshell.execDetached(["protonvpn-app"])
  }

  function setUnavailable(raw) {
    connected = false
    server = ""
    lastError = compactError(raw)
    busy = false
  }

  Component.onCompleted: refresh()

  Timer {
    interval: 5000
    repeat: true
    running: true
    onTriggered: root.refresh()
  }

  Timer {
    id: delayedRefresh
    interval: 600
    repeat: false
    onTriggered: root.refresh()
  }

  Process {
    id: statusProcess
    command: ["timeout", "5", "nmcli", "-t", "-f", "DEVICE,STATE,CONNECTION", "device", "status"]
    stdout: StdioCollector { id: statusStdout; waitForEnd: true }
    stderr: StdioCollector { id: statusStderr; waitForEnd: true }
    onExited: function(exitCode) {
      var output = String(statusStdout.text || "")
      var errorOutput = String(statusStderr.text || "")
      if (exitCode === 0) root.updateStatus(output)
      else root.setUnavailable(errorOutput || output)
    }
  }

  Process {
    id: actionProcess
    command: []
    stdout: StdioCollector { id: actionStdout; waitForEnd: true }
    stderr: StdioCollector { id: actionStderr; waitForEnd: true }
    onExited: function(exitCode) {
      var output = String(actionStdout.text || "")
      var errorOutput = String(actionStderr.text || "")
      if (exitCode === 124) root.reportFailure("Proton VPN command timed out")
      else if (exitCode !== 0) root.reportFailure(errorOutput || output)
      else delayedRefresh.restart()
    }
  }

  onPressed: function() {
    if (busy || actionProcess.running) return
    busy = true
    lastError = ""
    actionProcess.command = connected
      ? ["timeout", "30", "protonvpn", "disconnect"]
      : ["timeout", "30", "protonvpn", "connect"]
    actionProcess.running = true
  }
}
