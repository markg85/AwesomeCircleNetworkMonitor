import QtQuick 2.0

Rectangle {
    width: 800
    height: 600
    color: Qt.rgba(0.11, 0.13, 0.24)

    Canvas {
        id:canvas
        width:400
        height:400
        antialiasing: true
        anchors.centerIn: parent

        property string background: "rgb(11, 13, 24)"
        property string lineColor: "rgb(28, 67, 81)"
        property int outerCircleRadiusWithOffset: 200
        property int outerCircleRadius: 195
        property int innerCircleRadius: 50
        property int lineWidth:2


        onPaint: {
            var ctx = canvas.getContext('2d');
            ctx.save();
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            ctx.fillStyle = canvas.background
            //ctx.fillRect(0, 0, canvas.width, canvas.height)

            ctx.strokeStyle = canvas.lineColor;
            ctx.lineWidth = canvas.lineWidth;

            ctx.beginPath()
            ctx.arc(outerCircleRadiusWithOffset,outerCircleRadiusWithOffset,canvas.outerCircleRadius,0,Math.PI*2,true); // Outer circle
            ctx.stroke();            

            ctx.beginPath()
            ctx.arc(outerCircleRadiusWithOffset,outerCircleRadiusWithOffset,innerCircleRadius,0,Math.PI*2,true); // Inner circle
            ctx.stroke();

            /*
            for(var i = 0; i < Math.PI*2; i += 0.1)
            {
                ctx.beginPath()
                ctx.moveTo(canvas.circleWidth/2*Math.cos(i) + canvas.circleWidth/2, canvas.height/2 - canvas.height/2*Math.sin(i))
                ctx.lineTo(canvas.circleWidth/2,canvas.height/2)
                ctx.stroke();
            }
            */

            for(var i = 0; i < 360; i += 30)
            {
                var angle = i/180*Math.PI
                var fromXPos = outerCircleRadius*Math.cos(angle) + outerCircleRadiusWithOffset
                var fromYPos = outerCircleRadiusWithOffset - outerCircleRadius*Math.sin(angle)
                var toXPos = innerCircleRadius*Math.cos(angle) + outerCircleRadiusWithOffset
                var toYPos = outerCircleRadiusWithOffset - innerCircleRadius*Math.sin(angle)
                ctx.beginPath()
                ctx.moveTo(fromXPos, fromYPos)
                ctx.lineTo(toXPos, toYPos)
                //ctx.lineTo(outerCircleRadiusWithOffset,outerCircleRadiusWithOffset)
                ctx.stroke();
            }
            ctx.restore();
        }
    }

    ParticleLine {
        id: particleDownlink
        anchors.fill: canvas
        colors: ["cyan", "green", "green", "blue", "blue", "cyan"]
    }

    ParticleLine {
        id: particleUplink
        anchors.fill: canvas
        colors: ["magenta", "orange", "orange", "purple", "purple", "magenta"]
    }

    function testParticles() {

        var outerCircleRadiusWithOffset = 200
        var outerCircleRadius = 195
        var innerCircleRadius = 50
        var toXPos = canvas.width/2
        var toYPos = canvas.height/2

        for(var i = 0; i < 360; i += 30)
        {
            var angle = i/180*Math.PI
            var fromXPos = outerCircleRadius*Math.cos(angle) + outerCircleRadiusWithOffset
            var fromYPos = outerCircleRadiusWithOffset - outerCircleRadius*Math.sin(angle)
            particleDownlink.burstParticle(fromXPos, fromYPos, toXPos, toYPos)
        }
    }

    function particlesAroundCircle(i) {

        //i = (((Math.PI*2)/50000)*i)
        var outerCircleRadiusWithOffset = 200
        var outerCircleRadius = 195
        var innerCircleRadius = 50
//        var toXPos = canvas.width/2
//        var toYPos = canvas.height/2

        var angle = i/180*Math.PI
        var fromXPos = outerCircleRadius*Math.cos(angle) + outerCircleRadiusWithOffset
        var fromYPos = outerCircleRadiusWithOffset - outerCircleRadius*Math.sin(angle)
        var toXPos = innerCircleRadius*Math.cos(angle) + outerCircleRadiusWithOffset
        var toYPos = outerCircleRadiusWithOffset - innerCircleRadius*Math.sin(angle)

        if((Math.random() * 2) >= 1) {
            particleDownlink.burstParticle(fromXPos, fromYPos, toXPos, toYPos, true)
        } else {
            particleUplink.burstParticle(toXPos, toYPos, fromXPos, fromYPos)
        }
    }

    Timer {
        id: myTimer
        property int iVal: 0
        interval: 250; running: true; repeat: true
        onTriggered: {
            //particlesAroundCircle(iVal)
            particlesAroundCircle(Math.random() * 360)
            iVal += 15
        }
    }

    MouseArea {
        anchors.fill: canvas

        onPressed: {
            //testparticleDownlinks()
            //particleDownlink.burstparticleDownlink(100, 100, 200, 200)
        }
    }
}

