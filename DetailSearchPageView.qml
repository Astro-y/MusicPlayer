//DetailSearchPageView.qml

import QtQuick.Controls 2.5
import QtQuick 2.15
import QtQuick.Layouts 1.12

ColumnLayout{

    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 10

    property int offset: 0

    Rectangle{
        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#00000000"

        Text {
            x:10
            verticalAlignment: Text.AlignBottom//垂直居中
            text: qsTr("搜索音乐")
            font.family: window.mFONT_FAMILY
            font.pointSize: 25
            color:"#eeffffff"
        }
    }

    //搜索框
    RowLayout{
        Layout.fillWidth: true
        TextField{
            id:searchInput
            font.pixelSize: 14
            font.family: window.mFONT_FAMILY
            selectByMouse: true //是否可以选择文本
            selectionColor: "#999999"//选中背景颜色
            placeholderText: qsTr("请输入搜索关键词")
            color: "#eeffffff"
            background: Rectangle {
                color: "#00000000"
                opacity: 0.5//0.05
                implicitHeight: 40
                implicitWidth: 400
                border.width: 0.5
                border.color: "#394272"
                radius: 10
            }
            focus: true
            Keys.onPressed: if(event.key===Qt.Key_Enter||event.key===Qt.Key_Return)doSearch()

        }
        MusicIconButton{
            iconSource: "qrc:/imgs/search"
            toolTip: "搜索"
            onClicked: doSearch()
        }
    }

    MusicListView{
        id:musicListView
        deletable: false
        onLoadMore: doSearch(offset,current)
        Layout.topMargin: 10
    }

    function doSearch(offset = 0,current = 0){
        loading.open()
        var keywords = searchInput.text
        if(keywords.length<1) return
        function onReply(reply){
            loading.close()
            http.onReplySignal.disconnect(onReply)
            try{
                if(reply.length<1){
                    notification.openError("搜索结果为空！	")
                    return
                }
                var result = JSON.parse(reply).result
                musicListView.current = current
                musicListView.all = result.songCount
                musicListView.musicList = result.songs.map(item=>{
                                                               return {
                                                                   id:item.id,
                                                                   name:item.name,
                                                                   artist:item.artists[0].name,
                                                                   album:item.album.name,
                                                                   cover:""
                                                               }
                                                           })
            }catch(err){
                notification.openError("搜索结果错误！	")
            }
        }
        http.onReplySignal.connect(onReply)
        http.connet("search?keywords="+keywords+"&offset="+offset+"&limit=60")
    }
}

/*Rectangle{
    Layout.fillWidth: true
    width: parent.width
    height: 60
    color:"#00000000"
    Text{
        x:10
        verticalAlignment: Text.AlignBottom
        text:qsTr("搜索音乐")
        font.family: window.mFONT_FAMILY
        font.pointSize: 25
    }
}*/
