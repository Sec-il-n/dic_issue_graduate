class SuggestsController < ApplicationController
  include SuggestsHelper
  include SuggestConcern
  before_action :set_suggest, only:[:show, :edit, :update, :destroy]
  before_action :not_admin, only:[:edit, :update, :destroy]
  before_action :corp_prop_registerd, only:[:new, :create]
  def new
    @suggest = Suggest.new
    @suggest.suggest_tags.build
    2.times{@suggest.images.build}
  end
  def create
    @suggest = Suggest.new(suggest_params)
    if params[:back]
      render 'new'
    else
      if @suggest.save
        Participant.create(suggest_id: @suggest.id, user_id: current_user.id)
        redirect_to participants_path,
        # redirect_to suggests_path,
        notice: t('.suggest.created')
      else
        flash.now[:warning] = t('.suggest.create_faild')
        render 'new'
      end
    end
  end
  # def confirm
  #   @suggest = Suggest.new(suggest_params)
  #   @images = @suggest.images.collect(&:image)
  #   @tags = @suggest.tags.collect(&:name)
  #
  #   if @suggest.invalid?
  #     @suggest.suggest_tags.build
  #     2.times{@suggest.images.build}
  #     render 'new'
  #
  #   elsif @suggest.valid?
  #     @suggest.suggest_tags.build
  #     2.times{@suggest.images.build}
  #     flash.now[:notice] = t('.confirmation')
  #     render 'confirm'
  #
  #   end
  # end
  def index
    @suggests = Suggest.all.default_orderd.page(params[:page]).per(5)
    if params[:tag].present?
      @suggests = Tag.find_by(id: params[:tag]).suggests.all.page(params[:page]).per(5)
    elsif params[:category_id].present?
      @suggests = @suggests.category_search(params[:category_id])
    end
  end
  def show
    # @comment = Comment.new
    # @comments = @suggest.comments.recent
    if params[:comment_id]
      @comment = @suggest.comments.where(id: params[:comment_id])
      render template: "comments/ajax_edit"
    else
      @comment = Comment.new
      @comments = @suggest.comments.recent
    end
  end
  def edit
    image_saved = @suggest.images.count
    case image_saved
    when 0
      2.times{@suggest.images.build}
    when 1
      1.times{@suggest.images.build}
    end
  end
  def update
    if current_user.admin? &&
    begin @suggest.update!(suggest_update_params)
      redirect_to admin_users_path, notice: t('.updated')
    rescue => e
      puts e.class
      redirect_to admin_users_path, notice: '更新に失敗しました'
    end
    else
      redirect_to suggests_path, danger: t('.need admin')
    end
  end
  def destroy
    begin
      @suggest.destroy!
      redirect_to admin_users_path, notice: "#{@suggest.title}#{t('.destroyed')}"
    rescue => e
      puts e.class
      puts e
      redirect_to admin_users_path, danger: t('.destroy faild')
    end
  end
end
