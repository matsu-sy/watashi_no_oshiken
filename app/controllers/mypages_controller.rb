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
end
