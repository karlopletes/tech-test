# frozen_string_literal: true

json.absences @absences do |absence|
  json.studio_id absence[:studio_id]
  json.studio_name absence[:studio_name]
  json.start_date absence[:start_date]
  json.end_date absence[:end_date]
end
