import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    property var theme
    spacing: 4

    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            id: wsPill
            property bool isActive: modelData.active
            property bool hasWindows: modelData.clientCount > 0

            implicitWidth: Math.max(isActive ? 32 : 24, numText.implicitWidth + 12)
            implicitHeight: 22
            radius: 11

            color: isActive
                ? root.theme.primary
                : (hasWindows ? root.theme.surface_container_high : root.theme.surface_container)

            opacity: hasWindows || isActive ? 1.0 : 0.5

            Behavior on implicitWidth { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: 150 } }

            function toRoman(str) {
                var num = parseInt(str);
                if (isNaN(num)) return str;
                var roman = { M: 1000, CM: 900, D: 500, CD: 400, C: 100, XC: 90, L: 50, XL: 40, X: 10, IX: 9, V: 5, IV: 4, I: 1 };
                var res = '';
                for (var i in roman) {
                    while (num >= roman[i]) {
                        res += i;
                        num -= roman[i];
                    }
                }
                return res;
            }

            Text {
        font.family: root.theme && root.theme.font ? root.theme.font : "monospace"
                id: numText
                anchors.centerIn: parent
                text: wsPill.toRoman(modelData.name)
                color: wsPill.isActive ? root.theme.on_primary : root.theme.on_surface_variant
                font.bold: wsPill.isActive
                font.pixelSize: 11
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    var wsNum = modelData.name
                    switchWsProc.command = ["hyprctl", "dispatch", "workspace", wsNum]
                    switchWsProc.running = true
                }
            }
        }
    }

    Process {
        id: switchWsProc
        command: ["hyprctl", "dispatch", "workspace", "1"]
    }
}
