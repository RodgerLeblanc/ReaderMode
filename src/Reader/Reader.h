/*
 * Reader.h
 *
 *  Created on: Nov 22, 2017
 *      Author: roger
 */

#ifndef READER_H_
#define READER_H_

#include <QObject>
#include <QtNetwork>

class Reader : public QObject
{
    Q_OBJECT

public:
    Reader(QString apiKey, QObject* parent = NULL);

    Q_INVOKABLE void read(QString url);

private slots:
    void onReadReply();

private:
    QByteArray apiKey;

signals:
    void htmlReady(QString html);
    void error(QString message);
};

#endif /* READER_H_ */
