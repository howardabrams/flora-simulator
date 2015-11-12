# Need to insert the technical operands...

showInstructionCode = (mnemonic, note) ->
  $("#instructions ol").append( "<li><b>#{mnemonic}</b> - #{note}</li>")

showInstructions = ->
  [showInstructionCode(code.abbr, code.help) for code in operands]

loadPage = (url, dest, callback) ->
  $(dest).html("")
  ha = $("#holding-area")

  ha.load(url, null, (data) ->
    section = $("#holding-area div#content")
    if section.length > 0
      section.clone().appendTo(dest).find("h1").empty()
    else
      dest.html(data)
    if callback
      title = $("title,h1", ha).first().text()
      callback(title, dest)
    ha.html(""))  # Clear it out


# load content and open dialog
showInfoDialog = (url) ->
  loadPage(url, "#info-dialog", (title) ->
    $("#info-dialog").dialog("option", "title", title)
    $("a", "#info-dialog").attr("target", "_new")
    $("#info-dialog").dialog("open"))

$( ->
  bookmark = Cookies.get('bookmark') || 0
  dialogHeight = $("body").innerHeight() - 80
  dialogWidth  = $("body").innerWidth() - 80

  $("#info-dialog").dialog({
    autoOpen: false,
    height: dialogHeight,
    width: dialogWidth
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
    dest = $(this)
    loadPage(url, dest, ->
      $("a", dest).click ->
        showInfoDialog( "tutorial/" + $(this).attr("href") )
        false
      $("pre", dest).prepend("<span class=\"ui-icon ui-icon-arrowreturnthick-1-w\"></span>")
      $("pre .ui-icon").click ->
        text = $(this).parents("pre").text()
        console.log "Copying", text
        $("#input", window.parent.frames[0].document).html(text)
    )
)
