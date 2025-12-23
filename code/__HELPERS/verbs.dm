/**
 * handles adding verbs and updating the stat panel browser
 *
 * pass the verb type path to this instead of adding it directly to verbs so the statpanel can update
 * Arguments:
 * * target - Who the verb is being added to, client or mob typepath
 * * verb - typepath to a verb, or a list of verbs, supports lists of lists
 */
/proc/add_verb(client/target, verb_or_list_to_add)
	return

/**
 * handles removing verb and sending it to browser to update, use this for removing verbs
 *
 * pass the verb type path to this instead of removing it from verbs so the statpanel can update
 * Arguments:
 * * target - Who the verb is being removed from, client or mob typepath
 * * verb - typepath to a verb, or a list of verbs, supports lists of lists
 */
/proc/remove_verb(client/target, verb_or_list_to_remove)
	return