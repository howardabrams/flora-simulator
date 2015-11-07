function makeMemory(size) {
    size = size || 256;
    return _.fill(Array(size), 0);
}

$( function() {

    $.get("ada.coffee", function(ada) {
        if (location.pathname.endsWith("tutorial.html")) {
            $.get("tutorial.coffee", function(hardware) {
                var coffee = window.CoffeeScript;
                var code = coffee.compile(ada + hardware);
                eval(code);
            });
        } else {
            $.get("hardware.coffee", function(hardware) {
                var coffee = window.CoffeeScript;
                var code = coffee.compile(ada + hardware);
                eval(code);
            });
        }
    });

});
