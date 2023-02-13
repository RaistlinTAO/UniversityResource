var playerName;
var playerLocation;
var locationFlag = true; //Bool, true = Room A

function loadApplication() {
    configureGameUI();
    //displayPlayerName();
    //displayCurrentLocation();
    //This from UI.JS
    CreateMoveButton(locationFlag);
};

function configureGameUI(){
    //Inside loadApplication() function, call two functions: displayPlayerName, and
    document.writeln("<p id=\"playerName\">" + playerName + "</p>");
    document.writeln("<p id=\"playerLocation\">" + playerLocation + "</p>");
    document.writeln("<button id=\"move\" onclick='movePlayer()'>Move to Library</button>");
    displayPlayerName();
    displayCurrentLocation();
}

function movePlayer() {
    locationFlag = !locationFlag;
    displayCurrentLocation();
    CreateMoveButton(locationFlag);
}

function displayPlayerName() {
    //6. displayPlayerName should output to console the current player name.
    //console.log(playerName);
    //playerName = playerSettings.name;
    document.getElementById("playerName").innerText = fetchPlayerName();
}

function fetchPlayerName() {
    return playerSettings.name;
}

function displayCurrentLocation() {
    switch (locationFlag)
    {
        case true:
            document.getElementById("playerLocation").innerText = gameLevels["Room A"].description;
            break;
        case false:
            document.getElementById("playerLocation").innerText = gameLevels["Library"].description;
            break;
    }
}