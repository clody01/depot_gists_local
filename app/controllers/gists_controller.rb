class GistsController < ApplicationController
  before_action :set_gist, only: [:show, :edit, :update, :destroy]

  # GET /gists
  # GET /gists.json
  def index
  
    Gist.make_local_repository
      @gists = Gist.all
  end

  # GET /gists/1
  # GET /gists/1.json
  def show
  end

  # GET /gists/new
  def new
    @gist = Gist.new
  end

  # GET /gists/1/edit
  def edit
  end

  # POST /gists
  # POST /gists.json
  def create
    @gist = Gist.new(gist_params)

    respond_to do |format|
      if @gist.save
        format.html { redirect_to @gist, notice: 'Gist was successfully created.' }
        format.json { render :show, status: :created, location: @gist }
      else
        format.html { render :new }
        format.json { render json: @gist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gists/1
  # PATCH/PUT /gists/1.json
  def update
    respond_to do |format|
      if @gist.update(gist_params)
        format.html { redirect_to @gist, notice: 'Gist was successfully updated.' }
        format.json { render :show, status: :ok, location: @gist }
      else
        format.html { render :edit }
        format.json { render json: @gist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gists/1
  # DELETE /gists/1.json
  def destroy
    @gist.destroy
    respond_to do |format|
      format.html { redirect_to gists_url, notice: 'Gist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
def create_local_and_github_gists
     logger.info " µµµµµµµµµµµµµµµµµµµµµµµ  DEBUT CONTROLLER"
    gist = Gist.new  
    logger.info " µµµµµµµµµµµµµµµµµµµµµµµ  params[:description] = #{ params[:description]}"
    logger.info " µµµµµµµµµµµµµµµµµµµµµµµ  params[:file_liste] = #{params[:file_liste]}"
    if params[:description] != "" &&  params[:file_liste]  != ""
      gist["description"] =  params[:description]
      gist["public"] =  params[:public]
#      JSON.parse(str);
   
      files_liste = eval(params[:file_liste]) 
      logger.info " files_liste = #{files_liste}"
       
     @reponse = Gist.create_local_and_github_gists(params[:login],params[:password],gist,files_liste) 
      logger.info " ££££££££££££££££££££££££   FIN CONTROLLER"
    end
  end
  
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gist
      @gist = Gist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gist_params
      params.require(:gist).permit(:hubid, :description, :public, :userlogin, :saved,:fichiers)
    end
end
