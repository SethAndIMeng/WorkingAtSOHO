
function seth_cookieWithName(name) {
    var value = "; " + document.cookie;
    var parts = value.split("; " + name + "=");
    if (parts.length == 2) return parts.pop().split(";").shift();
}

function seth_get3QUserIdentity() {
    var token = seth_cookieWithName("token");
    var sid = seth_cookieWithName("sid");
    var user_phone = seth_cookieWithName("user_phone");
    return {
        "sid": sid,
        "token": token,
        "user_phone": user_phone
    };
}

function seth_hideProxyInfo() {
    $("#salerInfo > .paimaizf-c-xx").hide();
    $("#salerInfo > .paimaizf-c-title").not(".agreement").hide();
    return true
}