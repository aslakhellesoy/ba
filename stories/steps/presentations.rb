Given /the presentation "([^"]+)" is approved/ do |presentation| # Comment to fool TextMate"
  presentation_page = Page.find_by_title(presentation)
  presentation_page.status = Status[:published]
  presentation_page.save!
end
