class RepostsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!
  before_action :set_post

  def create
    current_user.reposts.find_or_create_by!(post: @post)
    @post.reload
    respond_to do |format|
      format.html { redirect_back fallback_location: post_path(@post) }
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            dom_id(@post, :repost_button),
            partial: "posts/repost_button",
            locals: { post: @post }
          )
        ]
      end
    end
  end

  def destroy
    current_user.reposts.where(post: @post).destroy_all
    @post.reload
    respond_to do |format|
      format.html { redirect_back fallback_location: post_path(@post) }
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            dom_id(@post, :repost_button),
            partial: "posts/repost_button",
            locals: { post: @post }
          )
        ]
      end
    end
  end

  private
  def set_post
    @post = Post.find(params[:post_id])
  end
end
