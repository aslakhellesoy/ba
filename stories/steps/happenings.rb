Given /there is a "(\w+)" happening page with parts/ do |title|
  layout = Layout.create! :name => 'Normal', :content => "<html><r:content /></html>"
  
  home = Page.create!(
    :layout_id => layout.id,
    :title => "Home Page",
    :breadcrumb => "Home Page",
    :slug => "/",
    :status_id => 100,
    :published_at => Time.now.to_s(:db),
    :starts_at => Time.now.to_s(:db),
    :ends_at => Time.now.to_s(:db)
  )
  
  page = HappeningPage.create!(
    :parent_id => home.id,
    :layout_id => layout.id,
    :title => title,
    :breadcrumb => title,
    :slug => title.symbolize.to_s.gsub("_", "-"),
    :status_id => 100,
    :published_at => Time.now.to_s(:db),
    :starts_at => Time.now.to_s(:db),
    :ends_at => Time.now.to_s(:db)
  )

  page.parts.create! :name => 'body', :content => %{h2. Welcome to this awesome event

  <r:ba:hcal />}
end

Given /"(\w+)" has "(\w+)" promotion codes "(\w*)" at "(\w+)" "(\d+)"/ do |title, max, code, currency, amount|
  page = Page.find_by_title(title)
  max = nil if max == 'unlimited'
  page.prices.create! :max => max, :code => code, :currency => currency, :amount => amount
end

When /I view the "(\w+)" main page/ do |title|
  page = Page.find_by_title(title)
  visits page.url
end

Then /the page should display the conference details as hCal/ do
  response.should have_tag('abbr[class=dtstart]')
end