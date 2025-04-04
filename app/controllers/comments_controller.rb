class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show update destroy ]
  before_action :set_post, only: %i[ index create ]
  before_action :require_post_ownership, only: %i[ update destroy ]

  # GET /posts/1/comments
  def index
    @comments = @post.comments

    render json: @comments
  end

  # GET /posts/1/comments/1
  def show
    render json: @comment
  end

  # POST /posts/1/comments
  def create
    @comment = @post.comments.new(comment_params)

    if @comment.save
      render json: @comment, status: :created, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1/comments/1
  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1/comments/1
  def destroy
    @comment.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params.expect(:post_id))
    end

    def set_comment
      @comment = Comment.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.expect(comment: [ :content, :post_id ]).merge(user_id: Current.user.id)
    end

    def require_post_ownership
      unless @post.user_id == Current.user.id
        render json: { error: "You are not authorized to perform this action." }, status: :forbidden
      end
    end
end
