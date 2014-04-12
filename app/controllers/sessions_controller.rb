class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    respond_to do |format|

      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        format.html { redirect_to users_url, :notice => "Logged in!" }
        format.json { render :json => {:response => 'Unauthorized !'} }
      else
        flash.now.alert = "Invalid email or password"
        format.html { render "new" }
        format.json { render :json => {:response => 'Unauthorized !'}, :status => 401 }
      end

    end

  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end
