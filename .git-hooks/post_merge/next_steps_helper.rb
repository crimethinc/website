module Overcommit
  module Hook
    module PostMerge
      # Checks for changed files in a merge/pull and suggests next steps to run to update dev setup
      class NextStepsHelper < Base
        def run
          changed_files = execute(%w[git diff-tree -r --name-only --no-commit-id ORIG_HEAD HEAD]).stdout.split("\n")

          configs = [
            # regex            command            explanation
            [/^Brewfile/,      'brew bundle',     'Brewfile changed'],
            [%r{^db/migrate/}, 'rake db:migrate', 'new schema migrations']
          ]

          output_messages = configs.map do |config|
            regex   = config[0]
            command = config[1]
            message = config[2]

            [command, message] if changed_files.map { |file_name| file_name if file_name.match?(regex) }.compact.any?
          end

          if output_messages.any?
            puts
            puts '#' * 40
            puts
            puts '==> Post-merge follow-up commands to run'

            output_messages.each do |command, message|
              puts "==> Because #{message}, run:"
              puts "    #{command}"
              puts
            end

            puts '#' * 40
            puts
          end

          :pass
        end
      end
    end
  end
end
