#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include "httputils.h"

#include <QSslSocket>
#include "qdebug.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    qDebug()<< QSslSocket::sslLibraryBuildVersionString();

    //命名空间 主版本 次版本
    qmlRegisterType<HttpUtils>("MyUtils",1,0,"HttpUtils");

    //软件图标设置
    app.setWindowIcon(QIcon(":/imgs/music.ico"));

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/App.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
