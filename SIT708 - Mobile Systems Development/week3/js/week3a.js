window.onload = function() {
    console.log("startup code running");
    createHeading1("This is H1 test");
    createHeading2("This is H2 test");
    createHeading3("This is H3 test");
    createP("This is P test");
    loadApp();
};

function createHeading1(titleText) {
    document.writeln("<h1>" + titleText + "</h1>");
}

function createHeading2(titleText) {
    document.writeln("<h2>" + titleText + "</h2>");
}

function createHeading3(titleText) {
    document.writeln("<h3>" + titleText + "</h3>");
}

function createP(titleText) {
    document.writeln("<p>" + titleText + "</p>");
}