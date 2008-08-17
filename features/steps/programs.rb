Given /there is a simple "([^"]+)" program for "([^"]+)"/ do |program, happening|
  happening_page = Page.find_by_title(happening)
  program_page = ProgramPage.create!(
    :parent_id    => happening_page.id,
    :title        => program,
    :breadcrumb   => program,
    :slug         => program.symbolize.to_s.gsub("_", "-"),
    :status       => Status[:published],
    :published_at => Time.now.to_s(:db)
  )
  program_page.parts << PagePart.new(:name => 'body', :content => %{
    <r:ba:program:presentation slot="1" />
    <r:ba:program:presentation slot="2" />
  })
  program_page.save!
end
