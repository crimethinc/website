class MiscController < ApplicationController
  def manifest_json
    render formats: :json
  end

  def opensearch_xml
    render formats: :xml
  end
end
