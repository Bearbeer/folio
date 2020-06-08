Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # 로그인
  resources :sessions, controller: 'session', only: %i[create]

  # 회원정보 / 회원가입 / 회원정보 수정 / 회원탈퇴
  resources :users, controller: 'user' do
    post :profile, on: :collection
  end

  # 중앙 스킬 조회/추가/수정/삭제
  resources :skills, controller: 'skill', only: %i[index create update destroy]

  # 중앙 프로젝트 추가/수정/삭제
  resources :projects, controller: 'project', only: %i[index create update destroy]

  # 경력 관리
  resources :careers, controller: 'career', only: %i[index show create update destroy]

  # 중앙 학력 조회/추가/수정/삭제
  resources :educations, controller: 'education', only: %i[index create update destroy]

  resources :portfolios, controller: 'portfolio', only: %i[index show create update destroy] do
    member do
      post :share
    end

    collection do
      get :get_share, path: '/share/:code'
    end

    # Portfolio의 프로젝트 조회/추가/수정/삭제
    resources :projects, controller: 'portfolio/project', only: %i[index create update destroy]

    # Portfolio의 경력 조회/추가/수정/삭제
    resources :careers, controller: 'portfolio/career', only: %i[index create update destroy]

    # Portfolio의 학력 조회/추가/수정/삭제
    resources :educations, controller: 'portfolio/education', only: %i[index create update destroy]

    # Portfolio의 기술 조회/추가/수정/삭제
    resources :skills, controller: 'portfolio/skill', only: %i[index create update destroy]
  end
end
