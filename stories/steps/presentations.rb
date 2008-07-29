Given /the presentation "([^"]+)" is in the "([^"]+)" slot/ do |presentation, slot|
  presentation_page = Page.find_by_title(presentation)
  presentation_page.program_slot = slot
  presentation_page.save!
end
