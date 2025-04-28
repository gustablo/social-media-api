class PostsController < ApplicationController
  before_action :set_post, only: %i[ show destroy ]
  before_action :require_post_ownership, only: %i[ destroy ]

  # GET /posts
  def index
    user = Current.user
    following_ids = user.following.pluck(:followed_id)
    following_ids << user.id

    per_page = 20
    cursor = params[:cursor].to_i || 0
    offset = (cursor * per_page)

    @posts = Post.where(user_id: following_ids).limit(per_page).offset(offset).order(created_at: :desc)

    render json: { results: @posts.as_json, next: cursor + 1 }
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
    if @post.parent_post_id.present?
      @post.unshare
    else
      @post.destroy!
    end
  end

  def like
    unless %w[ ADD REMOVE ].include?(like_params)
      render json: { error: "Invalid type" }, status: :bad_request
      return
    end

    @post = Post.find params.expect(:post_id)

    case like_params
    when "REMOVE"
      @post.remove_like(Current.user)
    when "ADD"
      @post.add_like(Current.user)
    end

    head :ok
  end

  def share
    original_post = Post.find params.expect(:post_id)
    new_post = original_post.share(post_params)
    if new_post
      render json: new_post, status: :ok
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
      params.expect(post: [ :body, media_files: [] ]).merge(user_id: Current.user.id)
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
