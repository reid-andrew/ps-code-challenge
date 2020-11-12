class CreatePostCodeReports < ActiveRecord::Migration[6.0]
  def change
    create_view :post_code_reports
  end
end
