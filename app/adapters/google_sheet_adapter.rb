require "google/apis/sheets_v4"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

class GoogleSheetAdapter
  OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
  CREDENTIALS_PATH = "config/google/credentials.json".freeze
  TOKEN_PATH = "config/google/token.yaml".freeze
  APPLICATION_NAME = "Google Sheets API for IssPay".freeze
  SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

  class << self
    def authorize
      client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
      token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
      authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
      user_id = "isspay".freeze
      credentials = authorizer.get_credentials user_id
      if credentials.nil?
        url = authorizer.get_authorization_url base_url: OOB_URI
        puts "Open the following URL in the browser and enter the " \
             "resulting code after authorization:\n" + url
        code = gets
        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: OOB_URI
        )
      end
      credentials
    end

    def build_service
      @@service = Google::Apis::SheetsV4::SheetsService.new
      @@service.client_options.application_name = APPLICATION_NAME
      @@service.authorization = authorize
    end

    def service
      @@service
    end
  end

  build_service

  attr_reader :gateway
  def initialize
    @gateway = self.class.service
  end

  def read_all(table)
    read(table, ['A', 'Z'], [1])
  end

  def read(table, rows_range, cols_range)
    res = gateway.get_spreadsheet_values sheet_id, range(table, rows_range, cols_range)
    ValuesWrapper.to_struct res.values
  end

  def write_all(records)
    values_wrapper = ValuesWrapper.new(records)
    table = values_wrapper.table_name
    values = values_wrapper.to_values_with(cols_order(table))
    value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: values) 
    res = gateway.update_spreadsheet_value sheet_id, range(table, ['A', 'Z'], [2, 1+values.count]), value_range_object, value_input_option: 'RAW'
    res.updated_rows
  end

  def sheet_id
    Rails.application.credentials[:google][:sheet_id]
  end

  def cols_order(table)
    res = gateway.get_spreadsheet_values sheet_id, range(table, ['A','Z'], [1, 1])
    res.values[0]
  end

  def range(table, rows, cols)
    "#{table}!#{rows[0]}#{cols[0]}:#{rows[1]}#{cols[1]}"
  end
end