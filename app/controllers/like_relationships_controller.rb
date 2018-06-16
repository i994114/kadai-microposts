class LikeRelationshipsController < ApplicationController
  before_action :require_user_logged_in
  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.like_set(micropost)
    flash[:success] = 'micropostをお気に入り登録しました'
    redirect_to root_url
  end

  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.like_out(micropost)
    flash[:success] = 'micropostをお気に入りから外しました'
    redirect_to root_url
    
  end
  
  
  
end
