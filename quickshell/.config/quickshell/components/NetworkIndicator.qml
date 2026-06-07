pragma ComponentBehavior: Bound

import Quickshell.Io
import QtQuick

StatusChip {
    id: netChip

    iconText: "󰖩"
    labelText: wifiName
    iconColor: wifiName === "Disconnected" ? netChip.theme.outline : netChip.theme.primary

    property string wifiName: "…"

    Process {
        id: wifiProc
        command: ["sh", "-c",
            "name=$(nmcli -t -f NAME connection show --active 2>/dev/null | grep -v 'lo' | head -n 1); " +
            "echo \"${name:-Disconnected}\""
        ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: netChip.wifiName = this.text.trim()
        }
    }
    Timer {
        interval: 8000
        running: true
        repeat: true
        onTriggered: wifiProc.running = true
    }

    Process {
        id: networkProcess
        command: ["kitty", "--title", "wlctl", "-e", "wlctl"]
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            networkProcess.running = true
        }
    }
}
