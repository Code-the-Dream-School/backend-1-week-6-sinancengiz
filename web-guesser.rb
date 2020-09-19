#import dependencies
require "sinatra"
require "uri"

#enable sessions
enable :sessions

def create_random()
    #function create random number
    random_number = rand(1..100)
    return random_number
end

def set_background_color(random, guessed) 
    #function sets background color
    if (random - guessed).abs > 50
        background_color = "lightblue"
        return background_color
    elsif (random - guessed).abs > 15
        background_color = "yellowgreen"
        return background_color
    elsif (random - guessed).abs > 10
        background_color = "yellow"
        return background_color
    elsif (random - guessed).abs > 5
        background_color = "orange"
        return background_color
    else
        background_color = "red"
        return background_color
    end

end



get("/")do
    session[:background_color] = "lightblue"
    @background_color = session[:background_color]
    
    erb :home
end

get "/game" do
    @name = session[:name].capitalize()
    @background_color = session[:background_color]
    @random_number = session[:random_number]
    @number_of_guess = session[:number_of_guess]
    @guessed_numbers_list = session[:guessed_numbers_list] 
    erb :game
end

get("/result") do
    # renders result page
    @background_color = session[:background_color]
    @result = session[:game_result]
    @random_number = session[:random_number]
    @guessed_numbers_list = session[:guessed_numbers_list] 
    erb :result
end

post '/start_game' do
    #initilize session parameters for use
    session[:name] = params[:name]
    @background_color = session[:background_color]
    session[:random_number] = create_random()
    session[:guessed_numbers_list] = ["__","__","__","__","__","__","__"]
    session[:number_of_guess] = 0
    session[:game_result] = "No result yet"
    redirect '/game'
end

put "/number_guessed" do
    # called each time user make a guess and updates the game variables and checks if won or lose
    if session[:number_of_guess] <= 5
        guessed_number = params[:guessed_number].to_i
        session[:guessed_numbers_list][session[:number_of_guess]] = guessed_number
        session[:number_of_guess] += 1
        session[:background_color] = set_background_color(session[:random_number], guessed_number)
        if session[:guessed_numbers_list].include?(session[:random_number])
            session[:game_result] = "You Won !!!!!"
            session[:background_color] = "lightblue"
            redirect '/result'
        else
            redirect "/game"
        end
    else
        guessed_number = params[:guessed_number].to_i
        session[:guessed_numbers_list][session[:number_of_guess]] = guessed_number
        if session[:guessed_numbers_list].include?(session[:random_number])
            session[:game_result] = "You Won!!!!"
            session[:background_color]= "lightblue"
            redirect '/result'
        else
            session[:game_result] = "You Lost"
            session[:background_color] = "lightblue"
            redirect '/result'
        end    
        
    end
end
