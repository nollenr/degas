# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(35)       not null
#  email           :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  approved_user   :boolean          default(FALSE), not null
#  password_digest :string(255)
#  remember_token  :string(255)
#

require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end
