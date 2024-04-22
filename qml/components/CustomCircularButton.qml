import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Button{
    id: btnTopBar
    // CUSTOM PROPERTIES
    property url btnIconSource: "../../images/svg_images/settings_icon.svg"
    property color matteBlack: "#222"
    property color yellowishGold: "#ffd700"

    // Define properties for button colors
    property color btnColorDefault: matteBlack
    property color btnColorMouseOver: yellowishGold
    property color btnColorClicked: yellowishGold

    property int btnRadius: 25

    QtObject{
        id: internal

        // MOUSE OVER AND CLICK CHANGE COLOR
        property var dynamicColor: if(btnTopBar.down){
                                       btnTopBar.down ? btnColorClicked : btnColorDefault
                                   } else {
                                       btnTopBar.hovered ? btnColorMouseOver : btnColorDefault
                                   }

    }

    width: 50
    height: 50

    background: Rectangle{
        id: bgBtn
        color: internal.dynamicColor
        radius: btnRadius
        anchors.fill: parent
        anchors.margins: 3

        Image {
            id: iconBtn
            source: btnIconSource
            sourceSize.height: 22
            sourceSize.width: 22
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            visible: false
            fillMode: Image.PreserveAspectFit
            antialiasing: true
        }

        ColorOverlay{
            anchors.fill: iconBtn
            source: iconBtn
            color: "#ffffff"
            antialiasing: true
        }
   
    }
}



/*##^##
Designer {
    D{i:0;height:50;width:50}
}
##^##*/
