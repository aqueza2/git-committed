class Profile < ActiveRecord::Base

  belongs_to :user
  has_many :answers
  has_many :questions, through: :answers
  has_attached_file :picture, styles: {
    thumb: '100x100>',
    square: '200x200',
    medium: '300x300>'
  }

  validates :about_me,  length:  { maximum: 140,
                                   too_long: "140 characters is the maximum allowed" },
                                   on: :update, allow_blank: :true

  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  validates_format_of :github_link, with: /github\.((com)|(io))/, message: "url is not in proper format" , on: :update, allow_blank: :true

  def get_traits
    [user.languages, user.text_editors, user.skills, user.operating_systems, user.relationship_types].flatten
  end

end
