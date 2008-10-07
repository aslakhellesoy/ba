require 'tempfile'

class Attendance < ActiveRecord::Base
  belongs_to :happening_page
  belongs_to :site_user
  belongs_to :price

  has_many :presenters, :dependent => :destroy
  has_many :presentation_pages, :through => :presenters, :dependent => :destroy

  validates_presence_of :happening_page_id
  validates_uniqueness_of :site_user_id, :scope => :happening_page_id, :message => "already signed up"
  validates_uniqueness_of :ticket_code
  
  validate :site_user_valid
  validate :price_code_valid

  before_save :update_price
  after_create :create_ticket_code, :activate_user, :send_signup_confirmation_email

  def price_code=(pc)
    @price_code = pc
  end

  def price_code
    @price_code || (price ? price.code : "")
  end

  def actual_price
    price || happening_page.default_price
  end
  
  def price_code_valid
    @old_price = self.price
    self.price = happening_page.prices.find_by_code(price_code)
    errors.add(:price_code, "No such price code") if self.price.nil?
    if self.price && !self.price.available?
      price_users = price.attendances.map(&:site_user).map{|u| %{<a href="mailto:#{u.email}">#{u.name}</a>}}.join(", ")
      errors.add(:price_code, "no longer available, used by #{price_users}")
    end
  end
  
  def site_user_valid
    if site_user
      if !site_user.valid?
        errors.add_to_base("SiteUser is invalid")
      end
    end
  end
  
  def update_price
    if @old_price != price
      self.amount = price.amount
      self.currency = price.currency
    end
  end
  
  def activate_user
    site_user.register! if site_user.passive?
    site_user.activate! if site_user.pending?
  end

  def save_presentation(presentation_page)
    presentation_page.parent_id = happening_page.presentations_page.id
    needs_presenter = presentation_page.new_record?
    if presentation_page.save && needs_presenter
      Presenter.create!(:presentation_page => presentation_page, :attendance => self)
    end
    !presentation_page.new_record?
  end
  
  def send_signup_confirmation_email
    happening_page.send_signup_confirmation_email(site_user)
  end

  TICKET_SALT = "f00k teH bark0de-hax0rz"
  TICKET_CODE_LENGTH = 20 # The barcode reader doesn't want any longer.
  def create_ticket_code
    self.ticket_code = Digest::MD5.hexdigest("#{TICKET_SALT}#{id}")[0..TICKET_CODE_LENGTH-1]
    save
  end

  # Returns a ticket as a Prawn document
  def ticket
    u = site_user
    barcode_file = write_barcode_image
    
    Prawn::Document.new(:page_size => "A4") do # We do A4 because that's what most printers use
      font "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"

      bounding_box [0,750], :width => 300, :height => 140 do
        text "Billett til Smidig 2008", :at => [15,115], :size => 20
        text "Navn", :at => [15,100]
        text u.name, :at => [65,100] # Expect this to be max 30 characters

        text "E-post", :at => [15,85]
        text u.email, :at => [65,85]

        text "Firma", :at => [15,70]
        text u.company, :at => [65,70] # Expect this to be max 50 characters

        # Strokes are nice, but the longest names will go through it....
        # stroke do
        #   line bounds.top_left, bounds.top_right
        #   line bounds.top_left, bounds.bottom_left
        #   line bounds.bottom_left, bounds.bottom_right
        #   line bounds.top_right, bounds.bottom_right
        # end

        image barcode_file, :at => [15,60], :scale => 0.7
        text u.id.to_s, :at => [15,10], :size => 10
      end
    end
  end
  
  def write_barcode_image
    barcode = Barby::Code128B.new(ticket_code)
    path = "/tmp/barcode-#{id}.png"
    File.open(path, 'w') do |f|
      f.write barcode.to_png(:height => 50, :margin => 0)
    end
    path
  end
end