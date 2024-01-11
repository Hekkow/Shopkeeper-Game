extends Node

class_name PriorityList

static func comp(a: Object, b: Object) -> bool:
	return a.prio > b.prio

static func sort(arr: Array):
	arr.sort_custom(PriorityList.comp)
	return arr