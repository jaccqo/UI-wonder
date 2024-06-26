import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Button {
    id: button

    // Custom Properties
    property color colorDefault: "#333"
    property color colorMouseOver: "#161717"
    property color colorPressed: "#ffd700"
    property url setIcon: "../../images/images/logo_rts.png"
    implicitWidth: 120
    implicitHeight: 95


    QtObject{
        id: internal

        property var dynamicColor: if(button.down){
                                       button.down ? colorPressed : colorDefault
                                   }else{
                                       button.hovered ? colorMouseOver : colorDefault
                                   }
    }

    text: qsTr("Button")
    font.family: "Segoe UI"
    contentItem: Item{
        id: itemBtn
        Text {
            id: name
            text: button.text
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            verticalAlignment: Text.AlignBottom
            anchors.leftMargin: 2
            anchors.bottomMargin: 5
            font: button.font
            color: "#ffffff"
        }
        Image {
            id: icon
            anchors.left: parent.left
            anchors.top: parent.top
            source: setIcon
            anchors.leftMargin: 2
            anchors.topMargin: 2
            sourceSize.height: 25
            sourceSize.width: 25
            fillMode: Image.PreserveAspectFit
            antialiasing: false
        }
    }

    background: Rectangle{
        color: internal.dynamicColor
        radius: 10
    }
}
/*##^##
Designer {
    D{i:0;height:95;width:120}
}
##^##*/
