class PostsController < ApplicationController
  before_action :set_post, only: %i[ show destroy ]
  before_action :require_post_ownership, only: %i[ destroy ]

  # GET /posts
  def index
    user = Current.user
    following_ids = user.following.pluck(:followed_id)
    following_ids << user.id

    @posts = Post
      .left_outer_joins(:likes)
      .select(
        "posts.*",
        "COUNT(CASE WHEN likes.user_id = #{Current.user.id} THEN 1 END) > 0 AS liked_by_current_user"
      )
      .where(user_id: following_ids)
      .group("posts.id")

    render json: @posts
  end

  # GET /posts/1
  def show
    render json: @post
  end

  # POST /posts
  def create
    @post = Post.new(post_params)

    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy!
  end

  def like
    unless %w[ ADD REMOVE ].include?(like_params)
      render json: { error: "invalid type" }, status: :bad_request
      return
    end

    case like_params
    when "REMOVE"
      @post.remove_like(Current.user)
    when "ADD"
      @post.add_like(Current.user)
    end

    head :ok
  end

  def share
    original_post = Post.find params.expect(:id)

    if original_post.share(Current.user)
      head :ok
    else
      render json: { error: "Failed to share" }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.expect(post: [ :body ]).merge(user_id: Current.user.id)
    end

    def like_params
      params.expect(:type)
    end

    def require_post_ownership
      unless @post.user_id == Current.user.id
        render json: { error: "You are not authorized to perform this action." }, status: :forbidden
      end
    end
end
