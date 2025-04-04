class PostsController < ApplicationController
  before_action :set_post, only: %i[ show update destroy ]
  before_action :require_post_ownership, only: %i[ update destroy ]

  # GET /posts
  def index
    user = Current.user
    following_ids = user.following.pluck(:followed_id)
    following_ids << user.id

    @posts = Post.where(user_id: following_ids).order_by(created_at: :desc)
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
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy!
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

    def require_post_ownership
      unless @post.user_id == Current.user.id
        render json: { error: "You are not authorized to perform this action." }, status: :forbidden
      end
    end
end
