import QtQuick
import QtQuick.Layouts

Rectangle {
    id: menuItemBtn
    property string icon: ""
    property string text: ""
    property color iconColor: menuItemBtn.theme ? menuItemBtn.theme.on_surface_variant : "white"
    property color hoverColor: menuItemBtn.theme ? menuItemBtn.theme.secondary_container : "gray"
    property color hoverIconColor: menuItemBtn.theme ? menuItemBtn.theme.on_secondary_container : "black"
    property var theme
    signal clicked

    Layout.fillWidth: true
    Layout.preferredHeight: 36
    radius: 6
    color: itemHover.containsMouse ? hoverColor : "transparent"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 12

        Text {
        font.family: menuItemBtn.theme && menuItemBtn.theme.font ? menuItemBtn.theme.font : "monospace"
            text: menuItemBtn.icon
            color: itemHover.containsMouse ? menuItemBtn.hoverIconColor : menuItemBtn.iconColor
            font.pixelSize: 16
        }

        Text {
        font.family: menuItemBtn.theme && menuItemBtn.theme.font ? menuItemBtn.theme.font : "monospace"
            text: menuItemBtn.text
            color: itemHover.containsMouse ? menuItemBtn.hoverIconColor : (menuItemBtn.theme ? menuItemBtn.theme.on_surface : "white")
            font.pixelSize: 13
            Layout.fillWidth: true
        }
    }

    MouseArea {
        id: itemHover
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            menuItemBtn.clicked()
        }
    }
}
