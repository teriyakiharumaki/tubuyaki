class PostsController < ApplicationController
  include ActionView::RecordIdentifier 

  before_action :authenticate_user!, only: [:new, :create, :destroy, :edit, :update]
  before_action :set_post, only: [:show, :destroy, :edit, :update]
  before_action :authorize_owner!, only: [:destroy, :edit, :update]  

  def index
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: "投稿しました"
    else
      flash.now[:alert] = "投稿に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "更新しました"
    else
      flash.now[:alert] = "更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_path, notice: "つぶやきを削除しました" }
      format.turbo_stream
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_owner!
    redirect_to posts_path, alert: "権限がありません" unless @post.user_id == current_user&.id
  end

  def post_params
    params.require(:post).permit(:body)
  end
end
