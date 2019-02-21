#helper function is accessible from any erb, so we can always find the current user
helpers do
    def current_user
        User.find_by(id: session[:user_id])
    end
end

#'/' indicates root page of app requested by browser. homepage
get '/' do
    #at symbol defines an instance variable, available in index.erb
    @posts = FinstagramPost.order('created_at DESC')
    #calling the erb method with symbol argument :index
    erb(:index)
end

get '/about' do
     erb(:about)
end

#login pages
get '/login' do
    erb(:login)
end

post '/login' do
    # take in user input
    username = params[:username]
    password = params[:password]
    
    # search for user object by username
    @user = User.find_by(username: username)
    
    # if that user exists and password matches
    if @user && (password == @user.password)
        # create a session with user ID as key
        session[:user_id] = @user.id
        redirect to('/')
    else
        @error_message = "Login failed"
        erb(:login)
    end
    
end

get '/logout' do
    session[:user_id] = nil
    redirect to('/')
end



#signup pages
get '/signup' do
    #set up an empty user object to hold the new user signing up
    @user = User.new
    erb(:signup)
end

post '/signup' do
    #params is a hash holding all values from input fields in signup
    #taking user input values from params has
    email = params[:email]
    avatar_url = params[:avatar_url]
    username = params[:username]
    password = params[:password]
    
    #if all the fields are completed, commented out for a better way
    #if email.present? && avatar_url.present? && username.present? && password.present?
    
    #instantiate user object, save to instance variable 
    @user = User.new({email: email, avatar_url: avatar_url, username: username, password: password})
        
    #If all validations pass, this saves user and returns true 
    #If not, assigns errors to user errors attribute and returns false
    #also assigns error messages to full_messages attribute of errors
    if @user.save
        #how do I make this display nicely. should this also be rendered in erb(:signup)?
        redirect to('\login')
    else
        #render the signup erb file
        erb(:signup)
    end
end

get '/posts/new' do
    @post = FinstagramPost.new
    erb(:'posts/new')
end

# adding a new mishtagram post
post '/posts' do
    photo_url = params[:photo_url]
    text = params[:caption]
    
    #instatiate new post object with photo URL
    @post = FinstagramPost.new({photo_url: photo_url, user_id: current_user.id})
    
    if @post.save
        if text != ""
            comment = Comment.new({text: text, user_id: current_user.id, finstagram_post_id: @post.id})
            comment.save
        end
        redirect to('/')
    else
        #render the new post erb with error messages
        erb(:'posts/new')
    end
end

#view an individual post
#:id in the path will capture whatever is there into params[:id]
get '/posts/:id' do
    #find the post for whatever id is in the url
    @post = FinstagramPost.find(params[:id])
    erb(:'posts/show')
end

#add sumbitted comment to database
post '/comments' do
    text = params[:text]
    finstagram_post_id = params[:finstagram_post_id]

    comment = Comment.new({text: text, finstagram_post_id: finstagram_post_id, user_id: current_user
    .id})
    comment.save
    
    #redirects to wherever we came from
    redirect(back)
end

post '/likes' do
    finstagram_post_id = params[:finstagram_post_id]
    
    like = Like.new({user_id: current_user.id, finstagram_post_id: finstagram_post_id})
    like.save
    
    redirect(back)
end