#include "httputils.h"


HttpUtils::HttpUtils(QObject *parent) : QObject{parent}
{
    manager = new QNetworkAccessManager(this);
    connect(manager,SIGNAL(finished(QNetworkReply*)),this,SLOT(replyFinished(QNetworkReply*)));

}

void HttpUtils::connet(QString url)
{
    QNetworkRequest request;
    request.setUrl(QUrl(BASE_URL+url));//请求地址
    manager->get(request);//让manager发起get请求
    loadBaseUrlFromSettings();
}

void HttpUtils::replyFinished(QNetworkReply *reply)
{
    emit replySignal(reply->readAll());
}

bool HttpUtils::setBaseUrl(QString newBaseUrl)
{
    if(newBaseUrl=="") return false;
    BASE_URL = newBaseUrl;
    saveBaseUrlToSettings();
    return true;
}

void HttpUtils::recoverBaseUrl()
{
    BASE_URL = DEFAULT_URL;
    saveBaseUrlToSettings();
}

QString HttpUtils::getBaseUrl()
{
    if(BASE_URL==DEFAULT_URL)
        return "默认URL";
    else
        return BASE_URL;
}

void HttpUtils::saveBaseUrlToSettings()
{
    QSettings settings("HDZX", "CloudMusicPlayer"); // 根据实际情况修改组织名和应用名
    settings.setValue("BASE_URL", BASE_URL);
}

void HttpUtils::loadBaseUrlFromSettings()
{
    QSettings settings("HDZX", "CloudMusicPlayer");
    if (settings.contains("BASE_URL")) {
        BASE_URL = settings.value("BASE_URL").toString();
    }
}
