import QtQuick
import QtQuick.Controls.Basic
import Launcher
import QtQuick.Dialogs

Item {
    id: page
    readonly property color accent: Theme.video
    readonly property int side: 36

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: width; contentHeight: body.implicitHeight + 60
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        Connections { target: Graphics; function onScrollRequested(y) { flick.contentY = Math.max(0, Math.min(y, flick.contentHeight - flick.height)) } }
        ScrollBar.vertical: ScrollBar {
            id: bar
            contentItem: Rectangle { implicitWidth: 6; radius: 3; color: bar.pressed ? Theme.ghostLineHover : Theme.ghostLine }
            background: Item { }
        }

        Column {
            id: body
            x: page.side; y: 26; width: flick.width - 2 * page.side; spacing: 14

            Text { text: Theme.tr("gfx_title"); color: "#fff"; font.family: Theme.fontDisplay; font.variableAxes: ({ "wght": 800 }); font.pixelSize: 42
                   font.weight: Font.ExtraBold; font.capitalization: Font.AllUppercase; font.letterSpacing: 2.1 }
            Text { width: parent.width; text: Theme.tr("gfx_intro"); wrapMode: Text.WordWrap; color: Theme.textDim
                   font.family: Theme.fontText; font.pixelSize: 13; lineHeight: 1.35; lineHeightMode: Text.ProportionalHeight }

            // ---- presets ----------------------------------------------------------------------
            Rectangle {
                id: presetCard
                width: parent.width
                radius: 14
                color: Theme.card
                border.width: 1
                border.color: Graphics.presets.some(function (p) { return p.active }) ? Qt.rgba(page.accent.r, page.accent.g, page.accent.b, 0.40) : Theme.cardLine
                height: presetCol.implicitHeight + 36

                readonly property var activePreset: {
                    for (var i = 0; i < Graphics.presets.length; ++i) {
                        if (Graphics.presets[i].active) return Graphics.presets[i];
                    }
                    return null;
                }

                Column {
                    id: presetCol
                    x: 20; y: 18
                    width: parent.width - 40
                    spacing: 12

                    Row {
                        width: parent.width
                        spacing: 16

                        Column {
                            width: parent.width - 250 - parent.spacing
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 6

                            Row {
                                spacing: 10
                                SectionTitle { text: Theme.tr("gfx_presets_title"); accent: page.accent }
                                Rectangle {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: activeBadgeText.implicitWidth + 20; height: 26; radius: 13
                                    color: Theme.chip
                                    border.width: 1
                                    border.color: presetCard.activePreset ? page.accent : Theme.warn
                                    Text {
                                        id: activeBadgeText
                                        anchors.centerIn: parent
                                        text: presetCard.activePreset ? presetCard.activePreset.label : Theme.tr("gfx_preset_custom_badge")
                                        color: Theme.textChip
                                        font.family: Theme.fontText; font.pixelSize: 12; font.weight: Font.Bold
                                    }
                                }
                            }

                            Text {
                                width: parent.width
                                text: presetCard.activePreset ? presetCard.activePreset.what : Theme.tr("gfx_preset_custom_desc")
                                wrapMode: Text.WordWrap
                                color: Theme.textDim
                                font.family: Theme.fontText; font.pixelSize: 13
                                lineHeight: 1.35; lineHeightMode: Text.ProportionalHeight
                            }
                        }

                        Select {
                            id: presetCombo
                            width: 250
                            anchors.verticalCenter: parent.verticalCenter
                            accent: page.accent
                            model: Graphics.presets
                            textRole: "label"
                            currentIndex: {
                                for (var i = 0; i < Graphics.presets.length; ++i) {
                                    if (Graphics.presets[i].active) return i;
                                }
                                return -1;
                            }
                            displayText: presetCard.activePreset ? presetCard.activePreset.label : Theme.tr("gfx_preset_custom_short")
                            onActivated: (index) => {
                                if (index >= 0 && index < Graphics.presets.length) {
                                    Graphics.applyPreset(Graphics.presets[index].id);
                                }
                            }
                        }
                    }

                    Row {
                        spacing: 10
                        GhostButton { compact: true; text: Theme.tr("ps_export"); onClicked: { nameField.text = Graphics.exportName; whatField.text = ""; exportCard.visible = true } }
                        GhostButton { compact: true; text: Theme.tr("ps_import"); onClicked: openJson.open() }
                    }
                }
            }
            NoteBar { text: Theme.tr("gfx_preset_note"); bar: page.accent }
            NoteBar { visible: Graphics.shareMessage !== ""; text: Graphics.shareMessage
                      bar: Graphics.shareTone === "good" ? Theme.ok : Theme.bad; textColor: Theme.textSoft }

            // ---- the options ------------------------------------------------------------------
            Column {
                width: parent.width; spacing: 2
                Repeater {
                    model: Graphics.rows
                    OptionRow {
                        d: model.d; accent: page.accent
                        onValueSet: (id, value) => Graphics.setValue(id, value)
                        onActionTriggered: (id, action) => Graphics.runAction(id, action)
                    }
                }
            }

            // ---- shader cache ------------------------------------------------------------------
            SectionTitle { text: Theme.tr("gfx_sec_cache"); accent: page.accent }
            Rectangle {
                width: parent.width; height: cacheCol.implicitHeight + 36
                radius: 14; color: Theme.card; border.width: 1; border.color: Theme.cardLine
                Column {
                    id: cacheCol
                    x: 18; y: 18; width: parent.width - 36; spacing: 10
                    Text { text: Graphics.cacheText; color: "#fff"; font.family: Theme.fontText; font.pixelSize: 17; font.weight: Font.DemiBold }
                    Text { width: parent.width; text: Theme.tr("gfx_cache_hint"); wrapMode: Text.WordWrap; color: Theme.textDim
                           font.family: Theme.fontText; font.pixelSize: 13; lineHeight: 1.35; lineHeightMode: Text.ProportionalHeight }
                    NoteBar { visible: Graphics.gameRunning; text: Theme.tr("gfx_cache_running"); bar: Theme.bad }
                    NoteBar { visible: Graphics.message !== ""; text: Graphics.message
                              bar: Graphics.messageTone === "good" ? Theme.ok : Theme.bad; textColor: Theme.textSoft }
                    Text { visible: Graphics.confirming; width: parent.width; text: Graphics.confirmText; wrapMode: Text.WordWrap; color: Theme.textSoft
                           font.family: Theme.fontText; font.pixelSize: 14; lineHeight: 1.35; lineHeightMode: Text.ProportionalHeight }
                    Row {
                        spacing: 10
                        GhostButton { visible: !Graphics.confirming; compact: true; text: Theme.tr("clear_cache"); enabled: Graphics.canClear
                                      onClicked: Graphics.askClear() }
                        GhostButton { visible: Graphics.confirming; compact: true; tone: "danger"; text: Theme.tr("gfx_cache_yes"); onClicked: Graphics.clearCache() }
                        GhostButton { visible: Graphics.confirming; compact: true; text: Theme.tr("gfx_cache_no"); onClicked: Graphics.cancelClear() }
                    }
                }
            }
        }
    }

    ConfirmCard { anchors.fill: parent; target: Graphics }

    // ---- export: name and description, then the file dialog ----------------------------------------------
    Rectangle {
        id: exportCard
        anchors.fill: parent; visible: false
        color: Qt.rgba(0, 0, 0, 0.62)
        MouseArea { anchors.fill: parent }
        Rectangle {
            anchors.centerIn: parent
            width: Math.min(600, parent.width - 72); height: exportCol.implicitHeight + 48
            radius: 14; color: Theme.card; border.width: 1; border.color: Theme.ghostLineHover
            Column {
                id: exportCol
                x: 24; y: 24; width: parent.width - 48; spacing: 12
                Text { width: parent.width; text: Theme.tr("ps_export_title"); color: "#fff"; wrapMode: Text.WordWrap
                       font.family: Theme.fontDisplay; font.variableAxes: ({ "wght": 800 }); font.pixelSize: 28; font.weight: Font.ExtraBold
                       font.capitalization: Font.AllUppercase; font.letterSpacing: 1.4 }
                Text { width: parent.width; text: Theme.tr("ps_export_hint"); color: Theme.textSoft; wrapMode: Text.WordWrap
                       font.family: Theme.fontText; font.pixelSize: 14; lineHeight: 1.35; lineHeightMode: Text.ProportionalHeight }
                Text { text: Theme.tr("ps_name"); color: Theme.textDim; font.family: Theme.fontText; font.pixelSize: 13 }
                TextField {
                    id: nameField
                    width: parent.width; color: "#fff"; selectByMouse: true; maximumLength: 80
                    selectionColor: page.accent; selectedTextColor: "#00131a"
                    font.family: Theme.fontText; font.pixelSize: 14; leftPadding: 12; rightPadding: 12; topPadding: 9; bottomPadding: 9
                    background: Rectangle { radius: 8; color: Theme.chip; border.width: 1; border.color: nameField.activeFocus ? page.accent : Theme.ghostLine }
                }
                Text { text: Theme.tr("ps_what"); color: Theme.textDim; font.family: Theme.fontText; font.pixelSize: 13 }
                TextField {
                    id: whatField
                    width: parent.width; color: "#fff"; selectByMouse: true; maximumLength: 300
                    selectionColor: page.accent; selectedTextColor: "#00131a"
                    font.family: Theme.fontText; font.pixelSize: 14; leftPadding: 12; rightPadding: 12; topPadding: 9; bottomPadding: 9
                    background: Rectangle { radius: 8; color: Theme.chip; border.width: 1; border.color: whatField.activeFocus ? page.accent : Theme.ghostLine }
                }
                Flow {
                    width: parent.width; spacing: 10; topPadding: 6
                    GhostButton { tone: "primary"; text: Theme.tr("ps_choose_file")
                                  onClicked: { exportCard.visible = false; saveJson.currentFile = saveJson.currentFolder + "/" + Graphics.exportFile; saveJson.open() } }
                    GhostButton { text: Theme.tr("ps_cancel"); onClicked: exportCard.visible = false }
                }
            }
        }
    }
    FileDialog {
        id: openJson
        title: Theme.tr("ps_open_title")
        nameFilters: [Theme.tr("ps_filter"), "*"]
        onAccepted: Graphics.importPreset(selectedFile.toString())
    }
    FileDialog {
        id: saveJson
        title: Theme.tr("ps_save_title")
        fileMode: FileDialog.SaveFile
        defaultSuffix: "json"
        nameFilters: [Theme.tr("ps_filter")]
        onAccepted: Graphics.exportPreset(nameField.text, whatField.text, selectedFile.toString())
    }
}
