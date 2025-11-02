class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_password_path, alert: { title: "Accesso negato", description: "Prova un altro indirizzo email." } }

  def new
  end

  def create
    if user = User.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to new_session_path, notice: { title: "Inviata una email", description: "Se esiste un utente con quell'indirizzo email." }
  end

  def edit
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      @user.sessions.destroy_all
      redirect_to new_session_path, notice: { title: "Password aggiornata", description: "Ora puoi accedere con la tua nuova password." }
    else
      redirect_to edit_password_path(params[:token]), alert: { title: "Le password non corrispondono", description: "Per favore riprova." }
    end
  end

  private
    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: { title: "Link non valido", description: "Il link per il reset della password non è valido o è scaduto." }
    end
end
