class PostsController < ApplicationController

  before_action :move_to_index, except: :index

  def index
    @posts = Post.all.includes(:user).order("created_at DESC").page(params[:page]).per(5)
  end

  def new
    @post = Post.new
  end

  def create
    Post.create(text: create_params[:text], user_id: current_user.id)
    redirect_to controller: :posts, action: :index
  end

  def destroy
    post = Post.find(params[:id])
    if post.user_id == current_user.id
      post.destroy
    end
    redirect_to controller: :posts, action: :index
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    if post.user_id == current_user.id
      post.update(create_params)
    end
    redirect_to controller: :posts, action: :index
  end

  private
  def create_params
    params.require(:post).permit(:text)
  end

  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end

end
