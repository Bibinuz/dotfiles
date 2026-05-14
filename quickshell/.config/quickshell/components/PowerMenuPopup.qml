import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

PopupWindow {
    id: popup
    property var theme

    implicitWidth: 180
    implicitHeight: powerMenuCol.implicitHeight + 16
    color: "transparent"
    visible: false
    grabFocus: true

    Process { id: logoutProc;  command: ["hyprctl", "dispatch", "exit"] }
    Process { id: restartProc; command: ["systemctl", "reboot"] }
    Process { id: poweroffProc; command: ["systemctl", "poweroff"] }
    Process { id: suspendProc; command: ["systemctl", "suspend"] }
    Process { id: lockProc;    command: ["hyprlock"] }

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 6
        color: popup.theme.surface_container_high
        radius: 12
        border.color: popup.theme.outline_variant
        border.width: 1

        ColumnLayout {
            id: powerMenuCol
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 8
            spacing: 4

            PopupMenuItem {
                icon: "󰌾"
                text: "Lock"
                theme: popup.theme
                onClicked: { popup.visible = false; lockProc.running = true }
            }

            PopupMenuItem {
                icon: "󰤄"
                text: "Suspend"
                theme: popup.theme
                onClicked: { popup.visible = false; suspendProc.running = true }
            }

            PopupMenuItem {
                icon: "󰗽"
                text: "Logout"
                theme: popup.theme
                onClicked: { popup.visible = false; logoutProc.running = true }
            }

            PopupMenuItem {
                icon: "󰑐"
                text: "Reboot"
                theme: popup.theme
                onClicked: { popup.visible = false; restartProc.running = true }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: popup.theme.outline_variant
                opacity: 0.5
                Layout.topMargin: 2
                Layout.bottomMargin: 2
            }

            PopupMenuItem {
                icon: "󰐥"
                text: "Power Off"
                theme: popup.theme
                onClicked: { popup.visible = false; poweroffProc.running = true }
                Layout.bottomMargin: 6
            }
        }
    }
}
