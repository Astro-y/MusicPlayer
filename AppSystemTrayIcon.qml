//AppSystemTrayIcon.qml

import QtQuick 2.15
import Qt.labs.platform 1.0

SystemTrayIcon {
    id:systemTray
    visible: true
    iconSource: "qrc:/imgs/music"
    property bool windowVisible: true
    onActivated: function(reason){
        if (reason === SystemTrayIcon.Trigger){
            if(windowVisible){
                window.hide()
                windowVisible = !windowVisible
            }else{
                window.show()
                window.raise()
                window.requestActivate()
                windowVisible = !windowVisible
            }
        }
    }
    menu: Menu{
        id:menu
        MenuItem{
            text: "上一首"
            onTriggered: layoutBottomView.playPrevious()
        }
        MenuItem{
            text: layoutBottomView.playingState==0?"播放":"暂停"
            onTriggered: layoutBottomView.playOrPause()
        }
        MenuItem{
            text: "下一首"
            onTriggered: layoutBottomView.playNext()
        }
        MenuSeparator{}
        MenuItem{
            text: "退出"
            onTriggered: Qt.quit()
        }
    }
}
