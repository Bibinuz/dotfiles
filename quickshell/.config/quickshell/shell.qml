import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import QtQuick.Window
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

    // ── IPC Handlers ──────────────────────────────────────────────────────────
    IpcHandler {
        target: "wallpaper"
        function toggle() {
            wallpaperMenuPopup.visible = !wallpaperMenuPopup.visible
        }
    }

    IpcHandler {
        target: "launcher"
        function toggle() {
            appLauncherPopup.visible = !appLauncherPopup.visible
        }
    }

    // ── Global Functions ──────────────────────────────────────────────────────
    function applyWallpaper(path) {
        console.log("Shell: Applying wallpaper:", path);
        applyWallpaperProc.running = false;
        applyWallpaperProc.command = [
            "sh", "-c",
            "notify-send 'Wallpaper' 'Applying: " + path + "'; " +
            "awww img \"" + path + "\" --transition-type grow --transition-pos 0.9,0.9 --transition-step 90 --transition-fps 144 && " +
            "cp \"" + path + "\" \"$HOME/.config/hypr/current_wallpaper\" && " +
            "matugen image \"" + path + "\" --source-color-index 0 >/dev/null 2>&1; " +
            "notify-send 'Wallpaper changed' 'Applied: " + path + "'"
        ];
        applyWallpaperProc.running = true;
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
                    width: 1
                    height: 16
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
                    onClicked: { /* Wifi menu logic if any */ }
                }
                BluetoothIndicator { theme: theme }

                StatusChip {
                    id: wallpaperChip
                    theme: theme
                    iconText: "󰸉"
                    labelText: ""
                    iconColor: theme.primary
                    onClicked: wallpaperMenuPopup.visible = !wallpaperMenuPopup.visible
                }

                // Separator before power
                Rectangle {
                    width: 1
                    height: 16
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
        theme: root.theme_obj
        shellRoot: root
        anchor.window: root
        anchor.rect.x: root.width - 180 - 14
        anchor.rect.y: 40
        anchor.rect.width: 180
        anchor.rect.height: 0
        visible: false
    }

    // Helper to expose theme as a property
    property alias theme_obj: theme

    property alias applyWallpaperProc: applyWallpaperProc
    property alias logoutProc: logoutProc
    property alias restartProc: restartProc
    property alias poweroffProc: poweroffProc
    property alias suspendProc: suspendProc
    property alias lockProc: lockProc

    Process { id: applyWallpaperProc }
    Process { id: logoutProc;    command: ["hyprctl", "dispatch", "exit"] }
    Process { id: restartProc;   command: ["systemctl", "reboot"] }
    Process { id: poweroffProc;  command: ["systemctl", "poweroff"] }
    Process { id: suspendProc;   command: ["systemctl", "suspend"] }
    Process { id: lockProc;      command: ["hyprlock"] }

    // ── App Launcher Popup ───────────────────────────────────────────────────
    AppLauncherPopup {
        id: appLauncherPopup
        theme: root.theme_obj
        shellRoot: root
        visible: false
    }

    // ── Wallpaper Gallery Popup ───────────────────────────────────────────────
    WallpaperGalleryPopup {
        id: wallpaperMenuPopup
        theme: root.theme_obj
        shellRoot: root
        anchor.window: root
        anchor.rect.x: (root.width - width) / 2
        anchor.rect.y: (Screen.height - height) / 2
        anchor.rect.width: width
        anchor.rect.height: 0
        visible: false
    }

    // ── Auto Reload Watcher ───────────────────────────────────────────────────
    Process {
        command: ["sh", "-c", "inotifywait -q -m -e close_write ~/.config/quickshell/components/Colors.qml | while read -r line; do touch ~/.config/quickshell/shell.qml; done"]
        running: true
        Component.onDestruction: running = false
    }
}
