module UserSpecHelpers
  def login_valid_user
    user.confirm# factoryの:userのみ(letで:userと定義 x)

    visit new_user_session_path
    find('#user_email').fill_in with: user.email
    find('#user_password').fill_in with: user.password
    find(:xpath, '//*[@id="new_user"]/div[4]/input').click
    # fill_in "#{I18n.t('.dictionary.words.email')}", with: user.email
    # fill_in "#{I18n.t('.dictionary.words.password')}" , with: user.password
    # click_button "#{I18n.t('.dictionary.words.sign_in')}"
  end
  def login(user)
    user.confirm# factoryの:userのみ(letで:userと定義 x)

    visit new_user_session_path
    find('#user_email').fill_in with: user.email
    find('#user_password').fill_in with: user.password
    find(:xpath, '//*[@id="new_user"]/div[4]/input').click
  end
  def login_admin(admin)
    sign_in users(admin), scope: :admin
  end
end
