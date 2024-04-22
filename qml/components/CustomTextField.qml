import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

TextField {
    id: textField

    // Custom Properties
    property color colorDefault: "#222" // Black matte
    property color colorOnFocus: "#1d1d2b" // Yellowish gold
    property color colorMouseOver: "#1d1d2b" // White
    property color borderColor: "#33334c" // Border color
    property int borderWidth: 2 // Border width

    QtObject {
        id: internal

        property var dynamicColor: textField.focus ? colorOnFocus : (textField.hovered ? colorMouseOver : colorDefault)
    }

    implicitWidth: 300
    implicitHeight: 40
    placeholderText: qsTr("Type something")
    color: "#ffffff" // Text color
    background: Rectangle {
        color: internal.dynamicColor
        radius: 10
        border.color: borderColor
        border.width: borderWidth
    }
    
    selectByMouse: true
    selectedTextColor: "#FFFFFF" // Selected text color
    selectionColor: "#ffd700" // Selection color
    placeholderTextColor: "#ffd700" // Placeholder text color
}


/*##^##
Designer {
    D{i:0;autoSize:true;height:40;width:640}
}
##^##*/
