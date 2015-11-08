# Need to insert the technical operands...

showInstructionCode = (mnemonic, note) ->
        $("#instructions ol").append( "<li><b>#{mnemonic}</b> - #{note}</li>")

showInstructions = ->
        [showInstructionCode(code.abbr, code.help) for code in operands]

# load content and open dialog
showInfoDialog = (url) ->
        $("#info-dialog").load(url)
        $("#info-dialog").dialog("open")

$( ->
        bookmark = Cookies.get('bookmark') || 0

        $("#info-dialog").dialog({
           autoOpen: false,
           # height: 300,
           # width: 350,
           # modal: true
        });

        $( "#accordion" ).accordion({
                # collapsible: true
                fillSpace: true
                autoHeight: false
                heightStyle: "content"
                active: Number(bookmark)
                activate: ( event, ui ) ->
                        opened = $( "#accordion" ).accordion( "option", "active" )
                        Cookies.set('bookmark', opened)
        })

        showInstructions()

        $(".loadable").each ->
                url = "tutorial/" + $(this).attr("id")
                $(this).load(url, null, ->
                        $("a").click ->
                                url = "tutorial/" + $(this).attr("href")
                                showInfoDialog(url)
                                return false
                )
)
