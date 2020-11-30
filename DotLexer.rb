# This is the DotLexer class that has a primary use of
# determining what tokens are in the inputted data, the
# primary method in this class is called nextToken. 
# Author:: Stephen Stirling
require_relative "Token"

class DotLexer
  # Var
  ID = 1 
  # Integer
  INT = 2
  # "String"
  STRING = 3
  # {
  LCURLY = 4
  # }
  RCURLY = 5
  # ;
  SEMI = 6
  # [
  LBRACK = 7
  # ]
  RBRACK = 8
  # ->
  ARROW = 9
  # =
  EQUALS = 10
  # digraph case insensitive
  DIGRAPH = 11
  # subgraph case insensitive
  SUBGRAPH = 12
  # ,
  COMMA = 13
  # Whitespace, ignore it
  WS = 14

# class instatiator
  def initialize
    @input = []
    @index = 0
  end

# Takes the input and checks the next characters to 
# determine the newest token that is entered.
# if no valid characters are entered, then it
# outputs the invalid character and moves to the
# next character.
  def nextToken
    valid = false
    while !valid
      valid = true
      whitespace = false
      if @input[@index] == "\n" || @index >= @input.length - 1
        @input = gets
        if @input == nil
          return Token.new(Token::EOF, "END OF PROGRAM")
        else
          @input.chomp.strip
        end
        @index = 0
      else
        @index +=1
        while(@input[@index] == " ")
          @index +=1
        end
      end
      current_char = @input[@index]

      #check lcurly
      if (current_char =~ /{/)
        token = Token.new(LCURLY, current_char)
      #check rcurly
      elsif (current_char =~ /}/)
        token = Token.new(RCURLY, current_char)
      #check semi
      elsif (current_char =~ /;/)
        token = Token.new(SEMI, current_char)
      #check lbrack
      elsif (current_char =~ /[\[]/)
        token = Token.new(LBRACK, current_char)
      #check rbrack
      elsif (current_char =~ /[\]]/)
        token = Token.new(RBRACK, current_char)
      #check arrow
      elsif (current_char =~ /-/)
        #NOT DONE
        token = Token.new(ARROW, @input[@index] + @input[@index+1])
        @index +=1
      #check equals
      elsif (current_char =~ /=/)
        token = Token.new(EQUALS, current_char)
      #check comma
      elsif (current_char =~ /,/)
        token = Token.new(COMMA, current_char)
      #is_int
      elsif (current_char =~ /[0-9]/)
        token = Token.new(INT, current_char)
      #is_string
      elsif (current_char =~ /"/)
        token = read_string
      #is_id or digraph or subgraph
      elsif (current_char =~ /[a-zA-Z]/)
        token = read_id
      #is_whitespace
      elsif (current_char =~ /[\s\t\r\n\f]/)
        valid = false
        white_space = true
      #Illegal char
      else
        valid = false
      end
      if valid
        return token
      else
        if !white_space
          puts "illegal char: #{current_char}"
        end
      end
    end
  end

# reads in the token as an id and then checks to
# see if the id is actually an ID or if it is
# a subgraph or digraph. Returns the appropriate
# token generated.
  def read_id
    text = ''
    while @input[@index] =~ /[0-9a-zA-Z]/
      text += @input[@index]
      @index +=1
    end
    @index -=1
    if (text =~ /(digraph|DIGRAPH)/)
      return Token.new(DIGRAPH, text)
    elsif (text =~ /(subgraph|SUBGRAPH)/)
      return Token.new(SUBGRAPH, text)
    else
      return Token.new(ID, text)
    end
  end

# reads in the string and returns the token
# generated
  def read_string
    text = ''
    text += @input[@index]
    @index +=1
    while @input[@index] =~ /[0-9a-zA-Z]/
      text += @input[@index]
      @index +=1
    end
    text += @input[@index]
    return Token.new(STRING, text)
  end
end