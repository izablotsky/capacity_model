# frozen_string_literal: true

module Reports
  class BaseResult
    attr_accessor :report, :type, :endpoint

    def initialize(report:, type:, endpoint:)
      @report = report
      @type = type
      @endpoint = endpoint
    end
  end
end
