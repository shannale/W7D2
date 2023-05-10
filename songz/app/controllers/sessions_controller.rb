class SessionsController < ApplicationController
    def new
        @user = User.new
        render :new
    end
  
    def create
    #   debugger
      @user = User.find_by_credentials(params[:user][:email],params[:user][:password])
  
      if @user
        login!(@user)
        redirect_to user_url(@user)
      else
        flash.now[:errors] = ["Do you not remember your login?"]
        @user = User.new(email: params[:user][:email])
        return :new
      end
    end
  
    def destroy
      logout!
      flash[:message] = ["BYE BYE"]
      redirect_to new_session_url
    end
end
