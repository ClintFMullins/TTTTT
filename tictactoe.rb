class TicTacToe
	
	def initialize(size, winReq, playSyms)
		@size = size   # the size of the board (size*size) MAXIMUM SIZE is 9 due to regex. To fix this do a find of **HERE
		@board = Array.new(@size+1) {Array.new(@size+1)} #the board itself, one row and column are used for information
		@playSyms = playSyms #list of all the player symbols, add more symbols to add more players
		@curPlayerInd = 0 #index of current player
		@player == @playSyms[@curPlayerInd] # the first player is has first player symbol
		@winReq = winReq #number of pieces in a row required
		play #calls the play method
	end
	
	def play
		while true  # the loop of the game, this only breaks when someone wins
			displayboard  #this method displays the board
			playermove #this method gets a players move and executes it
			if winCheck #this is a check for any winner, if there is we execute the inner commands
				winDisplay #displays the board and the winner's symbol
				break #breaks from the game loop
			end
			#getting to this point means there were no winners this round
			nextPlayer #the next player is put in the @player variable
			puts "\n\n"
		end
	end
	
	def nextPlayer
		# if the next index is larger than the symbol array, we start from the first symbol
		@curPlayerInd = @curPlayerInd+1>=@playSyms.length ? 0 : @curPlayerInd + 1 
		@player = @playSyms[@curPlayerInd] #correct symbol is given the the player variable with the player index
	end
	
	def playermove
		while true #this loop won't exit until a valid, untaken spot is chosen for a move
			puts "Where would you like to move? Col Row" #friendly question for the user
			input = gets.chomp # we get the input
			next unless input=~/\d{1} \d{1}/ #make sure the input is in "[number][space][number]" using regular expression **HERE
			x,y =input.split().map{|c| c.to_i} #once we are sure the format is correct we grab our input and separate it into X and Y coords
			break if canput?(x,y) # if these are valid coords we break from this loop
		end
		@board[x][y] = @player #the player's symbol is placed on the board
	end
	
	def canput?(x,y)
		inBounds?(x,y) && @board[x][y].nil? #a valid spot is one that is within the board limits and not already taken
	end
	
	def inBounds?(x,y)
		 #we have odd bounds because we store other information(the row and column numbers the user can see printed) in our array.
		x>0 && y>0 && x<@size+1 && y<@size+1
	end
	
	def displayboard
		(@size+1).times do |y|
			(@size+1).times do |x|
				if x==0 &&y==0 # the first value we print is the symbol of the player whose turn it is
					print "["+@player+"]"
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
	
	def winCheck
		#here we check every single spot for a win, it may be overkill, but it is easier than other things and it works
		1.upto(@size) do |y|
			1.upto(@size) do |x|
				return true if anyDirectionsWin?(x,y) #return true if we have found a winner in any directions
			end
		end
		false # return false if no winner is found
	end
	
	def anyDirectionsWin?(x,y)
		#here we check each direction for a winner using check direction. There are four ways to get a win. They are listed below
		return true if (checkDirection(x,y,"*","-")+checkDirection(x,y,"*","+")+1>=@winReq) #up down
		return true if (checkDirection(x,y,"+","*")+checkDirection(x,y,"-","*")+1>=@winReq) #left right
		return true if (checkDirection(x,y,"+","-")+checkDirection(x,y,"-","+")+1>=@winReq) #forward slash
		return true if (checkDirection(x,y,"+","+")+checkDirection(x,y,"-","-")+1>=@winReq) #backward slash
		false #return false if no directions contain a winning segment
	end
	
	def checkDirection(x,y,xOp,yOp)
		thisPlayer = @board[x][y] #this is the symbol we are looking for
		count=0 #this value represents how many of thisPlayer symbols we have found in a row, not including our starting spot
		if !thisPlayer.nil? #if this spot is empty, we skip this whole ordeal
			while true 
				x=eval [x.to_s,xOp,"1"].join() #first we get our next step, using the operations passed to us
				y=eval [y.to_s,yOp,"1"].join() #we get them for both our x and our y
				space = inBounds?(x,y) ? @board[x][y] : "-" #we then save this space as either a symbol, or "-"
				if (space==thisPlayer) #if this symbol is equal to our player symbol, we have a continued match
					count+=1 #we add to our count because we now have the number count symbols in a row
				else #if we don't find a match
					break #we break out of our loop
				end
			end
		end
		count #count is returned no matter what. 
	end
	
	def winDisplay
		puts "\n\n[][][][][][][][][][][][][][]\n\n\n" #super style
		puts "#{@player} is the winner!" #we display the winning player's symbols
		displayboard #we display the won board for all to see
		puts "\n\n[][][][][][][][][][][][][][]\n\n\n\n" #super-duper style
	end

end


ttt = TicTacToe.new(3,3, ["X","O"]) #gotta call this, otherwise it just sits there
