let docStyle = document.documentElement.style;
if (docStyle.filter == "invert(100%)") {
    docStyle.filter = "invert(0%)";
} else {
    docStyle.filter = "invert(100%)";
}
