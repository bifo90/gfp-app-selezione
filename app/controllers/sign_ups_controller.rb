class SignUpsController < ApplicationController
    unauthenticated_access_only
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      start_new_session_for(@user)
      redirect_to new_session_path, notice: { title: "Account creato con successo", description: "Effettua il login." }
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.expect(user: [ :first_name, :last_name, :email_address, :password, :password_confirmation ])
  end
end
