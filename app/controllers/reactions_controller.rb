class ReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_reaction_type

  def create
    current_user.reactions.find_or_create_by!(
      post: @post,
      reaction_type: @reaction_type
    )
    redirect_back fallback_location: post_path(@post)
  end

  def destroy
    current_user.reactions.find_by(
      post: @post,
      reaction_type: @reaction_type
    )&.destroy
    redirect_back fallback_location: post_path(@post)
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_reaction_type
    @reaction_type = params.require(:reaction_type)
  end
end
