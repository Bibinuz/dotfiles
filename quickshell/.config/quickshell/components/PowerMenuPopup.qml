import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

PopupWindow {
    id: popup
    property var theme
    property var shellRoot

    implicitWidth: 180
    implicitHeight: powerMenuCol.implicitHeight + 16
    color: "transparent"
    visible: false
    grabFocus: true

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 6
        color: popup.theme ? popup.theme.surface_container_high : "#252b29"
        radius: 12
        border.color: popup.theme ? popup.theme.outline_variant : "#3f4945"
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
                onClicked: {
                    popup.visible = false
                    if (popup.shellRoot && popup.shellRoot.lockProc)
                        popup.shellRoot.lockProc.running = true
                }
            }

            PopupMenuItem {
                icon: "󰤄"
                text: "Suspend"
                theme: popup.theme
                onClicked: {
                    popup.visible = false
                    if (popup.shellRoot && popup.shellRoot.suspendProc)
                        popup.shellRoot.suspendProc.running = true
                }
            }

            PopupMenuItem {
                icon: "󰗽"
                text: "Logout"
                theme: popup.theme
                onClicked: {
                    popup.visible = false
                    if (popup.shellRoot && popup.shellRoot.logoutProc)
                        popup.shellRoot.logoutProc.running = true
                }
            }

            PopupMenuItem {
                icon: "󰑐"
                text: "Reboot"
                theme: popup.theme
                onClicked: {
                    popup.visible = false
                    if (popup.shellRoot && popup.shellRoot.restartProc)
                        popup.shellRoot.restartProc.running = true
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: popup.theme ? popup.theme.outline_variant : "#3f4945"
                opacity: 0.5
                Layout.topMargin: 2
                Layout.bottomMargin: 2
            }

            PopupMenuItem {
                icon: "󰐥"
                text: "Power Off"
                theme: popup.theme
                onClicked: {
                    popup.visible = false
                    if (popup.shellRoot && popup.shellRoot.poweroffProc)
                        popup.shellRoot.poweroffProc.running = true
                }
                Layout.bottomMargin: 6
            }
        }
    }
}
