import QtQuick
import QtQuick.Dialogs
import Launcher

Item {
    id: page
    signal openFixes()
    signal openSaves()
    signal openGraphics()
    property real pulse: 0
    property bool animate: true
    readonly property color accent: Theme.katGold

    SequentialAnimation on pulse {
        running: page.animate && page.visible && !Backend.reducedMotion
        loops: Animation.Infinite
        NumberAnimation { from: 0; to: 1; duration: 1300; easing.type: Easing.InOutSine }
        NumberAnimation { from: 1; to: 0; duration: 1300; easing.type: Easing.InOutSine }
    }

    // ---- Full Canvas Background -----------------------------------------------------------
    Item {
        anchors.fill: parent
        clip: true
        Image { anchors.fill: parent; source: "image://hero/bg"; fillMode: Image.PreserveAspectCrop; cache: false }
        Image {
            anchors.fill: parent
            source: Backend.artSource
            visible: Backend.artSource !== ""
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            opacity: status === Image.Ready ? 0.95 : 0
            Behavior on opacity { NumberAnimation { duration: 300 } }
        }
        // Multi-stage cinematic gradient overlay
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(12/255, 14/255, 21/255, 0.40) }
                GradientStop { position: 0.35; color: Qt.rgba(12/255, 14/255, 21/255, 0.65) }
                GradientStop { position: 0.72; color: Qt.rgba(12/255, 14/255, 21/255, 0.94) }
                GradientStop { position: 1.0; color: Theme.bg }
            }
        }
    }

    // ---- Save migration hint (if present) -------------------------------------------------
    Rectangle {
        visible: Saves.homeHint !== ""
        anchors.top: parent.top; anchors.topMargin: 12
        anchors.horizontalCenter: parent.horizontalCenter
        width: Math.min(parent.width - 64, 720); height: hintCol.implicitHeight + 20
        radius: 10; color: Qt.rgba(0.05, 0.06, 0.09, 0.92); border.width: 1; border.color: Qt.rgba(Theme.ok.r, Theme.ok.g, Theme.ok.b, 0.6)
        Column {
            id: hintCol
            x: 16; y: 10; width: parent.width - 32; spacing: 4
            Text { width: parent.width; wrapMode: Text.WrapAnywhere; text: Saves.homeHint; color: Theme.text
                   font.family: Theme.fontText; font.pixelSize: 13; lineHeight: 1.3; lineHeightMode: Text.ProportionalHeight }
            Text { text: Theme.tr("saves_home_open") + " →"; color: Theme.ok; font.family: Theme.fontText; font.pixelSize: 13; font.weight: Font.Bold
                   MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: page.openSaves() } }
        }
    }

    // ---- Upper Hero Showcase (Title & Action Deck) ----------------------------------------
    Item {
        id: heroShowcase
        anchors.left: parent.left; anchors.leftMargin: 36
        anchors.right: parent.right; anchors.rightMargin: 36
        anchors.top: parent.top; anchors.topMargin: Saves.homeHint !== "" ? 70 : 20
        height: 165

        // Left: Game Branding & Kicker
        Column {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            spacing: 8

            // Floating Kicker Pill
            Rectangle {
                width: kickerRow.implicitWidth + 20; height: 26; radius: 13
                color: Qt.rgba(Theme.katGold.r, Theme.katGold.g, Theme.katGold.b, 0.14)
                border.width: 1; border.color: Qt.rgba(Theme.katGold.r, Theme.katGold.g, Theme.katGold.b, 0.45)
                Row {
                    id: kickerRow
                    anchors.centerIn: parent
                    spacing: 6
                    Text { text: "✦"; color: Theme.katGold; font.pixelSize: 10 }
                    Text {
                        text: Backend.heroKicker
                        color: Theme.katGold
                        font.family: Theme.fontDisplay; font.variableAxes: ({ "wght": 700 })
                        font.pixelSize: 11; font.weight: Font.Bold; font.capitalization: Font.AllUppercase; font.letterSpacing: 2.2
                    }
                    Text { text: "✦"; color: Theme.katGold; font.pixelSize: 10 }
                }
            }
            Text {
                text: "GRAVITY RUSH"
                color: "#ffffff"
                font.family: Theme.fontDisplay; font.variableAxes: ({ "wght": 800 })
                font.pixelSize: 46; font.weight: Font.ExtraBold
                font.capitalization: Font.AllUppercase; font.letterSpacing: 2.4
                lineHeight: 0.95; lineHeightMode: Text.ProportionalHeight
            }
            Text {
                text: Theme.tr("hero_tagline")
                color: Theme.textSoft
                font.family: Theme.fontText
                font.pixelSize: 14; font.weight: Font.Medium
            }
        }

        // Right: Glowing Play Center & Quick Buttons
        Row {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            spacing: 14

            // The Glowing Kat Play Button
            Item {
                id: playBox
                width: 280; height: 72
                anchors.verticalCenter: parent.verticalCenter
                Repeater {
                    model: 4
                    Rectangle {
                        anchors.centerIn: parent
                        width: playBtn.width + 2 * (4 + index * 6) * (0.5 + page.pulse)
                        height: playBtn.height + 2 * (4 + index * 6) * (0.5 + page.pulse)
                        radius: 16 + (4 + index * 6) * (0.5 + page.pulse)
                        color: Qt.rgba(Theme.katGold.r, Theme.katGold.g, Theme.katGold.b,
                                       (Backend.canPlay ? 0.08 : 0.0) * (1 - index * 0.22) * (0.6 + page.pulse * 0.8))
                    }
                }
                Rectangle {
                    id: playBtn
                    anchors.fill: parent
                    radius: 14
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: !Backend.canPlay ? "#272218" : (playMouse.containsMouse ? "#fde047" : Theme.katGold) }
                        GradientStop { position: 1.0; color: !Backend.canPlay ? "#1a1710" : (playMouse.containsMouse ? "#eab308" : "#d97706") }
                    }
                    border.width: 1
                    border.color: !Backend.canPlay ? "#3d3420" : "#fef08a"
                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left; anchors.leftMargin: 20
                        spacing: 12
                        Text {
                            text: "▶"
                            font.pixelSize: 22
                            color: Backend.canPlay ? "#0e0c06" : "#6e6040"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 1
                            Text {
                                text: Theme.tr("play_label")
                                font.family: Theme.fontDisplay; font.variableAxes: ({ "wght": 800 })
                                font.pixelSize: 25; font.weight: Font.ExtraBold
                                font.capitalization: Font.AllUppercase; font.letterSpacing: 1.2
                                color: Backend.canPlay ? "#0e0c06" : "#6e6040"
                            }
                            Text {
                                text: Backend.playSubtitle
                                width: 200; elide: Text.ElideRight
                                font.family: Theme.fontText; font.pixelSize: 11; font.weight: Font.Bold
                                color: Backend.canPlay ? "#2a2208" : "#6e6040"
                            }
                        }
                    }
                    MouseArea {
                        id: playMouse; anchors.fill: parent; hoverEnabled: true
                        enabled: Backend.canPlay; cursorShape: Qt.PointingHandCursor; onClicked: Backend.play()
                    }
                    Accessible.role: Accessible.Button
                    Accessible.name: Theme.tr("play_label")
                }
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8
                GhostButton {
                    width: 170; compact: true
                    text: Theme.tr("choose_folder")
                    onClicked: { if (!Backend.selectGameDir()) folderDialog.open() }
                }
                GhostButton {
                    width: 170; compact: true
                    text: "♥  " + Theme.tr("sponsor_label")
                    onClicked: Backend.openUrl("sponsor")
                }
            }
        }
    }

    // ---- Floating Glassmorphism Quick Settings Dock ---------------------------------------
    Rectangle {
        id: quickDock
        anchors.left: parent.left; anchors.leftMargin: 36
        anchors.right: parent.right; anchors.rightMargin: 36
        anchors.top: heroShowcase.bottom; anchors.topMargin: 20
        height: dockCol.implicitHeight + 22
        radius: 14
        color: Qt.rgba(18/255, 22/255, 34/255, 0.85)
        border.width: 1
        border.color: Qt.rgba(246/255, 201/255, 68/255, 0.28)

        Column {
            id: dockCol
            x: 20; y: 11; width: parent.width - 40; spacing: 8
            Item {
                width: parent.width; height: 22
                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: "⚡  " + Theme.tr("quick_settings_title")
                    color: Theme.katGold
                    font.family: Theme.fontDisplay; font.variableAxes: ({ "wght": 700 })
                    font.pixelSize: 14; font.weight: Font.Bold
                    font.capitalization: Font.AllUppercase; font.letterSpacing: 1.0
                }
                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: Theme.tr("nav_graphics") + "  →"
                    color: Theme.video
                    font.family: Theme.fontText; font.pixelSize: 12; font.weight: Font.Bold
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: page.openGraphics() }
                }
            }
            Row {
                width: parent.width; spacing: 16
                Column {
                    width: (parent.width - 32) / 3; spacing: 4
                    Text { text: "🖥️  " + Theme.tr("quick_mode"); color: Theme.textMuted; font.family: Theme.fontText; font.pixelSize: 11; font.weight: Font.DemiBold }
                    Select {
                        width: parent.width; accent: Theme.katGold
                        model: Backend.displayModeOptions
                        currentIndex: Backend.displayModeIndex
                        onActivated: (i) => Backend.setDisplayMode(Backend.displayModeOptions[i].value)
                    }
                }
                Column {
                    width: (parent.width - 32) / 3; spacing: 4
                    Text { text: "📐  " + Theme.tr("quick_resolution"); color: Theme.textMuted; font.family: Theme.fontText; font.pixelSize: 11; font.weight: Font.DemiBold }
                    Select {
                        width: parent.width; accent: Theme.katGold
                        model: Backend.resolutionOptions
                        currentIndex: Backend.resolutionIndex
                        onActivated: (i) => Backend.setResolution(Backend.resolutionOptions[i].value)
                    }
                }
                Column {
                    width: (parent.width - 32) / 3; spacing: 4
                    Text { text: "⚡  " + Theme.tr("quick_upscaler"); color: Theme.textMuted; font.family: Theme.fontText; font.pixelSize: 11; font.weight: Font.DemiBold }
                    Select {
                        width: parent.width; accent: Theme.katGold
                        model: Backend.upscalerOptions
                        currentIndex: Backend.upscalerIndex
                        onActivated: (i) => Backend.setUpscaler(Backend.upscalerOptions[i].value)
                    }
                }
            }
        }
    }

    // ---- Lower Cards: System Status & Hekseville Highlights -------------------------------
    Row {
        id: lowerDeck
        anchors.left: parent.left; anchors.leftMargin: 36
        anchors.right: parent.right; anchors.rightMargin: 36
        anchors.top: quickDock.bottom; anchors.topMargin: 16
        anchors.bottom: parent.bottom; anchors.bottomMargin: 16
        spacing: 18

        // Card 1: System Hardware & Status Chips
        Rectangle {
            width: (parent.width - 18) * 0.58; height: parent.height
            radius: 14; color: Theme.card; border.width: 1; border.color: Theme.cardLine
            clip: true
            Column {
                anchors.fill: parent; anchors.margins: 18; spacing: 12
                Row {
                    spacing: 8
                    Rectangle { width: 8; height: 8; radius: 4; color: Backend.ready ? Theme.ok : Theme.warn; anchors.verticalCenter: parent.verticalCenter }
                    Text {
                        text: Backend.statusTitle
                        color: "#ffffff"; font.family: Theme.fontDisplay; font.variableAxes: ({ "wght": 700 })
                        font.pixelSize: 16; font.weight: Font.Bold; font.capitalization: Font.AllUppercase; font.letterSpacing: 0.8
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Flow {
                    width: parent.width; spacing: 8
                    Repeater { model: Backend.chips; Chip { text: modelData.text; level: modelData.level } }
                }
                Rectangle {
                    width: parent.width; height: 48; radius: 8
                    color: Qt.rgba(255, 255, 255, 0.03); border.width: 1; border.color: Theme.chipLine
                    Row {
                        anchors.fill: parent; anchors.leftMargin: 14; anchors.rightMargin: 14
                        anchors.topMargin: 8; anchors.bottomMargin: 8
                        spacing: 24
                        Column {
                            spacing: 2
                            Text { text: "MOTOR GRÁFICO"; color: Theme.textDim; font.family: Theme.fontText; font.pixelSize: 10; font.weight: Font.Bold; font.letterSpacing: 1.0 }
                            Text { text: "Vulkan 1.3 · Shaders Assíncronos"; color: Theme.text; font.family: Theme.fontText; font.pixelSize: 12; font.weight: Font.DemiBold }
                        }
                        Rectangle { width: 1; height: parent.height - 4; color: Theme.chipLine; anchors.verticalCenter: parent.verticalCenter }
                        Column {
                            spacing: 2
                            Text { text: "SISTEMA DE ÁUDIO"; color: Theme.textDim; font.family: Theme.fontText; font.pixelSize: 10; font.weight: Font.Bold; font.letterSpacing: 1.0 }
                            Text { text: "libSceNgs2 Nativo PS4 (60 FPS)"; color: Theme.text; font.family: Theme.fontText; font.pixelSize: 12; font.weight: Font.DemiBold }
                        }
                    }
                }
                Item {
                    visible: Backend.showFirstRun || Backend.notice !== ""
                    width: parent.width; height: Math.max(warnText.implicitHeight, 20)
                    Rectangle { width: 3; height: parent.height; color: Theme.warn }
                    Text { id: warnText; x: 12; width: parent.width - 12; wrapMode: Text.WordWrap
                           text: Backend.notice !== "" ? Backend.notice : Theme.tr("first_run_warning")
                           color: Theme.textDim; font.family: Theme.fontText; font.pixelSize: 12; lineHeight: 1.3 }
                }
                // Game Language Row
                Row {
                    spacing: 10
                    Text { text: Theme.tr("game_language_label"); color: Theme.textMuted; font.family: Theme.fontText; font.pixelSize: 12; font.weight: Font.Bold
                           anchors.verticalCenter: parent.verticalCenter }
                    Select {
                        accent: Theme.katGold; width: 170
                        model: Backend.gameLanguageOptions
                        currentIndex: Backend.gameLanguageIndex
                        onActivated: (i) => Backend.setGameLanguage(Backend.gameLanguageOptions[i].value)
                    }
                    Text { visible: Backend.gameLanguageNow !== ""; text: Backend.gameLanguageNow; color: Theme.katGold
                           font.family: Theme.fontText; font.pixelSize: 12; font.weight: Font.Bold; anchors.verticalCenter: parent.verticalCenter }
                }
            }
        }

        // Card 2: Hekseville Highlights & News
        Rectangle {
            width: (parent.width - 18) * 0.42; height: parent.height
            radius: 14; color: Theme.card; border.width: 1; border.color: Theme.cardLine
            clip: true
            Column {
                anchors.fill: parent; anchors.margins: 18; spacing: 10
                Text {
                    text: Theme.tr("news_title") + (Backend.version ? " · " + Backend.version : "")
                    color: "#ffffff"; font.family: Theme.fontDisplay; font.variableAxes: ({ "wght": 700 })
                    font.pixelSize: 16; font.weight: Font.Bold; font.capitalization: Font.AllUppercase; font.letterSpacing: 0.8
                }
                Column {
                    width: parent.width; spacing: 6
                    Repeater {
                        model: Backend.newsLines
                        Row {
                            width: parent.width; spacing: 8
                            Text { text: "✦"; color: Theme.katGold; font.pixelSize: 11 }
                            Text { width: parent.width - 20; text: modelData; color: Theme.textSoft; wrapMode: Text.WordWrap
                                   font.family: Theme.fontText; font.pixelSize: 13; lineHeight: 1.25 }
                        }
                    }
                }
            }
            Text {
                anchors.left: parent.left; anchors.leftMargin: 18; anchors.bottom: parent.bottom; anchors.bottomMargin: 14
                text: Theme.tr("news_link") + " →"; color: Theme.katGold; font.family: Theme.fontText
                font.pixelSize: 13; font.weight: Font.Bold
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: page.openFixes() }
            }
        }
    }

    FolderDialog {
        id: folderDialog
        title: Theme.tr("choose_folder_title")
        currentFolder: Backend.gameDir ? "file://" + Backend.gameDir : ""
        onAccepted: Backend.chooseFolder(selectedFolder.toString())
    }

    // ---- Game log (only while game runs or after crash/error) ------------------------------
    Rectangle {
        visible: Backend.playState !== "idle" || (Backend.logText !== "" && Backend.logShown)
        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
        height: 140; color: "#080a10"; border.width: 1; border.color: Theme.cardLine
        Flickable {
            id: flick
            anchors.fill: parent; anchors.margins: 10; clip: true
            contentHeight: logText.implicitHeight
            onContentHeightChanged: contentY = Math.max(0, contentHeight - height)
            Text { id: logText; width: flick.width; text: Backend.logText; color: Theme.textDim
                   font.family: "monospace"; font.pixelSize: 11; wrapMode: Text.WrapAnywhere }
        }
    }
}
