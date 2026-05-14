pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

PopupWindow {
    id: popup
    property var theme

    // ── State ────────────────────────────────────────────────────────────────
    property string selectedSsid: ""
    property string selectedSecurity: ""
    property string connectStatus: ""   // "", "connecting…", "ok", "error: <msg>"
    property string connectingForSsid: ""  // track which SSID we're waiting on
    property var knownSsids: []            // SSIDs with saved nmcli connections

    implicitWidth: 250
    implicitHeight: 350 + (selectedSsid !== "" ? 52 : 0) + (connectStatus !== "" ? 24 : 0)
    color: "transparent"
    visible: false
    grabFocus: true

    // Reset state when popup is closed
    onVisibleChanged: {
        if (!visible) {
            selectedSsid = ""
            selectedSecurity = ""
            connectStatus = ""
            connectingForSsid = ""
            passwordInput.text = ""
        }
    }

    // ── Processes ─────────────────────────────────────────────────────────────

    // Fetch saved connection names so we know which networks don't need a password
    Process {
        id: knownNetsProc
        command: ["sh", "-c", "nmcli -t -f NAME connection show"]
        running: popup.visible
        stdout: StdioCollector {
            onStreamFinished: {
                var names = this.text.trim().split("\n").map(function(s) { return s.trim() })
                popup.knownSsids = names
            }
        }
    }

    Process {
        id: wifiListProc
        command: ["sh", "-c", "nmcli -t -f SSID,SIGNAL,SECURITY,ACTIVE dev wifi | awk -F: '$1 != \"\" && !seen[$1]++' | head -n 20"]
        running: popup.visible
        stdout: StdioCollector {
            onStreamFinished: {
                wifiModel.clear()
                var lines = this.text.trim().split("\n")
                for (var i = 0; i < lines.length; i++) {
                    if (lines[i] === "") continue
                    var parts = lines[i].split(":")
                    if (parts.length >= 4) {
                        wifiModel.append({
                            ssid: parts[0],
                            signal: parseInt(parts[1]) || 0,
                            security: parts[2],
                            active: parts[3] === "yes"
                        })
                    }
                }
                // If we were waiting for a connection, check if it's now active
                if (popup.connectingForSsid !== "") {
                    for (var j = 0; j < wifiModel.count; j++) {
                        var entry = wifiModel.get(j)
                        if (entry.ssid === popup.connectingForSsid && entry.active) {
                            popup.connectStatus = "ok"
                            popup.connectingForSsid = ""
                            break
                        }
                    }
                }
            }
        }
    }

    Timer {
        interval: 10000
        running: popup.visible
        repeat: true
        onTriggered: {
            wifiListProc.running = true
            knownNetsProc.running = true
        }
    }

    Process { id: toggleWifiProc; command: ["sh", "-c", "nmcli radio wifi | grep -q enabled && nmcli radio wifi off || nmcli radio wifi on"] }
    Process { id: disconnectProc; property string targetSsid; command: ["nmcli", "con", "down", "id", targetSsid] }

    // connectProc: command is set dynamically before running = true
    Process {
        id: connectProc

        // When the process finishes, always kick a refresh so the list updates
        // and the wifiListProc callback above can detect success by seeing active=yes
        onRunningChanged: {
            if (!running) {
                // Give the system a moment to fully activate the connection
                refreshTimer.running = true
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                var err = this.text.trim()
                if (err !== "") {
                    popup.connectStatus = "error: " + err.split("\n")[0]
                    popup.connectingForSsid = ""
                }
            }
        }
    }

    // ── UI ────────────────────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 6
        color: popup.theme.surface_container_high
        radius: 12
        border.color: popup.theme.outline_variant
        border.width: 1
        clip: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 8

            // ── Header ───────────────────────────────────────────────────────
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "Wi-Fi Networks"
                    color: popup.theme.on_surface
                    font.family: popup.theme && popup.theme.font ? popup.theme.font : "monospace"
                    font.pixelSize: 14
                    font.weight: Font.Bold
                    Layout.fillWidth: true
                }

                Rectangle {
                    implicitWidth: 30
                    implicitHeight: 30
                    radius: 6
                    color: wifiHover.containsMouse ? popup.theme.secondary_container : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "󰖩"
                        color: wifiHover.containsMouse ? popup.theme.on_secondary_container : popup.theme.on_surface_variant
                        font.family: popup.theme && popup.theme.font ? popup.theme.font : "monospace"
                        font.pixelSize: 16
                    }

                    MouseArea {
                        id: wifiHover
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            toggleWifiProc.running = true
                            refreshTimer.running = true
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: popup.theme.outline_variant
                opacity: 0.5
            }

            // ── Network list ─────────────────────────────────────────────────
            ListView {
                id: wifiList
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: ListModel { id: wifiModel }
                spacing: 2
                clip: true
                delegate: Rectangle {
                    id: delegateRoot
                    required property int signal
                    required property string ssid
                    required property string security
                    required property bool active

                    readonly property bool isSelected: popup.selectedSsid === delegateRoot.ssid

                    width: ListView.view.width
                    height: 36
                    radius: 6
                    color: isSelected
                        ? popup.theme.secondary_container
                        : (itemHover.containsMouse
                            ? popup.theme.secondary_container
                            : (delegateRoot.active ? popup.theme.primary_container : "transparent"))

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 8

                        Text {
                            text: {
                                if (delegateRoot.signal >= 80) return "󰤨"
                                if (delegateRoot.signal >= 60) return "󰤥"
                                if (delegateRoot.signal >= 40) return "󰤢"
                                if (delegateRoot.signal >= 20) return "󰤟"
                                return "󰤯"
                            }
                            color: (delegateRoot.active || delegateRoot.isSelected)
                                ? popup.theme.on_primary_container
                                : (itemHover.containsMouse ? popup.theme.on_secondary_container : popup.theme.primary)
                            font.family: popup.theme && popup.theme.font ? popup.theme.font : "monospace"
                            font.pixelSize: 16
                        }

                        Text {
                            text: delegateRoot.ssid
                            color: (delegateRoot.active || delegateRoot.isSelected)
                                ? popup.theme.on_primary_container
                                : (itemHover.containsMouse ? popup.theme.on_secondary_container : popup.theme.on_surface)
                            font.family: popup.theme && popup.theme.font ? popup.theme.font : "monospace"
                            font.pixelSize: 13
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        Text {
                            text: delegateRoot.security !== "" ? "󰌾" : ""
                            color: (delegateRoot.active || delegateRoot.isSelected)
                                ? popup.theme.on_primary_container
                                : popup.theme.on_surface_variant
                            font.family: popup.theme && popup.theme.font ? popup.theme.font : "monospace"
                            font.pixelSize: 12
                            visible: delegateRoot.security !== ""
                        }
                    }

                    MouseArea {
                        id: itemHover
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (delegateRoot.active) {
                                // Already connected — disconnect
                                disconnectProc.targetSsid = delegateRoot.ssid
                                disconnectProc.running = true
                                popup.selectedSsid = ""
                                popup.connectStatus = ""
                                refreshTimer.running = true
                            } else if (delegateRoot.security !== "") {
                                // Secured network — show password input
                                popup.selectedSsid = delegateRoot.ssid
                                popup.selectedSecurity = delegateRoot.security
                                popup.connectStatus = ""
                                passwordInput.text = ""
                                passwordInput.forceActiveFocus()
                            } else {
                                // Open network — connect directly
                                popup.selectedSsid = ""
                                popup.connectStatus = "connecting…"
                                connectProc.command = ["nmcli", "dev", "wifi", "connect", delegateRoot.ssid]
                                connectProc.running = true
                            }
                        }
                    }
                }
            }

            // ── Password input row (visible when a secured network is selected) ──
            RowLayout {
                Layout.fillWidth: true
                spacing: 6
                visible: popup.selectedSsid !== ""

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    radius: 6
                    color: popup.theme.surface_container
                    border.color: passwordInput.activeFocus ? popup.theme.primary : popup.theme.outline_variant
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        spacing: 6

                        Text {
                            text: "󰌾"
                            color: popup.theme.on_surface_variant
                            font.family: popup.theme && popup.theme.font ? popup.theme.font : "monospace"
                            font.pixelSize: 13
                        }

                        TextInput {
                            id: passwordInput
                            Layout.fillWidth: true
                            color: popup.theme.on_surface
                            font.family: popup.theme && popup.theme.font ? popup.theme.font : "monospace"
                            font.pixelSize: 13
                            echoMode: TextInput.Password
                            Keys.onReturnPressed: doConnect()
                            Keys.onEscapePressed: {
                                popup.selectedSsid = ""
                                popup.connectStatus = ""
                                passwordInput.text = ""
                            }
                        }
                    }
                }

                // Confirm button
                Rectangle {
                    implicitWidth: 32
                    implicitHeight: 32
                    radius: 6
                    color: confirmHover.containsMouse ? popup.theme.primary : popup.theme.surface_container
                    Behavior on color { ColorAnimation { duration: 120 } }

                    Text {
                        anchors.centerIn: parent
                        text: "󰄴"
                        color: confirmHover.containsMouse ? popup.theme.on_primary : popup.theme.on_surface_variant
                        font.family: popup.theme && popup.theme.font ? popup.theme.font : "monospace"
                        font.pixelSize: 14
                    }

                    MouseArea {
                        id: confirmHover
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: doConnect()
                    }
                }

                // Cancel button
                Rectangle {
                    implicitWidth: 32
                    implicitHeight: 32
                    radius: 6
                    color: cancelHover.containsMouse ? popup.theme.surface_container_highest : popup.theme.surface_container
                    Behavior on color { ColorAnimation { duration: 120 } }

                    Text {
                        anchors.centerIn: parent
                        text: "󰅖"
                        color: popup.theme.on_surface_variant
                        font.family: popup.theme && popup.theme.font ? popup.theme.font : "monospace"
                        font.pixelSize: 14
                    }

                    MouseArea {
                        id: cancelHover
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            popup.selectedSsid = ""
                            popup.connectStatus = ""
                            passwordInput.text = ""
                        }
                    }
                }
            }

            // ── Status line ───────────────────────────────────────────────────
            Text {
                Layout.fillWidth: true
                visible: popup.connectStatus !== ""
                text: {
                    if (popup.connectStatus === "connecting…") return "󰤫  Connecting…"
                    if (popup.connectStatus === "ok") return "󰤨  Connected"
                    return "󰤮  " + popup.connectStatus
                }
                color: {
                    if (popup.connectStatus === "connecting…") return popup.theme.on_surface_variant
                    if (popup.connectStatus === "ok") return popup.theme.tertiary
                    return popup.theme.error
                }
                font.family: popup.theme && popup.theme.font ? popup.theme.font : "monospace"
                font.pixelSize: 12
                elide: Text.ElideRight
            }
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────────
    function doConnect() {
        var ssid = popup.selectedSsid
        var pass = passwordInput.text
        if (ssid === "") return

        popup.connectStatus = "connecting…"
        popup.selectedSsid = ""     // hide input row
        passwordInput.text = ""

        if (pass !== "") {
            connectProc.command = ["nmcli", "dev", "wifi", "connect", ssid, "password", pass]
        } else {
            connectProc.command = ["nmcli", "dev", "wifi", "connect", ssid]
        }
        connectProc.running = true
    }

    Timer {
        id: refreshTimer
        interval: 2000
        running: false
        onTriggered: wifiListProc.running = true
    }
}
