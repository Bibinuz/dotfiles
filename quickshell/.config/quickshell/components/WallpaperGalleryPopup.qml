import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.folderlistmodel

PopupWindow {
    id: popup
    property var theme
    property var shellRoot

    implicitWidth: 1000
    implicitHeight: 750
    color: "transparent"
    visible: false
    grabFocus: true

    Shortcut {
        sequence: "Escape"
        onActivated: popup.visible = false
    }

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 6
        color: popup.theme ? popup.theme.surface_container_high : "#252b29"
        radius: 12
        border.color: popup.theme ? popup.theme.outline_variant : "#3f4945"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12

            Text {
                font.family: popup.theme && popup.theme.font ? popup.theme.font : "monospace"
                text: "Wallpaper Gallery (" + folderModel.count + ")"
                color: popup.theme ? popup.theme.on_surface : "white"
                font.pixelSize: 16
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            GridView {
                id: grid
                Layout.fillWidth: true
                Layout.fillHeight: true
                cellWidth: Math.floor(grid.width / 5)
                cellHeight: Math.floor((grid.width / 5) * 0.75)
                clip: true
                cacheBuffer: 500

                ScrollBar.vertical: ScrollBar {
                    active: true
                }

                model: FolderListModel {
                    id: folderModel
                    folder: "file:///home/bibinuz/Pictures/Wallpaper"
                    nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.gif", "*.webp"]
                }

                delegate: Item {
                    id: delegateItem
                    width: grid.cellWidth
                    height: grid.cellHeight

                    required property url fileUrl
                    required property string filePath

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 6
                        radius: 8
                        color: popup.theme ? popup.theme.surface_container : "#1b211f"
                        border.color: itemHover.containsMouse ? (popup.theme ? popup.theme.primary : "#86d6bf") : "transparent"
                        border.width: 2
                        clip: true

                        Image {
                            anchors.fill: parent
                            source: delegateItem.fileUrl
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            cache: false
                            sourceSize.width: 300
                            sourceSize.height: 225
                        }

                        MouseArea {
                            id: itemHover
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                var path = delegateItem.filePath
                                console.log("Gallery: Requesting wallpaper:", path)
                                if (popup.shellRoot && popup.shellRoot.applyWallpaper) {
                                    popup.shellRoot.applyWallpaper(path)
                                } else {
                                    console.error("Gallery: shellRoot.applyWallpaper not found!")
                                }
                                popup.visible = false
                            }
                        }
                    }
                }
            }
        }
    }
}
