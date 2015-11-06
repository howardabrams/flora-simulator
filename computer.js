function makeMemory(size) {
    size = size || 256;
    return _.fill(Array(size), 0);
}

$( function() {

    $.get("ada.coffee", function(ada) {
        $.get("hardware.coffee", function(hardware) {
            var coffee = window.CoffeeScript;
            var code = coffee.compile(ada + hardware);
            eval(code);
        });
    });

});
