/******************************************************************************
 *
 * Copyright (C) 2018-2019 Marton Borzak <hello@martonborzak.com>
 *
 * This file is part of the YIO-Remote software project.
 *
 * YIO-Remote software is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * YIO-Remote software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with YIO-Remote software. If not, see <https://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *****************************************************************************/

#pragma once

#include <QAbstractListModel>
#include <QObject>
#include <QVariant>
#include <QtDebug>

class SpeakerModelItem {
 public:
    SpeakerModelItem(const QString& key, const QString& name, const QString& description, const QString& type,
              const QString& imageUrl, const QVariant& commands, const QVariant& supported)
        : m_key(key), m_name(name), m_description(description), m_type(type), m_imageUrl(imageUrl), m_commands(commands), m_supported(supported) {}

    QString  item_key() const { return m_key; }
    QString  item_name() const { return m_name; }
    QString  item_description() const { return m_description; }
    QString  item_type() const { return m_type; }
    QString  item_imageUrl() const { return m_imageUrl; }
    QVariant item_commands() const { return m_commands; }
    QVariant item_supported() const { return m_supported; }

 private:
    QString  m_key;
    QString  m_name;
    QString  m_description;
    QString  m_type;
    QString  m_imageUrl;
    QVariant m_commands;
    QVariant m_supported;
};

class SpeakerListModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(int count READ count WRITE setCount NOTIFY countChanged)

 public:
    enum SearchRoles { KeyRole = Qt::UserRole + 1, NameRole, DescriptionRole, TypeRole, ImageUrlRole, CommandsRole, SupportedRole };

    explicit SpeakerListModel(QObject* parent = nullptr);
    ~SpeakerListModel() {}

    int                    count() const;
    int                    rowCount(const QModelIndex& p = QModelIndex()) const;
    QVariant               data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

    void append(const SpeakerModelItem& o);

 public slots:  // NOLINT open issue: https://github.com/cpplint/cpplint/pull/99
    void setCount(int count);

 signals:
    void countChanged(int count);

 private:
    int              m_count;
    QList<SpeakerModelItem> m_data;
};

class SpeakerModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString id READ id NOTIFY idChanged)
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    Q_PROPERTY(QString description READ description NOTIFY descriptionChanged)
    Q_PROPERTY(QString type READ type NOTIFY typeChanged)
    Q_PROPERTY(QString imageUrl READ imageUrl NOTIFY imageUrlChanged)
    Q_PROPERTY(QObject* model READ model NOTIFY modelChanged)
    Q_PROPERTY(QStringList commands READ commands NOTIFY commandsChanged)
    Q_PROPERTY(QStringList supported READ supported NOTIFY supportedChanged)

 public:
    SpeakerModel(QObject* parent = nullptr, const QString& id = "", const QString& name = "",
                const QString& description = "", const QString& type = "", const QString& imageUrl = "",
                const QStringList& commands = {}, const QStringList& supported = {})
        : m_id(id), m_name(name), m_description(description), m_type(type), m_imageUrl(imageUrl), m_commands(commands) {
        Q_UNUSED(parent)
    }
    ~SpeakerModel() {}

    QString     id() { return m_id; }
    QString     name() { return m_name; }
    QString     description() { return m_description; }
    QString     type() { return m_type; }
    QString     imageUrl() { return m_imageUrl; }
    QObject*    model() { return m_model; }
    QStringList commands() { return m_commands; }
    QStringList supported() { return m_supported; }

    void addItem(const QString& key, const QString& name, const QString& description, const QString& type,
                 const QString& imageUrl, const QVariant& commands, const QVariant& supported);

 signals:
    void idChanged();
    void nameChanged();
    void descriptionChanged();
    void typeChanged();
    void imageUrlChanged();
    void modelChanged();
    void commandsChanged();
    void supportedChanged();

 private:
    QString     m_id;
    QString     m_name;
    QString     m_description;
    QString     m_type;
    QString     m_imageUrl;
    QObject*    m_model = new SpeakerListModel();
    QStringList m_commands;
    QStringList m_supported;
};
