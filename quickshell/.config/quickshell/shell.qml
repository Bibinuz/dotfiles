import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import "components"

PanelWindow {
    id: root
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 40
    color: "transparent"

    Colors { id: theme }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(
            theme.surface_container_lowest.r,
            theme.surface_container_lowest.g,
            theme.surface_container_lowest.b,
            0.75
        )

        // Subtle bottom border
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: theme.outline_variant
            opacity: 0.5
        }

        Item {
            anchors.fill: parent
            anchors.leftMargin: 14
            anchors.rightMargin: 14

            // ── LEFT: Workspaces + Active Window ────────────────────────────
            RowLayout {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 0

                WorkspaceWidget {
                    theme: theme
                }

                // Separator
                Rectangle {
                    implicitWidth: 1
                    implicitHeight: 16
                    color: theme.outline_variant
                    opacity: 0.6
                    Layout.leftMargin: 10
                    Layout.rightMargin: 10
                }

                ActiveWindowWidget {
                    theme: theme
                    Layout.maximumWidth: 380
                }
            }

            // ── CENTER: Clock ────────────────────────────────────────────────
            ClockWidget {
                anchors.centerIn: parent
                theme: theme
            }

            // ── RIGHT: Status indicators + Power ────────────────────────────
            RowLayout {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                BatteryIndicator { theme: theme }
                VolumeIndicator { theme: theme }
                NetworkIndicator {
                    theme: theme
                    onClicked: wifiMenuPopup.visible = !wifiMenuPopup.visible
                }
                BluetoothIndicator { theme: theme }

                // Separator before power
                Rectangle {
                    implicitWidth: 1
                    implicitHeight: 16
                    color: theme.outline_variant
                    opacity: 0.5
                    Layout.leftMargin: 6
                    Layout.rightMargin: 6
                }

                PowerButton {
                    id: mainPowerBtn
                    icon: "󰐥"
                    tooltip: "Power Menu"
                    bgColor: theme.error_container
                    iconColor: theme.on_error_container
                    hoverColor: theme.error
                    hoverIconColor: theme.on_error
                    theme: theme
                    onClicked: powerMenuPopup.visible = !powerMenuPopup.visible
                }
            }
        }
    }
    // ── Power Menu Popup ──────────────────────────────────────────────────────
    PowerMenuPopup {
        id: powerMenuPopup
        theme: theme
        anchor.window: root
        anchor.rect.x: root.width - 180 - 14
        anchor.rect.y: 40
        anchor.rect.width: 180
        anchor.rect.height: 0
    }

    // ── Auto Reload Watcher ───────────────────────────────────────────────────
    Process {
        command: ["sh", "-c", "inotifywait -q -m -e close_write ~/.config/quickshell/components/Colors.qml | while read -r line; do touch ~/.config/quickshell/shell.qml; done"]
        running: true
    }
}
