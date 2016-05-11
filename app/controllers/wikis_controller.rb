class WikisController < ApplicationController
  def index
    @wikis = policy_scope(Wiki)
  end

  def show
    @wiki = Wiki.find(params[:id])
  end

  def new
    @wiki = Wiki.new
    @users = User.all
  end

  def create
    @wiki = current_user.wikis.new(wiki_params)

    if @wiki.save

      params[:collaborator_ids].each do |uid|
        Collaboration.create!({wiki_id: params[:id], user_id: uid})
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

          params[:collaborator_ids].each do |uid|
            Collaboration.create!({wiki_id: params[:id], user_id: uid})
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



end
