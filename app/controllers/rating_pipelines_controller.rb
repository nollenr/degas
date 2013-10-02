class RatingPipelinesController < ApplicationController
  # GET /rating_pipelines
  # GET /rating_pipelines.json
  def index
    @rating_pipelines = current_user.rating_pipelines.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rating_pipelines }
    end
  end

  # GET /rating_pipelines/new
  # GET /rating_pipelines/new.json
  def new
    @rating_pipeline = current_user.rating_pipelines.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rating_pipeline }
    end
  end

  # GET /rating_pipelines/1/edit
  def edit
    @rating_pipeline = current_user.rating_pipelines.find(params[:id])
  end

  # POST /rating_pipelines
  # POST /rating_pipelines.json
  def create
    @rating_pipeline = current_user.rating_pipelines.new(params[:rating_pipeline])

    respond_to do |format| 
      if @rating_pipeline.save
        format.html { redirect_to rating_pipelines_path, notice: 'Rating pipeline was successfully created.' }
        format.json { render json: @rating_pipeline, status: :created, location: @rating_pipeline }
      else
        format.html { render action: "new" }
        format.json { render json: @rating_pipeline.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rating_pipelines/1
  # PUT /rating_pipelines/1.json
  def update
    @rating_pipeline = current_user.rating_pipelines.find(params[:id])

    respond_to do |format|
      if @rating_pipeline.update_attributes(params[:rating_pipeline])
        format.html { redirect_to rating_pipelines_path, notice: 'Rating pipeline was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @rating_pipeline.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rating_pipelines/1
  # DELETE /rating_pipelines/1.json
  def destroy
    @rating_pipeline = current_user.rating_pipelines.find(params[:id])
    @rating_pipeline.destroy

    respond_to do |format|
      format.html { redirect_to rating_pipelines_url }
      format.json { head :no_content }
    end
  end
  
  def convert
    @rating_pipeline = current_user.rating_pipelines.find(params[:id])
    @bottle = Bottle.new
    @bottle[:is_for_rating_only] = true
    @bottle[:rating] = @rating_pipeline[:rating]
    @bottle[:date_added_to_cellar] = @rating_pipeline[:tasting_date]
    @bottle[:notes] = @rating_pipeline[:tasting_notes]
    render 'bottles/new'
  end

end
