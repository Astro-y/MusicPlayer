//MusicTextButton.qml

import QtQuick 2.15
import QtQuick.Controls 2.5


Button{

    property alias btnText: name.text

    //按钮是否可以被选中
    property alias isCheckable: self.checkable
    //当前按钮是否被选中
    property alias isChecked: self.checked

    property alias btnWidth: self.width
    property alias btnHeight: self.height

    //设置ToolButton自身ID
    id:self

    Text{
        id:name
        text: "Button"
        color: self.down || (self.checkable&&self.checked) ?"#ee000000":"#eeffffff"
        font.family: window.mFONT_FAMILY
        font.pointSize: 14
        anchors.centerIn: parent
    }

    //定义一个矩形作为背景
    background: Rectangle{
        implicitHeight: self.height
        implicitWidth: self.width
        //如果按钮被按下或处于选中状态，背景颜色为深绿色,否则为浅蓝色
        color:self.down || (self.checkable&&self.checked) ?"#e2f0f8":"#66e9f4ff"
        //矩形圆角半径，矩形的角被圆滑处理，半径为3个单位
        radius: 3
    }

    width: 50
    height: 50
    //根据isCheckable设置按钮是否可被选中
    checkable: false
    //根据isChecked设置按钮当前是否被选中
    checked: false
}
