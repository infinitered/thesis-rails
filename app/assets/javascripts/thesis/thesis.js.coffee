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

  set_up_bindings: ->
    t = this
    @edit_page_button.on "click", (e)->
      e.preventDefault()
      t.toggle_edit_mode()

  editing: ->
    $("body").hasClass("thesis-editing")

  hallo_text_options: ->
    options =
      editable: true

  hallo_html_options: ->
    options =
      editable: true
      plugins:
        'halloformat': {}
        'halloheadings': {}
        'hallojustify': {}
        'hallolists': {}
        'halloreundo': {}
        'hallolink': {}
        # 'halloimage': {} # Someday?

  start_editing: ->
    $("body").append($("<div></div>").addClass("thesis-fader"))
    $("body").addClass("thesis-editing")
    $(".thesis-content-html").hallo this.hallo_html_options()
    $(".thesis-content-text").hallo this.hallo_text_options()

  end_editing: ->
    $(".thesis-fader").remove()
    $("body").removeClass("thesis-editing")
    $(".thesis-content-html").hallo editable: false
    $(".thesis-content-text").hallo editable: false

  save_content: ->
    # Gather the content for posting
    payload = {}
    $(".thesis-content-html, .thesis-content-text").each ()->
      content_area = $(this)
      content_id = content_area.data("thesis-content-id")
      payload[content_id] = content_area.html()

    $.ajax
      url: "/thesis/update_page_content"
      data: payload
      type: "put"
      dataType: "json"
      success: ->
        alert "Page saved."
      error: ->
        alert "Sorry, couldn't save this page."

  add_page: ->
    page_name = prompt "What is the name of the new page?"
    if page_name
      parent_slug = null
      if confirm("Make this a subpage of the current page?")
        parent_slug = window.location.pathname
      $.ajax
        url: "/thesis/create_page"
        data:
          name: page_name
          parent_slug: parent_slug
        type: "post"
        dataType: "json"
        success: (resp, status, xhr)->
          if resp && resp.page
            window.location = resp.page.slug
          else
            alert "Unknown error"
        error: ->
          alert "Sorry, couldn't save this page."

  delete_page: ->
    really_sure = confirm "Are you sure you want to delete this page? There is no undo!"
    if really_sure
      $.ajax
        url: "/thesis/delete_page"
        data:
          slug: window.location.pathname
        type: "delete"
        # dataType: "json"
        success: ->
          alert "Page was deleted."
        error: ->
          alert "Sorry, couldn't delete this page."


  toggle_edit_mode: ->
    if this.editing()
      this.end_editing()
    else
      this.start_editing()

  draw_editor: ->
    @thesis.append this.draw_edit_page_button()

  draw_edit_icon: ->
    @edit_icon = $("<i></i>").addClass("thesis-icon-edit thesis-icon-2x")

  draw_save_icon: ->
    @save_icon = $("<i></i>").addClass("thesis-icon-save thesis-icon-2x")
    @save_icon.on "click", ->
      Thesis.save_content()

  draw_add_icon: ->
    @add_icon = $("<i></i>").addClass("thesis-icon-plus thesis-icon-2x")
    @add_icon.on "click", ->
      Thesis.add_page()

  draw_delete_icon: ->
    @delete_icon = $("<i></i>").addClass("thesis-icon-trash thesis-icon-2x")
    @delete_icon.on "click", ->
      Thesis.delete_page()

  draw_cancel_icon: ->
    @cancel_icon = $("<i></i>").addClass("thesis-icon-remove thesis-icon-2x")

  draw_edit_page_button: ->
    @edit_page_button = $("<a></a>").attr("href", "#").attr("id", "thesis-edit-page")
    @edit_page_button.append(this.draw_edit_icon())
    @edit_page_button.append(this.draw_cancel_icon())
    @edit_page_button.append(this.draw_save_icon())
    @edit_page_button.append(this.draw_add_icon())
    @edit_page_button.append(this.draw_delete_icon())
    @edit_page_button

jQuery ($)->
  Thesis.setup()

# window.Thesis = Thesis # Enable if necessary