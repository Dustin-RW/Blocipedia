class WikisController < ApplicationController


  before_action :require_sign_in, except: [:index, :show]

  before_action :confirm_authorization, except: [:index, :show]


  def index
    @wikis = policy_scope(Wiki)
  end

  def show
    @wiki = Wiki.find(params[:id])

    unless @wiki.private? == false || (current_user.premium? || current_user.admin?)
      flash[:alert] = "You must be a premium member or admin to do that"
      redirect_to :back
    end
  end

  def new
    @wiki = Wiki.new
    @users = User.all
  end

  def create
    @wiki = current_user.wikis.new(wiki_params)

    if @wiki.save(wiki_params)

      params[:collaborator_ids].each do |uid|
        Collaboration.create!({wiki_id: @wiki.id, user_id: uid})
      end

      flash[:notice] = "Wiki was saved"
      redirect_to wikis_path
    else
      flash.now[:alert] = 'There was an error saving the wiki.  Please try again'
      render :new
    end


  end

  def edit
    @wiki = Wiki.find(params[:id])
    @users = User.all
  end

  def update


    @wiki = Wiki.find(params[:id])
    @wiki.assign_attributes(wiki_params)
    @wiki.collaborations = [] # TOOK ME FOREVER TO FIGURE THIS OUT, HIP HIP HURRAY!

    authorize @wiki

    if @wiki.update(wiki_params)

        #params[:collaborator_ids].each do |uid|
          #Collaboration.find({wiki_id: params[:id], user_id: uid})
          #Collaboration.destroy({wiki_id: params[:id], user_id: uid})
        #end

        #params[:collaborator_ids].each do |uid|
          #@collaboration = Collaboration.find({wiki_id: params[:id], user_id: uid})
          #@collaboration.destroy
        #end

          unless params[:collaborator_ids].nil?
            params[:collaborator_ids].each do |uid|
              Collaboration.create!({wiki_id: params[:id], user_id: uid})
            end
          end


      flash[:notice] = 'Wiki was updated.'
      redirect_to @wiki
    else
      flash.now[:alert] = 'There was an error saving the wiki. Please try again'
      render :edit
    end

  end

  def destroy
    @wiki = Wiki.find(params[:id])

    authorize @wiki

    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully"
      redirect_to wikis_path
    else
      flash.now[:alert] = 'There was an error deleting the wiki.'
      render :show
    end
  end


  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end

  def owner
    if wiki.include?(current_user)
      owner = current_user.id
    end
  end


  def confirm_authorization
    if current_user.nil? || current_user.standard?
      flash[:alert] = "Access denied, must be a premium member or admin to do that"
      redirect_to wikis_path
    end
  end


end
