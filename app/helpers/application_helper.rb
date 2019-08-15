module ApplicationHelper
  def error_messages_for(record)
    return unless record.errors.any?

    content_tag :ul, class: 'alert alert-danger px-4' do
      record.errors.full_messages.each do |msg|
        concat(tag.li msg)
      end
    end
  end
end