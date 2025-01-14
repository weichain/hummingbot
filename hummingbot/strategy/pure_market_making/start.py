from typing import (
    List,
    Tuple,
)

from hummingbot.strategy.market_symbol_pair import MarketSymbolPair
from hummingbot.strategy.pure_market_making import (
    PureMarketMakingStrategyV2,
    ConstantMultipleSpreadPricingDelegate,
    StaggeredMultipleSizeSizingDelegate,
)
from hummingbot.strategy.pure_market_making.pure_market_making_config_map import pure_market_making_config_map


def start(self):
    try:
        order_size = pure_market_making_config_map.get("order_amount").value
        cancel_order_wait_time = pure_market_making_config_map.get("cancel_order_wait_time").value
        bid_place_threshold = pure_market_making_config_map.get("bid_place_threshold").value
        ask_place_threshold = pure_market_making_config_map.get("ask_place_threshold").value
        mode = pure_market_making_config_map.get("mode").value
        number_of_orders = pure_market_making_config_map.get("number_of_orders").value
        order_start_size = pure_market_making_config_map.get("order_start_size").value
        order_step_size = pure_market_making_config_map.get("order_step_size").value
        order_interval_percent = pure_market_making_config_map.get("order_interval_percent").value
        maker_market = pure_market_making_config_map.get("maker_market").value.lower()
        raw_maker_symbol = pure_market_making_config_map.get("maker_market_symbol").value.upper()
        pricing_delegate = None
        sizing_delegate = None

        if mode == "multiple":
            pricing_delegate = ConstantMultipleSpreadPricingDelegate(bid_place_threshold,
                                                                     ask_place_threshold,
                                                                     order_interval_percent,
                                                                     number_of_orders)
            sizing_delegate = StaggeredMultipleSizeSizingDelegate(order_start_size,
                                                                  order_step_size,
                                                                  number_of_orders)

        try:
            maker_assets: Tuple[str, str] = self._initialize_market_assets(maker_market, [raw_maker_symbol])[0]
        except ValueError as e:
            self._notify(str(e))
            return

        market_names: List[Tuple[str, List[str]]] = [(maker_market, [raw_maker_symbol])]

        self._initialize_wallet(token_symbols=list(set(maker_assets)))
        self._initialize_markets(market_names)
        self.assets = set(maker_assets)

        maker_data = [self.markets[maker_market], raw_maker_symbol] + list(maker_assets)
        self.market_symbol_pairs = [MarketSymbolPair(*maker_data)]

        strategy_logging_options = PureMarketMakingStrategyV2.OPTION_LOG_ALL

        self.strategy = PureMarketMakingStrategyV2(market_infos=[MarketSymbolPair(*maker_data)],
                                                   pricing_delegate=pricing_delegate,
                                                   sizing_delegate=sizing_delegate,
                                                   legacy_order_size=order_size,
                                                   legacy_bid_spread=bid_place_threshold,
                                                   legacy_ask_spread=ask_place_threshold,
                                                   cancel_order_wait_time=cancel_order_wait_time,
                                                   logging_options=strategy_logging_options)
    except Exception as e:
        self._notify(str(e))
        self.logger().error("Unknown error during initialization.", exc_info=True)
