import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import "../components"
import QtQuick.Timeline 1.0

Item {

    property bool showValue: true

    Flickable {
        id: flickable
        opacity: 0
        anchors.fill: parent
        contentHeight: gridLayout.height
        clip: true

        GridLayout {
            id: gridLayout
            columns: 1
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            columnSpacing: 10
            rows: 3

            
           
            Rectangle{
                id: rectangle1
         
                height: 220
                width: flickable.width
                radius: 10

                color: "#1c1c1b"
                border.color: "#333" // Slightly lighter border color
                border.width: 1

                Rectangle {
                    id: whiteCard_3
                    width: 340
                    color: "#ffffff"
                    radius: 10
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    Image {
                        id: iconCart2
                        width: 30
                        height: 30
                        visible: false
                        anchors.left: parent.left
                        anchors.top: parent.top
                        source: "../../images/svg_images/moeda_icon.svg"
                        fillMode: Image.PreserveAspectFit
                        sourceSize.height: 30
                        sourceSize.width: 30
                        anchors.leftMargin: 15
                        anchors.topMargin: 15
                        antialiasing: false
                    }

                    ColorOverlay {
                        color: "#33334c"
                        anchors.fill: iconCart2
                        source: iconCart2
                        antialiasing: false
                    }

                    Label {
                        id: labelTitleBar8
                        x: 58
                        y: 20
                        color: "#33334c"
                        text: qsTr("Rewards")
                        font.bold: true
                        font.family: "Segoe UI"
                        font.pointSize: 11
                    }

                    Label {
                        id: labelTitleBar9
                        x: 15
                        y: 129
                        width: 190
                        height: 17
                        color: "#767676"
                        text: qsTr("My points")
                        font.family: "Segoe UI"
                        font.pointSize: 10
                    }

                    Label {
                        id: textValue_6
                        x: 15
                        y: 169
                        color: "#767676"
                        text: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\np, li { white-space: pre-wrap; }\n</style></head><body style=\" font-family:'MS Shell Dlg 2'; font-size:8.25pt; font-weight:400; font-style:normal;\">\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Points: <span style=\" font-weight:600; color:#55aa00;\">55.530</span></p></body></html>"
                        font.family: "Segoe UI"
                        textFormat: Text.RichText
                        font.pointSize: 10
                        visible: showValue
                    }

                    CustomButton {
                        x: 227
                        y: 153
                        width: 108
                        height: 30
                        text: "ACCESS"
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        colorMouseOver: "#40405f"
                        colorDefault: "#33334c"
                        anchors.bottomMargin: 17
                        anchors.rightMargin: 15
                        colorPressed: "#55aaff"
                    }

                    Label {
                        id: labelTitleBar10
                        x: 15
                        y: 146
                        width: 190
                        height: 17
                        color: "#767676"
                        text: qsTr("Rewards")
                        font.family: "Segoe UI"
                        font.pointSize: 10
                    }
                    anchors.bottomMargin: 10
                    anchors.topMargin: 10
                    anchors.leftMargin: 10
                }

                Label {
                    id: labelTitleBar12
                    y: 60
                    color: "#ffffff"
                    text: qsTr("$ 1,00 = 1 Point")
                    anchors.left: whiteCard_3.right
                    font.bold: true
                    anchors.leftMargin: 37
                    font.family: "Segoe UI"
                    font.pointSize: 11
                }

                Label {
                    id: labelTitleBar13
                    x: 387
                    y: 86
                    color: "#ffffff"
                    text: qsTr("Buy and receive points")
                    anchors.left: whiteCard_3.right
                    font.bold: true
                    font.family: "Segoe UI"
                    font.pointSize: 11
                    anchors.leftMargin: 37
                }

                Label {
                    id: labelTitleBar14
                    x: 387
                    y: 105
                    color: "#ffffff"
                    text: qsTr("Some text here")
                    anchors.left: whiteCard_3.right
                    font.family: "Segoe UI"
                    font.pointSize: 10
                    anchors.leftMargin: 37
                }

                Label {
                    id: labelTitleBar15
                    x: 387
                    y: 124
                    color: "#ffffff"
                    text: qsTr("Another text")
                    anchors.left: whiteCard_3.right
                    font.family: "Segoe UI"
                    font.pointSize: 10
                    anchors.leftMargin: 37
                }

                Label {
                    id: labelTitleBar16
                    x: 387
                    y: 147
                    color: "#da7dff"
                    text: qsTr("Access now")
                    anchors.left: whiteCard_3.right
                    font.underline: true
                    font.family: "Segoe UI"
                    font.pointSize: 10
                    anchors.leftMargin: 37
                }
            }
        }
        ScrollBar.vertical: ScrollBar {
            id: control
            size: 0.3
            position: 0.2
            orientation: Qt.Vertical
            visible: flickable.moving || flickable.moving

            contentItem: Rectangle {
                implicitWidth: 6
                implicitHeight: 100
                radius: width / 2
                color: control.pressed ? "#222" : "#ffd700"
            }
        }
    }

    Timeline {
        id: timeline
        animations: [
            TimelineAnimation {
                id: timelineAnimation
                running: true
                loops: 1
                duration: 1000
                to: 1000
                from: 0
            }
        ]
        endFrame: 1000
        enabled: true
        startFrame: 0

        KeyframeGroup {
            target: flickable
            property: "opacity"
            Keyframe {
                frame: 550
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        // KeyframeGroup {
        //     target: greenBar
        //     property: "anchors.leftMargin"
        //     Keyframe {
        //         easing.bezierCurve: [0.254,0.00129,0.235,0.999,1,1]
        //         value: 40
        //         frame: 850
        //     }

        //     Keyframe {
        //         value: 400
        //         frame: 399
        //     }

        //     Keyframe {
        //         value: 400
        //         frame: 0
        //     }
        // }

        // KeyframeGroup {
        //     target: greenBar
        //     property: "opacity"
        //     Keyframe {
        //         value: 1
        //         frame: 650
        //     }

        //     Keyframe {
        //         value: 0
        //         frame: 399
        //     }

        //     Keyframe {
        //         value: 0
        //         frame: 0
        //     }
        // }

        // KeyframeGroup {
        //     target: greenBar1
        //     property: "anchors.leftMargin"
        //     Keyframe {
        //         easing.bezierCurve: [0.254,0.00129,0.235,0.999,1,1]
        //         value: 40
        //         frame: 998
        //     }

        //     Keyframe {
        //         value: 400
        //         frame: 548
        //     }

        //     Keyframe {
        //         value: 400
        //         frame: 0
        //     }
        // }

        // KeyframeGroup {
        //     target: greenBar1
        //     property: "opacity"
        //     Keyframe {
        //         value: 1
        //         frame: 749
        //     }

        //     Keyframe {
        //         value: 0
        //         frame: 547
        //     }

        //     Keyframe {
        //         value: 0
        //         frame: 0
        //     }
        // }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#c0c0c0";height:800;width:800}D{i:65;property:"anchors.leftMargin";target:"greenBar"}
D{i:69;property:"opacity";target:"greenBar"}D{i:73;property:"anchors.leftMargin";target:"greenBar1"}
D{i:77;property:"opacity";target:"greenBar1"}D{i:58}
}
##^##*/
