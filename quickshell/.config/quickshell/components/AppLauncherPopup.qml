import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

PanelWindow {
    id: popup
    property var theme
    property var shellRoot

    visible: false

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    anchors {
        top: false
        bottom: false
        left: false
        right: false
    }

    implicitWidth: 1000
    implicitHeight: 560
    color: "transparent"

    property string searchText: ""
    property int selectedIndex: 0

    function focusInput() {
        searchText = ""
        selectedIndex = 0
        if (typeof searchInput !== "undefined" && searchInput) {
            searchInput.forceActiveFocus()
        }
    }

    function launchApp(app) {
        if (app) {
            console.log("AppLauncher: Executing application:", app.name)
            app.execute()
        }
        popup.visible = false
    }

    onVisibleChanged: {
        if (visible) {
            Qt.callLater(focusInput)
        }
    }

    Shortcut {
        sequence: "Escape"
        context: Qt.WindowShortcut
        onActivated: popup.visible = false
    }

    Rectangle {
        anchors.fill: parent
        color: popup.theme ? popup.theme.surface : "#1a1110"
        radius: 15
        border.color: popup.theme ? popup.theme.secondary_container : "#5d3f3a"
        border.width: 2
        clip: true

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 12

            // ── LEFT COLUMN: Wallpaper Container with Overlay Search Bar ────────
            Rectangle {
                id: imageBoxContainer
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 460
                radius: 15
                color: popup.theme ? popup.theme.surface_container_lowest : "#140c0b"
                border.color: popup.theme ? popup.theme.outline_variant : "#534340"
                border.width: 1

                // 1. Wallpaper Image (source item)
                Image {
                    id: wallpaperImg
                    anchors.fill: parent
                    source: "file:///home/bibinuz/.config/hypr/current_wallpaper"
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    sourceSize.width: 600
                    sourceSize.height: 600
                    visible: false
                }

                // 2. Rounded Mask Item (Radius 15 matching image container)
                Rectangle {
                    id: maskItem
                    anchors.fill: parent
                    radius: 15
                    color: "black"
                    visible: false
                    layer.enabled: true
                }

                // 3. MultiEffect applying true rounded corner mask to wallpaper image
                MultiEffect {
                    anchors.fill: parent
                    source: wallpaperImg
                    maskEnabled: true
                    maskSource: maskItem
                }

                // 4. Dark overlay tint for contrast
                Rectangle {
                    anchors.fill: parent
                    radius: 15
                    color: Qt.rgba(0, 0, 0, 0.35)
                }

                // 5. Search Bar overlaid at top of image
                Rectangle {
                    id: searchBarContainer
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 10
                    height: 48
                    radius: 10
                    color: popup.theme ? popup.theme.on_primary : "#561e15"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        spacing: 10

                        Text {
                            text: ""
                            font.family: popup.theme && popup.theme.font ? popup.theme.font : "JetBrainsMono Nerd Font"
                            font.pixelSize: 16
                            color: popup.theme ? popup.theme.on_surface : "#f1dfdb"
                        }

                        TextField {
                            id: searchInput
                            Layout.fillWidth: true
                            placeholderText: "Search applications..."
                            placeholderTextColor: popup.theme ? popup.theme.on_surface_variant : "#d8c2be"
                            text: popup.searchText
                            color: popup.theme ? popup.theme.on_surface : "#f1dfdb"
                            font.family: popup.theme && popup.theme.font ? popup.theme.font : "JetBrainsMono Nerd Font"
                            font.pixelSize: 14
                            background: null

                            onTextChanged: {
                                popup.searchText = text
                                popup.selectedIndex = 0
                            }

                            Keys.onDownPressed: {
                                if (appListView.count > 0) {
                                    popup.selectedIndex = Math.min(popup.selectedIndex + 1, appListView.count - 1)
                                    appListView.positionViewAtIndex(popup.selectedIndex, ListView.Contain)
                                }
                            }

                            Keys.onUpPressed: {
                                if (appListView.count > 0) {
                                    popup.selectedIndex = Math.max(popup.selectedIndex - 1, 0)
                                    appListView.positionViewAtIndex(popup.selectedIndex, ListView.Contain)
                                }
                            }

                            Keys.onEscapePressed: {
                                popup.visible = false
                            }

                            Keys.onReturnPressed: {
                                var current = appModel.values[popup.selectedIndex]
                                if (current) {
                                    popup.launchApp(current)
                                }
                            }
                        }
                    }
                }

                // 6. Footer text overlaid at bottom
                Text {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.margins: 14
                    text: "Applications (" + appModel.values.length + ")"
                    font.family: popup.theme && popup.theme.font ? popup.theme.font : "JetBrainsMono Nerd Font"
                    font.pixelSize: 13
                    font.bold: true
                    color: "#ffffff"
                }
            }

            // ── RIGHT COLUMN: 50% split (App List) ──────────────────────────────
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 460
                spacing: 10

                ListView {
                    id: appListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 8
                    clip: true

                    model: ScriptModel {
                        id: appModel
                        values: {
                            var allApps = DesktopEntries.applications.values
                            if (!allApps) return []
                            var q = popup.searchText.trim().toLowerCase()
                            if (q === "") return allApps
                            return allApps.filter(function(app) {
                                if (!app || !app.name) return false
                                var nameMatch = app.name.toLowerCase().includes(q)
                                var genericMatch = app.genericName ? app.genericName.toLowerCase().includes(q) : false
                                var commentMatch = app.comment ? app.comment.toLowerCase().includes(q) : false
                                return nameMatch || genericMatch || commentMatch
                            })
                        }
                    }

                    delegate: Item {
                        id: delegateItem
                        width: appListView.width
                        height: 52

                        required property var modelData
                        required property int index

                        property bool isSelected: index === popup.selectedIndex

                        Rectangle {
                            anchors.fill: parent
                            radius: 10
                            color: isSelected ? (popup.theme ? popup.theme.primary : "#ffb4a7") : "transparent"
                            Behavior on color { ColorAnimation { duration: 100 } }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 14
                                anchors.rightMargin: 14
                                spacing: 14

                                IconImage {
                                    Layout.preferredWidth: 32
                                    Layout.preferredHeight: 32
                                    Layout.alignment: Qt.AlignVCenter
                                    source: {
                                        var iconName = delegateItem.modelData ? delegateItem.modelData.icon : ""
                                        var resolved = iconName ? Quickshell.iconPath(iconName, true) : ""
                                        return resolved !== "" ? resolved : Quickshell.iconPath("application-x-executable", true)
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    spacing: 2

                                    Text {
                                        Layout.fillWidth: true
                                        text: delegateItem.modelData ? (delegateItem.modelData.name || "") : ""
                                        font.family: popup.theme && popup.theme.font ? popup.theme.font : "JetBrainsMono Nerd Font"
                                        font.pixelSize: 13
                                        font.bold: true
                                        color: isSelected
                                            ? (popup.theme ? popup.theme.on_primary : "#561e15")
                                            : (popup.theme ? popup.theme.on_surface : "#f1dfdb")
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        visible: text.length > 0
                                        text: {
                                            if (!delegateItem.modelData) return ""
                                            return delegateItem.modelData.genericName || delegateItem.modelData.comment || ""
                                        }
                                        font.family: popup.theme && popup.theme.font ? popup.theme.font : "JetBrainsMono Nerd Font"
                                        font.pixelSize: 11
                                        color: isSelected
                                            ? (popup.theme ? popup.theme.on_primary : "#561e15")
                                            : (popup.theme ? popup.theme.on_surface_variant : "#d8c2be")
                                        opacity: isSelected ? 0.9 : 0.7
                                        elide: Text.ElideRight
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onEntered: popup.selectedIndex = delegateItem.index
                                onClicked: popup.launchApp(delegateItem.modelData)
                            }
                        }
                    }

                    ScrollBar.vertical: ScrollBar {
                        active: true
                    }
                }
            }
        }
    }
}
