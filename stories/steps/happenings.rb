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

  page.parts.create! :name => 'body', :content => %s{
    h2. Welcome to this awesome event
    
    <r:hcal />
  }

  page.parts.create! :name => 'attendances/new', :content => %s{
    h2. Please sign up below
    
    <r:signup />
  }
  
  page.parts.create! :name => 'attendances/show', :content => %s{
    h2. You are registered, <r:user />
  }

  page.parts.create! :name => 'attendances/already', :content => %s{
    h2. You are already registered, <r:user />
  }
end

When /I view the "(\w+)" main page/ do |title|
  page = Page.find_by_title(title)
  visits page.url
end

Then /the page should display the conference details as hCal/ do
  response.should have_tag('abbr[class=dtstart]')
end