ActiveAdmin.register User do
  form do |f|
    f.inputs do
      f.input :username
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit(user: [:username, :email, :password, :password_confirmation])
    end

    def per_page
      return User.count + 100 if request.format == 'text/csv'
      super
    end
  end
end
