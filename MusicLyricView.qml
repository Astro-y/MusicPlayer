import QtQuick 2.15
import QtQuick.Layouts 1.12
import QtQml 2.15

Rectangle {

    property alias lyrics: list.model
    property alias current: list.currentIndex

    color: "#00000000"

    id:lyricView

    Layout.preferredHeight: parent.height*0.8
    Layout.alignment: Qt.AlignCenter

    clip: true

    ListView{
        id:list
        anchors.fill: parent
        model: ["暂无歌词","暂无歌词","暂无歌词"]
        delegate: listDelegate
        // highlight: Rectangle{
        //     color: "#2073a7db"
        // }
        highlightMoveDuration: 0
        highlightResizeDuration: 0
        currentIndex: 0
        preferredHighlightBegin: parent.height/2-50
        preferredHighlightEnd: parent.height/2
        highlightRangeMode: ListView.StrictlyEnforceRange
    }

    Component{
        id:listDelegate
        Item{
            id:delegateItem
            width: parent?parent.width:0
            height: 50
            Text{
                text:modelData
                anchors.centerIn: parent
                color: index===list.currentIndex?"#6f98fe":"#aaffffff"
                font{
                    family: window.mFONT_FAMILY
                    pointSize: 12
                }
            }
            states:State{
                when:delegateItem.ListView.isCurrentItem
                PropertyChanges{
                    target: delegateItem
                    scale:1.2
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: list.currentIndex = index
            }
        }
    }

}
