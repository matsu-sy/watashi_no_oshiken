class PostsController < ApplicationController
  before_action :authenticate_user!, except: [ :index ]

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

  def show
    @post = Post.includes(:user, :category).find(params[:id])
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: t("flash_message.posts.update.success", item: Post.model_name.human)
    else
      flash.now[:alert] = t("flash_message.posts.update.failure")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy!
    redirect_to posts_path, notice: t("flash_message.posts.deleted.success", item: Post.model_name.human)
  end

  private

  def post_params
    params.require(:post).permit(:prefecture_code, :category_id, :body, :image, :place_name)
  end
end
