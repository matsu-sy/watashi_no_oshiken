class PostsController < ApplicationController
  before_action :authenticate_user!, except: [ :index ]
  before_action :set_post, only: %i[show edit update destroy destroy_image]
  before_action :authorize_post!, only: %i[edit update destroy destroy_image]

  def index
    base = Post.includes(:user, :category, :reactions).order(created_at: :desc)

    # 未ログインは常に all
    unless user_signed_in?
      @posts = base
      @current_filter = "all"
      @hometown_not_registered = false
      return
    end

    # ログイン時のみ filter
    @current_filter = normalize_filter(params[:filter])

    if @current_filter == "all"
      @posts = base
      @hometown_not_registered = false
      return
    end

    # hometown タブ
    if current_user.hometowns.exists?
      codes = current_user.hometowns.pluck(:prefecture_code)
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

  def destroy_image
    @post.image.purge_later if @post.image.attached?
    redirect_to edit_post_path(@post), notice: t("flash_message.posts.image_deleted.success")
  end


  private

  def post_params
    params.require(:post).permit(:prefecture_code, :category_id, :body, :image, :place_name)
  end

  def normalize_filter(raw)
    filter = raw.presence || "hometown"
    %w[all hometown].include?(filter) ? filter : "hometown"
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_post!
    redirect_to posts_path, alert: t("flash_message.posts.not_authorized") unless current_user.own?(@post)
  end
end