Given /there is a "(\w+)" happening page with parts/ do |title|
  page = HappeningPage.create!(
    :parent => @home_page,
    :title => title,
    :breadcrumb => title,
    :slug => title.symbolize.to_s.gsub("_", "-"),
    :status => Status[:published],
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