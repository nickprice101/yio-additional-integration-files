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

import QtQuick 2.11
import Haptic 1.0
import Style 1.0

Rectangle {
    id: main
    width: parent.width; height: 100+(80*list.length)
    radius: Style.cornerRadius
    color: Style.color.background

    property var list: []
    property string id
    property string type

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // STATES
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    state: "closed"

    Component.onCompleted: {
        state = "open";
    }


    states: [
        State { name: "closed";
            PropertyChanges {target: main; y: main.height; enabled: false }
        },
        State { name: "open";
            PropertyChanges {target: main; y: 0; enabled: true }
        }
    ]
    transitions: [
        Transition {to: "closed";
            SequentialAnimation {
                PropertyAnimation { target: main; properties: "y"; easing.type: Easing.OutExpo; duration: 300 }
            }
        },
        Transition {to: "open";
            SequentialAnimation {
                PropertyAnimation { target: main; properties: "y"; easing.type: Easing.OutExpo; duration: 300 }
            }
        }
    ]

    Flow {
        anchors.fill: parent
        spacing: 0

        Item { width: main.width; height: 20 }

        Repeater {
            model: list

            Item {
                width: main.width; height: 80

                Text {
                    id: icon
                    color: Style.color.text
                    text: {
                        if (list[index] === "PLAY")
                            return Style.icon.music
                        else if (list[index] === "QUEUE")
                            return Style.icon.playlist
                        else if (list[index] === "SHUFFLE")
                            return Style.icon.music
                        else if (list[index] === "CONNECT")
                            return Style.icon.speakers
                        else if (list[index] === "SONGRADIO")
                            return Style.icon.radio
                        else
                            return ""
                    }
                    renderType: Text.NativeRendering
                    width: 70; height: 70
                    verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
                    font { family: "icons"; pixelSize: 80 }
                    anchors { left: parent.left; leftMargin: 20; verticalCenter: parent.verticalCenter }
                }

                Text {
                    text: {
                        if (list[index] === "PLAY")
                            return "Play"
                        else if (list[index] === "QUEUE")
                            return "Add to queue"
                        else if (list[index] === "SHUFFLE")
                            return "Shuffle play"
                        else if (list[index] === "CONNECT")
                            return "Connect"
                        else if (list[index] === "SONGRADIO")
                            return "Go to song radio"
                        else
                            return "Not supported"
                    }
                    color: Style.color.text
                    anchors { left: icon.right; leftMargin: 20; verticalCenter: parent.verticalCenter }
                    font: Style.font.button
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Haptic.playEffect(Haptic.Click);
                        if (list[index] === "PLAY")
                            obj.playMedia(id, type);
                        else if (list[index] === "QUEUE")
                            obj.addToQueue(id, type);
                        else if (list[index] === "SHUFFLE")
                            obj.shufflePlay(id, type);
                        else if (list[index] === "CONNECT")
                            obj.changeSpeaker(id);
                        else if (list[index] === "SONGRADIO")
                            obj.songRadio(id, type);
                        else
                            return "Not supported"

                        main.state = "closed";
                    }
                }
            }
        }

        Item {
            width: main.width; height: 80

            Text {
                text: qsTr("Cancel") + translateHandler.emptyString
                horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                color: Style.color.text
                opacity: 0.5
                font { family: "Open Sans Regular"; pixelSize: 25 }
                lineHeight: 1
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Haptic.playEffect(Haptic.Click);
                    main.state = "closed";
                }
            }
        }
    }
}
