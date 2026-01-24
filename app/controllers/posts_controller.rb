class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.includes(:user, :category).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to posts_path, notice: t("flash_message.posts.create.success")
    else
      flash.now[:alert] = t("flash_message.posts.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:prefecture_code, :category_id, :body, :image, :place_name)
  end
end
