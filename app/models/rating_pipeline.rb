class RatingPipeline < ActiveRecord::Base
  attr_accessible :rating, :tasting_date_text, :tasting_notes, :tasting_date, :front_label, :back_label
  
  # has_attached_file :front_label, :back_label
  has_attached_file :front_label
  has_attached_file :back_label
  
  validate  :check_tasting_date_text

  before_save :save_tasting_date_text  

  attr_writer :tasting_date_text
  
  # getter for virtual attribute tasting_date_text
  def tasting_date_text
    # instance variable for persistence (see attr_writer)
    @tasting_date_text || tasting_date.try(:strftime, "%m/%d/%Y")
  end

  # setter for virtual attribute date_added_to_cellar
  def save_tasting_date_text 
    self.tasting_date = Chronic::parse(@tasting_date_text) if @tasting_date_text.present?
  end

  def check_tasting_date_text
    if @tasting_date_text.present? && Chronic::parse(@tasting_date_text).nil?
      errors.add :tasting_date_text, "cannot be parsed"
    end
  rescue ArgumentError
    errors.add :tasting_date_text, "is out of range"
  end

end
