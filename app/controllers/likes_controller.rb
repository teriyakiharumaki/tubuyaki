class LikesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!
  before_action :set_post

  def create
    current_user.likes.find_or_create_by!(post: @post)
    respond_to do |format|
      format.html { redirect_back fallback_location: post_path(@post), notice: "いいねしました" }
      format.turbo_stream do
        flash.now[:notice] = "いいねしました"
        render turbo_stream: [
          turbo_stream.replace(dom_id(@post, :likes),      partial: "posts/likes",        locals: { post: @post }),
          turbo_stream.replace(dom_id(@post, :like_button), partial: "posts/like_button", locals: { post: @post }),
          turbo_stream.replace("flash", partial: "shared/flash")
        ]
      end
    end
  end

  def destroy
    current_user.likes.where(post: @post).destroy_all
    respond_to do |format|
      format.html { redirect_back fallback_location: post_path(@post), notice: "いいねを取り消しました" }
      format.turbo_stream do
        flash.now[:notice] = "いいねを取り消しました"
        render turbo_stream: [
          turbo_stream.replace(dom_id(@post, :likes),       partial: "posts/likes",        locals: { post: @post }),
          turbo_stream.replace(dom_id(@post, :like_button),  partial: "posts/like_button", locals: { post: @post }),
          turbo_stream.replace("flash", partial: "shared/flash")
        ]
      end
    end
  end

  private
  def set_post
    @post = Post.find(params[:post_id])
  end
end
