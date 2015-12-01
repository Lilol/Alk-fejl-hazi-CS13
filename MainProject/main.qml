import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4


/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//The main window of the application. It is rescalable, and the content is scaling with it.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

ApplicationWindow {

    signal resetCommandCpp()
    signal accelerateXCommandCpp()
    signal accelerateYCommandCpp()
    signal slowDownXCommandCpp()
    signal slowDownYCommandCpp()
    signal stopCommandCpp()
    signal defaultCommandCpp()
    signal testCommandCpp()

    id: app_window
    title: qsTr("Simulator GUI")
    minimumWidth: 800
    minimumHeight: 600
    visible: true
    color: "beige"

    //Properties of the robot
    property bool reset: false
    property bool calibration: false

    property bool rotation_left: false
    property bool rotation_right: false
    property bool move_forward: false
    property bool move_backward: false

    //Menubar
    menuBar: MenuBar
    {
        Menu{
            title: qsTr("&Menu")
            MenuItem{
                text: qsTr("&Help")
                onTriggered:{
                    var component = Qt.createComponent("help_window.qml")
                    var window = component.createObject(app_window, {color: app_window.color})
                    window.show()
                }
            }

            MenuItem{
                text: qsTr("&Exit")
                onTriggered: Qt.quit();
            }
        }

        //Style of the menu
        style: MenuBarStyle{
            background: Rectangle{
                color: "springgreen"
            }
            menuStyle: MenuStyle {
                frame: Rectangle {
                    color: "springgreen"
                }
            }
        }
    }
    //Buttons and speedmeter
    Row{
        height: parent.height * 0.3
        width: parent.width * 0.4
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        layoutDirection: Qt.RightToLeft

        Rectangle {
            id: speed_meter_outer_rectangle
            height: parent.height
            width: parent.width * 0.7
            color: app_window.color
            visible: true

            SpeedMeter {
                    speed_x : currentState.vx
                    speed_y : currentState.vy
            }
        }

        Rectangle {
            id: button_outer_rectangle
            height: parent.height
            width: 100
            color: app_window.color
            visible: true

            Buttons {

            }
        }
    }

    //Visual representation of the model and the map
    MapImage {
        objectName: "mapImage"
        id: mapimage_outer_rectangle
        width: parent.width * 0.6
        height: parent.height * 0.65
        anchors.right: parent.right
        anchors.top: parent.top

        position_x : currentState.x
        position_y : currentState.y
        speed_x : currentState.vx
        speed_y : currentState.vy
    }

    //Handling the input keys
    KeyHandler {
        id: keyhandlercontrol
    }

    //Loglist
    Rectangle {
        objectName: "logList"
        id: loglist_outer_rectangle
        anchors.left: parent.left
        anchors.right: mapimage_outer_rectangle.left
        height: mapimage_outer_rectangle.height
        color: app_window.color
        LogList {
            anchors.fill: parent
            anchors.topMargin: parent.height * 0.1
            anchors.bottomMargin: parent.height * 0.1
            anchors.leftMargin: parent.width * 0.3
            anchors.rightMargin: parent.width * 0.3

            state : currentState.statusName
            // @disable-check M16
            position_x : currentState.x
            position_y : currentState.y
            speed_y : currentState.vy
            speed_x : currentState.vx
            acceleration_X : currentState.ax
            acceleration_y : currentState.ay
            // @disable-check M16
            top_wall_distance : currentState.sensors[0]
            // @disable-check M16
            bottom_wall_distance : currentState.sensors[2]
            // @disable-check M16
            left_wall_distance : currentState.sensors[3]
            // @disable-check M16
            right_wall_distance : currentState.sensors[1]
            lamp: (currentState.light !== 0 ? "ON" : "OFF" )
            }
    }

    //Graph
    HistoryGraph {
        objectName: "historyGraph"
        width: parent.width * 0.5
        height: parent.height * 0.3
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        //It can be buggy, if the window crashes, delete this line
        anchors.bottomMargin: 3

        // @disable-check M16
        graphTimestamps: historyGraphTimestamps
        // @disable-check M16
        graphVelocitiesX: historyGraphVelocityX
        // @disable-check M16
        graphVelocitiesY: historyGraphVelocityY
        // @disable-check M16
        graphAccelerationsX: historyGraphAccelerationX
        // @disable-check M16
        graphAccelerationsY: historyGraphAccelerationY
    }

// @disable-check M16
    onResetCommand: {
        resetCommandCpp();
    }
// @disable-check M16
    onAccelerateXCommand: {
        accelerateXCommandCpp();
    }
// @disable-check M16
    onAccelerateYCommand: {
        accelerateYCommandCpp();
    }
// @disable-check M16
    onSlowDownXCommand: {
        slowDownXCommandCpp();
    }
// @disable-check M16
    slowDownYCommand: {
        slowDownYCommandCpp();
    }
// @disable-check M16
    onStopCommand: {
        stopCommandCpp();
    }
// @disable-check M16
    onDefaultCommand: {
        defaultCommandCpp();
    }
// @disable-check M16
    onTestCommand: {
        testCommandCpp();
    }
}

