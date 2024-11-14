import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Window 2.15

//顶部工具栏
ToolBar{

    property point point: Qt.point(x,y)
    property bool isSmallWindow: false

    //背景设置为矩形，背景颜色为青色
    background: Rectangle{
        color:"#00000000"
    }
    //设置宽度为父元素的宽度
    width: parent.width
    //确保填充其父元素整个宽度
    Layout.fillWidth: true
    //水平排列的子元素
    RowLayout{

        //将布局填满工具栏
        anchors.fill: parent

        //音乐工具按钮设置
        MusicToolButton{
            //设置按钮图片信息
            iconSource: "qrc:/imgs/music"
            //设置鼠标悬停信息
            toolTip: "关于"
            //点击按钮触发事件
            onClicked: {
                //弹出弹窗
                aboutPop.open()
            }
        }
        MusicToolButton{
            iconSource: "qrc:/imgs/about"
            toolTip: "GitHub"
            onClicked: {
                //打开指定的网站
                Qt.openUrlExternally("http://www.baidu.com")
            }
        }

        Item{
            Layout.fillWidth: true
            height: 32
            Text{
                anchors.centerIn: parent
                text:qsTr("Music Player")
                font.family: window.mFONT_FAMILY
                font.pointSize: 15
                color: "#ffffff"
            }

            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                onPressed: setPoint(mouseX,mouseY)
                onMouseXChanged: moveX(mouseX)
                onMouseYChanged: moveY(mouseY)
            }
        }
        MusicToolButton{
            id:smallWindow
            iconSource: "qrc:/imgs/small-window"
            toolTip: "小窗播放"
            visible: !isSmallWindow
            onClicked: {
                //设置窗口的宽高
                setWindowSize(330,650)

                maxWindow.visible = false

                isSmallWindow = true
                pageHomeView.visible = false
                pageDetailView.visible = true
                appBackground.showDefaultBackground = pageHomeView.visible
            }
        }
        MusicToolButton{
            id:normalWindow
            iconSource: "qrc:/imgs/exit-small-window"
            toolTip: "退出小窗播放"
            //初始化不可见
            visible: isSmallWindow
            onClicked: {
                //设置窗口的宽高
                setWindowSize()
                maxWindow.visible = true
                isSmallWindow = false
                appBackground.showDefaultBackground = pageHomeView.visible
            }
        }
        MusicToolButton{
            iconSource: "qrc:/imgs/minimize-screen"
            toolTip: "最小化"
            onClicked: {
                //将窗口最小化
                window.visibility = Window.Minimized
            }
        }
        MusicToolButton{
            id:maxWindow
            iconSource: "qrc:/imgs/full-screen"
            toolTip: "全屏"
            onClicked: {
                //设置窗口的宽高
                window.visibility = Window.Maximized
                //将退出全屏设置可见，全屏设置不可见
                maxWindow.visible = false
                resize.visible = true
            }
        }
        MusicToolButton{
            id:resize
            iconSource: "qrc:/imgs/small-screen"
            toolTip: "退出全屏"
            //初始化不可见
            visible: false
            onClicked: {
                //设置窗口的宽高
                setWindowSize()
                window.visibility = Window.AutomaticVisibility
                //将退出全屏设置不可见，全屏设置可见
                maxWindow.visible = true
                resize.visible = false
            }
        }
        MusicToolButton{
            iconSource: "qrc:/imgs/power"
            toolTip: "退出"
            onClicked: {
                //结束Qt程序
                Qt.quit()
            }
        }
    }

    //弹出窗口
    Popup{

        //设置指定ID
        id:aboutPop

        //设置窗口相对于其父元素的边距
        topInset: 0
        leftInset: 0
        rightInset: 0
        bottomInset: 0

        //将弹窗定位在窗口的中心
        parent: overlay.overlay
        //将窗口的中心点对齐父元素的中心点
        x:(parent.width-width)/2
        y:(parent.height-height)/2

        //设置窗口的宽度和高度
        width: 250
        height: 230

        //设置背景为一个矩形，并设置一个指定背景颜色和边框颜色，将边框平滑处理，半径为5个单位
        background: Rectangle{
            color:"#e9f4ff"
            radius:5
            border.color: "#2273a7ab"
        }

        //设置内容项，垂直排列子元素
        contentItem: ColumnLayout{
            //设置宽度为父元素的宽度
            width: parent.width
            //设置高度为父元素的高度
            height: parent.height
            //将内容水平居中对齐
            Layout.alignment: Qt.AlignHCenter
            //设置图片
            Image{
                //设置图片的首选高度
                Layout.preferredHeight: 60
                //设置图片源
                source:"qrc:/imgs/music"
                //将图片的宽度填充父元素的宽度
                Layout.fillWidth: true
                //保持图片的宽高比，适应图片的尺寸
                fillMode: Image.PreserveAspectFit
            }

            Text{
                //显示的文本，qsTr用于国际化支持
                text:qsTr("软件2204")
                //使Text的宽度填充其父元素的宽度
                Layout.fillWidth: true
                //文本水平居中
                horizontalAlignment: Text.AlignHCenter
                //设置字体大小为18
                font.pixelSize: 18
                //设置文本颜色
                color: "#8573a7ab"
                //设置指定的字体
                font.family: window.mFONT_FAMILY
                //文本加粗
                font.bold: true
            }

            Text{
                text:qsTr("Music Player V0.5.3")
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 16
                color: "#8573a7ab"
                font.family: window.mFONT_FAMILY
                font.bold: true
            }

            Text{
                text:qsTr("astro_0707@qq.com")
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 16
                color: "#8573a7ab"
                font.family: window.mFONT_FAMILY
                font.bold: true
            }
        }
    }

    //设置窗口的宽高的函数
    function setWindowSize(width=window.mWINDOW_WIDTH,height=window.mWINDOW_HEIGHT){
        window.height = height
        window.width = width
        window.x = (Screen.desktopAvailableWidth-window.width)/2
        window.y = (Screen.desktopAvailableHeight-window.height)/2

    }

    function setPoint(mouseX=0,mouseY=0){
        point = Qt.point(mouseX,mouseY)
    }
    function moveX(mouseX=0){
        var x = window.x + mouseX-point.x
        if(x<-(window.width-70)) x=-(window.width-70)
        if(x>Screen.desktopAvailableWidth-70) x = Screen.desktopAvailableWidth-70
        window.x = x
    }

    function moveY(mouseY=0){
        var y = window.y + mouseY-point.y
        if(y<=0) y=0
        if(y>Screen.desktopAvailableHeight-70) y = Screen.desktopAvailableHeight-70
        window.y = y
    }

}

