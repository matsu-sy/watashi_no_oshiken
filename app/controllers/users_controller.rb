class UsersController < ApplicationController
  def show
    @user = User.includes(hometowns: :prefecture).find(params[:id])
    @hometowns = @user.hometowns
  end
end
