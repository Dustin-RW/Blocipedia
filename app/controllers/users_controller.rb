class UsersController < ApplicationController
    def new
        @user = User.new
    end

    def create
        @user = User.new
        @user.email = params[:user][:email]
        @user.password = params[:user][:password]
        @user.password_confirmation = params[:user][:password_confirmation]

        if @user.save
            flash[:notice] = "#{@user.email} created"
            create_session(@user)
            redirect_to wikis_path
        else
            render 'new'
        end
    end

    def show
        @user = current_user
    end

    def confirm
        @user = current_user

        @user.role = 'standard'

        privatewikis = @user.wikis.where(private: true)

        privatewikis.each do |privatewiki|
          privatewiki.update_attribute(:private, false)
        end



        if @user.save!
            flash[:notice] = 'Downgraded role to standard and all private wikis set to public'
            redirect_to wikis_path
        else
            flash[:alert] = 'error, please try again'
            redirect_to my_account_path
        end
    end


end
