# Cryptocurrency Terminal System

This module adds a cryptocurrency trading terminal to the game, allowing players to invest in various cryptocurrencies, track market trends, and withdraw profits to their kaotiks.

## Features

- **Market Simulation**: Cryptocurrency prices change dynamically based on news events
- **News System**: Regular updates about cryptocurrencies that impact their prices
- **Kaotiks Integration**: Uses the player's actual kaotiks (bobux_amount) for investments and withdrawals
- **Portfolio Management**: View and manage cryptocurrency investments
- **Trend Analysis**: Technical analysis tools for predicting price movements
- **Multiple Terminal Types**: Standard, wall-mounted, portable, and advanced models

## How It Works

### Market Updates

Every minute, the terminal generates news that affects cryptocurrency prices. News can be:
- **Positive**: Increases the price of the affected cryptocurrency
- **Negative**: Decreases the price of the affected cryptocurrency
- **Neutral**: Causes minor fluctuations

### Global Market Events

Occasionally, market-wide events like booms or crashes can affect all cryptocurrencies simultaneously.

### Kaotiks Economy Integration

The cryptocurrency system integrates with the kaotiks economy:
- Players spend their existing kaotiks (bobux_amount) to invest
- When withdrawing, cryptocurrency value is converted to kaotiks at a rate of 100 credits = 1 kaotik
- Maximum transaction limits prevent economy inflation (500 kaotiks per transaction)
- Cooldown periods between transactions prevent abuse

### Investing

1. System automatically identifies the player by their client ckey
2. Player selects a cryptocurrency to invest in
3. Maximum investment is limited by the player's available kaotiks
4. Kaotiks are deducted from the player's account when investing

### Withdrawing

1. System automatically identifies the player by their client ckey
2. Player selects which cryptocurrency to withdraw
3. Cryptocurrency value is converted to kaotiks at a controlled rate
4. Kaotiks are added to the player's account with appropriate limits
5. A cooldown period prevents frequent trading to manipulate the market

## Terminal Types

- **Standard Terminal**: Desktop model with basic functionality
- **Wall-mounted Terminal**: Space-saving version for public areas
- **Portable Terminal**: Can be carried around but updates less frequently
- **Advanced Terminal**: Higher-end model with faster updates and more features

## Technical Notes

- The system uses a global market sentiment variable that affects all cryptocurrencies
- Price history is tracked for trend analysis
- News events are saved in a history log
- The system uses real client preferences (bobux_amount) for economy integration
- Transaction cooldowns and limits prevent market abuse 