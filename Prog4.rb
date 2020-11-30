# This is the main class for program4, which was provided by the instructor.
# Author:: Joshua Yue

require_relative "DotLexer"
require_relative "DotParser"
require_relative "Token"

# Uncomment this line for debugging.
#$stdin.reopen("Prog4_3.in")

lexer = DotLexer.new

parser = DotParser.new(lexer)
parser.graph()


