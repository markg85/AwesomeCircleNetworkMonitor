/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtQuick.Particles 2.0

Item {
    id: root
    property bool directionOutTooIn: false

    function burstParticle(fromX, fromY, toX, toY, reverse) {
        trailsNormal.setToPosition(toX, toY)
        trailsNormal.burst(1, fromX, fromY)

        if(directionOutTooIn)
        {
            trailsNormal2.setToPosition(root.width/2, root.height/2)
            trailsNormal2.burst(1, fromX, fromY)
        }
        else
        {
            trailsNormal2.setToPosition(fromX, fromY)
            trailsNormal2.burst(1, fromX, fromY)
        }
    }

    property var colors: ["cyan", "green", "green", "blue", "blue", "cyan"]

    ParticleSystem { id: sys2 }
    ImageParticle {
        system: sys2
        source: "images/particle.png"
        color: particleA.color
        groups: ["A", "B"]
        alpha: 0
        colorVariation: 0.3
    }
    ImageParticle {
        system: sys2
        source: "images/particle.png"
        color: particleA.color
        groups: ["C"]
        alpha: 0
        colorVariation: 0.6
    }
    ParticleSystem { id: sys1 }
    ImageParticle {
        system: sys1
        source: "images/particle.png"
        color: colors[0]
        groups: ["A", "B"]
        alpha: 0
        id: particleA
        SequentialAnimation on color {
            loops: Animation.Infinite
            ColorAnimation {
                from: colors[0]
                to: colors[1]
                duration: 2000
            }
            ColorAnimation {
                from: colors[2]
                to: colors[3]
                duration: 2000
            }
            ColorAnimation {
                from: colors[4]
                to: colors[5]
                duration: 2000
            }
        }
        colorVariation: 0.3
    }

    TrailEmitter {
        id: trail
        anchors.fill: parent
        system: sys1
        group: "A"
        follow: "B"

        emitRatePerParticle: 75
        lifeSpan: 500
        velocity: PointDirection {xVariation: 4; yVariation: 4;}
        acceleration: PointDirection {xVariation: 50; yVariation: 50;}

        size: 8
        sizeVariation: 4
    }


    Emitter {
        id: trailsNormal
        system: sys1
        group: "B"

        emitRate: 0
        lifeSpan: 675
        enabled: false

        property int toX: 0
        property int toY: 0

        function setToPosition(toX, toY) {
            trailsNormal.toX = toX
            trailsNormal.toY = toY
        }

//        velocity: PointDirection {xVariation: 100; yVariation: 100;}
        velocity: TargetDirection {
            targetX: trailsNormal.toX
            targetY: trailsNormal.toY
            proportionalMagnitude: true
            magnitude: 1.5
        }
        //acceleration: PointDirection {xVariation: 10; yVariation: 10;}
        velocityFromMovement: 1

        size: 8
        //sizeVariation: 4
    }


    TrailEmitter {
        id: trai2
        anchors.fill: parent
        system: sys2
        group: "A"
        follow: "B"

        emitRatePerParticle: 50
        lifeSpan: 300

        velocity: TargetDirection {
            targetX: root.width/2
            targetY: root.height/2
            proportionalMagnitude: true
            magnitude: (root.directionOutTooIn) ? 1.1 : -0.3
            targetVariation: (root.directionOutTooIn) ? 20 : 80
        }
        acceleration: TargetDirection {
            targetX: root.width/2
            targetY: root.height/2
        }

        size: 8
        sizeVariation: 4
    }

    TrailEmitter {
        anchors.fill: parent
        system: sys2
        group: "C"
        follow: "A"

        emitRatePerParticle: 5
        lifeSpan: 350

        velocity: TargetDirection {
            targetX: root.width/2
            targetY: root.height/2
            proportionalMagnitude: true
            magnitude: (root.directionOutTooIn) ? 1.1 : -0.3
            targetVariation: (root.directionOutTooIn) ? 20 : 80
        }
        acceleration: TargetDirection {
            targetX: root.width/2
            targetY: root.height/2
        }

        size: 4
        sizeVariation: 4
    }

    Emitter {
        id: trailsNormal2
        system: sys2
        group: "B"

        emitRate: 0
        lifeSpan: 350
        enabled: false

        property int toX: 0
        property int toY: 0

        function setToPosition(toX, toY) {
            trailsNormal2.toX = toX
            trailsNormal2.toY = toY
        }

        size: 16
    }
}
