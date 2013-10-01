class RatingPipelinesController < ApplicationController
  # GET /rating_pipelines
  # GET /rating_pipelines.json
  def index
    @rating_pipelines = RatingPipeline.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rating_pipelines }
    end
  end

  # GET /rating_pipelines/1
  # GET /rating_pipelines/1.json
  def show
    @rating_pipeline = RatingPipeline.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rating_pipeline }
    end
  end

  # GET /rating_pipelines/new
  # GET /rating_pipelines/new.json
  def new
    @rating_pipeline = RatingPipeline.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rating_pipeline }
    end
  end

  # GET /rating_pipelines/1/edit
  def edit
    @rating_pipeline = RatingPipeline.find(params[:id])
  end

  # POST /rating_pipelines
  # POST /rating_pipelines.json
  def create
    logger.debug "Okay....................creating rating pipeline in controller"
    @rating_pipeline = RatingPipeline.new(params[:rating_pipeline])
    logger.debug "Okay....................instance variables created in controller"
    logger.debug "controller variables are: #{@rating_pipeline.inspect}"
    
    @rating_pipeline.tasting_date = '30-Sept-2013'

    respond_to do |format| 
      logger.debug"okee dokee..........gettin ready to save"
      if @rating_pipeline.save
        format.html { redirect_to @rating_pipeline, notice: 'Rating pipeline was successfully created.' }
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
    @rating_pipeline = RatingPipeline.find(params[:id])

    respond_to do |format|
      if @rating_pipeline.update_attributes(params[:rating_pipeline])
        format.html { redirect_to @rating_pipeline, notice: 'Rating pipeline was successfully updated.' }
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
    @rating_pipeline = RatingPipeline.find(params[:id])
    @rating_pipeline.destroy

    respond_to do |format|
      format.html { redirect_to rating_pipelines_url }
      format.json { head :no_content }
    end
  end
end
