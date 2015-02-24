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

  thesis: ->
    @thesis = $("#thesis-editor")

  # ATTRIBUTES
  page_is_editable: ->
    this.thesis().length > 0

  page_in_edit_mode: ->
    $("body").hasClass("thesis-editing")

  page_has_unsaved_content: ->
    $("body .thesis-content.isModified").length

  modal: (blur=false, type="settings")->
    this.close_modal()
    $("body").addClass "thesis-blur" if blur
    $("body").append this["#{type}_modal_markup"]()
    $("#thesis-modal").fadeIn 300

    $("#thesis-modal").on "click", ".modal-field.cancel", (e)->
      e.preventDefault()
      Thesis.close_modal()

    $("#thesis-modal").on "submit", "form", (e) ->
      alert "To Do: submit form"
      e.preventDefault() #temp
      return false       #temp

  close_modal: ->
    if $("#thesis-modal").length
      $("body").removeClass "thesis-blur"
      $("#thesis-modal").remove()

  settings_modal_markup: ->
    is_win = navigator.appVersion.indexOf("Win")!=-1
    """
      <div id="thesis-modal" class="settings #{if is_win then 'windows' else ''}">
        <div class="modal-icon"><i class="fa fa-wrench fa-2x"></i></div>
        <div class="modal-title">Page Settings</div>
        <form action="" method="">
          <label class="modal-field"><span>Page Name</span><input class="page-settings_page-title" name="page-settings_page-title" type="text" /></label>
          <label class="modal-field"><span>Page Slug</span><input class="page-settings_page-slug" name="page-settings_page-slug" type="text" /></label>
          <label class="modal-field"><span>Meta Title</span><input class="page-settings_meta-title" name="page-settings_meta-title" type="text" /></label>
          <label class="modal-field"><span>Meta Description</span><textarea class="page-settings_meta-description" name="page-settings_meta-description"></textarea></label>
          <label class="modal-field cancel"><button class="page-settings_submit" name="page-settings_submit"><i class="fa fa-remove fa-2x"></i> <span>Cancel</span></button></label>
          <label class="modal-field submit"><button class="page-settings_submit" name="page-settings_submit" type="Submit" value=""><i class="fa fa-save fa-2x"></i> <span>Save</span></button></label>
        </form>
      </div>
    """

  # ACTIONS
  set_up_bindings: ->
    t = this

    t.thesis.on "mouseenter", ->
      clearTimeout @hide_editor_delay
      $(this).addClass "active"
    .on "mouseleave", ->
      @hide_editor_delay = Utilities.delay 2000, ()=>
        $(this).removeClass "active"

    @edit_page_button.on "mouseenter", ->
      t.change_edit_tooltip_status()

    @edit_page_button.on "click", (e) ->
      e.preventDefault()
      t.edit_button_click_actions()

  edit_button_click_actions: ->
    if this.page_in_edit_mode()
      if this.page_has_unsaved_content()
        this.change_edit_tooltip_status("Save Page before Exiting", "error")
      else
        this.end_editing()
    else
      this.start_editing()

  change_edit_tooltip_status: (edit_text=null, classes=null) ->
    $tooltip = @edit_page_button.find(".tooltip")
    $tooltip.removeClass().addClass("tooltip")
    $tooltip.addClass "#{classes}" if classes
    unless edit_text
      if this.page_in_edit_mode()
        if this.page_has_unsaved_content()
          edit_text = "Editing Page"
        else
          edit_text = "Exit Edit Mode"
      else
        edit_text = "Edit Page"
    $tooltip.text edit_text

  start_editing: ->
    $("body").append($("<div></div>").addClass("thesis-fader"))
    $("body").addClass("thesis-editing")
    $(".thesis-content-html").hallo this.hallo_html_options()
    $(".thesis-content-text").hallo this.hallo_text_options()
    this.change_edit_tooltip_status()

  end_editing: ->
    $(".thesis-fader").remove()
    $("body").removeClass("thesis-editing")
    $(".thesis-content-html").hallo editable: false
    $(".thesis-content-text").hallo editable: false
    this.change_edit_tooltip_status()

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


  # OPTIONS
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


  # EDITOR
  draw_editor: ->
    @thesis.append(this.draw_add_icon())
    @thesis.append(this.draw_delete_icon())
    @thesis.append(this.draw_settings_icon())
    @thesis.append(this.draw_cancel_icon())
    @thesis.append(this.draw_save_icon())
    @thesis.append(this.draw_edit_icon())
    @edit_page_button = @thesis.find(".thesis-button.edit")

  draw_edit_icon: ->
    $icon = $("<i></i>").addClass "fa fa-edit fa-2x"
    $tooltip = $("<div></div>").addClass("tooltip").text "Edit Page"
    $("<div></div>").addClass("thesis-button edit").append $tooltip, $icon

  draw_save_icon: ->
    $icon = $("<i></i>").addClass "fa fa-save fa-2x"
    $tooltip = $("<div></div>").addClass("tooltip").text "Save Changes"
    $button = $("<div></div>").addClass("thesis-button save").append $tooltip, $icon
    $button.on "click", ->
      Thesis.save_content()
      Thesis.end_editing()

  draw_add_icon: ->
    $icon = $("<i></i>").addClass "fa fa-plus fa-2x"
    $tooltip = $("<div></div>").addClass("tooltip").text "Add New Page"
    $button = $("<div></div>").addClass("thesis-button add").append $tooltip, $icon
    $button.on "click", ->
      Thesis.add_page()

  draw_settings_icon: ->
    $icon = $("<i></i>").addClass "fa fa-wrench fa-2x"
    $tooltip = $("<div></div>").addClass("tooltip").text "Page Settings"
    $button = $("<div></div>").addClass("thesis-button settings").append $tooltip, $icon
    $button.on "click", ->
      Thesis.modal(true, "settings")

  draw_delete_icon: ->
    $icon = $("<i></i>").addClass "fa fa-trash fa-2x"
    $tooltip = $("<div></div>").addClass("tooltip").text "Delete Page"
    $button = $("<div></div>").addClass("thesis-button delete").append $tooltip, $icon
    $button.on "click", ->
      Thesis.delete_page()

  draw_cancel_icon: ->
    $icon = $("<i></i>").addClass "fa fa-remove fa-2x"
    $tooltip = $("<div></div>").addClass("tooltip").text "Discard Changes"
    $button = $("<div></div>").addClass("thesis-button cancel").append $tooltip, $icon
    $button.on "click", ->
      Thesis.end_editing()
      location.reload()

jQuery ($)->
  Thesis.setup()

# window.Thesis = Thesis # Enable if necessary