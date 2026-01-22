class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.includes(:user, :category).order(created_at: :desc)
  end
end
