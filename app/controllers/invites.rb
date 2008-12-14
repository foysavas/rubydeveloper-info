class Invites < Application
  # provides :xml, :yaml, :js
  before :ensure_authenticated

  def new
    only_provides :html
    @invite = Invite.new
    display @invite
  end

  def create(invite)
    @invite = Invite.new(invite)
    @invite.user = session.user
    if @invite.save
      run_later do
        send_mail(InviteMailer, :notify, {
          :from => session.user.login,
          :to => @invite.email,
          :subject => 'RubyDeveloper.Info invite'
        }, {
          :code => @invite.code
        })
      end
      redirect url(:new_invite), :message => {:notice => "Invite was successfully created. Do it again!!!"}
    else
      message[:error] = "Invite failed to be created"
      render :new
    end
  end


end # Invites
