import QtQuick
import QtQuick.Layouts

Item {
    id: chip
    property string iconText: ""
    property string labelText: ""
    property color iconColor
    property var theme
    property color hoverColor: theme ? theme.secondary : "transparent"
    signal clicked

    implicitWidth: chip.labelText !== "" ? chipRow.implicitWidth + 16 : 28
    implicitHeight: 28

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: chip.hoverColor
        opacity: chipHover.containsMouse ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 120 } }
    }

    RowLayout {
        id: chipRow
        anchors.centerIn: parent
        spacing: chip.labelText !== "" ? 5 : 0

        Text {
        font.family: chip.theme && chip.theme.font ? chip.theme.font : "monospace"
            text: chip.iconText
            color: chipHover.containsMouse ? (chip.theme ? chip.theme.on_secondary : "black") : chip.iconColor
            font.pixelSize: 15
            Behavior on color { ColorAnimation { duration: 150 } }
        }

        Text {
            visible: chip.labelText !== ""
        font.family: chip.theme && chip.theme.font ? chip.theme.font : "monospace"
            text: chip.labelText
            color: chipHover.containsMouse ? (chip.theme ? chip.theme.on_secondary : "black") : (chip.theme ? chip.theme.on_surface : "white")
            font.pixelSize: 12
            font.weight: Font.Medium
            elide: Text.ElideRight
            Layout.maximumWidth: 120
            Behavior on color { ColorAnimation { duration: 150 } }
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
