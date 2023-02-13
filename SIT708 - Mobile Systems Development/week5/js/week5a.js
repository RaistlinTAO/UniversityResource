function loadApplication() {
    for (i = 0; i < colourList.length; i++) {
        CreateButtontag(colourList[i]);
    }
}

function CreateButtontag(innerText) {
    document.writeln("<button type=\"button\" style = \"background-color:" + innerText +
        ";\" onclick='SetBackgroundColour(\"" + innerText + "\")'>" + innerText + "</button>");
}

function randomiseBackgroundColour() {
    document.body.style.backgroundColor = colourList[Math.floor(Math.random() * 5)];
}

function SetBackgroundColour(colour) {
    document.body.style.backgroundColor = colour;
}