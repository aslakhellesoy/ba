Given /the presentation "([^"]+)" is in the "([^"]+)" slot/ do |presentation, slot|
  presentation_page = Page.find_by_title(presentation)
  presentation_page.program_slot = slot
  presentation_page.save!
end

Given /"([^"]+)" has a "([^"]+)" presentation in "([^"]+)" slot "(\d+)"/ do |user_name, presentation, program, slot|
  site_user = SiteUser.find_by_name(user_name)
  presentation_page = Page.find_by_title(presentation)
  program_page      = Page.find_by_title(program)
  presentation_page = PresentationPage.new(
    :parent_id    => program_page.presentations_page.id,
    :title        => presentation,
    :body         => "#{presentation} body",
    :status       => Status[:published],
    :published_at => Time.now.to_s(:db)
  )
  attendance = Attendance.find_by_happening_page_id_and_site_user_id(program_page.happening_page.id, site_user.id)
  attendance.save_presentation(presentation_page)
  presentation_page.program_slot = slot
  presentation_page.save!
end

Then /the tags for "(.*)" should be "(.*)"/ do |presentation, tags|
  presentation_page = Page.find_by_title(presentation)
  presentation_page.tag_list.split(" ").sort.should == tags.split(" ")
end

Then /Page "(.*)" should have one attachment named "(.*)"/ do |presentation, file_name|
  presentation_page = Page.find_by_title(presentation)
  presentation_page.should have(1).attachments
  attachment = presentation_page.attachment(file_name)
  attachment.should_not be_nil
end
