import QtQuick 2.15
import QtQuick.Controls 2.5

//工具按钮
ToolButton{
    //按钮图片源
    property string iconSource: ""

    //鼠标悬停在按钮时的提示信息
    property string toolTip: ""

    //按钮是否可以被选中
    property bool isCheckable: false
    //当前按钮是否被选中
    property bool isChecked: false

    //设置ToolButton自身ID
    id:self

    //设置按钮图片为iconSource指定值
    icon.source:iconSource

    MusicToolTip{
        visible:parent.hovered
        text: toolTip
    }
    //当鼠标悬停在按钮时显示提示
    //ToolTip.visible:hovered
    //设置提示信息文本为toolTip指定值
    //ToolTip.text: toolTip

    //定义一个矩形作为背景
    background: Rectangle{
        //如果按钮被按下或处于选中状态，背景颜色为浅灰色,否则为透明
        color:self.down || (isCheckable&&self.checked) ?"#eeeeee":"#00000000"
    }
    //如果按钮被按下或处于选中状态，图标颜色为透明，否则为浅灰色
    icon.color: self.down || (isCheckable&&self.checked) ?"#00000000":"#eeeeee"

    //根据isCheckable设置按钮是否可被选中
    checkable: isCheckable
    //根据isChecked设置按钮当前是否被选中
    checked: isChecked
}
