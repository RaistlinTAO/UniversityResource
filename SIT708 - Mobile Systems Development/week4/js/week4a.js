var playerName;
var playerLocation;

var test1 = 'value';
window.test2 = 'value';
console.log( delete window.test1 ); // not deleted
console.log( delete window.test2 ); // deleted
console.log( test1 );  // 'value'
console.log( test2 );  // ERROR

function loadApplication() {
    configureGameUI();
    displayPlayerName();
    displayCurrentLocation();
    (function() {
        var playerName = "MM"; // `a` is NOT a property of `window` now

        function foo() {
            document.getElementById("playerName").innerText = playerName;   // Alerts "0", because `foo` can access `a`
        }
    })();
};

function configureGameUI(){
    //Inside loadApplication() function, call two functions: displayPlayerName, and
    document.writeln("<p id=\"playerName\">" + playerName + "</p>");
    document.writeln("<p id=\"playerLocation\">" + playerLocation + "</p>");
    displayPlayerName();
    displayCurrentLocation();

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
    //7. displayCurrentLocation should output to console the current location.
    //console.log(playerLocation);
    //8. Change displayCurrentLocation to not just get the current location, but to
    //look up the location’s description inside gameLevels.
    //console.log(gameLevels["Room A"].description);

    document.getElementById("playerLocation").innerText = gameLevels["Room A"].description;
}