class @Utilities

  # settimeout
  @delay: (ms, func) -> setTimeout func, ms

  # smoothscroll
  @scroll_to: (area, modifier, callback) ->
    modifier = modifier || 0
    go_to_position = $(area).offset().top
    $("html,body").stop()
    $("html,body").animate
      scrollTop: go_to_position + modifier
    , "slow", callback