class UsersController < ApplicationController
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction
	
  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
		@users = User.order(sort_column + " " + sort_direction)
			           .search_users(params[:search], params[:page])
								 .where(['id != ?', current_user.id])
		if @users.blank? 
			flash.now[:alert] = "There are no users found."
		end
	end

  def show
    @user = User.find(params[:id])
  end
  
  def update
    authorize! :update, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user], :as => :admin)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end
    
  def activate
		@user = User.find(params[:id]);
		@user.update_attributes({:active => true})
		redirect_to(:back)
	end
	
	def deactivate
		@user = User.find(params[:id]);
		@user.update_attributes({:active => false})
		redirect_to(:back)
	end
    
  def destroy
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end
	
	private
  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end