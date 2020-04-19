Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # 로그인
  resources :sessions, controller: 'session', only: %i[create]

  # 회원가입 / 회원탈퇴
  resources :users, controller: 'user', only: %i[create destroy]
end
