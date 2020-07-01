module Admin
  module ToolsHelper
    def attachement_form_attr_for side, kind, color
      "image_#{side}_#{color}_#{kind}"
    end

    def acceptable_mime_types_for kind
      kind == 'download' ? 'application/pdf' : 'image/jpeg, image/png, image/gif'
    end

    def attachment_display_name_for kind
      kind == 'download' ? 'PDF' : 'Image'
    end
  end
end
