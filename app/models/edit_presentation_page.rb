class EditPresentationPage < Page
  before_validation_on_create :create_default_content

  attr_accessor :presentation_page

  def cache?
    false
  end

  def create_default_content
    self.slug = 'edit_presentation'
    self.breadcrumb = self.title = 'EditPresentation'
    self.status = Status[:published]
    parts << PagePart.new(:name => 'body', :content => read_file('default_edit_presentation_part.html'))
  end

  def title
    presentation_page.nil? ? super : presentation_page.title
  end

  def url
    presentation_page.nil? ? super : super + presentation_page.slug
  end

  def find_by_url(url, live = true, clean = false)
    if url =~ %r{^#{ self.url }(.+)/$}
      @presentation_page_slug = $1
      self
    else
      super
    end
  end
    
  def process(request, response)
    @site_user = controller.current_site_user
    @attendance = happening_page.attendance(@site_user)

    if @attendance
      @presentation = if @presentation_page_slug
        happening_page.presentations_page.children.find_by_slug(@presentation_page_slug)
      else
        PresentationPage.new
      end

      if request.post?
        presentation_params = request.parameters[:presentation]
        meta_tags = extract_meta_tags(presentation_params)

        @presentation.attributes = presentation_params
        if @attendance.save_presentation(@presentation)
          @presentation.meta_tags = meta_tags if meta_tags
          controller.redirect_to(happening_page.attendance_page.url)
        else
          super
        end
      else
        super
      end
    else
      # Nothing allowed here unless we're signed up
      controller.redirect_to(happening_page.signup_page.url)
    end
  end
  
  def extract_meta_tags(params)    
    if params[:meta_tags]
      meta_tags = params.delete(:meta_tags).join(" ")
    else
      meta_tags = nil
    end
  end
end