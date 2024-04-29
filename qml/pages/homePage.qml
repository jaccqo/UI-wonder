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

               

               // Main content area
               
               


                  
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
