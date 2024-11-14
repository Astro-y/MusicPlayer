//MusicGridLatestView.qml

import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQml 2.15

Item {

    property alias list: gridRepeater.model

    Grid{
        id:gridLayout
        anchors.fill: parent
        //列数
        columns: 3
        //构造一系列相同的组件
        Repeater{
            id:gridRepeater
            Frame{
                padding: 5
                width: parent.width*0.333
                height: parent.width*0.1
                background: Rectangle{
                    id:background
                    color: "#00000000"
                }
                //超出区域裁剪
                clip: true

                MusicRoundImage{
                    id:img
                    width: parent.width*0.6
                    height: parent.height*0.6+35
                    imgSrc:modelData.album.picUrl
                }

                Text {
                    id:name
                    anchors{
                        left: img.right
                        verticalCenter: parent.verticalCenter
                        bottomMargin: 10
                        leftMargin: 5
                    }
                    text:modelData.album.name
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 7.5
                    height: 30
                    width: parent.width*0.72
                    //超出部分自动省略
                    elide: Qt.ElideRight
                    color:"#eeffffff"
                }

                Text {
                    anchors{
                        left: img.right
                        top: name.bottom
                        leftMargin: 5
                    }
                    text:modelData.artists[0].name
                    font.family: window.mFONT_FAMILY
                    height: 30
                    width: parent.width*0.72
                    //超出右边部分自动省略
                    elide: Qt.ElideRight
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
                        layoutBottomView.current = -1
                        layoutBottomView.playList = [{
                                                         id:list[index].id,
                                                         name:list[index].name,
                                                         artist:list[index].artists[0].name,
                                                         album:list[index].album.name,
                                                         cover:list[index].album.picUrl,
                                                         ype:"0"
                                                     }]
                        layoutBottomView.current = 0
                    }
                }
            }
        }
    }
}
