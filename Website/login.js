
function onClick() {
    var user = document.getElementsByName("username")[0].value;
    var pass = document.getElementsByName("password")[0].value;
    console.log(user);
    console.log(pass);
    if (user == "abcd") {
        window.location = "index.html";
    }
}