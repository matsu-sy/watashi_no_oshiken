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

    ActiveRecord::Base.transaction do
      unless @user.update(user_params.except(:hometown_prefecture_codes))
        raise ActiveRecord::Rollback
      end

      validate_hometowns_input!(@user, user_params[:hometown_prefecture_codes])

      if @user.errors.any?
        raise ActiveRecord::Rollback
      end

      apply_hometowns!(@user, user_params[:hometown_prefecture_codes])
    end

    if @user.errors.any?
      @hometowns = @user.hometowns
      render :edit, status: :unprocessable_entity
    else
      redirect_to mypage_path
    end
  end

  def destroy_avatar
    current_user.avatar.purge_later if current_user.avatar.attached?
    redirect_to edit_mypage_path, notice: t("flash_message.users.avatar_deleted")
  end

  private

  def user_params
    params.require(:user).permit(:name, :avatar, :hometown_visibility, hometown_prefecture_codes: [])
  end

  def validate_hometowns_input!(user, codes_param)
    raw = Array(codes_param).map { |v| v.to_s.strip }.reject(&:blank?)
    return if raw.size == raw.uniq.size

    user.errors.add(:base, I18n.t("activerecord.errors.models.hometown.attributes.prefecture_code.taken"))
  end

  def apply_hometowns!(user, codes_param)
    codes = Array(codes_param).map { |v| v.to_s.strip }.reject(&:blank?).map(&:to_i)

    # DBにある出身地コードを取得
    existing = user.hometowns.pluck(:prefecture_code)

    # 差分を計算
    to_add = codes - existing
    to_remove = existing - codes

    # 削除
    user.hometowns.where(prefecture_code: to_remove).destroy_all if to_remove.any?

    # 追加
    to_add.each do |code|
      hometown = user.hometowns.create(prefecture_code: code)
      next if hometown.persisted?

      hometown.errors.full_messages.each { |msg| user.errors.add(:base, msg) }
      raise ActiveRecord::Rollback
    end

  rescue ActiveRecord::RecordNotUnique
    user.errors.add(:base, I18n.t("activerecord.errors.models.hometown.attributes.prefecture_code.taken"))
    raise ActiveRecord::Rollback
  end
end
