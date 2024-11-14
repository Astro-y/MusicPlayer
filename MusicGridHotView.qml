//MusicGridHotView.qml

import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQml 2.15

Item {

    property alias list: gridRepeater.model

    Grid{
        id:gridLayout
        anchors.fill: parent
        //列数
        columns: 5
        //构造一系列相同的组件
        Repeater{
            id:gridRepeater
            Frame{
                padding: 10
                width: parent.width*0.2
                height: parent.width*0.2+30
                background: Rectangle{
                    id:background
                    color: "#00000000"
                }
                //超出区域裁剪
                clip: true

                MusicBorderImage{
                    id:img
                    width: parent.width
                    height: parent.height-8
                    imgSrc:modelData.coverImgUrl
                }

                Text {
                    anchors{
                        top:img.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                    text:modelData.name
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 7.5
                    height: 15
                    width: parent.width
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    //超出部分自动省略
                    elide: Qt.ElideMiddle
                    color:"#eeffffff"
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        background.color = "#50ffffff"
                    }
                    onExited: {
                        background.color = "#00000000"
                    }
                    onClicked: {
                        var item = gridRepeater.model[index]
                        pageHomeView.showPlayList(item.id,"1000")
                    }
                }
            }
        }
    }
}
