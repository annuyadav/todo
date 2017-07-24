class UsersController < ApplicationController
  def crop_profile_pic
    img = Magick::Image.from_blob(params[:user][:profile_pic].read)[0]
    cropped_image=img.crop(params[:x].to_f,params[:y].to_f,params[:width].to_f,params[:height].to_f).thumbnail(User::THUMBNAIL_WIDTH,User::THUMBNAIL_HEIGHT)
    dir = FileUtils.mkdir(File.join(Rails.root,SecureRandom.uuid))
    cropped_image.write(File.join(dir[0] , params[:user][:profile_pic].original_filename))
    current_user.profile_pic = File.open(File.join(dir[0],params[:user][:profile_pic].original_filename))
    current_user.save
    FileUtils.rm_rf(dir)
  end

  def remove_profile_pic
    current_user.profile_pic_destroy!
    current_user.stamp_destroy!
    redirect_to my_profile_edit_url
  end

  def update_with_password
    user=current_user
    if current_user.update_with_password(user_password_params)
      flash[:now]= 'Password successfully updated.'
      sign_in(user, :bypass => true)
    else
      flash[:error]="Password update failed, because of #{current_user.errors.full_messages.join('. ')}"
    end
    redirect_to :back
  end

  def update_without_password
    if current_user.update(user_email_params)
      if current_user.previous_changes[:email].class == Array
        current_user.confirmed_at=nil
        current_user.save
        current_user.send_confirmation_instructions
      end
      flash[:now]='Profile successfully updated.'
    else
      flash[:error]="Profile update failed, because of#{current_user.errors.full_messages.join('. ')}"
    end
    redirect_to :back
  end

  private
  def user_password_params
    params.require(:user).permit(:id, :password, :password_confirmation, :current_password)
  end

  def user_email_params
    params.require(:user).permit(:id, :first_name, :last_name, :email)
  end
end