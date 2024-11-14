import QtQuick 2.15
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0

//自定义圆角图片
Item {

    //设置圆角图片为指定路径
    property string imgSrc: "qrc:/imgs/player1"

    //设置矩形遮罩的圆角半径
    property int borderRadius: 5

    //显示图片
    Image{
        //为该图片组件指定一个ID
        id:image
        //将图片的中心点对齐到其父元素Item的中心点
        anchors.centerIn: parent
        //将图片设置为imgSrc指定值
        source: imgSrc
        //启用平滑过滤，改善图片的缩放质量
        smooth: true
        //初始化图片不可见
        visible: false
        //设置图片的宽度为父元素的宽度
        width: parent.width
        //设置图片的高度为父元素的高度
        height: parent.height
        //图片将以保持其纵横比的方式被裁剪以适应给定的宽度和高度
        fillMode: Image.PreserveAspectCrop
        //启用抗锯齿
        antialiasing: true
    }

    //绘制矩形
    Rectangle{
        //为该矩形设置一个指定的ID
        id:mask
        //设置矩形的颜色为黑色
        color:"black"
        //将矩形填充其父元素的整个区域
        anchors.fill: parent
        //矩形圆角半径，矩形的角被圆滑处理，半径为borderRadius
        radius: borderRadius
        //初始化矩形不可见
        visible: false
        //启用平滑过滤，改善图片的缩放质量
        smooth: true
        //启用抗锯齿
        antialiasing: true
    }

    OpacityMask{
        anchors.fill: image
        source: image
        maskSource: mask
        visible: true
        antialiasing: true
    }
}
