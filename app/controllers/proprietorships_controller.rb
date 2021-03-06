class ProprietorshipsController < ApplicationController
  include UsersHelper
  include ProprietorshipConcern
  before_action :set_proprietorship, only:[:show, :edit, :update, :destroy]
  before_action :create_not_permitted, only:[:new, :create]
  before_action :edit_not_permitted, only:[:edit, :update, :destroy]
  def new
    # @proprietorship = Proprietorship.new(session[:proprietorship] || {})
    @proprietorship = Proprietorship.new
  end
  def create
    @proprietorship = Proprietorship.new(params_proprietorship)
    if @proprietorship && @proprietorship.save
      update_user_proprietorship_id
      redirect_to proprietorship_path(@proprietorship), notice: t('.registerd')
    else
      # session[:proprietorship] = @proprietorship.attributes.slice(*params_proprietorship.keys)
      # flash.now[:danger] = '不正な画面遷移が行われました'
      # redirect_to new_corporation
      flash.now[:danger] = '企業登録が失敗しました'
      render 'new'
    end
  end
  def show
    @user = @proprietorship.user
  end
  def edit
  end
  def update
    begin
      @proprietorship.update!(params_proprietorship)
      redirect_to proprietorship_path(@proprietorship), notice: '企業登録(個人)を編集しました'
    rescue => e
      puts e.class
      flash.now[:danger] = '編集に失敗しました'
      render 'edit'
    end
  end
end
