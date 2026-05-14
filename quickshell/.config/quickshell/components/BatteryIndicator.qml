import Quickshell.Io
import QtQuick

StatusChip {
    id: batteryChip

    iconText: batteryIcon
    labelText: batteryText
    iconColor: batteryCharging ? batteryChip.theme.tertiary : (batteryLevel < 20 ? batteryChip.theme.error : batteryChip.theme.primary)

    property int batteryLevel: 100
    property bool batteryCharging: false
    property string batteryText: "—"
    property string batteryIcon: "󰁹"

    Process {
        id: batProc
        command: ["sh", "-c",
            "cap=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1); " +
            "stat=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1); " +
            "echo \"${cap:-N/A}|${stat:-Unknown}\""
        ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var parts = this.text.trim().split("|")
                var cap = parts[0]
                var stat = parts[1] || ""
                if (cap === "N/A") {
                    batteryChip.batteryText = "AC"
                    batteryChip.batteryIcon = "󰚥"
                    batteryChip.batteryCharging = true
                } else {
                    batteryChip.batteryLevel = parseInt(cap) || 100
                    batteryChip.batteryCharging = stat === "Charging"
                    batteryChip.batteryText = cap + "%"
                    var lvl = parseInt(cap) || 100
                    var charging = stat === "Charging"
                    if (charging) {
                        batteryChip.batteryIcon = "󰂄"
                    } else if (lvl >= 90) {
                        batteryChip.batteryIcon = "󰁹"
                    } else if (lvl >= 70) {
                        batteryChip.batteryIcon = "󰂀"
                    } else if (lvl >= 50) {
                        batteryChip.batteryIcon = "󰁾"
                    } else if (lvl >= 30) {
                        batteryChip.batteryIcon = "󰁼"
                    } else {
                        batteryChip.batteryIcon = "󰁺"
                    }
                }
            }
        }
    }
    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: batProc.running = true
    }
    Process {
        id: battery
        command: ["kitty", "--title", "btop", "-e", "btop"]
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            battery.running = true
        }
    }
}
