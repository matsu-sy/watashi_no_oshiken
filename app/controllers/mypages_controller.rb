class MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @hometowns = current_user.hometowns

    reacted_ids =
      current_user.reactions
        .group(:post_id)
        .order(Arel.sql("MAX(created_at) DESC"))
        .pluck(:post_id)

    @reacted_posts =
      if reacted_ids.empty?
        Post.none
      else
        Post
          .includes(:user, :category, :reactions)
          .where(id: reacted_ids)
          .order(Arel.sql("array_position(ARRAY[#{reacted_ids.join(',')}], posts.id)"))
      end
  end

  def edit
    @user = current_user
    @hometowns = @user.hometowns
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to mypage_path
    else
      @hometowns = @user.hometowns
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :image, :hometown_visibility)
  end
end
