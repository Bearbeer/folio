# frozen_string_literal: true

module Exceptions
  # 부모 클래스
  class ParentError < StandardError
    def initialize(message = nil)
      super message
    end
  end

  #
  # 400: 필수 요청 파라미터 누락 등 API 스펙 미준수
  class BadRequest < ParentError
  end

  #
  # 401: http Token 누락 등 미인증 클라이언트
  class Unauthorized < ParentError
  end

  #
  # 403: 요청 가능한 회원이 아닌 등 권한 없음
  class Forbidden < ParentError
  end

  #
  # 409: 리소스 충돌 발생. 사용자가 이를 반영하여 재요청 가능
  class Conflict < ParentError
  end

  #
  # 404: API 없음, 데이터 없음 등
  class NotFound < ParentError
  end

  #
  # 429: 지정된 시간 내 요청 가능 회수 초과
  class TooManyRequest < ParentError
  end
end
