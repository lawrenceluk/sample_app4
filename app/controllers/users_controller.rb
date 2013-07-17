class UsersController < ApplicationController
	before_action :signed_in_user, only: [:index, :edit, :update]
	before_action :correct_user,   only: [:edit, :update]
	before_action :admin_user, 	   only: :destroy
	
	def index
		@users = User.paginate(page: params[:page])
	end

  	def new
  		@user = User.new
  	end

	def show 
	  @user = User.find(params[:id])
	end

    def create
      @user = User.new(user_params)
   	  if @user.save
   	  	sign_in @user
   	  	flash[:success] = "Sign up successful! Welcome!"
	    redirect_to @user
	  else
	    render 'new'
	  end
	end

	def edit
		# before_action got the user
	end

	def update
		# before_action got the user
		if @user.update_attributes(user_params)
	      sign_in @user
	      redirect_to @user
		else 
			render 'edit'
		end
	end
	  
	def destroy
	  User.find(params[:id]).destroy
	  flash[:success] = "User was removed."
	  redirect_to users_url
	end

	private
	def user_params # the only fields that users can change
	  params.require(:user).permit(:name, :email, :password,
	                                 :password_confirmation)
	end

	def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin? && !current_user?(User.find(params[:id]))
    end

end


