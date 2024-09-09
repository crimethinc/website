class DataMigrate
  class << self
    def run
      Locale.find_each do |locale|
        language_direction = locale.language_direction
        locale.update! temp_language_direction: language_direction
      end

      User.find_each do |locale|
        role = locale.role
        locale.update! temp_role: role
      end
    end
  end
end
