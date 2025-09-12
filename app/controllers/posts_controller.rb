class PostsController < ApplicationController
  include ActionView::RecordIdentifier 

  before_action :authenticate_user!, only: [:new, :create, :like]

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

  def show
    @post = Post.find(params[:id])
  end

  def like
    @post = Post.find(params[:id])
    @post.increment!(:likes_count)
    respond_to do |format|
      format.html { redirect_back fallback_location: post_path(@post), notice: "いいねしました" }
      format.turbo_stream do
        flash.now[:notice] = "いいねしました"
        render turbo_stream: [
          turbo_stream.replace(
            dom_id(@post, :likes),
            partial: "posts/likes",
            locals: { post: @post }
          ),
          turbo_stream.replace(
            "flash",
            partial: "shared/flash"
          )
        ]
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end
end
