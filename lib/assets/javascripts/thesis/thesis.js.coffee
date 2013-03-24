Thesis =
  setup: ->
    if this.requirements()
      this.bindings()
    
  
  requirements: ->
    if jQuery.ui
      true
    else
      alert "jQuery UI not included. Thesis will not work properly without it."
      false
  
  page_is_editable: ->
    $("#thesis-editor").length > 0

  bindings: ->
    thesis = $("#thesis-editor")
    if thesis
      thesis.append $("<div></div>").addClass("thesis-container").append $("<h3></h3>").text("Thesis Editor")
    

jQuery ($)->
  Thesis.setup()

# window.Thesis = Thesis # Enable if necessary