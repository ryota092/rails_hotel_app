module ApplicationHelper
  # アセットが存在するかどうかを確認するメソッド
  def asset_exists?(logical_path)
    if Rails.configuration.assets.compile && Rails.application.assets
      Rails.application.assets.find_asset(logical_path).present?
    else
      Rails.application.assets_manifest&.find_sources(logical_path)&.any?
    end
  end
end
