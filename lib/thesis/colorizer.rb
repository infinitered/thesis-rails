class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize 31
  end

  def green
    colorize 32
  end

  def yellow
    colorize 33
  end

  def pink
    colorize 35
  end

  def gray
    colorize 37
  end

  def brown
    colorize 33
  end

  def blue
    colorize 34
  end

  def magenta
    colorize 35
  end

  def cyan
    colorize 36
  end

  def bold
    colorize 1
  end

  def blink
    colorize 5
  end

end