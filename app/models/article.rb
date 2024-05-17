class Article < ApplicationRecord
  include Visible
  has_many :comments, dependent: :destroy
  has_one_attached :image
  belongs_to :user
  validates :title, presence: true
  validates :body, presence: true
  validates :status, inclusion: { in: %w(public private) }


  before_save :check_reports_count

  private
  def check_reports_count
    if reports_count >= 3
      self.status = 'archived'
    end
  end
end
