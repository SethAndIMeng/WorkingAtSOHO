
function seth_cookieWithName(name) {
    var value = "; " + document.cookie;
    var parts = value.split("; " + name + "=");
    if (parts.length == 2) return parts.pop().split(";").shift();
}

function seth_get3QUserIdentity() {
    var token = seth_cookieWithName("token");
    var sid = seth_cookieWithName("sid");
    return {
        "sid": sid,
        "token": token
    }
}