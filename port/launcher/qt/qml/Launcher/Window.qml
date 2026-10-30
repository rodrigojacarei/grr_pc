import QtQuick
import QtQuick.Window
import Launcher

Window {
    id: win
    property alias current: main.current
    property alias animate: main.animate
    width: 1180
    height: 760
    minimumWidth: 1000
    minimumHeight: 650
    visible: true
    color: Theme.bg
    title: "Gravity Rush Remastered — PC"
    Main { id: main; anchors.fill: parent }
}
