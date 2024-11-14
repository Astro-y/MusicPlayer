import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.15
import QtMultimedia 5.12

//底部工具栏

//定义一个容器
Rectangle{

    property var playList: []
    property int current: -1

    property int sliderValue: 0
    property int sliderFrom: 10
    property int sliderTo: 100

    property int currentPlayMode: 0
    property var playModeList: [{icon:"single-repeat",name:"单曲循环"},
        {icon:"repeat",name:"顺序播放"},
        {icon:"random",name:"随机播放"}]

    property bool playbackStateChangeCallbackEnabled: false

    property string musicName: "未知歌曲"
    property string musicArtist: "未知歌手"
    property string musicCover: "qrc:/imgs/player1"

    property int playingState: 0

    //确保容器填充其父元素
    Layout.fillWidth: true
    //设置容器的高度
    height: 48
    //设置容器的背景为青色
    color:"#1500AAAA"

    //行布局
    RowLayout{
        //填充满其父元素
        anchors.fill: parent
        //占位符
        Item{
            Layout.preferredWidth: parent.width/10
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        MusicIconButton{
            //设置图片来源
            iconSource: "qrc:/imgs/previous"
            //设置图片的宽度
            iconWidth: 32
            //设置图片的高度
            iconHeight: 32
            //设置按钮的工具提醒
            toolTip: "上一首"
            onClicked: playPrevious()
        }
        MusicIconButton{
            iconSource: playingState===0?"qrc:/imgs/stop":"qrc:/imgs/pause"
            iconWidth: 32
            iconHeight: 32
            toolTip: playingState===0?"播放":"暂停"
            onClicked: playOrPause()
        }
        MusicIconButton{
            iconSource: "qrc:/imgs/next"
            iconWidth: 32
            iconHeight: 32
            toolTip: "下一首"
            onClicked: playNext("")
        }
        Item{
            visible: !layoutHeaderView.isSmallWindow
            Layout.preferredWidth: parent.width/2
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.topMargin: 20

            //显示歌曲名称
            Text{
                anchors.left: slider.left
                anchors.bottom: slider.top
                anchors.leftMargin: 5
                text:musicName+"-"+musicArtist
                font.family: window.mFONT_FAMILY
                color: "#ffffff"
            }
            //显示歌曲时间
            Text{
                id:timeText
                anchors.right: slider.right
                anchors.bottom: slider.top
                anchors.rightMargin: 5
                text:"00:00/00:00"
                font.family: window.mFONT_FAMILY
                color: "#ffffff"
            }

            //进度条
            Slider{
                id:slider
                width: parent.width
                Layout.fillWidth: true
                value:sliderValue
                from:sliderFrom
                to:sliderTo

                onMoved: {
                    mediaPlayer.seek(value)
                }

                height: 25
                background: Rectangle{
                    x:slider.leftPadding
                    y:slider.topPadding+(slider.availableHeight-height)/2
                    width: slider.availableWidth
                    height: 4
                    radius: 2
                    color:"#e9f4ff"
                    Rectangle{
                        width:slider.visualPosition*parent.width
                        height: parent.height
                        color:"#8cecf3"
                        radius: 2
                    }

                }
                handle:Rectangle{
                    x:slider.leftPadding+(slider.availableWidth-width)*slider.visualPosition
                    y:slider.topPadding+(slider.availableHeight-height)/2
                    width: 15
                    height: 15
                    color: "#f0f0f0"
                    border.color: "#73a7ab"
                    border.width: 0.5

                }
            }

        }

        MusicBorderImage{
            visible: !layoutHeaderView.isSmallWindow
            imgSrc: musicCover
            width: 50
            height: 45

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onPressed: {
                    parent.scale = 0.9
                    pageDetailView.visible = !pageDetailView.visible
                    pageHomeView.visible = !pageDetailView.visible
                    appBackground.showDefaultBackground = !appBackground.showDefaultBackground
                }
                onReleased: {
                    parent.scale = 1.0
                }
            }
        }

        MusicIconButton{
            Layout.preferredWidth: 50
            iconSource: "qrc:/imgs/favorite"
            iconWidth: 32
            iconHeight: 32
            toolTip: "我喜欢"
            onClicked: saveFavorite(playList[current])
        }
        MusicIconButton{
            Layout.preferredWidth: 50
            iconSource: "qrc:/imgs/"+playModeList[currentPlayMode].icon
            iconWidth: 32
            iconHeight: 32
            toolTip: playModeList[currentPlayMode].name
            onClicked: changePlayMode()
        }

        MusicIconButton {
            id:volumeIconButton
            Layout.preferredWidth: 50
            iconSource: "qrc:/imgs/volume"
            iconWidth: 32
            iconHeight: 32
            toolTip: "音量"
            onClicked: {
                volumePopup.open();
            }

        }

        Item{
            Layout.preferredWidth: parent.width/10
            Layout.fillWidth: true
        }

    }

    // 新增的弹出式音量条组件
    Popup {
        id: volumePopup
        visible: false
        x: volumeIconButton.x + volumeIconButton.width / 2 - width / 2
        y: volumeIconButton.y - height-10
        width: 40
        height: 150

        // 音量条组件
        Slider {
            id: volumeSlider
            height: 120
            value: mediaPlayer.volume
            from: 0
            to: 1
            orientation: Qt.Vertical
            width: 15

            onValueChanged: {
                mediaPlayer.volume = value;
                volumeProgressRectangle.height = (1 - value) * parent.height
                volumeSlider.handle.y = volumeProgressRectangle.y + volumeProgressRectangle.height - volumeSlider.handle.height
                updateVolumeText();

                // 根据音量值切换图标
                if (value === 0) {
                    volumeIconButton.iconSource = "qrc:/imgs/volume0"
                } else {
                    volumeIconButton.iconSource = "qrc:/imgs/volume"
                }
            }

            onPositionChanged: {
                volumeProgressRectangle.height = (1 - value) * parent.height
                volumeSlider.handle.y = volumeProgressRectangle.y + volumeProgressRectangle.height - volumeSlider.handle.height
                updateVolumeText();
            }

            background: Rectangle {
                width: parent.width
                height: parent.height
                radius: 5
                color: "#007FFF"

                Rectangle {
                    id: volumeProgressRectangle
                    width: parent.width
                    height: (1 - volumeSlider.visualPosition) * parent.height
                    color: "#e0e0e0"
                    border.color: "#4CAF50"
                    border.width: 2
                    radius: 4
                }
            }

            handle: Rectangle {
                width: 20
                height: 2
                color: "#ffffff"
                border.color: "#4CAF50"
                border.width: 2
                // 初始位置设置
                y: volumeSlider.availableHeight - height+100
                x: (parent.width - width) / 2
            }

            function updateVolumeText() {
                volumeValueText.text = (value * 100).toFixed(0) + "%";
            }
        }

        // 显示音量值的文本组件
        Text {
            id: volumeValueText
            text: ""
            font.family: window.mFONT_FAMILY
            color: "#000000"
            anchors.top: volumeSlider.bottom
            anchors.horizontalCenter: volumeSlider.horizontalCenter
            Layout.preferredHeight: 20
            font.pointSize: 11
        }
    }

    Component.onCompleted: {
        //从配置文件中拿到currentPlayMode
        currentPlayMode = settings.value("currentPlayMode",0)
    }

    onCurrentChanged: {
        playbackStateChangeCallbackEnabled = false
        playMusic(current)
    }

    //数据标准化
    function standardizeItem(item) {
        return {
            id: item.id,
            name: item.name.trim().toLowerCase(),
            artist: item.artist.trim().toLowerCase(),
            url: item.url? item.url.trim() : "",
            type: item.type? item.type.trim() : "",
            album: item.album? item.album.trim() : "本地音乐"
        };
    }

    //创建复合唯一键
    function createUniqueKey(item) {
        item = standardizeItem(item);
        var keys = [item.id, item.name, item.artist, item.album, item.url].sort();
        return keys.join("-");
    }

    function saveHistory(index=0){
        if(playList.length<index+1) return
        var item = playList[index]
        if(!item||!item.id) return
        var history = historySettings.value("history",[])
        //var i = history.findIndex(value=>value.id === item.id)
        var uniqueKey = createUniqueKey(item)
        var i = history.findIndex(value=>createUniqueKey(value)===uniqueKey)
        if(i>=0) history.splice(i,1)
        history.unshift({
                            id:item.id+"",
                            name:item.name+"",
                            artist:item.artist+"",
                            url:item.url?item.url:"",
                            type:item.type?item.type:"",
                            album:item.album?item.album:"本地音乐"
                        })
        if(history.length>500){
            //限制五百条
            history.pop()
        }
        historySettings.setValue("history",history)
    }

    function saveFavorite(value={}){
        if(!value||!value.id)return
        var favorite =  favoriteSettings.value("favorite",[])
        //var i =  favorite.findIndex(item=>value.id===item.id)
        var uniqueKey = createUniqueKey(value)
        var i = favorite.findIndex(item=>createUniqueKey(item)===uniqueKey)
        if(i>=0) favorite.splice(i,1)
        favorite.unshift({
                             id:value.id+"",
                             name:value.name+"",
                             artist:value.artist+"",
                             url:value.url?value.url:"",
                             type:value.type?value.type:"",
                             album:value.album?value.album:"本地音乐"
                         })
        if(favorite.length>500){
            //限制五百条数据
            favorite.pop()
        }
        favoriteSettings.setValue("favorite",favorite)
    }

    //上一曲
    function playPrevious(){
        if(playList.length<1) return
        switch(currentPlayMode){
        case 0:
        case 1:
            current = (current+playList.length-1)%playList.length
            break
        case 2:{
            var random = parseInt(Math.random()*playList.length)
            current = current === random ? random+1:random
            break
        }
        }
    }

    //暂停播放切换
    function playOrPause(){

        if(!mediaPlayer.source) return
        if(mediaPlayer.playbackState===MediaPlayer.PlayingState){
            mediaPlayer.pause()
        }else if(mediaPlayer.playbackState===MediaPlayer.PausedState){
            mediaPlayer.play()
        }

    }

    //下一曲
    function playNext(type='natural'){
        if(playList.length<1) return
        switch(currentPlayMode){
        case 0:
            if(type==='natural'){
                mediaPlayer.play()
                break
            }
        case 1:
            current = (current+1)%playList.length
            break
        case 2:{
            var random = parseInt(Math.random()*playList.length)
            current = current === random ? random+1:random
            break
        }
        }

    }

    function changePlayMode(){
        currentPlayMode = (currentPlayMode+1)%playModeList.length
        settings.setValue("currentPlayMode",currentPlayMode)
    }

    function playMusic(){
        if(current<0) return
        if(playList.length < current+1) return
        //获取播放链接
        if(playList[current].type==="1"){
            //播放本地音乐
            playLocalMusic()
        }
        else{
            //播放网络音乐
            playWebMusic()
        }
    }
    function playLocalMusic(){
        var currentItem = playList[current]
        mediaPlayer.source =currentItem.url
        mediaPlayer.play()
        saveHistory(current)
        musicName = currentItem.name
        musicArtist = currentItem.artist
        musicCover = "qrc:/imgs/player1"
        pageDetailView.lyrics = ["暂无歌词","暂无歌词","暂无歌词"]
    }
    function playWebMusic(){
        loading.open()
        //播放
        var id = playList[current].id
        if(!id) return
        //设置详细
        musicName = playList[current].name
        musicArtist = playList[current].artist

        function onReply(reply){
            loading.close()
            http.onReplySignal.disconnect(onReply)
            try{
                if(reply.length<1){
                    notification.openError("请求歌曲链接为空！	")
                    musicCover = "qrc:/imgs/player1"
                    pageDetailView.lyrics = ["暂无歌词","暂无歌词","暂无歌词"]
                    return
                }
                var data = JSON.parse(reply).data[0]
                var url = data.url
                var time = data.time
                //设置slider
                setSlider(0,time,0)
                if(!url) return

                var cover = playList[current].cover
                if(!cover){
                    //请求cover
                    getCover(id)
                }else{
                    musicCover = cover
                    getLyric(id)
                }
                mediaPlayer.source = url
                mediaPlayer.play()
                saveHistory(current)

                playbackStateChangeCallbackEnabled = true
            }catch(err){
                notification.openError("请求歌曲链接错误！	")
                musicCover = "qrc:/imgs/player1"
                pageDetailView.lyrics = ["暂无歌词","暂无歌词","暂无歌词"]
            }
        }

        http.onReplySignal.connect(onReply)
        http.connet("/song/url?id="+id)
    }

    function setSlider(from=0,to=1,value=0){
        sliderFrom = from
        sliderTo = to
        sliderValue = value

        var va_mm = parseInt(value/1000/60)+""
        va_mm = va_mm.length<2?"0"+va_mm:va_mm;
        var va_ss = parseInt(value/1000%60)+""
        va_ss = va_ss.length<2?"0"+va_ss:va_ss;

        var to_mm = parseInt(to/1000/60)+""
        to_mm = to_mm.length<2?"0"+to_mm:to_mm;
        var to_ss = parseInt(to/1000%60)+""
        to_ss = to_ss.length<2?"0"+to_ss:to_ss;

        timeText.text = va_mm+":"+va_ss+"/"+to_mm+":"+to_ss

    }

    function getCover(id){
        loading.open()
        function onReply(reply){
            http.onReplySignal.disconnect(onReply)
            loading.close()
            //请求歌词
            getLyric(id)
            try{
                if(reply.length<1){
                    notification.openError("请求歌曲图片为空！	")
                    musicCover = "qrc:/imgs/player1"
                    return
                }
                var song = JSON.parse(reply).songs[0]
                var cover = song.al.picUrl
                musicCover = cover
                if(musicName.length<1) musicName = song.name
                if(musicArtist.length<1) musicArtist = song.ar[0].name
            }catch(err){
                notification.openError("请求歌曲图片错误！	")
                musicCover = "qrc:/imgs/player1"
            }
        }
        http.onReplySignal.connect(onReply)
        http.connet("song/detail?ids="+id)
    }

    function getLyric(id){
        loading.open()
        function onReply(reply){
            loading.close()
            http.onReplySignal.disconnect(onReply)
            try{
                if(reply.length<1){
                    notification.openError("请求歌曲歌词为空！	")
                    pageDetailView.lyrics = ["暂无歌词","暂无歌词","暂无歌词"]
                    return
                }
                var lyric = JSON.parse(reply).lrc.lyric
                if(lyric.length<1) return
                var lyrics = (lyric.replace(/\[.*\]/gi,"")).split("\n")
                if(lyrics.length>0) pageDetailView.lyrics = lyrics
                var times = []
                lyric.replace(/\[.*\]/gi,function(match,index){
                    //match:[00:00.00]
                    if(match.length>2){
                        var time = match.substr(1,match.length-2)
                        var arr = time.split(":")
                        var timeValue = arr.length>0?parseInt(arr[0])*60*1000:0
                        arr = arr.length>1?arr[1].split("."):[0,0]
                        timeValue += arr.length>0?parseInt(arr[0])*1000:0
                        timeValue += arr.length>1?parseInt(arr[1])*10:0
                        times.push(timeValue)
                    }
                })

                mediaPlayer.times = times
            }catch(err){
                notification.openError("请求歌曲歌词错误！	")
                pageDetailView.lyrics = ["暂无歌词","暂无歌词","暂无歌词"]
            }

        }
        http.onReplySignal.connect(onReply)
        http.connet("lyric?id="+id)
    }

}

