class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  include Verify
  require 'rubygems' 
require 'twilio-ruby' 
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
 def create
@user = User.new(user_params)
    if valid_phone_number?(user_params['country_code'], user_params['phone_number'])
      if (@user.save)
         @client = Twilio::REST::Client.new( 'AC7a434b2f7c777b49c06b04afe8521b34' , 'f2970ecc477396ac28d0e4871ba91255') 
          message = @client.messages.create(  
                             from: '+16097784262',       
                             to: '+919540659717' ,
                              body: 'You are a verified user'
                           )

      redirect_to @user, notice: 'You have a valid phone number!'
    end
    else
      flash.alert = 'Please enter a valid phone number'
      render :new
    end
end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
 def update
    if  valid_confirmation_code?(params['code'], @user.country_code, @user.phone_number)
      @user.update(verified: true)

      redirect_to users_path, notice: "#{@user.phone_number} has been verified!"
    else
      redirect_to @user, alert: 'invalid or expired token'
    end
  end
  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :country_code, :phone_number)
    end
end
