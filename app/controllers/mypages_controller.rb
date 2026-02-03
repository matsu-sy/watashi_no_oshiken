class MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @hometowns = current_user.hometowns
  end
end
