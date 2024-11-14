import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.15

RowLayout{



    property int defaultIndex: 0

    property var qmlList: [
        {icon:"recommend-white",value:"推荐内容",qml:"DetailRecommendPageView",menu:true},
        {icon:"cloud-white",value:"搜索音乐",qml:"DetailSearchPageView",menu:true},
        {icon:"local-white",value:"本地音乐",qml:"DetailLocalPageView",menu:true},
        {icon:"history-white",value:"播放历史",qml:"DetailHistoryPageView",menu:true},
        {icon:"favorite-big-white",value:"我的喜欢",qml:"DetailFavoritePageView",menu:true},
        {icon:"set",value:"设置",qml:"DetailSettingPageView",menu:true},
        {icon:"",value:"专辑歌单",qml:"DetailPlayListPageView",menu:false}
    ]

    spacing: 0
    //左边菜单
    Frame {

        Layout.preferredWidth: 200
        Layout.fillHeight: true
        background: Rectangle{
            color:"#1000AAAA"
        }
        padding: 0

        ColumnLayout{
            anchors.fill: parent

            Item{
                Layout.fillWidth: true
                Layout.preferredHeight: 150
                MusicBorderImage{
                    anchors.centerIn: parent
                    height: 100
                    width: 100
                    borderRadius: 100
                }
            }

            ListView{
                id:menuView
                height: parent.height
                Layout.fillHeight: true
                Layout.fillWidth: true
                model:ListModel{
                    id:menuViewModel
                }
                delegate: menuViewDelegate
                //高亮效果
                highlight: Rectangle{
                    color: "#3073a7ab"
                }
                //移动切换动画，不需要为0
                highlightMoveDuration: 0
                //长度和宽度改变的时候变形的时间
                highlightResizeDuration: 0
            }
        }


        Component{
            id:menuViewDelegate
            Rectangle{
                id:menuViewDelegateItem
                height: 50
                width: 200
                color: "#00000000"
                RowLayout{
                    anchors.fill: parent
                    anchors.centerIn: parent
                    spacing: 15
                    Item{
                        width: 30
                    }
                    Image {
                        source: "qrc:/imgs/"+icon
                        Layout.preferredHeight: 20
                        Layout.preferredWidth: 20
                    }
                    Text {
                        text: value
                        Layout.fillWidth: true
                        height: 50
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 12
                        color:"#eeffffff"
                    }
                }

                //鼠标操作
                MouseArea{
                    //鼠标悬停
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        color="#aa73a7ab"
                    }
                    onExited: {
                        color="#00000000"
                    }
                    //鼠标点击切换效果
                    onClicked: {
                        hidePlayList()
                        repeater.itemAt(menuViewDelegateItem.ListView.view.currentIndex).visible = false
                        menuViewDelegateItem.ListView.view.currentIndex = index
                        var loader = repeater.itemAt(index)
                        loader.visible = true
                        loader.source = qmlList[index].qml+".qml"
                    }
                    onDoubleClicked: {
                        hidePlayList()
                        repeater.itemAt(menuViewDelegateItem.ListView.view.currentIndex).visible = false
                        menuViewDelegateItem.ListView.view.currentIndex = index
                        var loader = repeater.itemAt(index)
                        loader.visible = true
                        loader.active = false
                        loader.source = qmlList[index].qml+".qml"
                        loader.active = true
                    }
                }

            }
        }

        Component.onCompleted: {
            menuViewModel.append(qmlList.filter(item=>item.menu))
            var loader = repeater.itemAt(defaultIndex)
            loader.visible = true
            loader.source = qmlList[defaultIndex].qml+".qml"

            menuView.currentIndex = defaultIndex
            //showPlayList()
        }

    }

    //右边加载页面

    //重复构造子组件
    Repeater{
        id:repeater
        model:qmlList.length

        Loader{
            visible: false
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    function showPlayList(targetId="",targetType="10"){
        repeater.itemAt(menuView.currentIndex).visible = false
        var loader = repeater.itemAt(6)
        loader.visible = true
        loader.source = qmlList[6].qml+".qml"
        loader.item.targetType = targetType
        loader.item.targetId = targetId
    }
    function hidePlayList(){
        repeater.itemAt(menuView.currentIndex).visible = true
        var loader = repeater.itemAt(6)
        loader.visible = false
    }

}


