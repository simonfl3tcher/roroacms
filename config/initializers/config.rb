APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")
BUCKET = Setting.find_by_setting_name('aws_bucket_name')[:setting]
