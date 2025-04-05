class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show destroy ]
  before_action :set_post, only: %i[ index create ]
  before_action :require_post_ownership, only: %i[ destroy ]

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
    @comment = @post.add_comment(Current.user, comment_params[:content])

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1/comments/1
  def destroy
    @comment.destroy!
  end

  def like
    unless %w[ ADD REMOVE ].include?(like_params)
      render json: { error: "invalid type" }, status: :bad_request
      return
    end

    case like_params[:action]
    when "REMOVE"
      @comment.remove_like(Current.user)
    when "ADD"
      @comment.add_like(Current.user)
    end
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

    def like_params
      params.expect(:type)
    end

    def require_post_ownership
      unless @post.user_id == Current.user.id
        render json: { error: "You are not authorized to perform this action." }, status: :forbidden
      end
    end
end
