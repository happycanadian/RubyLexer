# This is the Token Class. This class stores information
# about the specific tokens, the type and the text of
# what exactly the token is.
# Author:: Stephen Stirling

class Token
  INVALID = 0
  EOF = -1

  attr_reader :type, :text

  def initialize (type, text)
    @type = type
    @text = text
  end

# Overrides the default to_s that the object has and
# returns the text and type in a specific format.
  def to_s
    return "[#{@text}:#{@type}]"
  end

end