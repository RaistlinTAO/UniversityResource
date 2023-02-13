function displayStudentTable() {
    document.writeln("<table>");
    document.writeln("<tr>");
    document.writeln("<th>SID</th>");
    document.writeln("<th>Name</th>");
    document.writeln("<th>WAM</th>");
    document.writeln("<th>Grade</th>");
    document.writeln("</tr>");
    for (i = 0; i < studentList.length; i++) {
        document.writeln("<tr id='sd" + i + "'>");
        document.writeln("<td>" + studentList[i].sid + "</td>");
        document.writeln("<td>" + studentList[i].name + "</td>");
        document.writeln("<td>" + studentList[i].wom + "</td>");
        changerowcolour("sd" + i, false);
        if (studentList[i].wom < 50) {
            document.writeln("<td>FAIL</td>");
            changerowcolour("sd" + i, true)
        } else if (studentList[i].wom >= 50 && studentList[i].wom < 60) {
            document.writeln("<td>PASS</td>");
        } else if (studentList[i].wom >= 60 && studentList[i].wom < 70) {
            document.writeln("<td>CREDIT</td>");
        } else if (studentList[i].wom >= 70 && studentList[i].wom < 80) {
            document.writeln("<td>DISTINCTION</td>");
        } else if (studentList[i].wom > 80) {
            document.writeln("<td>HIGH DISTINCTION</td>");
        }

        document.writeln("</tr>");
    }
    document.writeln("</table>");

}

function changerowcolour(sid, fail) {
    if (fail) {
        document.getElementById(sid).style.backgroundColor = "red";
    }
    else {
        document.getElementById(sid).style.backgroundColor = "green";
    }
}