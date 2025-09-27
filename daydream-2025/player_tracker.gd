extends Node

# -------------------------
# Player condition variables
# -------------------------
var fingers: int = 5            # Number of fingers (0–5)
var vision: float = 100.0       # Vision clarity/field of view (0–100)
var hearing: float = 100.0      # Hearing clarity (0–100)
var mobility: float = 100.0     # Movement ability (0–100)
var stability: float = 0.0      # Shakiness (0–100)
var money: int = 0              # Currency (0+)

# Called when the node enters the scene tree
func _ready():
	print_status()

# -------------------------
# Status Modifiers
# -------------------------

# Fingers
func lose_finger(amount: int = 1):
	fingers = max(fingers - amount, 0)
	print("Lost a finger! Current fingers:", fingers)

func add_finger(amount: int = 1):
	fingers = min(fingers + amount, 5)
	print("Finger restored! Current fingers:", fingers)


# Vision
func reduce_vision(amount: float):
	vision = max(vision - amount, 0)
	print("Vision deteriorated! Current vision:", vision)

func add_vision(amount: float):
	vision = min(vision + amount, 100)
	print("Vision improved! Current vision:", vision)


# Hearing
func reduce_hearing(amount: float):
	hearing = max(hearing - amount, 0)
	print("Hearing loss! Current hearing:", hearing)

func add_hearing(amount: float):
	hearing = min(hearing + amount, 100)
	print("Hearing restored! Current hearing:", hearing)


# Mobility
func reduce_mobility(amount: float):
	mobility = max(mobility - amount, 0)
	print("Joint pain! Current mobility:", mobility)

func add_mobility(amount: float):
	mobility = min(mobility + amount, 100)
	print("Mobility restored! Current mobility:", mobility)


# Stability (shakiness)
func reduce_stability(amount: float):
	stability = min(stability + amount, 100)
	print("You feel shakier. Current Shakiness:", stability)

func add_stability(amount: float):
	stability = max(stability - amount, 0)
	print("You steady yourself. Current Shakiness:", stability)


# Money
func add_money(amount: int):
	money = max(money + amount, 0)
	print("Money gained! Current money:", money)

func reduce_money(amount: int):
	money = max(money - amount, 0)
	print("Money lost! Current money:", money)


# -------------------------
# Check Status
# -------------------------
func is_disabled() -> bool:
	# Example: fully disabled if no fingers OR all senses drop too low
	return fingers == 0 or (vision <= 0 and hearing <= 0 and mobility <= 0)

func print_status():
	print("Player Status → Fingers:", fingers,
		  " Vision:", vision,
		  " Hearing:", hearing,
		  " Mobility:", mobility,
		  " Shakiness:", stability,
		  " Money:", money)
