/**
 * Cryptocurrency Market Simulation
 * Handles advanced market dynamics and price calculations
 */

// Global market sentiment (affects all prices)
GLOBAL_VAR_INIT(market_sentiment, 0) // -100 to 100, 0 is neutral

/**
 * Adjusts global market sentiment based on world events
 */
/obj/structure/crypto_computer/proc/adjust_global_sentiment(amount)
	GLOB.market_sentiment = clamp(GLOB.market_sentiment + amount, -100, 100)

/**
 * Updates cryptocurrency prices based on the latest news
 */
/obj/structure/crypto_computer/proc/update_crypto_prices()
	for(var/crypto_name in crypto_currencies)
		var/current_price = crypto_currencies[crypto_name]
		var/price_change = 0
		
		if(findtext(latest_news, crypto_name))
			// This crypto was mentioned in the news
			switch(news_impact)
				if("Positive")
					price_change = rand(5, 15) / 100 // 5-15% increase
				if("Negative")
					price_change = -rand(5, 15) / 100 // 5-15% decrease
				if("Neutral")
					price_change = rand(-2, 2) / 100 // -2% to +2% change
		else
			// Random small fluctuation for cryptos not in the news
			price_change = rand(-3, 3) / 100
		
		// Apply price change
		crypto_currencies[crypto_name] = max(1, round(current_price * (1 + price_change)))

/**
 * Extended price update with more market factors
 */
/obj/structure/crypto_computer/proc/extended_price_update()
	// First update prices based on news
	update_crypto_prices()
	
	// Additional market-wide adjustments
	for(var/crypto_name in crypto_currencies)
		var/current_price = crypto_currencies[crypto_name]
		
		// Global sentiment effect (small)
		var/sentiment_effect = (GLOB.market_sentiment / 1000) // 0.1% per 1 point of sentiment
		
		// Random market noise (very small)
		var/market_noise = rand(-5, 5) / 1000 // -0.5% to 0.5%
		
		// Market volatility (occasional spikes)
		var/volatility = 0
		if(prob(5)) // 5% chance of a volatile move
			volatility = (rand(-25, 25) / 100) // -25% to 25% spike
		
		// Apply all factors
		var/total_change = sentiment_effect + market_noise + volatility
		crypto_currencies[crypto_name] = max(1, round(current_price * (1 + total_change)))

/**
 * Analyze trends for a specific cryptocurrency
 */
/obj/structure/crypto_computer/proc/analyze_crypto_trends(crypto_name)
	var/trend_analysis = ""
	
	// Simulate technical analysis
	if(GLOB.market_sentiment > 50 && findtext(latest_news, crypto_name) && news_impact == "Positive")
		trend_analysis = "Strong upward trend detected. Technical indicators suggest bullish momentum."
	else if(GLOB.market_sentiment < -50 && findtext(latest_news, crypto_name) && news_impact == "Negative")
		trend_analysis = "Strong downward trend detected. Technical indicators suggest bearish pressure."
	else if(abs(GLOB.market_sentiment) < 20)
		trend_analysis = "Sideways trading pattern detected. Market appears to be consolidating."
	else if(GLOB.market_sentiment > 0) 
		trend_analysis = "Moderate upward trend. Market sentiment is cautiously optimistic."
	else
		trend_analysis = "Moderate downward trend. Market sentiment shows some caution."
	
	return trend_analysis

/**
 * Generate world news that affects the entire crypto market
 */
/obj/structure/crypto_computer/proc/generate_world_news()
	var/list/world_news_events = list(
		"Positive" = list(
			"Major financial institution announces cryptocurrency support framework.",
			"New legislation provides clarity for cryptocurrency regulation.",
			"Tech consortium forms to standardize cryptocurrency protocols.",
			"Global payment processor to integrate cryptocurrencies.",
			"Major country announces cryptocurrency as legal tender."
		),
		"Negative" = list(
			"Major cryptocurrency exchange hacked, millions stolen.",
			"Governmental crackdown on cryptocurrency trading.",
			"Major financial authority warns against cryptocurrency investment.",
			"Energy concerns grow over cryptocurrency mining impact.",
			"Cryptocurrency scam uncovered, investors lose millions."
		),
		"Neutral" = list(
			"Cryptocurrency conference concludes with mixed outlook.",
			"Experts debate long-term viability of cryptocurrency ecosystem.",
			"Market analysts release cryptocurrency sector report.",
			"Cryptocurrency trading volumes remain steady amid broader market volatility.",
			"Development updates released across multiple cryptocurrency platforms."
		)
	)
	
	var/news_type = pick("Positive", "Negative", "Neutral")
	var/world_news = pick(world_news_events[news_type])
	
	// Adjust global sentiment based on news
	switch(news_type)
		if("Positive")
			adjust_global_sentiment(rand(5, 15))
		if("Negative")
			adjust_global_sentiment(rand(-15, -5))
		if("Neutral")
			adjust_global_sentiment(rand(-2, 2))
	
	return "GLOBAL CRYPTO NEWS: [world_news]"

/**
 * Process market crashes and booms
 */
/obj/structure/crypto_computer/proc/process_market_event()
	if(prob(2)) // 2% chance of a major market event
		var/is_boom = prob(50)
		var/event_news = ""
		
		if(is_boom)
			event_news = "MARKET BOOM: Cryptocurrency market surges across the board due to [pick("sudden institutional investment", "major technological breakthrough", "unexpected regulatory approval")]!"
			adjust_global_sentiment(rand(25, 50))
			
			// Apply boom to all cryptos
			for(var/crypto_name in crypto_currencies)
				crypto_currencies[crypto_name] = round(crypto_currencies[crypto_name] * (1 + (rand(15, 30) / 100)))
		else
			event_news = "MARKET CRASH: Cryptocurrency market plummets due to [pick("major security vulnerability", "regulatory crackdown", "large-scale selloff")]!"
			adjust_global_sentiment(rand(-50, -25))
			
			// Apply crash to all cryptos
			for(var/crypto_name in crypto_currencies)
				crypto_currencies[crypto_name] = max(1, round(crypto_currencies[crypto_name] * (1 - (rand(15, 30) / 100))))
		
		return event_news
	
	return null 