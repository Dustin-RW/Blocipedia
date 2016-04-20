class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])

    if user
      session[:user_id] = user.id
      flash[:notice] = "Logged In"
      redirect_to wikis_path
    else
      flash[:alert] = "Invalid email or password"
      render "new"
    end

  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to root_url
  end
end
