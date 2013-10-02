class RatingPipeline < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :rating, :tasting_date_text, :tasting_notes, :front_label, :back_label
  
  # has_attached_file :front_label, :back_label
  has_attached_file :front_label, :styles => { :original => "600x600>", :thumbnail => "150x150>"}
  has_attached_file :back_label, :styles => {  :original => "600x600>", :thumbnail => "150x150>"}
  
  # validate runs when the data is returned, before_save before the record is committed to the database
  # attr_writer makes the attribute available for writing -- maybe becuase there is no real setter?
  validate  :check_tasting_date_text
  before_save :save_tasting_date_text  
  attr_writer :tasting_date_text
  
  # Make rating nullable, but make sure if it is included it is an integer between 1 and 10.
  validates :rating, inclusion: 1..10, allow_nil: true
  
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
