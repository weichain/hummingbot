# distutils: language=c++

from libc.stdint cimport int64_t

from hummingbot.core.data_type.limit_order cimport LimitOrder
from hummingbot.core.data_type.order_book cimport OrderBook
from hummingbot.strategy.strategy_base cimport StrategyBase

cdef class CrossExchangeMarketMakingStrategy(StrategyBase):
    cdef:
        dict _market_pairs
        set _maker_markets
        set _taker_markets
        bint _all_markets_ready
        dict _anti_hysteresis_timers
        double _min_profitability
        double _order_size_taker_volume_factor
        double _order_size_taker_balance_factor
        double _order_size_portfolio_ratio_limit
        double _anti_hysteresis_duration
        double _status_report_interval
        double _last_timestamp
        double _trade_size_override
        double _cancel_order_threshold
        bint _active_order_canceling
        dict _tracked_maker_orders
        dict _tracked_taker_orders
        dict _order_id_to_market_pair
        dict _shadow_tracked_maker_orders
        dict _shadow_order_id_to_market_pair
        object _shadow_gc_requests
        dict _order_fill_buy_events
        dict _order_fill_sell_events
        dict _suggested_price_samples
        object _in_flight_cancels
        int64_t _logging_options
        object _exchange_rate_conversion

    cdef c_cancel_order(self, object market_pair, str order_id)
    cdef c_process_market_pair(self, object market_pair, list active_ddex_orders)
    cdef c_check_and_hedge_orders(self, object market_pair)
    cdef c_check_and_cleanup_shadow_records(self)
    cdef c_start_tracking_limit_order(self, object market_pair, str order_id, bint is_buy, object price,
                                      object quantity)
    cdef c_stop_tracking_limit_order(self, object market_pair, str order_id)
    cdef c_start_tracking_market_order(self, object market_pair, str order_id, bint is_buy, object quantity)
    cdef c_stop_tracking_market_order(self, object market_pair, str order_id)
    cdef object c_get_order_size_after_portfolio_ratio_limit(self, object market_pair, double original_order_size)
    cdef object c_get_adjusted_limit_order_size(self, object market_pair, double price, double original_order_size)
    cdef double c_sum_flat_fees(self, str quote_currency, list flat_fees)

    cdef double c_calculate_bid_profitability(self,
                                              object market_pair,
                                              double bid_order_size = *)
    cdef double c_calculate_ask_profitability(self,
                                              object market_pair,
                                              double ask_order_size = *)
    cdef tuple c_calculate_market_making_profitability(self, object market_pair)
    cdef tuple c_has_market_making_profit_potential(self, object market_pair)
    cdef tuple c_get_market_making_price_and_size_limit(self,
                                                        object market_pair,
                                                        bint is_bid,
                                                        double own_order_depth=*)
    cdef double c_calculate_effective_hedging_price(self,
                                                    OrderBook taker_order_book,
                                                    bint is_maker_bid,
                                                    double maker_order_size) except? -1
    cdef tuple c_get_suggested_price_samples(self, object market_pair)
    cdef c_take_suggested_price_sample(self, object market_pair, list active_orders)
    cdef bint c_check_if_still_profitable(self,
                                          object market_pair,
                                          LimitOrder active_order,
                                          double current_hedging_price)
    cdef bint c_check_if_sufficient_balance(self, object market_pair, LimitOrder active_order)
    cdef bint c_check_if_price_correct(self, object market_pair, LimitOrder active_order, double current_hedging_price)
    cdef c_check_and_create_new_orders(self, object market_pair, bint has_active_bid, bint has_active_ask)