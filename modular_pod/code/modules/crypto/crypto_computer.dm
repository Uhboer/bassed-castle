/**
 * Cryptocurrency Computer
 * Allows users to invest in cryptocurrencies, view market trends, and withdraw earnings to kaotiks
 */

/obj/structure/crypto_computer
	name = "Crypto Terminal"
	desc = "A terminal for investing in and trading cryptocurrencies."
	icon = 'modular_pod/icons/content_6.dmi'
	icon_state = "crypto"
	density = TRUE
	anchored = TRUE
	var/list/crypto_currencies = list(
		"DarkLight" = 1000,
		"Babybc" = 4000,
		"LoveCoin" = 800,
		"SpaceMoney" = 1200,
		"QuantumCash" = 1500
	)
	var/list/owned_crypto = list()
	var/list/news_events = list(
		"Positive" = list(
			"New security update increases confidence in #CRYPTO# blockchain!",
			"Major corporation announces #CRYPTO# adoption!",
			"Celebrity endorses #CRYPTO# on social media!",
			"Revolutionary new feature added to #CRYPTO#!",
			"#CRYPTO# developers announce partnership with major company!"
		),
		"Negative" = list(
			"Security breach reported in #CRYPTO# network!",
			"Government announces plans to regulate #CRYPTO#!",
			"Major #CRYPTO# investor sells off holdings!",
			"Critical bug discovered in #CRYPTO# code!",
			"Competing cryptocurrency outperforms #CRYPTO#!",
			"Terrorists Blow Up #CRYPTO# Headquarters!",
			"The General Manager of #CRYPTO# was killed!"
		),
		"Neutral" = list(
			"#CRYPTO# market stabilizes after recent fluctuations.",
			"Analysts remain divided on #CRYPTO# future value.",
			"Minor update released for #CRYPTO# wallet software.",
			"Trading volume for #CRYPTO# remains consistent.",
			"#CRYPTO# community discusses potential governance changes."
		)
	)
	var/next_news_time = 0
	var/news_cooldown = 60 SECONDS // News every minute
	var/latest_news = ""
	var/news_impact = "Neutral"
	var/history_length = 10 // Store last 10 news events
	var/list/news_history = list()
	var/list/price_history = list() // Store price history for each crypto

/**
 * Initialize the computer
 */
/obj/structure/crypto_computer/Initialize(mapload)
	. = ..()
	// Initialize price history for each crypto
	for(var/crypto_name in crypto_currencies)
		price_history[crypto_name] = list(crypto_currencies[crypto_name])

	START_PROCESSING(SSobj, src)
	next_news_time = world.time + rand(10, 30) SECONDS // Random initial delay

/**
 * Clean up when destroyed
 */
/obj/structure/crypto_computer/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/**
 * Process function to generate news events periodically
 */
/obj/structure/crypto_computer/process()
	if(world.time >= next_news_time)
		// Check if we should trigger a market crash/boom event (rare)
		var/market_event = process_market_event()
		if(market_event)
			latest_news = market_event
		else
			// 10% chance for global news, 90% chance for specific crypto news
			if(prob(10))
				latest_news = generate_world_news()
			else
				generate_news()

		// Add to news history
		news_history.Insert(1, latest_news)
		if(news_history.len > history_length)
			news_history.len = history_length

		// Update crypto prices
		extended_price_update()

		// Update price history
		for(var/crypto_name in crypto_currencies)
			var/list/history = price_history[crypto_name]
			history.Insert(1, crypto_currencies[crypto_name])
			if(history.len > history_length)
				history.len = history_length

		// Broadcast news to everyone near the terminal
		visible_message("<span class='notice'>[src] displays: \"[latest_news]\"</span>")

		next_news_time = world.time + news_cooldown

/**
 * Generate a random news event affecting a random cryptocurrency
 */
/obj/structure/crypto_computer/proc/generate_news()
	var/selected_crypto = pick(crypto_currencies)
	news_impact = pick("Positive", "Negative", "Neutral")

	var/news_template = pick(news_events[news_impact])
	latest_news = replacetext(news_template, "#CRYPTO#", selected_crypto)

/**
 * UI interaction
 */
/obj/structure/crypto_computer/attack_hand(mob/user, list/modifiers)
	if(!ishuman(user))
		to_chat(user, "<span class='warning'>You lack the dexterity to use this!</span>")
		return

	var/mob/living/carbon/human/H = user

	// Main menu
	var/action = input(H, "Cryptocurrency Terminal", "Select Option") as null|anything in list(
		"View Market",
		"Invest in Cryptocurrency",
		"View Portfolio",
		"Withdraw to Kaotiks",
		"Analyze Trends",
		"News History"
	)

	if(!action)
		return

	switch(action)
		if("View Market")
			view_market(H)
		if("Invest in Cryptocurrency")
			invest_crypto(H)
		if("View Portfolio")
			view_portfolio(H)
		if("Withdraw to Kaotiks")
			withdraw_to_kaotiks(H)
		if("Analyze Trends")
			analyze_trends(H)
		if("News History")
			view_news_history(H)

/**
 * Show current market prices
 */
/obj/structure/crypto_computer/proc/view_market(mob/living/carbon/human/user)
	var/market_data = "<b>Current Cryptocurrency Market:</b>\n"

	for(var/crypto_name in crypto_currencies)
		var/price = crypto_currencies[crypto_name]
		var/list/history = price_history[crypto_name]
		var/price_indicator = ""

		if(history.len >= 2)
			var/current = history[1]
			var/previous = history[2]
			if(current > previous)
				price_indicator = " ▲" // Up arrow
			else if(current < previous)
				price_indicator = " ▼" // Down arrow
			else
				price_indicator = " ━" // Flat line

		market_data += "[crypto_name]: [price] credits[price_indicator]\n"

	market_data += "\n<b>Latest News:</b> [latest_news ? latest_news : "No recent news."]"
	market_data += "\n<b>Market Sentiment:</b> [get_sentiment_description()]"

	to_chat(user, "<span class='notice'>[market_data]</span>")

/**
 * View news history
 */
/obj/structure/crypto_computer/proc/view_news_history(mob/living/carbon/human/user)
	var/history_text = "<b>Recent News Events:</b>\n"

	if(!news_history.len)
		history_text += "No recent news.\n"
	else
		for(var/i = 1 to news_history.len)
			history_text += "[i]. [news_history[i]]\n"

	to_chat(user, "<span class='notice'>[history_text]</span>")

/**
 * Get a text description of the current market sentiment
 */
/obj/structure/crypto_computer/proc/get_sentiment_description()
	if(GLOB.market_sentiment > 75)
		return "Extremely Bullish"
	else if(GLOB.market_sentiment > 50)
		return "Bullish"
	else if(GLOB.market_sentiment > 25)
		return "Somewhat Bullish"
	else if(GLOB.market_sentiment > 10)
		return "Slightly Positive"
	else if(GLOB.market_sentiment > -10)
		return "Neutral"
	else if(GLOB.market_sentiment > -25)
		return "Slightly Negative"
	else if(GLOB.market_sentiment > -50)
		return "Somewhat Bearish"
	else if(GLOB.market_sentiment > -75)
		return "Bearish"
	else
		return "Extremely Bearish"

/**
 * Analyze market trends
 */
/obj/structure/crypto_computer/proc/analyze_trends(mob/living/carbon/human/user)
	var/selected_crypto = input(user, "Select cryptocurrency to analyze:", "Trend Analysis") as null|anything in crypto_currencies
	if(!selected_crypto)
		return

	var/trend_text = "<b>Trend Analysis for [selected_crypto]:</b>\n\n"

	// Current price and change
	var/current_price = crypto_currencies[selected_crypto]
	var/list/history = price_history[selected_crypto]

	trend_text += "Current Price: [current_price] credits\n"

	if(history.len >= 2)
		var/previous_price = history[2]
		var/change = current_price - previous_price
		var/percent_change = (change / previous_price) * 100

		trend_text += "Change: [change > 0 ? "+" : ""][change] credits ([percent_change > 0 ? "+" : ""][round(percent_change, 0.1)]%)\n"

	// Technical analysis
	trend_text += "\n<b>Technical Analysis:</b>\n"
	trend_text += analyze_crypto_trends(selected_crypto)

	// Price forecast
	trend_text += "\n\n<b>Price Forecast:</b>\n"

	if(findtext(latest_news, selected_crypto) && news_impact == "Positive" && GLOB.market_sentiment > 0)
		trend_text += "Forecast: Strong Buy - Positive fundamentals suggest continued upward movement."
	else if(findtext(latest_news, selected_crypto) && news_impact == "Negative" && GLOB.market_sentiment < 0)
		trend_text += "Forecast: Strong Sell - Negative indicators suggest further price deterioration."
	else if(GLOB.market_sentiment > 30)
		trend_text += "Forecast: Buy - General market sentiment is positive, suggesting potential gains."
	else if(GLOB.market_sentiment < -30)
		trend_text += "Forecast: Sell - Market sentiment is negative, suggesting caution."
	else
		trend_text += "Forecast: Hold - Market indicators are mixed, suggesting sideways movement in the near term."

	to_chat(user, "<span class='notice'>[trend_text]</span>")

/**
 * Invest in a cryptocurrency
 */
/obj/structure/crypto_computer/proc/invest_crypto(mob/living/carbon/human/user)
	if(!user.client)
		to_chat(user, "<span class='warning'>You need to be logged in to invest using your kaotiks account.</span>")
		return
		
	var/kaotiks = user.client.ckey
	
	// Check withdrawal cooldown
	if(user.client.prefs.last_crypto_withdrawal && (world.time - user.client.prefs.last_crypto_withdrawal < 5 MINUTES))
		var/remaining_time = round((user.client.prefs.last_crypto_withdrawal + 1 MINUTES - world.time) / (1 MINUTES))
		to_chat(user, "<span class='warning'>Market cooldown active. Please wait [remaining_time] more minute(s) before transaction.</span>")
		return
	
	// Choose crypto and amount
	var/selected_crypto = input(user, "Select cryptocurrency to invest in:", "Investment") as null|anything in crypto_currencies
	if(!selected_crypto)
		return
	
	var/current_price = crypto_currencies[selected_crypto]
	
	// Apply conversion rate - 100 credits = 1 kaotik
	var/kaotiks_conversion_rate = 100
	var/max_kaotiks_cost = 500 // Maximum 500 kaotiks per transaction
	
	// Make sure we don't go over the player's available kaotiks
	var/available_kaotiks = user.client.prefs.bobux_amount
	var/max_affordable_kaotiks = min(available_kaotiks, max_kaotiks_cost)
	var/max_affordable_units = round((max_affordable_kaotiks * kaotiks_conversion_rate) / current_price)
	
	if(max_affordable_units <= 0)
		to_chat(user, "<span class='warning'>You don't have enough kaotiks to invest in [selected_crypto].</span>")
		return
	
	// Show how many units the player can afford
	var/units = input(user, "How many units of [selected_crypto] at [current_price] credits each? (You can afford [max_affordable_units] units with your [available_kaotiks] kaotiks)", "Investment", 1) as num|null
	if(!units || units <= 0)
		return
	
	units = min(units, max_affordable_units)
	var/total_cost = current_price * units
	var/kaotiks_cost = round(total_cost / kaotiks_conversion_rate)
	
	// Confirm purchase
	var/confirm = alert(user, "Invest [kaotiks_cost] kaotiks to purchase [units] units of [selected_crypto]?", "Confirm Investment", "Yes", "No")
	if(confirm != "Yes")
		return
	
	// Verify funds again in case player spent kaotiks elsewhere
	if(user.client.prefs.bobux_amount < kaotiks_cost)
		to_chat(user, "<span class='warning'>Insufficient kaotiks. Transaction cancelled.</span>")
		return
	
	// Process payment
	user.client.prefs.adjust_bobux(-kaotiks_cost, "<span class='bobux'>Invested in [selected_crypto] cryptocurrency! -[kaotiks_cost] Kaotiks!</span>")
	
	// Add to portfolio
	if(!owned_crypto[kaotiks])
		owned_crypto[kaotiks] = list()
	
	if(!owned_crypto[kaotiks][selected_crypto])
		owned_crypto[kaotiks][selected_crypto] = 0
	
	owned_crypto[kaotiks][selected_crypto] += units
	
	to_chat(user, "<span class='notice'>Successfully purchased [units] units of [selected_crypto] for [kaotiks_cost] kaotiks!</span>")
	
	// Apply cooldown to prevent abuse
	user.client.prefs.last_crypto_investment = world.time

/**
 * View owned cryptocurrencies
 */
/obj/structure/crypto_computer/proc/view_portfolio(mob/living/carbon/human/user)
	if(!user.client)
		to_chat(user, "<span class='warning'>You need to be logged in to view your kaotiks portfolio.</span>")
		return
		
	var/kaotiks = user.client.ckey
	
	if(!owned_crypto[kaotiks] || !length(owned_crypto[kaotiks]))
		to_chat(user, "<span class='notice'>You do not own any cryptocurrencies under your kaotiks account.</span>")
		return
	
	var/portfolio = "<b>Portfolio for [kaotiks]:</b>\n"
	var/total_value = 0
	var/total_kaotiks_value = 0
	var/kaotiks_conversion_rate = 100 // 100 credits = 1 kaotik
	
	for(var/crypto_name in owned_crypto[kaotiks])
		var/units = owned_crypto[kaotiks][crypto_name]
		var/current_price = crypto_currencies[crypto_name]
		var/value = units * current_price
		var/kaotiks_value = round(value / kaotiks_conversion_rate)
		
		total_value += value
		total_kaotiks_value += kaotiks_value
		
		portfolio += "[crypto_name]: [units] units (Value: [value] credits / [kaotiks_value] kaotiks)\n"
	
	portfolio += "\n<b>Total Portfolio Value:</b> [total_value] credits / [total_kaotiks_value] kaotiks"
	
	to_chat(user, "<span class='notice'>[portfolio]</span>")

/**
 * Withdraw cryptocurrency value to kaotiks
 */
/obj/structure/crypto_computer/proc/withdraw_to_kaotiks(mob/living/carbon/human/user)
	if(!user.client)
		to_chat(user, "<span class='warning'>You need to be logged in to withdraw to your kaotiks account.</span>")
		return
		
	var/kaotiks = user.client.ckey
	
	if(!owned_crypto[kaotiks] || !length(owned_crypto[kaotiks]))
		to_chat(user, "<span class='notice'>You do not own any cryptocurrencies under this kaotiks account.</span>")
		return
	
	var/crypto_list = list()
	for(var/crypto_name in owned_crypto[kaotiks])
		if(owned_crypto[kaotiks][crypto_name] > 0)
			crypto_list += crypto_name
	
	if(!length(crypto_list))
		to_chat(user, "<span class='notice'>You do not have any cryptocurrencies to withdraw.</span>")
		return
	
	var/selected_crypto = input(user, "Select cryptocurrency to withdraw:", "Withdrawal") as null|anything in crypto_list
	if(!selected_crypto)
		return
	
	var/owned_units = owned_crypto[kaotiks][selected_crypto]
	var/current_price = crypto_currencies[selected_crypto]
	var/max_withdrawal = owned_units
	
	var/units_to_withdraw = input(user, "How many units of [selected_crypto] to withdraw? (Max: [max_withdrawal])", "Withdrawal", max_withdrawal) as num|null
	if(!units_to_withdraw || units_to_withdraw <= 0)
		return
	
	units_to_withdraw = min(units_to_withdraw, max_withdrawal)
	var/withdrawal_value = units_to_withdraw * current_price
	
	// Apply conversion rate to balance the economy - 100 credits = 1 kaotik
	var/kaotiks_conversion_rate = 100
	var/kaotiks_to_add = round(withdrawal_value / kaotiks_conversion_rate)
	
	// Cap maximum withdrawal to prevent inflation - max 500 kaotiks per transaction
	var/max_kaotiks_per_transaction = 500
	if(kaotiks_to_add > max_kaotiks_per_transaction)
		to_chat(user, "<span class='warning'>Transaction capped at [max_kaotiks_per_transaction] kaotiks to prevent market manipulation.</span>")
		kaotiks_to_add = max_kaotiks_per_transaction
	
	// Process withdrawal
	to_chat(user, "<span class='notice'>Processing withdrawal of [units_to_withdraw] units of [selected_crypto] (Value: [withdrawal_value] credits, Conversion: [kaotiks_to_add] kaotiks)...</span>")
	
	if(prob(95)) // 95% success rate
		owned_crypto[kaotiks][selected_crypto] -= units_to_withdraw
		
		// If we have 0 units left, clean up the entry
		if(owned_crypto[kaotiks][selected_crypto] <= 0)
			owned_crypto[kaotiks] -= selected_crypto
			
			if(!length(owned_crypto[kaotiks]))
				owned_crypto -= kaotiks
		
		// Add kaotiks to player's account
		user.client.prefs.adjust_bobux(kaotiks_to_add, "<span class='bobux'>Successfully converted [selected_crypto] cryptocurrency! +[kaotiks_to_add] Kaotiks!</span>")
		
		// Apply cooldown to prevent abuse
		user.client.prefs.last_crypto_withdrawal = world.time
	else
		to_chat(user, "<span class='warning'>Withdrawal failed. Please try again later.</span>")