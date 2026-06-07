pragma ComponentBehavior: Bound

import Quickshell.Io
import QtQuick

Item {
    id: root
    property var theme

    implicitHeight: 40

    Row {
        anchors.centerIn: parent
        spacing: 6

        Text {
        font.family: root.theme && root.theme.font ? root.theme.font : "monospace"
            id: clockTime
            anchors.verticalCenter: parent.verticalCenter
            color: root.theme.on_surface
            font.bold: true
            font.pixelSize: 15
            text: "00:00"
        }

        Rectangle {
            width: 1
            height: 14
            color: root.theme.outline_variant
            opacity: 0.7
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
        font.family: root.theme && root.theme.font ? root.theme.font : "monospace"
            id: clockDate
            anchors.verticalCenter: parent.verticalCenter
            color: root.theme.on_surface_variant
            font.pixelSize: 12
            text: "Mon 01 Jan"
        }
    }

    Process {
        id: timeProc
        command: ["date", "+%H:%M"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: clockTime.text = this.text.trim()
        }
    }

    Process {
        id: dateProc
        command: ["date", "+%a %d %b"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: clockDate.text = this.text.trim()
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: {
            timeProc.running = true
            dateProc.running = true
        }
    }
}
