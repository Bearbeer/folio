# frozen_string_literal: true

module Exceptions
  #
  # 400: 필수 요청 파라미터 누락 등 API 스펙 미준수
  class BadRequest < StandardError
  end

  #
  # 401: http Token 누락 등 미인증 클라이언트
  class Unauthorized < StandardError
  end

  #
  # 403: 요청 가능한 회원이 아닌 등 권한 없음
  class Forbidden < StandardError
  end

  #
  # 404: API 없음, 데이터 없음 등
  class NotFound < StandardError
  end

  #
  # 429: 지정된 시간 내 요청 가능 회수 초과
  class TooManyRequest < StandardError
  end
end
