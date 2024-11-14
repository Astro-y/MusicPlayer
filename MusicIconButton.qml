import QtQuick 2.15
import QtQuick.Controls 2.5


Button{
    //按钮图片源
    property string iconSource: ""

    //鼠标悬停在按钮时的提示信息
    property string toolTip: ""

    //按钮是否可以被选中
    property bool isCheckable: false
    //当前按钮是否被选中
    property bool isChecked: false

    //设置按钮图片的宽度
    property int iconWidth: 32
    //设置按钮图片的高度
    property int iconHeight: 32

    //设置ToolButton自身ID
    id:self

    //设置按钮图片为iconSource指定值
    icon.source:iconSource
    //设置按钮图片宽度为iconWidth指定值
    icon.width: iconWidth
    //设置按钮图片高度为iconHeight指定值
    icon.height: iconHeight

    MusicToolTip{
        visible:parent.hovered
        text: toolTip
    }

    //定义一个矩形作为背景
    background: Rectangle{
        //如果按钮被按下或处于选中状态，背景颜色为深绿色,否则为浅蓝色
        color:self.down || (isCheckable&&self.checked) ?"#497563":"#20e9f4ff"
        //矩形圆角半径，矩形的角被圆滑处理，半径为3个单位
        radius: 10
    }
    //如果按钮被按下或处于选中状态，图标颜色为白色，否则为浅灰色
    icon.color: self.down || (isCheckable&&self.checked) ?"#ffffff":"#e2f0f8"

    //根据isCheckable设置按钮是否可被选中
    checkable: isCheckable
    //根据isChecked设置按钮当前是否被选中
    checked: isChecked
}
