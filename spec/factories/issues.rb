FactoryBot.define do
  factory :issue, parent: :tool, class: Issue do
    journal
    title { 'Issue 1' }
    slug { 'issue-1' }
    issue { '1' }
  end
end
