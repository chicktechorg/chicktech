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

  def show
    @comment = Comment.find(params[:id])
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      flash[:notice] = "Your comment has been updated."
      redirect_to @comment
    else
      render :edit
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Your comment has been deleted."
    redirect_to @comment.commentable
  end

private
  def comment_params
    params.require(:comment).permit(:content, :commentable_id, :commentable_type)
  end
end
