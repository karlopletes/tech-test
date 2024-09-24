# Updates stays based on absence params with overlap handling
class StayUpdater
  def initialize(absences)
    @absences = absences
  end

  def update_stays
    @absences.flat_map { |absence| process_absence(absence) }
  end

  private

  def process_absence(absence_data)
    studio = Studio.find_by(id: absence_data[:studio_id])
    return failure_response(absence_data[:studio], 'Studio not found') unless studio

    start_date = Date.parse(absence_data[:start_date])
    end_date = Date.parse(absence_data[:end_date])

    overlapping_stays = find_overlapping_stays(studio, start_date, end_date)

    overlapping_stays.each_with_object([]) do |stay, absences|
      absences.concat(handle_overlap(stay, studio, start_date, end_date))
    end
  end

  def find_overlapping_stays(studio, start_date, end_date)
    studio.stays.where('(start_date <= ?) AND (end_date >= ?)', end_date, start_date)
  end

  def handle_overlap(stay, studio, start_date, end_date)
    case determine_overlap_case(stay, start_date, end_date)
    when :surrounds
      split_stay(stay, studio, start_date, end_date)
    when :ends_within
      stay.update!(end_date: start_date - 1.day)
    when :starts_within
      stay.update!(start_date: end_date + 1.day)
    when :fully_within
      stay.destroy
    end
    [{ studio: studio.name, status: 'success' }]
  rescue ActiveRecord::RecordInvalid => e
    [failure_response(studio.name, e.message)]
  end

  def determine_overlap_case(stay, start_date, end_date)
    overlap_cases = {
      surrounds: stay.start_date < start_date && stay.end_date > end_date,
      ends_within: stay.start_date < start_date && stay.end_date <= end_date,
      starts_within: stay.start_date >= start_date && stay.end_date > end_date,
      fully_within: stay.start_date >= start_date && stay.end_date <= end_date
    }

    overlap_cases.each do |case_key, condition|
      return case_key if condition
    end
  end

  def split_stay(stay, studio, start_date, end_date)
    Stay.create!(studio:, start_date: stay.start_date, end_date: start_date - 1.day)
    Stay.create!(studio:, start_date: end_date + 1.day, end_date: stay.end_date)
    stay.destroy
  end

  def failure_response(studio_name, message)
    { studio: studio_name, status: 'failed', error: message }
  end
end
