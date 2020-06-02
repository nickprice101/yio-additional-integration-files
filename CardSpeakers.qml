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
import QtQuick 2.12
import QtQuick.Controls 2.12
import Style 1.0

import Haptic 1.0

import "qrc:/basic_ui" as BasicUI

Rectangle {
    id: main
    width: parent.width; height: parent.height
    color: Style.color.dark
    radius: Style.cornerRadius

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    property var speakerModel
    property bool isCurrentItem: parent._currentItem
    property bool start: true

    onIsCurrentItemChanged: {
        if (isCurrentItem && start) {
            console.debug("LOAD SPEAKERS");
            start = false;
            obj.getSpeakers();
            obj.speakerModelChanged.connect(onFirstLoadComplete);
        }
        if (!isCurrentItem) {
            speakerListView.contentY = 0-120;
        }
    }


    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // FUNCTIONS
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    function onFirstLoadComplete(model) {
        main.speakerModel = model.model;
        obj.speakerModelChanged.disconnect(onFirstLoadComplete);
    }

    function onSpeakerModelChanged(model) {
        //if (speakerLoader) {
                //speakerLoader.item.albumModel = model;
                //speakerLoader.item.itemFlickable.contentY = 0;
        //}
        main.speakerModel = model.model;
        obj.speakerModelChanged.disconnect(onSpeakerModelChanged);
    }


    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // UI ELEMENTS
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    property alias swipeView: swipeView

    SwipeView {
        id: swipeView
        width: parent.width; height: parent.height
        currentIndex: 0
        interactive: false
        clip: true

        Item {
            property alias speakerListView: speakerListView

            ListView {
                id: speakerListView
                width: parent.width; height: parent.height-100
                spacing: 20
                anchors { top: parent.top; horizontalCenter: parent.horizontalCenter }
                maximumFlickVelocity: 6000
                flickDeceleration: 1000
                boundsBehavior: Flickable.DragAndOvershootBounds
                flickableDirection: Flickable.VerticalFlick
                clip: true
                cacheBuffer: 3000

                delegate: speakerThumbnail
                model: main.speakerModel

                ScrollBar.vertical: ScrollBar {
                    opacity: 0.5
                }

                header: Component {
                    Item {
                        width: parent.width; height: 120

                        Text {
                            id: title
                            color: Style.color.text
                            text: qsTr("My players") + translateHandler.emptyString
                            font { family: "Open Sans Bold"; weight: Font.Bold; pixelSize: 40 }
                            lineHeight: 1
                            anchors { left: parent.left; leftMargin: 30; top: parent.top; topMargin: 30 }
                        }
                    }
                }

                populate: Transition {
                    id: popTransition
                    SequentialAnimation {
                        PropertyAction { property: "opacity"; value: 0 }
                        PauseAnimation { duration: popTransition.ViewTransition.index*100 }
                        NumberAnimation { properties: "opacity"; from: 0; to: 1; duration: 300; easing.type: Easing.InExpo }
                    }
                }
            }

            Component {
                id: speakerThumbnail

                Item {
                    id: speakerThumbnailItem
                    width: parent.width-60; height: 80
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        id: speakerImage
                        width: 80; height: 80

                        Image {
                            source: item_image
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                        }
                    }

                    Text {
                        id: speakerTitleText
                        text: item_title
                        elide: Text.ElideRight
                        width: itemFlickable.width-60-speakerImage.width-20-80
                        wrapMode: Text.NoWrap
                        color: Style.color.text
                        anchors { left: speakerImage.right; leftMargin: 20; top: speakerImage.top; topMargin: item_subtitle == "" ? 26 : 12 }
                        font { family: "Open Sans Regular"; pixelSize: 25 }
                        lineHeight: 1
                    }

                    Text {
                        id: speakerSubTitleText
                        text: item_subtitle
                        elide: Text.ElideRight
                        visible: item_subtitle == "" ? false : true
                        width: speakerTitleText.width
                        wrapMode: Text.NoWrap
                        color: Style.color.text
                        opacity: 0.6
                        anchors { left: speakerTitleText.left; top: speakerTitleText.bottom; topMargin: 5 }
                        font { family: "Open Sans Regular"; pixelSize: 20 }
                        lineHeight: 1
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            Haptic.playEffect(Haptic.Click);
                            load(item_key, item_type);
                        }
                    }

                    BasicUI.ContextMenuIcon {
                        anchors { right: parent.right; verticalCenter: parent.verticalCenter }

                        mouseArea.onClicked: {
                            Haptic.playEffect(Haptic.Click);
                            contextMenuLoader.setSource("qrc:/basic_ui/ContextMenu.qml", { "width": itemFlickable.width, "id": item_key, "type": item_type, "list": item_commands })
                        }
                    }
                }
            }
        }

    }
}
