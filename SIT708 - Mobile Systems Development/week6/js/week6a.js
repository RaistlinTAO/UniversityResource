window.onload = function () {

    //to id the win situation, win condition = all true
    var flggCircle = false;
    var flagRect = false;
    var flgPolygpm = false;

    document.getElementById('CrossRedsquare').style.visibility = "hidden";
    document.getElementById('CrossRedcircle').style.visibility = "hidden";
    document.getElementById('CrossRedtriangle').style.visibility = "hidden";
    //Prepare Drag-able elements
    document.getElementById('svgCircle').setAttribute("draggable", "true");
    document.getElementById('svgRect').setAttribute("draggable", "true");
    document.getElementById('svgPolygon').setAttribute("draggable", "true");
    document.getElementById('svgCircle').ondragstart = onDragStart;
    document.getElementById('svgRect').ondragstart = onDragStart;
    document.getElementById('svgPolygon').ondragstart = onDragStart;
    function onDragStart(event) {
        //Put the id here, then later judge if win or not
        event.dataTransfer.setData("Text", event.target.id);
    }
    //Prepare contains
    document.getElementById('svgCircleCover').ondragover = Dragover;
    document.getElementById('svgRectCover').ondragover = Dragover;
    document.getElementById('svgPolygonCover').ondragover = Dragover;
    document.getElementById('svgCircleCover').ondrop = dropDone;
    document.getElementById('svgRectCover').ondrop = dropDone;
    document.getElementById('svgPolygonCover').ondrop = dropDone;
    function Dragover(event) {
        event.preventDefault();
    }

    function dropDone(event) {
        var data = event.dataTransfer.getData("Text");
        //Mark a red X when error
        if(event.target.id === "svgCircleCover")
        {
            document.getElementById("CrossRedcircle").style.visibility = "visible";
            document.getElementById("svgCircleCover").appendChild(document.getElementById("CrossRedcircle"));
        }
        if(event.target.id === "svgRectCover")
        {
            document.getElementById("CrossRedsquare").style.visibility = "visible";
            document.getElementById("svgRectCover").appendChild(document.getElementById("CrossRedsquare"));
        }
        if(event.target.id === "svgPolygonCover")
        {
            document.getElementById("CrossRedtriangle").style.visibility = "visible";
            document.getElementById("svgPolygonCover").appendChild(document.getElementById("CrossRedtriangle"));
        }
        //Switch parent when the sharp is right
        if(data === "svgCircle" &&  event.target.id === "svgCircleCover")
        {
            document.getElementById("CrossRedcircle").style.visibility = "hidden";
            document.getElementById("CrossRedsquareCover").appendChild(document.getElementById("CrossRedcircle"));
            document.getElementById("svgCircleCover").appendChild(document.getElementById("svgCircle"));
            flggCircle = true;
        }
        else if (data === "svgRect" &&  event.target.id ==="svgRectCover")
        {
            document.getElementById("CrossRedsquare").style.visibility = "hidden";
            document.getElementById("CrossRedsquareCover").appendChild(document.getElementById("CrossRedsquare"));
            document.getElementById("svgRectCover").appendChild(document.getElementById("svgRect"));
            flagRect = true;
        }
        else if (data === "svgPolygon" &&  event.target.id ==="svgPolygonCover")
        {
            document.getElementById("CrossRedtriangle").style.visibility = "hidden";
            document.getElementById("CrossRedtriangleCover").appendChild(document.getElementById("CrossRedtriangle"));
            document.getElementById("svgPolygonCover").appendChild(document.getElementById("svgPolygon"));
            flgPolygpm = true;
        }
        if(flggCircle && flagRect && flgPolygpm)
        {
            fadeinbgColour();
        }
        event.preventDefault();
    }
    //Fade in without jquery
    function fadeinbgColour() {
        var temp = 1;
        var intervalId = setInterval(function () {
            //Basically change the alpha value of rgb
            document.getElementById("bg").style.backgroundColor = "rgba(0,255,0," + temp/100 + ")";
            if (++temp > 100) clearInterval(intervalId);
        }, 200);
    }
};