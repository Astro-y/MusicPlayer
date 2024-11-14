import QtQuick.Controls 2.5
import QtQuick 2.15
import QtQuick.Layouts 1.12
import QtQml 2.15

ColumnLayout{

    property var timer: null
    property int remainingSeconds: 0 // 用于存储剩余秒数

    Rectangle{
        Layout.fillWidth: true
        width: parent.width
        height: 60
        color:"#00000000"
        Text{
            x:10
            verticalAlignment: Text.AlignBottom
            text:qsTr("设置")
            font.family: window.mFONT_FAMILY
            font.pointSize: 25
            color:"#eeffffff"
        }
    }

    RowLayout{
        height: 80
        Item{
            width: 5
        }
        Rectangle {
            width: 250
            height: 50
            border.width: 0.5
            border.color: "black"
            radius: 10
            opacity: 0.8
            Text {
                id:urltext
                text: "默认URL"
                font.pixelSize: 16
                color: "blue"
                anchors.centerIn: parent
            }

        }
        Item{
            width: 200
        }
        MusicTextButton{
            btnText: "获取URL"
            btnHeight: 50
            btnWidth: 120
            onClicked: {
                urltext.text = http.getBaseUrl()
                notification.openSuccess("获取成功！")
            }
        }

        MusicTextButton{
            btnText: "更改URL"
            btnHeight: 50
            btnWidth: 120
            onClicked: {
                urlDialog.open()
            }
        }

        MusicTextButton{
            btnText: "重置URL"
            btnHeight: 50
            btnWidth: 120
            onClicked: {
                http.recoverBaseUrl()
                notification.openSuccess("重置成功！")
            }
        }
    }

    RowLayout{
        height: 80
        Item{
            width: 5
        }
        Rectangle {
            width: 250
            height: 50
            border.width: 0.5
            border.color: "black"
            radius: 10
            opacity: 0.8
            Text {
                id:timertext
                text: "00:00:00"
                font.pixelSize: 16
                color: "blue"
                anchors.centerIn: parent
            }

        }
        Item{
            width: 200
        }
        MusicTextButton{
            btnText: "设置定时关闭"
            btnHeight: 50
            btnWidth: 120
            onClicked: {
                timerDialog.visible = true
            }
        }
        Item{
            width: 120
        }
        MusicTextButton{
            btnText: "取消定时关闭"
            btnHeight: 50
            btnWidth: 120
            onClicked: {
                cancelTimer()
                notification.openSuccess("取消成功！")
            }
        }
    }

    Item {
        height: 500
    }

    Dialog{
        id:urlDialog
        visible: false
        title: "输入新的 URL"
        anchors.centerIn: parent
        Column{
            spacing: 10
            TextField{
                id:input
                placeholderText:"请输入URL"
                echoMode: TextInput.Normal
            }
            Row{
                spacing: 10
                Button{
                    text: "确认"
                    height: 32
                    width: 64
                    onClicked: {
                        var url = input.text
                        var regex = /^(http:\/\/localhost(:3000)?\/)$/
                        if(http.setBaseUrl(url)&&regex.test(url))
                            notification.openSuccess("更改成功！")
                        else
                            notification.openError("更改失败！URL格式错误")
                        input.text = ""
                        urlDialog.close()
                    }
                }
                Button{
                    text: "取消"
                    height: 32
                    width: 64

                    onClicked: {
                        input.text = ""
                        urlDialog.close()
                    }
                }
            }
        }
    }

    Dialog {
        id: timerDialog
        visible: false
        title: "设置定时关闭时间"
        anchors.centerIn: parent

        Column {
            spacing: 10
            Row {
                spacing: 10

                TextField {
                    id: hourInput
                    placeholderText:"请输入小时："
                    echoMode: TextInput.Normal
                    width: 100
                }
                TextField {
                    id: minuteInput
                    placeholderText:"请输入分钟："
                    echoMode: TextInput.Normal
                    width: 100
                }
                TextField {
                    id: secondInput
                    placeholderText:"请输入秒："
                    echoMode: TextInput.Normal
                    width: 100
                }
            }

            // Label {
            //     text: "请输入分钟数："
            // }

            // TextField {
            //     id: timeInput
            //     echoMode: TextInput.Normal
            // }

            Row{
                spacing: 10
                Button {
                    text: "确定"
                    height: 32
                    width: 64
                    onClicked: {
                        var hours = parseInt(hourInput.text) || 0
                        var minutes = parseInt(minuteInput.text) || 0
                        var seconds = parseInt(secondInput.text) || 0
                        var totalSeconds = hours * 3600 + minutes * 60 + seconds
                        if (!(hours === 0 && minutes === 0 && seconds === 0)) {
                            if(totalSeconds<86400)
                                startTimer(hours, minutes, seconds)
                            else
                                notification.openError("设置时间不能超过24小时！")
                        } else {
                            notification.openError("不能全部为0")
                        }
                        hourInput.text = ""
                        minuteInput.text = ""
                        secondInput.text = ""
                    }
                }
                Button{
                    text: "取消"
                    height: 32
                    width: 64
                    onClicked: {
                        hourInput.text = ""
                        minuteInput.text = ""
                        secondInput.text = ""
                        timerDialog.close()
                    }
                }
            }
        }
    }

    function startTimer(hours, minutes, seconds){
        if (!isNaN(hours) &&!isNaN(minutes) &&!isNaN(seconds) && (hours >= 0) && (minutes >= 0) && (seconds >= 0) && (hours > 0 || minutes > 0 || seconds > 0)) {
            timerDialog.close()
            var totalSeconds = hours * 3600 + minutes * 60 + seconds;
            remainingSeconds = totalSeconds;
            var delay = 1000; // 转换为毫秒
            timer = Qt.createQmlObject('import QtQuick 2.12; Timer { interval: ' + delay + '; repeat: true; onTriggered: updateRemainingTime() }', Qt.application, "dynamicTimer");
            if(timer) {
                timer.start()
                updateRemainingTime()
                var currentDate = new Date();
                var closeTime = new Date(
                            currentDate.getFullYear(),
                            currentDate.getMonth(),
                            currentDate.getDate(),
                            currentDate.getHours() + hours,
                            currentDate.getMinutes() + minutes,
                            currentDate.getSeconds() + seconds
                            );
                var closeTimeString = closeTime.getHours() + ":" + closeTime.getMinutes() + ":" + closeTime.getSeconds();
                notification.openSuccess("设置成功！将在 " + closeTimeString + " 关闭");
            } else {
                notification.openError("设置失败！")
            }
        }
        else{
            timerDialog.close()
            notification.openError("设置失败！必须全部输入框都输入,且其中一个大于0")
        }
    }

    function updateRemainingTime() {
        if (remainingSeconds > 0) {
            if(remainingSeconds==3)
                notification.openWarning("程序将在三秒后关闭！")
            remainingSeconds--;
            var hours = Math.floor(remainingSeconds / 3600);
            var minutes = Math.floor((remainingSeconds % 3600) / 60);
            var seconds = remainingSeconds % 60;
            timertext.text = hours.toString().padStart(2, '0') + ':' + minutes.toString().padStart(2, '0') + ':' + seconds.toString().padStart(2, '0');
        } else {
            // 时间到了，这里可以添加相应的处理，比如关闭应用或者执行其他操作
            if (timer) {
                timer.stop()
                timer.destroy()
                timer = null
                Qt.quit()
            }
        }
    }

    function cancelTimer() {
        if (timer) {
            timer.stop()
            timer.destroy()
            timer = null
            remainingSeconds = 0;
            timertext.text = "00:00:00";
        }
    }
}
