Thesis =
  setup: ->
    @edit_mode = false
    if this.requirements() && this.page_is_editable()
      this.draw_editor()
      this.set_up_bindings()
  
  requirements: ->
    if jQuery.ui
      true
    else
      alert "jQuery UI not included. Thesis will not work properly without it."
      false
      
  edit_mode: ->
    @edit_mode
  
  page_is_editable: ->
    this.thesis().length > 0
    
  thesis: ->
    @thesis = $("#thesis-editor")
    
  draw_editor: ->
    @thesis.append this.edit_page_button()
    
  set_up_bindings: ->
    t = this
    @edit_page_button.on "click", (e)->
      e.preventDefault()
      t.toggle_edit_mode()
  
  toggle_edit_mode: ->
    @edit_mode = !@edit_mode
    if @edit_mode
      @edit_page_button.text "Save"
      $("body").addClass("thesis-editing")
    else
      @edit_page_button.text "Edit"
      $("body").removeClass("thesis-editing")
      
      
  
  edit_page_button: ->
    @edit_page_button = $("<a></a>").attr("href", "#").attr("id", "thesis-edit-page").text("Edit")
    

jQuery ($)->
  Thesis.setup()

# window.Thesis = Thesis # Enable if necessary