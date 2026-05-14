import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    property var theme
    spacing: 6

    // App indicator dot
    Rectangle {
        implicitWidth: 7
        implicitHeight: 7
        radius: 3.5
        color: root.theme.tertiary
        visible: Hyprland.activeToplevel !== null
        opacity: 0.85
    }

    Text {
        font.family: root.theme && root.theme.font ? root.theme.font : "monospace"
        text: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : "Desktop"
        color: Hyprland.activeToplevel ? root.theme.on_surface : root.theme.on_surface_variant
        font.pixelSize: 13
        font.weight: Hyprland.activeToplevel ? Font.Medium : Font.Normal
        elide: Text.ElideRight
        Layout.fillWidth: true
    }
}
