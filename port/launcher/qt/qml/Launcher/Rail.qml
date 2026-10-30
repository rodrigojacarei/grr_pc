import QtQuick
import Launcher

Rectangle {
    id: root
    property int current: 0
    signal pick(int index)
    color: Theme.rail
    height: 64
    Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.railLine }

    readonly property var entries: [
        { key: "play", label: "nav_play" },
        { key: "graphics", label: "nav_graphics" },
        { key: "controls", label: "nav_controls" },
        { key: "fixes", label: "nav_fixes" },
        { key: "mods", label: "nav_mods" },
        { key: "saves", label: "nav_saves" },
        { key: "guides", label: "nav_guides" },
        { key: "support", label: "nav_support" },
        { key: "updates", label: "nav_updates" },
        { key: "advanced", label: "nav_advanced" }
    ]

    // Left brand: Glowing Gravity Gem + Title
    Row {
        id: brand
        anchors.left: parent.left; anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        spacing: 12

        Rectangle {
            width: 32; height: 32; radius: 8
            rotation: 45
            color: Qt.rgba(Theme.katGold.r, Theme.katGold.g, Theme.katGold.b, 0.15)
            border.width: 1.5; border.color: Theme.katGold
            anchors.verticalCenter: parent.verticalCenter
            Rectangle {
                anchors.centerIn: parent
                width: 12; height: 12; radius: 3
                color: Theme.katGold
            }
        }
        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 1
            Text {
                text: "GRAVITY RUSH"
                color: "#ffffff"
                font.family: Theme.fontDisplay; font.variableAxes: ({ "wght": 800 })
                font.pixelSize: 17; font.weight: Font.ExtraBold; font.letterSpacing: 1.2
            }
            Text {
                text: "REMASTERED PC"
                color: Theme.katGold
                font.family: Theme.fontDisplay; font.variableAxes: ({ "wght": 700 })
                font.pixelSize: 10; font.weight: Font.Bold; font.letterSpacing: 2.4
            }
        }
    }

    // Center Navigation Tabs: horizontal flickable so it handles any window width gracefully
    Flickable {
        id: navFlick
        anchors.left: brand.right; anchors.leftMargin: 20
        anchors.right: rightDeck.left; anchors.rightMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        height: 42
        contentWidth: navRow.implicitWidth
        contentHeight: height
        clip: true; boundsBehavior: Flickable.StopAtBounds
        Row {
            id: navRow
            spacing: 4
            anchors.verticalCenter: parent.verticalCenter
            Repeater {
                id: navRepeater
                model: root.entries
                NavButton {
                    label: Theme.tr(modelData.label)
                    iconPath: Theme.icons[modelData.key]
                    accent: Theme.accents[modelData.key]
                    current: root.current === index
                    badge: modelData.key === "updates" && Updates.available
                    onClicked: root.pick(index)
                }
            }
        }
    }

    // Right Deck: Language Switcher Capsule
    Row {
        id: rightDeck
        anchors.right: parent.right; anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10
        Rectangle {
            width: 124; height: 32; radius: 16
            color: Theme.chip; border.width: 1; border.color: Theme.chipLine
            anchors.verticalCenter: parent.verticalCenter
            Row {
                anchors.fill: parent; anchors.margins: 2
                Repeater {
                    model: [ { code: "pt_BR", label: "PT-BR" }, { code: "en_US", label: "EN-US" } ]
                    Rectangle {
                        readonly property bool on: Backend.lang === modelData.code
                        width: (parent.width) / 2; height: parent.height; radius: 14
                        color: on ? Theme.navOn : "transparent"
                        border.width: on ? 1 : 0; border.color: on ? Theme.katGold : "transparent"
                        Text {
                            anchors.centerIn: parent
                            text: modelData.label
                            color: parent.on ? Theme.katGold : Theme.textMuted
                            font.family: Theme.fontText; font.pixelSize: 11; font.weight: Font.Bold
                        }
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            onClicked: Backend.setLang(modelData.code)
                        }
                    }
                }
            }
        }
    }
}
