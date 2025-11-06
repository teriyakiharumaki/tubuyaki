module PostsHelper
  def posted_time_ago(post)
    "#{time_ago_in_words(post.created_at)}前"
  end
end
