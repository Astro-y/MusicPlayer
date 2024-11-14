import QtQuick 2.15
import QtGraphicalEffects 1.0

Rectangle {

    property bool showDefaultBackground: true

    Image {
        id: backgroundImage
        source:showDefaultBackground?"qrc:/imgs/player1":layoutBottomView.musicCover
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }

    ColorOverlay{
        id:backgroundImageOverlay
        anchors.fill: backgroundImage
        source: backgroundImage
        color: "#35000000"
    }

    FastBlur{
        anchors.fill: backgroundImageOverlay
        source: backgroundImageOverlay
        //模糊半径
        radius: 80
    }

}
