# frozen_string_literal: true

# 학력 헬퍼
module EducationHelper
  def educations_view(educations)
    educations.map { |education| education_view(education) }
  end

  def education_view(education)
    {
      id: education.id,
      name: education.name,
      start_date: education.start_date,
      end_date: education.end_date,
      created_at: education.created_at,
      updated_at: education.updated_at
    }
  end
end