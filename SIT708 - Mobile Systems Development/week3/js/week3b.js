function loadApp() {
    createImage('images/1.jpg');

    document.getElementById("whatever").onclick = function() {
        console.log("The user just clicked on the image.");
        document.getElementById("whatever").style.opacity = 0.5;
    };
}

function createImage(imageSource) {
    document.writeln("<img id='whatever' src = '" + imageSource + "'/>");
}

