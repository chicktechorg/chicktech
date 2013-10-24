class CommentsController < ApplicationController::Base
  def index
    @comments = Comment.all
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      flash[:notice] = "Your comment has been created."
      redirect_to @comment.commentable
    else
      render :new
    end
  end

private
  def comment_params
    params.require(:comment).permit(:content, :commentable_id, :commentable_type)
  end
end