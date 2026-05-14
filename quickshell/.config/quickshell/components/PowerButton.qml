import QtQuick

Rectangle {
    id: btn
    property string icon: ""
    property string tooltip: ""
    property color bgColor
    property color iconColor
    property color hoverColor
    property color hoverIconColor
    property var theme
    signal clicked

    implicitWidth: 28
    implicitHeight: 28
    radius: 7
    color: btnHover.containsMouse ? theme.secondary : theme.primary
    Behavior on color { ColorAnimation { duration: 130 } }

    Text {

        font.family: btn.theme && btn.theme.font ? btn.theme.font : "monospace"
        anchors.centerIn: parent
        text: btn.icon
        color: btnHover.containsMouse ? btn.theme.on_secondary : btn.theme.on_primary
        font.pixelSize: 15
        Behavior on color { ColorAnimation { duration: 130 } }
    }

    MouseArea {
        id: btnHover
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: btn.clicked()
    }
}
