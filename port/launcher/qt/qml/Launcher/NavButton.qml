import QtQuick
import Launcher

Rectangle {
    id: root
    property string label: ""
    property string iconPath: ""
    property color accent: Theme.smoke
    property bool current: false
    property bool badge: false
    signal clicked()
    implicitWidth: contentRow.implicitWidth + (root.badge ? 34 : 24)
    height: 40
    radius: 8
    color: current ? Qt.rgba(root.accent.r, root.accent.g, root.accent.b, 0.14) : (mouse.containsMouse ? Theme.navHover : "transparent")
    border.width: 1
    border.color: current ? Qt.rgba(root.accent.r, root.accent.g, root.accent.b, 0.35) : "transparent"
    Behavior on color { ColorAnimation { duration: 120 } }

    Rectangle {
        visible: root.current
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
        anchors.horizontalCenter: parent.horizontalCenter
        width: Math.max(parent.width - 16, 20)
        height: 2.5
        radius: 1.5
        color: root.accent
    }

    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: 7
        Icon {
            path: root.iconPath
            color: root.current || mouse.containsMouse ? "#ffffff" : Theme.textMuted
            size: 16
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: root.label
            color: root.current || mouse.containsMouse ? "#ffffff" : Theme.textMuted
            font.family: Theme.fontText
            font.pixelSize: 13
            font.weight: root.current ? Font.Bold : Font.DemiBold
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Rectangle {
        visible: root.badge
        width: 7; height: 7; radius: 3.5; color: Theme.warn
        anchors.right: parent.right; anchors.rightMargin: 6; anchors.verticalCenter: parent.verticalCenter
    }

    MouseArea {
        id: mouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
    Accessible.role: Accessible.Button
    Accessible.name: label
}
