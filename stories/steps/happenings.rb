Given /there is a "(\w+)" page/ do |title|
  page = HappeningPage.create!(
    :title => title,
    :breadcrumb => title,
    :slug => '/',
    :status_id => 100,
    :published_at => Time.now.to_s(:db),
    :starts_at => Time.now.to_s(:db),
    :ends_at => Time.now.to_s(:db)
  )
  page.parts.create! :name => 'body'
end

Given /I am editing the "(\w+)" page/ do |title|
  page = Page.find_by_title(title)
  visits "/admin/pages/edit/#{page.id}"
end

Given /I add a hCal tag to the body text/ do
  fills_in 'part_0_content', :with => %s{
    h1. Welcome to this awesome event
    
    <r:hcal />
  }
  clicks_button 'Save Changes'
end

When /I view the "(\w+)" page/ do |title|
  page = Page.find_by_title(title)
  visits page.url
end

Then /the page should display the conference details as hCal/ do
  response.should have_tag 'abbr[class=dtstart]'
end