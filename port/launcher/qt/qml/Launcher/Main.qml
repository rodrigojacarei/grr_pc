import QtQuick
import QtQuick.Controls.Basic
import Launcher

Rectangle {
    id: root
    color: Theme.bg
    implicitWidth: 1180
    implicitHeight: 760
    property int current: 0
    readonly property var pages: ["play", "graphics", "controls", "fixes", "mods", "saves", "guides", "support", "updates", "advanced"]
    property bool animate: true

    Rail {
        id: rail
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 64
        current: root.current
        onPick: (i) => root.current = i
    }
    Item {
        id: stage
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: rail.bottom
        anchors.bottom: parent.bottom
        clip: true
        Repeater {
            model: root.pages.length
            Item {
                id: slot
                readonly property bool on: root.current === index
                width: stage.width; height: stage.height
                // Only the page coming in fades; the one going out disappears at once
                opacity: on ? 1 : 0
                visible: on
                y: on ? 0 : 10
                Behavior on opacity { enabled: root.animate && slot.on; NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                Behavior on y { enabled: root.animate && slot.on; NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                Loader {
                    anchors.fill: parent
                    sourceComponent: { var k = root.pages[index]
                        return k === "play" ? home : k === "graphics" ? graphics : k === "controls" ? controls
                             : k === "fixes" ? fixes : k === "mods" ? mods : k === "saves" ? saves
                             : k === "guides" ? guides
                             : k === "support" ? support : k === "updates" ? updates : k === "advanced" ? advanced : soon }
                    onLoaded: if (item.key !== undefined) item.key = root.pages[index]
                }
            }
        }
    }
    Component { id: home; HomePage { animate: root.animate; onOpenFixes: root.current = root.pages.indexOf("fixes"); onOpenSaves: root.current = root.pages.indexOf("saves"); onOpenGraphics: root.current = root.pages.indexOf("graphics") } }
    Component { id: graphics; GraphicsPage { } }
    Component { id: controls
        ControlsPage { guidesShown: root.pages.indexOf("guides") >= 0
                       onOpenGuides: root.current = root.pages.indexOf("guides") } }
    Component { id: fixes; FixesPage { } }
    Component { id: mods; ModsPage { } }
    Component { id: advanced; AdvancedPage { } }
    Component { id: saves; SavesPage { } }
    Component { id: guides; GuidesPage { } }
    Component { id: support; SupportPage { } }
    Component { id: updates; UpdatesPage { } }
    Component { id: soon; SoonPage { } }
}
