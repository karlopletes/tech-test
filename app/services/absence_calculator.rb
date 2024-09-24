# Returns list of absences based on stay data
class AbsenceCalculator
  RESIDENCE_OPEN_DATE = Date.parse('2024-01-01').freeze

  attr_reader :studio

  def initialize(studio)
    @studio = studio
  end

  def calculate_absences
    return [] if stays.empty?

    last_end_date = stays.first.end_date
    stays.drop(1).each_with_object([]) do |stay, absences|
      next if absence_before_opening?(stay)

      absences << build_absence(last_end_date, stay.start_date) if absence_exists?(stay, last_end_date)
      last_end_date = stay.end_date
    end
  end

  private

  def stays
    @stays ||= studio.stays.order(:start_date)
  end

  def absence_before_opening?(stay)
    stay.end_date < RESIDENCE_OPEN_DATE
  end

  def absence_exists?(stay, last_end_date)
    stay.start_date > last_end_date
  end

  def build_absence(last_end_date, next_start_date)
    {
      studio_id: studio.id,
      studio_name: studio.name,
      start_date: (last_end_date + 1.day).to_s,
      end_date: (next_start_date - 1.day).to_s
    }
  end
end
