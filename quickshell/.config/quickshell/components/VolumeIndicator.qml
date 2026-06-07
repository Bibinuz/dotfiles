pragma ComponentBehavior: Bound

import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: root
    property var theme

    implicitWidth: volumeRow.implicitWidth + 16
    implicitHeight: 28

    Rectangle {
        id: volumeBg
        anchors.fill: parent
        radius: 8
        color: root.theme.secondary
        opacity: volumeHover.containsMouse ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 120 } }
    }

    RowLayout {
        id: volumeRow
        anchors.centerIn: parent
        spacing: 5

        Text {
        font.family: root.theme && root.theme.font ? root.theme.font : "monospace"
            text: {
                if (!Pipewire.defaultAudioSink || !Pipewire.defaultAudioSink.audio) return "󰝟"
                if (Pipewire.defaultAudioSink.audio.muted) return "󰖁"
                var v = Pipewire.defaultAudioSink.audio.volume
                if (v > 0.66) return "󰕾"
                if (v > 0.33) return "󰖀"
                return "󰕿"
            }
            color: volumeHover.containsMouse ? root.theme.on_secondary : (
                (Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio && Pipewire.defaultAudioSink.audio.muted)
                ? root.theme.outline : root.theme.primary
            )
            font.pixelSize: 15
            Behavior on color { ColorAnimation { duration: 150 } }
        }

        Text {
        font.family: root.theme && root.theme.font ? root.theme.font : "monospace"
            text: Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio
                ? Math.round(Pipewire.defaultAudioSink.audio.volume * 100) + "%"
                : "0%"
            color: volumeHover.containsMouse ? root.theme.on_secondary : root.theme.on_surface
            font.pixelSize: 12
            font.weight: Font.Medium
            Behavior on color { ColorAnimation { duration: 150 } }
        }
    }

    MouseArea {
        id: volumeHover
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onWheel: (wheel) => {
            if (!Pipewire.defaultAudioSink || !Pipewire.defaultAudioSink.audio) return
            var delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05
            var newVol = Math.max(0, Math.min(1.5, Pipewire.defaultAudioSink.audio.volume + delta))
            Pipewire.defaultAudioSink.audio.volume = newVol
        }
        onClicked: {
            if (Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio)
                Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
        }
    }

    Process {
        id: volumeProcess
        command: ["pavucontrol"]
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            volumeProcess.running = true
        }
    }
}
