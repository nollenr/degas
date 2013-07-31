# == Schema Information
#
# Table name: bottles
#
#  id                          :integer          not null, primary key
#  bottle_id                   :integer          not null
#  grape_id                    :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  available                   :boolean          default(TRUE), not null
#  availability_change_date    :datetime
#  availability_change_message :string(255)
#  winery_id                   :integer
#  vintage                     :string(4)
#  drink_by_year               :string(4)
#  vineyard                    :string(255)
#  name                        :string(255)
#  cellar_location             :string(30)
#  price                       :decimal(8, 2)
#  user_id                     :integer          not null
#

class Bottle < ActiveRecord::Base
  belongs_to :grape
  belongs_to :winery
  belongs_to :user
  belongs_to :bottle_type
  # In order to run seed, grape_id needs to be accessible
  # attr_accessible :bottle_id, :available, :availability, :grape_id

  validates :price, allow_nil: true, numericality: { greater_than: 0.01 }
  # validates :bottle_id, presence: { message: "identifier cannot be null. Bottle not created." }, 
  #  uniqueness: { scope: :user_id, message: "bottle_id should be unique and this identifier was found in your history."}
  validates :user_id, presence: true
  validates :grape_name, presence: {message: "cannot be empty and must be a value from the list.  Bottle not created."}
  validates :winery_name, presence: {message: "cannot be empty and must be a value from the list.  Bottle not created." }
  validates :bottle_type_id, presence: true
  validate  :check_date_added_to_cellar_text
  validate  :validate_vintage
  validate  :rating_on_rating_only_bottles
  validates :rating, inclusion: 1..10, allow_nil: true
  validates :vintage, presence: {message: "cannot be empty.  Enter a 4 digit year or 'NV'.  Bottle not created."}

  before_save :save_date_added_to_cellar_text  

  attr_accessible :available, :bottle_id, :bottle_id_text,
    :cellar_location, :vintage, :drink_by_year, :name, :vineyard, 
    :grape_name, :winery_name, :price, :rating, :bottle_type_id, 
    :date_added_to_cellar_text, :notes, :confirmed, :is_for_rating_only

  #This creates the setter (writer)... correct?
  attr_writer :date_added_to_cellar_text 

  attr_accessor :bottle_id_text, :confirmed

  def availability
    return @availability
  end

  def availability= avail_bool
    @availability = avail_bool ? 'Available' : 'Consumed'
  end

  after_find :set_availability
  after_find :set_bottle_id_text

  def set_availability
    self.availability= self.available
  end

  def set_bottle_id_text
    self.bottle_id_text = self.bottle_id
  end

# For exporting to a CSV file
  def self.to_csv
    CSV.generate do |csv|
      column_set = Array.new(column_names)
      export_set = Array.new(column_set).push("winery_name","grape_name","bottle_type")
      csv << export_set
      all.each do |bottle|
        fk = Array.new
        fk.push(bottle.winery.name,bottle.grape.name,bottle.bottle_type.name)
        csv << bottle.attributes.values_at(*column_set) + fk
      end
    end
  end

  # getter for virtual attribute grape_name
  # when a bottle is loaded from the database
  # this getter is executed and "gets" the grape_name.  
  def grape_name
    return grape.try(:name)
  end

  # setter for virtual attribute grape_name
  # When a record is saved to the database
  # this setter is executed.  This sets the 
  # database column value. 
  def grape_name= name
    self.grape = Grape.find_by_name(name)
  end

  def winery_name
    return winery.try(:name)
  end

  def winery_name= name
    self.winery = Winery.find_by_name(name)
  end

  # getter for virtual attribute date_added_to_cellar
  def date_added_to_cellar_text
    # instance variable for persistence (see attr_writer)
    @date_added_to_cellar_text || date_added_to_cellar.try(:strftime, "%m/%d/%Y")
  end

  # setter for virtual attribute date_added_to_cellar
  def save_date_added_to_cellar_text	
    self.date_added_to_cellar = Chronic::parse(@date_added_to_cellar_text) if @date_added_to_cellar_text.present?
  end

  def check_date_added_to_cellar_text
    if @date_added_to_cellar_text.present? && Chronic::parse(@date_added_to_cellar_text).nil?
      errors.add :date_added_to_cellar_text, "cannot be parsed"
    end
  rescue ArgumentError
    errors.add :date_added_to_cellar_text, "is out of range"
  end

  def validate_vintage
    # logger.debug("................. executing the validate_vintage before save... vintage is #{self.vintage}")
    if (self.vintage !~ /^\d{4}$/) && (self.vintage != 'NV')
      errors.add :vintage, "must be a 4 digit year, or 'NV'"
    end
  end
  
  def rating_on_rating_only_bottles
    if self.is_for_rating_only && self.rating.nil?
      errors.add :rating, "must be specified for a 'rating only' bottle."
    end 
  end

end
