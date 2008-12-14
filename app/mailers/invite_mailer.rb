class InviteMailer < Merb::MailController

  def notify
    # use params[] passed to this controller to get data
    # read more at http://wiki.merbivore.com/pages/mailers
    @code = params[:code]
    render_mail
  end
  
end
