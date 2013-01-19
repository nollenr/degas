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
  validates :bottle_id, presence: { message: "identifier cannot be null. Bottle not created." }, uniqueness: { scope: :user_id, message: "bottle_id should be unique and this identifier was found in your history."}
  validates :user_id, presence: true
  validates :grape_name, presence: {message: "cannot be empty and must be a value from the list.  Bottle not created."}
  validates :winery_name, presence: {message: "cannot be empty and must be a value from the list.  Bottle not created." }
  validates :bottle_type_id, presence: true
  
  attr_accessible :available, :bottle_id, :cellar_location, :vintage, :drink_by_year, :name, :vineyard, :grape_name, :winery_name, :price, :rating, :bottle_type_id

  def availability
    return @availability
  end

  def availability= avail_bool
    @availability = avail_bool ? 'Available' : 'Consumed'
  end

  after_find :set_availability

  def set_availability
    self.availability= self.available
  end

# For exporting to a CSV file
  def self.to_csv
    CSV.generate do |csv|
      export_set = Array.new(column_names)
      export_set.push("bottle.winery.name","bottle.grape.name","bottle.bottle_type.name")
      csv << export_set
      all.each do |bottle|
        fk = Array.new
        fk.push(bottle.winery.name,bottle.grape.name,bottle.bottle_type.name)
        csv << bottle.attributes.values_at(*export_set) + fk
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

end
