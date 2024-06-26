import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtQuick.Timeline 1.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"
import "pages"

Window {
    width: 1200
    height: 720
    minimumWidth: 1100
    minimumHeight: 650
    visible: true
    color: "#00000000"
    id: mainWindow
    title: qsTr("RTS")

    // Remove title bar
    flags: Qt.Window | Qt.FramelessWindowHint
    // ... your QML object definition here ...

    property string loggedUsername: ""
    property string hiddenEmail:""
    property string hiddenOrg:""


    // Text Edit Properties
    property alias actualPage: stackView.currentItem
    property int windowStatus: 0
    property int windowMargin: 10
    property int bgRadius: 20

    // Internal functions
    QtObject{
        id: internal

    

        function resetResizeBorders() {
            try {
                // Resize visibility
                resizeLeft.visible = true
                resizeRight.visible = true
                resizeBottom.visible = true
                resizeApp.visible = true
                bg.radius = bgRadius
                bg.border.width = 3
            } catch (error) {
                console.error("An error occurred while resetting resize borders:", error)
            }
        }


        function maximizeRestore(){
            if(windowStatus == 0){
                mainWindow.showMaximized()
                windowStatus = 1
                windowMargin = 0
                // Resize visibility
                resizeLeft.visible = false
                resizeRight.visible = false
                resizeBottom.visible = false
                resizeApp.visible = false
                bg.radius = 0
                bg.border.width = 0
                btnMaximizeRestore.btnIconSource = "../images/svg_images/restore_icon.svg"
            }
            else{
                mainWindow.showNormal()
                windowStatus = 0
                windowMargin = 10
                // Resize visibility
                internal.resetResizeBorders()
                bg.border.width = 3
                btnMaximizeRestore.btnIconSource = "../images/svg_images/maximize_icon.svg"
            }
        }

        function ifMaximizedWindowRestore(){
            if(windowStatus == 1){
                mainWindow.showNormal()
                windowStatus = 0
                windowMargin = 10
                // Resize visibility
                internal.resetResizeBorders()
                bg.border.width = 3
                btnMaximizeRestore.btnIconSource = "../images/svg_images/maximize_icon.svg"
            }
        }

        function restoreMargins(){
            windowStatus = 0
            windowMargin = 10
            bg.radius = bgRadius
            // Resize visibility
            internal.resetResizeBorders()
            bg.border.width = 3
            btnMaximizeRestore.btnIconSource = "../images/svg_images/maximize_icon.svg"
        }
    }

    Rectangle {
        id: bg
        opacity: 0
        color: "#222"
        radius: 20
        border.color: "#333"
        border.width: 3
        anchors.fill: parent
        anchors.margins: windowMargin
        clip: true
        z: 1

        TopBarButton {
            id: btnClose
            x: 1140
            visible: true
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 8
            btnColorClicked: "#55aaff"
            btnColorMouseOver: "#ff007f"
            anchors.topMargin: 8
            btnIconSource: "../images/svg_images/close_icon.svg"
            CustomToolTip {
                text: "Close"
            }
            onPressed: mainWindow.close()
        }


        Timer {
            id: timer
            interval: timeoutInterval;
            running: false;
            repeat: false

            onTriggered: {
                mainWindow.close()
            }

            }



        TopBarButton {
            id: btnMaximizeRestore
            x: 1105
            visible: true
            anchors.right: btnClose.left
            anchors.top: parent.top
            anchors.rightMargin: 0
            anchors.topMargin: 8
            btnColorClicked: "#ffd700"
            btnColorMouseOver: "#161717"
            btnIconSource: "../images/svg_images/maximize_icon.svg"
            CustomToolTip {
                text: "Maximize"
            }
            onClicked: internal.maximizeRestore()
        }

        TopBarButton {
            id: btnMinimize
            x: 1070
            visible: true
            anchors.right: btnMaximizeRestore.left
            anchors.top: parent.top
            btnRadius: 17
            anchors.rightMargin: 0
            btnColorClicked: "#ffd700"
            btnColorMouseOver: "#161717"
            
            anchors.topMargin: 8
            btnIconSource: "../images/svg_images/minimize_icon.svg"
            CustomToolTip {
                text: "Minimize"
            }
            onClicked: {
                mainWindow.showMinimized()
                internal.restoreMargins()
            }
        }

        Rectangle {
            id: titleBar
            height: 40
            color: "#222"
            radius: 14
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 120
            anchors.leftMargin: 8
            anchors.topMargin: 8

            DragHandler { onActiveChanged: if(active){
                   mainWindow.startSystemMove()
                   internal.ifMaximizedWindowRestore()
                }
            }

            Image {
                id: iconTopLogo
                y: 5
                width: 20
                height: 20
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                source: "../images/images/logo_rts.png"
                sourceSize.height: 20
                sourceSize.width: 20
                anchors.leftMargin: 15
                fillMode: Image.PreserveAspectFit
            }

            Label {
                id: labelTitleBar
                y: 14
                color: "#ffd700"
                text: qsTr("RUHMTECH SYSTEMS - "+loggedUsername)
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: iconTopLogo.right
                font.pointSize: 12
                font.family: "Segoe UI"
                anchors.leftMargin: 15
            }




        }

       Rectangle {
            id: appVersion
            width: parent.width
            height: 30
            color: "#222"
            anchors.bottom: parent.bottom
            anchors.right: parent.right

            Label {
                id: labelVersion
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 8
                color: "#ffd700"
                text:qsTr("RTS - Version 1.0")

                font.pointSize: 7
                font.family: "Segoe UI"
                padding: 8
            }
        }




        Flickable {
            id: flickable
            height: 106
            contentWidth: gridLayoutBottom.width
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 15
            anchors.leftMargin: 15
            anchors.bottomMargin: 4
            
            clip: true

            GridLayout {
                id: gridLayoutBottom
                columns: 100
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                columnSpacing: 10
                
                rows: 0

                FontLoader {
                    id: fontAwesomeLoader
                    source: "../fonts/fontawesome-webfont.ttf" // Path to your FontAwesome TTF file
                }

                CustomAppButton {
                    text: "\uf002 Product Lookup" // Unicode value for the search icon followed by text
                    font.family: fontAwesomeLoader.name // Use the name of the loaded font
                    font.pointSize: 9 // Adjust the font size as needed
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    onClicked: stackView.push("pages/pageNoInternet.qml")
                }

                CustomAppButton {
                    text: "\uf007 Customer Info" // Unicode value for the user icon followed by text
                    font.family: fontAwesomeLoader.name
                    font.pointSize: 9
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    onClicked: stackView.push("pages/pageNoInternet.qml")
                }

                CustomAppButton {
                    text: "\uf05a Inventory" // Unicode value for the barcode icon followed by text
                    font.family: fontAwesomeLoader.name
                    font.pointSize: 9
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    onClicked: stackView.push("pages/pageNoInternet.qml")
                }


            }
            ScrollBar.horizontal: ScrollBar {
                id: control
                size: 0.3
                position: 0.2
                orientation: Qt.Horizontal
                visible: flickable.moving || flickable.moving

                contentItem: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 6
                    radius: height / 2
                    color: control.pressed ? "#222" : "#ffd700"

                    
                }
            }
        }

        Column {
            id: columnCircularButtons
            width: 50
            anchors.left: parent.left
            anchors.top: titleBar.bottom
            anchors.bottom: flickable.top
            spacing: 5
            anchors.bottomMargin: 10
            anchors.topMargin: 10
            anchors.leftMargin: 15
            

            CustomCircularButton {
                id: btnHome
                width: 50
                height: 50
                visible: true
         
                CustomToolTip {
                    text: "Point of sale"
                }
                btnIconSource: "../images/svg_images/home_icon.svg"
                onClicked: {
                    stackView.push(Qt.resolvedUrl("pages/homePage.qml"))
                    
                }
            }


            CustomCircularButton {
                id: btnSettings
                width: 50
                height: 50
                visible: true
                CustomToolTip {
                    id: settingsTooltip
                    text: "Settings"
                }
                btnIconSource: "../images/svg_images/settings_icon.svg"
                onClicked: {
                    animationMenu.running = true
                    if(leftMenu.width == 0){
                        btnSettings.btnIconSource = "../images/svg_images/close_icon_2.svg"
                        settingsTooltip.text = "Close settings"
                    } else {
                        btnSettings.btnIconSource = "../images/svg_images/settings_icon.svg"
                        settingsTooltip.text = "Settings"
                    }
                }
            }

            
        }

        Rectangle {
            id: leftMenu
            width: 0
            color: "#222" // Matte black color
            
            border.color: "#333" // Slightly lighter border color
            border.width: 1
            radius: 10 // Rounded corners

            anchors.left: columnCircularButtons.right
            anchors.top: titleBar.bottom
            anchors.bottom: flickable.top
            clip: true
            anchors.bottomMargin: 10
            anchors.leftMargin: 5
            anchors.topMargin: 10

            PropertyAnimation {
                id: animationMenu
                target: leftMenu
                property: "width"
                to: if(leftMenu.width == 0) return 240; else return 0
                duration: 800
                easing.type: Easing.InOutQuint
            }

            Image {
                id: imageQrCode
                width: 110
                height: 110
                source: "../images/svg_images/rts_qr.svg"
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
                sourceSize.width: 110
                sourceSize.height: 110
            }

            Label {
                id: labelContaInfo
                x: 39
                opacity: 1
                color: "white" // Yellowish gold color
                text: "Point Of Sale - BY: RTS"
                anchors.top: imageQrCode.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                textFormat: Text.RichText
                anchors.horizontalCenterOffset: 0
                font.family: "Arial" // Change the font to Arial or another suitable font
                anchors.topMargin: 10
                font.bold: false
                font.weight: Font.Normal
                font.pointSize: 8
            }


            Column {
                id: columnMenus
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: labelContaInfo.bottom
                anchors.bottom: parent.bottom

                LeftButton {
                  
                    text: "Help"
                    onClicked: stackView.push("pages/pageNoInternet.qml")
                    colorPressed: "#ffd700" // Yellowish gold color when pressed
                    colorMouseOver: "#222" // Yellowish gold color on mouse over
                    colorDefault: "#333" // White color by default
                     
            
                }

                LeftButton {
                    text: "Profile"
                    btnIconSource: "../images/svg_images/user_icon.svg"
                    onClicked: stackView.push("pages/pageNoInternet.qml")
                    colorPressed: "#ffd700" // Yellowish gold color when pressed
                    colorMouseOver: "#222" // Yellowish gold color on mouse over
                    colorDefault: "#333" // White color by default
            
                }

                LeftButton {
            
                    text: "\uf013 Settings" // Unicode character for the cog icon in Font Awesome
                    font.family: fontAwesomeLoader.name // Set the font family to the loaded Font Awesome font
                    btnIconSource:""
                    
                    onClicked: stackView.push("pages/pageNoInternet.qml")

                    colorPressed: "#ffd700" // Yellowish gold color when pressed
                    colorMouseOver: "#222" // Yellowish gold color on mouse over
                    colorDefault: "#333" // White color by default
                }


                anchors.topMargin: 10
            }

            CustomButton {
                    id:"logoutbtn"
                    width: 220
                    height: 30
                    text: "LOGOUT"
                    anchors.bottom: parent.bottom
                    
                    anchors.bottomMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
          

                    colorPressed: "#ffd700" // Yellowish gold color when pressed
                    colorMouseOver: "#161717" // Darker matte black color on mouse over
                    colorDefault: "#333" // Matte black color by default
                    
                    Text {
                       
                        anchors.centerIn: parent
                        color: "#fff" // White text color
                        font.pixelSize: 14
                        font.bold: true
                    }

                   MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            logoutbtn.text="Loggin out .."
                            db_backend.logout(loggedUsername);
                           
                        }
                    }

                    Connections {
                        target: db_backend // Specify the target object as the backend component
                        function onLogoutSignal(success) {
                            // Handle the logout signal
                            if (success) {
                                // Logout successful, perform any necessary actions
                                console.log("Logout successful");
                                timer.running = true;
                            } else {
                                // Logout failed, handle error if needed
                                console.error("Logout failed");
                            }
                        }
                    }

            }

            
        }


        Rectangle {
            id: contentPages
            color: "#00000000"
            anchors.left: leftMenu.right
            anchors.right: parent.right
            anchors.top: titleBar.bottom
            anchors.bottom: flickable.top
            anchors.rightMargin: 15
            anchors.leftMargin: 10
            anchors.bottomMargin: 10
            anchors.topMargin: 10

            StackView {
                id: stackView
                anchors.fill: parent
                clip: true
                initialItem: Qt.resolvedUrl("pages/homePage.qml")
            }
        }

    }

    DropShadow{
        id: dropShadowBG
        opacity: 0
        anchors.fill: bg
        source: bg
        verticalOffset: 0
        horizontalOffset: 0
        radius: 10
        color: "#40000000"
        z: 0
    }


        MouseArea {
            id: resizeLeft
            width: 12
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            anchors.leftMargin: 0
            anchors.topMargin: 10
            cursorShape: Qt.SizeHorCursor
            DragHandler {
                target: null
                onActiveChanged: {
                    try {
                        if (active) { 
                            mainWindow.startSystemResize(Qt.LeftEdge) 
                        }
                    } catch (error) {
                        console.error("An error occurred during resizing:", error)
                    }
                }
            }
        }


        MouseArea {
            id: resizeRight
            width: 12
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 0
            anchors.bottomMargin: 25
            anchors.leftMargin: 6
            anchors.topMargin: 10
            cursorShape: Qt.SizeHorCursor
            DragHandler {
                target: null
                onActiveChanged: {
                    try {
                        if (active) { 
                            mainWindow.startSystemResize(Qt.RightEdge) 
                        }
                    } catch (error) {
                        console.error("An error occurred during resizing:", error)
                    }
                }
            }
        }


    MouseArea {
        id: resizeBottom
        height: 12
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        cursorShape: Qt.SizeVerCursor
        anchors.rightMargin: 25
        anchors.leftMargin: 15
        anchors.bottomMargin: 0
        DragHandler {
            target: null
            onActiveChanged: {
                try {
                    if (active) { 
                        mainWindow.startSystemResize(Qt.BottomEdge) 
                    }
                } catch (error) {
                    console.error("An error occurred during resizing:", error)
                }
            }
        }
    }


    MouseArea {
        id: resizeApp
        x: 1176
        y: 697
        width: 25
        height: 25
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.rightMargin: 0
        cursorShape: Qt.SizeFDiagCursor
        DragHandler{
            target: null
            onActiveChanged: if (active){
                                 mainWindow.startSystemResize(Qt.RightEdge | Qt.BottomEdge)
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
            target: bg
            property: "opacity"
            Keyframe {
                frame: 949
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        KeyframeGroup {
            target: dropShadowBG
            property: "opacity"
            Keyframe {
                frame: 949
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }
    }
}
