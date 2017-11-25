/*
 * Reader.cpp
 *
 *  Created on: Nov 22, 2017
 *      Author: roger
 */

#include "Reader.h"
#include <bb/data/JsonDataAccess>

Reader::Reader(QString apiKey, QObject* parent) :
    QObject(parent)
{
    this->apiKey = apiKey.toUtf8();
}

void Reader::read(QString url) {
    QNetworkRequest request(QString("https://mercury.postlight.com/parser?url=%1").arg(url));
    request.setRawHeader("Content-Type", "application/json");
    request.setRawHeader("x-api-key", apiKey);

    QNetworkAccessManager* nam = new QNetworkAccessManager(this);
    QNetworkReply* reply = nam->get(request);
    connect(reply, SIGNAL(finished()), this, SLOT(onReadReply()));
    connect(reply, SIGNAL(finished()), nam, SLOT(deleteLater()));
}

void Reader::onReadReply() {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());
    if (reply) {
        if (reply->error() == QNetworkReply::NoError) {
            const int available = reply->bytesAvailable();
            if (available > 0) {
                bb::data::JsonDataAccess ja;
                QVariantMap map = ja.loadFromBuffer(reply->readAll()).toMap();
                if (map.contains("content"))
                    emit this->htmlReady(map["content"].toString());
                else
                    emit error(tr("No content could be retrieved."));
            }
            else {
                emit this->error(tr("Empty response from server."));
            }
        } // end of : if (reply->error() == QNetworkReply::NoError)
        else {
            emit this->error(reply->errorString());
        }
    }  // end of : if (reply)
    else {
        emit this->error(tr("There was no response."));
    }

    reply->deleteLater();
}
