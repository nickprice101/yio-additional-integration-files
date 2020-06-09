# Project Include file for weather model
# MUST be included by remote-software
# May be included by integration plugins with mediaplayer functionality

INCLUDEPATH += $$PWD/src

# Model files
HEADERS += \
    $$PWD/src/yio-model/mediaplayer/albummodel_mediaplayer.h \
    $$PWD/src/yio-model/mediaplayer/searchmodel_mediaplayer.h \
    $$PWD/src/yio-model/mediaplayer/speakermodel_mediaplayer.h

SOURCES += \
    $$PWD/src/yio-model/mediaplayer/albummodel_mediaplayer.cpp \
    $$PWD/src/yio-model/mediaplayer/searchmodel_mediaplayer.cpp \
    $$PWD/src/yio-model/mediaplayer/speakermodel_mediaplayer.cpp
