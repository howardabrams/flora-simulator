# Need to insert the technical operands...

showInstructionCode = (mnemonic, note) ->
        $("#instructions ol").append( "<li><b>#{mnemonic}</b> - #{note}</li>")

showInstructions = ->
        [showInstructionCode(code.abbr, code.help) for code in operands]

$( ->
        showInstructions()
)
