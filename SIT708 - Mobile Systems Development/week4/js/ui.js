function CreateMoveButton(location) {
    if(location)
    {
        document.getElementById("move").innerText = "Move to Library";
        //document.writeln("<button id=\"move\" onclick='movePlayer()'>Move to Library</button>");
    }
    else
    {
        document.getElementById("move").innerText = "Move to Room A";
        //document.writeln("<button id=\"move\" onclick='movePlayer()'>Move to Room A</button>");
    }
}