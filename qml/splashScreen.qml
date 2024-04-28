import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtQuick.Timeline 1.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "components"

Window {
    width: 550
    height: 500
    visible: true
    id: splashScreen
    color: "#00000000"
    title: qsTr("Login RTS")
    signal timeout

    FontLoader {
        id: fontAwesomeLoader
        source: "../fonts/fontawesome-webfont.ttf"
    }

    // Remove title bar
    flags: Qt.SplashScreen | Qt.FramelessWindowHint
    modality: Qt.ApplicationModal
    

    // Custom Properties
    property int timeoutInterval: 1000

    Timer {
        id: timer
        interval: timeoutInterval;
       
        running: false;
        repeat: false
        
        onTriggered: {
       
            var component = Qt.createComponent("main.qml");

            var win = component.createObject()

            win.loggedUsername=hiddenusername.text.trim()
            win.hiddenOrg=hiddenOrg.text.trim()
            win.hiddenEmail=hiddenEmail.text.trim()

            win.show()
            visible = false
            splashScreen.timeout()
        }
    }

    
    // Functions
    QtObject {
        id: internal

            // Reset Text Error
            function resetTextLogin(){
                labelPassword.visible = false
                loginTextField.borderColor = "#333" // Slightly lighter border color
            }

            function resetUsernameLogin(){
                labelUsernameError.visible = false
                usernameTextField.borderColor = "#333" // Slightly lighter border color
            }

            
            function proceedTomain() {
            // Additional logic if login is successful
                    loginAnimationFrameMarginTop.running = true;
                    timer.running = true;

                    checkloggedin.running=false
                    checkloggedin.repeat=false

                    
            }

           function displayStatus(message, success) {
            // Set the status message
            labelName.text = message;

            // Check if the message contains "verifying logged-in user" and set color accordingly
            if (message.indexOf("Verifying logged-in user") !== -1) {
                
                labelName.color = "#ffd700"; // Yellow
            } else {
                // Set the color based on success or failure
                labelName.color = success ? "#00FF00" : "#FF0000";
            }

            // Start animation to display the label
            labelNametextFieldAnimationRightMargin.running = true;
            labelNameFieldOpacity.running = true;
        }


            

          
    }



Rectangle {
    id: bg
    x: 25
    y: 131
    width: 500
    height: 318
    opacity: 0
    color: "#222" // Cool matte black background color
    radius: 20
    border.color: "#333" // Slightly lighter border color
    border.width: 1 // Thin border
    anchors.verticalCenter: parent.verticalCenter
    clip: true
    anchors.verticalCenterOffset: -100
    anchors.horizontalCenter: parent.horizontalCenter
    z: 3

    DragHandler { onActiveChanged: if(active){ splashScreen.startSystemMove() } }

    CircularProgressBar {
        id: circularProgressBar;
        width: 200;
        height: 200;
        opacity: 1
        anchors.verticalCenter: parent.verticalCenter ;
        enableDropShadow: false
        value: 100;
        textColor: "#fff" // White text color
        progressColor: "#ffd700" // Yellowish golden progress color
        progressWidth: 4;
        strokeBgWidth: 2;
        bgStrokeColor: "#333" // Slightly lighter border color
        anchors.horizontalCenter: parent.horizontalCenter
    }



    Image {
        id: logoImage
        x: 50
        y: 50
        width: 100
        height: 100
        opacity: 1
        anchors.verticalCenter: parent.verticalCenter
        source: "../images/images/logo_rts.png"
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
    }

    TopBarButton {
        id: btnClose;
        opacity: 0
        visible: true
        anchors.right: parent.right;
        anchors.top: parent.top;
        enabled: true
        btnColorClicked: "#ffd700" // Yellowish golden color on click
        btnColorMouseOver: "#444" // Darker gray color on mouse over
        btnIconSource: "../images/svg_images/close_icon.svg";
        anchors.topMargin: 8
        anchors.rightMargin: 8
        onClicked: splashScreen.close()
        CustomToolTip {
            text: "Close"
        }
    }



    

    Label {
        id: labelName
        y: 295
        width: 294
        height: 25
        color: "#fff" // White text color
        text: qsTr("")
        opacity:0
        anchors.left: parent.left

        anchors.bottomMargin: -0
        anchors.leftMargin: 30
        font.pointSize: 10
        font.bold: true
        font.family: "Arial" // Use a standard font like Arial
        font.weight: Font.DemiBold
        
        PropertyAnimation {
        id: labelNametextFieldAnimationRightMargin
        target: labelName
        property: "anchors.rightMargin"
        to: labelName.anchors.rightMargin === 110 ? 30 : 110
        duration: 1000
        easing.type: Easing.InOutQuint
        }

        PropertyAnimation {
            id: labelNameFieldOpacity
            target: labelName
            property: "opacity"
            to: labelName.opacity === 0 ? 1 : 0
            duration: 1000
            easing.type: Easing.InOutQuint
        }
    }

    CustomButton {
        id: btnChangeUser // Changed id to reflect its purpose as a login button
        x: 270
        y: 270
        width: 80
        height: 30
        opacity: 1
        text:"Signup"
        Text {
            text: btnChangeUser.text === "Signup" ? "\uf234" : "\uf060" // Unicode for the Font Awesome back and sign-up icons
            font.family: fontAwesomeLoader.name
            font.pixelSize: 15
            color: "white" // Set the color as needed
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.rightMargin: 5
        }
        
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.rightMargin: 30
        colorPressed: "#ffd700" // Yellowish golden color on press
        colorMouseOver: "#222" // Darker gray color on mouse over
        colorDefault: "#222" // Darker gray default color
        CustomToolTip {

            text: btnChangeUser.text === "Signup" ? "Sign up" : "Back"
        }
    
        onClicked: {
            // imageAnimationRightMargin.running = true
            // imageAnimationOpacity.running = true
            // textFieldAnimationRightMargin.running = true
            // textFieldOpacity.running = true

            if (btnChangeUser.text === "Back") {
                loginAnimationFrameMarginTop.running = false // Stop the animation
                loginAnimationFrameMarginBottom.running=true
               
            }

             else {
                loginAnimationFrameMarginTop.running = true // Stop the animation
                loginAnimationFrameMarginBottom.running=false
            }

            btnSignText.running=true

            signuppasswordtextFieldAnimationRightMargin.running=true
            signuppasswordtextFieldOpacity.running = true
            signupTextField.text = ""

            signupEmailAnimationRightMargin.running=true
            signupEmailOpacity.running=true
            signupEmailField.text=""

            signupUsernameAnimationRightMargin.running=true
            signupUsernameOpacity.running=true
            signupUsernameField.text=""
            

            labelNametextFieldAnimationRightMargin.running=true
            labelNameFieldOpacity.running=true
            labelName.text=""


            addUserButtonAnimationRightMargin.running=true
            addUserButtonOpacity.running=true

            switchlayoutAnimationRightMargin.running=true
            switchlayoutOpacity.running=true

            signupOrgAnimationRightMargin.running=true
            signupOrgOpacity.running=true

        }
        PropertyAnimation {
            id: btnSignText
            target: btnChangeUser
            property: "text"
            to: if(btnChangeUser.text == "Signup") return "Back"; else return "Signup"
            duration: 0
        }
        

    }


    CustomTextField {
        id: signupTextField
        x: 120
        y: 190
        width: 300
        height: 40
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 10
        placeholderText: "Enter password"
        color: "#fff" // Color for text
        selectionColor: "#ffd700" // Color for selection
        selectedTextColor: "#222" // Text color when selected
        anchors.bottomMargin: 60
        anchors.rightMargin: 110
        opacity: 0
        echoMode: TextInput.Password
        maximumLength: 100

         MouseArea {
            id: eyeIconArea
            width: 20
            height: parent.height
            anchors.right: parent.right
            anchors.bottomMargin: 20
             anchors.rightMargin: 20
            onClicked: {
                signupTextField.echoMode = signupTextField.echoMode === TextInput.Password ? TextInput.Normal : TextInput.Password;
            }

            Text {
                anchors.centerIn: parent
                text: signupTextField.echoMode === TextInput.Password ? "\uf06e" : "\uf070" // Font Awesome icons for eye and eye-slash
                font.family: "Font Awesome 5 Free Solid"
                color: "#fff"
                font.pointSize: 16
            }
        }
    

        PropertyAnimation {
            id: signuppasswordtextFieldAnimationRightMargin
            target: signupTextField
            property: "anchors.rightMargin"
            to: signupTextField.anchors.rightMargin === 110 ? 30 : 110
            duration: 500
            easing.type: Easing.InOutQuint
        }

        PropertyAnimation {
            id: signuppasswordtextFieldOpacity
            target: signupTextField
            property: "opacity"
            to: signupTextField.opacity === 0 ? 1 : 0
            duration: 500
            easing.type: Easing.InOutQuint
        }
    
    }

    RowLayout {
        id:switchlayout
        x:115
        y:240
        spacing: 10

        opacity: 0

        anchors.bottomMargin: 90
        anchors.rightMargin: 110

        Switch {
            id: mySwitch
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: "Superuser"
            color: mySwitch.checked ? "#ffd700" : "#d1d1cf"
            Layout.alignment: Qt.AlignVCenter
            font.pointSize: 10
            font.weight: Font.Normal
            font.family: "Segoe UI"
            font.bold: true
            

        }
        PropertyAnimation {
            id: switchlayoutAnimationRightMargin
            target: switchlayout
            property: "anchors.rightMargin"
            to: switchlayout.anchors.rightMargin === 110 ? 30 : 110
            duration: 500
            easing.type: Easing.InOutQuint
        }

        PropertyAnimation {
            id: switchlayoutOpacity
            target: switchlayout
            property: "opacity"
            to: switchlayout.opacity === 0 ? 1 : 0
            duration: 500
            easing.type: Easing.InOutQuint
        }
    }

    CustomTextField {
        id: signupOrgField // Renamed to reflect organization name
        x: 120
        y: 35
        width: 300
        height: 40
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 10
        placeholderText: "Enter Organization name"
        color: "#fff" // Color for text
        selectionColor: "#ffd700" // Color for selection
        selectedTextColor: "#222" // Text color when selected
        anchors.bottomMargin: 60
        anchors.rightMargin: 110
        opacity: 0
        maximumLength: 1000 // Adjust maximum length as needed

        PropertyAnimation {
            id: signupOrgAnimationRightMargin // Renamed animation ID
            target: signupOrgField
            property: "anchors.rightMargin"
            to: signupOrgField.anchors.rightMargin === 110 ? 30 : 110
            duration: 500
            easing.type: Easing.InOutQuint
        }

        PropertyAnimation {
            id: signupOrgOpacity // Renamed animation ID
            target: signupOrgField
            property: "opacity"
            to: signupOrgField.opacity === 0 ? 1 : 0
            duration: 500
            easing.type: Easing.InOutQuint
        }
    }


        

    CustomTextField {
        id: signupEmailField
        x: 120
        y: 80
        width: 300
        height: 40
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 10
        placeholderText: "Enter email"
        color: "#fff" // Color for text
        selectionColor: "#ffd700" // Color for selection
        selectedTextColor: "#222" // Text color when selected
        anchors.bottomMargin: 60
        anchors.rightMargin: 110
        opacity: 0
        maximumLength: 1000 // Adjust maximum length as needed

        PropertyAnimation {
            id: signupEmailAnimationRightMargin
            target: signupEmailField
            property: "anchors.rightMargin"
            to: signupEmailField.anchors.rightMargin === 110 ? 30 : 110
            duration: 500
            easing.type: Easing.InOutQuint
        }

        PropertyAnimation {
            id: signupEmailOpacity
            target: signupEmailField
            property: "opacity"
            to: signupEmailField.opacity === 0 ? 1 : 0
            duration: 500
            easing.type: Easing.InOutQuint
        }

    }

    CustomTextField {
        id: signupUsernameField
        x: 120
        y: 130
        width: 300
        height: 40
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 10
        placeholderText: "Enter username"
        color: "#fff" // Color for text
        selectionColor: "#ffd700" // Color for selection
        selectedTextColor: "#222" // Text color when selected
        anchors.bottomMargin: 60
        anchors.rightMargin: 110
        opacity: 0
        maximumLength: 100 // Adjust maximum length as needed

        PropertyAnimation {
            id: signupUsernameAnimationRightMargin
            target: signupUsernameField
            property: "anchors.rightMargin"
            to: signupUsernameField.anchors.rightMargin === 110 ? 30 : 110
            duration: 500
            easing.type: Easing.InOutQuint
        }

        PropertyAnimation {
            id: signupUsernameOpacity
            target: signupUsernameField
            property: "opacity"
            to: signupUsernameField.opacity === 0 ? 1 : 0
            duration: 500
            easing.type: Easing.InOutQuint
        }
    }

    CustomButton {
        id: addUserButton
        text: "Add User"
        x: 270
        y: 240
        width: 80
        height: 30
        opacity: 0
       
       
        colorPressed: "#ffd700" // Yellowish golden color on press
        colorMouseOver: "#444" // Darker gray color on mouse over
        colorDefault: "#444" // Darker gray default color
        CustomToolTip {
            text: "Add user"
        }

        PropertyAnimation {
            id: addUserButtonAnimationRightMargin
            target: addUserButton
            property: "anchors.rightMargin"
            to: addUserButton.anchors.rightMargin === 110 ? 30 : 150
            duration: 500
            easing.type: Easing.InOutQuint
        }

        PropertyAnimation {
            id: addUserButtonOpacity
            target: addUserButton
            property: "opacity"
            to: addUserButton.opacity === 0 ? 1 : 0
            duration: 500
            easing.type: Easing.InOutQuint
        }

        onClicked: {
            
            // Check if all required fields are filled out
            var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (signupUsernameField.text.trim() === "" ||
                signupEmailField.text.trim() === "" ||
                signupTextField.text.trim() === "") {
                internal.displayStatus("Please fill out all fields before adding the user.")
                return; // Exit the function if any field is empty
            }
            if (!signupEmailField.text.trim().match(emailPattern)) {
                internal.displayStatus("Please enter a valid email address.")
                return; // Exit the function if any field is empty or email format is incorrect
            }

            if (addUserButton.enabled) {
                // Extract text from the fields
                var username = signupUsernameField.text;
                var email = signupEmailField.text;
                var password = signupTextField.text;
                var organization = signupOrgField.text;

                // Disable the button to prevent multiple clicks
                addUserButton.enabled = false;

                // Add user information to the 
                var is_superuser=mySwitch.checked
                
                db_backend.create_user(username, email, organization, password,is_superuser, true)

                internal.displayStatus(`Adding ${username} to database please wait ..`, true);
            }
            
         }
    } 

    Connections {
        target: db_backend
        function onUserCreated(user) {
            var data = JSON.parse(user);
            if (data["status"] === 200) {
                internal.displayStatus(data["message"], true);
                console.log("User added successfully");
            } else {
                console.error("Error adding user:", data["message"]);
                internal.displayStatus(data["message"], false);
            }
            // Re-enable the button after the operation is complete
            addUserButton.enabled = true;
        }
    }


    Label {
        id: labelUnlockInfo1
        x: 30
        y: 23
        opacity: 0
        color: "#ffd700" // Yellowish golden color
        text: "RTS pos -  By: RUHMTECH"
        textFormat: Text.RichText
        font.pointSize: 8
        font.bold: false
        
        font.weight: Font.Normal
        font.family: "Segoe UI"


    }
    

    Image {
        id: image1
        x: 50
        y: 104
        width: 50
        height: 50
        opacity: 0
        anchors.verticalCenter: parent.verticalCenter
        source: "../images/images/logo_rts.png"
        sourceSize.height: 50
        sourceSize.width: 50
        fillMode: Image.PreserveAspectFit
    }

    Label {
        id: hiddenusername
        visible: false // Initially hidden
        text: "" // Use the passed username argument
    }
    Label {
        id: hiddenEmail
        visible: false // Initially hidden
        text: "" // Use the passed username argument
    }

    Label {
        id: hiddenOrg
        visible: false // Initially hidden
        text: "" // Use the passed username argument
    }



    Timer {
        id: userloggedin
        interval: 1000 // Adjust the delay time as needed (in milliseconds)
        repeat: false // We want it to run only once
        running: false // We'll start it manually
        onTriggered: {
            checkloggedin.running=false
            checkloggedin.repeat=false

            internal.displayStatus("Verifying logged-in user. Please wait ! ", true);
            db_backend.startThread() // tries to login user by checking local db

        }
    }

     Connections {
        target: db_backend // Specify the target object as the Backend component
        function onUserReceived(user) {
            var data = JSON.parse(user)

            if (data["status"] === 200) {
                hiddenusername.text = data["data"]["username"];
                hiddenEmail.text = data["data"]["email"];
                hiddenOrg.text = data["data"]["organization"];

                internal.displayStatus("login success .. ", true);

                loginAnimationFrameMarginTop.running = true;

                timer.running = true;

            } else {
                internal.displayStatus(data["message"], false);
                // Start the delay timer
                delayTimer.running = true;
            }
        }
    }

    Timer {
        id: delayTimer
        interval: 100 // Delay in milliseconds (adjust as needed)
        onTriggered: {
           

            // Check if the status is not 200 and retry
            if (userloggedin.running) {
                // If the timer is running, restart it
                userloggedin.restart();
            } else {
                // If the timer is not running, start it
                userloggedin.start();
            }

        
        }
        running: false // Start the timer when needed
        repeat: false // Run only once
}



    Timer {
        id:checkloggedin
        interval: 1000 // Adjust interval as needed
        running: true
        repeat: true
        onTriggered: {
            // check is the user is logged in and if progressbar is more than 100
            if (circularProgressBar.value >= 0) {
                userloggedin.start()
                
            }
        }

    }



}


Rectangle {
    id: loginFrame
    x: 45
    width: 460
    height: 180
    visible: false
    color: "#222" // Cool matte black background color
    radius: 15
    border.color: "#333" // Slightly lighter border color
    border.width: 3
    anchors.top: bg.bottom
    anchors.topMargin: -280
    anchors.horizontalCenter: parent.horizontalCenter
    z: 2


    PropertyAnimation {
        id: loginAnimationFrameMarginTop
        target: loginFrame
        property: "anchors.topMargin"
        to: -280
        duration: 950
        easing.type: Easing.InOutQuint
    }

    PropertyAnimation {
        id: loginAnimationFrameMarginBottom
        target: loginFrame
        property: "anchors.topMargin"
        to: -20 // Position to reveal the element
        duration: 950
        easing.type: Easing.InOutQuint
    }


    Label {
        id: labelNubank
        x: 30
        y: 50
        color: "#fff" // White text color
        text: qsTr("RTS")
        font.weight: Font.DemiBold
        font.bold: true
        font.pointSize: 14
        font.family: "Segoe UI"
    }

    Label {
        id: labelUnlockInfo
        x: 30
        y: 72
        color: "#ffd700" // Yellowish golden text color
        text: qsTr("Access your account")
        font.pointSize: 10
        font.bold: false
        font.family: "Segoe UI"
        font.weight: Font.Normal
    }


    Image {
        id: imageFingerPrint
        x: 185
        y: 123
        width: 100
        height: 100
        opacity: 1
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        source: "../images/images/fingerprint.png"
        anchors.rightMargin: 30
        anchors.verticalCenterOffset: 10
        fillMode: Image.PreserveAspectFit

        PropertyAnimation {
            id: imageAnimationRightMargin
            target: imageFingerPrint
            property: "anchors.rightMargin"
            to: if(imageFingerPrint.anchors.rightMargin == 30) return 130; else return 30
            duration: 500
            easing.type: Easing.InOutQuint
        }
        PropertyAnimation {
            id: imageAnimationOpacity
            target: imageFingerPrint
            property: "opacity"
            to: if(imageFingerPrint.opacity == 1) return 0.35; else return 1
            duration: 500
            easing.type: Easing.InOutQuint
        }
    }
    

    CustomTextField {
        id: loginTextField
        x: 230
        y: 100
        width: 160
        height: 30
      
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 10
        placeholderText: "Password"
        color: "#fff" // Color for text
        selectionColor: "#ffd700" // Color for selection
        selectedTextColor: "#222" // Text color when selected
        
        anchors.bottomMargin: 60
        anchors.rightMargin: 110
        opacity: 0
        echoMode: TextInput.Password
        maximumLength: 100

        MouseArea {
            id: eyeIconAreaLogin
            width: 20
            height: parent.height
            anchors.right: parent.right
   
            anchors.bottomMargin: 2
             anchors.rightMargin: 5
            onClicked: {
                loginTextField.echoMode = loginTextField.echoMode === TextInput.Password ? TextInput.Normal : TextInput.Password;
            }

            Text {
                anchors.centerIn: parent
                text: loginTextField.echoMode === TextInput.Password ? "\uf06e" : "\uf070" // Font Awesome icons for eye and eye-slash
                font.family: "Font Awesome 5 Free Solid"
                color: "#fff"
                font.pointSize: 16
            }
        }


        PropertyAnimation {
            id: textFieldAnimationRightMargin
            target: loginTextField
            property: "anchors.rightMargin"
            to: if(loginTextField.anchors.rightMargin == 110) return 30; else return 110
            duration: 500
            easing.type: Easing.InOutQuint
        }
        PropertyAnimation {
            id: textFieldOpacity
            target: loginTextField
            property: "opacity"
            to: if(loginTextField.opacity == 0) return 1; else return 0
            duration: 500
            easing.type: Easing.InOutQuint
        }
    }

    CustomTextField {
        id: usernameTextField
        x: 230
        y: 60
        width: 160
        height: 30
   
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 10
        placeholderText: "Username" // Placeholder text updated to "Your username"
        color: "#fff" // Color for text
        selectionColor: "#ffd700" // Color for selection
        selectedTextColor: "#222" // Text color when selected
     
        opacity: 0
        echoMode: TextInput.Normal // Changed from Password to Normal
        maximumLength: 100
       
        PropertyAnimation {
            id: usertextFieldAnimationRightMargin
            target: usernameTextField
            property: "anchors.rightMargin"
            to: if(usernameTextField.anchors.rightMargin == 110) return 30; else return 110
            duration: 500
            easing.type: Easing.InOutQuint
        }
        PropertyAnimation {
            id: usertextFieldOpacity
            target: usernameTextField
            property: "opacity"
            to: if(usernameTextField.opacity == 0) return 1; else return 0
            duration: 500
            easing.type: Easing.InOutQuint
        }
    }

    CustomTextField {
        id: loginOrgField
        x: 230
        y: 25
        width: 160
        height: 30

        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 10
        placeholderText: "Organization" // Placeholder text updated to "Organization"
        color: "#fff" // Color for text
        selectionColor: "#ffd700" // Color for selection
        selectedTextColor: "#222" // Text color when selected

        opacity: 0
        echoMode: TextInput.Normal // Changed from Password to Normal
        maximumLength: 100

        PropertyAnimation {
            id: orgTextFieldAnimationRightMargin
            target: loginOrgField
            property: "anchors.rightMargin"
            to: if(loginOrgField.anchors.rightMargin == 110) return 30; else return 110
            duration: 500
            easing.type: Easing.InOutQuint
        }
        PropertyAnimation {
            id: orgTextFieldOpacity
            target: loginOrgField
            property: "opacity"
            to: if(loginOrgField.opacity == 0) return 1; else return 0
            duration: 500
            easing.type: Easing.InOutQuint
        }
    }



    CustomButton {
        id: loginButton // Changed id to reflect its purpose as a login button
        x: 235
        y: 120
        width: 150
        height: 30
        opacity: 0

        text: "Authenticate"

        anchors.bottom: parent.bottom
      
        anchors.bottomMargin: 5
       
        colorPressed: "#ffd700" // Yellowish golden color on press
        colorMouseOver: "#444" // Darker gray color on mouse over
        colorDefault: "#444" // Darker gray default color
      
        onClicked: {
            labelPassword.visible = false;

                // Get the values from the input fields
            var username = usernameTextField.text.trim();
            var password = loginTextField.text.trim();
            var loginorg = loginOrgField.text.trim();

            // Check if all fields are filled out
            if (!username || !password || !loginorg) {
                // Show error message for incomplete fields
                labelPassword.text = qsTr("Please fill out all fields before logging in.");
                labelPassword.visible = true;
                return; // Exit the function if any field is empty
            }
            if (loginButton.enabled){
                    // Proceed with login request using backend function
                db_backend.login(username, password, loginorg);

                // Disable the login button until the response is received
                labelName.text=""
                loginButton.enabled = false;

                labelPassword.visible = true;
                labelPassword.color="#34eb83"
               
                labelPassword.text = "Checking loggin .... ";

            }
    
        }
        
        Connections {
            target: db_backend // Specify the target object as the Backend component
            function onLoginResult(success, message) {
                // Enable the login button when a response is received
                loginButton.enabled = true;

                // Handle the response
                if (success) {
                    // Login successful
                    // Proceed to main 
                    labelPassword.text = message;
                    loginTextField.borderColor = "#34eb83"; // Green color for correct input
                    usernameTextField.borderColor= "#34eb83";
                   // proceedToMain();
                } else {
                    // Login failed, show error message
                    labelPassword.text = message;
                    labelPassword.visible = true;
                    labelPassword.color="#FF0000"

                    loginTextField.borderColor = "#FF0000"; // Red color for incorrect input
                }
            }
        }


        PropertyAnimation {
            id: loginButtonAnimationRightMargin // Changed animation id to reflect its purpose as a login button animation
            target: loginButton // Changed target to loginButton
            property: "anchors.rightMargin"
            to: if(loginButton.anchors.rightMargin == 110) return 30; else return 110
            duration: 500
            easing.type: Easing.InOutQuint
        }

        PropertyAnimation {
            id: loginButtonOpacity // Changed animation id to reflect its purpose as a login button animation
            target: loginButton // Changed target to loginButton
            property: "opacity"
            to: if(loginButton.opacity == 0) return 1; else return 0
            duration: 500
            easing.type: Easing.InOutQuint
        }

        }

    

    CustomButton {
        id: btnChangeLogin
        x: 30
        y: 120
        width: 80
        height: 30
        text: "LOGIN"
        Text {
            text: btnChangeLogin.text === "LOGIN" ? "\uf090" : "\uf060" // Unicode for the Font Awesome back and sign-up icons
            font.family: fontAwesomeLoader.name
            font.pixelSize: 15
            color: "white" // Set the color as needed
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.rightMargin: 5
        }

        colorPressed: "#ffd700" // Yellowish golden color on press
        colorMouseOver: "#444" // Darker gray color on mouse over
        colorDefault: "#444" // Darker gray default color

        onClicked: {
            imageAnimationRightMargin.running = true
            imageAnimationOpacity.running = true
            textFieldAnimationRightMargin.running = true
            textFieldOpacity.running = true

            usertextFieldAnimationRightMargin.running=true
            usertextFieldOpacity.running = true

            loginButtonAnimationRightMargin.running=true
            loginButtonOpacity.running=true

            orgTextFieldAnimationRightMargin.running=true
            orgTextFieldOpacity.running=true


            btnText.running = true
            loginTextField.text = ""
            usernameTextField.text=""
            loginOrgField.text=""

            
            

            internal.resetTextLogin()
            internal.resetUsernameLogin()
        }
        PropertyAnimation {
            id: btnText
            target: btnChangeLogin
            property: "text"
            to: btnChangeLogin.text === "LOGIN" ? "BACK" : "LOGIN"
            duration: 0
        }

        CustomToolTip {
            text: btnChangeLogin.text === "LOGIN" ? "Login" : "Back"
        }

    }

    Label {
        id: labelPassword
        x: 311
        color: "#FF0000" // Reddish color for incorrect password message
        text: qsTr("password incorrect")
        anchors.right: parent.right
        anchors.top: loginTextField.bottom
        horizontalAlignment: Text.AlignRight
        anchors.topMargin: 0
        anchors.rightMargin: 30
        font.pointSize: 10
        font.weight: Font.Normal
        font.family: "Segoe UI"
        font.bold: false
        visible: false
        antialiasing: false
    }
    Label {
        id: labelUsernameError
        x: 311
        color: "#FF0000" // Reddish color for incorrect username message
        text: qsTr("Username incorrect")
        anchors.right: parent.right
        anchors.top: usernameTextField.top // Assuming usernameTextField is the id of the username input field
        horizontalAlignment: Text.AlignRight
        anchors.topMargin: -20
        anchors.rightMargin: 30
        font.pointSize: 10
        font.weight: Font.Normal
        font.family: "Segoe UI"
        font.bold: false
        visible: false // Initially hidden
        antialiasing: false
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
        z: 1
    }

    DropShadow{
        id: dropShadowLogin
        visible: false
        anchors.fill: loginFrame
        source: loginFrame
        verticalOffset: 0
        horizontalOffset: 0
        radius: 10
        color: "#40000000"
        z: 0
    }

    Timeline {
        id: timeline
        animations: [
            TimelineAnimation {
                id: timelineAnimation
                running: true
                loops: 1
                duration: 3000
                to: 3000
                from: 0
            }
        ]
        endFrame: 3000
        enabled: true
        startFrame: 0

        KeyframeGroup {
            target: circularProgressBar
            property: "value"
            Keyframe {
                frame: 0
                value: 0
            }

            Keyframe {
                frame: 1505
                value: 100
            }
        }

        KeyframeGroup {
            target: circularProgressBar
            property: "opacity"
            Keyframe {
                frame: 1505
                value: 1
            }

            Keyframe {
                frame: 1902
                value: 0
            }

            Keyframe {
                frame: 0
                value: 1
            }

            Keyframe {
                frame: 250
                value: 1
            }
        }

        KeyframeGroup {
            target: btnClose
            property: "opacity"
            Keyframe {
                frame: 1501
                value: 0
            }

            Keyframe {
                frame: 2000
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        KeyframeGroup {
            target: logoImage
            property: "opacity"
            Keyframe {
                frame: 1750
                value: 0
            }

            Keyframe {
                frame: 2250
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        KeyframeGroup {
            target: bg
            property: "anchors.verticalCenterOffset"
            Keyframe {
                frame: 1998
                value: 0
            }

            Keyframe {
                easing.bezierCurve: [0.254,0.00129,0.235,0.999,1,1]
                frame: 2697
                value: -80
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        KeyframeGroup {
            target: loginFrame
            property: "anchors.topMargin"
            Keyframe {
                easing.bezierCurve: [0.254,0.00129,0.235,0.999,1,1]
                frame: 2700
                value: -20
            }

            Keyframe {
                frame: 2000
                value: -280
            }

            Keyframe {
                frame: 0
                value: -280
            }
        }

        KeyframeGroup {
            target: labelUnlockInfo1
            property: "opacity"
            Keyframe {
                frame: 2000
                value: 1
            }

            Keyframe {
                frame: 1500
                value: 0
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        KeyframeGroup {
            target: btnChangeUser
            property: "opacity"
            Keyframe {
                frame: 1900
                value: 0
            }

            Keyframe {
                frame: 2450
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        KeyframeGroup {
            target: bg
            property: "opacity"
            Keyframe {
                frame: 250
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
                frame: 250
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        KeyframeGroup {
            target: dropShadowLogin
            property: "visible"
            Keyframe {
                frame: 497
                value: false
            }

            Keyframe {
                frame: 550
                value: true
            }

            Keyframe {
                frame: 0
                value: false
            }
        }

        KeyframeGroup {
            target: loginFrame
            property: "visible"
            Keyframe {
                frame: 497
                value: false
            }

            Keyframe {
                frame: 550
                value: true
            }

            Keyframe {
                frame: 0
                value: false
            }
        }

        KeyframeGroup {
            target: imageFingerPrint
            property: "opacity"
            Keyframe {
                frame: 2500
                value: 0
            }

            Keyframe {
                frame: 2950
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        KeyframeGroup {
            target: image1
            property: "opacity"
            Keyframe {
                frame: 1450
                value: 1
            }

            Keyframe {
                frame: 1750
                value: 0
            }

            Keyframe {
                frame: 500
                value: 1
            }

            Keyframe {
                frame: 252
                value: 1
            }
        }

        KeyframeGroup {
            target: labelName
            property: "anchors.bottomMargin"
            Keyframe {
                easing.bezierCurve: [0.254,0.00129,0.235,0.999,1,1]
                value: 22
                frame: 2350
            }

            Keyframe {
                value: -25
                frame: 1798
            }

            Keyframe {
                value: -25
                frame: 0
            }
        }
    }
}
