module Alphavantage
  class TimeSeries
    include Validations

    FUNCTIONS = { 
      search: 'SYMBOL_SEARCH',
      quote: 'GLOBAL_QUOTE',
      monthly: 'TIME_SERIES_MONTHLY',
      monthly_adjusted: 'TIME_SERIES_MONTHLY_ADJUSTED',
      weekly: 'TIME_SERIES_WEEKLY',
      weekly_adjusted: 'TIME_SERIES_WEEKLY_ADJUSTED',
      daily: 'TIME_SERIES_DAILY',
      daily_adjusted: 'TIME_SERIES_DAILY_ADJUSTED',
      intraday: 'TIME_SERIES_INTRADAY',
      intraday_extended_history: 'TIME_SERIES_INTRADAY_EXTENDED'
    }

    def self.search(keywords:)
      Client.get(params: { function: self::FUNCTIONS[__method__], keywords: keywords }).best_matches
    end

    def initialize(symbol:)
      @symbol = symbol
    end

    def quote
      Client.get(params: { function: FUNCTIONS[__method__], symbol: @symbol }).global_quote
    end

    def monthly(adjusted: false)
      function = adjusted ? FUNCTIONS[:monthly_adjusted] : FUNCTIONS[__method__]
      Client.get(params: { function: function, symbol: @symbol })
    end

    def weekly(adjusted: false)
      function = adjusted ? FUNCTIONS[:weekly_adjusted] : FUNCTIONS[__method__]
      Client.get(params: { function: function, symbol: @symbol })
    end

    def daily(adjusted: false, outputsize: 'compact')
      function = adjusted ? FUNCTIONS[:daily_adjusted] : FUNCTIONS[__method__]
      Client.get(params: { function: function, symbol: @symbol, outputsize: validate_outputsize(outputsize) })
    end

    def intraday(adjusted: true, outputsize: 'compact', interval: '5min', extended_history: false, slice: 'year1month1')
      if extended_history
        raise Alphavantage::Error, "Extended history returns a CSV which will be supported at a later time."
        # params = { 
        #   function: FUNCTIONS[:intraday_extended_history], 
        #   symbol: @symbol, 
        #   slice: validate_slice(slice), 
        #   interval: validate_interval(interval), 
        #   adjusted: adjusted 
        # }
      else
        params = { 
          function: FUNCTIONS[__method__], 
          symbol: @symbol, 
          outputsize: validate_outputsize(outputsize), 
          interval: validate_interval(interval), 
          adjusted: adjusted 
        }
      end
      Client.get(params: params)
    end
  end
end