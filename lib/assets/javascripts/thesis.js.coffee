Thesis =
  requirements: ->
    unless jQuery.ui
      alert "jQuery UI not included. Thesis will not work properly without it."
  
  page_is_editable: ->
    $("#thesis").length > 0

  bindings: ->
    thesis = $("#thesis")

    

jQuery ($)->
  Thesis.requirements()

# window.Thesis = Thesis # Enable if necessary
