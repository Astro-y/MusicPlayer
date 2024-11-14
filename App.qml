import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import MyUtils 1.0
import QtMultimedia 5.12
import Qt.labs.settings 1.1
import QtQml 2.15

ApplicationWindow {
    id:window

    //软件窗口的宽高
    property int mWINDOW_WIDTH: 1100
    property int mWINDOW_HEIGHT: 680

    //公共字体
    property string mFONT_FAMILY:"微软雅黑"

    width: mWINDOW_WIDTH
    height: mWINDOW_HEIGHT
    visible: true
    //软件名
    title: qsTr("Music Player")

    background: Background{
        id:appBackground
    }

    flags: Qt.Window|Qt.FramelessWindowHint|Qt.WindowMinimizeButtonHint|Qt.WindowMaximizeButtonHint

    AppSystemTrayIcon{

    }

    HttpUtils{
        id:http
    }

    Settings{
        id:settings
        fileName: "conf/settings.ini"
    }

    Settings{
        id:historySettings
        fileName: "conf/history.ini"
    }

    Settings{
        id:favoriteSettings
        fileName: "conf/favorite.ini"
    }

    ColumnLayout{
        anchors.fill: parent
        spacing: 0

        LayoutHeaderView{
            id:layoutHeaderView
            z:1000
        }

        PageHomeView{
            id:pageHomeView
        }

        PageDetailView{
            id:pageDetailView
            visible: false
        }

        LayoutBottomView{
            id:layoutBottomView
        }

    }

    MusicNotification{
        id:notification
    }

    MusicLoading{
        id:loading
    }

    MediaPlayer{
        id:mediaPlayer

        property var times: []

        onPositionChanged: {
            layoutBottomView.setSlider(0,duration,position)

            if(times.length>0){
                var count = times.filter(time=>time<position).length
                pageDetailView.current = (count===0)?0:count-1
            }

        }
        onPlaybackStateChanged: {
            layoutBottomView.playingState = playbackState===MediaPlayer.PlayingState?1:0
            if(playbackState===MediaPlayer.StoppedState&&layoutBottomView.playbackStateChangeCallbackEnabled){
                layoutBottomView.playNext()
            }
        }
    }
}
