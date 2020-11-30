# This is the DotParser class that has a primary use of
# determining if the input is valid in the given
# language using EBNF grammar.
# This is done by recursive descent algorithm.
# Author:: Stephen Stirling
class DotParser
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
  def initialize lexer
    @lexer = lexer
    #@curtoken = lexer.nextToken
    @token_array = Array.new
    t = lexer.nextToken
    while Token::EOF != t.type
      @token_array.push(t)
      t = lexer.nextToken
    end
    @index = 0
    @curtoken = @token_array[@index]
    @exit = false
  end

  #Returns whether the token is of the appropriate type
  def term (tok)
    #puts "Index: #{@index}"
    #puts "Actual: #{@curtoken}"
    #puts "Check: #{tok}"
    if (@curtoken::type == tok)
      #puts "#{@curtoken.type}"
      @index += 1
      @curtoken = @token_array[@index]
      return true
    end
    return false
  end

  #Calls the terms relating to graph
  def graph
    puts "Start recognizing a digraph"
    graph_boolean =  term(DIGRAPH) && (id || true) && term(LCURLY) && graph1 && term(RCURLY)
    if(graph_boolean)
      puts "Finish recognizing a digraph"
    end
    return graph_boolean
  end

  def graph1
    puts "Start recognizing a cluster"
    valid = true
    while(@curtoken.type != RCURLY && valid)
      valid = stmt_list
    end
    if(valid)
      puts "Finish recognizing a cluster"
    end
    return valid
  end

  #Calls the terms relating to stmt_list
  def stmt_list
    #puts "STATEMENT LIST"
    #puts
    return stmt && (term(SEMI) || true)
  end

  #Calls the terms relating to stmt
  def stmt
    #puts "STATEMENT"
    #puts
    stmt_boolean =  edge_stmt || stmt1 || subgraph
    if(!stmt_boolean && @exit == false)
      puts "Error: expecting property, edge or subgraph, but found: #{@curtoken.text}"
    end
    return stmt_boolean
  end

  #Calls the additional methods from stmt
  def stmt1
    save = @index
    stmt1_boolean =  id && term(EQUALS) && id
    if(!stmt1_boolean)
      @index = save
      @curtoken = @token_array[@index]
    else
      puts "Start recognizing a property"
      puts "Finish recognizing a property"
    end
    return stmt1_boolean
  end

#Calls the terms relating to edge_stmt
  def edge_stmt
    #puts "EDGE STATEMENT"
    #puts
    save = @index
    edge_stmt_boolean = false
    if((@curtoken.type == INT || @curtoken.type == STRING || @curtoken.type == ID ||@curtoken.type == SUBGRAPH) && @token_array[@index + 1].type == ARROW)
      edge_stmt_boolean = (id || subgraph) && edge
      if(edge_stmt_boolean)
        puts "Start recognizing an edge statement"
      end
      edge_stmt_boolean = edge_stmt_boolean && edgeRHS && edge_stmt1
      if(@curtoken.type != SEMI && @curtoken.type != ARROW && @curtoken.type != LCURLY && @curtoken.type != EQUALS && @curtoken.type != SUBGRAPH && @curtoken.type !=RCURLY)
        puts "Error: expecting ; or edge, but found: #{@curtoken.text}"
        edge_stmt_boolean = false
        @exit = true
      end
      if(edge_stmt_boolean)
        puts "Finish recognizing an edge statement"
      else
        @index = save
        @curtoken = @token_array[@index]
      end
    end
    return edge_stmt_boolean
  end

  def edge_stmt1
    save = @index
    edgestmt1 = (term(LBRACK) && attr_list && term(RBRACK))
    if(!edgestmt1)
      @index = save
      @curtoken = @token_array[@index]
    end
    return true
  end

  #Calls the terms relating to attr_list
  def attr_list
    return id && attr_list1 && attr_list2
  end

  def attr_list1
    if(@curtoken.type == EQUALS)
      puts "Start recognizing a property"
      puts "Finish recognizing a property"
    end
    return (term(EQUALS) && id) || true
  end

  def attr_list2
    save = @index
    #puts"attr_list2"
    attr_list_bool = term(COMMA) && id && attr_list1
    if(!attr_list_bool)
      @index = save
      @curtoken = @token_array[@index]
    end
    while(@curtoken.type != RBRACK)
      term(COMMA) && id && attr_list1
    end
    return true
  end

  #Calls the terms relating to edgeRHS
  def edgeRHS
    #puts "edgeRHS"
    return edgeRHS1 && edgeRHS2
  end

  def edgeRHS1
    #puts "edgeRHS1"
    return id || subgraph
  end

  def edgeRHS2
    #puts"edgeRHS2"
    while(@curtoken.type == ARROW)
      #puts "loop"
      edge && (id || subgraph)
    end
    return true
  end

  #Calls the terms relating to edge
  def edge
    return term(ARROW)
  end

  #Calls the terms relating to subgraph
  def subgraph
    
    subgraph_boolean =  term(SUBGRAPH) && id
    if(subgraph_boolean)
      puts "Start recognizing a subgraph"
    end
    subgraph_boolean = subgraph_boolean && term(LCURLY) && subgraph1 && term(RCURLY)
    if(subgraph_boolean)
      puts "Finish recognizing a subgraph"
    end
    #puts
    #puts subgraph_boolean
    #puts @index
    #puts
    return subgraph_boolean
  end

  def subgraph1
    puts "Start recognizing a cluster"
    while(@curtoken.type != RCURLY)
      stmt_list
    end
    puts "Finish recognizing a cluster"
    return true
  end

  #Calls the terms relating to id
  def id
    return term(ID) || term(STRING) || term(INT)
  end

end