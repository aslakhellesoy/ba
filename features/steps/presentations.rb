Given /the presentation "([^"]+)" is in the "([^"]+)" slot/ do |presentation, slot|
  presentation_page = Page.find_by_title(presentation)
  presentation_page.program_slot = slot
  presentation_page.save!
end

Given /there is a "([^"]+)" presentation in "([^"]+)" slot "(\d+)"/ do |presentation, program, slot|
  presentation_page = Page.find_by_title(presentation)
  program_page      = Page.find_by_title(program)
  presentation_page = PresentationPage.create!(
    :parent_id    => program_page.presentations_page.id,
    :title        => presentation,
    :body         => "#{presentation} body",
    :status       => Status[:published],
    :published_at => Time.now.to_s(:db)
  )
  presentation_page.program_slot = slot
  presentation_page.save!
end