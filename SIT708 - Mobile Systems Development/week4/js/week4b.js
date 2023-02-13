function loadApplication() {
    CreatePtag("test");
    CreateHtag(1,"test");
    var tempContent = CreateLabelledTextField("test","test","test");
    CreateDivtag(tempContent.label + tempContent.input + tempContent.button);
    CreateSpantag("test");
    CreateButtontag("Submit");
    CreateInputtag("test");
    //CC0 IMAGE

    CreateImgTag("https://images.pexels.com/photos/459793/pexels-photo-459793.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940");
};
function CreatePtag(innerText) {
    document.writeln("<p>" + innerText + "</p>");
}
function CreateHtag(level, innerText) {
    switch (level)
    {
        case 1:
            document.writeln("<h1>" + innerText + "</h1>");
            break;
        case 2:
            document.writeln("<h2>" + innerText + "</h2>");
            break;
        case 3:
            document.writeln("<h3>" + innerText + "</h3>");
            break;
    }
}
function CreateDivtag(content) {
    document.writeln("<div>" + content + "</div>");
}
function CreateSpantag(innerText) {
    document.writeln("<span>" + innerText + "</span>");
}
function CreateButtontag(innerText) {
    document.writeln("<button type=\"button\">" + innerText + "</button>");
}
function CreateInputtag(inputName) {
    document.writeln("<input type=\"text\" name=\""+inputName+"\">");
}
function CreateLabelledTextField(lblText, inputName, buttonText) {
    return {
        label: "<label>" + lblText + "</label>",
        input: "<input type=\"text\" name=\""+inputName+"\">",
        button: "<button type=\"button\">" + buttonText + "</button>"
    }
}
function CreateImgTag(Source) {
    document.writeln("<img src=\"" + Source + "\">");
}