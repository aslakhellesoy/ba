require 'rubygems'
require 'faster_csv'

CSV_FILE_PATH = ARGV[0]
data = FasterCSV.read(CSV_FILE_PATH)
header = data[0]
SiteUser.transaction do
  data[1..-1].each do |line|
    attributes = {}
    [header, line].transpose.each do |p|
      attributes[p[0]] = p[1] ? p[1].strip : nil
    end
    attributes['created_at'] = Time.parse(attributes['created_at']).utc if attributes['created_at']
    random_temp_pass = Digest::SHA1.hexdigest("--#{attributes['email']}--#{Time.now.to_s}--#{rand(10000000)}--")
    site_user = SiteUser.create!(attributes.merge({:password => random_temp_pass, :password_confirmation => random_temp_pass}))
    site_user.register!
    site_user.password = nil
    site_user.crypted_password = nil
    site_user.save_without_validation
    site_user.update_attribute('created_at', attributes['created_at']) if attributes['created_at']
    puts site_user.inspect
  end
end