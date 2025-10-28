class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :authorize_me!, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "アカウントを作成しました！"
    else
      flash.now[:alert] = "登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    own_posts = @user.posts
                     .includes(:user)
                     .select('posts.*, posts.created_at AS acted_at, NULL::integer AS actor_id, \'post\' AS kind')
    reposted_posts = Post.joins(:reposts)
                         .where(reposts: { user_id: @user.id })
                         .includes(:user)
                         .select('posts.*, reposts.created_at AS acted_at, reposts.user_id AS actor_id, \'repost\' AS kind')
    @timeline = (own_posts.to_a + reposted_posts.to_a)
                  .sort_by { |r| r.acted_at }
                  .reverse
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "プロフィールを更新しました"
    else
      flash.now[:alert] = "更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :bio)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_me!
    redirect_to user_path(@user), alert: "権限がありません" unless current_user&.id == @user.id
  end
end
