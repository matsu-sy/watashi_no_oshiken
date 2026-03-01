class PostsController < ApplicationController
  before_action :authenticate_user!, except: [ :index ]

  def index
    @current_filter = normalize_filter(params[:filter])

    base = Post.includes(:user, :category, :reactions).order(created_at: :desc)

    if @current_filter == "all"
      @posts = base
      @hometown_not_registered = false
      return
    end

    # hometown タブ
    if user_signed_in? && current_user.hometowns.exists?
      codes = current_user.hometowns.pluck(:prefecture_code) # => [8, 13, ...]
      @posts = base.where(prefecture_code: codes)
      @hometown_not_registered = false
    else
      @posts = []
      @hometown_not_registered = true
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to posts_path(filter: "all"), notice: t("flash_message.posts.create.success")
    else
      flash.now[:alert] = t("flash_message.posts.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.includes(:user, :category, :reactions).find(params[:id])
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

  def normalize_filter(raw)
    filter = raw.presence || "hometown"
    %w[all hometown].include?(filter) ? filter : "hometown"
  end
end
