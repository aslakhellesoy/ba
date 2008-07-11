Given /there is a "(\w+)" happening page/ do |title|
  page = HappeningPage.create!(
    :title => title,
    :breadcrumb => title,
    :slug => '/',
    :status_id => 100,
    :published_at => Time.now.to_s(:db),
    :starts_at => Time.now.to_s(:db),
    :ends_at => Time.now.to_s(:db)
  )
  page.parts.create! :name => 'body', :content => 'Edit me'
end

Given /the "(\w+)" page has a <r:hcal> tag/ do |title|
  page = Page.find_by_title(title)
  page.part("body").update_attribute(:content, %s{
    h1. Welcome to this awesome event
    
    <r:hcal />
  })
end

Given /the "(\w+)" page has a <r:signup> tag/ do |title|
  page = Page.find_by_title(title)
  page.part("body").update_attribute(:content, %s{
    h1. Welcome to this awesome event
    
    <r:signup />
  })
end

When /I view the "(\w+)" happening page/ do |title|
  page = Page.find_by_title(title)
  visits page.url
end

Then /the page should display the conference details as hCal/ do
  response.should have_tag 'abbr[class=dtstart]'
end