 class TicTacToe

	def initialize(size, winReq, playSyms)
		@board = Board.new(size)
		@winCheck = WinCheck.new(winReq)
		@playSyms = playSyms #list of all the player symbols, add more symbols to add more players
		@curPlayerInd = 0 #index of current player
		play #calls the play method
	end

	def play
		while true  # the loop of the game, this only breaks when someone wins
			@board.displayboard  #this method displays the board
			playerMove #this method gets a players move and executes it
			if @winCheck.check(@board) #this is a check for any winner, if there is we execute the inner commands
				break #breaks from the game loop
			end
			#getting to this point means there were no winners this round
			nextPlayer #the next player is put in the @player variable
			puts "\n\n"
		end
		@board.displayboard  #this method displays the board
	end
	
	def playerMove
		while true #this loop won't exit until a valid, untaken spot is chosen for a move
			x,y = getDesiredPlayerMove
			break if @board.placePiece(x,y,player) # if these are valid coords we break from this loop
		end
	end
	
	def getDesiredPlayerMove
		begin
			puts "Where would you like to move? Col Row" #friendly question for the user
			input = gets.chomp # we get the input
		end while !(input=~/\d{1,2} \d{1,2}/)
		input.split.map{|c| c.to_i} #once we are sure the format is correct we grab our input and separate it into X and Y coords
	end
	
	def nextPlayer
		# if the next index is larger than the symbol array, we start from the first symbol
		@curPlayerInd = @curPlayerInd+1>=@playSyms.length ? 0 : @curPlayerInd + 1 
	end
	
	def player
		@playSyms[@curPlayerInd]
	end

end

class WinCheck
	def initialize(winReq)
		@winReq = winReq
		@curBoard = nil
		@curPlayer = nil
	end
	
	 #public
	 
	def check (board)
		@curBoard = board
		#here we check every single spot for a win, it may be overkill, but it is easier than other things and it works
		1.upto(@curBoard.size) do |y|
			1.upto(@curBoard.size) do |x|
				return true if _anyDirectionsWin?(x,y) #return true if we have found a winner in any directions
			end
		end
		false # return false if no winner is found
	end

	#private

	def _anyDirectionsWin?(x,y)
		#here we check each direction for a winner using check direction. There are four ways to get a win. They are listed below
		if (_checkDirection(x,y,"*","-")+_checkDirection(x,y,"*","+")+1>=@winReq)  || #up down
		   (_checkDirection(x,y,"+","*")+_checkDirection(x,y,"-","*")+1>=@winReq)  || #left right
		   (_checkDirection(x,y,"+","-")+_checkDirection(x,y,"-","+")+1>=@winReq)  || #forward slash
		   (_checkDirection(x,y,"+","+")+_checkDirection(x,y,"-","-")+1>=@winReq)      #backward slash
			_winDisplay
			true
		else
			false #return false if no directions contain a winning segment
		end
	end

	def _checkDirection(x,y,xOp,yOp)
		@curPlayer = @curBoard.getSpot(x,y) #this is the symbol we are looking for
		count=0 #this value represents how many of thisPlayer symbols we have found in a row, not including our starting spot
		if !@curPlayer.nil? #if this spot is empty, we skip this whole ordeal
			while true 
				x=eval [x.to_s,xOp,"1"].join() #first we get our next step, using the operations passed to us
				y=eval [y.to_s,yOp,"1"].join() #we get them for both our x and our y
				space = @curBoard.getSpot(x,y) #we then save this space as either a symbol, or nil
				if (space==@curPlayer) #if this symbol is equal to our player symbol, we have a continued match
					count+=1 #we add to our count because we now have the number count symbols in a row
				else #if we don't find a match
					break #we break out of our loop
				end
			end
		end
		count #count is returned no matter what. 
	end

	def _winDisplay
		puts "\n\n[][][][][][][][][][][][][][]\n\n\n" #super style
		puts "#{@curPlayer} is the winner!" #we display the winning player's symbols
		puts "\n\n[][][][][][][][][][][][][][]\n\n\n\n" #super-duper style
	end
end

class Board
	attr_reader :size
	
	def initialize(size)
		@size = size
		@board = Array.new(@size+1) {Array.new(@size+1)} #the board itself, one row and column are used for information
	end
	
	#public
	
	def placePiece(x,y,sym)
		if _canPut?(x,y)
			@board[x][y] = sym
			true
		else
			false
		end
	end
	
	def displayboard
		(@size+1).times do |y|
			(@size+1).times do |x|
				if x==0 &&y==0 # the first value we print is the symbol of the player whose turn it is
					print "[T]"
				elsif     x==0 && y!=0 # we print our row numbers
					print "["+y.to_s+"]"
				elsif x!=0 && y==0 # we print our column numbers
					print "["+x.to_s+"]"
				elsif @board[x][y].nil? #if there is no move, we print [-]
					print "[-]"
				else # if none of the other conditions apply, we must have an occupied space, and we print that space
					print "["+@board[x][y].to_s+"]"
				end	
			end
			puts "\n" #just a little space, that's all I need
		end
	end 
	
	def getSpot(x,y)
		if (_inBounds?(x,y))
			@board[x][y]
		else
			nil
		end
	end
	
	#private
	
	def _canPut?(x,y)
		_inBounds?(x,y) && @board[x][y].nil? #a valid spot is one that is within the board limits and not already taken
	end
	
	def _inBounds?(x,y)
		 #we have odd bounds because we store other information(the row and column numbers the user can see printed) in our array.
		x>0 && y>0 && x<@size+1 && y<@size+1
	end

end


ttt = TicTacToe.new(3,3, ["X","O"]) #gotta call this, otherwise it just sits there