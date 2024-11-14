#ifndef HTTPUTILS_H
#define HTTPUTILS_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <qsettings.h>

class HttpUtils : public QObject
{
    Q_OBJECT
public:
    explicit HttpUtils(QObject *parent = nullptr);

    Q_INVOKABLE void connet(QString url);
    Q_INVOKABLE void replyFinished(QNetworkReply* reply);
    Q_INVOKABLE bool setBaseUrl(QString newBaseUrl);
    Q_INVOKABLE void recoverBaseUrl();
    Q_INVOKABLE QString getBaseUrl();
    void saveBaseUrlToSettings();
    void loadBaseUrlFromSettings();

signals:
    void replySignal(QString reply);

private:
    QNetworkAccessManager* manager;
    QString DEFAULT_URL = "http://121.41.98.135:3000/";
    QString BASE_URL = "http://localhost:3000/";//网易云api地址
};

#endif // HTTPUTILS_H
