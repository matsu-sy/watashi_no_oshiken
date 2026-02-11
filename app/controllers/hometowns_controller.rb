class HometownsController < ApplicationController
  def create
    current_user.hometowns.create!(hometown_params)
    redirect_to edit_mypage_path
  end

  def update
    hometown = current_user.hometowns.find(params[:id])
    hometown.update!(hometown_params)
    redirect_to edit_mypage_path
  end

  def destroy
    hometown = current_user.hometowns.find(params[:id])
    hometown.destroy!
    redirect_to edit_mypage_path
  end
  
  private

  def hometown_params
    params.require(:hometown).permit(:prefecture_code)
  end
end
