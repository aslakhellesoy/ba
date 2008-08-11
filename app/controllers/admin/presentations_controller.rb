class Admin::PresentationsController < Admin::AbstractModelController
  protect_from_forgery :except => :update # Too much hassle to make it work with external javascript...
  model_class PresentationPage
  
  def update
    # TODO: move whoever is taking the spot out!! Do it in Admin::PresentationsController
    # and protect from the same in the PresentationController#put (forbidden)

    presentation_page = PresentationPage.find(params[:id])
    presentation_page.attributes = params[:presentation_page]
    presentation_page.clear_slot
    presentation_page.save!
    presentation_page.expire_programs

#    render :nothing, :status => :ok
    render :text => 'OKEI'
  end
end