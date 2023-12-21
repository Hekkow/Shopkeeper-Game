extends Node

class_name PriorityList

static func comp(a, b):
	return a.prio > b.prio

static func sort(arr):
	arr.sort_custom(PriorityList.comp)
	return arr