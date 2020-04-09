Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # 로그인 / 로그아웃
  resources :sessions, controller: 'session/main', only: [] do
    collection do
      post :login
      post :logout
    end

  end
end
