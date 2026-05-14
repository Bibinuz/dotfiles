import QtQuick
import QtQuick.Layouts

Item {
    id: chip
    property string iconText: ""
    property string labelText: ""
    property color iconColor
    property var theme
    signal clicked

    implicitWidth: chipRow.implicitWidth + 16
    implicitHeight: 28

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: chip.theme.surface_container
        opacity: chipHover.containsMouse ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 120 } }
    }

    RowLayout {
        id: chipRow
        anchors.centerIn: parent
        spacing: 5

        Text {
        font.family: chip.theme && chip.theme.font ? chip.theme.font : "monospace"
            text: chip.iconText
            color: chip.iconColor
            font.pixelSize: 15
            Behavior on color { ColorAnimation { duration: 150 } }
        }

        Text {
        font.family: chip.theme && chip.theme.font ? chip.theme.font : "monospace"
            text: chip.labelText
            color: chip.theme.on_surface
            font.pixelSize: 12
            font.weight: Font.Medium
            elide: Text.ElideRight
            Layout.maximumWidth: 120
        }
    }

    MouseArea {
        id: chipHover
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: chip.clicked()
    }
}
