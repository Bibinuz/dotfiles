pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Bluetooth
import Quickshell.Io
import QtQuick

StatusChip {
    id: btChip
    property var adapter: (Bluetooth.adapters && Bluetooth.adapters.count > 0) ? Bluetooth.adapters.get(0) : null
    property string connectedDevice: {
    if (!adapter || !adapter.enabled) return ""
        if (Bluetooth.devices && Bluetooth.devices.count > 0) {
            for (var i = 0; i < Bluetooth.devices.count; i++) {
                var d = Bluetooth.devices.get(i)
                if (d && d.connected) return d.name || "Device"
            }
        }
        return ""
    }
    iconText: "󰂯"
    labelText: !adapter ? "N/A" : (!adapter.enabled ? "Off" : (connectedDevice !== "" ? connectedDevice : "On"))
    iconColor: adapter && adapter.enabled ? (connectedDevice !== "" ? btChip.theme.tertiary : btChip.theme.primary) : btChip.theme.outline

    Process {
        id: bluetuiProcess
        command: ["kitty", "--title", "bluetui", "-e", "bluetui"]
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            bluetuiProcess.running = true
        }
    }
}
