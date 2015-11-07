# This global variable holds the "state" to whether the memory and
# other values are shown in decimal or hexadecimal

showDecimal = true

getNumberDisplay = (value) ->
        if showDecimal
                value.toString()
        else
                if value < 16
                        "0" + value.toString(16)
                else
                        value.toString(16)

# SYSTEM FUNCTIONS

loadSystem = ->
        data = loadMemory( $("#input").val() )
        heap = _.fill( Array(256 - data.length), 0)
        memory = data.concat(heap)
        pointer = 0

        load()
        updateSystem()
        $("#step").prop("disabled",false);

stepSystem = ->
        if memory[pointer] == 0
                $("#step").prop("disabled",true);
        else
                step()
        updateSystem()

contSystem = ->
        process()
        updateSystem()

# HELPER FUNCTIONS

error = ->
     debug "ERROR"

debug = (msg...) ->
     # msg.push "Processor:"
     # msg.push registerX
     # msg.push "Memory:"
     # msg.push memory

     console.log msg...

# ----------------------------------------------------------------------
# The parsing system is quite simplistic. We parse everything into
# tokens, and convert them to their numeric equivalent:
# ----------------------------------------------------------------------

notEmpty = _.negate _.isEmpty

# Our string to number conversion allows for "#10" to return 16:
convertToNumber = (n) ->
        if n[0] == "#" or n[0] == "$"
                num = parseInt( n[1..], 16 );
        else
                num = parseInt( n, 10 );

        if isNaN(num) then 0 else Math.abs( num % 256 )

# Take the global variable "codes" that contains our complex data
# structure, and turning it into a hash where the key is the
# abbreviation code, and the value is its numeric position in the data
# structure (the index):

getAbbrCodesReducer = (mapping, code, idx) ->
        _.merge(mapping, { "#{code}": idx })

getAbbrCodes = (codes) ->
        _.reduce( _.pluck(codes, 'abbr'), getAbbrCodesReducer, {})

# Normalizing the code returns either the operands "code" value or a
# numeric number if not found in the table.

normalizeCode = (opers, abbr) ->
        code = opers[abbr]
        if code > -1 then code else convertToNumber(abbr)

# This reducing function accumulates all of the labels as a hash map,
# the non-labels as token codes, and a pointer that helps identify the
# address in memory that a label refers.

labelReducer = (coll, code) ->
        [labels, data, pointer] = coll
        if code.endsWith(":")
                new_label = { "#{code.slice(0, -1)}" : pointer }
                [ _.merge(labels, new_label), data, pointer ]
        else
                [ labels, data.concat(code), pointer + 1 ]

# Loading code into memory amounts to:
#   - tokenizing the string given
#   - creating an operand_hash corresponding to the operands and labels
#   - converting each token into its equivalent value

loadMemory = (strData) ->
        # Create tokens by ignoring all whitespace:
        tokens = strData.split(/[ \n\t,]/).filter(notEmpty)

        [ labels, code ] = _.reduce(tokens, labelReducer, [{}, [], 0])
        new_operands = _.merge( getAbbrCodes(operands), labels )


        convertCodes = _.partial(normalizeCode, new_operands)
        _.map(code, convertCodes)

# This allows us to write the following "code":
#        LDX 10
#  LOOP: INX
#        SAX #81
#        JMP LOOP
#        END
#
# And have the result be something like:
#   [ 2, 10, 10, 6, 129, 12, 2, 0 ]
# ----------------------------------------------------------------------

displayLowerElem = (value, index) ->
        # console.log "Display:", value, index, pointer
        highlight = if pointer == index then "class='highlight'" else ""
        $("#memory-index").append( "<th #{highlight}>" + getNumberDisplay(index) + "</th>" )
        $("#memory-strip").append( "<td #{highlight}>" + getNumberDisplay(value) + "</td>" )
        if pointer == index
                $("#lower-pointer").append("<th #{highlight}>↑</th>")
        else
                $("#lower-pointer").append("<th>&nbsp;</th>")

displayUpperElem = (value, index) ->
        # console.log "Display:", value, index, pointer
        highlight = if pointer == index then "class='highlight'" else ""
        $("#upper-index").append( "<th #{highlight}>" + getNumberDisplay(index) + "</th>" )
        $("#upper-strip").append( "<td #{highlight}>" + getNumberDisplay(value) + "</td>" )
        if pointer == index
                $("#upper-pointer").append("<th #{highlight}>↑</th>")
        else
                $("#upper-pointer").append("<th>&nbsp;</th>")

displayMemory = ->
        $("#memory-index").html("")
        $("#memory-strip").html("")
        $("#lower-pointer").html("")
        $("#upper-pointer").html("")
        $("#upper-index").html("")
        $("#upper-strip").html("")

        displayLowerElem(value, index)     for value, index in memory[..127]
        displayUpperElem(value, index+128) for value, index in memory[128..]

        $("#pointer").html( getNumberDisplay(pointer) )
        $("#x-register").html( getNumberDisplay(registerX) )
        $("#y-register").html( getNumberDisplay(registerY) )
        $("#z-register").html( getNumberDisplay(registerZ) )

displayLight = (num, addr) ->
        light = $("#light-#{num}")
        console.log(light)
        switch memory[addr] % 8
          when 0 then light.removeClass().addClass("light off")
          when 1 then light.removeClass().addClass("light on-red")
          when 2 then light.removeClass().addClass("light on-green")
          when 3 then light.removeClass().addClass("light on-yellow")
          when 4 then light.removeClass().addClass("light on-blue")
          when 5 then light.removeClass().addClass("light on-magenta")
          when 6 then light.removeClass().addClass("light on-cyan")
          else        light.removeClass().addClass("light on-white")

displayLights = ->
        console.log "Displaying lights..."
        (displayLight(num, addr) for num, addr of {1:129, 2:130, 3:131, 4:132})

updateSystem = ->
        displayMemory()
        displayLights()

toggleHexDec = ->
        image = $("#hex-dec-toggle")
        if showDecimal
                image.attr("src", "img/switch-right.svg")
                showDecimal = false
        else
                image.attr("src", "img/switch-left.svg")
                showDecimal = true
        updateSystem()

$( ->
        $("#load").click( loadSystem )
        $("#step").click( stepSystem )
        $("#go").click( contSystem )

        $(".keycap").mousedown ->
                $(this).parents(".key-border").addClass("pressed")
        $(".keycap").mouseup ->
                $(this).parents(".key-border").removeClass("pressed")
        $("#hex-dec-area").click ->
                toggleHexDec()

        updateSystem()

        console.log "System Powered On."
)
